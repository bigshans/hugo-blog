---
title: "如何正确的替换 HTML"
date: 2023-02-18T14:08:26+08:00
draft: false
tags:
- 前端
categories:
- 前端
---

算是私人页的一个 BUG ，之前没有注意到。使用 `innerHTML` 进行替换后，替换内容内所有的 `script` 都失效了，这是符合浏览器预期的，可见 MDN 。

> Although this may look like a cross-site scripting attack, the result is harmless. HTML specifies that a `<script>` tag inserted with innerHTML should not execute.

换句话说，如果你不是插入 `<script>` 标签的话，`innerHTML` 是不执行的。但现状是，我需要它执行。我也不想要一个个去插入 `<script>` ，这不现实。因此，我想到的办法是 `eval()` 。

虽然 `eval()` 挺脏的，但在这种情景下是可预期的。步骤可以分为两步，第一步替换 HTML ，第二步获取脚本执行。脚本分为两种，一种是内嵌的 JavaScript 代码，另一种则需要我去手动拉取。我个人直接用了 `fetch` 。 `fetch` 基本上主流的浏览器都兼容了，并不需要太多的思考。

代码如下：

```javascript
async function filled() {
    const scripts = document.body.querySelectorAll("script");
    for (const script of scripts) {
        try {
            if (script.src) {
                eval(await (await fetch(script.src)).text());
            } else {
                eval(script.innerText);
            }
        } catch(e) {
            console.error(e);
        }
    }
}
```

代码采用了顺序的方式执行。这是极为简单的一种实现，因为没有考虑 `module` 还有属性不为 `javascript` 的情况，不过也是够用了。
