---
title: deb 打包指北
date: 2018-09-09 19:18:52
tags:
- Debian
- Linux
categories:
- Linux
---

最近几天在给我的一些软件打包，原本打算建立一个私人仓库，不过没有云还是算了。本地打包的话貌似空间不太够，不过首先还是要学习一下 debian 的相关知识的。

<!--more-->

要打包一个 deb 首先要建立目录，按照对应目录结构构建的子目录，以及放置相关信息和修改脚本的 DEBIAN 目录。

DEBIAN 目录下至少要一个 control 文件， control 包含了安装的必要信息，所以一定要好好填写。一下几项请务必填写：

* Version - 版本号
* Architecture - 平台
* Maintainer - 维护者
* Description - 描述

我还经常加上:

* Installed-Size - 安装大小，按 KB 计算。

除此之外，还有 preinst 、 postinst 、 prerm 、 postrm 脚本。这些脚本是可执行脚本，还要注意写完后 chmod 改变权限。一般我改为 755 。

```
+---------+  安装后      +----------+
| preinst | ----------> | postinst |
+---------+             +----------+
+---------+  卸载后      +----------+
|  prerm  | ----------> |  postrm  |
+---------+             +----------+

```

打包使用 dpkg-deb ，命令格式为：

``` shell
dpkg-deb -b package-path deb-path
```

以上就是本次的内容。