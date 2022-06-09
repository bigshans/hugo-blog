---
title: latex 部分常用公式代码
date: 2018-12-26 15:46:18
copyright: true
markup: pandoc
tags:
- latex
- emacs
categories:
- latex
---

我个人很喜欢在 emacs 里用 latex 写公式，而且可以从中到处对应的 pdf ，很方便。在这里我记录一下常用的代码。

<!--more-->

| 公式代                             | 展示效果                           |
| ---------------------------------- | ---------------------------------- |
| `\times`                           | $\times$                           |
| `\rightarrow`                      | $\rightarrow$                      |
| `A_{x}`                            | $A_{x}$                            |
| `A^{x}`                            | $A^{x}$                            |
| `\mbox{汉语}`                      | $\mbox{汉语}$                      |
| `\geq`                             | $\geq$                             |
| `a\qquad b`(a b 之间留空)          | $a \qquad{b}$                      |
| `\overline{CS}`                    | $\overline{CS}$                    |
| `\underline{CS}`                   | $\underline{CS}$                   |
| `\neq`                             | $\neq$                             |
| `\leq`                             | $\leq$                             |
| `\sqrt{x}`                         | $\sqrt{x}$                         |
| `\underbrace{a+b\cdots+z}_{26}`    | $\underbrace{a+b\cdots+z}_{26}$    |
| `\vec a \quad \overrightarrow{AB}` | $\vec a \quad \overrightarrow{AB}$ |
| `\sum_{i=1}^{n} aa`                | $\sum_{i=1}^{n} aa$                |
| `\int_{0}^{5}`                     | $\int_{0}^{5}$                     |
| `\in`                              | $\in$                              |
| `\frac{5}{\pi}`                    | $\frac{5}{\pi}$                    |
| `\hat{C}`                          | $\hat{C}$                          |
| `\forall`                          | $\forall$                          |
| `\exists`                          | $\exists$                          |
| `\partial`                         | $\partial$                         |
| `\mathcal{L}`                      | $\mathcal{L}$                      |

多行的不太好用表格表示：

向量，

```latex
\mathbf{x} = \left[ \\
\begin{matrix}
a_1 \\
a_2 \\
\vdots \\
a_n \\
\end{matrix}
\right], \tag{1, 1}
```

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

矩阵，

```latex
\mathbf{x} = \left[
\begin{matrix}
a_{11} & a_{12} & \dots & a_{1n} \\
a_{21} & a_{22} & \dots & a_{2n} \\
\vdots & \vdots & \ddots & \vdots \\
a_{m1} & a_{m2} & \dots & a_{mn} \\
\end{matrix}
\right], \tag{2, 1}
```

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

转置，

```latex
\mathbf{A} = \mathbf{A^{\mathrm{T}}}
```

$$
\mathbf{A} = \mathbf{A^{\mathrm{T}}}
$$

哈达玛积，

```latex
\mathbf{A} \odot \mathbf{B} = \left[
\begin{matrix}
a_{11}b_{11} & a_{12}b_{12} & \dots & a_{1n}b_{1n} \\
a_{21}b_{21} & a_{22}b_{22} & \dots & a_{2n}b_{2n} \\
\vdots & \vdots & \ddots & \vdots \\
a_{m1}b_{m1} & a_{m2}b_{m2} & \dots & a_{mn}b_{mn} \\
\end{matrix}
\right], \tag{3, 1}
```

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

矩阵向量积，

```latex
\mathbf{A} = \left[
\begin{matrix}
\mathbf{a_1^{\mathsf{T}}} \\
\mathbf{a_2^{\mathsf{T}}} \\
\vdots \\
\mathbf{a_m^{\mathsf{T}}} \\
\end{matrix}
\right] \tag{4, 1}
```

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

大括号，

$$
\hat{C}'_p(x)
\left\{
\begin{array}{lr}
=\mu_w, & if & x_p > 0 \\
\\
\geq \mu_w, & if & x_p = 0,
\end{array}
\right.
$$

以上，以后有新的再添加。
