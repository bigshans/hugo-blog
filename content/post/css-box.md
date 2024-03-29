---
title: "CSS 盒子模型"
date: 2023-01-13T09:27:13+08:00
markup: pandoc
draft: false
categories:
- 前端
tags:
- CSS
- 前端
---

一个 HTML 文档在浏览器内将会被解析为一棵文档树，这是众所周知的。 CSS 的盒子模型则描述了文档上的每一个节点所生成的模型，这是 CSS 布局排版的基础。

## 标准盒型

![盒子模型示意图](https://www.w3.org/TR/2016/WD-CSS22-20160412/images/boxdim.png)

每一个盒子都一块内容（content）区域，围绕内容从内向外分别是内边距、边框和外边距（padding 、 border 、 margin）。

内容、内边距、边框和外边距这四块区域，每一块区域的边缘被叫做边界，因此，一个盒型有如下四个边界：

- **content edge** 或 **inner edge**
    * 即环绕于内容区域的矩形，它定义了内容区域。它有宽和高，一般由元素内容来决定。四个内容边缘确定一块内容盒子（**content box**）。
- **padding edge**
    * 填充边界环绕于盒子的填充区域，如果填充区域的宽度为 0 ，则填充边界与内容边界相同。四个填充边界定义了一个填充盒子（**padding box**）。
- **border edge**
    * 边框边界环绕与盒子的边框，如果边框宽度为 0 ，则边框边界与填充边界相同。四个边框边界定义了一个边框盒子（**border box**）。
- **margin edge** 或 **outer edge**
    * 外边距边界环绕于盒子的外边距，如果外边距宽度为 0 ，则外边距边界与填充边界相同。四个外边距边界定义了一个外边距盒子（**margin box**）。

每一个边界都存在着上边界、右边界、下边界和左边界。

内容、内边距和边框的背景由背景属性生成。外边距的背景默认为透明。

内容盒子的宽高通常由多种因素决定，比如说：生成的盒子是否允许设置 `width` 和 `height` ，生成的盒子是否包含文本或其他盒子，盒子是否是表格等等。具体的这些内容，将由视觉格式上下文（visiual formatting context）来做具体的规定。

## `box-sizing`

以上对盒型的讨论，是基于 CSS2 的，但在 CSS3 中，因为 `box-sizing` 的出现而有了些变化。

`box-sizing` 允许我们设置盒子的固定尺寸是会被设定到内容盒子上还是边框盒子上。具体有两个值，一个是 `content-box` ，即设定到内容盒子上，另一个是 `border-box` ，即设定到边框盒子上。前者与 CSS2 所设定的宽高关联相一致，默认的盒子尺寸采用 `content-box` 。

设定为 `border-box` 的盒子，其 `内容元素的宽高 = max(0, 元素固定大小 - 内边距大小 - 边框大小)` ，内容盒子的尺寸将由计算决定，相当于我们设定标准盒型的内容宽高为对应的计算属性。 `border-box` 的好处还是很明显的，当我们不清楚盒子具体内容的大小，但知道盒子整体大小时，设置为 `border-box` 可以防止盒子的最终大小因内容的变动而引起盒子尺寸的变动。

## `direction` 属性对行内元素的影响

当 `direction` 为 `ltr` 时，即从左到右阅读文本，元素将从左到右生成内容。

当 `direction` 为 `rtl` 时，即从右到左阅读文本，元素将从右到左生成内容。
