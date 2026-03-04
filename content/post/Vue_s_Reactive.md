---
title: "Vue 的响应式原理"
date: 2026-03-04T19:46:28+08:00
markup: pandoc
draft: false 
categories:
- Vue
tags:
- Vue
- 前端
---

Vue 3 使用 `Proxy` 是一大创举，它成功解决了 Vue 2 无法追踪新增属性的问题。不过，仅仅是如此吗？不如我们用简单的代码实现一个 `reactive` 看看。

```javascript
function reactive(target) {
  return new Proxy(target, {
    get(target, key, recevier) {
      return Reflect.get(target, key, recevier);
    },
    set(target, key, value, recevier) {
      return Reflect.set(target, key, value, recevier);
    }
  });
}
```
这里，`Reflect` 和 `Proxy()` 是配套的，等同于我们直接对 `target[key]` 进行操作，但用 `Reflect` 更加方便，也更加安全。我们可以通过在拦截器层面增加 `console.log()` 来查看效果。

但目前的代码和存在着一个问题，就是我们只能对第一层的属性进行追踪。这个问题也很好办，如果我们遇到对象，就同样对对象进行 `reactive()` 。这里我们需要排除 `null` ，因为 `null` 也是 `object` 。

```javascript
function reactive(target) {
  return new Proxy(target, {
    get(target, key, recevier) {
      const newTarget = Reflect.get(target, key, recevier);
      if (newTarget != null && typeof newTarget === 'object') {
        return reactive(newTarget);
      }
      return newTarget;
    },
    set(target, key, value, recevier) {
      return Reflect.set(target, key, value, recevier);
    }
  });
}
```

很好！完成拦截后，我们需要对这些属性和依赖做些什么，就是将依赖与属性相互关联。显然，我们需要一个数据结构存储这些依赖关系。

我们首先需要记录哪些对象有了依赖，这些对象的哪个属性有了依赖。前一点意味着我们需要用对象作为键值，这里，我们使用 `WeakMap()` 进行记录。它有两个好处，其一，我们可以使用对象作为键值；其二，也是最重要的，它是个弱引用，不影响 GC 。其次，是该 `WeakMap()` 的值，显然，它应该是个 `Map()` ，因为我们存储对应键名的依赖，这就有个一对多的关系。这个 `Map()` 应该记录键名和依赖集合 `Set()` ，最后的类型大概是这样 `WeakMap<any, Map<any, Set<any>>>()`。

接着，我们需要一个方法去记录当前的依赖。

```javascript
let activeEffect = null;
function effect(fn) {
    activeEffect = fn;
    fn();
    activeEffect = null;
}
```

`effect()` 就是运行的作用域，我们会收集在这个作用域内出现的依赖。收集依赖我们会使用 `track()` ，触发依赖我们会使用 `trigger()` 。

```javascript
const targetMap = new WeakMap();

function reactive(target) {
  return new Proxy(target, {
    get(target, key, recevier) {
      const newTarget = Reflect.get(target, key, recevier);
      // 新增收集依赖
      track(target, key);
      if (newTarget != null && typeof newTarget === 'object') {
        return reactive(newTarget);
      }
      return newTarget;
    },
    set(target, key, value, recevier) {
      // 新增触发依赖
      trigger(target, key);
      return Reflect.set(target, key, value, recevier);
    }
  });
}

function track(target, key) {
    if (!activeEffect) return;
    let depsMap = targetMap.get(target);
    if (!depsMap) {
        targetMap.set(target, (depsMap = new Map()));
    }
    let deps = depsMap.get(key);
    if (!deps) {
        depsMap.set(key, (deps = new Set()));
    }
    deps.add(activeEffect);
}

function trigger(target, key) {
    const depsMap = targetMap.get(target);
    if (!depsMap) return;
    const deps = depsMap.get(key);
    if (!deps) return;
    deps.forEach(fn => fn());
}
```

至此，我们已经实现了一个极简版本的 reactive 。我们写一点代码进行测试。

