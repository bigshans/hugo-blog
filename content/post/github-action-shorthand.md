---
title: Github Action 使用速记
date: 2021-11-23T18:07:24+08:00
draft: false
categories:
- 编程随笔
tags:
- Github
- CI
---

最近尝试搞一下 Github Action ，因为看到别人搞了一下，用起来挺方便的。先说一下使用的体验，首先速度比不上用自己电脑编译，但胜在方便，比较大的编译最好还是本地来处理， Github Action 提供机器性能有限，像代码检查、小项目编译、小型定时任务这些还是很不错的。

## 编写 workflows

我目前给两个库编写了 Github Action ，一个是 emacs-git 的打包，另一个 PPet 的打包，前者比较有代表性。

创建 Github Action 需要创建隐藏目录 `.github` ，我创建了 `main.yml` 到 `.github/workflows` 下面。

`main.yml` 文件：

``` yml
name: Github Action Build PKGBUILD
on:
  push:
  schedule:
    - cron: '0 8-21 * * *'
jobs:
  build_for_arch:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          ref: ${{ github.head_ref }}
      - name: GNU Emacs. Development master branch.
        uses: antman666/build-aur-action@mine
        with:
          repo-name: emacs-aur
      - uses: ncipollo/release-action@v1.8.6
        with:
          allowUpdates: true
          tag: "v29.0.50"
          artifacts: "./*.zst"
          token: ${{ secrets.GITHUB_TOKEN }}
```

Github Action 就是根据 yaml 文件创建对应的 CI 任务的。这里我创建了一个 `cron` 定时任务，且该任务在仓库被 push 的时候也会被触发。任务的具体内容由 `jobs` 来定义。

`runs-on` 代表任务的运行环境， `steps` 代表具体的步骤。下面的内容你可以看到 `uses` ，这个代表一个别人已经写好了的 Github Action ，我们使用 `uses` 并补充对应的参数就可以启动任务了。

`actions/checkout@v2` 是用来修复 Github Action 分支切换问题的， Github Action 无法直接拉取到分支内容，于是先用这个来做个 workaround 。

`antman666/build-aur-action@v1.8.6` 是用来构建 AUR 包的。

`ncipollo/release-action@v1.8.6` 是用来发布构建好的包的。

## 具体感受

我是尝试过内核自动构建，但编译速度太慢，还不如我自己手动编译。频繁更新的 emacs-git 是相当好用，而 PPet 包则一般般，只不过自己懒得在自己电脑上处理，交给 Github Action 还是很方便的。
