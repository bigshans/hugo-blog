---
title: TypeScript 类型体操之斐波那契
date: 2021-12-17T15:26:50+08:00
draft: false
tags:
- typescript
- 元编程
categories:
- typescript
---

类型体操如果不是写库的话，基本上是屠龙技。 TypeScript 的类型系统本质上是一个小函数式语言，通过类型体操能够更清晰的感受到这一点。不过 TypeScript 类型系统有限制，并不能跟真正的函数式相媲美。但我们仍然可以写一个斐波那契数列小试牛刀。

## 数字表示

数字我们用数组的长度表示。

```typescript
type Length<A extends any[]> = A['length'];
type ToNum<N extends number, A extends any[] = []> =
    Length<A> extends N ? A : ToNum<N, [any, ...A]>;
```

显然， `extends` 在这里起到了类似相等比较符的作用，三目运算符起到了 `if...else` 的作用。上面一段代码转成一般的 TypeScript 函数是这样的：

```typescript
const Length = (A: any[]) => A.length;
const ToNum = (N: number, A: any[] = []) =>
    Length(A) === N ? A : ToNum<N, [1, ...A]>
```

主要原因在于我们并不能正常使用数字进行加减乘除，所以只好曲线救国。我们的数字就是数组，想要查看数字是多少就将这样：

```typescript
type Two = Length<ToNum<2>>; // 2
```

鼠标移动到 `Two` 上就可以看到数字 2 了。

## 两数相加

两数相加的就很简单了，只要把数组合并就行了。

```typescript
Add<A extends number, B extends number> = 
    Length<[...ToNum<A>, ...ToNum<b>]>
```

我们来试一下：

```typescript
type Five = Add<2, 3>; // 5
```

## 减一

其实如果你愿意的话可以做减任意，这里我们写的简单一点，就写减一，对于斐波那契而言是足够的了。

```typescript
type CutOne<T extends any[]> = 
    T extends [any, ...infer R] ? R : [];
type CutOneNum<T extends number> = Length<CutOne<ToNum<T>>>;
```

这里我们用到了 `infer` 。 `infer` 是个很常用的关键词，常常用于解包已有类型，非常好用。比如上面的例子，我们将剩余数组命名为类型 `R` ，并提取出来可以用到外面。

## 斐波那契

首先我们先简单写一下用普通 TypeScript 如何实现斐波那契函数。

```typescript
function fib(a: number) {
    if (a === 1) {
        return 1;
    } else (a === 2) {
        return 2;
    }
    return fib(a - 1) + fib(a - 2);
}
```

工具已经准备好了，我们只需依葫芦画瓢就行了。

```typescript
type fib<N extends number> = 
  N extends 1 ? 1
    : (N extends 2 ? 1 
      : Add<
          fib<(CutOneNum<N>)>
        ,
          fib<(CutOneNum<(CutOneNum<N>)>)>
        >);
```

由于 TypeScript 类型递归深度限制，你会看到这里有报错，但并不影响我们使用（就是玩，嘿）。

```typescript
type Fib5 = fib<5>; // 5
```

数列是

$$
fib=1,1,2,3,5,\ldots,a,b,a+b
$$

也可以写一个函数证明一下：

```typescript
const fib = 
    (n: number) => 
        n === 1 ? 1 
            : (n === 2 ? 1 : (fib(n - 1) + fib(n - 2)));
fib(5); 5
```

嗯，不如直接写 lisp (逃

---

更新：我艹，真有大佬写了 lisp 解释器！

[TypeScript 类型体操天花板，用类型运算写一个 Lisp 解释器 - 掘金](https://juejin.cn/post/7024673107906396190)

真的 NB ！

另外，我又写了大小比较的代码，只适用于整数，我觉得这个挺好玩的。

```typescript
type Gt<A extends any[], B extends any[]> =
 A extends [...B, ...infer R] ?
   (R extends [] ? false : true)
: false;
type T = Gt<ToNum<0>, ToNum<3>>;
```
