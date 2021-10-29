---
title: Rust 快速入门
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

#### 引用与借用

为了解决上面的麻烦， Rust 引入了引用。

我们将上面的代码改写为引用版本。

``` rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

使用引用，我们就将变量引入到作用域内来，但离开作用域的时候，值也不会被丢弃，在 Rust 里，我们使用 **借用** （borrowing） 这个词来描述此种行为。
值得注意的是，引用默认与赋值的情况一样，是不可更改的，比如像下面的代码，是不可以被编译通过的。

``` rust
fn main() {
    let s = String::from("hello");

    change(&s);
}

fn change(some_string: &String) {
    some_string.push_str(", world");
}
```

但如果我们确实需要改变所指向的值该怎么办呢？与赋值一样使用 `mut` 。我们稍加改造，上面的代码就可以通过了。

``` rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

我们称呼为可变引用。

但引用的使用也有限制，总的遵循一下两条规则：

    - 在任意给定时间，要么**只能有一个可变引用**，要么**只能有多个不可变引用**。
    - 引用必须总是有效的。

### 克隆与基础数据类型

有些时候我们实际上是需要一份一模一样的新数据作为我们的值，我们可以使用 `clone()` 方法来了解决这个问题。

``` rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone();

    println!("s1 = {}, s2 = {}", s1, s2);
}
```

另外，基础数据类型是直接使用克隆而不是像对象一样使用移动的。

``` rust
fn main() {
    let x = 5;
    let y = x;

    println!("x = {}, y = {}", x, y);
}
```

## 切片

切片就是对一段连续数据序列的引用，这个引用是不可变引用。

```rust
fn main() {
    let s = String::from("Hello, World!");
    let part1 = &s[0..6];
    let part2 = &s[6..13];
    println!("{}={}+{}", s, part1, part2);
}
```

`..` 我们在循环章节看过， `0..6` 代表一个 $0 \le i < 6$ 区间的切片。
除此之外， `..` 还有其他的状态。

    `..y` 等价于 `0..y` 。
    `x..` 等价于从 x 开始到结束。
    `..` 等价于全部的数据。

另外，我们说过，切片是不可变引用，因此我们不能改变切片的值。

``` rust
fn main() {
    let mut s = String::from("Hello, World");
    let slice = &s[0..6];
    s.push_str("Jack!"); // 错误
    println!("slice = {}", slice);
}
```

另外，还有一个有趣的问题不知道你有没有发现。我们一直在使用 `String` 而不是直接使用字符串，这是为什么呢？

如果我们直接使用字符串，我们实际上使用的是 `&str` ，换而言之，就是引用。而 `String` 就是对 `&str` 的包装。裸用 `&str` 其实是既不方便又不安全的，所以我们使用 `String` 。不过，我们可以使用切片进行非常简单的转换。

``` rust
fn main() {
    let s1 = String::from("hello");
    let s2 = &1[..];
    println!("{}", s2);
}
```

当然，我们说切片适用于**连续序列**，所以也不止于字符串。

``` rust
fn main() {
    let arr = [1, 2, 3, 4, 5, 6];
    let part = &arr[0..3];
    for i in part.iter() {
        println!("{}", i);
    }
}
```

## 结构体

Rust 结构体的定义使用 `struct` 关键字。

``` rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}
```

定义结构体后，我们就可以创建一个结构体了。

``` rust
let user1 = User {
    email: String::from("hello@exmaple.com"),
    username: String::from("user"),
    active: true,
    sign_in_count: 1,
};
```

Rust 创建结构体的方法其实与 JS 创建对象的方法类似，熟悉 JS 的方法应该很熟悉。

Rust 还可以这样创建。

``` rust
fn build_user(email: String, username: String) -> String {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}
```

结构体也可以使用别的结构体进行创建。

``` rust
fn main() {
    struct User {
        username: String,
        email: String,
        sign_in_count: u64,
        active: bool,
    }

    let user1 = User {
        email: String::from("someone@example.com"),
        username: String::from("someusername123"),
        active: true,
        sign_in_count: 1,
    };

    let user2 = User {
        active: user1.active,
        username: user1.username,
        email: String::from("another@example.com"),
        sign_in_count: user1.sign_in_count,
    };
}
```

我们也可以使用 `..` 来指定剩余为显示设置的字段。

``` rust
let user2 = User {
    email: String::from("another@example.com"),
    ..user1
}
```

