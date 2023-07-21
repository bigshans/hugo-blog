---
title: 玩玩 docker emacs
date: 2019-11-10 20:35:36
tags:
- Emacs
- Docker
categories:
- Emacs
---

最近倒腾公司电脑，结果装不上 emacs 26，我的很多配置无法启用，在这里我要批评一下 deepin 。我真的是很少有听过降系统升级的。 deepin 还在 Debian stretch 上，如今 Debian 都上 buster 了。 deepin 为了稳定系统搞这个我觉得真是不行，至少软件也要新的嘛！

<!--more-->

目前我在我个人电脑上装了 Manjaro Deepin ，公司的电脑由于各种原因，于是装了 Deepin 。不得不说， Deepin 软件源太老了，没有 Arch 系那种新鲜感。但 pacman 的依赖处理着实弱鸡，没有 apt 好。

闲话不多说，进入正题吧！首先，是我装 emacs 26 装不上，于是使用 emacs 25，然而， 有些依赖仍然需要 emacs 26 。于是，我搜了搜，发现了这个 <https://github.com/JAremko/docker-emacs> 。于是我试了一下：

``` shell
docker run -ti --name emacs\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 -v <path_to_your_.emacs.d>:/home/emacs/.emacs.d\
 -v <path_to_your_workspace>:/mnt/workspace\
 jare/emacs emacs
```
感觉还可以，可以把这个当做 Daemon ，稍微改写一下：
``` shell
docker run -ti --name emacs\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 -v <path_to_your_.emacs.d>:/home/emacs/.emacs.d\
 -v <path_to_your_workspace>:/mnt/workspace\
 -v /tmp:/tmp\
 jare/emacs emacs --fg-daemon
```
使用 emacsclient 就可以了。

不过我又遭遇了另外一个问题就是 gnu-elpa-keyring-update Failed to verify signature 。问了一下群友，大概是这样解决了：
``` shell
gpg --homedir ~/.emacs.d/elpa/gnupg --receive-keys 066DAFCB81E42C40
```

出处是在这里<https://elpa.gnu.org/packages/gnu-elpa-keyring-update.html>。

以上。
