---
title: lua 快速入门
date: 2022-01-09T15:01:18+08:00
draft: false
tags:
- lua
- 编程语言学习
categories:
- lua
- 编程语言学习
---

lua 是一门用标准 C 语言编写的、轻量小巧的脚本语言，它常常被嵌入到各种 C 语言项目中做扩展语言。它与 C 的兼容性不必多说，本身也是用 C 写的，速度也是非常的快。像 Redis 、 Nginx 、 AwesomeWM 等都拿它做扩展语言，现在 Neovim 也加入了增强 lua 语言扩展，性能也是非常好。虽然我目前没有用 lua 语言扩展的打算，但也不打算未来不用。总之，先学起来。

## Learn Lua in Y minutes

lua 快速学习， https://learnxinyminutes.com/docs/lua/ 。

## 数据类型

主要分为：

- nil
- number
- boolean
- string
- function
- table

我们一个个看。

### nil

``` lua
local a -- output: nil
```

`nil` 代表空值，默认没有定义时就是 `nil` 。

```
local a = 1
a = nil
```

当变量被赋 `nil` ，变量其实也就被删除了，值在正确的时候会被释放。

### number

``` lua
local num = 42  -- All numbers are doubles.
-- Don't freak out, 64-bit doubles have 52 bits for
-- storing exact int values; machine precision is
-- not a problem for ints that need < 52 bits.
```

number 跟 JavaScript 一样 int 和 double 不分。

### boolean

``` lua
local a = true
local b = false
```

boolean 值主要就是两个： `true` 和 `false` 。

### string

``` lua
s = 'walternate'  -- Immutable strings like Python.
t = "double-quotes are also fine"
u = [[ Double brackets
       start and end
       multi-line strings.]]
e = [=[string have a [[]].]=]
```

lua 有三种表示字符串的方法：单引号、双引号以及括号。前面两个没有什么好说的，考好主要是用以表示多行字符串，以及不转义的字符串表达，想要规避中括号则用 `[=[]=]` ，不想规避直接 `[[]]` 即可。

### function

``` lua
local function foo()
    print("in the function")
    --dosomething()
    local x = 10
    local y = 20
    return x + y
end

local a = foo    --把函数赋给变量

print(a())
```

lua 中视函数也是值，于是我们可以借助回调的手段实现闭包。

### table

``` lua
local corp = {
    web = "www.google.com",   --索引为字符串，key = "web",
                              --            value = "www.google.com"
    telephone = "12345678",   --索引为字符串
    staff = {"Jack", "Scott", "Gary"}, --索引为字符串，值也是一个表
    100876,              --相当于 [1] = 100876，此时索引为数字
                         --      key = 1, value = 100876
    100191,              --相当于 [2] = 100191，此时索引为数字
    [10] = 360,          --直接把数字索引给出
    ["city"] = "Beijing" --索引为字符串
}
```

lua 借助 table 类型以实现面向对象、字典、数组等特性。

值得一提的是， lua 作为数组是，下标是从 1 开始的。

## 局部变量和全局变量

通过上面的代码其实你应该已经注意到了 `local` 这个关键字， `local` 代表局部变量。我们不用 `local` 声明变量不存在语法上的问题，不过此时，我们的变量变成了全局变量。如果不是必要的话，这将会污染我们的全局变量命名空间。因此，还请谨慎把握。

## 控制流

- if/else
- while
- repeat
- for
- break, return 和 goto

### if/else

``` lua
if num > 40 then
  print('over 40')
elseif s ~= 'walternate' then  -- ~= is not equals.
  -- Equality check is == like Python; ok for strs.
  io.write('not over 40\n')  -- Defaults to stdout.
else
  -- Variables are global by default.
  thisIsGlobal = 5  -- Camel case is common.

  -- How to make a variable local:
  local line = io.read()  -- Reads next stdin line.

  -- String concatenation uses the .. operator:
  print('Winter is coming, ' .. line)
end
```

我们可以注意到， lua 的风格是 pascal 式的。

与 C/C++ 不同的是， lua 的 `elseif` 是写在一起的，并不等同于 `else` 里嵌 `if` 。

### while

``` lua
while num < 50 do
  num = num + 1  -- No ++ or += type operators.
end
```

### repeat

``` lua
repeat
  print('the way of the future')
  num = num - 1
until num == 0
```

