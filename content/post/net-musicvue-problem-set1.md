---
title: webpack 的 require 和 import 相关的一点问题
date: 2018-08-26 12:41:45
tags:
 - javascript
 - electron
 - vue
categories:
 - netcloud-music

---

今天继续用 electron-vue 写 NeteaseCloudMusic 的第三方 app， 用的 NeteaseCloudMusicApi 使用起来却很麻烦。不知道为什么之前可以正常使用，现在却不行了，摸索了好久，还是没能解决。不过还是有点收获的，接下来讲一讲。

<!--more-->

## import 和 require 混用问题

很麻烦的问题，不过很好解决。一般会报错显示 `Cannot assign to read only property 'exports' of object '` 。

首先 webpack 不支持两者混用，分开用还是没有问题的，你可以选择将两者同意改为 require 或 import ，但我这里有问题，express 不支持用 import 但 electron-vue 使用 es6 的语法，改两个都不可能，所以只能寻求他法。

那么就用 babel 将 import 解释为 require 吧！

我使用了插件去解决 babel-plugin-transform-es2015-modules-commonjs ，具体命令项目里有。

安装：
```shell
npm install --save-dev babel-plugin-transform-es2015-modules-commonjs
```

在 .babelrc 里：

```json
// without options
{
  "plugins": ["transform-es2015-modules-commonjs"]
}

// with options
{
  "plugins": [
    ["transform-es2015-modules-commonjs", {
      "allowTopLevelThis": true
    }]
  ]
}
```

编译运行这个错误消除。

## require 内使用 path 的问题

会报这个错误 Uncaught Error: Cannot find module "." 。

当你这么写的使用会报错：

```javascript
var path = 'path/to/file.js' 
require(path) // Error: Cannot find module "."
```

这个问题在 [issues](https://github.com/webpack/webpack/issues/4921) 里有解，改为以下这个就行：

```javascript
require(`${path_to_file}`);
```

electron-vue 有个 __static ，我需要用这个 require 一些 js 。

## 动态 require

这个问题会显示 cannot find module 。我没有什么好的解决方法，主要原因是 webpack 不支持动态 require ，如果你在运行时构造字符串用 require ，就会报错，建议提前 require，一次性 require 完就好了。webpack 打包完后就已经读完了 require ，所以动态读取的没有 require 的，就不会在 modules 里，自然会报 cannot find module （吐血）。

只能是把 NeteaseCloudMusicApi 稍（大）微（幅）重构一下（我算是知道了 ieaseMusic 那个 server 模块为什么疯狂 use 。）。



我用 electron-vue 各种吐血，凡是涉及到一些 nodejs 层面的东西总是很无力， webpack 打包是不是对 nodejs 很不友好？不过即使如此依旧得继续写，越折腾得到的越多~~，也越想摔电脑~~。
