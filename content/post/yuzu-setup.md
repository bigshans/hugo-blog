---
title: 使用 yuzu 模拟器玩《月姬R》
date: 2021-09-12T10:53:17+08:00
draft: false
tags:
- linux
categories:
- linux
---

最近想要玩《月姬R》。目前，《月姬R》发布在了 PS4 和 Switch 上面，所以我在想能不能用模拟器去运行《月姬R》。简单查找了一下，发现了 yuzu ，嗯， Linux 下可运行的 Switch 模拟器。不错，就它了！

## 准备工作

我个人使用 Arch ，由于 CN 源里有，所以就不用我大费周章去编译了。但仍然还是有些东西需要准备的：

- 由于是商业作品所以需要密钥
- 《月姬R》Switch 版

## 获取密钥

没有密钥其实 yuzu 也可以运行，但某些游戏会被限制。如果你想玩某些商业游戏的话，密钥是必不可少的。

如果你自己制作密钥，你需要准备一台 Switch 。当然，其实你也可以到网站上去找，我是在 Reddit 的[一个帖子](https://www.reddit.com/r/NewYuzuPiracy/comments/mbydcu/complete_guide_for_maximum_performance_on_yuzu/) 上找到了一个密钥，这个帖子还有详细的一些配置教程，建议可以看一下，不过需要魔法才行。关键是下面这段密文：

    aHR0cDovL3d3dy5tZWRpYWZpcmUuY29tL2ZpbGUvbGRzYmNza2J0MHoxMGt2L3Byb2Qua2V5cy9maWxl

可以自行解密下载。

文件下载后，需要放到 `~/.local/share/yuzu/keys/console.keys` 位置。

## 打开 yuzu

如果你没有加入密钥的话，打开会一个警告提示，忽略它也没事，如果你真的在意的话，你需要按照我上面讲的内容去获取密钥，当然，如果你要玩《月姬R》的话，你必须去做。

打开后如果没有任何游戏添加，就会是一个空空窗口，点击添加，然后选中我们放《月姬R》的目录即可。

最终效果：

![展示](/post/img/tsukihime.png)

然后就可以愉快地啃生肉了（不是
