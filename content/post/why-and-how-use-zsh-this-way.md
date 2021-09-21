---
title: 为什么使用 zsh 以及为什么这样使用
date: 2021-09-22T01:08:35+08:00
draft: false
tags:
- linux
- shell
categories:
- linux
---

我使用 zsh 作为我的默认 shell 已经很长时间了，大概是从我 Debian 时候开始就使用了。当初的原因其实很简单，因为强大的 Oh My Zsh ，如今我用了这么久，想要重新疏理一下，向你推荐这样使用 zsh 。

## zsh 与 bash

zsh 之于 bash 的关系，如同 bash 之于 sh 的关系——可以兼容，但不能完全兼容。比如，我日常中最常遇到的 zsh 不兼容 bash 的问题就是通配符问题，在 bash 上可运行的、涉及通配符的命令一律需要使用引号进行消除。 zsh 会优先使用通配符进行匹配，这点着实令人烦恼。

除此之外， zsh 还有很多与 bash 不兼容的优点，这些有点就是我们所看中的。比如， zsh 的自动补全能力，即使不使用插件， zsh 的自动笔卷也不 bash 墙上百倍，它可以多层匹配路径，也可以匹配参数，而且补全可以选择而不是像 bash 一样单纯的展示，而这些能力将会在插件中得到增强。

不过，选择 zsh 的人大多都是因为一个原因—— Oh My Zsh 。

## Oh My Zsh 与 fish

OMZ 主要还是仿照 fish 的一些功能做的。 fish ，号称最 friendly 的 shell ，实际体验下来，确实，除了它不兼容 shell 语法之外， fish 的体验几乎是最好的。如果你不在乎 shell 语言兼容性的话，建议使用 fish ，而如果你需要 shell 语法兼容的话， zsh + OMZ 几乎是最好的组合。

OMZ 内置了许多插件，使得你可以很便捷启用这些插件。它还内置了一部分主题，你可以很轻易的改变 zsh 的样式。它还为你添加了许多方便的命令，比如说 `take` ，就是 `mkdir` 和 `cd` 的连携操作，还有非常快捷的路径切换。

但是除此之外， OMZ 带来了一个很麻烦的问题——慢。 OMZ 过大的体积使得 zsh 的启动速度被大幅拖慢，解决方法是，使用插件器去异步加载 OMZ 。

## zinit 和 antibody

其实 OMZ 默认的插件管理非常难用，通常只要你从 OMZ 的插件管理毕业之后，你基本上会再选择一个插件管理去管理 OMZ 和其他插件。

虽然 OMZ 自带了一些插件，但是默认是不启用的，除此之外， OMZ 就是一个基础的 zsh 配置框架，提供了一些基本的功能。但这对我们来说足够了， OMZ 只是集合了这些插件，我们可以在别的地方找到他们。

然后，我不推荐使用 zinit ，因为我用过一段时间，它在我的 shell 上有一些难以处理的麻烦，虽然很多人推荐，但我在这里不建议。

我在这里推荐 antibody ，貌似很少有人提到过，一个用 Go 写的插件管理器，它号称是最快 shell 插件管理器，我个人用下来确实不错，在此推荐给大家。

## 一些实用的插件

这里我就列个名目吧！

```
ohmyzsh/ohmyzsh
zsh-users/zsh-completions
zsh-users/zsh-autosuggestions
Aloxaf/fzf-tab
skywind3000/z.lua
zdharma/fast-syntax-highlighting
romkatv/powerlevel10k
mfaerevaag/wd
```

OMZ 自不必说。

zsh-completions 和 zsh-autosuggestions 这两个是仿造 fish 的插件，完完全全增强了 zsh 本来的补全能力。

fzf-tab ，如果你安装 fzf ，这个插件会给你的补全带来不一样的体验。简单来说，就是使用 fzf 来选择补全。

z.lua ，跟 autojump 差不多的插件，就是跳得快一点，使用 autojump 代替也行。

fast-syntax-highlighting ，更快的 zsh 语法渲染。

powerlevel10k ，从视觉上让你的 zsh 变得更快 zsh 主题，简单来说，它就是让 prompt 和 zsh 加载分离，让图形先出来，从而有一种 zsh 启动变快了的错觉。除此之外， p10k 也是相当漂亮的主题色，可定制能力也不错。

wd ，用来自定义目录名的。

插件不要贪多哦，否则启动速度谁也救不了你！

## 为什么使用 zsh

一个日用的 shell 的话，语法好不是第一目的，良好的交互才是，没必要用那有限的功能去限制自己。当然，能够保持最大限度的兼容是最好的。所以，这就是我选择 zsh 而不选择 bash 或 fish 的最大原因。那么，我们就抛弃完全放弃 bash 或 fish 了吗？不是的，首先，很多发行版上其实没有 zsh ，学习 bash 也能够与 zsh 兼容，是最经济的。而 fish ，则是与 bash 或 zsh 完全不同的选择，它虽然抛弃了 shell 的语法，但它获得了更好的语法，抛弃了原有 shell 的历史包袱，对于苦 shell 语法久矣的同志可以试一试。
