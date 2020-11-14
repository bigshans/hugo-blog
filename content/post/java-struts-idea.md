---
title: 在 idea 中布置 struts 2.5
date: 2018-09-06
tags:
- java
- idea
- struts 2
categories:
- java
---
不得不说百度跟谷歌比还差的远啊。我从官网上下载 struts 的最小包，布置到 idea 上不能正常使用，百度不行上谷歌，终于解决了。
<!--more-->

## 建立 struts 2 工程

- 新建工程，选择 struts 2 工程，下面选择 later 。
- 建好之后，在 web/WEB-INF 下创建 lib 和 classes 文件夹，将 struts 相关包放到 lib 里。打开 Project Structure ，选择 Modules ，开始配置库。
- 选择 Dependencies ，点旁边加号，使用选择 JARS or Directries 选择 lib 文件，然后勾上这里的库。
- 选择 Path ，选第二项，将两个文件夹都改为 classes 文件夹，下面勾勾掉。这里这一步可选。
- Problems 出现错误，点进去，再点 Fix 。

这样差不多可以了接下来修改一下配置文件。

## 配置修改

- 选择 web.xml 文件，将 filter 里的 .ng 去掉，不再变红无报错。
- 到 index.jsp 里加入 taglib ，无报错。
- 点击运行无报错，出网页。

以上就是在 idea 里配置 struts 的过程。