```javascript
const a = reactive({ name: 1 });
effect(() => {
    console.log(a.name);
});

a.name = 2;
```

结果为：

```
1
2
```

很好！但是，在没有 `Proxy()` 和 `WeakMap()` 的情况下，一个 Vue 2 版本是如何实现的呢？

第一件事是相同的，我们需要拦截所有的 `get()` 和 `set()` 。在 es5 下，我们只能使用 `Object.defineProperty()` 。

```javascript
function observe(data) {
  if (typeof data !== 'object' || data == null) return data;

  Object.keys(data).forEach(key => {
    defineReactive(data, key, data[key]);
  });
}

function defineReactive(obj, key, val) {
  Object.defineProperty(obj, key, {
    get() {
      return val;
    },
    set(newVal) {
      if (newVal === val) return;
      val = newVal;
      observe(newVal);
    }
  });
}
```

思想与之前使用 `Proxy` 时是一样的，但实现的细节不同。在 Vue 2 下，我们需要提前遍历所有的属性，因为 `Object.defineProperty()` 只能作用于已有的属性。

接着，我们需要设计一个收集依赖的数据结构。在这里，我们不能使用 `WeakMap()` ，我们得寻找到一个替代品。我们为什么要使用 `WeakMap()` ？最重要的一点是，因为它不会影响 GC ，因为我们不知道对象什么时候被释放，所以，最好记录对象的依赖对象能随着对象一起被收集。我们想到了什么？闭包。我们把创建闭包的时机放到监听对象属性时，这样，当对象属性消失时，记录依赖的对象也会一起被释放。不过，原来存储依赖的数据结构层级，就与数据本身紧密耦合了，但我们别无选择。

```javascript
let ativeEffect = null;
class Dep {
  constructor() {
    this.subs = new Set();
  }
  depend() {
    if (activeEffect) {
      this.subs.add(activeEffect);
    }
  },
  notify() {
    this.subs.forEach(fn => fn());
  }
}

function defineReactive(obj, key, val) {
  const deps = new Dep();
  Object.defineProperty(obj, key, {
    get() {
      deps.depend();
      return val;
    },
    set(newVal) {
      if (newVal === val) return;
      val = newVal;
      deps.notify();
      observe(newVal);
    }
  });
}
```

我们在此将依赖封装成了一个对象 `Dep` 。这里真正重要的是依赖集合，除此之外的，比如说 `Dep()` 对象，都不是关键内容。 最后，我们仍然使用 `effect` 将一切连接起来。

```javascript
function effect(fn) {
  activeEffect = fn();
  fn();
  activeEffect = null;
}
```

如果你阅读过 Vue 2 源码，你会发现我们与源码的实现差距很大。Vue 2 使用了一个 `Watcher` 对象， 而我们使用 `effect()` ，但我们也实现了同样的效果。究其原因，是因为我们掌握了其实现的根本原理。我们可以看到 Vue 2 和 Vue 3 实现的核心思想：任何对变量属性的操作都无法逃脱对 `get()` 和 `set()` 的调用，一旦我们知道了当前正在运行的函数，我们就可以将变量与函数关系起来，从而构建起一张依赖网络。

在 Vue 2 下，受限于 API 的使用，我们只能使用 `Object.defineProperty()` ，而在 Vue 3 ，我们才算真正实现了这一思想。在原本 Vue 3 代码的基础上，我们只是在 `reactive()` 中改用了 `Object.defineProperty()`，并修改了存储依赖的数据结构 ，就获得 Vue 2 版本的代码。Vue 2 和 Vue 3 在范式上的变化是表层，其核心思想是一直不变的。如果你观察尤雨溪初版的 Vue 3 代码，你会发现，他几乎是在将 Vue 2 版本的代码转译成 Vue 3 的。

很多面试题都会考察 Vue 2 与 Vue 3 之间的区别，却鲜少着眼于 Vue 2 和 Vue 3 之间不变的地方。这是不对的。当你掌握了什么东西是不变的，你才能知道什么东西是可变的。变化的是表象，而不变的才是根基。
