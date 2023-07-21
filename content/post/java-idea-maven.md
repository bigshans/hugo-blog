---
title: idea 一直加载 maven
date: 2018-10-28 21:16:08
tags:
- Idea
- Maven
categories:
- Software
---

之前遇到过一次 idea 无法正常加载 maven ，那时 hosts 里设置有问题，将 127.0.0.1 loacalhost 加入 hosts 里就行。现在又有新的问题，于是试了试在 import 里的 VMoption 改为 1024 就行了。
