---
title: Arch 打包备忘录
date: 2021-10-30T01:08:44+08:00
draft: false
tags:
- linux
- 打包
categories:
- linux
---

最近又写了一个 PKGBUILD 传到了 AUR 。不过距离上一次打包已经过去很久了，这些包其实许久没有更新了，就到我自己都忘了要怎么打包了。因为一些常用命令经常记不住，所以就简单写一篇记录一下。

## 打包过程中源码所在的位置

源码位于 `srcdir` 下与 `source` 里的文件（夹）同名的位置。最终打包是要放到 `pkgdir` 下的，这个目录下没有文件，那打出来的就是空包。

如果我们要在 `pkgdir` 下建对应系统的目录，用 `install -d "$pkgdir"/<system-dir>` 。安装源码到对应文件也是用 `install` 。举个例子。

``` PKGBUILD
install -Dm644 $srcdir/$pkgname.desktop "$pkgdir"/usr/share/applications/Debugtron.desktop # 文件权限会变成 644
```

## shasum256 生成

一旦涉及到自己打包，这个命令就很常用，但是呢，往往 `SKIP` 更具诱惑力。不过尽量的，能使用验证就使用吧，毕竟为了安全。而且对于一个高质量的包这也是必然的一个步骤，除非你是 git 包经常变动。

``` bash
makepkg -g >> PKGBUILD
```

需要注意，这里会自动追加到结尾，不影响代码，但建议删掉上面无用的校验。

## `.SRCINFO` 的生成

如果要提交给 AUR ，此文件必不可缺。但是对于打包来说没有影响，但如果要上传就要记牢这条命令。

``` bash
makepkg --printsrcinfo > .SRCINFO
```

以上就是一些备忘。
