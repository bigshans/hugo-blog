---
title: '如何使用 ja-netfilter'
date: 2022-03-02T21:29:21+08:00
draft: false
tags:
  - Jetbrains
categories:
  - Software
---

之前淘宝卖的 JB 帐号又失效了，连带着服务器也失效了，感觉店家是跑路了。 JB 家的东西是不错的，不过就是一个客户端套多个皮，当成多个 IDE ，让我觉得有点蠢。而且 JB 的价格并不便宜，因为公司并没有替我买，我自己也不想负担——虽然好，我也用，但不是绝对常用的。于是我选择了找破解方法。

ja-netfilter 是个好东西，本质上是个 java 代理，虽然只要让它代理上 IDE 就可以了，但并不是开箱即用的。虽然作者预先做了一些工作，但后面的一些工作还是需要自己完成的。

我们需要在对应的 vmoptions 文件内添加一行代理：

```
javaagent:/the/jar/path=jetbrains
```

然后我们需要将 config 和 plugin 文件夹重命名为 config-jetbrains 和 plugin-jetbrains 。如果你想要起别的名字也可以，但 vmoptions 跟的参数需要与 config 和 plugin 后跟的内容相一致。

之后打开 IDE ，会弹出激活窗口，选激活服务器，填写 https://jetbra.in ，点击激活，能连通就是成功了。如果没有连通，可以看看配置文件的名字是否与 vmoptions 内的一致，一般是这个问题。
