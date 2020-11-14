---
title: nodejs 的 import
date: 2018-08-26 20:29:41
categories:
- nodejs
tags:
- nodejs
- javascript
- es6
---

nodejs 对 es 6 的支持目前并不完全，直接使用 import 不行，exports 也不行，可以用 babel 之类的编译， nodejs 10 可以尝试加上 flag ： --experimental-modules。
`````` shell
node --experimental-modules my-app.mjs
``````
<!--more-->
