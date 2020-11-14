---
title: css绘制三角形
date: 2019-12-22 21:21:47
tags:
- css
categories:
- css
---

最近写前端要一个下拉箭头，所以选择用 css 画一个三角形来用，话不多说，看代码：

<!--more-->

```css
.replenish .arrow-down {
    display : inline-block;
    position: relative;
    width: 20px;
    height: 3px;
    margin-right: 20px;
    /*font-size: 0;*/
    /*line-height: 0;*/
    /*border-width: 6px;*/
    /*border-color: black;*/
    /*border-bottom-width: 0;*/
    /*border-style: dashed;*/
    /*border-top-style: solid;*/
    /*border-left-color: transparent;*/
    /*border-right-color: transparent;*/
}

.replenish .arrow-down::after {
    display: inline-block;
    content: ' ';
    height: 8px;
    width: 8px;
    border-width: 0 2px 2px 0;
    border-color: #999999;
    border-style: solid;
    transform: matrix(0.71, 0.71, -0.71, 0.71, 0, 0);
    transform-origin: center;
    transition: transform 0.3s;
    position: absolute;
    top: 50%;
    right: 10px;
    margin-top: -10px;
}

.replenish .arrow-up::after {
    display: inline-block;
    content: ' ';
    height: 8px;
    width: 8px;
    border-width: 0 2px 2px 0;
    border-color: #999999;
    border-style: solid;
    position: absolute;
    top: 50%;
    right: 10px;
    margin-top: -10px;
    transform-origin: center;
    transform: rotate(-135deg);
    transition: transform 0.3s;
}

.replenish .arrow-up {
    display : inline-block;
    position: relative;
    width: 20px;
    height: 3px;
    margin-right: 20px;
    /*font-size: 0;*/
    /*line-height: 0;*/
    /*border-width: 6px;*/
    /*border-color: black;*/
    /*border-top-width: 0;*/
    /*border-style: dashed;*/
    /*border-bottom-style: solid;*/
    /*border-left-color: transparent;*/
    /*border-right-color: transparent;*/
}

```

这里是空心箭头，就是绘制两个三角形，一个是白色的三角形进行遮挡。注释里的是实心箭头。