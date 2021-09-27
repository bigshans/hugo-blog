---
title: Sku 算法浅讲
date: 2021-09-27T17:41:12+08:00
draft: false
tags:
- algorithm
categories:
- algorithm
---

一个重复写过几次的老算法了，今天总结一下大体思路。这是一个在电商领域非常常见的算法，就是选择商品 Sku 时的算法。

这个算法的写法非常只多，往往需要根据你自己的数据结构，还有业务的各种奇怪的需求。

一般来说，每当用户选择一个属性时，就要为用户禁用掉一些不可能的组合，这个算法就是需要实时运行的。先说一下，这个算法复杂度还是挺高的，利用了集合的思想，只要 Sku 的情况不是很复杂，这个算法都没有什么问题，所幸基本上不会太复杂。

接下来我们正式开始讲。

首先，我们的属性是分层的，每一层下面是多个不同的属性，总体的数据结构类似一层的森林结构。显然，一个 Sku ，它的属性集合中的每一个属性的所在层，与其他属性的所在层都应该不同。这一点先记住。

然后，当用户属性的时候，如果是已选择的属性，则取消选择，如果是未选择，假如同层已有其他已选择的属性，则取消已选择的属性，然后选择我们需要选择的属性。选择部分就是这样了，选择完成后我们开始校验是否可以禁用该属性。

我们首先取出我们选择过的所有属性，然后我们遍历这些属性。我们获取这些属性所在的层，将层中除被我们选中的属性，其之外的属性逐一与我们所选的属性进行替换，并与所有的 Sku 进行比较，如果至少存在一项，则不禁用。

然后，我们同样遍历所有未选择过的层。我们获取这些里的属性，然后依次放入一个属性组成一个新的集合，并判断是否未某个 Sku 的子集。如果是，则不禁用。

这部分讲得很抽象，其实代码不难，我给一下伪代码：

```
properties; # 所有的属性
propertiesOfSelected; # 被选中的属性
propertiesOfNotSelectedLayers = getLayers(properties) - getLayers(propertiesOfSelected); # 未选中的属性层

for prop in propertiesOfSelected:
    propertiesOfSelected = propertiesOfSelected - prop
    propertiesLayer = getLayer(properties, prop) # 选中的属性层
    for replace in propertiesLayer:
        propertiesOfSelected = propertiesOfSelected + replace
        for sku in skus:
            # 如果是 sku 的子集，则不禁用
            if sku.has(propertiesOfSelected):
                markEnable(replace)
                break
        propertiesOfSelected = propertiesOfSelected - replace
    propertiesOfSelected = propertiesOfSelected + prop

# 遍历未选中层
for layer in propertiesOfNotSelectedLayers:
    # 遍历层中属性
    for prop in layer:
        propertiesOfSelected = propertiesOfSelected + prop
        for sku in skus:
            if sku.has(propertiesOfSelected):
                markEnable(prop)
                break
        propertiesOfSelected = propertiesOfSelected - prop
```

大致是这样的，一些集合的交并操作我用加减表示了，以上。
