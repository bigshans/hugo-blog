---
title: flex 布局简说
date: 2021-07-10T22:35:25+08:00
draft: false
tag:
- flex
- css
categories:
- css
---

最近同事开分享会讲到了一点 flex 布局相关的东西，但是讲得很仓促，于是决定私下里整理一下，也算是对 flex 知识的总结。内容基本参考了 MDN 还有 W3C 文档的内容，当然，并不是面向初学者的内容，是知识整合。

## flex 布局的盒子模型与术语

当我们设置 `display: flex` 或 `display: inline-flex` 时，我们就生成了一个 flex 容器。 flex 容器的子元素称之为 *flex item* ，并且子元素使用 flex 布局。我们来看一下 flex 容器的盒子模型。

![](https://www.w3.org/TR/css-flexbox/images/flex-direction-terms.svg)

我们来规定一下这些术语：

- main axis/主轴：就是 flex 容器的方向，由 `flex-direction` 决定。可以取四个值：`row`、`row-reverse`、`column`、`column-reverse`。
- main size/主尺寸：就是 flex 容器的大小，由容器的宽高或 item 的宽高决定。
- cross axis/交叉轴：垂直于主轴的轴线，如果主轴是水平的，交叉轴就是垂直的，反之亦然。
- cross size/交叉尺寸：与主尺寸相对，当主尺寸为容器的宽时，交叉尺寸则为高，反之亦然。
- main start/main end/cross start/cross end/起始线/终止线：代表 flex 容器布局开始和结束的地方， flex 布局不会随着书写系统的改变而改变。

理解盒子模型是我们理解 flex 布局最关键的一步。

## `flex-direction` 和 `flex-wrap`

`flex-direction` 定义了 flex 容器的布局方向，它的四个方向分别对应：

- `row` ，从左到右。
- `row-reverse` ，从右到左。
- `column` ，从上到下。
- `column-reverse` ，从下到上。

`flex-wrap` 定义了当 flex item 溢出时应该如何处理，默认为 `nowrap` ，即不折行直接溢出，也可以使用 `wrap` 折行处理。

CSS 还提供了简写 `flex-flow` 用来同时设置 `flex-direction` 和 `flex-wrap` 。

## `flex-grow` 、`flex-shrink` 、 `flex-basis` —— flex item 的属性

`flex-grow` 、`flex-shrink` 和 `flex-basis` 这三个属性有一个简写—— `flex` 。

想要熟练使用 `flex` 属性，就必须要弄懂 `flex-grow` 、`flex-shrink` 和 `flex-basis` 。

### `flex-grow`

`flex-grow` 生效于当 flex 容器主尺寸大于各个 flex item 尺寸之和时，默认值为 0 。当 flex 容器主尺寸大于各个 flex item 尺寸之和时，浏览器会将剩余空间按照各个 flex item 的 `flex-grow` 设定分配给各个 flex item 。例如，当  flex 容器有 3 个子元素，若 3 个子元素的 `flex-grow` 都设定为 1 时，那么浏览器就会将剩下的空间按照 1:1:1 比例进行分配，追加到子元素后面。

### `flex-shrink`

`flex-shrink` 生效于当 flex 容器主尺寸小于各个 flex item 尺寸之和时，默认值为 0 。当 flex 容器主尺寸小于各个 flex item 尺寸之和时，浏览器会按照子元素 `flex-shrink` 设定进行分配缩放。例如，当  flex 容器有 3 个子元素，若 flex 容器为 100px ，子元素的 `flex-shrink` 分别设定为 A 、B 元素 1 ，C 元素 2 ，三个元素宽度都为 60px ，`3*60=180px` ，溢出容器 80px 。我们计算总权重为 `1*60+1*60+2*60=240` ，因此 A 、B 元素需要减少 `1*60/240*80=20px` ，C 元素需要减少 `2*60/240*80=40px` ，最终 A 、B 为 40px ，C 为 20px 。

关于 `flex-shrink` 和 `flex-grow` 的具体计算还请参看[这篇文章](https://zhuanlan.zhihu.com/p/24372279) 。

### `flex-basis`

`flex-basis` 设定了 flex item 在主轴方向上初始大小，默认为 `auto` ，即与 flex item 自己的大小相同。当一个元素同时被设置了 `flex-basis` (除值为 `auto` 外) 和 `width` (或者在 `flex-direction: column` 情况下设置了`height`) ， `flex-basis` 具有更高的优先级。

### `flex` 简写

`flex` 简写形式允许你把三个数值按这个顺序书写 —— `flex-grow`，`flex-shrink` ，`flex-basis` 。

我们可以使用一个，两个或三个值来指定 `flex` 属性。

简写形式如下：

``` css
/* 关键字值 */
flex: auto; /* flex: 1 1 auto */
flex: initial; /* flex: 0 1 auto */
flex: none; /* flex: 0 0 auto */

/* 一个值, 无单位数字: flex-grow */
flex: 2;

/* 一个值, width/height: flex-basis */
flex: 10em;
flex: 30px;
flex: min-content;

/* 两个值: flex-grow | flex-basis */
flex: 1 30px;

/* 两个值: flex-grow | flex-shrink */
flex: 2 2;

/* 三个值: flex-grow | flex-shrink | flex-basis */
flex: 2 2 10%;

/*全局属性值 */
flex: inherit;
flex: initial;
flex: unset;
```

语法规则如下：

**单值语法**: 值必须为以下其中之一:

- 一个无单位数: 它会被当作 `flex:<number> 1 0` ； `<flex-shrink>` 的值被假定为1，然后 `<flex-basis>` 的值被假定为 `0` 。
- 一个有效的宽度值: 它会被当作 `<flex-basis>` 的值
- 关键字`none`，`auto`或`initial`.

**双值语法**: 第一个值必须为一个无单位数，并且它会被当作 `<flex-grow>` 的值。第二个值必须为以下之一：

- 一个无单位数：它会被当作 `<flex-shrink>` 的值。
- 一个有效的宽度值: 它会被当作 `<flex-basis>` 的值。

**三值语法:**

- 第一个值必须为一个无单位数，并且它会被当作 `<flex-grow>` 的值。
- 第二个值必须为一个无单位数，并且它会被当作 `<flex-shrink>` 的值。
- 第三个值必须为一个有效的宽度值， 并且它会被当作 `<flex-basis>` 的值。

所以我们常用的 `flex: 1` 其实是 `flex: 1 1 0` 。

## `aligin-items` 和 `justify-content`

这两个属性是老朋友了。

`aligin-items` 是设定在交叉轴对齐的方式，默认是 `stretch` ，这就是为什么flex元素会默认被拉伸到最高元素的高度。

`justify-content` 属性用来使元素在主轴方向上对齐，主轴方向是通过 `flex-direction` 设置的方向。初始值是`flex-start`，元素从容器的起始线排列。但是你也可以把值设置为`flex-end`，从终止线开始排列，或者`center`，在中间排列。



最后，关于 `flex` 属性的话也可以参考这篇博文： https://www.zhangxinxu.com/wordpress/2020/10/css-flex-0-1-none/ 。
