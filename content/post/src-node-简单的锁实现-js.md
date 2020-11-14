---
title: 分布式锁的简单实现
date: 2019-10-20 10:11:38
tags:
- node
- javascript
categories:
- javascript
---

   打算每周写一篇博客，希望每周都能有新的收获。本周写的博客是我在工作中应用写的一个有趣的东西。
   我们采用 pm2 进行进程管理，我们开启了多个进程，但各个进程之间并没有交流，所以，我想要全局操作某个变量时，就会出现数据安全问题，虽然在 redis 里面单个操作是原子，但我也要保证复合操作也是原子的。但我并不使用 redis 的事务，是因为这个事务会阻塞其他操作，所以，不如在应用层上实现锁，从而不阻塞 redis 。我们虽然不是分布式系统，但是是分布式进程，所以实现也参考分布式锁。
   <!--more-->
   我的写法比较简单。
   ``` js
   let lock = getSync(lockName);
   let time = Date.now();
   while (isExpired(time)) {
       if (lock) {
           if (timeOut(lock)) {
               lock = delSync(lockName);
           }
       } else {
           lock = setNX(lockName, Date.now());
           if (lock) {
               // Do something
               delSync(lockName);
               break;
           }
       }
       lock = getSync(lockName);
   }
   ```
   实现是用 node 实现的，大概是这样的，这个循环是有时间限制的，我设置为 5s ，一般来说是够的，运行超过 5s 获取锁基本上说明某个程序出问题了。
   锁需要过期操作，防止某个程序挂掉忘了释放锁的问题，这个时间设置不需要太长也不要太短，5s 以内就足够了。
