---
title: 安装 graph-easy
date: 2018-09-03 17:34:16
tags:
- Linux
- Perl
- Graph-easy
categories:
- Software
---
推荐一个软件， graph-easy  。如果你查看文档的话，经常能看到一些 ascii 码流程画，个人觉得非常酷，于是去查找了一下，发现了这个软件。下面我将做一些简单的介绍。
<!--more-->
## 安装

首先要安装 graphviz 。

``` shell
sudo apt install graphviz
```

安装完成之后，用 perl 的 cpan 来进行安装， linux 下默认有。

``` shell
cpan # 安装 capn
sudo cpan Graph:Easy # 安装 Graph Easy
```

如此在 linux 下便安装好了 Graph Easy 。

## 使用

使用用 graph-easy 命令。

我们来写个简单命令试试。

```shell
graph-easy <<< '[a]->[b]'
```

结果：

```
+---+     +---+
| a | --> | b |
+---+     +---+
```

画个分支：

```shell
graph-easy <<< '[a]->[b]->[c][b]->[d]->[e]'
```

结果：

```
+---+     +---+     +---+     +---+
| a | --> | b | --> | d | --> | e |
+---+     +---+     +---+     +---+
            |
            |
            v
          +---+
          | c |
          +---+
```

加入说明：

```shell
graph-easy <<< '[a]->[b]->{label:"true";}[c]->[d]->{label:"FeedBack";}[a]'
```

```
      FeedBack
  +---------------------------------+
  v                                 |
+---+     +---+  true   +---+     +---+
| a | --> | b | ------> | c | --> | d |
+---+     +---+         +---+     +---+
```

改变方向：

``` shell
graph-easy <<< 'graph{flow:south;}[上]->[中]->[下]'
```

```
+---+
| 上 |
+---+
  |
  |
  v
+---+
| 中 |
+---+
  |
  |
  v
+---+
| 下 |
+---+
```

## 手册地址

最后给个 Graph Easy 的手册地址：[手册地址](http://bloodgate.com/perl/graph/manual/index.html) 。