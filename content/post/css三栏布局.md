---
title: "CSS 三栏布局"
date: 2023-01-10T09:27:35+08:00
markup: pandoc
draft: false
categories:
- 前端
tags:
- 前端
- CSS
---

三栏布局是比较经典的 CSS 布局，特点就是中间内容自适应，首先渲染，其次左右内容大小保持不变分布两旁。结构上打破了一般意义上的左中右的顺序，变成了中左右的顺序，但视觉展示仍然要求是左中右的布局，于是，如何将中间内容放回到中间，并重新分布左右则是此类技术的核心所在。在 `flex` 之前，前端多用 `float` 实现，出现了双飞翼和圣杯布局两种实现，现在我们可以用 `flex` 来很简单的实现。

## 圣杯布局

圣杯布局的基本 HTML 结构如下：

```HTML
<div class="header">header</div>
<div class="container">
    <div class="middle">middle</div>
    <div class="left">left</div>
    <div class="right">right</div>
</div>
<div class="footer">footer</div>
```

我们可以看到，三栏的主要部分被 container 容器包裹。圣杯布局主要是利用容器的内边距撑开左右，再借助 `position: relative` 和 `margin` 来实现左右元素的偏移，这里我们都使用了 `float` 来脱离原有的文档流布局。

基本思路是这样的：

1. 设置 `container` 容器左右内边距，需要左右容器同宽。
2. 设置 `middle` 、 `left` 、 `right` 为 `float: left` ，此时 `container` 内部坍陷。可以给 `container` 设置 `overflow: hidden` 或者给 `footer` 设置 `clear: both` 来解决塌陷问题。
3. 设置 `middle` 宽度为 `width: 100%` 。
4. 将 `left` 向左边移动一个 `container` 加一个 `left` 的宽度。
5. 将 `right` 向左移动一个 `right` 的宽度。

最后实现的效果如下：

<div>
<div class="header-1">header</div>
<div class="container-1">
<div class="middle-1">middle</div>
<div class="left-1">left</div>
<div class="right-1">right</div>
</div>
<div class="footer-1">footer</div>
</div>

<style type="text/css">
.header-1,.footer-1,.middle-1,.left-1,.right-1 { height: 50px; }
.container-1 { padding: 0 100px; }
.header-1 { background-color: red; }
.middle-1 { width: 100%; float: left; background-color: green; }
.left-1 { width: 100px; float: left; background-color: blue; margin-left: calc(-100% - 100px); }
.right-1 { width: 100px; float: left; background-color: pink; margin-right: -100px; }
.footer-1 { clear: both; background-color: red; }
</style>

css 源码如下：

```css
.header,.footer,.middle,.left,.right { height: 50px; }
.container { padding: 0 100px; }
.header { background-color: red; }
.middle { width: 100%; float: left; background-color: green; }
.left { width: 100px; float: left; background-color: blue; margin-left: -100%; position: relative; left: -100px; }
.right { width: 100px; float: left; background-color: pink; margin-left: -100px; position: relative; left: 100px;  }
.footer { clear: both; background-color: red; }
```

这里左右移动分为两步，先用 margin 将左右元素移动到同一行，然后分别向左右移动一个自身宽度。我们也可以用 `calc()` 来实现。

```css
.left { width: 100px; float: left; background-color: blue; margin-left: calc(-100% - 100px); }
.right { width: 100px; float: left; background-color: pink; margin-right: -100px;  }
```

这样，我们可以完全不用 `position` 属性了。其实主要是左元素移动会比较麻烦，右元素移动都比较通用。

## 双飞翼布局

双飞翼布局主要使用外边距撑开内容。

```HTML
<div class="header">header</div>
<div class="middle">
    <div class="inside">inside</div>
</div>
<div class="left">left</div>
<div class="right">right</div>
<div class="footer">footer</div>
```

双飞翼的布局，主要部分放在 `inside` 中，而原来的 `middle` 主要起到了一个容器的作用。

基本思路是这样的：

1. 设置 `middle` 容器宽度为 `100%` ，并设置 `float: left` ，让中间容器上浮一行。
2. 设置 `inside` 的外边距与左右容器同宽，因为 `inside` 此时高度为 0 ，需设置 `inside` 高度。
3. 将 `left` 向左边移动一个 `container` 的宽度。
4. 将 `right` 向左移动一个 `right` 的宽度。

最后效果如下：

<div>
<div class="header-2">header</div>
<div class="middle-2">
<div class="inside">inside</div>
</div>
<div class="left-2">left</div>
<div class="right-2">right</div>
<div class="footer-2">footer</div>
</div>

<style type="text/css">
.header-2,.footer-2,.middle-2,.left-2,.right-2 { height: 50px; }
.header-2 { background-color: red; }
.inside { margin: 0 100px; height: 50px; }
.middle-2 { width: 100%; float: left; background-color: green; }
.left-2 { width: 100px; float: left; background-color: blue; margin-left: -100%; }
.right-2 { width: 100px; float: left; background-color: pink; margin-left: -100px; }
.footer-2 { clear: both; background-color: red; }
</style>

css 源码如下：

```css
.header,.footer,.middle,.left,.right { height: 50px; }
.header { background-color: red; }
.inside { margin: 0 100px; height: 50px; }
.middle { width: 100%; float: left; background-color: green; }
.left { width: 100px; float: left; background-color: blue; margin-left: -100%; }
.right { width: 100px; float: left; background-color: pink; margin-left: -100px; }
.footer { clear: both; background-color: red; }
```

其实与圣杯布局相差不多，但 `middle` 占满了单独一行，还是有很多可以操作的空间的。

## flex 实现三栏布局

`flex` 可以很轻松的实现三栏布局。

```html
<div class="header">header</div>
<div class="container">
    <div class="middle">middle</div>
    <div class="left">left</div>
    <div class="right">right</div>
</div>
<div class="footer">footer</div>
```

DOM 结构与圣杯布局类似。

基本思路是这样的：

1. 通过 `order` 设置三栏的顺序。
2. 将三栏排布到同一行。
3. 设置左右元素定宽，并设置左右元素的伸缩能力为 0 。
4. 设置中间元素不定宽，并将所有伸缩空间赋予给它。

最后效果如下：

<div>
<div class="header-1">header</div>
<div class="container-3">
<div class="middle-3">middle</div>
<div class="left-3">left</div>
<div class="right-3">right</div>
</div>
<div class="footer-1">footer</div>
</div>

<style type="text/css">
.middle-3,.left-3,.right-3 { height: 50px; }
.container-3 { display: flex; }
.middle-3 { width: 100%; background-color: green; order: 2; flex: 1; }
.left-3 { width: 100px; background-color: blue; order: 1; flex: 0 0 100px; }
.right-3 { width: 100px; background-color: pink; order: 3; flex: 0 0 100px; }
</style>

css 源码如下：

```css
.header,.footer,.middle,.left,.right { height: 50px; }
.header { background-color: red; }
.container { display: flex; }
.middle { width: 100%; background-color: green; order: 2; flex: 1; }
.left { width: 100px; background-color: blue; order: 1; flex: 0 0 100px; }
.right { width: 100px; background-color: pink; order: 3; flex: 0 0 100px; }
.footer { clear: both; background-color: red; }
```

`flex: 1` 是 `flex: 1 1 auto` 的缩写。具体可以看我之前的文章[flex 布局简说](../flex)。

三者具体的区别，你可以通过调整窗口大小看到。
