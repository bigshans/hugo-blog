---
title: "添加以词定字与汉字部件拆字反查到 Rime 中"
date: 2024-08-04T14:41:07+08:00
markup: pandoc
draft: true
tags:
 - Rime
categories:
 - Rime
---

在 Linux 使用 Rime 已经有大概四五年的时间了，我个人做的 rime-zrm 方案一直用到现在，已经是相当习惯了。我原来的方案存在许多问题，一直没有解决，比如说字序的问题，一些生僻字莫名其妙得排到前面来，原因很简单，因为编码的问题，一些词频并不能很好地被应用，于是默认就会遵循该词出现的顺序。为了处理这个问题，我首先找到了一份常用汉字的字表，将将一级汉字赋值为 `1` ，二级汉字赋值为 `2` ，剩下找不到的赋值为 `3` ，然后将字表重新排序。最后出来的效果比之前好了不少。

以词定字是一个相当诱人的功能，我也垂涎许久了。 [BlidingDark](https://github.com/BlindingDark/rime-lua-select-character) 的脚本我看过，并尝试配置使用，但始终无法很好地使用。于是我改用了 [rime-double-terra](https://github.com/Reniastyc/rime-double-terra) 的以词定字脚本。但在配置完成并使用的期间，我发现这其中存在一些 bug 比较影响使用，于是我尝试修复了一下，现在效果好了很多。

另外就是反查功能，原本使用 stroke 进行反查，但我完全不用，因为根本不好用，所以现在改用了 [radical_pinyin](https://github.com/mirtlecn/rime-radical-pinyin) ，效果杠杠的。

其他的就是一些优化工作，一个辅码展示不太好的问题，主要是放置位置的问题，当我把 `second_code_filter` 放到 `uniquifier` 之后，效果就很好了。
