---
title: 安装 Anbox for Arch
date: 2021-07-24T10:47:29+08:00
draft: false
tags:
- Linux
- Anbox
categories:
- Linux
---

台风天写这篇文章。

---

最近更新了 Linux 的内核，然后日常发布合并，日常逛 Issues 的时候，发现有人提出要 Anbox 的需求。Anbox 我试着安装过几次，然后每次装上都因为各种问题而失败。然后这次我就想顺便把它成功装上。

## 安装

Arch Wiki 的内容还是很详细的，因为我是自己编译的内核，所以需要重新添加一些 Anbox 依赖的一些模块之后重新构建。我把这些依赖加到了编译的配置脚本里，我加入到打包中，做了个打包。 然后我还发布了一个编译好了的包，如果是跟我用同一个内核的话，可以尝试用我这个包来进行替代，然后你就拥有了 Anbox  内核支持。(https://github.com/bigshans/Xanmod-CaCule-UKSM ，上游已经加入了，就是没有包发布，过段时间我再考虑要不要直接发到上游。)

如果是官方内核的话，添加对应的 dksm 就好了，如果是非官方的，尝试在 AUR 里找一下对应的 Anbox 支持内核 。Linux-zen 用户已经得到支持了，所以可以跳过这一步。Arch Wiki 讲得很好了，我不赘述了。

内核准备好之后，加载  `binder-linux`  、 `ashmem-linux` 模块。

``` sh
sudo modprobe -a binder-linux ashmem-linux
```

然后安装 `anbox-image` ，可以直接使用 Archlinuxcn 源里的。

最后是安装 `anbox-git` ，最好用 AUR 里的， Archlinuxcn 源的有点老。

安装完成后别忘了启动 `anbox-container-manager.service` 。

接着我们就能成功打开 Anbox 了，不过还要问题——连不上网。

Arch Wiki 提供了三种解决方式。我选择了最后一种，因为我用的是 iw 上网的。

首先下载一个脚本（https://raw.githubusercontent.com/anbox/anbox/master/scripts/anbox-bridge.sh）到 `/usr/bin` 目录下并赋予可执行权限，然后创建文件 `/etc/systemd/system/anbox-container-manager.service.d/enable-anbox-bridge.conf` 并写入一下内容：

``` config
[Service]
ExecStartPre=/usr/bin/anbox-bridge start
ExecStopPost=/usr/bin/anbox-bridge stop
```



## 使用

安装 APP 完全就是 adb 一把梭。

用下来缺陷还是蛮多的，比如有些按钮不管怎样都按不了，一些 APP 无法使用，总的来说，有点鸡肋。