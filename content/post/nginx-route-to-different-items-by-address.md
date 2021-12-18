---
title: "Nginx 按路由分流请求"
date: 2021-11-30T14:04:23+08:00
draft: false
tags:
- nginx
- 前端
- 运维
categories:
- 前端
---

一个很恶心的需求，到部署最后部署的时候才发现问题很大，但只好死马当活马医了。

我们目前搞了两个项目，其中一个项目是传统 Vue 项目，另一个是 Angular SSR ，刚开始的时候，我们设想两个项目会由 Nginx 根据路由进行分流请求到不同项目，这样我们就可以不用将全部项目改造为 SSR 。设想很美好，但是我们漏考虑了一个点，我接下来就会说。

## 问题

其实按路由将请求分流其实不是什么难题，但问题是，两个项目生成后最后都有各自的样式，如果我们仅仅导流了页面而没有导流对应的 js 、 css 、图片等文件，必然会造成其中一个项目无法正常运行，这与我们的设想严重背离。

显然，导流非页面文件是不现实的，因为量太大了。但解决办法也不是没有，只不过并不是那么优雅。

## 解决办法

非常朴素的办法——把样式放到一起去。

首先我把 Vue 的 index.html 改为了 main.html 以与 Angular 的相区别，之后将 Vue 的文件拷贝到 Angular 的 browser 下。因为二者目录结构相差较多，所以重合的内容只有少数的一点文件，而这些文件本就是相同的，所以不受影响。接着，我们修改 Nginx ，修改 root ，指向到 Anguar 的 browser 。其他的就是修改路由指向到对应的页面。

Nginx 检测一下，没有问题，重启 Nginx 打开页面，大功告成！

## 总结

搞其实还挺吐血的，前期没有思虑到这个问题。问题解决的思路其实蛮类似微前端的处理方案，需要把样式之类的最终打包到一起，只不过我没发打包就只好放到一起了。目前来说，两边代码发生重合的机率挺低的，毕竟框架不同生成的结构不同，但一旦出现重合，最好就再打包让它们避开，除此之外，实在没有更好的办法了。

