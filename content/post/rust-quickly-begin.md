---
title: Rust 极简入门
date: 2021-10-09T15:57:32+08:00
draft: true
tags:
- rust
categories:
- rust
---

一个幽灵，一个 Rust 的幽灵，在 Cpp 的上空游荡......咳咳，开玩笑。

Rust 是值得一学的语言，但它的学习难度也另人望而生畏。因为它的内容众多，概念复杂，我觉得我需要对这些内容做一个“手术”，使得我们能够先熟悉 Rust ，而后再去攻克难点，本篇也是按照这个顺序去推进的。我们不着手大项目，尽量从简单的代码入手去学习最最基础的代码。

## Hello World!

我假设你已经安装了 Rust ，我们首先来写一个编程的传统代码 Hello World 。

我建议代码都自己敲一遍。

``` Rust
fn main() {
    println!("Hello World!");
}
```

我们运行 `rustc` 编译，运行之后会打印 `Hello World!` 。

这段代码我们可以知道东西：

- Rust 与 C 、 C++ 类似都有一个入口函数，并且都叫 `main` 。
- 函数的标识为 `fn` ，目前我们没有看到参数定义和返回值定义，所以一个纯空函数的定义是这样的。
- `println!` 用于换行打印，其实也有 `print!` ，它们实际上不是函数，这点与 C 、 C++ 类似。
- 目测字符串与字符的标识是双引号与单引号。

目前我们不能了解更多了，我们继续。

## 变量声明

``` Rust
fn main() {
    let a = 123;
    println!("a: {}", a);
    let a = 134; // 直接 a = 134 错误
    println!("a: {}", a);
}
```

这段代码是最简单的变量声明，涉及到几个问题：

- 变量使用 `let` 声明，但是要改变变量的值，需要显示的使用 `let` 改变，但是一定要这样做吗？

  ``` rust
  fn main() {
      let mut a = 123;
      println!("a: {}", a);
      a = 134; // 直接 a = 134 错误
      println!("a: {}", a);
  }
  ```

  使用 `let mut` 进行声明就没有问题了，其中 `mut` 是  mutable 的简写。

- `println!` 打印变量使用 `{}` 占位。

- 类型是可以隐式声明的，但变量类型在声明后固定，不存在隐式转换。

### 变量与常量

``` rust
fn main() {
    const A:i32 = 123;
    println!("A: {}", A);
    let b = 134 + A;
    println!("b: {}", b);
}
```

这段代码大家可以做几次尝试，比如将 `A` 改为 `a` ，去除 `A` 的类型声明，常量再赋值等。

- 常量名小写会有 WARN ，一般我们约定常量名大写。
- 常量类型必须显式声明。
- 常量只能声明一次，不像变量一样存在多次声明的可能。

## 数据类型

有一下基础类型：

- 整数
- 浮点数
- 布尔
- 字符
- 复合

### 整数

整数按照位长度和有无符号分为 12 种。

| 位数     | 有符号 | 无符号 |
| -------- | ------ | ------ |
| 8        | i8     | u8     |
| 16       | i16    | u16    |
| 32       | i32    | u32    |
| 64       | i64    | u64    |
| 128      | i128   | u128   |
| 平台相关 | isize  | usize  |

其中 `isze` 和 `usize` 一般用来衡量数据大小。

### 浮点数

分为 32 位和 64 位：

- `f32`
- `f32`

### 布尔

就是 `true` 或 `false`

### 字符

`char` 。

### 复合类型

这里讲元组和数组。

#### 元组

``` rust
fn main() {
    let tup: (i32, f64, u8) = (500, 6.4, 1);
    let (x, y, z) = tup;
    println!("{}, {}, {}", x, y, z);
}
```

其中 `(i32, f64, u8)` 。

#### 数组

``` rust
fn main() {
    let arr: [i32; 5] = [1, 2, 3, 4, 5];
    println!("{}", arr[0]);
}
```

其中 `[i32; 5]` 为数组类型的声明。



注意，你不能直接打印复合类型。

## 条件判断

Rust 的条件判断与其他语言基本一致，也是 `if` 、 `else if` 、 `else` 。

``` rust
fn main() {
    let number = 15;
    let b: i32;
    if number < 5 {
        b = 1;
    } else if number < 10 {
        b = 2;
    } else {
        b = 3;
    }
    println!("b: {}", b);
}
```

Rust 的条件判断可以省略括号，但是不能省略 `{}` ，在这一点上与 Golang 类似。显然，由于 Rust 不像 C/C++ 一样隐式类型转换，所以我们不能用 `0` 代表 `false` ， `1` 代表 `true` 。

除此之外， `Rust` 是没有三目运算符的，不过 `Rust` 提供了新的表达式形式。

``` rust
fn main() {
    let number = 15;
    let b: i32 = if number > 15 { 1 } else { 2 };
    println!("b: {}", b);
}
```

其中 `{}` 中的是我们的值，且 `{}` 不能省略。

## 函数声明

现在我们学习函数的声明，我们已经知道了其中一种函数的声明，但我们仍然需要更进一步的函数声明供我们学习。

### 最基础的函数声明

