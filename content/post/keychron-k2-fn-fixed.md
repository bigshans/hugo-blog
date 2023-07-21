---
title: '修复 Keychron K2 的 Fn 键在 Arch 上不好使的问题'
date: 2022-03-06T14:24:56+08:00
draft: false
tags:
  - Linux
categories:
  - Linux
---

话说 Keychron 这个软件系统兼容做的真差，没想到基础的 Fn 键也能出岔子。

虽然我已经将键盘布局改为 Windows 布局，但 Fn + F1~F12 仍然处于完全不能用的状态。 Windows 用户也不能幸免。主要问题还是在于 Keychron 被识别为 Apple 键盘，导致 F1 到 F12 全被认为是媒体键。而 Mac 用户没有这个问题。

Windows 的解决办法就是删掉 Apple 键盘驱动。

Linux 快速生效的办法是运行下面的命令：

```shell
echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode
```

这样就能立刻生效了，但下次启动会丢失。如果想要持久化，则需要写入 module ，再重建一下 `initramfs` 。

```
echo "options hid_apple fnmode=0" | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo mkinitcpio -P
```
