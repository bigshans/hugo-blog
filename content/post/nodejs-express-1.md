---
title: Express 学习(一)
date: 2019-06-27 13:48:27
tags:
- Node
- Express
categories:
- 后端
---

公司后端采用了 nodejs + express 环境，最近在看，现在记录一点笔记。

<!--more-->

## Hello World Example

新建项目，将项目入口设置为 app.js 。然后安装 expressjs ：

```sh
npm install --save express
```

我们在 app.js 里写一点简单的代码。

```js
const express = require('express')
const app = express()
const port = 3000
app.get('/', (request, response) => response.send('<h1>Hello World</h1>'))
app.listen(port, () => console.log(`Example listening on port ${port}!`))
```

运行命令查看结果：

```sh
node app.js
```

在浏览器上打开 `http://127.0.0.1:3000` 就可以看到 Hello World 了。

## Routing

express 的路由还是很简单的。

基本形式就是：

```
app.METHOD(PATH, HANDLER)
```

在这里：

- app 是 express 的实例。
- METHOD 就是方法。
- PATH 就是路径。
- HANDLER 就是回调函数。

### Routing paths

路由路径我们可以使用 `?`、 `+`、 `*`、 `()` 等正则来对路由进行灵活的匹配，也可以直接使用正则对象进行匹配。