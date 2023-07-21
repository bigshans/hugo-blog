---
title: 纯 numpy 实现 KNN
date: 2021-11-08T15:16:47+08:00
draft: false
tags:
- python
- numpy
- 机器学习
- kNN
categories:
- 机器学习
---

首先，感谢知乎文章 https://zhuanlan.zhihu.com/p/59755939 提供了**纯 numpy** 的写法，我这个也基本上是抄他的。

kNN 算法算是非常简单的了，但越是简单就越是要自己实现一下子。这里实现的是最基础的 kNN ， kNN 的缺点还是比较大的，在有更好算法的前提下我们并不用它。

## 导入库

``` python
from sklearn import datasets, model_selection
import numpy as np
from collections import Counter
```

原理我不讲了，很简单的。导入的几个库，其中 `sklearn` 主要是用它的鸢尾花数据集和划分测试集的能力， `Counter` 是 python 内建库，用于最后投票。

## predict

``` python
def _predict(self, X):
    distances = [ np.sqrt(np.sum((x_train - X) ** 2)) for x_train in self._x_train]
    sorted_dis = np.argsort(distances)
    topK = [self._y_train[s] for s in sorted_dis[:self.k]]
    votes = Counter(topK)
    return votes.most_common(1)[0][0]
```

这段代码基本上在暴力求解。

`np.sqrt(np.sum((x_train - X) ** 2))` 在求解 `x_train` 和 `X` 之间的距离， `distances` 为 `X` 与 `self._x_train` 中的每个张量之间的距离。

`np.argsort(distances)` 将 `distances` 从小到大排序，并返回的是对应的索引。

`topK` 是对应排序后前 `self.k` 个距离 `X` 最近的标签。之后利用 `votes` 求解出前 `k` 个标签中最常出现的。

## 完整代码

``` python
from sklearn import datasets, model_selection
import numpy as np
from collections import Counter


class KNNClassify:
    def __init__(self, k = 5):
        self.k = k
        self._x_train = None
        self._y_train = None

    def fit(self, X, y):
        self._x_train = X
        self._y_train = y
        return self

    def predict(self, X):
        y_predict = [self._predict(x) for x in X]
        return np.array(y_predict)

    def _predict(self, X):
        distances = [ np.sqrt(np.sum((x_train - X) ** 2)) for x_train in self._x_train]
        sorted_dis = np.argsort(distances)
        topK = [self._y_train[s] for s in sorted_dis[:self.k]]
        votes = Counter(topK)
        return votes.most_common(1)[0][0]

iris = datasets.load_iris()
iris_x, iris_y = iris.data, iris.target
Xtr, Xte, Ytr, Yte = model_selection.train_test_split(iris_x, iris_y, test_size=0.3, random_state=42)

knn = KNNClassify()
knn.fit(Xtr, Ytr)
print(knn.predict(Xte) == Yte)
```

我写得比较简单。有兴趣看看连接里的大佬，写得比较规范。
