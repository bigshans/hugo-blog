---
title: 动态规划求解 RMQ 问题
date: 2019-03-22 19:37:15
tags:
- algorithm
- dp
- rmq
categories:
- algorithm
mathjax: true
---

rmq 即是区间最值问题，这里是动态规划模板的讲解。所谓 dp 的方法，就是区间 dp 的方法，如果采用原始的区间 dp 方法，那么当数据量很大时会出现时间和空间的双重爆破。这里我们采用了倍增法。我们通过这个模板来观察这个的实现以及思想。

<!--more-->

上模板。这是 poj 3264 的题，可以用线段树，也可以用 rmq 求解。
``` cpp
#include <algorithm>
#include <stdio.h>
#include <math.h>
#define scf scanf
#define prf printf

using namespace std;

const int MAXN = 50000 + 5;
const int MAXN_L = 25;
int dp_max[MAXN][MAXN_L], dp_min[MAXN][MAXN_L], cows[MAXN];

void dp(int n)
{
    for (int i = 1; i <= n; ++i) {
        dp_max[i][0] = dp_min[i][0] = cows[i];
    }
    for (int j = 1; j < MAXN_L; ++j) {
        for (int i = 1; i <= n; ++i) {
            if (i + (1 << j) <= n + 1) {
                dp_max[i][j] = max(dp_max[i][j - 1], dp_max[i + (1 << (j - 1)) ][j - 1]);
                dp_min[i][j] = min(dp_min[i][j - 1], dp_min[i + (1 << (j - 1))][j - 1]);
            }
        }
    }
}

int query_max(int l, int r)
{
    int k = (int)((double)(log(double(r - l + 1)) / log(2.0)));
    return max(dp_max[l][k], dp_max[r - (1 << k) + 1][k]);
}

int query_min(int l, int r)
{
    int k = (int)(log(double(r - l + 1)) / log(2.0));
    return min(dp_min[l][k], dp_min[r + 1 - (1 << k)][k]);
}

int main(int argc, char *argv[])
{
    int N, Q;
    while (~scf("%d%d", &N, &Q)) {
        for (int i = 1; i <= N; ++i) {
            scf("%d", cows + i);
        }
        dp(N);
        int l, r;
        while (Q--) {
            scf("%d%d", &l, &r);
            prf("%d\n", (query_max(l, r) - query_min(l, r)));
        }
    }
    return 0;
}

```

预处理时间是 $\mathcal{O}(\mathcal{n}\log n)$ ，而查询复杂度则为 $\mathcal{O}(\mathcal{1})$ 。

## 预处理

``` cpp
    for (int j = 1; j < MAXN_L; ++j) {
        for (int i = 1; i <= n; ++i) {
            if (i + (1 << j) <= n + 1) {
                dp_max[i][j] = max(dp_max[i][j - 1], dp_max[i + (1 << (j - 1)) ][j - 1]);
                dp_min[i][j] = min(dp_min[i][j - 1], dp_min[i + (1 << (j - 1))][j - 1]);
            }
        }
    }
```

这里，$dp[i][j]$ 代表以 i 为起点，长度为 $2^{j}$ 区间的最值。

该区间的终点为 $2^{j} + i - 1$ ，终点不能超过 n 。

区间我们对半拆分。

$[i, 2^{j} + i - 1]$ 的中值为 $\frac{i + 2^{j} + i - 1}{2} = i + 2^{j - 1} - \frac{1}{2}$ ，我们这里分成两个区间 $[i, 2^{j - 1} + i - 1]$ 和 $[2^{j - 1} + i, 2^{j} + i - 1]$ ，显然，区间长度都为 $2^{j - 1}$ 。

## 查询

```cpp
int query_max(int l, int r)
{
    int k = (int)((double)(log(double(r - l + 1)) / log(2.0)));
    return max(dp_max[l][k], dp_max[r - (1 << k) + 1][k]);
}

int query_min(int l, int r)
{
    int k = (int)(log(double(r - l + 1)) / log(2.0));
    return min(dp_min[l][k], dp_min[r + 1 - (1 << k)][k]);
}
```

显然，查询最大值和查询最小值是一样的。

任意一个整数可以表达为一个二进制数，我们求得 $$k=\lfloor \log_2{(r - l + 1)} \rfloor$$ ，就是求得区间内最大的二的整数幂。这个数 $$k \geq \frac{r - l + 1}{2}$$ ，我们确保 $$2k \geq r - l + 1$$ ，从而确保范围覆盖。虽然这里出现区间重复，但这里并不影响我们求解区间最值，区间重叠不影响区间最值求解。

## 总结

首先，这是个区间 dp 的优化，这个优化也可以作用于允许区间重叠的问题。

区间 dp 我们分别枚举开始节点和终点，并枚举分割节点。这里，我们的分割节点取中间节点即可。由于原始的区间 dp 复杂度都很大，所以我们采用了倍增法解决一部分问题。

这里，我们用倍增法压缩了一些区间，在我们查询的时候再将之取出。我们之所以采用二倍是因为计算机的二进制表达，我们也可以采用三倍甚至四倍，但倍增越大，我们压缩的就越厉害，到时候我们将之分割的时候就越麻烦。所以，一般我们采用二倍。

以上就是我学习 rmq 的一些总结，希望对大家学习该算法的时候有所帮助。