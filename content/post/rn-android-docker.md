---
title: 在 Docker 内编译 React Native
date: 2021-02-21T18:57:43+08:00
draft: false
tag:
- docker
- react native
categories:
- docker
---

每次 Android Studio 升级，打开后总会带着 Android SDK 升级，还有我的 Gradle 、 Java ，然后就不能正常编译了，很烦。于是我决定搞一个 Docker 来让编译环境保持一致。

## 选择 Docker 镜像

其实 React Native 的镜像已经有人搭建好了，并上传到 Docker Hub 上了。我看了看目前热度比较高的几个镜像，并尝试了一下，最终在 reactnativecommunity 和 theanam 中进行抉择。其实前者更新更频繁一些，但 pull 下来镜像有 5G 多，所以最后选择了 theanam 的镜像。

把镜像拉下来后，尝试了一下编译，发现了一些问题，调整了一下代码，最终成功编译起来了。

## 目录权限问题

当我完成编译之后我发现，我的目录权限被改成 root 了。然后我上网搜索了一下，发现是 Docker 引起的，然后在 mac 下不会有这个问题（要死啊）。

既然这样，那这应该是由来已久的问题，已经有不错的解决方案吧，幸运的是，我找到了。

我使用 gosu 进行 work around 。

我基于 theanam 写了个 Dockerfile ，重新 build 了一下还可以，运行后权限也没有改变。

下面是我的地址：[rn-android](https://github.com/bigshans/rn-android)

欢迎大家 Star ！
