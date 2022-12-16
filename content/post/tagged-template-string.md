---
title: "JavaScript 的标签模板字符串"
date: 2022-12-16T10:49:05+08:00
markup: pandoc
draft: false
categories:
- JavaScript
tags:
- JavaScript
---

标签模板是个看起来很 Magic 的语法，写起来像是这样。

```JavaScript
console.log`Hello, World!`;
// Output: ["Hello, World!"]
```

实际上，这里的模板标签被转换成这样的一句调用。

```JavaScript
console.log.call(console, ['Hello, World!']);
```

如果我们有用变量的话，

```JavaScript
const name = 'world';
console.log`Hello, ${name}!`
// Output: [ 'Hello, ', '!' ] world
```

就会被转换成这样一句调用。

```JavaScript
const name = 'world';
console.log.call(console, ['Hello, ', '!'], name);
```

这不代表 V8 确实会这样做，但 ECMAScript 标准是这样规定的。

字符串模板会分为两部分，一部分是无变量的静态字符串，剩下的就是表达式。对应我们看到就是 `['Hello, ', '!']` 和 `name` 部分，前者是一个对象展开，后者是数组展开作为函数剩余的变量。

`console.log` 实际上是表达式，其返回值必须是一个可以调用的函数。 `typeof` 不用考虑，应为他们走的其实是另一套逻辑。

这个可调用的函数，完全体应该是：

```JavaScript
// @param {string[]} strings
// @param {string[]} templates
function tagged(strings, ...templates) {}
```

标签模板的好处是，我们可以省去一些括号，而获得一些更简洁的写法。
