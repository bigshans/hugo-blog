---
title: Tensorflow 入门之数学基础
date: 2021-10-18T16:06:11+08:00
draft: false
markup: pandoc
tags:
- 机器学习
- Tensorflow
- Python
categories:
- 机器学习
---

数学是通往机器学习不可避免的路径，它即是阶梯也是拦路虎。本篇以 d2l 第二版所提供的数学知识作为阅读内容进行学习。换而言之，本篇是 d2l 的读书笔记。我尽量把我能弄懂弄清楚，所以，开始吧！

## 导入

```python
import tensorflow as tf
```

## 线性代数

### 标量

所谓标量，就是只有大小、没有方向、可用实数表示的一个量。在 tensorflow 中，我们使用 只有一个元素的张量表示，它可以被正常用于加减乘除。对于我们来说，实际上它就是一个数。

```python
x = tf.constant([3.0])
y = tf.constant([2.0])

x + y, x * y, x / y, x**y
```

### 向量

在原来标量的维度上多了方向这一维度，就成了向量。你可以将向量视为标量组成的列表，在几何上，它往往代表了坐标系上的一个点，其方向是零点指向对应点。

在 tensorflow 里我们使用一维张量处理向量。

```python
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

```python
x[3]
```

显而易见的，向量只有一维，它因此存在一个长度。通过 `len()` 即可以获得。

```python
len(x)
```

因为我们实际上是把它当作一个特殊的张量来使用的，它实际上还存在一个 `shape` ，只不过是一维的。

```python
x.shape
# TensorShape([4])
```

### 矩阵

我们一步步前进你就会发现，标量到向量，意味着我们从零维到达了一维，而从向量到矩阵，我们则从一维到达了二维。矩阵在形式上是由 $m \times n$ 个元素组成的 $m$ 行 $n$ 列的元素几何，在代码中，被表示为具有两个轴的张量。

```python
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

```python
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

```python
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

```python
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

```python
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

```python
A * B
```

将张量乘以或加上一个标量不会改变张量的形状，其中张量的每个元素都将与标量相加或相乘。

```python
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

```python
x = tf.range(4, dtype=tf.float32)
x, tf.reduce_sum(x)
```

我们也可以表示任何形状张量的元素和。例如，矩阵 $\mathbf{A}$ 中的元素和可以记为 $\sum_{i=1}^{m}\sum_{j=1}^{n}a_{ij}$ 。

```python
A.shape, tf.reduce_sum(A)
```

默认情况下，调用求和函数会沿所有的轴降低张量的维度，使它变为一个标量。 我们还可以指定张量沿哪一个轴来通过求和降低维度。

```python
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

```python
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

```python
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

```python
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

```python
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

