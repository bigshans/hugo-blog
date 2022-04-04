---
title: "可能 lua 不是配置 nvim 的最佳解决方案"
date: 2022-04-04T21:55:06+08:00
draft: false
tags:
- lua
- nvim
categories:
- nvim
---

这几天折腾 nvim ，折腾的过程中也发现各个插件可能并不一定如我意，于是我就修改一部分插件并 fork 为己所用。不知不觉过去好久了，我积累下来的好多配置，以及好多插件都需要更换了，一些是无人维护了，一些是不兼容了。除此之外，还有另外一件事情，要不要用 lua 替换我原来 vimScript 的配置？

经过几天我的折腾，我的回答是：**不要**！

## 为什么不用 lua 替换 vimScript ?

主要是因为我的 vim 配置实在是太大了。改语言如果没有解决我的本质问题，那我就没有必要改。

首先， lua 和 vimScript 一样是动态语言， vimScript 更加半吊子， lua 还好，但用 lua 配置 nvim 我觉得还是有点折腾。 lua 的面向对象还是挺半吊子的，虽然比 vimScript 要好。如果你不是在写插件的话，单纯作为配置的话，你就会发现，你实际上是在写一个 lua 化了的 vimScript 。虽然有人觉得这样好很多，但我觉得这只是套了一层皮，远不如直接用 vimScript 来得直观好写。

除此之外， lua 比起 vimScript 还是很尴尬的， vimScript 是作为 vim 专有语言，而 lua ，虽然 nvim 把它提到了很高的高度，但除非它跟 elisp 之于 emacs 一样，否则 lua 的位置一直会是很尴尬的。

而且你在写脚本的时候很爽，一旦当你想要在命令模式下调用的时候，你写起来就很麻烦了，作为 vim 的亲儿子， vimScript 在这方面的优势是得天独厚的。

## vimScript 的归 vimScript ， lua 的归 lua

我自己在重新整理 nvim 时，对于 vimScript 插件和 lua 插件的配置进行了分别的处理。 lua only 的插件用 lua 配置， vimScript 的继续用 vimScript ，不必蹩脚的将两人糅合。全部用 lua 并没有让我觉得特别方便，相反，lua 与 vimScript 之间的交互反而是比较麻烦的事，即使 nvim 团队给 lua 加再多语法糖也不能解决。

vimScript 作为一门 DSL ，在配置 vim/nvim 方面是很有优势的，但 vimScript 本身效率十分底下，孤儿 nvim 采用 lua 本质上是希望能提高运行效率的。就我个人而言，可能 vim9Script 倒是有希望着力解决这个问题， nvim 即使用着 lua 也不可能舍弃 vimScript 的。所以，我个人倒是希望 nvim 能够采用 vim9Script 。

其实目前我用下来，很多 lua 插件质量其实一般，但是因为 lua 速度快而有很多人用它。我觉得很多老牌的 vimScript 插件都还是很能打的。我个人觉得不应该盲目追求 lua 或 vimScript ，还是应该以实际体验为主去选择插件。
