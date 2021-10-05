---
title: RxJs 初探 —— 基于事件为中心的编程
date: 2021-10-02T22:19:12+08:00
draft: false
tags:
- rxjs
- javascript
categories:
- javascript
---

这是我学习 RxJs 的一些整理 ，其实 RxJs 是个 FRP 库，理解它应该从 FRP 来落脚，但一开始就讲函数式就太难了，而且放在初学者面前未免喧宾夺主了，所以我从事件开始讲，把函数式放到一边，然而这个其实也是 FRP 的重点——事件建模。

全文内容有点长，可以顺着思路慢慢看，结尾比较匆忙，看不看随意。另外代码基于 RxJs 6 的，因此会与网上的一些版本有着明显的区别，建议阅读英文文档，中文文档旧了。

---

RxJs 是以事件为核心的库，正如它官网所说的那样：

> RxJS is a library for composing asynchronous and event-based programs by using observable sequences.

初学者学习的时候很多会被函数式给唬住，而网上的诸多教程基本上也是对函数式大吹特吹，而不讲 RxJs 实际要处理的核心问题：事件。如果要我为  RxJs 的风格命名的话，我会命名为“面向事件编程”（OEP）（实际上不是，方便法门而已）。我接下来的叙述也会按照这个理解去处理。

## RxJs 的基本方法

RxJs 基本概念很多，像什么 `Observable` 啦， `Observer` 啦， `Subject` 啦，但这些实际上都是处理工具， RxJs 的处理方法主要有三个：观察者模式、迭代器模式和函数式编程。

那么 RxJs 如何将这三个方法应用于事件的管理上的呢？

首先，是观察者模式和迭代器模式。观察者模式用于注册事件并管理事件，而迭代模式则用于触发事件，二者统一使用。前者是事件与事件之间的管理，后者同一事件发生顺序的管理。由此，二者构成了对事件不同维度上的管理。

然后，是函数式编程。对于数据的管理即是对于事件发生的管理， RxJs  利用了函数式编程无副作用的特点并结合链式调用去流动数据，并将函数作为值传递，做了高层次的抽象。而对于 RxJs  初学者来说，函数式部分其实是最难的，初学的时候应该先跳过函数式，当你明白用非函数式如何实现之后再去看函数式实现之后，为什么要用函数式这个问题就豁然开朗了。而且，你不要总想着函数式，这个是皮。

## `Observable`

`Observable` 对象的使用体现了 RxJs 最为基础的方法。 `Observable` 意为可订阅的，这里表示该对象可以被订阅。

``` javascript
const { Observable } from 'rxjs';

const observable = new Observable(subscriber => {
  // 迭代控制同事件的发生
  subscriber.next(1);
  subscriber.next(2);
  subscriber.next(3);
  setTimeout(() => {
    subscriber.next(4);
    subscriber.complete();
  }, 1000);
});
 
console.log('just before subscribe');
// 事件入口控制
observable.subscribe({
  next(x) { console.log('got value ' + x); }, // 事件处理
  error(err) { console.error('something wrong occurred: ' + err); },
  complete() { console.log('done'); }
});
console.log('just after subscribe');
```

`Observable` 对象生成了一个事件的入口，在 `subscribe` 的时候，我们的事件便在事件中心注册了。而 `next` 是迭代器， `next` 代表下一个值，它控制了同一个事件触发的时序， `complete` 代表时序的结束，不再被触发。这里就是观察者和迭代器模式的结合，我们还没有到要讲函数式的时候。

除此之外，我们还可以终止事件的发生。

``` javascript
const { from } = require('rxjs');
const observable = from([10, 20, 30]);
const subscription = observable.subscribe(x => console.log(x));
// Later:
subscription.unsubscribe();
```

我们也可以在创建 `Observable` 时定义好 `unsubscribe` ，来做一些扫尾工作。

``` javascript
const observable = new Observable(function subscribe(subscriber) {
  // Keep track of the interval resource
  const intervalId = setInterval(() => {
    subscriber.next('hi');
  }, 1000);

  // Provide a way of canceling and disposing the interval resource
  return function unsubscribe() {
    clearInterval(intervalId);
  };
});
```

## `Observer`

