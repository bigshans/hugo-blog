---
title: 如何合并 Git 无关历史
date: 2021-09-27T11:57:02+08:00
draft: false
tags:
- git
categories:
- trouble
---

由于每次线上建仓库总会给我留一个文件，导致我仓库连接远程总是提示无法合并无关代码。这里就写统一写一下这个问题如何解决。

``` shell
git pull origin master --allow-unrelated-histories 
```

`--allow-unrelated-histories` 用于强制合并无关历史。
