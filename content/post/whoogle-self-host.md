---
title: 使用 Whoogle 自建搜索网站
date: 2021-05-30T03:40:00+08:00
draft: false
tags:
- whoogle
- searx
- google
- 搜索
categories:
- whoogle
---

准确来说，Whoogle 是一个元搜索引擎，他主要将 Google 的搜索结果过滤，并去除掉其中的隐私追踪部分。与 Whoogle 差不多的另一个网站框架是 SearX ，两者都是自建的元搜索引擎，二者代码都开源到了 Github 上。

Whoogle 与 SearX 相比，更加简单，功能也更加少，且只专注于 Google 的结果过滤。二者都是非常不错的框架，我更倾向于使用简单的 Whoogle 。

网站: https://whoogle.sdf.org

Github: https://github.com/benbusby/whoogle-search

我并没有用上面那个网站，而是自己搭建了一个，毕竟我手头还有一台服务器空着。我自己的网站是不公开的。官方的安装手册，提供了很多种安装方式，基本上就是几行命令的事情，你自己在配个 nginx 就很完美。不过，官方给的都是 root 用户下进行操作，有条件的话最好切换到非 root 用户下进行。

然后就是搜索页，它提供的打开策略我是怎么也不舒服的，于是我写了个油猴脚本专门去处理这个问题，使得它另开标签页打开，而下一页不会打开新表情页。链接我放到下面，请随意取用，自建网站的同学可以修改一下网址匹配和图标。

当然，出于某些你懂的原因，你要是自建的话，你得确保 Whoogle 能访问 Google 。

最后说一下我为什么要这样绕着用 Google 。因为毫无疑问， Google 的搜索是真的不错，我用过 Duckduckgo ，还有其他几个搜索引擎， Google 给我的结果确实是最舒服的。因此，我还尝试了 StartPage 。但是 StartPage 对比 Duckduckgo 来说问题要更多，我使用它搜索莫名其妙地被拦截了好多次，这又迫使我改变我的默认搜索引擎。之所以不用 Google 是因为，第一，我是没有魔法的情况下用不了，第二，我讨厌各种无处不在的追踪。因为第二点情况，我先放弃了 Chrome ，改用 Chromium ，最后迁移到 Firefox 上，放弃使用 Google 搜索，也只是我在对抗隐私追踪的其中一步。现实中会有很多地方诱惑我们放弃对隐私的坚持，但是，只要坚持，你就会发现，即使不放弃隐私，也并不会让我们生活更糟。

脚本地址： https://gist.github.com/bigshans/ab4b797742b4171817436758784d72c7