`Observer` 是什么？它意为观察者，就是观察者模式中的消费者，其实也就对应我们的一个事件。

``` javascript
observable.subscribe(x => console.log('Observer got a next value: ' + x));
```

`Observer` 可以是一个简单的函数，或者是像下面这样的结构：

``` javascript
const observer = {
  next: x => console.log('Observer got a next value: ' + x),
  error: err => console.error('Observer got an error: ' + err),
  complete: () => console.log('Observer got a complete notification'),
};
observable.subscribe(observer);
```

其中 `next` 是必须得有的，不然没法迭代。

## `Subscription`

`Subscription` 就是订阅对象，是在调用 `subscribe` 后返回的。它只有一个无参的方法 `unsubscribe()` ，作用是取消订阅。订阅的取消显然是只有一次的。

``` javascript
import { interval } from 'rxjs';

const observable = interval(1000);
const subscription = observable.subscribe(x => console.log(x));
subscription.unsubscribe();
```

这里对象化订阅最大的好处就是方便管理订阅。

## `Operators`

`Operators` 一般翻译为操作符，是用处最大的部分，借助操作符，我们可以很方便地写出函数式的 RxJs 。换句话说，这里是 RxJs 函数式编程部分，用以更好的抽象 RxJs 的实现。

操作符分文两类，一类是管道式的操作符（Pipeable Operators），一类是创建式的运算符（Creation Operators）。两类运算符都是在对数据流下手，管道式针修改流中数据从而生成了新的 `Observable` ，而创建式又分为两种——创建新数据和创建新的 `Observable` 。

我们首先讲讲管道式的操作符。管道式操作符只有一个 `pipe()` ，且是在 `Observable` 的一个方法，这个方法传入至少一个只有一个参数的函数， `pipe()` 随后会传出一个新的 `Observable` 。为什么会传出新的 `Observable` 呢？是为了保持数据的不可变性。

``` javascript
const { of } = require('rxjs');
const { map } = require('rxjs/operators');

const ob = of(1, 2, 3)
const ob1 = ob.pipe(map(x => x * 2));
const ob2 = ob.pipe(map(x => x + 1));

ob1.subscribe(v => console.log('ob1 ' + v));
ob2.subscribe(v => console.log('ob2 ' + v));
```

这样 `ob1` 和 `ob2` 引用的都是 `ob` 的数据，二者不互相影响，这就是函数式的好处。

然后是创建式，分为两类，一类是创建 `Observable` 的，一类是创建数据的。

像上面代码的例子， `of()` 是创建了一个新的 `Observable` ， `map` 则根据输入的数据创建了一个新的数据。这里仍然要注意副作用的问题，所以不要有副作用。

除了 `of()` 之外， `interval()` 也是个常见的运算符。

``` javascript
import { interval } from 'rxjs';

const observable = interval(1000 /* number of milliseconds */);
```

当然，运算的内容特别多，也不需要全部都记住，自己那里写得麻烦再去找找有没有好用的运算简化，这样就行了。

## 高阶 `Observable`

我们之前讲了 `Observable` 对象，在我们学习了操作符之后，我们更深入地学习一下高价 `Observable` 。高阶听上去很高级，但实际上，我们要说的高阶就是多个 `Observable` 对象如何组合成一个 `Observable` 对象。

这里得用到创建式操作符中的合并操作符（join operators），它会处理多个 `Observable` 并返回一个新的 `Observable` 。

这些操作符有：

- `concatAll()`
- `mergeAll()`
- `switchAll()`
- `exhaustAll()`

我们一个个来讲。

### `concatAll()`

`concatAll()` 从它的名字上就知道它是将所有的 `Observable` 线性连接成一个数据的代码。

```javascript
const { of } = require('rxjs');
const { map, concatAll } = require('rxjs/operators');

of(1, 2, {a : 1})
  .pipe(map(e => of(e)))
  .pipe(concatAll())
  .subscribe(e => console.log(e));
```

### `mergeAll()`

`mergeAll()` 是将高阶 `Observable` 打平合并，合成一个一阶的 `Observable` 。它可以传入一个参数，就是同一事件最大的并发数，默认是 `Infinity` 。

