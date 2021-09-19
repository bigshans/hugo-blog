---
title: 写一个 Bash 补全函数
date: 2021-09-20T01:33:29+08:00
draft: false
tags:
- bash
- linux
categories:
- linux
---

我的配置文件里面有我以前封装的、用于管理博客文章的命令，只不过之前是用 Hexo ，而现在迁移到了 Hugo 上，已经好久没有了，现在发现，拂拂灰尘用起来还是很带感的，但是没有自动补全总是欠缺点味道，于是我自己写了一个自动补全。

## 关于 `complete`

想要实现自动补全，我们需要借助 `complete` 。 `complete` 可以让我们为某以命令添加、删除、修改自动补全。

`complete` 最重要的参数是下面四个：

| 参数 | 功能                                                       |
| ---- | ---------------------------------------------------------- |
| -F   | 执行 shell 函数，函数中生成 `COMPREPLY` 作为候选的补全结果 |
| -C   | 将 command 命令的执行结果作为候选的补全结果                |
| -G   | 将匹配 pattern 的文件名作为候选的补全结果                  |
| -W   | 分割 wordlist 中的单词，作为候选的补全结果                 |

这里，我们需要动态生成参数，所以使用 `-F` ，写一个补全函数。

## 关于 `compgen`

`compgen` 我们主要用来生成匹配结果。

大概是这么个效果：

``` shell
compgen -W "now tomrrow never" 
# now tomorrow never
compgen -W "now tomrrow never" n
# now never
compgen -W "now tomrrow never" t
# tomorrow
```

## 关于 `COMP_WORDS` 等参数

一共有下面三个参数：

- `COMP_WORDS`：程序后面跟着的参数组成的数组。
- `COMP_CWORD`：当前光标指向的参数在 `COMP_WORDS` 中的位置。
- `COMP_LINE`：当前命令的内容，一个字符串。

我需要其实的不多。

## 开始编写

我的命令是 `gitpage` ，主要参数有 `new` 、 `open` 、`push` 、 `server`  、  `rm` ，其中 `new` 和 `open` 后面还要跟一个目录。

代码最后的成品：

``` bash
function _gitpage() {
    local op=${COMP_WORDS[1]} # 获取 gitpage 的操作
    local suggest=() # 补全结果
    local BLOG='/projects/aerian/mygithub/blog'
    # 参数不能超过三个
    if [ "${COMP_CWORD}" -ge "3" ]; then
        return
    fi
    case $op in
        'new' )
            ;;
        'push' )
            ;;
        'open' ) # 补全与 rm 相同
            # suggest=($(compgen -W "$(ls $BLOG/content/post | cut -d . -f1)" ${COMP_WORDS[2]}));;
            ;&
        'rm' )
        	# 获取所有文章的名字去掉后缀名
            suggest=($(compgen -W "$(ls $BLOG/content/post | cut -d . -f1)" ${COMP_WORDS[COMP_CWORD-1]}));;
        'server' )
            ;;
        * ) # 不完整，以上是补全完整的，完整的且后面无须补全的就不补全
            suggest=($(compgen -W 'new open push rm server' $op))
    esac
    COMPREPLY=(${suggest[@]})
}

complete -F _gitpage gitpage

```

`source` 之后，按 `Tab` 就能补全了，感觉是很不错的。

参考了一下两篇文章：

- https://www.techug.com/post/linux-auto-completion.html
- https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial
