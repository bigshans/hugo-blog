---
title: "将 snap 打包成 AUR"
date: 2022-09-09T14:31:52+08:00
draft: false
categories:
- linux
tags:
- linux
- 打包
---

masscode 仅仅提供了 snap 包给 Linux 版，但我并不想使用 snap ，所以就想单独打包。由于 masscode 是 electron 应用，所以理论上只需要拿到 `resources/app.asar` 就万事大吉了。

snap 包实际上是一个 squashfs ，所以打包需要使用 squashfs-tools 。解包直接运行命令 `unsquashfs <snap-name>` 即可，包的内容放在当前目录的 `squashfs-root` 文件夹下。进入文件夹就会发现与一般的 electron 应用无异了。接着可以按照一般的 electron 应用打包。

中间出现了一点意外。我总是无法使用 electron 单独启动 masscode ，而我的 pnpm 又因为版本过高无法正常安装源码依赖，最终我不得不降低版本依赖安装调试。经过简单的调试，我发现 masscode 通过环境变量判断是否出于 dev 环境，但我的 NODE_ENV 恰恰是 development ，从而导致，通过 electron 启动的应用总是会进入到调试模式去。这个问题很好解决，只要在启动脚本单独设置环境变量就可以了。

最终成果： https://aur.archlinux.org/packages/masscode

用起来我还是挺喜欢的。
