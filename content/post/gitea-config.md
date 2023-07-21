---
title: '搞定了几个 Gitea 相关的问题'
date: 2022-03-19T00:52:32+08:00
draft: false
tags:
  - Gitea
categories:
  - Software
---

Gitea 可以同步 Github 仓库之后，让我觉得仓库管理有很大的便利。因为我的很多代码毕竟保存在 Github 上，允许同步 Github 免去了我很多两头跑的工作。

但是有几个我还是不太爽的地方，主要是之前没有配置好。

## http 的 clone 地址改为域名

不知道之前是怎么想的，或者 BUG 得到了修改，总之我简单改了一下 `ROOT_URL` ，然后就生效了， clone 也没有问题。

## ssh 的 clone 地址改为域名

同样是不知道为什么，我之前没能处理好这个问题。其实原因很简单，因为我用 cloudflare 代理了接口，导致我不能直连接口，我可以再写一个 cname ，然后去除 cloudflare 保护就可以了。目前只决定设置这一个，虽然很方便，但不安全。除开他免费的防护，我的机子根本挡不住 DDoS 攻击，所以特殊情况通融通融。

设置完 DNS 之后，改一下 `SSH_DOMAIN` 为对应的 subdomain 就可以了。