``` rust
fn add(x: i32, y: i32) -> i32 {
    return x + y;
}
```

`fn` 是 function 单词的简写，参数声明的方式与变量声明的方式类似，不过这里使用 `->` 而不是 `:` 代表返回值，如果没有返回值则代表无返回值。

至此，我们目前的知识可以来写一个简单的斐波那契。

``` rust
fn fib(n: i64) -> i64 {
    return if n <= 2 { 1 } else { fib(n - 1) + fib(n - 2) };
}

fn main() {
    println!("fib: {}", fib(20));
}
```

### 无 `return` 的返回

在 Rust 中，我们也可以不写 `return` ，比如：

``` rust
fn fib(n: i64) -> i64 {
    if n <= 2 { 1 } else { fib(n - 1) + fib(n - 2) }
}

fn main() {
    println!("fib: {}", fib(20));
}
```

注意，返回的这一句之后不能再有语句，且这一句不以分号结尾。

### 使用 `{}` 表达式

``` rust
fn main() {
    let x = 5;

    let y = {
        let x = 3;
        x + 1
    };

    println!("x: {}", x);
    println!("y: {}", y);
}
```

虽然 `{}` 里面最后的值也是不加分号，但是不能使用 `return` 。

## 循环判断

Rust 的循环有三个， `while` 、 `for` 和 `loop` 。

### `while` 循环

``` rust
fn main() {
    let mut x = 1;
    while x < 5 {
        println!("x: {}", x);
        x += 1;
    }
}
```

Rust 中的 `while` 与其他语言差不多。虽然 Rust 的 do 是作为保留字，但是 Rust 并没有 do-while 语句。

### `for` 循环

`for` 可用于迭代。

``` rust
fn main() {
    let a = [1, 2, 3, 4, 5];
    for x in 1..5 {
        println!("x: {}", x);
    }
    for x in a.iter() {
        println!("a: {}", x);
    }
}
```

其中 `1..5` 可以用以生成 1 、 2 、 3 、 4 、 5 的序列。

### `loop` 循环

`loop` 是无限循环。

```
fn main() {
    let a = [1, 2, 3, 4, 5];
    let mut i = 0;
    loop {
        if i >= 5 {
            break;
        }
        println!("x: {}", a[i]);
        i += 1;
    };
}
```

也是非常好用的语法了。

## 所有权

这里我们不得不涉及 Rust 里的内存概念：所有权。

所有权有三条基本概念：

    1. Rust 中的每一个值都有一个被称为其 **所有者**（owner）的变量。
    2. 值在任一时刻有且只有一个所有者。
    3. 当所有者（变量）离开作用域，这个值将被丢弃。

先记住，我们以 `String` 作为例子。

### 移动

``` rust
fn main() {
    let x1 = String::from("hello");
    // let x2 = x1;
    println!("{}", x1);
}
```

`String::from()` 为我们创建了一个在堆上的数据，但是当我们解除注释时，我们发现代码报错了， rustc 提醒我们 “move occurs because `x1` has type `String`, which does not implement the `Copy` trait” 。

这是怎么回事呢？

当我们令 `x2` = `x1` 时，一般的语言会选择将 `x1` 上的内容复制到 `x2` 上，从而使得 `x1` 、 `x2` 都指向同一个地址。当然，也可以选择将 `x1` 所指向的内容做一份复制，并用新的指针指向新的内容并赋值给 `x2` ，但明显地，这很耗费性能。不过 Rust 是怎么做的呢？

我们需要先回忆一下所有权的三个概念。当我们令 `x2` = `x1` 时，显然 `x1` 是实际上是一个指针，那么 `x1` 赋值 `x2` 时就是指针，于是 `x1` 和 `x2` 都指向了同一块数据，此刻，同一块数据有两个所有者，于是与所有权 1 、 2 条发生相悖， Rust 这时候就选择了取消 `x1` 的所有权，并把它的所有权转交给 `x2` 。

也就是说， `x2` = `x1` 在 Rust 里就是真正意义上的转移， `x1` 数据转移到 `x2` 上， `x1` 进而失效。

实际上，这个报错主要是因为我们使用了一个无效变量导致的，当我们使用 `x2` 时就不会有这个问题。

``` rust
fn main() {
    let x1 = String::from("hello");
    let x2 = x1;
    println!("{}", x2);
}
```

#### 参数转移

``` rust
fn printStr(x: String) {
    println!("{}", x);
}

fn main() {
    let x1 = String::from("hello");
    printStr(x1);
    println!("{}", x1);
}
```

我们运行以上代码会发现我们遇到与之前一样的错，这是因为当我们调用 `printStr()` 时， `x1` 的所有权就转移给 `printStr()` 的 `x` 上了，当函数结束时， `x` 离开了作用域，根据第三条原则，值被丢弃。

那我们应该如何处理呢？

``` rust
fn main() {
    let s1 = String::from("hello");

    let (s1, len) = calculate_length(s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: String) -> (String, usize) {
    let length = s.len(); // len() 返回字符串的长度

    (s, length)
}
```

我们使用元组可以返回数据，顺便把需要的参数传出来。但这么写起来未免太麻烦了。
