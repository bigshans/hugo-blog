---
title: 在linux 上安装 ssr
date: 2018-11-28 15:03:05
tags:
- ssr
- 翻墙
categories:
- Linux
---

一直以来我都是用谷歌访问助手来访问谷歌的，不过有时候我还想要上推特和 YouTube ，虽然不经常吧，但一旦想要翻墙的时候还是很麻烦的。翻墙的方法有很多，借住 chrome 的插件可以完成一些，但是不完全，而且我要想白嫖的，那些收费的也未必有免费的好用。不过最近我的几个插件都不好用，于是我决定再增加一些方法。我安装了 ss 来翻墙。我用的是 Debian 的社区源，里面有 ss-qt5 可以用。我从 google+ 上找到了一个 ss 的账号尝试了一下，挺快的。不过只有这样一个账号我并不放心，于是有尝试找了找各种白嫖机场。虽然机场都有但是大多是 ssr 的，于是我决定下个 ssr 装上。

<!--more-->

我在谷歌上找半天终于找到 ssr 的安装脚本，地址是 [这里](https://github.com/the0demiurge/CharlesScripts/blob/master/charles/bin/ssr)。下载后再执行命令：

``` shell
chmod 776 ssr # ssr 是下载脚本的名字
sudo mv ssr /usr/local/bin
ssr install
```

脚本会从 github 上自动克隆 ssr 。

``` shell
ssr config
```

运行以上命令进行配置。

``` shell
ssr start
```

运行以上命令启动 ssr 。

``` shell
ssr stop
```

运行以上命令关闭 ssr 。
