---
title: Tensorflow 入门之数学基础
date: 2021-10-18T16:06:11+08:00
draft: true
markup: pandoc
tags:
- machine learing
- tensorflow
categories:
- tensorflow
---

数学是通往机器学习不可避免的路径，它即是阶梯也是拦路虎。今天我们就来学习一下 Tensorflow 的一些简单的数学基础，并且与 Tensorflow 的数据结构进行结合，使我们能够不失抽象的情况下直观地与代码想联系。不多说，开始吧！

## 导入

``` python
import tensorflow as tf
```

## 线性代数

### 标量

所谓标量，就是只有大小、没有方向、可用实数表示的一个量。在 tensorflow 中，我们使用 只有一个元素的张量表示，它可以被正常用于加减乘除。对于我们来说，实际上它就是一个数。

``` python
x = tf.constant([3.0])
y = tf.constant([2.0])

x + y, x * y, x / y, x**y
```

### 向量

在原来标量的维度上多了方向这一维度，就成了向量。你可以将向量视为标量组成的列表，在几何上，它往往代表了坐标系上的一个点，其方向是零点指向对应点。

在 tensorflow 里我们使用一维张量处理向量。

``` python
x = tf.range(4)
x
```

习惯上，我们使用列向量来表示：
$$
\mathbf{x} = \left[ \\
\begin{matrix}
a_1 \\
a_2 \\
\vdots \\
a_n \\
\end{matrix}
\right], \tag{1, 1}
$$

其中 $a_1 , \dots, a_n$ 都是向量的元素，我们使用索引来访问任何一个元素。

``` python
x[3]
```

显而易见的，向量只有一维，它因此存在一个长度。通过 `len()` 即可以获得。

``` python
len(x)
```

因为我们实际上是把它当作一个特殊的张量来使用的，它实际上还存在一个 `shape` ，只不过是一维的。

```python
x.shape
# TensorShape([4])
```



### 矩阵

我们一步步前进你就会发现，标量到向量，意味着我们从零维到达了一维，而从向量到矩阵，我们则从一维到达了二维。矩阵在形式上是由 $m \times n$ 个元素组成的 $m$ 行 $n$ 列的元素几何，在代码中，被表示为具有两个轴的张量。

``` python
A = tf.reshapre(tf.range(20), (5, 4))
A
```

这里我们使用 `reshapre()` 创建了一个矩阵。

在数学表示法中，我们使用 $\mathbf{A} \in \mathbb{R}^{m\times n}$ 来表示矩阵，其由 $m$ 行和 $n$ 列的实值标量组成。直观地，我们可以将任意矩阵 $\mathbf{A} \in \mathbb{R}^{m\times n}$ 视为一个表格，其中每个元素 $a_{ij}$ 属于第 $i$ 行第 $j$ 列：
$$
\mathbf{x} = \left[
\begin{matrix}
a_{11} & a_{12} & \dots & a_{1n} \\
a_{21} & a_{22} & \dots & a_{2n} \\
\vdots & \vdots & \ddots & \vdots \\
a_{m1} & a_{m2} & \dots & a_{mn} \\
\end{matrix}
\right], \tag{2, 1}
$$
如果 $m = n$ ，则称之为方矩阵。

有时候我们想要翻转矩阵。当我们交换举轴和列时，其结果成为矩阵的转置（transpose）。我们用 $\mathbf{B} = \mathbf{A^\mathrm{T}}$ 。我用使用 `tf.transpose()` 进行转置。

``` python
tf.transpose(A)
```

比如我们对 `(2, 1)` 进行转置就得到了 `(2, 2)` 。
$$
\mathbf{x} = \left[
\begin{matrix}
a_{11} & a_{21} & \dots & a_{m1} \\
a_{12} & a_{22} & \dots & a_{m2} \\
\vdots & \vdots & \ddots & \vdots \\
a_{1n} & a_{n2} & \dots & a_{mn} \\
\end{matrix}
\right], \tag{2, 2}
$$
如果 $\mathbf{A} = \mathbf{A^{\mathrm{T}}}$ ，则该矩阵我们称为对称矩阵。

我们可以用代码简单证明一下。

``` python
B = tf.constant([[1, 2, 3], [2, 0, 4], [3, 4, 5]])
B == tftranspose(B)
'''
output:
<tf.Tensor: shape=(3, 3), dtype=bool, numpy=
array([[ True,  True,  True],
       [ True,  True,  True],
       [ True,  True,  True]])>
'''
```

