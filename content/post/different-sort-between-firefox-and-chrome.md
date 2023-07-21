---
title: 'sort 在 Chrome 和 Firefox 表现不同'
date: 2022-03-31T10:18:10+08:00
draft: false
tags:
  - Javascript 
  - 前端
categories:
  - 前端
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

```1 0
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

不过实际上除了自己做的特殊情况，顺序是无需考虑的事情：

```javascript
var a = [1, 2, 3, 4];
function cmp(a, b) {
  if (a > b) {
    return -1;
  } else if (a === b) {
    return 0;
  }
  return 1;
}
console.log(a.sort(cmp));
```

这个结果是两边一致的。

遇到那些情况需要你清楚调用顺序，然后规避一下就好了。

---

补遗：

[这个问题](https://stackoverflow.com/questions/68113002/js-sort-different-behaviour-in-firefox-and-chrome)提出了类似的疑问，下面的回答解答了此疑惑。

简单来说， `compareFn` 需要满足比较比较一致性。如果 `a = b` 且 `a = c, b = d` ，那么 `a = d` ，但我上面的代码就不满足比较一致性了，很可能会出现 `a != d` 的情况 ，因此就会出现因为浏览器算法实现差异而出现问题。比如题目中仅仅实现了 `-1` 和 `0` 的情况，缺少 `1` ，这就会导致比较一致性问题的出现。

当然，这实际上是不规范使用 compareFn 的结果。
