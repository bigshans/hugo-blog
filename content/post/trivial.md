---
title: "琐碎备录"
date: 2022-08-05T16:46:36+08:00
draft: false
---

## Makefile

`.PHONY` 可以用来重复编译，本意是将对应的对象视为虚假，从而强制执行编译。

## Joi

`joi.string().allow('').allow(null).empty('').optional()` ，允许字符串为空。

## pacman

以前记录过一遍，但太隐慝了，在此特意提出。

`pacman -Ql <package-name>` ，显示包内文件。

`pacman -Qi <package-name>` ，显示包内详细信息。

## git

自动 push 的实现，在 `.git/hooks` 中添加 `post-commit` 脚本，并赋予执行权限即可。脚本内容为：

```shell
#!/bin/bash

git push origin master
```

## 配色

阮一峰网站配色： bg = #F5F5D5 ， fg = #111 。

我的博客配色： bg = #FEFEFE ， fg = #000 .

## ln

如果要强制覆盖的话，使用 `-f` 选项，如 Arch 安装指导里就有 `ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime` 的示例。

`ln` 命令的两个地址，第一个是**源地址**，第二个是**目标地址**，我经常搞混。如果只输入一个地址，就是在当前目录下创建一个链接，连到目标地址上去。
