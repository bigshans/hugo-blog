---
title: "《Vuejs设计与实现》读书笔记"
date: 2023-01-08T13:37:21+08:00
markup: pandoc
draft: false
categories:
- 笔记
tags:
- 笔记
- Vue
---

## 第二篇 响应系统

### 第四章 响应系统的作用与实现

#### 设计完善的响应式系统

借助 `Proxy` ，我们实现一个基本的响应式系统。书中代码我改成可以在 Node 中运行的代码了。

```javascript
const bucket = new Set();

const data = { text: 'hello world' };

const obj = new Proxy(data, {
    get(target, key) {
        bucket.add(effect);
        return target[key];
    },
    set(target, key, newVal) {
        target[key] = newVal;
        bucket.forEach(fn => fn());
        return true;
    }
});

function effect() {
    console.log(obj.text);
}

effect();

setTimeout(() => {
    obj.text = 'Hello Vue';
}, 1000);
// Output:
// hello world
// Hello Vue
```

这里是写死了 `effect` ，不过不用太过纠结。

基本思路是：

- 读取的时候，副作用函数执行的时候，触发读操作，并把副作用函数放入桶内。
- 修改时，拦截写操作，执行副作用函数。

由于我们的副作用函数是硬编码，使得我们的代码非常不好维护。为此，我们还需要一个依赖收集函数来收集副作用函数。

```javascript
const bucket = new Set();

const data = { text: 'hello world' };

let activeEffect;

function effect(fn) {
    activeEffect = fn;
    fn();
}

const obj = new Proxy(data, {
    get(target, key) {
        if (activeEffect) {
            bucket.add(activeEffect);
        }
        return target[key];
    },
    set(target, key, newVal) {
        target[key] = newVal;
        bucket.forEach(fn => fn());
        return true;
    }
});

effect(() => {
    console.log(obj.text);
});

setTimeout(() => {
    obj.text = 'Hello Vue';
}, 1000);
```

但如果我们为 `obj` 添加一个不存在的属性，我们会发现副作用方法仍然被执行了。而且，如果我们添加多个 target ，只要任意一个 target 被执行，就会引起所有的副作用函数被执行。因为我们并没有在副作用函数与数据字段之间建立起明确的关系，为此我们需要重新设计我们的数据结构。

```javascript
const bucket = new WeakMap();

const data = { text: "hello world" };
let activeEffect;

function effect(fn) {
    activeEffect = fn;
    fn();
}

const obj = new Proxy(data, {
    get(target, key) {
        if (!activeEffect) return target[key];
        let depsMap = bucket.get(target);
        if (!depsMap) {
            bucket.set(target, ( depsMap = new Map() ));
        }
        let deps = depsMap.get(key);
        if (!deps) {
            depsMap.set(key, (deps = new Set()));
        }
        deps.add(activeEffect);
        return target[key];
    },
    set(target, key, value) {
        target[key] = value;
        const depsMap = bucket.get(target);
        if (!depsMap) return;
        const effects = depsMap.get(key);
        effects && effects.forEach(fn => fn());
    }
});

effect(() => {
    console.log(obj.text);
});

setTimeout(() => {
    obj.text = "Hello Vue";
}, 1000);
```

首先，我们需要用 `WeakMap` 来收集 `target` ，确保对应的 `target` 变动只会影响与之有关的副作用函数。使用 `WeakMap` 可以确保引用关系是弱引用，从而不影响 GC 。

其次，我们收集 `target` 对应的 `key` 的副作用函数，这些函数将构成一个集合，在需要的时候被执行。

我们简单重构一下代码：

```javascript
const bucket = new WeakMap();

const data = { text: "hello world" };
let activeEffect;

function effect(fn) {
    activeEffect = fn;
    fn();
}

const obj = new Proxy(data, {
    get(target, key) {
        track(target, key);
        return target[key];
    },
    set(target, key, value) {
        target[key] = value;
        trigger(target, key);
    }
});

function track(target, key) {
    if (!activeEffect) return;
    let depsMap = bucket.get(target);
    if (!depsMap) {
        bucket.set(target, ( depsMap = new Map() ));
    }
    let deps = depsMap.get(key);
    if (!deps) {
        depsMap.set(key, (deps = new Set()));
    }
    deps.add(activeEffect);
}

function trigger(target, key) {
    const depsMap = bucket.get(target);
    if (!depsMap) return;
    const effects = depsMap.get(key);
    effects && effects.forEach(fn => fn());
}

effect(() => {
    console.log(obj.text);
});

setTimeout(() => {
    obj.text = "Hello Vue";
}, 1000);
```

