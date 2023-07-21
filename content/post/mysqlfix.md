---
title: 解决 mysql 进程无法启动的问题
date: 2020-01-18 18:05:52
tags:
- MySQL
- 后端
categories:
- 后端
---

最近想写一点小东西，就发现自己电脑上的 mysql 出了点问题，解决之后做个小记录。

<!--more-->

首先遇到的第一个问题是 Mysql 进程无法启动，或者说启动失败。在 `systemctl status mysqld.service` 里出现了报错 `Can't start server : Bind on unix socket: No such file or directory` ，然后通过修改 `/etc/my.cnf` 里加上一句 `socket=/var/lib/mysql/mysql.sock` ，重启服务成功运行。

但是发现只有 root 可以运行，于是再运行命令 `sudo chmod -R 777 /var/lib/mysql/` ，运行成功。可喜可贺可喜可贺！
