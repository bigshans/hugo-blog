---
title: Pleroma 安装排雷
date: 2021-05-21T22:04:17+08:00
draft: false
tags:
- Pleroma
categories:
- Software
---

安装 Pleroma 倒也不是什么特别难的事，只要照着[文档](https://docs-develop.pleroma.social/backend/)自己安装即可，但是，事情往往并没有你想的那么简单。

Pleroma 是一款基于 Elixir 开发的轻量级的微博系统，而且还支持 Activity Pub 。提到 Activity Pub 大家第一时间会想起 Mastodon ，Mastodon 是基于 Ruby 开发的去中心化的微博系统，在功能上，它比 Pleroma 强上太多，但是最终我为什么没有选择它呢？因为它太吃资源了，我的服务器连最低配置要求都达不到，因此我用 Pleroma 替换了它。

想要安装 Pleroma 一共有三种方法：

1. 源码编译安装。
2. Docker 安装。
3. OPT releases 安装。

三个方法我都试过，我在这里给大家排排雷。

## 源码编译安装 Pleroma

源码编译的好处就是依赖不需要额外冗余一份，但问题就是依赖与系统相关，如果整个系统升级了，就会把依赖给升级了，容易出现不兼容的情况。如果你因为 Pleroma 而不升级系统，那我觉得问题就太大了。

目前，如果你采用源码编译的话，建议你用 VM 管理工具，因为 rebar3 出现了 bug 导致代码编译不过去，你只要把 erlang 降到 23 版本即可，但想装个旧版本哪那么容易想装就装的？

所以，除非你追求性能，否则编译真的不划算，尤其是后期更新的时候，更是心惊胆战。

## Docker 安装

当你使用 Docker 的使用你就不用关心环境了，你到 Docker Hub 上找 Pleroma 的镜像，你会发现这玩意儿配置起来还挺复杂的，但实际上呢，你可以 clone 一份官方 gitlab 的源码，然后你就可以看到有一份 Dockerfile 静静地躺在那里。

那份 Docker 是挺可用的，你需要自己提前准备一份 `prod.secret.exs` 复制到 `config` 目录下，然后构建镜像就可以了，想要运行程序直接运行镜像就可以了。但这里的另一个问题是，因为网络的原因， Postgresql 要支持远程访问。

到最后我也没有成功连上数据库。

## OPT releases 安装

说白了，就是直接下载编译好的文件运行，同时自带了一个 VM ，不用担心依赖问题。相对来说是个折中方案，我个人比较推荐此方案。一来，是系统升级对代码印象较小；二来，体积也比使用 Docker 要轻不少。

不过有一大坑点就是官方给的脚本不能用，像是一下的语句：

```shell
su pleroma -s $SHELL -lc "./bin/pleroma_ctl migrate"
```

会直接报错，建议用这个语句，也是官方的，但在写在别的地方了：

``` shell
sudo -Hu plermoa ./bin/pleroma_ctl migrate
```

## Postgresql

就一句话升级数据库要格外小心，我就在这里跌倒过，Postgresql 的大版本升级很有很有可能导致数据库的内容不可用（心塞的笑容）。

## 结语

Pleroma 的安装其实并不复杂，按照文档上的步骤进行操作基本上没有什么问题。它的文档基本上是英文，算是比较好了（对比 Misskey 的日文文档），而且它还有几个和友好的前端还存在着，灵活性也是很可以的。
