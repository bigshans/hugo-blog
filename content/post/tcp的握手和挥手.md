---
title: "TCP 的握手和挥手"
date: 2023-02-23T10:46:04+08:00
markup: pandoc
draft: false
categories:
- 网络
tags:
- Node
- 网络
- TCP
---

TCP 的握手和挥手想必很多人都已经很熟悉了，“三次握手”和“四次挥手”在面试的时候几乎都是八股文了。光是背这个的话，着实了无趣味。我们可以通过 `tcpdump` 和 wireshark 来看整个过程。

## 获取包

我们首先写一个 client-server 的程序。我们用 Node 来简单写一个。

```javascript
const net = require('net');
const server = net.createServer(function (socket) {
    console.log("客户端已经连接");
    socket.setEncoding('utf8');
    socket.on('data', function (data) {
        console.log("已接收客户端发送的数据:%s", data);
        socket.write('服务器:' + data);
    })
    socket.on('error', function (err) {
        console.log('与客户端通信过程中发生了错误，错误编码为%s', err.code);
        socket.destroy();
    });
    socket.on('end', function (err) {
        console.log('客户端已经关闭连接');
        socket.destroy();
    });
    socket.on('close', function (hasError) {
        console.log(hasError ? '异常关闭' : '正常关闭');
    });
});
server.listen(3001, function () {
    let client = new net.Socket();
    client.setEncoding('utf8');
    client.connect(3001, '127.0.0.1', function () {
        console.log('客户端已连接');
        // client.write('hello');
        setTimeout(function () {
            // client.end('byebye');
            client.destroy();
        }, 5000);
    });
    client.on('data', function (data) {
        console.log('已经接收到客户端发过来的数据:%s', data);
    });
    client.on('error', function (err) {
        console.log('与服务器通信过程中发生了错误，错误编码为%s', err.code);
        client.destroy();
    });

});
```

然后我们用 `tcpdump` 来抓包，当然我们也可以用 wireshark 来抓包分析，之所以用 `tcpdump` 主要是为了把数据固定下来方便查看。

```shell
sudo tcpdump -n -v -i any tcp port 3001 -w ./file.cap
```

运行 `tcpdump` 需要 root 权限。

之后我们用 wireshark 来进行分析。

![](https://raw.githubusercontent.com/bigshans/pictures/master/img/%E5%9B%BE%E7%89%87.png)

上面三个是三次握手，下面三个是三次挥手。

## 三次握手

三次握手的前两条呈现灰色，是因为前两条不能携带数据，下面握手也是同样的意思。

`[]` 代表启用的 Flag 。

第一条我们看到 Flag 为 `[SYN]` ，客户端代表发起连接。现在的 Seq 为 0 ，但这个不是真实的 Seq 号，代表相对的 Seq 号，此时真实的 Seq 号为 `2473815869` 。

第二条是服务端向客户端回传确认连接，此时的 Flag 为 `[SYN, ACK]` 。此时的真实 Seq 号为 `903756351` ，而 Ack 号为 `2473815870` ，即上一条的 Seq 号 + 1 。

第三条是客户端向服务端回传的确认报文，此时的 Flag 为 `[ACK]` 。此时的真实 Seq 号为 `2473815870` ， Ack 号为 `903756352` 。Seq 号为上一条的 Ack 号，而 Ack 号为上一条的 Seq 号 + 1 。

需要注意的是，我们整个过程中并没有传输数据，如果你传输数据的话，你会发现最后一条会携带数据， Flag 可能为 `[PSH, ACK]` 。TCP 允许握手的最后一条传输数据，这是符合要求的。

## 三次挥手

一般面试会讲四次挥手，但实际上，由于延迟确认机制默认启用，你在 wireshark 里看到的都是三次挥手。

TCP 的延迟确认策略是：

1. 当有响应数据要发送时，ACK 会随着响应数据一起立刻发送给对方。
2. 当没有响应数据要发送时，ACK 将会延迟一段时间，以等待是否有响应数据可以一起发送。
3. 如果在延迟等待发送 ACK 期间，对方的第二个数据报文又到达了，这时就会立刻发送 ACK 。

第一条由客户端向服务端发送，Flag 为 `[FIN, ACK]` ，此时的 Seq 号为 `903756352` ， Ack 号为 `2473815870` 。这里的 Ack 为确认之前的数据，真正跟关闭相关的是 Seq 和 `FIN` 。

第二条由服务端向客户端发送，Flag 为 `[FIN, ACK]` ，此时的 Seq 号 `903756352` ， Ack 号为 `2473815871` 。 Ack 号为上一条的 Seq 号 + 1 。在原先的四次挥手里，这里是要拆成两条的，一条发送 Ack 号，并置 `ACK` 为 1 ，另一条发送 `FIN` ，发送 Seq 号。相当于收到的瞬间，确认并且关闭了连接。

第三条由户端向服务端发送，Flag 为 `[ACK]` ，此时的 Ack 号为 `903756353` ，即上一条的 Seq 号 + 1 。
