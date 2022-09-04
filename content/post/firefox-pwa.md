---
title: "使用 Firefox PWA"
date: 2022-09-04T19:32:36+08:00
draft: false
categories:
- software
tags:
- software
---

Firefox 很久之前就停止支持 PWA 了，但现在 SPA 蓬勃发展，很多所谓的应用不过是网页套壳罢了， PWA 能够更简单的将网页安装为应用，比起要在系统里塞数个 Electron ，我觉得好很多。

我还是希望 Firefox 能够支持 PWA ，毕竟我是日常使用 Firefox 的。然后我就找到了这个项目： https://github.com/filips123/PWAsForFirefox 。终于，我可以在 Firefox 上使用 PWA 了。

首先要安装插件， https://addons.mozilla.org/en-US/firefox/addon/pwas-for-firefox/ 。插件安装完成后，它会引导安装 firefoxpwa 命令行。其实 firefoxpwa 才是本体，而插件不过是一个方便的前端。

按照引导完成安装之后，我们就可以将任意页面添加成为 PWA 了。添加的步骤也可以在命令行完成。需要注意的是，由于这个支持是非官方的，所以仍然存在一些问题，比如同一份 profile 的 PWA 会被合并成一个窗口，所以建议每一个 PWA 单独给一个 profile 。如果你的 PWA 不多的话，体验其实还不错。单开一个 profile 会起一个实例，多个 profile 会不能很好的进行资源共享，但相互之间隔离会带来近似独立应用的感受。只能说各有利弊吧！
