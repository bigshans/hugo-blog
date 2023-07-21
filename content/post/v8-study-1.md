---
title: v8 学习（一）——编译个v8 好麻烦啊！
date: 2021-07-11T15:14:22+08:00
draft: false
tags:
- V8
categories:
- V8
---

想要学习一下 v8 ，于是就尝试了一下编译 v8 源码，说实话，以国内的网络去做这件事超级麻烦。在折腾一番后，最后决定直接在我的海外服务器上进行编译。

## 安装 `depot_tools`

你不能直接拉 v8 源码编译，你得用 `depot_tools` 下来拉取代码，安装依赖。建议不要用 root 安装，切到有 sudo 权限的用户为好。

第一步是 clone ：

``` sh
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
```

第二步是将 `depot_tools` 加入到路径里去：

``` sh
export PATH=/path/to/depot_tools:$PATH
```

由于是在服务器上操作，我建议最好开一个 tmux 的 session 来保存工作，以避免重复劳动。

## 获取代码

默认运行 `gclient` 就会初始化和更新 `depot_tools` ，然后 `gclient` 是不能在 root 下运行的。 

输入 `gclient` ，输出对应的 usage 界面就说明完成了初始化，接着我们拉取 v8 代码：

```sh
mkdir ~/v8
cd ~/v8
fetch v8
cd v8
```

v8 代码还是很大的。

## 编译和安装依赖

首先下载和构建依赖：

``` sh
gclient sync
```

安装编译依赖，这步需要 sudo ：

``` sh
./build/install-build-deps.sh
```

## 编译 v8

首先到 v8 的目录下，拉取代码和编译依赖：

``` sh
cd /path/to/v8
git pull && gclient sync
```

然后开正式编译，这里用的是 gm：

```sh
./tools/dev/gm.py x64.release
```

运行 `./out/x64.release/d8` ，能够成功运行 `d8` 代表编译成功，然后我们可以从服务器上把我们编译好的结果拿下来了。
