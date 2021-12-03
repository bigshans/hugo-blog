---
title: drop-shadow 隐藏原始图像
date: 2021-12-03T16:32:50+08:00
draft: false
tags:
- css
categories:
- css
---

看到张鑫大佬的[这篇文章](https://www.zhangxinxu.com/wordpress/2016/06/png-icon-change-color-by-css/)很有意思。

张鑫大佬讲述了如何使用 `filter` 中的 `drop-shadow` 实现 png 图标改颜色的技巧，本质上是利用阴影偏移实现的。不过我有一点我一直没有搞明白就是如何将原始图像遮住。

文章中说使用透明边框，我试了试，不知道是不是姿势不对，并没有达到我想要的效果，于是我尝试了别的方法。

`margin` 、 `padding` 、 `left` 都没有效果，如果原图被完全覆盖，则阴影就会完全不显示。最后我试了试遮罩，成功了。

```html
<img src="nike.png" />
<div class="mask"></div>
```

```css
img {
    position: relative; 
}
.mask {
    position: absolute;
    z-index: 999;
    background: white;
}
```

需要注意的是，由于阴影并不是在原图的位置，你需要做一个位置上的偏移，同时，需要注意实际占据位置的是原图而不是阴影，以及遮罩的层级，还有偏移后会遮罩住其他颜色。
