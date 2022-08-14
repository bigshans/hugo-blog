---
title: "如何使用 wine-wechat-setup"
date: 2022-07-27T14:05:02+08:00
draft: false
categories:
- HACK
tags:
- HACK
---

最近升级了一下微信，好久没有这个脚本好像都不会用了。此脚本是依云姐写的，在 Archlinuxcn 源上，需要配合 wine-for-wechat 。

wine-wechat-setup 提供了一个 `wechat` 命令，如果你已经在本地安装了微信就会直接启动。 `wechat -h` 查看具体用法。

```
usage: wechat [-h] [-c] [-d] [-i INSTALL] [-p PROFILE] [args ...]

Wine WeChat

positional arguments:
  args                  arguments for WeChat.exe

options:
  -h, --help            show this help message and exit
  -c, --config          run winecfg
  -d, --dir             open Wine prefix directory
  -i INSTALL, --install INSTALL
                        install or update the WeChat program
  -p PROFILE, --profile PROFILE
                        use alternative profile
```

安装或者升级都使用 `-i` 选项。 wine-for-wechat 需要 freetype ，建议使用 lib32-freetype2 就行了。其他的依赖看着装就可以了。

安装的过程保持默认即可。
