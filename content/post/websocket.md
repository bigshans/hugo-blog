---
title: 长连接与 Websocket
date: 2019-10-27 23:11:07
tags:
- Websocket
- Node
categories:
- 编程随笔
---

公司想要做一个聊天系统，原本打算上 Websocket ，我例程都写了，老板又不想弄长连接了，认为短连接就符合需求了，无奈。

Websocket 还是值得说一说的，我们是使用 node 开发的。

<!--more-->

## 序

首先，长连接和短连接是相对于 Http 而言的， Http 每发起完成一次请求就会断开 socket 连接，且每次连接的时间较短，所以是短连接，而长连接就是尽可能保持住连接，这种连接的保持有什么用呢？能够让客户端保有状态，让客户端和服务端有更多的交互。

实现长连接的方案有很多种，比如说 Comet、SSE等，这些选择按照需求可以自行选择， Comet 适合旧有浏览器兼容，微信网页版就是用这种，SSE 适合服务器端不关心客户端的情况。 Websockt 相对来说是用于实时性很强、需要不同类型数据传输的场景。

## 库的选择

只考虑两个库：socket.io 和 ws 。

最终我选择的是 ws 。考虑两个因素，第一是 socket.io 低层并不是用 websocket ；第二是， 如果出用 socket.io 要考虑会话保持的问题。而且 socket.io 的效率并没有 ws 高。所以综上考虑，选择 ws 。

## 浏览器 Websocket 和 ws 的差异

由于我只看后端，跟前端对的时候才发现问题。

浏览器的 Websocket 和 ws 提供的 client 是不同的，我一直以为是一样的。

参考 MDN 。浏览器的没有 ping pong，心跳得自己写，重写 message 事件。

[^https://developer.mozilla.org/zh-CN/docs/Web/API/WebSocket]: MDN websocket 条目

