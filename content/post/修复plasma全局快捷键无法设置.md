---
title: "修复plasma全局快捷键无法设置"
date: 2023-02-04T20:22:00+08:00
markup: pandoc
draft: false
categories:
- linux
tags:
- linux
---

起因是不知道什么时候，我打开 Plasma 的快捷键设置时，全局设置总是报错，但虽然报错，全局快捷键亦然很好使。

经过我一番努力的探索，我终于发现了问题所在。

可以参考以下的帖子： https://forum.ubuntu.org.cn/viewtopic.php?t=491267 。

首先运行以下命令查看输出：

    systemctl restart --user plasma-kglobalaccel.service

你会发现有黄色的 warning 输出，但是不报错。它会告诉你有 dekstop 文件有问题，你需要修改自己的配置，把有问题的配置全部删掉。然后重启服务，问题就解决了。
