---
title: PHP学习（一）—— 面向过程的 PHP
date: 2022-01-12T11:51:08+08:00
draft: false
tags:
- php
- 编程语言学习
categories:
- php
- 编程语言学习
---

PHP 其实很早之前就学过，但时间一长没有用，基本上是忘了。所以最近是重新捡起来。 PHP 很语法还是很缝合的，光看它面向过程的语法像 C ，但面向对象像 C++ 和 Java 的杂交，而且 PHP 虽然兼容，但如果尽量用上新特性的话，都觉得是两门语言。我并不打算学过去 PHP 5 那种语法，当初学得恶心，最新的 PHP 语法其实好很多。

## 变量与常量定义

### 变量

PHP 的变量名都以 `$` 开头，槽点挺多的， PHP 程序员是多想要钱啊……咳咳，除开 `$` ，变量名其实与一般语言命名一样。

``` php
<? php
$greeting = "Hello, World!";
$_greeting = "Hello, World!";
$greeting_1 = "Hello, World!";
# $1greeting = "Hello, World!"; 错误
# $greeting-1 = "Hello, World!"; 错误
?>
```

PHP 作为一门若类型的动态弱类型语言，声明变量和使用都十分灵活。

``` php
<?php
$greeting = "你好， PHP！";
$var_name = "greeting";
echo $$var_name; // 等同于 echo $greeting;
?>
```

因为 `$varName` 的变量值是 `greeting` ，所以当我们调用 `$$varName` 时， `$varName` 被替换成 `greeting` ，因此实际上引用的是 `$greeting` ，由于 `$varName` 的值可以动态设置，所以也就可以实现了一个可变变量。

### 常量

PHP 的常量使用 `define` 方法定义，也可以使用 `const` 关键字定义，不过 `const` 一般在类中使用居多，但在文件中使用也是可以的。

``` php
<?php
define("HELLO", "HELLO");
const WORLD = "WORLD";
echo HELLO." ".WORLD;
?>
```

## 基本数据类型

主要是数字、字符串、布尔这三类。查看数据类型我们可以使用 `var_dump` 方法。

### 数字

数字分为整型与浮点型。

``` php
<?php
$time = 2022;
var_dump($time); // int(2022)
$f = 2.2;
var_dump($f); // float(2.2)
?>
```

不过需要注意的是， `1 / 2` 结果为浮点数，而不是整型。

``` php
<?php
echo var_dump(1 / 2); // float(0.5)
?>
```

### 字符串

PHP 字符串使用单引号和双引号皆可，但二者在功能上稍有区别。

``` php
<?php
echo '\'\n';
echo "\n";
?>
```

单引号不发生转义，除了 `\'` 。双引号可以，同时也可以类似模板字符串使用变量。

``` php
<?php
$name = "Jack";
$hello = "Hello World, $name\n";
echo $hello;
$name = "Mike";
echo $hello;
echo "Hello World, {$name}\n";
echo "Hello World, ${name}\n";
# Output:
# Hello World, Jack
# Hello World, Jack
# Hello World, Jack
# Hello World, Jack
?>
```

多行字符串使用 `<<<'END' ... END` 或 `<<<END ... END` ，区别也在于一个转义一个不转义。

``` php
<?php
// Since PHP 5.3, nowdocs can be used for uninterpolated multi-liners
$nowdoc = <<<'END'
Multi line
string
END;

// Heredocs will do string interpolation
$heredoc = <<<END
Multi line
$sgl_quotes
END;
?>
```

### 布尔

PHP 的布尔类型数值如常规一样，是 `true` 和 `false` ，但两个值大小写不敏感。

``` php
<?php
$boolean = true;  // or TRUE or True
$boolean = FALSE; // or false or False
?>
```

### 类型判断与类型转换

虽然 `var_dump` 可以判断类型，但有时候我们想要更直接的方法去判断，因此 PHP 提供了 `is_string` 、 `is_int`/`is_integer` 、 `is_float`/`is_double` 、 `is_bool` 等方法。

PHP 的类型转换形式上与 C 语言还是很相似的。

``` php
<?php
$str = "123";
$int = 2020;
$float = 99.0;
$bool = false;

var_dump((int) $str);
var_dump((bool) $str);
var_dump((string) $str);
var_dump((bool) $str);
var_dump((int) $float);
var_dump((string) $float);
var_dump((string) $bool);
var_dump((int) $bool);
?>
```

## 数组

PHP 数组比较早的时候只能用 `array` 方法，后面才有 `[]` 语法，两种创建方式实际上是类似的。

PHP 数组与 lua 的 table 类似，揉捏了列表和字典的结构，但是从 0 开始。

