---
title: "在 Lazada App 里面打开链接"
date: 2023-02-28T17:57:44+08:00
markup: pandoc
draft: false
categories:
- 爬虫
tags:
- 爬虫
---

由于需要爬 Lazada 的销量信息，所以我不得不在手机上进行爬虫。麻烦的是，PC 的链接虽然可以在移动端打开，但不能跳转进 App ， App 分享的链接虽然可以跳转，但让业务方在手机端复制分享链接再给到我，对他们而言也是不小的工作量。做 RPA 数据爬取本来就是为了帮他们减少负担，这样反倒适得其反。所以，还是得研究研究，能否直接从 PC 端的链接，直接跳转到 App 内部。

## 分析

首先，在移动端 App 内，我们可以通过扫描 PC 端详情页上的二维码进入特定详情页。这就说明，在 App 内部，是存在一个可跳转的 Activity 的。通过扫描二维码，发现内容就是 PC 端地址。由此可以大胆猜测，这里跳转的数据，就是链接地址，而且是对外暴露的。复制链接可以跳转，肯定是走了一个中间的跳转页，然后回调对应 App 的地址。

我首先尝试了一下 `scheme` 的方式打开，不行。然后解包 Lazada 的 App ，在 `AndroidManifest.xml` 里找对应的 Activity ，最终找到了 `com.lazada.activities.ForwardActivity` ，是 `exported` 为 `true`，里面有 `intent-filter` 刚好符合要求。只要能够正常 `intent` 过去就行了。个人感觉，就跟调用浏览器一样，我试了试手机上的浏览器，打开都没用。最后用微信内置的浏览器打开，打开还是老样子，但微信有一个选项是在浏览器里打开，我一点，页面就跳到了 Lazada 内部的详情页去了。

于是大致方案就清晰了。

## 解决

我本职不是安卓，只是略有涉猎。做这个 App 主要就是为了方便跳转。简单画了两个组件，中间还遇到 Gradle 的问题，最后放弃 Android Studio 内置的 Gradle 就好多了。Gradle 的问题我遇到好几次了，挺烦的。功能代码就一个监视器。

```java
binding.navBtn.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View view) {
        String lazadaActivity = "android.intent.action.VIEW";
        String url = binding.url.getText().toString().trim();
        try {
            if ("".equals(url)) {
                return ;
            }
            Intent intent = new Intent(lazadaActivity);
            intent.setData(Uri.parse(url));
            startActivity(intent);
        } catch (Exception e) {
            System.out.println(e);
        }
    }
});
```

Build 完后成功跳转。

## 最后

不得不说，Lazada 的反爬是做得真绝，宁杀错，不放过，不愧是阿里的产品。我正常使用都遇到几次滑块验证，难怪市面上 Lazada 爬虫那么少见。