一定需要注意的是，当我们这样使用的时候，就相当于我们在调用 `=` ，我们的值将会发生移动，在上面的例子里，我们将不能再使用 `user1` 。

#### 元组结构体

``` rust
struct Color(i32, i32, i32);
let black = Color(0, 0, 0);
```

### 枚举

我们使用 `enum` 来定义枚举，例如

``` rust
enum IpAddrKind {
    V4,
    V6,
}
```

其中 `IpAddrKind` 为我们定义的枚举， `V4` 、 `V6` 为枚举的成员。

这是一个非常简单的创建，我们也可以简单创建一个实例。

``` rust
let four = IpAddrKind::V4;
let six = IpAddrKind::V6;
```

但光是这样有时候对我们来说并不太够，我们可以将它与实际上的数据进行绑定。

``` rust
enum IdAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

let home = IpAddrKind::V4(127, 0, 0, 1);
let loopback = IpAddr:V6(String::from("::1"));
```

事实上，你会问这样定义枚举又什么意义？ Rust 中的枚举其实是为了 `match` 控制准备的。

### `match` 模式匹配

Rust 有一个叫做 match 的极为强大的控制流运算符，它允许我们将一个值与一系列的模式相比较，并根据相匹配的模式执行相应代码。模式可由字面值、变量、通配符和许多其他内容构成。match 的力量来源于模式的表现力以及编译器检查，它确保了所有可能的情况都得到处理。我们目前讲得比较简单。

``` rust
fn main() {
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
}
```

结构上似乎与我们常见的 `switch` 非常相似，但 `match` 比 `switch` 要强大得多。

我们还可以对它进行值匹配。

``` rust
fn main() {
    let book = 1;
    match book {
        1 => {
            println!("{}", book);
        },
        _ => {
            println!("fuck!");
        }
    }
}
```

`_` 在次是用来兜底的，相当于 `default` ， Rust 会穷尽所有的模式，如果又代码没有处理完成就会报错。

### `Option`

`Option` 是 Rust 标准库里的一个枚举。它的定义如下：

``` rust
enum Option<T> {
    Some(T),
    None,
}
```

你不需要显示引入它。这里 Rust 用到了泛型。

`None` 意味着无， `Some` 意味着被保存的非空数据。

我们结合 `Option` 和 `match` 一起写个程序。

``` rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

fn main() {
    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);
    println!("{} {:?}", six.unwrap(), none);
}
```

### `if let` 简单控制流

`if let` 语法让我们以一种不那么冗长的方式结合 `if` 和 `let` ，来处理只匹配一个模式的值而忽略其他模式的情况。考虑下面的例程，它匹配一个 `Option<u8>` 值并只希望当值为 3 时执行代码：

``` rust
fn main() {
    let some_u8_value = Some(0u8);
    match some_u8_value {
        Some(3) => println!("three"),
            _ => (),
    }
}
```

但是 `- => ()` 为我们添加许多无用的代码，我们想要写的更简洁。

``` rust
fn main() {
    let some_u8_value = Some(0u8);
    if let Some(3) = some_u8_value {
        println!("three");
    }
}
```

如此我们省去了无用的分支，减少了模板代码的编写。同时我们也可以结合 `else` 来减少 `match` 的啰嗦。

``` rust
fn main() {
    enum UsState {
        Alabama,
        Alaska,
    }

    enum Coin {
        Penny,
        Nickel,
        Dime,
        Quarter(UsState),
    }
    let coin = Coin::Penny;
    let mut count = 0;
    if let Coin::Quarter(state) = coin {
        println!("State quarter from {:?}!", state);
    } else {
        count += 1;
    }
}
```

## Cargo 基础

Cargo 是 Rust 的构建系统和包管理器，我们一般用它来创建 Rust 工程，管理 Rust 依赖。

### Cargo 基本功能

Cargo 可以完成从项目创建，到构建、运行等一系列工程。

``` bash
cargo new newproject # 创建项目
cd newproject
cargo build # 编译项目
cargo run # Hello, world!
```

在项目的目录下面有 `Cargo.toml` 文件和 `src` 目录，前者记录了项目的一些基本信息和项目的依赖，后者就是项目的 Rust 源码了。

### 模块和权限控制

Rust 中的组织单位是模块。

``` rust
mod nation {
    mod government {
        fn govern() {}
    }
    mod congress {
        fn legislate() {}
    }
    mod court {
        fn judicial() {}
    }
}
```
