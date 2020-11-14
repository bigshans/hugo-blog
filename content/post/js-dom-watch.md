---
title: js 实现 DOM 监视
date: 2018-10-07 15:53:19
tags:
- javascript
categories:
- javascript
---

花了点时间做了 b 站评论区地址链接化，比较麻烦的是 DOM 监视。找了很多，最后还是采用了 Muatation 来进行事件监视。

给个文档地址：http://javascript.ruanyifeng.com/dom/mutationobserver.html 。

<!--more-->

## 实例讲解

``` js
var observer = new MutationObserver(function (mutations, observer) {
  mutations.forEach(function(mutation) {
    console.log(mutation);
  });
});
```

这里创建了一个观察器实例，启动后被出发时会自动回调创建时赋予的函数。

```js
var article = document.querySelector('article');

var  options = {
  'childList': true,
  'attributes':true
} ;

observer.observe(article, options);
```

observe 方法接受两个参数，一个是对应要被监视的 DOM 节点，一个是对应观察的 DOM 操作，运行 observe 启动观察器即可简单使用。

#### 【附】

脚本地址： https://gist.github.com/bigshans/7b7b1c2c7896853a39ee7d573fd5097b