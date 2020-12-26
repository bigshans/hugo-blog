---
title: 初识 React Native （一）
date: 2020-12-02T21:26:09+08:00
draft: false
toc: true
tag:
 - React Native
 - React
 - Android
categories:
 - React Native
---

公司目前在用 RN 在开发 PDA 上的项目，我来来回回也写了很多次，虽然说也不是很清楚 RN 到底是个什么玩意儿，但摸得差不多了。今天我们就来正式认识认识 RN 。

## 跨平台方案

手机 App 一般会有以下这两个问题：
1. 存在这不同手机系统平台机制不同，导致操作没法统一的情况。
2. 存在手机需要热更新的情况。

由此，诞生了三种方案。一种是 Hybird 解决方案，一种是 Flutter 解决方案，剩下的一种是 React Native 解决方案了。

### Hybird 方案

Hybird 解决方案就是混合方案，该方案就是调起平台上 WebView 加载网页，展示 Web 页面来克服以上的问题。

优点很明显，借助了 H5 的表现力和网页加载的灵活性，但缺点也很明显，调用 WebView 是个非常重的操作，通常会有几百毫秒的延迟，性能不佳。

### Flutter 方案

Flutter 是有 Google 提出的一套解决方案，他们重写了一套与平台无关的引擎，并用了一种新的语言 Dart 。组件的绘制都将由 Flutter 的引擎来完成，最大限度的保持各个平台的一致性，同时性能也是接近原生的。

不过缺点也是有的，目前生态不够完善，仅仅靠 Flutter 提供的组件还不足以满足需求，而且需要另外学一门语言，学习成本比较高。

### React Native 方案

React Native 是由 Facebook 提出的一套解决方案，也是 React 系列的一部分。React Native 使用 React 编写 Native 程序，由 React 底层提供一致的抽象，保证各个平台的一致性，性能也是接近原生的。

同时，React Native 借助了 React 的生态，发展也比较成熟了，很多问题都有了解决方案。

但是缺点也有的，不能完全不受原生依赖的影响，必要的情况下仍然需要原生来帮忙。同时 React 为了确保一致性，阉割了一些原生的能力，同时有一些能力是平台特有的，React 这方面做的还不是很好。

## 为什么使用 React Native

第一点，React Native 性能比 Hybird 好，生态比 Flutter 成熟。

第二点，如果你熟悉 js 和 React 的话， React Native 的开发效率也是很快的。

第三点，React Native 借助 code-push 等工具可以很方便的实现热更新。

## React 与 React Native 的异同

有趣的是，这两点我在刚上手的时候并没有搞懂，常常搞混，知道最近才搞清楚一点。

首先，它们原理是一样的。

![](https://pic4.zhimg.com/v2-990aa3a1c34a8e1b956baaa00b4ca9db_r.jpg)

二者都是基于 JSX 转译为 VirtualDOM ，React 会将 VirtualDOM 转换为对应的 Browser DOM ，而 React Native 会通过 JSBridge 转译为平台原生代码。React Native不使用HTML来渲染App，但是提供了可代替它的类似组件。**这些React Native组件映射到渲染到App中的真正的原生iOS和Android UI组件,意味着你不能重用之前使用ReactJS渲染的HTML, SVG或Canvas任何库。**

未完待续。
