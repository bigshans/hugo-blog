---
title: "userChrome.js 的使用"
date: 2022-08-14T17:56:49+08:00
draft: false
tags:
- Firefox
- userChrome
categories:
- Software
---

userChrome.js 是 Firefox 的一种玩法，可以高度自定义 Firefox 的界面、样式、功能。虽然 XUL 很早就死掉了，但所幸 userChrome.js 仍然是可用的。需要注意的是， userChrome.js 是非正式且冷门的自定义玩法，常常随着 Firefox 的升级而失效，所以，你需要随时 Break 的准备。

## 安装 userChrome.js

我们需要一个 load script 来自动加载各个 `.uc.js` 脚本。

目前还在维护的脚本仓库在 https://github.com/alice0775/userChrome.js 。由于是日本人维护的，所以是日语。在安装前需要确认版本，我的 Firefox 是 Nightly 版，所以尽量往新的选。。

首先，确定自己的 Firefox 所在的目录， Linux 一般是在 `/usr/lib/firefox` 下，而我的是 Nightly 版本，非正式打包的，所以实际上位于 `/opt/firefox-nightly` 下。将仓库目录 `92/install_folder/` 下的 `config.js` 复制到与 Firefox 二进制同级的目录下，再将 `92/install_folder/defaults/pref` 下的 `config-prefs.js` 复制的到 Firefox 目录下的 `/defaults/pref` 下。完成这些后，找到自己的 profile 目录（可以通过 about:profile ）来查看，选择你对应版本目录下的 `userChrome.js` （没有的话，就往前几个版本找），复制到 profile 配置下的 `chrome` 文件夹下，如果没有就自己创建。如此， `userChrome.js` 就安装完成了。

## 安装 userScript

userScript 就是以 `.uc.js` 结尾的 js 脚本，你可以使用已有脚本，也可以自己编写。注意，脚本需要放在 `chrome` 目录下，然后想要脚本生效必须重启浏览器。

调试 userScript 需要浏览器工具箱，使用快捷键 `Ctrl+Shift+Alt+I` 可以打开，你也可以在工具箱里找到它。

与在浏览器内不同的是，在 userScript 中，你将面对整个浏览器界面。你可以通过 js 来对界面进行调整。浏览器升级带来的界面变化会显著影响 userScript 的使用。托马斯潘恩说过：“那些想收获自由所带来的美好的人，必须像真正的人那样，要承受支撑自由价值的艰辛。”想要灵活，就必须要承受灵活的代价。

## 示例

你可以从 userChrome.js 的仓库获取一些脚本，我自己也修改了一个脚本，主要是为了能让侧边栏浮动的，我自己改动得更符合我的心意而已。

Gist: https://gist.github.com/bigshans/be9eb72e6590760a7e3d81f9823d28ed.js
