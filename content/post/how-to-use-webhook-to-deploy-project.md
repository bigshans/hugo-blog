---
title: "如何使用 Webhook 来实现自动部署项目"
date: 2020-11-15T18:30:45+08:00
draft: false
tags:
 - webhooks
 - nginx
 - php
categories:
 - 自动部署
---

自动部署是个很香的想法，你只需要把代码一推，然后系统就可以自动的帮你完成繁琐的部署流程，前提你的部署流程足够的程式化。

在上家公司我也体验过自动部署，本质上是推代码时自动触发脚本运行。他们是使用 `K8S` 实现的，而我现在一台可怜巴巴的服务器，这样的配置太重了。于是， Webhook 就很适合我的场景。

我的主要需求是推一些静态页面到我的网站页面下，我查询了一些资料大概有了一些方案，并实践成功，在此与大家分享一下。

## 在服务器上部署自动部署服务

所谓的 Webhook 就是由 Github 触发某个事件时，自动的向部署服务器发送一条请求。部署服务器在验证请求后开始相应的服务。

这里我们需要简单搭建一个自动部署服务，在这里我使用的是 PHP 。 当然，这里你也可以用 Ruby 、 Python 、 Nodejs 、Go 等你看着顺眼的语言写。我们先安装好 PHP，安装好 php-fpm ，接着写一个 deploy.php 。

```php
<?php
    echo phpinfo();
?>
```

咳咳，我们要先试试，先不要急。

然后我们配置一下 nginx 。

```conf
location ~ \.php$ {
   root /var/www/html;
   fastcgi_pass unix:/run/php/php7.3-fpm.sock;
   fastcgi_split_path_info ^(.+\.php)(/.*)$;
   include fastcgi_params;
   fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
   fastcgi_param  HTTPS              off;
}
```

访问一下我们的服务器应该出现 `phpinfo` 的信息。

![这是我本地的图片](/post/img/phpinfo.png)

然我我们编写正式的 deploy.php 。

```php
<?php
$secret = "Your Secret";
$path="you web path";
$sig = $_SERVER['HTTP_X_HUB_SIGNATURE'];
if ($sig) {
    $hash = "sha1=".hash_hmac('sha1', file_get_contents("php://input"), $secret);
    if (strcmp($sig, $hash) == 0) {
        echo shell_exec("cd {$path} && git checkout -- . && git pull && .sh ./deploy.sh");
        echo "Success";
        exit();
    }
}
http_response_code(404);
?>
```

保存代码就可以了。

接下来我们到 Github 去配置 Webhooks 。

## 在 Github 上配置 Webhook

首先我们得有个仓库，我们到设置里去。

首先先配个 Deploy Key ，因为我是私人仓库， pull 和 push 都有限制。基本上与添加自己的 key 一致，我就不多赘述了。

然后开始配置 Webhook ，点击 Webhooks ，再点击添加 `Add Webhook` ，进入到如下页面。

![](/post/img/add-webhook.png)

Payload URL 就填写我们自己的 deploy.php 的请求地址即可。Secret 要与我们在 deploy.php 里的保持一致。

其他的你可以按需配置一下。然后，点击 `Add webhook` 就大功告成了。此时的 Webhook 就会发一个请求跑一下，如果返回结果没有问题，我们的配置就成功了。

## Enjoy it!

至此，我们完成了我们的一个简单的 Webhook ，我们还可以做很多的 Webhook 以用于自动化，当然，跟完全的自动化工具没法比较，作为一个小玩意儿还是挺有意思的。