```javascript
const { map, mergeAll, take } = require('rxjs/operators');
const { of } = require('rxjs');

const myPromise = val =>
  new Promise(resolve => setTimeout(() => resolve(`Result: ${val}`), 2000));
// 发出 1,2,3
const source = of(1, 2, 3);

const example = source.pipe(
  // 将每个值映射成 promise
  map(val => myPromise(val)),
  // 发出 source 的结果
  mergeAll()
);

const subscribe = example.subscribe(val => console.log(val, Date.now()));
```

运行上述代码，你会发现除了第一个事件不同之外，其他事件的发生都是同一时间的，这也是它与 `concatAll()` 不一样的地方。

### `switchAll`

`switchAll()`  的作用与 `mergeAll()` 的作用类似，都是将高阶 `Observable` 转换为一阶 `Observable` 。

那么，它与 `mergeAll()` 有什么不同呢？ `switchAll()` 会处理最新的订阅，每当有新的订阅来的时候，就会退订旧的订阅。它们在并发冲突时的表现不同。

``` javascript
const { interval } = require('rxjs');
const { map, take, switchAll } = require('rxjs/operators');

const a = interval(500).pipe(map((v) => 'a' + v), take(3));
const b = interval(500).pipe(map((v) => 'b' + v), take(3));
const higherOrderObservable = interval(1000).pipe(take(2), map(i => [a, b][i]));

higherOrderObservable.pipe(switchAll()).subscribe((value) => console.log(value));
/*
output:
a0
a1
b0
b1
*/
```

``` javascript
const { interval } = require('rxjs');
const { map, take, mergeAll } = require('rxjs/operators');

const a = interval(500).pipe(map((v) => 'a' + v), take(3));
const b = interval(500).pipe(map((v) => 'b' + v), take(3));
const higherOrderObservable = interval(1000).pipe(take(2), map(i => [a, b][i]));

higherOrderObservable.pipe(mergeAll()).subscribe((value) => console.log(value));
/*
output:
a0
a1
b0
a2
b1
b2
*/
```

因为有并发，所以输出是不唯一的，这一点在 `switchAll()` 上面体现得尤为明显，大家可以自己想想为什么会这么输出。

### `exhaustAll()`

`exhaustAll()` ，在前一个内部观测值尚未完成时，通过放弃内部观测值，将一个高阶观测值转换为一阶观测值。`exhaust` 意为用尽、耗尽，这里指代这样的行为，即观察某一个订阅完全耗尽之后再进行下一个订阅的观察，期间的所有订阅都忽视掉。

它与其他操作符的作用区别还是挺明显的。

``` javascript
const { of, interval } = require('rxjs');
const { map, take, exhaustAll } = require('rxjs/operators');

of(1, 2, 3)
  .pipe(map(ev => interval(100).pipe(take(5))))
  .pipe(exhaustAll())
  .subscribe(x => console.log(x))

/*
0
1
2
3
4
*/
```


除此之外，还有 `concatMap()` 、 `mergeMap()` 、 `switchMap()` 和 `exhaustMap()`  ，它们实际上是对应操作符与 `map()` 的结合，在此就不赘述了。

## `Subject`

`Subject` 对象是什么呢？官方是这么描述的：

> A Subject is like an Observable, but can multicast to many Observers. Subjects are like EventEmitters: they maintain a registry of many listeners.

挺玄乎的。 `subject` 这个词在这里并不好翻译，这里翻译成主体。主体意味着两层意思，一是它是主动的，强调它的主动性，二是它是被动的，强调它的中介性。综合起来更像是 `agent` ，这里 `Subject` 对象也更像是一个代理层。

首先， `Subject` 可以像 `Observable` 使用。

``` javascript
const { Subject } = require('rxjs');

const subject = new Subject();

subject.subscribe(v => console.log('Observer A: ' + v));
subject.subscribe(v => console.log('Observer B: ' + v));

subject.next(1);
subject.next(2);
```

也可以像 `Observer` 一样被一个 `Observable` 接收。

``` javascript
const { Subject, from } = require('rxjs');

const subject = new Subject();

subject.subscribe(v => console.log('Observer A: ' + v));
subject.subscribe(v => console.log('Observer B: ' + v));

from([1, 2, 3])
  .subscribe(subject)
```

### 多播的 `Observable`