思考以下代码：

```javascript
const data = { ok: true, text: "hello world" };
// 前略

effect(() => {
  console.log(obj.ok ? obj.text : "not");
});
```

当 `obj.ok` 为 `true` 时，依赖收集会为我们收集 `ok` 和 `text` ，为 `false` 时，会收集到 `ok` 字段。但 `obj.ok` 是会变动的，而这种变动显然会引起依赖的变动，而目前我们的代码显然无法收集这种变动。这会引起依赖变动的缺失和冗余。为了解决这个问题，我们可以副作用函数执行时，重新绑定依赖。

```javascript
const bucket = new WeakMap();

const data = { text: "hello world" };
let activeEffect;

function effect(fn) {
    const effectFn = () => {
        // 切断依赖
        cleanup(effectFn);
        activeEffect = effectFn;
        // 重新收集依赖
        fn();
    };
    effectFn.deps = [];
    effectFn();
}

function cleanup(effectFn) {
    for (let i = 0; i < effectFn.deps.length; i++) {
        const deps = effectFn.deps[i];
        deps.delete(effectFn);
    }
    effectFn.deps = [];
}

const obj = new Proxy(data, {
    get(target, key) {
        track(target, key);
        return target[key];
    },
    set(target, key, value) {
        target[key] = value;
        trigger(target, key);
    }
});

function track(target, key) {
    if (!activeEffect) return;
    let depsMap = bucket.get(target);
    if (!depsMap) {
        bucket.set(target, ( depsMap = new Map() ));
    }
    let deps = depsMap.get(key);
    if (!deps) {
        depsMap.set(key, (deps = new Set()));
    }
    deps.add(activeEffect);
    // 添加依赖
    activeEffect.deps.push(deps);
}

function trigger(target, key) {
    const depsMap = bucket.get(target);
    if (!depsMap) return;
    const effects = depsMap.get(key);
    // 复制一份 Set ，防止原依赖集合变动从而引起循环
    const effectsToRun = new Set(effects);
    effectsToRun.forEach(fn => fn());
}

effect(() => {
    console.log(obj.text);
});

setTimeout(() => {
    obj.text = "Hello Vue";
}, 1000);
```

#### 嵌套 effect

 我们当前的实现并不支持嵌套 effect ，因为我们使用了全局变量 `ativeEffect` 来注册 `effect` 函数，在 effect 嵌套时，就会引起覆盖。

```javascript
const data = { foo: true, bar: true };
let temp1, temp2;

// 省略

effect(() => {
    console.log('effectFn1 执行');
    effect(function effectFn2() {
        console.log('effectFn2 执行');
        temp2 = obj.bar;
    });
    temp1 = obj.foo;
});

setTimeout(() => {
    obj.foo = "Hello Vue";
}, 1000);

// Output:
// effectFn1 执行  
// effectFn2 执行  
// effectFn2 执行
```

我们需要一个 `effectStack` 来解决这个问题。

```javascript
let activeEffect;
let effectStack = [];
function effect(fn) {
    const effectFn = () => {
        cleanup(effectFn);
        effectStack.push(effectFn);
        activeEffect = effectFn;
        fn();
        effectStack.pop();
        activeEffect = effectStack[effectStack.length - 1];
    };
    effectFn.deps = [];
    effectFn();
}
```

`activeEffect` 相当于栈顶指针， `effectStack` 相当于执行栈。当嵌套发生时，位于栈顶的 `effect` 则始终等于当前值的 `effect` ，从而避免发生错乱。

#### 避免无限循环

如果 trigger 触发执行的副作用函数与当前正在执行的副作用函数相同，则不触发执行。

```javascript
const data = { foo: 1 };

// 省略

function trigger(target, key) {
    const depsMap = bucket.get(target);
    if (!depsMap) return;
    const effects = depsMap.get(key);
    const effectsToRun = new Set();
    // 过滤与当前执行 effect 相同的副作用函数
    effects && effects.forEach(effectFn => {
        if (effectFn !== activeEffect) {
            effectsToRun.add(effectFn);
        }
    });
    effectsToRun.forEach(effectFn => effectFn());
}

effect(() => {
    obj.foo++;
});
```

未完待续。
