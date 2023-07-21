---
title: 网易云音乐 for linux 不用 root 打开
date: 2018-08-29 16:42:55
tags:
- Linux
- NeteaseCloud Music
categories:
- 解决方案
---
从知乎上看到这个，非常感谢 Fancy 的努力。

[点击此处前往](https://www.zhihu.com/question/277330447/answer/478510195)。

<!--more-->

在命令行里输入 

```shell
unset SESSION_MANAGER&& netease-cloud-music
```

 可以运行。

不过我无法在 desktop 文件里用这个命令，所以只能把命令写一个 shell 文件然后用 sh 运行去运行了。亲测 Debian sid 的 cinnamon 里可用。望周知。