借助 `Subject` ，我们只需要调动一次 `subscribe()` ，就可以同时广播到两个 `Observer` 上。

我们看看下面的代码：

``` javascript
const { Observable } = require('rxjs');

const obs = new Observable(observer => {
  let counter = 0;
  const handler = setInterval(() => {
    console.log("producer: " + counter);
    observer.next(counter);
    counter++;
  }, 1000);
  return () => clearInterval(handler);
});

obs.subscribe((v) => console.log('subscription 1: ' + v));
obs.subscribe((v) => console.log('subscription 2: ' + v));
/*
output:
producer: 0
subscription 1: 0
producer: 0
subscription 2: 0
producer: 1
subscription 1: 1
producer: 1
subscription 2: 1
producer: 2
subscription 1: 2
producer: 2
subscription 2: 2
producer: 3
subscription 1: 3
producer: 3
subscription 2: 3
producer: 4
subscription 1: 4
producer: 4
subscription 2: 4
*/
```

你会发现每次 subscription 被调用前， producer 都被调用了一下，这不是我们期望的，因为 producer 被重复调用了，并生产了一样的值，这是无意义且多余的动作。于是我们用 `Subject` 进行改造。

``` javascript
const { Observable, Subject } = require('rxjs');

const obs = new Observable(observer => {
  let counter = 0;
  const handler = setInterval(() => {
    console.log("producer: " + counter);
    observer.next(counter);
    counter++;
  }, 1000);
  return () => clearInterval(handler);
});

const shared = new Subject();

shared.subscribe((v) => console.log('subscription 1: ' + v));
shared.subscribe((v) => console.log('subscription 2: ' + v));

obs.subscribe(shared);
/*
output:
producer: 0
subscription 1: 0
subscription 2: 0
producer: 1
subscription 1: 1
subscription 2: 1
producer: 2
subscription 1: 2
subscription 2: 2
producer: 3
subscription 1: 3
subscription 2: 3
producer: 4
subscription 1: 4
subscription 2: 4
*/
```

可以了，现在我们达到了我们想要的结果，但我们想要更进一步。

``` javascript
const { Observable, Subject, connectable } = require('rxjs');

const obs = new Observable(observer => {
  let counter = 0;
  const handler = setInterval(() => {
    console.log("producer: " + counter);
    observer.next(counter);
    counter++;
  }, 1000);
  return () => clearInterval(handler);
});

const shared = connectable(obs, {
  connector: () => new Subject(),
  resetOnDisconnect: false
});

shared.subscribe((v) => console.log('subscription 1: ' + v));
shared.subscribe((v) => console.log('subscription 2: ' + v));

shared.connect();
```

这里我们使用 `connectable` 将 `obs` 变成了一个 `ConnetableObservable` ，赋予了 `obs` 的多播的能力。其中， `Subject` 是作为二者桥接的桥梁而存在的。这里的代码与上面的代码实际上就是等效的。

#### 多播订阅的管理

在多播里面，我们通常希望第一个订阅到达时进行 `connect()` ，最后一个离开时做 `unsubscribe()` ，这样能方便我们管理订阅。

``` javascript
const { interval, Observable, Subject, connectable } = require('rxjs');

const multicasted = connectable(interval(500), { connector: () => new Subject(), resetOnDisconnect: false });
const subscription = multicasted.subscribe(v => console.log('observer A: ' + v));

const subscriptionConnect = multicasted.connect();
let subscription2;

setTimeout(() => {
  subscription2 = multicasted.subscribe(v => console.log('observer B: ' + v));
}, 600);

setTimeout(() => {
  subscription.unsubscribe();
}, 1200);


setTimeout(() => {
  subscription2.unsubscribe();
  subscriptionConnect.unsubscribe();
}, 2000);
```

然后你会发现这个代码非常麻烦。

``` javascript
const { interval, Observable, Subject, connectable } = require("rxjs");
const { share } = require("rxjs/operators");

const multicasted = interval(500).pipe(
  share({ connector: () => new Subject(), resetOnDisconnect: false })
);
const subscription = multicasted.subscribe((v) =>
  console.log("observer A: " + v)
);

let subscription2;

setTimeout(() => {
  subscription2 = multicasted.subscribe((v) => console.log("observer B: " + v));
}, 600);

setTimeout(() => {
  subscription.unsubscribe();
}, 1200);

setTimeout(() => {
  subscription2.unsubscribe();
}, 2000);
```

