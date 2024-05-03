---
title: "在 plasma 上使用 Meta 打开开始菜单"
date: 2024-05-03T13:38:44+08:00
markup: pandoc
draft: false
categories:
- Linux
tags:
- Linux
---

使用 `Meta` 打开开始菜单是一个非常方便的功能，最早在 Plasma 上，可以使用 `ksuperkey` 来实现。不过 `ksuperkey` 仅支持 X11 ，在 Plasma on Wayland 就失去作用了。不过 Plasma 很早之前就将这个功能内置了，详见[此处](https://zren.github.io/kde/#windowsmeta-key) 。

与 `ksuperkey` 一样，首先需要设定开始菜单的快捷键为 `Alt+F1` ，之后运行如下命令：

```shell
kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell,/PlasmaShell,org.kde.PlasmaShell,activateLauncherMenu"
qdbus org.kde.KWin /KWin reconfigure
```

然后该功能就生效了。
