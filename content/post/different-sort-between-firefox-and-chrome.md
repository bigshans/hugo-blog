---
title: 'sort 在 Chrome 和 Firefox 表现不同'
date: 2022-03-31T10:18:10+08:00
draft: false
tags:
  - javascript
categories:
  - javascript
---

首先，这个区别不算 BUG ，因为标准并没有规定该怎么排，但这个细微区别在实现一些特殊需求时需要被注意到。

注意下面一段代码：

```javascript
var a = [1, 1, 1, 1, 1];
a = a.map((k, i) => ({ a: k, i: i }));
function cmp(a, b) {
  console.log(a.index, b.index);
  return a.a - b.a;
}
a.sort(cmp);
```

Firefox 的结果：

```
0 1
1 2
2 3
3 4
```

Chrome 的结果：

```
1 0
2 1
3 2
4 3
```

可以看到， Firefox 调用应该是 `cmp(a[n], a[n + 1])` ， Chrome 则是 `cmp(a[n + 1], a[n])` 。当你不关心这个顺序时，这个区别是不影响的，虽然调用顺序不同，但就正常情况下是一致，不过当你这么写就需要关心了。

```javascript
var a = [1, 1, 1, 1, 7];
a = a.map((k, i) => ({ a: k, i: i === a.length - 1 ? undefined : i + 1 }));
function cmp(a, b) {
  console.log(a.i, b.i);
  return b.i ? b.a - a.a : 0;
}
console.log(JSON.stringify(a.sort(cmp)));
```

Firefox 的结果是：

```
[{"a":1,"i":1},{"a":1,"i":2},{"a":1,"i":3},{"a":1,"i":4},{"a":7}]
```

Chrome 的结果是：

```
[{"a":7},{"a":1,"i":1},{"a":1,"i":2},{"a":1,"i":3},{"a":1,"i":4}]
```

7 排前面了。

遇到这些情况需要你清楚调用顺序，然后规避一下就好了。
