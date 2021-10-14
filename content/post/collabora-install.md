---
title: 安装 Collabora Office
date: 2021-10-14T09:47:19+08:00
draft: false
categories:
- collabora
- nextcloud
- linux
tags:
- linux
---

最近在配置 Nextcloud 的 Office 功能，尝试了一下 OnlyOffice ，实在是太不稳定了。我最终选择了 Collabora Office 作为替代。

首先，极其不推荐使用 Docker 部署，因为 Docker 版已经好久没维护了，其次，如果你使用的是 Debian 、 CentOS 、 OpenSUSE 一系的话，应该是比较好安装的。在这里，我们使用软件包安装。

官网已经有了非常详细的软件包安装过程，我就不再赘述了，但有一些内容需要补充。

在安装完成后，我们需要再配置一下 `loolwsd.xml` ，我们使用 `loolconfig` 来进行。

``` sh
sudo loolconfig set ssl.enable false
sudo loolconfig set storage.wopi.host <your-domain-name>
sudo systemctl restart loolwsd
```

完成了，默认端口是 9980 ，然后添加到你 Nextcloud 配置里就可以了。