``` php
<?php
$nums = [2, 4, 8, 16, 32];
$nums_old = array(2, 4, 8, 16, 32);
echo var_dump($nums);
echo var_dump($nums_old);
?>
```

PHP 数组也可以当作字典使用。

``` php
<?php
$book = ['name' => '不能承受的生命之轻', 'author' => '米兰昆德拉'];
$book_old = array('name' => '不能承受的生命之轻', 'author' => '米兰昆德拉');
echo var_dump($book);
echo var_dump($book_old);
?>
```

也可以混合使用。

``` php
<?php
$game = ['明日方舟', 'company' => '鹰角网络'];
$game_old = array('明日方舟', 'company' => '鹰角网络');
echo var_dump($game);
echo var_dump($game_old);
?>
```

没有定义索引的就自动使用数字进行索引了。

当然，虽然我们可以写代码进行增删，但如果语言本身提供了就更加方便了。在 PHP 中，我们可以使用 `array_push` 进行添加，使用 `unset` 来取消数组中的某一个值。

``` php
<?php
$a = [1, 2, 3];
array_push($a, 5);
print_r($a);
unset($a[1]);
print_r($a);
?>
```

`unset` 也可以用来取消任何一个变量，如果我们想要删除整个数组，我们可以直接 `unset($a)` 。

PHP 也允许我们直接用索引的方式添加。

``` php
<?php
$a = [1, 2, 3];
$a[3] = 5;
print_r($a);
unset($a[1]);
print_r($a);
?>
```

但这里有一个问题，就是当我们删了一个值之后，数字索引就乱了， PHP 为我们提供了一个方法来重排索引， `array_values` 。

``` php
<?php
$a = [1, 2, 3];
$a[3] = 5;
print_r($a);
unset($a[1]);
$a = array_values($a);
print_r($a);
?>
```

如果我们想知道数组大小呢？我们可以通过 `count` 函数获得。

``` php
<?php
$a = [1, 2, 3];
echo count($a);
?>
```

你可以看到上面的代码我们用了两种不同的方式打印数组， `var_dump` 和 `print_r` 。 `var_dump` 会详细展示类型信息，而 `print_r` 则会吐出更精简的数组结构，区别仅仅在此。

## PHP 控制结构

PHP 的控制结构与 C 语言大致相近，除了 `foreach` 。

### 分支结构

#### `if`

``` php
<?php
if (true) {
    print 'I get printed';
}

if (false) {
    print 'I don\'t';
} else {
    print 'I get printed';
}

if (false) {
    print 'Does not get printed';
} elseif (true) {
    print 'Does';
}

if (false) {
    print 'Does not get printed';
} else if (true) {
    print 'Does';
}
?>
```

还有一种模板结构。

``` php
<?php if ($x): ?>
This is displayed if the test is truthy.
<?php else: ?>
This is displayed otherwise.
<?php endif; ?>
```

#### `switch`

``` php
<?php
$x = 0;
switch ($x) {
    case '0':
        print 'Switch does type coercion';
        break; // You must include a break, or you will fall through
               // to cases 'two' and 'three'
    case 'two':
    case 'three':
        // Do something if $variable is either 'two' or 'three'
        break;
    default:
        // Do something by default
}
?>
```

#### `while`

``` php
<?php
$i = 0;
while ($i < 5) {
    echo $i++;
} // Prints "01234"

echo "\n";

$i = 0;
do {
    echo $i++;
} while ($i < 5); // Prints "01234"
?>
```

#### `foreach`

PHP 的 `foreach` 主要是用于迭代的。

``` php
<?php
foreach($data as $key => $val) {
    // ...
}
?>
```

这里的 `$data` 是需要迭代的对象， `$key` 是键名， `$val` 是键值。如果只想要值的话可以不要 `$key` 。

``` php
<?php
foreach($data as $val) {
    // ...
}
?>
```

``` php
<?php
$wheels = ['bicycle' => 2, 'car' => 4];

// Foreach loops can iterate over arrays
foreach ($wheels as $wheel_count) {
    echo $wheel_count;
} // Prints "24"

echo "\n";

// You can iterate over the keys as well as the values
foreach ($wheels as $vehicle => $wheel_count) {
    echo "A $vehicle has $wheel_count wheels";
}

echo "\n";
?>
```

#### `for`

PHP 的 `for` 与 C 大致一样。

``` php
<?php
$i = 0;
for ($i = 0; $i < 5; $i++) {
    if ($i === 3) {
        continue; // Skip this iteration of the loop
    }
    echo $i;
} // Prints "0124"
?>
```

## 运算符

除了正常的加减乘除之外， PHP 还引入了求幂符号 `**` 。

PHP 还有自增运算符 `--` 、 `++` 。

