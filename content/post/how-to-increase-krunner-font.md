---
title: "如何增加 Krunner 的字体"
date: 2022-11-13T23:16:38+08:00
markup: pandoc
draft: false
categories:
- HACK
tags:
- HACK
---

由于我切换到了 Xfce 下避难，而之前我一直用的是 Plasma ，很多软件我还是习惯用 KDE 的，更何况 Xfce 本身也挺匮乏的。

Krunner 的字体在 Plasma 下表现不错，但在 Xfce 下显得过小。但改变系统字体似乎并不影响 Krunner 自己的字体，经过一番搜索，终于知道了要修改位于 `~/.config/krunnerrc` 位置的文件。但在修改前要提前将 Krunner 退出，不然重启时会自动覆盖文件，使用如下命令：

```sh
kquitapp5 krunner
```

然后做如下两个修改：

```TOML
[General]
font=Noto Sans,20,-1,5,50,0,0,0,0,0

[PlasmaRunnerManager]
migrated=false
```

没有的自己添加，有的就改。然后重新启动，使用如下命令：

```sh
kstart5 krunner
```

字体的设置就生效了。
