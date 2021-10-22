---
title: numpy 基础
date: 2021-10-22T16:12:26+08:00
draft: false
tags:
- python
- numpy
- 机器学习
- 大数据
categories:
- 机器学习
- 大数据
---

numpy 几乎可以说是 python 矩阵计算的基础库了，众多大数据处理框架都引用了它。因此，如果我们有意向大数据前进，我们必不可不面对它。

## 预备前提

如果你想要学习 numpy ，你至少需要具备以下基础：

- 熟悉常见的 python 数组操作。
- 熟悉基础的线性代数矩阵知识，并能够进行简单的计算。内容至少有标量、向量、矩阵、张量等。

具备这些基础我们就能够开始学习基础的 numpy 操作了。

## 创建一个 numpy 数组

首先导入 numpy 。

``` python
import numpy as np
```

首先，我们如何创建一个数组呢？可以分为创建自定义的数组和创建特定的数组。

创建自定义的数组较为简单。

``` python
np.array([2, 23, 4])
```

注意，我们创建的数组默认的数据类型为 `int` ，我们可以使用 `dtype` 指定。

``` python
np.array([2, 23, 4], dtype=float32)
```

我们可以使用 `ones` 、 `zeros` 、 `empty` ，创建特定形状并拥有特定数据的数组，其中 `empty` 是创建元素近似于的数组。

``` python
np.ones((3, 4), dtype=float32)
np.zeros((3, 4), dtype=float32)
np.empty((3, 4), dtype=float32)
```

`arange` 用于创建连续的数组。

``` python
np.arange(10) # array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
np.arange(10, 20) # array([10, 11, 12, 13, 14, 15, 16, 17, 18, 19])
np.arange(10, 20, 2) # array([10, 12, 14, 16, 18])
```

使用 `reshape` 可以改变数组的形状：

``` python
np.array(10).reshape((2, 5))
```

但是数组元素数量必须在 `reshape` 前后相等。

以上的这些都可以指定 `dtype` 。

numpy 创建的这些数组，其实实际上要对应线性代数的张量，在一阶的情况下为向量，二阶为矩阵，更高阶为张量。这是数据结构与数学的关联。

## 数组分割

分割数组在我们实际的代码开发中实际上是一个非常有用的功能， numpy 在这方面也做了很好的提供。

我们先创建两个数组。

``` python
A = np.array([1, 1, 1])
B = np.array([2, 2, 2])
```

我们可以使用 `vstack` 进行上下合并， `hstack` 进行左右合并。

``` python
np.vstack((A, B))
np.hstack((A, B))
```

我们还可以使用 `np.c_[]` 和 `np.r_[]` ，前者是列合并，后者是行合并。

``` python
np.c_[A, B]
np.r_[A, B]
```

除此之外，我们还吃好需要将一维数组转为一维矩阵，为此我们使用 `newaxis` ，当你探究 `newaxis` 的值时你会发现它为 `None` 。事实上，用 `None` 也没有问题，但就是语义不好罢了。

``` python
A[np.newaxis, :] # array([[1, 1, 1]])
A[:, np.newaxis] # array([[1], [1], [1]])
```

对于矩阵，我们使用 `concatenate` 进行合并， `axis` 进行合并轴的控制，不过普通向量也可以用 `concatenate` 合并。 `axis` 进行轴控制在 numpy 中是个比较常见的手段。

``` python
a = np.arange(10).reshape(2, 5)
b = np.arange(1, 11).reshape(2, 5)
np.concatenate((a, b), axis=0)
np.concatenate((a, b), axis=1)
```

## 数组分割

谈到合并就必然要谈到分割。

``` python
A = np.arange(12).reshape(3, 4)
np.split(A, 2, axis=1)
```

`axis` 控制分割的轴，第二个参数控制分割的份数，当然这实际上是等量分割，但我们实际需求中往往要不等量分割。

``` python
np.array_split(A, 3, axis=1)
```

尽量三等分。

值得注意的是，如果第二个参数输入的是个数组的话，那么 numpy 就会按照输入的序列进行索引分割，比如，

``` python
np.split(A, (1, 2), axis=0)
```

那 numpy 就会在 0 轴上进行分割，得到

- `A[:1]`
- `A[1:2]`
- `A[2:]`

三个数组。

## 针对元素的操作

``` python
A = np.arange(2,14).reshape((3,4)) 
np.max(A)
np.min(A)
np.argmin(A)
np.argmax(A)
```

`max` 和 `min` 求取数组元素的最大值和最小值， `argmax` 和 `argmin` 得到数组元素的最值的索引，但这个索引是摊平之后的。我们可以使用 `flatten` 将数组摊平。

```
A.flatten()[np.argmin[A]]
```

这里还有一些常用的方法。

``` python
np.sum(A) # 所有元素相加
np.mean(A) # 直接平均值
np.average(A) # 加权平均数
np.median(A) # 中位数
np.cumsum(A) # 累加
np.diff(A) # 累差
np.clip(A, 5, 9) # 裁剪
```

其中 `clip(A, 5, 9)` 的意思是，将 `A` 中大于 9 的元素用 9 替代，小于 5 的元素用 5 替代。

## 矩阵计算

``` python
a = np.array([10, 20, 30, 40])
b = np.arange(4)
a + b, a - b
```

`a + b` 、 `a - b` 就是矩阵上对应的各个元素相加。

`a * b` 默认是哈达玛积而不是矩阵相乘。

矩阵相乘我们使用 `dot` 。

``` python
a=np.array([[1,1],[0,1]])
b=np.arange(4).reshape((2,2))
np.dot(a, b)
```

但必须是矩阵，如果向量的话， `dot` 就是向量点积了。

我们也可以用 `a.dot(b)` 这个写法优雅替代 `np.dot()` 。

除此之外，还有一个很重要的计算就是转置。

``` python
np.transpose(A), A.T
```

两种写法皆可。

## 结语

写这篇文章的主要目的是为了整理最近所学的。最近看机器学习、数据分析的内容比较多，这样将学习转化为文章、从学到教的角色转变更有利于对这些内容的深入理解，至少我体验来看是不错的。
