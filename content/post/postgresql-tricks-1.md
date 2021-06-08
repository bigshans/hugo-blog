---
title: Postgresql 创建用户和数据库并赋权
date: 2021-06-08T09:04:01+08:00
draft: false
tags:
- Postgresql
- 数据库
categories:
- Postgresql
---

由于我经常忘记这个该怎么写了（因为不经常用），所以特地记录誊写一篇用来记忆。

## 创建新的数据库用户

先进入到 postgres 用户下，然后用运行 `psql` 进入数据库的命令行下。

1. 创建数据库新用户的命令为：

``` sql
CREATE USER dbuser WITH PASSWORD '<CUSTOM PASSWORD>';
```

2. 创建数据库：

```sql
CREATE DATABASE exampledb OWNER dbuser;
```

3. 将 exampledb 数据库的搜索权限都赋予给 dbuser ：

```sql
GRANT ALL PRIVILEGES ON DATABASE exampledb TO dbuser.
```