### 张量

我们使用多维数组表示张量，即是用分量的多维数组来表示。其实在之前的内容中，我们一直在使用张量来表示标量、向量、矩阵，这使得我们这样理解张量：张量是以上数据结构的更高维度。从计算机的角度看并没有问题，因为它确实是这样表示的，但在数学上，张量会更复杂一些，不过我们不纠结。

想看的话戳这里：https://www.bilibili.com/video/BV1dJ411W7Xm/ 。

``` python
X = tf.reshapre(tf.range(24), (2, 3, 4))
X
'''
output:
<tf.Tensor: shape=(2, 3, 4), dtype=int32, numpy=
array([[[ 0,  1,  2,  3],
        [ 4,  5,  6,  7],
        [ 8,  9, 10, 11]],

       [[12, 13, 14, 15],
        [16, 17, 18, 19],
        [20, 21, 22, 23]]], dtype=int32)>
'''
```

### 张量算法的基本性质

我们可以将任意两个具有相同形状的张量进行二元运算，得到的结果也必然是相同形状的张量。

``` python
A = tf.reshape(tf.range(20, dtype=tf.float32), (5, 4))
B = A  # 不能通过分配新内存将A克隆到B
A, A + B
'''
output:
(<tf.Tensor: shape=(5, 4), dtype=float32, numpy=
 array([[ 0.,  1.,  2.,  3.],
        [ 4.,  5.,  6.,  7.],
        [ 8.,  9., 10., 11.],
        [12., 13., 14., 15.],
        [16., 17., 18., 19.]], dtype=float32)>,
 <tf.Tensor: shape=(5, 4), dtype=float32, numpy=
 array([[ 0.,  2.,  4.,  6.],
        [ 8., 10., 12., 14.],
        [16., 18., 20., 22.],
        [24., 26., 28., 30.],
        [32., 34., 36., 38.]], dtype=float32)>)
'''
```

具体而言，两个矩阵按元素乘法成为*哈达玛积*（Hadamard product，数学符号 $\odot$）。对于矩阵 $\mathbf{B} \in \mathbb{R}^{m \times n}$ ，其中第 $i$ 行和第 $j$ 列的元素是 $b_{ij}$ 。矩阵 $\mathbf{A}$ （定义 `2，1`）和 $\mathbf{B}$ 的哈达玛积为：
$$
\mathbf{A} \odot \mathbf{B} = \left[
\begin{matrix}
a_{11}b_{11} & a_{12}b_{12} & \dots & a_{1n}b_{1n} \\
a_{21}b_{21} & a_{22}b_{22} & \dots & a_{2n}b_{2n} \\
\vdots & \vdots & \ddots & \vdots \\
a_{m1}b_{m1} & a_{m2}b_{m2} & \dots & a_{mn}b_{mn} \\
\end{matrix}
\right], \tag{3, 1}
$$

``` python
A * B
```

将张量乘以或加上一个标量不会改变张量的形状，其中张量的每个元素都将与标量相加或相乘。

``` python
a = 2
X = tf.reshape(tf.range(24), (2, 3, 4))
a + X, (a * X).shape
'''
output:
(<tf.Tensor: shape=(2, 3, 4), dtype=int32, numpy=
 array([[[ 2,  3,  4,  5],
         [ 6,  7,  8,  9],
         [10, 11, 12, 13]],

        [[14, 15, 16, 17],
         [18, 19, 20, 21],
         [22, 23, 24, 25]]], dtype=int32)>,
 TensorShape([2, 3, 4]))
'''
```

### 降维

我们可以对任何张量计算其元素的和。在数学表示法中，我们使用 $\sum$ 来表示求和，为了表示向量中元素的总和，可以记为 $\sum_{i=1}^{d}x_i$ 。在 tensorflow 中，我们调用 `tf.reduce_sum()` 来计算求和。

``` python
x = tf.range(4, dtype=tf.float32)
x, tf.reduce_sum(x)
```

我们也可以表示任何形状张量的元素和。例如，矩阵 $\mathbf{A}$ 中的元素和可以记为 $\sum_{i=1}^{m}\sum_{j=1}^{n}a_{ij}$ 。

```python
A.shape, tf.reduce_sum(A)
```

