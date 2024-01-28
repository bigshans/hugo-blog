---
title: "修改 hosts 加速访问 dl.google.com"
date: 2024-01-28T21:38:15+08:00
markup: pandoc
draft: false
category:
- 解决方案
tags:
- Android
---

https://dl.google.com 是 Android Studio 下载 Android SDK 的网站，国内有个镜像可以用。我们通过修改 hosts 文件让 Android Studio 去镜像站下载。

首先是获取 IP ，可以在[这里](https://ping.chinaz.com/dl.google.com) IP 访问情况，根据地区择优选择。

然后在 `/etc/hosts` 文件里追加即可。

```
220.181.174.97  dl.google.com
```
