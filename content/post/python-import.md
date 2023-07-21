---
title: python3 在不同目录下 import 其他py 文件
date: 2018-10-26 21:15:40
tags:
- Python
categories:
- Python
---

python 的 import 机制实在是太弱。。

今天我将不同目录下的 python 文件导入，试了半天快要吐血，虽然说最后解决了，但是我还是要说真的是 shit 啊！

<!--more-->

```
.
├── router
│   ├── HelloWorld.py
│   ├── __init__.py
├── src
│   ├── __init__.py
│   ├── server.py
└── static
```
这是大概的目录层级，我要运行的 server.py 调用了 router 下的 HelloWorld 模块，如果 router 是src 的子目录其实直接 import 就行了，但不是，于是这就很磨人。

最简单的方法，把 server.py 移到外面做入口文件。

但如果你想要保持这样的结构的话，就只能这么导入了。

```
import sys
sys.path.insert(0, '')
try:
    from router import HelloWorld
except ImportError:
    print("No modules here")
```

而且只能在父目录下运行，很鸡肋。

我是真的讨厌 python 这个奇怪的相对导入方式。为什么不能像 java 一样把这个 import 做好呢？
