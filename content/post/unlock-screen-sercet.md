---
title: 在 root 下去除 MIUI 锁屏密码
date: 2021-04-27T20:20:24+08:00
draft: false
tags:
- 手机
categories:
- 解决方案
---

因为 root 手机忘了锁屏密码，所以想要破解掉。因为手机已经提前 root 了，我本以为这个问题只需要搜一下就可以了，然而搜索的结果却让我大跌眼镜。使用 adb 删除 password.key 或者 gesture.key ，问题是根本没有这几个文件！我把几个 key 文件删了根本没有效果，然后我仔细研究了一下在 /data/system 下的文件，发现有几个名为 locksetting 的 db 文件，怀疑这个才是真正的屏幕锁文件，因为这几个文件看着像是 Sqlite 数据库。于是在 recovery 模式下我删除了这几个文件，重启之后，锁屏密码就去掉了。

嗯，这种事还是多研究一下的好，不然白白清掉数据。
