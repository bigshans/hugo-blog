---
title: Java 源码阅读之 HashMap
date: 2019-10-04 22:32:30
tags:
- Java
- HashMap
categories:
- Java
---

对以下一段代码进行 Debug，阅读建议边 Debug 边看。

    import java.util.HashMap;
    
    public class Collec {
        public static void main(String[] args) {
            HashMap a = new HashMap();
            a.put("sd", "54");
            a.put("sd", "125");
        }
    }

<!--more-->

## 继承关系

HashMap <- AbstractMap <- Map 。

## 初始化

这里会调用初始化代码。

    public HashMap() {
        this.loadFactor = DEFAULT_LOAD_FACTOR;
    }

DEFAULT_LOAD_FACTOR默认是0.75。我们可以看到，在这里 HashMap 并没有初始化空间。

## put 方法

我们一步一步地来看。

首先，我们调用了 put 方法，然后 put 方法回调了 putVal 方法。

    public V put(K key, V value) {
        return putVal(hash(key), key, value, false, true);
    }

首先将 key 进行 hash ，从而得到一个 int 值。

    static final int hash(Object key) {
        int h;
        return (key == null)?0:(h = key.hashCode()) ^ (h >>> 16);
    }

这里的意思是，将 key 的 hash 值先带符号右移 16 位，然后跟低位做异或操作。

这样将并不直观，我们直接进行一下计算吧！

首先我们的 key 设置为 131072 ，二进制为 10 0000 0000 0000，右移 16 位为 2，即 10 。两者异或地结果为 400002 ，二进制值为 10 0000 0000 0010 。这里就是将 hash 的低十六位与高十六位做了异或操作，使得低位与高位 01 分布均匀，减少 hash 冲突。

我们转进 putVal 里面。

    final V putVal(int hash, K key, V value, boolean onlyIfAbsent, boolean evict)

前两个参数我们很清楚，但后面两个是什么意思呢？

onlyIfAbsent ，为 true 时，不会改变原值。

evict，为 false时，表格处于创建模式。用不到，暂时不用理解。

    Node<K, V>[] tab; Node<K, V> p; int n, i;
    if ((tab = table) == null || (n = table.length) == 0) {
        n = (tab = resize()).length;
    }

我们先不理会我们创建的值，单看判断语句。这里写得很紧凑，可以这么改写一下，方便理解。

    Node<K, V>[] tab = table;int n;
    if (tab == null || table.length == 0) {
        tab = resize();
    }
    n = tab.length;

由于 table 表在构造时没有初始化，所以 table 为 null 。我们接着转入 resize 方法里面看看。

## resize 方法

第一步，保存旧值。

    Node<K, V>[] oldTab = table;
    int oldCap = (oldCap == null)?0:oldCap.length;

保存原有的 table 的值并记录长度。如果为 null 则记录为 0 。

    int oldThr = threshold;
    int newCap, newThr = 0;

threshold ，阈值，为 capacity * load factor 的结构，是下一次需要 resize 的大小。

随后我们进入下一个判断。

    if (oldCap > 0) {
        // 先不理会
    } else if (oldThr > 0) {
        // 先不理会
    } else {
        newCap = DEFAULT_INITIAL_CAPACITY;
        newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
    }
    threshold = newThr;

此时我们的阈值和容量都为 0 ，于是就加载默认的配置，然后将新的阈值赋值给 threshold。

DEFAULT_INITIAL_CAPACITY，1 << 4，就是 16。

DEFAULT_LOAD_FACTOR，0.75f，就是 0.75。

    Node<K, V>[] newTab = (Node<K, V>)new Node[newCap];
    table = newTab;

初始化此处的空间。

然后结束初始化。回到我们的 putVal 方法。

## putVal 方法

    if ((p = tab[i = (n - 1) & hash]) == null) {
        // 等会会讲
    }

又是一个紧凑的写法。我们可以用我们自己的方法改写一下。

    int i = (n - 1) & hash;
    Node<K, V> p = tab[i];
    if (p == null)

比较有意思的地方在于，我们没有直接使用 hash 做下标，问题很明显，这个 hash 会超过我们的 table 长度。

一般的想法是取模，我们会写成：

    int i = hash % (n - 1);

但 % 操作很慢，所以此处用 & 代替 % 操作。

如果长度为 16，则二进制为 10000，减一为 1111 。我们的 hash 是 984877383，二进制是 11 1010 1110 0001 1101 0000 0000 0111。我们取与之后的结果是 0111，就是 7。这与我们 984877383 % 16 的结果一致。不过，这也是得益于长度为 2 的整数幂。这点可以从我们的二进制操作中得出。如果我们想要让(n - 1) % hash 与 hash % (n - 1)行为一致的话，ｎ必须为 2 的整数幂。

    tab[i] = newNode(hash, key, value, null);

由于当前所有节点是空的，符合条件，所以我们进入分支。在这里我们只是新建一个节点。

    Node<K, V> newNode(int hash, K key, V value, Node<K, V> next) {
        return new Node<>(hash, key, value, next);
    }

完成之后，我们进入收尾。

    ++mCount;

mCount 是记录我们修改了 HashMap 的次数。这个是用于 faild-fast 的。

    if (++size > threshold)
        resize();
    afterNodeInsertion(evict);
    return null;

size 是记录有多少个键值对被占用，简单来说，就是 table 中不为空的个数。

如果 size 大于阈值，就重新调整大小，但我们目前没有。

afterNodeInsertion(evict) ，空函数，无意义。

最后返回值为 null 。

这就是整个插入一个无冲突值的过程。

## 第二个 put 方法

