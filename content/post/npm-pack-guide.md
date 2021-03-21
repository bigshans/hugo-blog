---
title: npm 打包指南
date: 2021-03-21T11:53:14+08:00
draft: false
tags:
- npm
- nodejs
categories:
- nodejs
---

最近在修改一些很长时间无人维护的包，估计包作者都不维护了，于是我重新搞了一份传到了 npm 上，有兴趣的可以看一下：[log4js-rabbitmq-appenders](https://www.npmjs.com/package/log4js-rabbitmq-appenders) 。

关于如何打包一个库，其实网上已经有很多教程了，核心其实就是两句命令：

```shell
npm login
npm publish
```

如果你用的是淘宝源之类的镜像源，记得要把源地址改回官方源。登录的话就是在 [npm.org](https://npm.org) 的帐号，如果没有的话就是需要注册，如果没有收到验证邮件的话，建议给官方客服发封邮件询问一下，客服会给你建立帐号的。

其他的其实就是一些细枝末节的东西了。

## 协议

如果你的库想要被更广泛的使用，就使用更宽松的协议，比如 BSD 、MIT 等，如果你想收紧对库的使用的话，就用 GPL 系列的协议。协议这块网上有很多好的建议，可以去看看 [这一篇](http://www.ruanyifeng.com/blog/2011/05/how_to_choose_free_software_licenses.html) 。

## 库支持的语言规范

如果你写一个库，你就应该考虑好你要支持那些语言规范，现在比较广泛的就是 CommonJS 、 TypeScript 、AMD 等，有可能你的库就是基于以上这几个规范中的某一个规范写的，但你接下来可能要支持比这多得多的语言规范。比如说，你的库是用 CommonJS 编写的，但你的库也要支持 TypeScript ，考虑到要让一般用户能够简单使用你的库，你就应该要编写 d.ts 文件。这些情形十分复杂，以至于一些著名库也常常会在此踩坑。

## 调试

由于每次修改了包之后，如果不修改版本号的话，是无法上传新的包。但有时候仅仅是测试，所以，比较好的方法是建立一个仓库，然后每次修改更新到仓库，然后在本地通过仓库地址进行包安装进行调试。为了不影响版本，最好再开一个分支处理。

## 结语

算是为社区作出了一点微小的贡献吧！

##  附：如何编写 d.ts 文件

其实挺简单的，不知道为何我想得如此复杂。

这是我编写的库的 `index.d.ts` ：

```typescript
/// <referencee types="node" />

export const RabbitmqAppenders: any;
```

实际上对应的 `index.js`:

```javascript
module.exports = {
  RabbitmqAppenders: require('./lib/index'),
};
```

但是，如果你使用的是 `export default` 的话，你就会发现，编译后的 js 代码会这样子调用代码：

```javascript
require('You Module').default
```

很恶心，对吧？所以我的处理是单个 `export` 出来，而不是 `export default` 。

另外，这个对应关系，事实上 `index.d.ts` 中 `export` 出来的对象应该要与 `index.js` 里 `export` 出的 结构一样就可以了，只不过多了一些类型说明罢了。