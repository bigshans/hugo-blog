---
title: 如何写一个深拷贝函数
date: 2021-08-22T14:52:42+08:00
draft: false
tags:
- Deep Clone
- Javascript
categories:
- Javascript
---

跟小伙伴们讨论的时候发现，es6 的解构其实和 `Object.assign` 一样属于是浅拷贝。那么一个深拷贝到底该怎么写呢？我个人阅读了一下 lodash 、 rambda 、 rfdc 的实现，发现思想其实都是一样，由于 rfdc 放弃了对一些内容的支持，使得它的速度飞快，但这些内容实际上我是需要的，所以 rfdc 不考虑。剩下两个实现思想基本上是一样的，但是 lodash 的实现内容很多，没有 rambda 简洁，所以我以 rambda 为蓝本自己写了一个深拷贝函数。

## 基本思路

首先，不同数据类型不同的方式处理，我们使用递归的方法依次遍历。这里除了基本类型以外，其他的诸如数组、对象、日期、正则等等，都需要特殊处理。这里还有个问题，就是循环依赖。我们可以各个节点的对象缓存起来，然后在每次遍历前进行依次检查，发现存在循环依赖，就直接返回。我们来看看代码。

## 编写

我们需要一个方法来检测数据类型：

``` javascript
function type(val) {
  // 特判 null 和 undefined ，因为这两个会报错
  return val === 'null' ?
    'Null'
    :val === undefined
    ? 'Undefined'
    : Object.prototype.toString.call(val).slice(8, -1);
}
```

然后是主要的代码：

``` javascript
function clone(source) {
  // null 和 undefined 在 == 下相等
  return source == null ? source : _clone(source);
}

// 克隆正则
function _cloneRegExp(pattern) {
  return new RegExp(pattern.source,
    (pattern.global     ? 'g' : '') +
    (pattern.ignoreCase ? 'i' : '') +
    (pattern.multiline  ? 'm' : '') +
    (pattern.sticky     ? 'y' : '') +
    (pattern.unicode    ? 'u' : ''));
}

function _clone(value, refFrom, refTo) {
  // 递归克隆，并在内部构建函数处理，主要是为了保留变量
  // 防止参数传递过多造成编写困难
  function copy(copiedValue) {
    const len = refFrom.length;
    let idx = 0;
    // 循环引用查找
    while (idx < len) {
      if (value === refFrom[idx]) {
        return refTo[idx];
      }
      idx += 1;
    }
    // 无循环引用，自动扩充一位
    refFrom[idx] = value;
    refTo[idx] = copiedValue;
    for (const key in value) {
      if (value.hasOwnProperty(key)) {
        copiedValue[key] = _clone(value[key], refFrom, refTo, true);
      }
    }
    return copiedValue;
  };
  switch (type(value)) {
    case 'Object':  return copy(Object.create(Object.getPrototypeOf(value)));
    case 'Array':   return copy([]);
    case 'Date':    return new Date(value.valueOf());
    case 'RegExp': return _cloneRegExp(value);
    case 'Int8Array':
    case 'Uint8Array':
    case 'Uint8ClampedArray':
    case 'Int16Array':
    case 'Uint16Array':
    case 'Int32Array':
    case 'Uint32Array':
    case 'Float32Array':
    case 'Float64Array':
    case 'BigInt64Array':
    case 'BigUint64Array':
      return value.slice();
    default:        return value;
  }
}
```

`copy` 函数放在内部影响不大。

``` javascript
    const len = refFrom.length;
    let idx = 0;
    while (idx < len) {
      if (value === refFrom[idx]) {
        return refTo[idx];
      }
      idx += 1;
    }
    refFrom[idx] = value;
    refTo[idx] = copiedValue;
```

这段代码是检测循环依赖的，如果没有循环依赖则缓存对象键值。

下面的数组处理实际上是在处理 `Buffer` 。

``` javascript
    case 'Object':  return copy(Object.create(Object.getPrototypeOf(value)));
```

这里还弄了原型链，基本上非常完善了。
