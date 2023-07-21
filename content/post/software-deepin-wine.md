---
title: 安装 deepin-wine 到 debian 上
date: 2018-09-02 19:21:21
tags:
- Linux
- QQ
categories:
- Linux
---

我尝试了一下 [deepin-wine-ubuntu](https://github.com/wszqkzqk/deepin-wine-ubuntu) 项目，不过无法正常装上。所以我自己尝试了一下安装 deepin-wine 并尝试了一下 deepin 的 QQ 和 TIM 。效果还不错。
<!--more-->
首先得先到 [阿里源](http://mirrors.aliyun.com/deepin/pool/non-free/d/) 下载的 deepin-wine ，我下的是旧版本的 2.18-10 。然后用 apt install 安装包然后出错，显示依赖问题，然后在源里查找依赖包，再用 apt install 这些包，又有新依赖，如此往复几次，最终没有依赖问题即安装成功。

然后在安装 QQ 和 TIM ，在源里查找 deepin QQ 的包安装，QQ 还有包依赖问题，继续重复上面的步骤。 TIM 如 QQ 一样安装，不过打开会有 flash 问题。不管也没事。
最后从菜单中打开它们。稳定性很好，能记住密码，比 crossover 的要稳定得多，但是不能加载动图，不过不碍事，语音可以用，视频不能用，比 crossover 的好一点。最后写了脚本，将这些打包上传到了 github 和码云上。

地址请点击： [github](https://github.com/bigshans/Deepin-wine-QQ-TIM-Debian) ， [码云](https://gitee.com/aerian/Deepin-wine-QQ-TIM-Debian)