```python
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

范数是具有“长度”概念的函数。非正式地说，一个向量的*范数*告诉我们一个向量有多大。 这里考虑的*大小*（size）概念不涉及维度，而是分量的大小。

在线性代数中，向量范数是将向量映射到标量的函数 $f$ 。向量范数需要满足一些属性。

给定任意向量 $\mathbf{x}$ ，

- 性质一，如果我们按常数因子 $\alpha$ 缩放向量的所有元素，其范数也会按照相同常数因子的绝对值缩放：
  
  $$
  f\left(\alpha\mathbf{x}\right) = \left|\alpha\right|f\left(\mathbf{x}\right)
  $$

- 性质二，三角不等式：
  
  $$
  f\left(\mathbf{x+y}\right) \le f\left(\mathbf{x}\right) + f\left(\mathbf{y}\right)
  $$

- 性质三，非负性：
  
  $$
  f\left(\mathbf{x}\right) \ge 0
  $$

- 性质四，范数最小为 0 ，当且仅当全部向量全由 0 组成：
  
  $$
  \forall_i,\left[\mathbf{x}\right]_i = 0 \Leftrightarrow f\left(\mathbf{x}\right) = 0
  $$

举个例子，比如 $L_2$ 范数欧几里德距离。假设 $n$ 维向量 $\mathbf{x}$ 中的元素是 $x_1, \cdots , x_n$ ,其中 $L_2$ 是向量元素平方和的平方根：

$$
\left \| \mathbf{x} \right \|_2 = \sqrt{\sum_{i=1}^{n} x_i^2}
$$

其中，在 $L_2$ 范数中常常省略下标 2 ，也就是说 $\left\|\mathbf{x}\right\|$ 等同于 $\left\|\mathbf{x}\right\|_2$ 。在 tensorflow 中，我们使用 `tf.norm` 来计算 $L_2$ 范数。

```python
u = f.constant([3.0, -4.0])
tf.norm(u)
'''
output:
<tf.Tensor: shape=(), dtype=float32, numpy=5.0>
'''
```

在深度学习中，我们更常使用 $L_2$ 范数的平方，你还会遇到 $L_2$ 范数，它表示为向量元素的绝对值之和：

$$
\left\| \mathbf{x} \right\|_1 = \sum_{i=1}^{n} \left|x_i\right|
$$

```python
tf.reduce_sum(tf.abs(u))
```

$L_1$ 范数和 $L_2$ 范数都是更一般的 $L_p$ 范数的特例：

$$
\left\| \mathbf{x} \right\|_p = \left(\sum_{i=1}^{n} \left|x_i\right|^p\right)^{1/p}
$$

类似于向量的 $L_2$ 范数，矩阵 $\mathbf{X} \in \mathbb{R}^{m\times n}$ 的*弗罗贝尼乌斯范数*（Frobenius norm）是矩阵元素平方和的平方根：

$$
\left \| \mathbf{X} \right \|_F = \sqrt{\sum_{i=1}^{m} \sum_{j=1}^n x_{ij}^2}
$$

弗罗贝尼乌斯范数满足向量范数的所有性质，它就像是矩阵形向量的 $L_2$ 范数。 调用以下函数将计算矩阵的弗罗贝尼乌斯范数。

```python
tf.norm(tf.ones((4, 9)))
'''
output:
<tf.Tensor: shape=(), dtype=float32, numpy=6.0>
'''
```

## 微分

### 导数

假设我们有一个函数 $f：\mathbb{R}^n \rightarrow \mathbb{R}$ ，其输入输出都是标量。 $f$ 的**导数**被定义为

$$
f'\left(x\right) = \lim_{h\rightarrow\infty} \frac{f(x + h) - f(x)}{h} ,
$$

如果 $f'(a)$ 存在，则称 $f$ 在 $a$ 处是**可微**（differentiable）的。如果*f*在一个区间内的每个数上都是可微的，则此函数在此区间中是可微的。我们可以将导数 $f'(x)$ 解释为 $f(x)$ 相对于 $x$ 的*瞬时*（instantaneous）变化率。所谓的瞬时变化率是基于 $x$ 中的变化 $h$ ，且$h$ 接近 0 。

让我们熟悉一下导数的几个等价符号。给定 $y=f(x)$ ，其中 $x$ 和 $y$ 分别是函数 $y$ 的自变量和因变量。以下表达式是等价的：

$$
f'(x) = y' = \frac{dy}{dx} = \frac{df}{dx} = \frac{d}{dx} f(x) = Df{x} = D_xf{x},
$$

其中符号 $\frac{d}{dx}$ 和 $D$ 是微分运算符，表示微分操作。我们可以使用一下规则来对常数求微分：

- $DC = 0$ （$C$ 是一个常数）
- $Dx^n=nx^{x-1}$ （$n$ 是任意实数）
- $De^x = e^x$
- $D\ln(x) = 1/x$

为了微分一个由一些简单函数（如上面的常见函数）组成的函数，下面的法则使用起来很方便。 假设函数 $f$ 和 $g$ 都是可微的， $C$ 是一个常数，我们有：

- 常数相乘法则
  
  $$
  \frac{d}{dx}\left[Cf(x)\right] = C\frac{d}{dx}f(x),
  $$

- 加法法则
  
  $$
  \frac{d}{dx}[f(x) + g(x)] = \frac{d}{dx}f(x) + \frac{d}{dx} g(x),
  $$

- 乘法法则
  
  $$
  \frac{d}{dx}[f(x)g(x)] = f(x)\frac{d}{dx}[g(x)] + g(x)\frac{d}{dx}[f(x)],
  $$

- 除法法则
  
  $$
  \frac{d}{dx}\left[\frac{f(x)}{g(x)}\right] = \frac{g(x)\frac{d}{dx}\left[f(x)]-f(x)\frac{d}{dx}\left[g(x)\right]\right]}{[g(x)]^2}
  $$

### 偏导数

  到目前为止，我们只讨论了仅含一个变量的函数的微分。在深度学习中，函数通常依赖于许多变量。因此，我们需要将微分的思想推广到这些*多元函数*（multivariate function）上。

  设 $y=f(x_1,x_2,\cdots,x_n)$ 是一个具有 $n$ 个变量的函数。 $y$ 关于第 $i$ 个参数 $x_i$ 的**偏导数**（partial derivative）为：

$$
\frac{\partial y}{\partial x_i} = \lim_{h \rightarrow \infty} \frac{f(x_1,\cdots,x_{i-1}, x_i+h, x_{i+1}, \cdots, x_n) - f(x_1, \cdots, x_i, \cdots, x_n)}{h}
$$

  为了计算 $\frac{\partial y}{\partial x_i}$ ，我们可以简单地将 $x_1, \cdots, x_{i-1}, x_{i+1}, \cdots， x_n$ 看作常数。对于偏导数的表示，一下是等价的：

$$
\frac{\partial y}{\partial x_i} = \frac{\partial f}{\partial x_i} = f_{x_i} = f_i = D_if=D_{x_i}f
$$

### 梯度

  我们可以连结一个多元函数对其所有变量的偏导数，以得到该函数的*梯度*（gradient）向量。设函数 $f：\mathbb{R}^n \rightarrow \mathbb{R}$ 输入的是一个 $n$ 维向量 $\mathbf{x} = [x_1, x_2, \cdots, x_n]^{\mathsf{T}}$ ，并且输出的是一个标量。函数 $f(\mathbf{x})$ 相对于 $\mathbf{x}$ 的梯度是一个包含 $n$ 个偏导数的向量：

$$
\nabla_xf(x) = \left[\frac{\partial f(x)}{\partial x_1}, \frac{\partial f(x)}{\partial x_2}, \cdots, \frac{\partial f(x)}{\partial x_n}\right]^{\mathsf{T}},
$$

  其中 $\nabla_xf(x)$ 通常在没有歧义时被 $\nabla f(x)$ 取代。

  假设 $\mathbf{x}$ 为 $n$ 维向量，在微分多元函数时经常使用一下规则：

- 对于所有 $\mathbf{A} \in \mathsf{R}^{m\times n}$ ，都有 $\nabla_{\mathbf{x}}\mathbf{Ax} = \mathbf{A}^{\mathsf{T}}$
- 对于所有 $\mathbf{A} \in \mathsf{R}^{m\times n}$ ，都有 $\nabla_{\mathbf{x}}\mathbf{x^{\mathsf{T}}A} = \mathbf{A}$
- 对于所有 $\mathbf{A} \in \mathsf{R}^{m\times n}$ ，都有 $\nabla_{\mathbf{x}}\mathbf{A_x} = \mathbf{(A+A^{\mathsf{T}})x}$
- $\nabla_{\mathbf{x}}\|\mathbf{x}\|^2=\mathbf{\nabla_{x} x^{\mathsf{T}}x}=2\mathbf{x}$
- 对于任何矩阵 $\mathbf{X}$ ，我们都有 $\nabla_{\mathbf{x}}\|\mathbf{X}\|_F^2 = 2\mathbf{X}$ 。

### 链式法则

然而，上面方法可能很难找到梯度。 这是因为在深度学习中，多元函数通常是*复合*（composite）的，所以我们可能没法应用上述任何规则来微分这些函数。 幸运的是，链式法则使我们能够微分复合函数。

让我们先考虑单变量函数。假设函数 $y=f(u)$ 和 $u=g(x)$ 都是可微的，根据链式法则：

$$
\frac{dy}{dx} = \frac{dy}{du}\frac{du}{dx},
$$

现在让我们把注意力转向一个更一般的场景，即函数具有任意数量的变量的情况。假设可微分函数 $y$ 有变量 $u_1, u_2, \cdots , u_m$ ，其中每个可微分函数 $u_i$ 都有变量 $x_1, x_2, \cdots ,x_n$ 。注意，的函数。对于任意 $i = 1, 2, \cdots, n$ ，链式法则给出：

$$
\frac{dy}{dx_i} = \frac{dy}{du_1}\frac{du_1}{dx_i} + \frac{dy}{du_2}\frac{du_2}{dx_i} + \cdots + \frac{dy}{du_m}\frac{du_m}{dx_i}
$$

### 自动求导

求导对于机器学习优化算法来说是非常关键的异步，，但每次都手动计算是非常麻烦的，于是深度学习框架往往会自动求导。

#### 例子一

假设我们想对函数 $y=2\mathbf{x \cdot x}$ 还是列向量 $\mathbf{x}$ 求导。

首先，我们创建变量 x 并初始化。

```python
x = tf.range(4, dtype=tf.float32)
x
'''
output:
<tf.Tensor: shape=(4,), dtype=float32, numpy=array([0., 1., 2., 3.], dtype=float32)>
'''
```

在我们计算 $y$ 关于 $\mathbf{x}$ 的梯度之前，我们需要一个地方来存储梯度。重要的是，我们不会在每次对一个参数求导时都分配新的内存。因为我们经常会成千上万次地更新相同的参数，每次都分配新的内存可能很快就会将内存耗尽。

```python
x = tf.Variable(x)
```

现在我们计算 $y$ 。

```python
# 把所有计算记录在磁带上
with tf.GradientTape() as t:
    y = 2 * tf.tensordot(x, x, axes=1)
