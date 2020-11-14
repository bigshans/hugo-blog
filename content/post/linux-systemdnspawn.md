---
title: systemd-nspawn 的简单使用
date: 2019-11-24 23:23:03
tags:
- linux
- systemd
- system-nspwan
categories:
- linux
---

systemd-nspawn 是 docker 与一样的 container 应用，只不过 docker 相比，跟类似于 chroot 。个人还是比较喜欢 chroot 这样的，这样有种子系统的感觉，与 docker 的 container 相比， chroot 下的操作是会被保留下来的， docker 和 chroot 还是两种不同情况，不可同语。

<!--more-->

chroot 和 systemd-nspawn 还是有所不同的， systemd-nspawn 是真正把系统启动了起来，而 chroot 只是改变了 root ，而不继承某些环境变量。system-nspawn 的使用需要用镜像，我是使用 debootstrap 搭了个 deepin 镜像。

```sh
sudo debootstrap --include=systemd-container stable deepin http://mirrors.ustc.edu.cn/deepin/
```

经过漫长的等待，我们的镜像终于搭好了。由于 Debian 系登陆需要用户名密码，我们先进入系统设置个用户名密码。

```sh
sudo systemd-nspawn -D deepin
```

然后我们输入 `passwd` 设置密码后，退出 shell 即可。

然后我们正式进入系统。

```sh
sudo systemd-nspawn --bind=/tmp/.X11-unix:/tmp/.X11-unix --bind=/run/user/1000/pulse:/run/user/host/pulse --setenv=LANGUAGE=zh_CN:zh -bD deepin
```

其实也没有什么好看的，不过我硬盘里有个系统，我可通过以上指令，让我硬盘里的系统在我主系统下启动，有时候出于维护的目的，这个命令挺好用的，毕竟真正启动了系统。

然后三下 `C-]` ，关闭启动的系统。