接着是有冲突的 put ，前面都差不多。

    if ((p = tab[i = (n - 1) & hash]) == null)
        tab[i] = newNode(hash, key, value, null);

我们进入 else 分支。

    Node<K, V> e; K k;
    if (p.hash == hash &&
       ((k = p .key) == key  || (key != null && key.equals(k))))
        e = p;

我们进行转写。

    Node<K, V> e;
    K k = p .key;
    if (p.hash == hash && (k == key || (key != null && key.equals(k))))
        e = p;

判断 hash 值是否相同，然后判断键值是否都相同。这里首先判断 k == key ，首先规避 k 为 null 的情况。

如果符合条件，就暂时取出原来的节点。

     if (e != null) {
         V oldValue = e.value;
         if (!onlyIfAbsent || oldValue == null)
             e.value = value;
         afterNodeAccess(e);
         return oldValue;
    }

此时存在需要被替换替换的节点，我们取出原来的节点。

onlyIfAbsent 此时为 false ，所以直接替换原值。

afterNodeAccess(e) 为空函数。

返回旧值。

## 另一段代码

再进行 Debug 。

    public class Collec {
        public static void main(String[] args) {
            HashMap a = new HashMap(2);
            a.put("sd", "54");
            a.put("sds", "125"); // breakpoint
        }
    }

由于我们设置的容量为 2，这里就发生了碰撞。

我们看看在链表情况下的代码。

    for (int binCount = 0; ; ++binCount) {
        if ((e = p.next) == null) {
            p.next = newNode(hash, key, value, null);
            if (binCount >= TREEFIY_THRESHOLD - 1)
                treeifyBin(tab, hash);
            break;
        }
        if (e.hash == hash &&
           ((k = e.key) == key || (key != null && key.equals(k))))
            break;
        p = e;
    }

这块代码也是挺紧凑的，转写一下。

    for (int binCount = 0; ; ++binCount) {
        e = p.next;
        if (e == null) {
            p.next = newNode(hash, key, value, null);
            if (binCount >= TREEFIY_THRESHOLD - 1)
                treeifyBin(tab, hash);
            break;
        }
        if (e.hash == hash &&
           ((k = e.key) == key || (key != null && key.equals(k))))
            break;
        p = e;
    }

没有改多少，e = p.next 和 p = e 完成遍历链表。binCount 计算链表里的元素个数。

由于我们要添加的新节点是之前没有过的，所以我们将进入 e == null 的分支。TREEFIY_THRESHOLD 的值为 8 。

在我们完成新节点的添加之后，我们将进入之前我们进入过的代码。

    ++modCount;
    if (++size > threshold)
        resize();
    afterNodeInsertion(evict);

我们插入了一对新的键值对，并且超过了阈值，需要进行扩容。

## resize 方法

    if (oldCap > 0) {
        if (oldCap >= MAXIMUM_CAPACITY) {
            threshold = Integer.MAX_VALUE;
            return oldTab;
        }
        else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
                 oldCap >= DEFAULT_INITIAL_CAPACITY)
            newThr = oldThr << 1; // double threshold
    }

此时，我们的 oldCap 为 2 。

MAXIMUM_CAPACITY 为 1 << 30 。

我们重写一下 else-if 判断。

    newCap = oldCap << 1;
    if (newCap < MAXIMUM_CAPACITY && oldCap >= DEFAULT_INITIAL_CAPACITY)
        newThr = oldThr << 1;

很显然，我们的我们原来的容量只有 2 ，两个分支都进不去。

     if (newThr == 0) {
         float ft = (float)newCap * loadFactor;
         newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ?
                   (int)ft : Integer.MAX_VALUE);
     }

获取新的容量大小，比较是否超过了最大容量。

接下来是一段比较长的代码了，我们一段一段地看。

    for (int j = 0; j < oldCap; ++j)

遍历原有的 table 。

    Node<K, V> e;
    if ((e = oldCap[j]) != null)

赋值的同时判断是否是空值，只对非空值进行操作。这种写法很多，不赘述。

    oldCap[j] = null;
    if (e.next == null)
        newTab[e.hash & (newCap - 1)] = e;

如果这个节点是单一的一个的话，根据 newTab 的大小重新计算 hash ，放到对应新的位置。但这里要保证重新计算的 hash 不会重复覆盖，那么如何保证呢？

    else if (e instanceof TreeNode)
        ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);

这里裂树，我们条件没有达到。

     Node<K,V> loHead = null, loTail = null;
    Node<K,V> hiHead = null, hiTail = null;
    Node<K,V> next;
     do {
         next = e.next;
         if ((e.hash & oldCap) == 0) {
             if (loTail == null)
                 loHead = e;
             else
                 loTail.next = e;
             loTail = e;
         }
         else {
             if (hiTail == null)
                 hiHead = e;
             else
                 hiTail.next = e;
             hiTail = e;
         }
     } while ((e = next) != null);

e.hash & oldCap ，当 e.hash 的二进制位数小于 oldCap 时，这个值为0，当且仅当 oldCap 为二的整数幂的时候。如果 e.hash 的二进制位数大于 oldCap 的时候，就把此时的值放在高位。因为 newCap 为 oldCap 的二倍，所以对应位置的偏移为 oldCap + j 。就是下面这段代码的意思。

     if (loTail != null) {
         loTail.next = null;
         newTab[j] = loHead;
     }
    if (hiTail != null) {
        hiTail.next = null;
        newTab[j + oldCap] = hiHead;
    }

## 后记

为了写这个前前后后 Debug 了很久，收获很大。建议有能力的同学一定要自己 Debug 一下。你看一下源码就会发现，这里面坑好多ORZ。后续有时间的话还会再写的。

