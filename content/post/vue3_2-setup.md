---
title: Vue 3.2 <script setup> 摘要
date: 2021-08-26T15:43:34+08:00
draft: false
tags:
- javascript
- vue
categories:
- javascript
- vue
---

在 Vue 3.2 发布的内容中，最主要内容就是 `<script setup>` 。 `<script setup>` 想必大家都有使用过，跟当初作为实验特性不同，这次正式发布还是有很多的修改的。

## 废除 `useContext()`

原先获取全局 `ctx` 的方法就是 `useContext()` ，现在不行了。 Vue 还是希望用户摆脱全局变量的使用，进而使用 `useXXX` 代替。利弊各有吧，总体来说利大于弊。

## 变量导出

`<script setup>` 默认会将所有变量导出到 template 里，但没有 `ref()` 、 `reactive()` 的变量不能实现响应式，我记得原先是只能导出响应式的变量。好处就是减少了无意义的响应式变量，但代价是过多的变量直接涌到了 template 里。

## Top-level `await`

新加入的特性，除了 `Suspsend` 是实验特性外，其他都很好。 `async setup()` 早就有了。

## 命名空间组件

某种意义上确实挺方便的。

## `defineProps` 和 `defineEmits`

`<script setup>` 专用编译宏。套在 ts 上极其舒适， `props` 终于不用像之前那样要写两套类型了！

## 与普通 `<script>` 一起使用

某种意义上是作为补充，以弥补 `<script setup>` 做不到的事。

## 总结

总体看下来，这次正式版主要强推 `<script setup>` ，它真正意义上推进了组合式 API ，代码组织也能够更简洁，应该是大方向所在。不过确实挺像 React 的，只能说好的设计总是趋同的，嗯！
