---
title: rinted 做端口转发
date: 2020-02-15 12:49:19
tags:
- linux
- rinted
categories:
- linux
---

因为腾讯云的 Mongo 和 Redis 都是内网的地址，不能访问，官方说内网进行内网转发就行，于是就用 rinted 做了一个内网转发。

<!--more-->

## 安装 rinted

由于是 Debian 系统，源里有就可以直接安装。

```sh
apt install rinted
```

## 配置

配置文件也很简单，按照如下个格式配置就好了。

```conf
# bindadress    bindport  connectaddress  connectport
```

成功之后用 Mongo 连一下，畅通无阻。