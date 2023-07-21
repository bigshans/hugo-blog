---
title: 写个简单的 QOS
date: 2020-01-27 21:58:14
tags:
- Node
- 后端
categories:
- 后端
---

最近客户端发生了 bug ，导致我们的服务被疯狂请求， QPS 高达 1000 ！数据压力很大，tjt 让我写个 qos ，就是限制接口访问次数，我粗略写了个，还可以。
<!--more-->
``` js
async function QOSLimit(inject) {
    let user = inject.auth;
    let keyName = 'QOS_' + user.userId;
    let key = await redisClient.getAsync(keyName);
    if (key) {
        if (parseInt(key) >= 3) {
            return false;
        } else {
            redisClient.incrAsync(keyName);
        }
    } else {
        redisClient.setAsync(keyName, 1, 'EX', 1);
    }
    return true;
}
```
数据库压力巨减。