`repeat` 类似于 `do-while` ，但条件与 `do-while` 是相反的，这点需要注意。

### for

``` lua
karlSum = 0
for i = 1, 100 do  -- The range includes both ends.
  karlSum = karlSum + i
end

-- Use "100, 1, -1" as the range to count down:
fredSum = 0
for j = 100, 1, -1 do
  fredSum = fredSum + j
end
```

这里的 `1, 100` 表示数字 1 到 100 ，且步长为 1 。 `100, 1, -1` 表示数字 100 到 1 ，且步长为 -1 。这里对一个数字范围进行了迭代。

``` lua
-- 打印数组a的所有值
local a = {"a", "b", "c", "d"}
for i, v in ipairs(a) do
  print("index:", i, " value:", v)
end
-- 打印table t中所有的key
for k in pairs(t) do
    print(k)
end
```

这里则对 table 进行了迭代。

### break, return 和 goto

#### break

``` lua
-- 计算最小的x,使从1到x的所有数相加和大于100
sum = 0
i = 1
while true do
    sum = sum + i
    if sum > 100 then
        break
    end
    i = i + 1
end
print("The result is " .. i)  -->output:The result is 14
```

#### return

``` lua
local function add(x, y)
    return x + y
    --print("add: I will return the result " .. (x + y))
    --因为前面有个return，若不注释该语句，则会报错
end

local function is_positive(x)
    if x > 0 then
        return x .. " is positive"
    else
        return x .. " is non-positive"
    end

    --由于return只出现在前面显式的语句块，所以此语句不注释也不会报错
    --，但是不会被执行，此处不会产生输出
    print("function end!")
end

local sum = add(10, 20)
print("The sum is " .. sum)  -->output:The sum is 30
local answer = is_positive(-10)
print(answer)                -->output:-10 is non-positive
```

lua 还可以用 `do-end` 括起来。

``` lua
local function foo()
    print("before")
    do return end
    print("after")  -- 这一行语句永远不会执行到
end
```

#### goto

在 lua 中我们使用 `goto` 来实现 `continue` 。

``` lua
for i = 1, 3 do
    if i <= 2 then
        print(i, "yes continue")
        goto continue
    end

    print(i, " no continue")

    ::continue::
    print([[i'm end]])
end
```

在其他语言里，一般我们不建议使用 `goto` ，主要是因为 `goto` 过分灵活会破坏程序结构。实质上，只要你能把握好代码结构， `goto` 可以更好的简化代码。

## and, or , not

lua 采用了关键字进行布尔运算，类似于 python 。

## 函数

``` lua
function fib(n)
  if n < 2 then return 1 end
  return fib(n - 2) + fib(n - 1)
end

-- Closures and anonymous functions are ok:
function adder(x)
  -- The returned function is created when adder is
  -- called, and remembers the value of x:
  return function (y) return x + y end
end
a1 = adder(9)
a2 = adder(36)
print(a1(16))  --> 25
print(a2(64))  --> 100

-- Returns, func calls, and assignments all work
-- with lists that may be mismatched in length.
-- Unmatched receivers are nil;
-- unmatched senders are discarded.

x, y, z = 1, 2, 3, 4
-- Now x = 1, y = 2, z = 3, and 4 is thrown away.

function bar(a, b, c)
  print(a, b, c)
  return 4, 8, 15, 16, 23, 42
end

x, y = bar('zaphod')  --> prints "zaphod  nil nil"
-- Now x = 4, y = 8, values 15...42 are discarded.

-- Functions are first-class, may be local/global.
-- These are the same:
function f(x) return x * x end
f = function (x) return x * x end

-- And so are these:
local function g(x) return math.sin(x) end
local g; g  = function (x) return math.sin(x) end
-- the 'local g' decl makes g-self-references ok.

-- Trig funcs work in radians, by the way.

-- Calls with one string param don't need parens:
print 'hello'  -- Works fine.
```

lua 的函数定义其实一看就懂，这里比较特色的是， lua 函数传参允许传更多的参数，虽然多出来的会被抛弃；可以不用圆括号；多返回值。

当我们不为函数设定名字是，该函数就是匿名函数。函数也分全局函数和局部函数，前面讲过，不赘述。

## 函数回调

