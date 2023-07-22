---
title: "用 node 实现一个简单的 http 代理"
date: 2022-12-12T22:52:19+08:00
lastmod: 2022-12-15T03:59:33Z
markup: pandoc
draft: false
categories:
- Node
tags:
- Node
- HTTP 代理实现
- 网络
---

http 代理可分为两种，一种是普通的代理，作为中间人传递两边的信息；另一种则是隧道的方式。

## 普通代理

```javascript
const http = require('http');
const url = require('url');

function request(cReq, cRes) {
  const u = url.parse(cReq.url);
  const options = {
    host: u.hostname,
    port: u.port || 80,
    path: u.path,
    method: cReq.method,
    headers: cReq.headers,
  };
  const pReq = http.request(options, (pRes) => {
    cRes.writeHead(pRes.statusCode, pRes.headers);
    pRes.pipe(cRes);
  }).on('error', (e) => {
    console.error(e);
    cRes.end();
  });
  cReq.pipe(pReq);
}

http.createServer().on('request', request).listen(8888, '0.0.0.0');
```

以上代码简单挑明了一个 http 代理的基本原理，但是还不能趋于实用。它只能用于代理 http 网站，由于 https 是基于 SSL/TSL 的，在传输层上实现，所以单单进行应用层代理无法正确处理 https 网站。

代码上可以注意的是，由于 IncomingMessage 和 OutgoingMessage 本质上是继承自 Stream 的，所以可以使用管道。同时，可以直接往 `createServer()` 里直接投入回调函数，本质上与调用 `on('request', request)` 是一样的。

我们可以用 `curl` 进行一下测试：

```shell
curl -x http://0.0.0.0:8888 http://baidu.com
```

返回给我们一段跳转到 https 页面的代码。

以上代码无法对 https 网站进行代理，连接会被直接组织。这时候我们就需要用到隧道。

## 带隧道的 http 代理

我们在之前代码的基础上进行改造。想要建立隧道，需要在 `CONNECTING` 时做一个 connect 代理。

```javascript
const http = require('http');
const net = require('net');
const url = require('url');

function request(cReq, cRes) {
  const u = url.parse(cReq.url);
  const options = {
    host: u.hostname,
    port: u.port || 80,
    path: u.path,
    method: cReq.method,
    headers: cReq.headers,
  };
  const pReq = http.request(options, (pRes) => {
    cRes.writeHead(pRes.statusCode, pRes.headers);
    pRes.pipe(cRes);
  }).on('error', (e) => {
    console.error(e);
    cRes.end();
  });
  cReq.pipe(pReq);
}

function connect(cReq, cSock) {
  const u = url.parse('http://' + cReq.url);
  const pSock = net.connect(u.port, u.hostname, () => {
    cSock.write('HTTP/1.1 200 Connection Established\r\n\r\n');
    pSock.pipe(cSock);
  }).on('error', (e) => {
    console.log(e);
    cSock.end();
  });
  cSock.pipe(pSock);
}

http.createServer()
  .on('connect', connect)
  .on('request', request)
  .listen(8888, '0.0.0.0');
```

这时候我们走代理就会发现很正常了。

```shell
curl -x http://0.0.0.0:8888 https://baidu.com
```

## 反向代理

学会了用 node 实现一个简单的正向代理，那么我们同样可以实现一个简单的反代。

```javascript
const http = require('http');
const url = require('url');
const net = require('net');

function request(cReq, cRes) {
  const u = url.parse(cReq.url);
  const options = {
    hostname: u.hostname ?? "127.0.0.1",
    port: u.hostname == null ? 3000 : u.port,
    path: u.path,
    method: cReq.method,
    headers: cReq.headers,
  };
  console.log(options);
  const pReq = http.request(options, (pRes) => {
    cRes.writeHead(200, pRes.statusCode);
    pRes.pipe(cRes);
  }).on('error', (e) => {
    console.error(e);
    cRes.end();
  });
  cReq.pipe(pReq);
}

function connect(cReq, cSock) {
  const u = url.parse('http://' + cReq.url);
  const port = u.hostname == null ? 3000 : u.port;
  const pSock = net.connect(port, u.hostname ?? "127.0.0.1", () => {
    cSock.write('HTTP/1.1 200 Connection established\r\n\r\n');
    pSock.pipe(cSock);
  }).on('error', (e) => {
    console.error(e);
    cSock.end();
  });
  cSock.pipe(pSock);
}

http.createServer()
  .on('connect', connect)
  .on('request', request)
  .listen(80);
```

我们用 `curl` 测试一下：

```shell
curl http://0.0.0.0
```

80 端口需要 root 权限才能启动。同时，直接访问本地， `hostname` 会直接为 `null` ，这里我们需要一些额外的修正，其余的并不是很困难。

---


参考：[HTTP 代理原理及实现 ](https://juejin.cn/post/6998351770871152653)
