---
title: 为什么 overflow 能够清除 float
date: 2021-11-07T17:27:40+08:00
draft: false
tags:
- css
categories:
- css
---

有些学问还是自己研究最为靠谱，像是 `overflow` 为什么能清 `float` ，都知道是 BFC ，但是为什么呢？因为在文档流中，普通的 `div` 其实也是 `BFC` ，所以，理论上添加 `overflow` 为非 `visible` 的时候，它也仍然是 BFC 啊？所以，问题在哪里呢？

我个人是在 [StackOverflow](https://stackoverflow.com/questions/6196725/how-does-the-css-block-formatting-context-work) 上找到了我想要的。

主要是文档下面的一段内容：

> Floats, absolutely positioned elements, block containers (such as inline-blocks, table-cells, and table-captions) that are not block boxes, and block boxes with 'overflow' other than 'visible' (except when that value has been propagated to the viewport) establish new block formatting contexts for their contents.

简单来说，就是当我们设置 `div` 为 `float` 、 绝对定位元素、块级容器等非块盒型，或块级盒型的 `overflow` 为除 `visible` 以外的值时，会为盒子创建新的上下文。而关于这个新的上下文：

> In a block formatting context, each box's left outer edge touches the left edge of the containing block (for right-to-left formatting, right edges touch)

意思是，其子元素将左右相连贴合，实际上的样子，就像清除了浮动了一样。这个要求本质上是为了让盒型保持规整，否则盒型就不是一个规则的矩形了。

实际上， BFC 清浮动的方法只有上述几种建立新的 BFC 的方法有效，其他的是无作用的。另外， `clear` 与盒型的方法是完全不一样的， `clear` 不会影响原有的浮动，但 BFC 的方法实际上是会影响的。实际用的时候需要考虑。但是，如果不是为了兼容性， `flex` 和 `grid` 其实是更好的方案。
