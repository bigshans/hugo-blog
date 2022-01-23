---
title: coc-kite-cmp 发布
date: 2022-01-23T19:10:42+08:00
draft: false
tags:
  - vim
  - coc.nvim
  - kite
  - typescript
categories:
  - vim
---

最近在尝试 AI complete ，主要是 TabNine 和 Kite ，两者可以基于本地代码作出较好的智能推测。在 VSCode 上，两者都有对应的插件，但在 Vim 上时，情况就不同了。我使用的是 coc.nvim ，作为我的补全框架， TabNine 有 coc-tabnine ，但 Kite 的 coc-kite 与 VSCode 上的不一致。于是我决定手动解决这个问题。

## 编写 coc-kite-cmp 插件

coc 插件编写其实并不是一件难事，我准备依照 coc-tabnine 和 VSCode 上的 Kite 插件自己写一个 Kite 的支持。

首先， coc 本身的框架与 VSCode 的插件框架是极其相似的。然后我又对比了 coc-kite 的源码——实际上并没有源码，只有打包好之后的 npm 包——发现原 coc-kite 仅仅支持了 Python ，而 Kite 本身对 Python 是全支持，除此之外的其他语言，是部分支持的。由于我要的仅仅是补全，所以其他的功能我也不需要，接下来的工作就很清晰了。

原先的 coc-kite 是使用了 `vscode-languageserver-protocol` 这个包的类型，可能是历史原因吧，毕竟有一年多没有更新了，而我就改用了 `coc.nvim` 包里的内容。除此之外， `coc.nvim` API 也发生了变化， coc-kite 里面的代码不少需要重新调整。这里面最烦的当属网络问题， `Kite-API` 的 `requestJSON` 方法不能正常使用， `axios` 也是，最后我发现 `coc.nvim` 自己提供了一个 `fetch` ，又折腾了一会儿才万事大吉。

## 感想

最后的效果还是可以的， Kite 的提示可以在更多文件上出现，不过比起原来 coc-kite ，在 Python 的支持上弱了许多，如果需要更好的 Python 支持，而不是单纯智能补全，那建议使用 coc-kite 。

最后仓库： [coc-kite-cmp](https://github.com/bigshans/coc-kite-cmp) 。

已经上传 npm 需要安装直接运行 `:CocInstall coc-kite-cmp` 即可。
