---
title: "函数柯里化"
date: 2023-10-14T11:52:10+08:00
markup: pandoc
draft: false
categories:
- JavaScript
tags:
- JavaScript
---

函数柯里化是一种可以将函数转换为另一个函数的技巧，通常是用来减少函数参数的。

用一个简单的例子以表示这种使用:

```javascript
function sum(a, b) {
  return a + b;
}

const add1 = curry((b) => sum(1, b));
console.log(add1(10));
```

这里我们实际上固定了 `sum` 的参数，但这里我只被允许加上 1 ，我们可以更灵活一些。

```javascript
function sum(a, b) {
  return a + b;
}

const _sum = curry(sum);
const add1 = _sum(1);
const add2 = _sum(2);

console.log(add1(10));
console.log(add2(10));
```

通过 `curry()` ，我们将 `sum` 包裹成一个可以生成函数的生成器。当传入的参数不足 `sum` 自身的形参数时，就返回柯里化之后的函数，否则就返回最终的结果。那么我们应该如何实现这个 `curry` 方法呢？

我们首先需要知道传入函数 `fx` 的形参数，这就要求传入函数的形参数是固定的。我们输入一个函数并输出一个函数，输出的函数接收剩余的函数参数，当总的形参数大于等于传入函数 `fx` 的形参数时，我们直接执行该函数。

```javascript
function curry(fx) {
  // 获取实际形参数
  const pLen = fx.length;
  const fn1 = (...args) => {
    if (args.length >= pLen) {
      return fx(...args)
    }
    const fn2 = (...args2) => fn1(...args, ...args2)
    return fn2;
  };
  return fn1;
}
```
