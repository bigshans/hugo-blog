---
title: "await 的背后"
date: 2022-12-15T21:49:39+08:00
markup: pandoc
draft: false
categories:
- nodejs
tags:
- nodejs
---

我们一般会认为 `async/await` 是 `Promise` 的语法糖，实际上也没有错。但在 Node 10 的时候，一个 `await` 会产生三个微任务，导致单个 `await` 的性能远不如 `Promise` ，但在 Node 12 时， V8 团队称，其性能已经比一般手动创建处理的 `Promise` 好了。

为什么会这样呢？

我们首先要理解 `async/await` 是如何实现的。一个函数被标记为 `async` ，它会被 V8 标记为 resumable 的，意为可暂停的。 V8 首先会创建一个隐式的 `Promise` ，等到执行到 `await` 时，将函数的 handler 传递给等待执行的 `Promise` ，然后挂起函数。

在 Node 10 时，代码执行大概是这样的。

![](https://v8.dev/_img/fast-async/await-under-the-hood.svg)

我们可以看到， V8 无论何时都会包装一边 v ，以确保 thenable 。在中间， V8 又创建 throwaway ，这个 `Promise` 纯粹是为了符合 ES 标准。 V8 把函数的 handler 传入到了新生成的 `Promise` 的 then 里面。最后挂起整个函数。等到前面的 `Promise` 完成了执行，就会恢复执行隐式的 `Promise` 。

首先，我们至少会多产生两个 `Promise` 和三个微任务。

![](https://v8.dev/_img/fast-async/await-overhead.svg)

为什么呢？一个 `await` 至少会多产生两个 `Promise` ，即 `promise` 和 `throwaway` 。同时一个 `await` 会多产生三个微任务，即执行 `promise` 时的微任务，由 promise 衍生的，用来决定返回值传播的微任务，即 `PromiseReactionJob` ，最后就是下一步执行的函数即 `then()` 或 `catch()` 。

显然，这里存在这许多优化空间。

首先，对于已经是 `Promise` 的 `v` 不必再进行一次封装，这是第一步。

![](https://v8.dev/_img/fast-async/await-code-comparison.svg)

当我们对 `Promise` 进行 `await` 时，只会增加一个 `Promise` ，和一个 `throwaway` 。

但 `throwaway` 我们完全不需要，只是 ES 强塞进来的。后面， ES 更改了这以规范，使得 `throwaway` 不再是必须的。

最终我们得到了现在的优化。

![](https://v8.dev/_img/fast-async/node-10-vs-node-12.svg)

## 关于 Bluebird

以前还有关于 Bluebird 还有 V8 哪个更优的争论，但现在， Bluebird 官方更推荐在最新版的 Node 里使用原生 `Promise` 。 `Promise` 经过几次优化，并历经几年考验之后，完全不输于 Bluebird 。除非你有特殊情况，比如老版本的 Node ，等等。

---

参考： [Faster async functions and promises](https://v8.dev/blog/fast-async)