y
'''
output:
<tf.Tensor: shape=(), dtype=float32, numpy=28.0>
'''
```

`x`是一个长度为4的向量，计算`x`和`x`的内积，得到了我们赋值给`y`的标量输出。接下来，我们可以通过调用反向传播函数来自动计算`y`关于`x`每个分量的梯度，并打印这些梯度。

```python
x_grad = t.gradient(y, x)
x_grad
'''
output:
<tf.Tensor: shape=(4,), dtype=float32, numpy=array([ 0.,  4.,  8., 12.], dtype=float32)>
'''
```

函数 $y=2\mathbf{x^{\mathsf{T}}x}$ 关于 $\mathbf{x}$ 的梯度应为 $4\mathbf{x}$ 。我们可以验证一下。

```python
x_grad == 4 * x
'''
<tf.Tensor: shape=(4,), dtype=bool, numpy=array([ True,  True,  True,  True])>
'''
```

现在让我们计算`x`的另一个函数。

```python
with tf.GradienTape() as t:
    y = tf.reduce_sum(x)
t.gradient(y, x)
'''
<tf.Tensor: shape=(4,), dtype=float32, numpy=array([1., 1., 1., 1.], dtype=float32)>
'''
```

#### 非标量变量的反向传播

```python
with tf.GradientTape() as t:
    y = x * x
