---
title: 线段树算法
date: 2019-03-08 20:50:55
tags:
- algorithm
categories:
- algorithm
mathjax: true
---

我的 ACM 线段树模板。

<!--more-->

``` cpp
#include <stdio.h>

typedef long long ll;

const int MAXN=1000005;
ll sum[MAXN << 1], lazy[MAXN << 1];

void pushup(int root)
{
    sum[root] = sum[root << 1] + sum[root << 1 | 1];
}

void pushdown(int root, int len)
{
    if (lazy[root]) {
        lazy[root << 1] += lazy[root];
        lazy[root << 1 | 1] += lazy[root];
        sum[root << 1] += lazy[root] * (len - (len >> 1));
        sum[root << 1 | 1] += lazy[root] * (len >> 1);
        lazy[root] = 0;
    }
}

void build(int l, int r, int root)
{
    lazy[root] = 0;
    if (l == r) {
        scanf("%lld", sum + root);
        return ;
    }
    int m = (l + r) >> 1;
    build(l, m, root << 1);
    build(m + 1, r, root << 1 | 1);
    pushup(root);
}

void update(int L, int R, ll add, int l, int r, int root)
{
    if (l >= L && r <= R) {
        lazy[root] += add;
        sum[root] += add * (r - l + 1);
        return ;
    }
    pushdown(root, r - l + 1);
    int m = (l + r) >> 1;
    if (m >= L) update(L, R, add, l, m, root << 1);
    if (m < R) update(L, R, add, m + 1, r, root << 1 | 1);
    pushup(root);
}

ll query(int L, int R, int l, int r, int root)
{
    if (l >= L && r <= R) {
        return sum[root];
    }
    pushdown(root, r - l + 1);
    ll ret = 0;
    int m = (l + r) >> 1;
    if (m >= L) ret += query(L, R, l, m, root << 1);
    if (m < R) ret += query(L, R, m + 1, r, root << 1 | 1);
    return ret;
}

int main(int argc, char *argv[])
{
    int n, q, a, b;
    ll c;
    char op;
    scanf("%d%d", &n, &q);
    build(1, n, 1);
    while (q--) {
        getchar();
        scanf("%c%d%d", &op, &a, &b);
        if (op == 'Q') {
            printf("%lld\n", query(a, b, 1, n, 1));
        } else {
            scanf("%lld", &c);
            update(a, b, c, 1, n, 1);
        }
    }
    return 0;
}
```

这里有一个 lazy 的延迟标记，线段树不用延迟标记复杂度是 O(n^2) ，用了延迟标记复杂度才是 O(nlogn) 。

看源码基本能懂。

build 函数。 l 和 r 代表当前节点所代表的线段区间， root 是节点位置。这里我写的是递归方式建立。

update 函数。 L 和 R 代表所要更新的区间， l 和 r 代表当前节点所代表的线段区间。当前节点处于更新区间内，我们不向下更新，在这里做一个延迟标记， lazy 在这里标记该节点是否作出了某些修改，当查询到该节点时，若该节点存在修改，则将该修改部署到子节点，修改完成，则将该节点标记清楚。当 m >= L 时，说明查询区间与当前区间的左半部分有交集，同理， m < R 时，说明查询区间与当前区间的右版部分有交集。

query 函数。 参数的含义和 update 函数一致。查询到代表当前区间的节点即可。

pushup 函数。更新完子节点后，要更新父节点。父节点等于子节点之和。

pushdown 函数。这个函数部署 lazy 。查询到当前节点，就将当前节点更新下去。若父节点存在延迟时，将父节点的延迟更新到子节点，子节点上的值更新。通过建立函数，我们可以知道，父节点代表的区间长度等于两个子节点长度之和，且子节点是父节点的一半。父节点数目为 r - l + 1，故左节点有 (r - l) / 2 + 1 个节点，右节点有 (r - l) / 2 个节点。 m >> 1 等于 m / 2 向下取整，所以右节点有 m >> 1 个， 剩余的就是左节点数。最后清楚延迟标记，表示更新完成。

以上就是线段树的一点东西。