比较运算符的情况类似于 JavaScript ，基本上就是多了 `<>` 、 `<=>` 。前者等于 `!=` ，后者情况比较特殊，被称做结合比较运算符。

``` php
<?php
$a = 100;
$b = 1000;

echo $a <=> $a; // 0 since they are equal
echo $a <=> $b; // -1 since $a < $b
echo $b <=> $a; // 1 since $b > $a
?>
```

逻辑运算符与 C 语言一致。

特别提一点，字符串连接使用 `.` 而不能使用 `+` 。

## 函数

### 自定义函数

``` php
<?php

/**
 * 计算两数相加之和
 * @param $a
 * @param $b
 * @return mixed
 */
function add($a, $b) {
    $sum = $a + $b;
    return $sum;
}
?>
```

从 PHP 7 开始允许声明数值类型。

``` php
<?php
/**
 * 计算两数相加之和
 * @param int $a
 * @param int $b
 * @return int
 */
function add(int $a, int $b): int {
    $sum = $a + $b;
    return $sum;
}
?>
```

这样，任何非 `int` 类型的参数都无法传入。

函数参数默认以值传递方式进行传递，无论是基本类型还是其他的。想要引用传递则使用 `&` 符号。

``` php
<?php
$a = [1, 2, 3];
function test(array $k) {
    $k[1] = 1;
}
test($a);
print_r($a); // 没变
function test_1(array &$k) {
    $k[1] = 1;
}
test_1($a);
print_r($a); // 变了
?>
```

### 匿名函数

``` php
<?php
$add = function(int $a, int $b): int {
    return $a + $b;
};
$sum = $add(1, 2);
echo $sum . PHP_EOL;
?>
```

### 可变参数与默认参数

可变参列表使用 `...` 定义。

``` php
<?php
function call_user_func ($function, ...$parameter) {
    print_r($parameter);
}
?>
```

默认参数需要放到最后。

``` php
<?php
function add($x, $y = 1) { // $y is optional and defaults to 1
    $result = $x + $y;
    return $result;
}
?>
```

还有一种完全放弃治疗的获取参数方式。

``` php
<?php
// You can get all the parameters passed to a function
function parameters() {
    $numargs = func_num_args();
    if ($numargs > 0) {
        echo func_get_arg(0) . ' | ';
    }
    $args_array = func_get_args();
    foreach ($args_array as $key => $arg) {
        echo $key . ' - ' . $arg . ' | ';
    }
}

parameters('Hello', 'World'); // Hello | 0 - Hello | 1 - World |
?>
```

### 可变函数

以匿名函数的方式定义的变量也被视作函数变量，由于是变量，所以就可以被重新定义。这种在运行时动态设置函数类型值给变量的功能，在 PHP 中称之为可变函数。

``` php
<?php
/**
 * 通过匿名函数定义两数相加函数 add
 * @param int $a
 * @param int $b
 * @return int
 */
$add = function (int $a, int $b = 2): int {
    return $a + $b;
};

/**
 * 两数相乘函数 multi
 * @param int $a
 * @param int $b
 * @return int
 */
$multi = function (int $a, int $b): int {
    return $a * $b;
};

// 调用匿名函数
$n1 = 1;
$n2 = 3;
$sum = $add($n1, $n2);
echo "$n1 + $n2 = $sum" . PHP_EOL;
// 将 multi 赋值给 $add
$add = $multi;
$product = $add($n1, $n2);
echo "$n1 x $n2 = $product" . PHP_EOL;
?>
```

## 函数作用域

PHP 的函数作用域是隔得非常清楚的，如果不声明，函数是无法使用父作用域的。

``` php
<?php
$n1 = 1;
$n2 = 3;

function t() {
    global $n1;
    return function () use ($n1) {
        return $n1;
    };
}

// 计算两数相加
$add = function () use ($n1, $n2) {
    return $n1 + $n2;
};

// 计算两数相乘
$multi = function () use ($n1, $n2){
    return $n1 * $n2;
};

// 调用匿名函数
$sum = $add();
echo "$n1 + $n2 = $sum" . PHP_EOL;
$product = $multi();
echo "$n1 x $n2 = $product" . PHP_EOL;
?>
```

对于匿名函数，可以使用 `use` 使用父作用域关键字，同样也可以使用 `global` 定义全局作用域可访问值。除此之外， PHP 还提供了 `$GLOBALS` 数组，数组内就是全部的全局变量。

## 小结

PHP 是个多范式编程语言，面向过程编程只是其最基本的编程形式。相对其他语言来说， PHP 是个自由度非常大的语言，同时也对代码质量管理提出了挑战。关于 PHP 的 OOP ，以后有时间再谈吧！
