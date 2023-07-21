---
title: read 在 zsh 和 bash 下的不同
date: 2021-10-22T14:13:51+08:00
draft: false
tags:
- Bash
- Zsh
categories:
- Linux
---

不实际进行使用我还注意不到这个区别，就是 `read` 这个命令在 zsh 和 bash 下是不同的。

## 缘起

起因是我在脚本里写的两个命令同时都用了 `read` ，区别在于一个是封装在 bash 脚本里的，另一个是封装成 zsh 函数。因而当我使用 `-p` 参数的时候， zsh 就会报错给我 `read: -p: no coprocess` 。

当我反复确认没有拼写上的问题，我就确信这应该又是 zsh 和 bash 有区别的锅。

## 区别

在 zsh 中， `-p` 意味着从一个协程读取输入，而 bash 则意味着一个提示，因此 zsh 会报 `no coprocess` 的错误。

假设我们的 bash 语句为

``` bash
read -p "What are you doing?" message
```

则 zsh 得改成

``` zsh
# 这是 zsh
read 'message?What are you doing?'
```

然后问题似乎是解决了。

## 更舒服的选择

但是当你尝试在你的输入中左右移动时，你有会发现你无法在 zsh 里移动。而在 bash 里你需要添加 `-e` 参数。

``` bash
read -p "What are you doing?" message
```

可惜的是， zsh 并不兼容，但这个时候有一个很好的替代： `zle` 。使用 `zle` 的 `vared` 来替代 `read` ，还可以有更好的体验。

``` zsh
# 这是 zsh
vared -p 'What would you like to do?: ' -c tmp
```

## 结语

虽然是个小问题但真正遇上的时候就真的是焦头烂额，还好有处理方法。关于 zsh 与 bash 的不同，在 zsh 自己的文档已经很详细了，详情使用命令 `man zshbuiltins` 查看。当然，自己搜索网页也是可以的。