默认情况下，调用求和函数会沿所有的轴降低张量的维度，使它变为一个标量。 我们还可以指定张量沿哪一个轴来通过求和降低维度。

``` python
A_sum_axis0 = tf.reduce_sum(A, axis=0)
A_sum_axis0, A_sum_axis0.shape
'''
output:
(<tf.Tensor: shape=(4,), dtype=float32, numpy=array([40., 45., 50., 55.], dtype=float32)>,
 TensorShape([4]))
'''
```

其中 `axis` 的决定了求和函数将哪个轴合并，可以使用 `list` 进行多轴求和。显然，当 `axis=[0,1]` 时，对矩阵 $\mathbf{A}$ 的求和与直接求和无异。

#### 非降维求和

有时候维度保持住还是非常有用的。

``` python
sum_A = tf.reduce_sum(A, axis=1, keepdims=True)
sum_A
'''
output:
<tf.Tensor: shape=(5, 1), dtype=float32, numpy=
array([[ 6.],
       [22.],
       [38.],
       [54.],
       [70.]], dtype=float32)>
'''
```

如果我们想沿某个轴计算`A`元素的累积总和，比如`axis=0`（按行计算），我们可以调用`tf.cumsum()`函数。此函数不会沿任何轴降低输入张量的维度。

``` python
tf.cumsum(A, axis=0)
'''
output:
<tf.Tensor: shape=(5, 4), dtype=float32, numpy=
array([[ 0.,  1.,  2.,  3.],
       [ 4.,  6.,  8., 10.],
       [12., 15., 18., 21.],
       [24., 28., 32., 36.],
       [40., 45., 50., 55.]], dtype=float32)>
'''
```

### 点积

所谓点积（Dot Product），即给定两个向量 $\mathbf{x}, \mathbf{y} \in \mathbb{R}^d$ ，它们的点积为 $\mathbf{x} \cdot \mathbf{y}$ （或 $\left<\mathbf{x}, \mathbf{y}\right>$），计算为相同位置的按元素成绩的和： $\mathbf{x \cdot y} = \sum_{i=1}^{d}x_iy_i$ 。

``` python
y = tf.ones(4, dtype=tf.float32)
x, y, tf.tensordot(x, y, axes=1)
'''
output:
(<tf.Tensor: shape=(4,), dtype=float32, numpy=array([0., 1., 2., 3.], dtype=float32)>,
 <tf.Tensor: shape=(4,), dtype=float32, numpy=array([1., 1., 1., 1.], dtype=float32)>,
 <tf.Tensor: shape=(), dtype=float32, numpy=6.0>)
'''
```

其实也可以直接相加。

``` python
tf.redice_sum(x * y)
```

从代数上看， $\mathbf{x} \cdot \mathbf{y}$ 实际上等于  $\mathbf{x}^{\mathsf{T}} \mathbf{y}$ ；从几何上看，点积可以直观的定义为 $\mathbf{a \cdot b} = \mathbf{|a||b|}\cos \theta$ ， $\theta$ 为 $\mathbf{A}$ 和 $\mathbf{B}$ 的夹角，因此，不难理解，两个向量的点积可以理解为向量 $\mathbf{A}$ 在向量 $\mathbf{B}$ 上的投影再乘以 $\mathbf{B}$ 的长度。

### 矩阵向量积

现在，我们知道如何计算点积，我们可以开始计算*矩阵向量积*（matrix-vector product）了。这个实际上是一个过渡内容。

我们首先将矩阵 $\mathbf{A}$ 用行向量表示：
$$
\mathbf{A} = \left[
\begin{matrix}
\mathbf{a_1^{\mathsf{T}}} \\
\mathbf{a_2^{\mathsf{T}}} \\
\vdots \\
\mathbf{a_m^{\mathsf{T}}} \\
\end{matrix}
\right] \tag{4, 1}
$$
其中，$\mathbf{a_i^{\mathsf{T}}} \in \mathbb{R}^n$ 都是行向量，表示矩阵第 $i$ 行。矩阵向量积 $\mathbf{Ax}$ 是一个长度为 $m$ 的列向量：
$$
\mathbf{Ax} = \left[
\begin{matrix}
\mathbf{a_1^{\mathsf{T}}} \\
\mathbf{a_2^{\mathsf{T}}} \\
\vdots \\
\mathbf{a_m^{\mathsf{T}}} \\
\end{matrix}
\right]\mathbf{x}= \left[
\begin{matrix}
\mathbf{a_1^{\mathsf{T}}x} \\
\mathbf{a_2^{\mathsf{T}}x} \\
\vdots \\
\mathbf{a_m^{\mathsf{T}}x} \\
\end{matrix}
\right] \tag{4, 2}
$$