这样我们就不需要自己管理 `connect` 了，当所有订阅取消之后，连接也会被断开。

这其实就是操作符一个很重要的作用，简化代码。

### `BehaviorSubject`

`BehaviorSubject` 是 `Subject` 的变体，它在原有 `Subject` 的基础上多了个当前值的概念。看代码的应该就能理解了。

```javascript
const { BehaviorSubject } = require('rxjs');

const subject = new BehaviorSubject(0); // 初始值

subject.subscribe(v => console.log('observerA: ' + v));

subject.next(1);
subject.next(2);

subject.subscribe(v => console.log('observerB: ' + v));

subject.next(3);

/*
output:
observerA: 0
observerA: 1
observerA: 2
observerB: 2
observerA: 3
observerB: 3
*/
```

### `ReplaySubject`

`ReplaySubject` 与 `BehaviorSubject` 还是比较像的， `ReplaySubject` 是一个带有缓存的 `Subject` ，当缓存为为 0 或 1 时，它的表现与 `BehaviorSubject` 基本上一样了。

``` javascript
const { ReplaySubject } = require('rxjs');

const subject = new ReplaySubject(3); // buffer 大小

subject.subscribe(v => console.log('observerA: ' + v));

subject.next(1);
subject.next(2);
subject.next(3);
subject.next(4);

subject.subscribe(v => console.log('observerB: ' + v));

subject.next(5);
/*
output:
observerA: 1
observerA: 2
observerA: 3
observerA: 4
observerB: 2
observerB: 3
observerB: 4
observerA: 5
observerB: 5
*/
```

### `AsyncSubject`

`AsyncSubject` 在多个值返回时，会取最后一个值。

``` javascript
const { AsyncSubject } = require('rxjs');
const subject = new AsyncSubject();
 
subject.subscribe({
  next: (v) => console.log(`observerA: ${v}`)
});
 
subject.next(1);
subject.next(2);
subject.next(3);
subject.next(4);
 
subject.subscribe({
  next: (v) => console.log(`observerB: ${v}`)
});
 
subject.next(5);
subject.complete();
 
// Logs:
// observerA: 5
// observerB: 5
```

看起来好像没什么用，不过可以举一个场景，比如在多个 http 请求时，重复获取时可以保证只获取最后一个。

## `Scheduler`

`Scheduler` ，意为调度器，它控制了订阅数据的发送。

``` javascript
const { Observable, asyncScheduler } = require('rxjs');
const { observeOn } = require('rxjs/operators');
 
const observable = new Observable((observer) => {
  observer.next(1);
  observer.next(2);
  observer.next(3);
  observer.complete();
}).pipe(
  observeOn(asyncScheduler)
);
 
console.log('just before subscribe');
observable.subscribe({
  next(x) {
    console.log('got value ' + x)
  },
  error(err) {
    console.error('something wrong occurred: ' + err);
  },
  complete() {
     console.log('done');
  }
});
console.log('just after subscribe');
// Logs:
// just before subscribe
// just after subscribe
// got value 1
// got value 2
// got value 3
// done
```

比如说上面使用了 `asyncScheduler` ，使得数据数据被异步发送，事件也被异步触发。

### 调度器类别

- `null`，默认的调度，即同步调度。
- `queueScheduler`，在当前事件帧上的队列调度。
- `asapScheduler`，微任务调度。
- `asyncScheduler`，异步调度，使用 `setInterval()` 。
- `animationFrameScheduler`，在下一次浏览器内容绘制时调度。

### 更多的内容

......

## 结语

这篇文章断断续续写了好几天，虽然是有参考官方文档的，但是呢，官方也有些东西也没讲清楚。我来来回回看了几次，大概抓住了一个点，然后顺着讲了下去。有些内容根本没有讲完，比如说调度器部分，再比如自定义操作符，有兴趣的自己可以看看，即使没看也暂时不影响。写完就觉得非常累，但也非常值，终于把 RxJs 看进去了。希望你也能顺着文章的轨迹，进入 RxJs 的大门。