``` lua
unpack = table.unpack or unpack

local function run(x, y)
    print("run", x, y)
end

local function attack(targetId)
    print("targetId", targetId)
end

local function callback(method, ...)
    local args = {...} or {}
    method(unpack(args, 1, #args))
end

callback(run, 1, 2)
callback(attack, 1111)
```

## 简单的面向对象

``` lua
Dog = {}                                   -- 1.

function Dog:new()                         -- 2.
  newObj = {sound = 'woof'}                -- 3.
  self.__index = self                      -- 4.
  return setmetatable(newObj, self)        -- 5.
end

function Dog:makeSound()                   -- 6.
  print('I say ' .. self.sound)
end

mrDog = Dog:new()                          -- 7.
mrDog:makeSound()  -- 'I say woof'         -- 8.
-- 1. Dog acts like a class; it's really a table.
-- 2. function tablename:fn(...) is the same as
--    function tablename.fn(self, ...)
--    The : just adds a first arg called self.
--    Read 7 & 8 below for how self gets its value.
-- 3. newObj will be an instance of class Dog.
-- 4. self = the class being instantiated. Often
--    self = Dog, but inheritance can change it.
--    newObj gets self's functions when we set both
--    newObj's metatable and self's __index to self.
-- 5. Reminder: setmetatable returns its first arg.
-- 6. The : works as in 2, but this time we expect
--    self to be an instance instead of a class.
-- 7. Same as Dog.new(Dog), so self = Dog in new().
-- 8. Same as mrDog.makeSound(mrDog); self = mrDog.
```

下面是继承：

``` lua
LoudDog = Dog:new()                           -- 1.

function LoudDog:makeSound()
  s = self.sound .. ' '                       -- 2.
  print(s .. s .. s)
end

seymour = LoudDog:new()                       -- 3.
seymour:makeSound()  -- 'woof woof woof'      -- 4.

-- 1. LoudDog gets Dog's methods and variables.
-- 2. self has a 'sound' key from new(), see 3.
-- 3. Same as LoudDog.new(LoudDog), and converted to
--    Dog.new(LoudDog) as LoudDog has no 'new' key,
--    but does have __index = Dog on its metatable.
--    Result: seymour's metatable is LoudDog, and
--    LoudDog.__index = LoudDog. So seymour.key will
--    = seymour.key, LoudDog.key, Dog.key, whichever
--    table is the first with the given key.
-- 4. The 'makeSound' key is found in LoudDog; this
--    is the same as LoudDog.makeSound(seymour).

-- If needed, a subclass's new() is like the base's:
function LoudDog:new()
  newObj = {}
  -- set up newObj
  self.__index = self
  return setmetatable(newObj, self)
end
```

## 模块

``` lua
local _M = {}

local function get_name()
    return "Lucy"
end

function _M.greeting()
    print("hello " .. get_name())
end

return _M
```

在这里我们定义了一个 table ，并在最后将它 `return` 出去， `_M` 就是我们这个模块所要导出的数据。注意，这里全局变量其实是会有影响的，不定义为 `local` 才能暴露出去。

``` lua
local my_module = require("my")
my_module.greeting()     -->output: hello Lucy
```

`require` 加载模块，返回值就是之前的 `_M` 。

## 其他一些要注意的

### 数组大小的获取

``` lua
local a = {1, 2, 3, 4}
print #a
```

`#` 操作符可以获取数组的长度。

### 虚变量

``` lua
local t = {1, 3, 5}

print("all  data:")
for i,v in ipairs(t) do
    print(i,v)
end

print("")
print("part data:")
for _,v in ipairs(t) do
    print(v)
end
```

虚变量指的是 `_` ，一般我们不会去读它的值。虚变量可以被多次使用。

``` lua
function foo()
    return 1, 2, 3, 4
end

local _, _, bar = foo();    -- 我们只需要第三个
print(bar)
```

一般就是用来占位的。

### 比较运算符

lua 的不等于为 `~=` ，其他的与 C 基本一致。

### 调用代码前先定义函数

lua 必须先定义，后调用，这与 JavaScript 还有 Python 不一样。

### 点号与冒号操作符的区别

``` lua
obj = { x = 20 }

function obj:fun1()
    print(self.x)
end
```

等价于

``` lua
obj = { x = 20 }

function obj.fun1(self)
    print(self.x)
end
```

