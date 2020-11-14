---
title: infinality font 字体渲染安装
date: 2019-11-03 10:23:43
tags:
---

最近在工作电脑上安装了 deepin ，发现字体渲染很糟糕，于是在想起了 infinality 补丁，由于我个人电脑上是 manjaro ， arch 源里就有该包，所以我查找一下，发现 Debian 系的也有打包，成功安装之后，特此记录一下。

原文链接：<https://www.linuxdashen.com/debian8安装infinality改善字体渲染，安装ubuntu字体>

<!--more-->

我是选择直接下载对应的 fontconfig-infinality 包进行安装，由于并没有别的什么依赖，安装很顺利。之后输入命令：

    sudo bash /etc/fonts/infinality/infctl.sh setstyle

我选择的是 osx，我比较喜欢 mac 风。
之后编辑 /etc/profile.d/infinality-setting.sh ，找到 USE_STYLE ，修改成我们刚刚选的。然后重启一下电脑就可以了。

