---
title: hostname 也不要随便取
date: 2018-09-05 18:11:35
tags:
- Linux
categories:
- Linux
---

一个小问题，困扰很久了，最近解决掉了，就是不能以 root 打开任何 GUI ，打开之后不显示。
问题在于我的 hostname 取成 localhost 了，所以打不开。。（下次不这样了）改个 hostname 就行。
``` shell
hostnamectl set-hostname "myhostname"
```
<!--more-->