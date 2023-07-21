---
title: 在 linux 下备份系统
date: 2019-11-17 22:13:03
tags:
- Linux
- 备份
categories:
- Linux
---

新买的移动硬盘到了，着手做新的启动盘。在硬盘上分了一个 G ，然后用 Deepin 的启动盘制作工具做了一个启动盘。然后重启，启动 Deepin live cd ，然后还备份还是失败了。没办法，只能另寻他路。

<!--more-->

所谓备份，不过把文件复制一份，回头恢复的时候覆盖就行了。所以，其实我们拷贝一份我们的系统也是可以的，为了省空间，可以压缩一下。这样，只要 grub 没有坏，其实问题就不大。其他分区我们自行备份。

使用如下命令：
``` sh
tar -cvpzf /media/disk/backup.tgz --exclude=/proc --exclude=/lost+found --exclude=/tmp --exclude=/sys --exclude=/media --exclude=/home --exclude=/run/media /
```

恢复备份使用如下命令：
``` sh
sudo tar -xvpzf backup.tgz -C /
```

以上。
