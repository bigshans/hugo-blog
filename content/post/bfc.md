---
title: "BFC 简述"
date: 2023-08-06T19:09:10+08:00
markup: pandoc
draft: false
categories:
- 前端
tags:
- 前端
---

BFC 指块格式上下文。格式上下文定义了一个元素内部如何排布，以及与外部元素间如何排布。BFC 即定义了块元素的格式上下文。

默认情况下，`<html>` 为块格式上下文。块元素的子元素将按块排布，或者按行排布，如果出现混合排布的情况，则会将内联元素用匿名块包裹起来，然后按块排布。同时，匿名块不能被 CSS 指定，不受 CSS 样式影响。

在一些情况下，浏览器将会为元素创建新的独立 BFC ：

1. 使用了 `float` 。
2. 使 `position` 为绝对定位。
3. `display: inline-block` ，或者表格布局，`flex` ，`flow-root` 等。
4. `overflow` 不是 `visible` 。
5. `contain` 为 `layout` 、`content` 、 `strict` 。
6. flex 。
7. grid 。
8. multicol containers ，多列布局。
9. `column-span` 为 `all` 。

我们一般通过给父元素添加 CSS 来创建 BFC 来清除浮动。虽然子元素是独立的 BFC ，但父元素也是独立 BFC ，同样属于独立 BFC 的情况下，就按父子元素的原则正常包含了。
