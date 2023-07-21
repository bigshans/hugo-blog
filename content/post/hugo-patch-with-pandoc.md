---
title: 给 Hugo 增加一些 Pandoc 支持增强
date: 2021-10-22T13:46:00+08:00
markup: pandoc
draft: false
tags:
- Hugo
- Golang
categories:
- Hugo
---

Hugo 可以使用不同的 markdown 引擎来解析 `md` ，pandoc 就是其中之一。不过问题在于，使用 pandoc 就不会有 TOC ，如果在意这个的话使用起来还是挺麻烦的。

## 缘起

我个人使用 pandoc 主要是为了处理公式问题，我默认使用的 Hugo 引擎没有正确处理块公式，所以我就转用了 pandoc ，效果还是十分丝滑的，当然只是部分页面使用。

Hugo 在使用 pandoc 没有 TOC 的主要原因在于没有使用 `--toc` 参数，所以没有生成 TOC ，但实际情况要复杂一些，我个人选择 fork 了一份源码自己编译处理。

首先已经有人提出了 PR 给 Hugo 官方了，但我试了一下似乎还有一些问题，于是我就顺手修正一下代码。我的代码地址： [bigshans/hugo](https://github.com/bigshans/hugo) 。

## 编译安装

你可以选择直接 clone 下我的代码来编译。 `go install` 就可以安装到本地了，但如果你的主题是 scss 或是 less 编写样式的话，你运行就会有问题，所以想要安装扩展，得运行如下命令：

``` sh
go install --tags extended
```

## 结语

如果你想要使用，只需要添加 `markup: pdc` 到头部就可以了。不过，仍然需要注意的是，由于解析上的区别，一些 CSS 样式需要对主题代码进行调整，比如代码块， pandoc 直接用 class name 表示语言，但 Hugo 会加个 language 的前缀，这些都需要对应代码的兼容，我个人主题都做了适配。其他的，只能说慢慢看有没有问题，至于官方最新的更新就不知道到什么时候了。

最后，为了演示，本篇也是用 pandoc 渲染的。
