---
title: python 实现尾递归斐波那契数列
date: 2018-08-28 16:30:17
tags:
- Python
- lambda
categories:
- Python
---

看了一下 [《 Python 简明教程》](https://pythoncaff.com/docs/byte-of-python/2018)，发现了一个很有意思的项目，它推荐了这个[项目](https://github.com/karan/Projects)来练手。这个项目是一份列表，关于用任何语言都可以实现的程序的项目。有兴趣可以实现一下。

我在这里写一下简单的斐波那契数列。
<!--more-->

```python
def fibonacci(a, b, n):
    if n == 0:
        return a
    return fibonacci(b, a + b, n - 1)

if __name__ == '__main__':
    while True:
        n = None
        try:
            n = input('>> ')
        except EOFError:
            exit()
        print(fibonacci(0, 1, int(n)))
```

使用了尾递归。可以用 lambda 减少代码：

```python
fib = lambda n, x=0, y=1: x if not n else fib(n-1, y, x+y)
print("lambda:" + str(fib(int(n))))

```

