---
title: 用 Svelte 写个简单的 Todo
date: 2021-02-16T20:30:32+08:00
draft: false
categories:
- Svelte
tags:
- 前端
- Svelte
---

> 官网： https://svelte.dev/

Svelte 是个新的前端框架，发展强劲。与目前主流的三大框架不同的是，Svelte 不采用 vdom ，而是借助 complier 的能力，打包出最小化的包，不附带更多的 runtime 。Svelte 是由 rollup 作者开发的 Reative 框架，语法与 vue 很像，个人简单写了一下，速度是真的给力，打包也是真的简洁。

下面是我简单用 Svelte 写的简单 Todo ，只有添加功能，不过实现起来相当舒服。

App.svelte:

```html
<script>
    let list = ['a'];
    let todo = '';
    function add() {
        if (todo !== '') {
            list[list.length] = todo;
            todo = '';
        }
    }
</script>

<style>
    #todo {
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        position: absolute;
        height: 100%;
        width: 100%;
    }
</style>

<div id="todo">
    <input bind:value={todo} />
    <button on:click={add}>添加</button>

    {#each list as todo}
        <li>{todo}</li>
    {/each}
</div>
```

可以在官网的 REPL 里粘贴进去运行。

编译后总代码不到 4KB ，是相当小了。
