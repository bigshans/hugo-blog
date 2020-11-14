---
title: 最长上升子序列模板
date: 2019-03-22 20:40:40
tags:
- LIS
- algorithm
- dp
categories:
- algorithm
mathjax: true
---

最长上升子序列模板。以 poj 3903 为例。

<!--more-->

``` cpp
/**
 *
 * @author: aerian
 * @description: 最长递增子序列 O(nlogn) 版本
 *
 **/
#include <iostream>
#include <algorithm>
#include <string.h>
#define cls(s) memset(s, 0, sizeof(s))

using namespace std;

const int MAXN = 100005;
int n, p[MAXN], dp[MAXN], a[MAXN];

int main(int argc, char *argv[])
{
    while (cin >> n) {
        cls(dp);
        cls(a);
        int len = 1;
        for (int i = 0; i < n; ++i) {
            cin >> p[i];
        }
        a[0] = p[0];
        for (int i = 1; i < n; ++i) {
            if (a[len - 1] < p[i]) {
                a[len++] = p[i];
            } else {
                *lower_bound(a, a + len, p[i]) = p[i];
            }
        }
        /**
         *
         * a[i] 为长度为 i 的子序列末尾的最小数
         * 此处的不严谨的证明
         * 1) 当 p 序列为递增序列时，则 a 为递增序列
         * 2) 当 p 序列为非递增序列时，则 a 序列长度为 1 ，此时该序列仍然有序。
         * 3) 当 p 序列为先递增后非递增序列时，则 a 在 p 的递增部分时， a 为有序递增， 
         *    在非递增序列时，若存在 p[k] > a[n] ，则可加入该递增序列，使序列长度 +1 ，显然，应取 max{a[n] | p[k] > a[n]} ，
         *    若 a[n + 1] >= p[k] 时，则选择替换为佳，否则不替换。换而言之，即取首个在 a 中大于 p[k] 的位置进行替换，此时，a 仍然为有序递增。
         * 4) 当 p 序列为先非递增后递增，则前非递增长度得到 a 序列长度为 1 ，此时长度仍然为 1 ，后面递增序列再加入显然 a 仍然递增。
         * 5) 当 p 序列为以上几种任意组合反复时，可通过以上证明进行推广，仍可证明 a 序列为递增序列。
         *
         **/
        cout << len << endl;
    }
    return 0;
}
```

这个是 $\mathcal{O}(n\log n)$ 的方法。关键点在于证明其 $a[i]$ 为上升序列，具体看注释，这里不多说了。
