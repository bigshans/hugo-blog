---
title: 在 Linux 下使用 Objective-C 编程
date: 2021-09-12T20:33:41+08:00
draft: false
tags:
- Linux
- Objective-C
categories:
- Objective-C
---

GCC 本来就可以编译 Objective-C ，以前我虽然尝试过，但是并没有成功。不过最近又想要弄着玩一下，学习一下 Objective-C 。

Linux 是没有 XCode 这样的环境的，而如果想要使用 GCC 编译 Objective-C 需要 Objective-C front-end for GCC ，Arch 下面直接安装 gcc-objc 这个包就可以了。

但是呢，这个只是装了个编译器前端，重要的一些库都没有，在这里我们使用 GNUStep 模拟苹果的环境。实际上 GNUStep 与真实的苹果环境是有差异的，如果要进行 GUI 编程的话还要装 GUI 的库，但这些其实跟苹果已经毫无关系了。如果你只是为了学习 Objective-C ，或者使用 Objective-C 在 Linux 上编程，这些已经完全够了。

Arch 安装 GNUStep ，会有两个包让你选，两个都要就可以了。安装完成我们写个 Demo 。

``` objective-c
#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
   
   NSLog (@"hello world");
   [pool drain];
   return 0;
}
```

保存上面一段代码为 `hello.m` ，运行命令:

``` sh
gcc `gnustep-config --objc-flags` -lgnustep-base -lobjc hello.m -o hello
```

编译成功，运行 `./hello` 打印 `2021-09-12 20:50:45.378 hello[61801:61801] hello world` 。

以上都是在命令行环境下的编程，如果想要进行苹果开发的话，你还是得买 Mac 。当然， Objective-C 也不一定非要与苹果绑定，也有基于 GNUStep 开发的图形界面库和应用，不过这些都跟苹果没有半毛钱关系了。

补充：

现在需要安装 gnustep-base 、gnustep-make 和 gcc-objc 。
