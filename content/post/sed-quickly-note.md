---
title: 'sed 速记'
date: 2022-02-16T17:11:39+08:00
draft: false
tags:
  - sed 
categories:
  - Linux
---

`sed` 命令是一个强大的、基于行的文本处理命令，它仍被广泛使用。 `sed` 借助正则表达式对文本的某行进行增删改查。

## 基本格式

```
sed [options] {script} [input file]
```

## 增

```shell
cat pets.txt
# output:
# This is my cat
#   my cat's name is betty
# This is your dog
#   my dog's name is frank
# This is my fish
#   my fish's name is george
# This is my goat
#   my goat's name is adam

sed "/fish/a I like fish too" pets.txt
# output:
# This is my cat
#   my cat's name is betty
# This is your dog
#   my dog's name is frank
# This is my fish
# I like fish too
#   my fish's name is george
# I like fish too
# This is my goat
#   my goat's name is adam
```

我们可以看到文本会被添加到匹配行的后面，如果想要将文本插入到行前面，则使用 `a` 参数。

```shell
sed "/fish/i I like fish too" pets.txt
# output:
# This is my cat
#   my cat's name is betty
# This is your dog
#   my dog's name is frank
# I like fish too
# This is my fish
# I like fish too
#   my fish's name is george
# This is my goat
#   my goat's name is adam
```

`sed` 脚本在这里的基本格式是 `/匹配/操作 追加内容` ，其中操作有 append （`a`）和 insert （`i`）。

## 删

```shell
sed "/fish/d" pets.txt
# output:
# This is my cat
#   my cat's name is betty
# This is your dog
#   my dog's name is frank
# This is my goat
#   my goat's name is adam
```

删除相对来说就简单许多，基本格式为 `/匹配/d` 。

## 改

改的情况就比较多了，首先是最基本的情况。

```shell
sed "s/my/your/" pets.txt
# output:
# This is your cat
#   your cat's name is betty
# This is your dog
#   your dog's name is frank
# This is your fish
#   your fish's name is george
# This is your goat
#   your goat's name is adam
```

基本格式为 `s/匹配/替换/` ，需要注意的是，最后的 `/` 不能省略，因为后面其实还预留了参数的位置。

```shell
sed "s/my/your/g"
```

我们还可以先匹配特定行，再对行内进行匹配替换。

```shell
sed "/fish/s/my/your/" pets.txt
# output:
# This is my cat
#   my cat's name is betty
# This is your dog
#   my dog's name is frank
# This is your fish
#   your fish's name is george
# This is my goat
#   my goat's name is adam
```

基本格式为 `/行匹配/s/行内匹配/替换/[参数]` ，s 往后的部分基本与之前一致。

我们也可以指定范围进行匹配。

```shell
sed "3,\$s/my/your/" pets.txt # 第三行到最后一行
sed "3,4s/my/your/" pets.txt # 读三行到第四行
```

## 总结

TLDR：

```shell
# 增
sed "/fish/a I like fish too" pets.txt
sed "/fish/i I like fish too" pets.txt

# 删
sed "/fish/d" pets.txt

# 改
sed "s/my/your/" pets.txt
sed "/fish/s/my/your/" pets.txt
sed "3,\$s/my/your/" pets.txt # 第三行到最后一行
sed "3,4s/my/your/" pets.txt # 读三行到第四行
```

不过以上内容你会发现它是直接输出而不会修改实际文件，可以选择重定向文件或者使用 `-i` 参数。

```shell
sed -i "/fish/a I like fish too" pets.txt
sed "/fish/i I like fish too" pets.txt > pets.txt
```