t.gradient(y, x)
'''
output:
<tf.Tensor: shape=(4,), dtype=float32, numpy=array([0., 2., 4., 6.], dtype=float32)>
'''
```

#### 分离计算

有时，我们希望将某些计算移动到记录的计算图之外。 例如，假设`y`是作为`x`的函数计算的，而`z`则是作为`y`和`x`的函数计算的。 现在，想象一下，我们想计算`z`关于`x`的梯度，但由于某种原因，我们希望将`y`视为一个常数，并且只考虑到`x`在`y`被计算后发挥的作用。

在这里，我们可以分离`y`来返回一个新变量`u`，该变量与`y`具有相同的值，但丢弃计算图中如何计算`y`的任何信息。换句话说，梯度不会向后流经`u`到`x`。因此，下面的反向传播函数计算`z=u*x`关于`x`的偏导数，同时将`u`作为常数处理，而不是`z=x*x*x`关于`x`的偏导数。

```python
# 设置 `persistent=True` 来运行 `t.gradient`多次
with tf.GradientTape(persistent=True) as t:
    y = x * x
    u = tf.stop_gradient(y)
    z = u * x

x_grad = t.gradient(z, x)
x_grad == u
'''
output:
<tf.Tensor: shape=(4,), dtype=bool, numpy=array([ True,  True,  True,  True])>
'''
```

```
<tf.Tensor: shape=(4,), dtype=bool, numpy=array([ True,  True,  True,  True])>
```

由于记录了`y`的计算结果，我们可以随后在`y`上调用反向传播，得到`y=x*x`关于的`x`的导数，这里是`2*x`。

```python
t.gradient(y, x) == 2 * x
```

```
<tf.Tensor: shape=(4,), dtype=bool, numpy=array([ True,  True,  True,  True])>
```

#### Python 控制流的梯度计算

使用自动求导的一个好处是，即使构建函数的计算图需要通过Python控制流（例如，条件、循环或任意函数调用），我们仍然可以计算得到的变量的梯度。在下面的代码中，`while`循环的迭代次数和`if`语句的结果都取决于输入`a`的值。

```python
def f(a):
    b = a * 2
    while tf.norm(b) < 1000:
        b = b * 2
    if tf.reduce_sum(b) > 0:
        c = b
    else:
        c = 100 * b
    return c