### 矩阵乘法

现在我们学习矩阵乘法。

假设我们有两个矩阵 $\mathbf{A} \in \mathbb{R}^{n\times k}$ 和 $\mathbf{B} \in \mathbb{R}^{n\times k}$ ：
$$
\mathbf{A} = \left[
\begin{matrix}
a_{11} & a_{12} & \dots & a_{1k} \\
a_{21} & a_{22} & \dots & a_{2k} \\
\vdots & \vdots & \ddots & \vdots \\
a_{n1} & a_{n2} & \dots & a_{nk} \\
\end{matrix}
\right],
\mathbf{B} = \left[
\begin{matrix}
b_{11} & b_{12} & \dots & b_{1k} \\
b_{21} & b_{22} & \dots & b_{2k} \\
\vdots & \vdots & \ddots & \vdots \\
b_{n1} & b_{n2} & \dots & b_{nk} \\
\end{matrix}
\right] \tag{5, 1}
$$
用行向量 $\mathbf{a_i^{\mathsf{T}}} \in \mathbb{R}^k$ 表示矩阵 $\mathbf{A}$ 的第 $i$ 行，并让列向量 $\mathbf{b_j} \in \mathbb{R}^k$ 表示矩阵 $\mathbf{B}$ 的第 $j$ 列，则
$$
\mathbf{A} = \left[
\begin{matrix}
\mathbf{a_1^{\mathsf{T}}} \\
\mathbf{a_2^{\mathsf{T}}} \\
\vdots \\
\mathbf{a_n^{\mathsf{T}}} \\
\end{matrix}
\right],
\mathbf{B} = \left[
\begin{matrix}
\mathbf{b_1} &,
\mathbf{b_2} &
\cdots &
\mathbf{b_m}
\end{matrix}
\right] \tag{5, 2}
$$
当我们简单地将每个元素 $c_{ij}$ 计算为点积 $\mathbf{a_i^\mathsf{T}b_j}$:
$$
\mathbf{C} =
\mathbf{AB} = \left[
\begin{matrix}
\mathbf{a_1^{\mathsf{T}}} \\
\mathbf{a_2^{\mathsf{T}}} \\
\vdots \\
\mathbf{a_m^{\mathsf{T}}} \\
\end{matrix}
\right]\left[
\begin{matrix}
\mathbf{b_1} &,
\mathbf{b_2} &
\cdots &
\mathbf{b_m}
\end{matrix}
\right] = \left[
\begin{matrix}
\mathbf{a_1^{\mathsf{T}}b_1} & \mathbf{a_1^{\mathsf{T}}b_2} & \cdots & \mathbf{a_1^{\mathsf{T}}b_m} \\
\mathbf{a_2^{\mathsf{T}}b_1} & \mathbf{a_2^{\mathsf{T}}b_2} & \cdots & \mathbf{a_2^{\mathsf{T}}b_m} \\
\vdots & \vdots & \ddots & \vdots \\
\mathbf{a_n^{\mathsf{T}}b_1} & \mathbf{a_n^{\mathsf{T}}b_2} & \cdots & \mathbf{a_n^{\mathsf{T}}b_m} \\
\end{matrix}
\right] \tag{5, 3}
$$
我们可以将矩阵-矩阵乘法 $\mathbf{AB}$ 看作是简单地执行 $m$ 次矩阵-向量积，并将结果拼接在一起，形成一个 $m\times n$ 矩阵。在下面的代码中，我们在 `A` 和 `B` 上执行矩阵乘法。这里的 `A` 是一个5行4列的矩阵， `B` 是一个4行3列的矩阵。相乘后，我们得到了一个5行3列的矩阵。

``` python
B = tf.ones((4, 3), dtype=float64)
tf.matmul(A, B)
'''
output:
<tf.Tensor: shape=(5, 3), dtype=float32, numpy=
array([[ 6.,  6.,  6.],
       [22., 22., 22.],
       [38., 38., 38.],
       [54., 54., 54.],
       [70., 70., 70.]], dtype=float32)>
'''
```



### 范数	

