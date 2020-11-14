---
title: Express 源码阅读（一）
date: 2019-12-01 14:55:32
tags:
- Express
- Node
categories:
- Node
---

我们写一个简单的程序。

```js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.end('<h1>Hello</h1>');
});

app.listen(3000, () => console.log('Connected!'));
```

我们对这段代码进行 Debug 。

<!--more-->

## `createApplication()`

我们进入 express 源码，就会发现如下源码：

```js
module.exports = require('./lib/express');
```

原来是 require 了 lib/express 的源码，进入源码，我们便见到如下语句：

```js
exports = module.exports = createApplication;
```

我们调用的 `express` 本质上是调用了 `createApplication` 方法。

我们进入到 `createApplication` 看看。

```js
function createApplication() {
  var app = function(req, res, next) {
    app.handle(req, res, next);
  };

  mixin(app, EventEmitter.prototype, false);
  mixin(app, proto, false);

  // expose the prototype that will get set on requests
  app.request = Object.create(req, {
    app: { configurable: true, enumerable: true, writable: true, value: app }
  })

  // expose the prototype that will get set on responses
  app.response = Object.create(res, {
    app: { configurable: true, enumerable: true, writable: true, value: app }
  })

  app.init();
  return app;
}
```

`app` 本质上是一个 handle 函数，有三个变量，`req` 是 `request`，`res` 是 `response`，next 是回调函数。

`app` 继承了两个类，一个是 `EventEmitter` ，另一个 `proto` ，`proto` 是 `require` 了 `./applicaition` 的核心。

`app` 还有两个属性，`request` 和 `response` ，分别是 `http.InComingMessage` 和 `http.ServerResponse` 的原型，`request` 和 `response`，最终会作为 `http.createServer` 的第一参数和第二参数。

最后是 `app.init()` ，进行默认的配置，增加默认的中间件，构建 route 的反射方法。

## `app.init()`

进入 `app.init()` 。

```js
app.init = function init() {
  this.cache = {};
  this.engines = {};
  this.settings = {};

  this.defaultConfiguration();
};
```

那么大头就在 `this.defaultConfiguration()` 。我们一点点的看。

```js
  this.enable('x-powered-by');
  this.set('etag', 'weak');
  this.set('env', env);
  this.set('query parser', 'extended');
  this.set('subdomain offset', 2);
  this.set('trust proxy', false);
```

`x-powered-by` 是表示框架语言的。`etag` 是缓存，`query parser` 是解析请求参数的，`subdomain offset` 解析子域名， `trust proxy` 不采用代理托管模式。