a = tf.Variable(tf.random.normal(shape=()))
with tf.GradientTape() as t:
    d = f(a)
d_grad = t.gradient(d, a)
d_grad

'''
output:
<tf.Tensor: shape=(), dtype=float32, numpy=1024.0>
'''
```

我们现在可以分析上面定义的`f`函数。请注意，它在其输入`a`中是分段线性的。换言之，对于任何`a`，存在某个常量标量`k`，使得`f(a)=k*a`，其中`k`的值取决于输入`a`。因此，`d/a`允许我们验证梯度是否正确。

```python
d_grad == d / a
```

```
<tf.Tensor: shape=(), dtype=bool, numpy=True>
```

## 概率

### 基本概率论

#### 概率论公理

在处理骰子掷出时，我们将集合 $\mathcal{S} = \{1, 2, 3,4,5,6\}$ 称为**样本空间**（sample space）或**结果空间**（outcome space）。**事件**（event）是来自给定样本空间的一组结果。例如，“看到 5 ” 和 “看到奇数” 都是掷出骰子的有效事件。

形式上，**概率**（probability）可以被认为是将集合映射到真实值的函数。在给定样本空间 $\mathcal{S}$ 中，事件 $\mathcal{A}$ 的概率，表示为 $P(\mathcal{A})$ ，满足以下属性：

- 对于任意事件 $\mathcal{A}$ ，其概率从不会是负数，即 $P(\mathcal{A}) \ge 0$
- 整个样本空间的概率为 1 ，即 $P(\mathcal{S}) = 1$
- 对于**互斥**事件的任意一个可数序列 $\mathcal{A_1},\mathcal{A_2}, \dots$ 序列中任意事件发生的概率等于它们各自发生概率之和，即 $P\left({\textstyle \bigcup_{i=1}^{\infty}}\mathcal{A}_i\right) = {\textstyle \sum_{i=1}^{\infty}}P(\mathcal{A}_i)$

这些也是概率论的公理。

#### 随机变量

随机变量几乎可以是任何数量，并且不是确定性的。它可以在随机实验的一组可能性中取一个值。考虑一个随机变量 $X$ ，其值在掷骰子的样本空间 $\mathcal{S}=\{1,2,3,4,5,6\}$ 中。我们可以将事件“看到一个5”表示为 $\{X=5\}$ 或 $X=5$，其概率表示或 $P(\{X=5\})$ 或 $P(X=5)$。进一步的，我们用 $P(1 \le X \le 3)$ 表示事件 $\{1\le X \le 3\}$ ，即 $\{X = 1,2,or,3\}$ 的概率。

### 联合概率

联合概率（joint probability），给定任何值 $a$ 和 $b$ ，同时满足 $A = a$ 和 $B = b$ 的概率是 $P(A = a, B = b)$ ，即对应的联合概率。注意，对于任何 $a$ 和 $b$ 的取值， $P(A = a, B = b) \le P(A = a)$ ，对于 $P(B = b)$ 亦然。

### 条件概率

比率 $0 \le \frac{P(A=a, B=b)}{P(A=a)} \le 1$ 我们称为条件概率，我们用 $P(B = b | A = a)$ 来表示它：它是在 $A = a$ 发生后 $B = b$ 的概率。

### 贝叶斯定理

使用条件概率的定义，我们可以得出统计学中最有用和最著名的方程之一：*Bayes定理*（Bayes’ theorem）。

根据条件概率的定义我们易得，$P(A,B) = P(B|A)P(A)$ 。

同理， $P(A,B)=P(A|B)P(B)$ 。

联立， $P(B|A)P(A)=P(A|B)P(B)$ 。

假设 $P(B) > 0$ ,我们就得到了

$$
P(A|B) = \frac{P(B|A)P(A)}{P(B)}，
$$

### 边际化

边际化是从 $P(A, B)$ 中确定 $P(B)$ 的操作。我们可以看到 $B$ 的概率相当于计算 $A$ 的所有可能选择，并将所有选择的连接概率聚合在一起，就可以得到 $B$ 的概率。

$$
P(B) = \sum_AP(A,B),
$$

这也称为*求和规则*。边际化结果的概率或分布称为*边际概率*或*边际分布*。

### 独立性

两个随机变量 $A$ 和 $B$ 是独立的，意味着事件 $A$ 的发生不会透露有关 $B$ 事件发生的任何信息，统计学上记为 $A \bot B$ ，根据贝叶斯定理，我们马上就能得到 $P(A|B) = P(A)$ 。在其他所有情况下我们称 $A$ 和 $B$ 依赖。

由于 $P(A | B) = \frac{P(A, B)}{P(B)} = P(A)$ 等价于 $P(A, B) = P(A)P(B)$ ，因此两个随机变量是独立的当且仅当两个随机变量的联合分布是其各自分布的乘积。同样地，给定另一个随机变量 $C$ 时，两个随机变量 $A$ 和 $B$ 是**条件独立**的，当且仅当 $P(A, B|C) = P(A|C)P(B|C)$ 。这个情况表示为 $A \bot B | C$ 。

### 期望和差异

为了概括概率分步的关键特征，我们需要一些测量方法。随机变量 $X$ 的**期望**表示为

$$
E[X] = \sum_xxP(X = x).
$$

当函数 $f(x)$ 的输入是从分步 $P$ 中出去的随机变量时， $f(x)$ 的期望为

$$
E_{x \sim p}[f(x)] = \sum_xf(x)P(x).
$$

在许多情况下，我们希望衡量随机变量 $X$ 与其期望值的偏置。这可以通过方差来量化

$$
\mathrm{Var}[X] = E[(X-E[X]^2)] = E[X^2] - E[X]^2.
$$

他们的平方根被称为**标准差**（standard deviation）。随机变量函数的方差衡量的是，当该随机变量分步中采样不同值 $x$ 时，函数值偏离该函数期望的程度：

$$
\mathrm{Var}[f(x)] = E[(f(x) - E[f(x)])^2]
$$

## 结语

这是我写的最多的一篇博客了，写到最后我仍然有些东西稀里糊涂的，但是大致上还是把握了一些。以前深度学习看不懂的地方能够懂一点。这些数学最最重要的就是前面花大幅笔墨书写的线性代数的内容，虽然说后面也很重要，但线代不懂后面意义也不大， Tensorflow 名字有一般是 tensor 。当然，深度学习的数学也不是就这么完了，路曼曼其修远兮，但现在暂告一段落。
