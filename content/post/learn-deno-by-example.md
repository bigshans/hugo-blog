---
title: "从例子开始学习 Deno"
date: 2022-04-14T17:30:03+08:00
draft: false
tags:
- deno
- typescript
categories:
- deno
---

Deno 算是一个新的 TypeScript 运行时，个人简单看了一下，感觉还可以。用来简单写一些东西还是很方便的。但网络上 Deno 相关的教程都很老了， Deno 都出正式了，但相关的教程大多还是尝鲜，所以找例子的时候遇到了很大的问题。

建议到[官方的 Example](https://examples.deno.land) 上去找。

## HTTP Server 的例子

Hello World 级别的例子，但是由于版本变化，所以网上的很多例子跑不起来。

```typescript
import { serve } from "https://deno.land/std/http/server.ts";

serve(() => new Response('Hello World!'));
```

服务会跑在 8000 端口。可以设置成别的端口。

为了防止因为版本变化而导致脚本失效，请标明版本。

```typescript
import { serve } from "https://deno.land/std@0.129.0/http/server.ts";

serve(() => new Response('Hello World!'));
```

官方的例子还有两个，一个是路由的例子，一个是 Stream 的例子。

```typescript
import { serve } from "https://deno.land/std@0.129.0/http/server.ts";

const BOOK_ROUTE = new URLPattern({ pathname: '/books/:id' });

function handler(req: Request): Response {
  const match = BOOK_ROUTE.exec(req.url);
  if (match) {
    const id = match.pathname.groups.id;
    return new Response(`Book ${id}`);
  }
  return new Response('Not found (try /books/1)', {
    status: 404,
  })
}

console.log('Running on 8000 port');
serve(handler);
```

`Response` 和 `Response` 是 `fetch` 的。是的， Deno 内置实现了 `fetch` 。

```typescript
import { serve } from "https://deno.land/std@0.114.0/http/server.ts";

function handler(_req: Request): Response {

  let timer: number | undefined = undefined;
  const body = new ReadableStream({

    start(controller) {
      timer = setInterval(() => {
        const message = `It is ${new Date().toISOString()}\n`;
        controller.enqueue(new TextEncoder().encode(message));
      }, 1000);
    },

    cancel() {
      if (timer !== undefined) {
        clearInterval(timer);
      }
    },
  });

  return new Response(body, {
    headers: {
      "content-type": "text/plain",
      "x-content-type-options": "nosniff",
    },
  });
}

console.log("Listening on http://localhost:8000");
serve(handler);
```

Deno 内置了很多类型，且不需要像 Node 一样自己再 `require` 。

这段脚本会一直往客户端写入固定格式的文字。

需要注意的是，以上脚本运行都需要以 `deno run --alow-net <script name>` 的格式运行。 Deno 严格限制了脚本在运行时的权限，以增强安全性。后面还有一些脚本需要打开对应的权限，嫌麻烦可以使用 `--allow-all` 打开全部权限。

## 输入提示的例子

``` typescript
alert("Please acknowledge the message.");
console.log("The message has been acknowledged.");

const shouldProceed = confirm("Do you want to proceed?");
console.log("Should proceed?", shouldProceed);

const name = prompt("Please enter your name:");
console.log("Name:", name);

const age = prompt("Please enter your age:", "18");
console.log("Age:", age);
```

`alert` 、 `confirm` 、 `prompt` 等 API 原本是浏览器所有的，但 Deno 为了保持浏览器和 CLI 下一致性，于是实现了对应的接口。三者可以很方便的实现输入，比 Node 要简单许多。

Deno 除了以上三者，还有 `window` 、 `location` 等。

## 获取环境变量

```typescript
const PORT = Deno.env.get('PORT');
console.log('PORT:', PORT);

const env = Deno.env.toObject();
console.log('env:', env);
Deno.env.set("MY_PASSWORD", "123456");

Deno.env.delete("MY_PASSWORD");

Deno.env.set("MY_PASSWORD", "123");
Deno.env.set("my_password", "456");
console.log("UPPERCASE:", Deno.env.get("MY_PASSWORD"));
console.log("lowercase:", Deno.env.get("my_password"));
```

Deno 把主要的 API 都放在了 `Deno` 对象里，基本上不需要像 Node 一样要额外引入。

`env` 不同于 Node 的 `process.env` ，它是一个对象，可以进行 OOP ，比 Node 进行了更好的封装。

## 依赖管理

```typescript
// deps.ts
export * as http from "https://deno.land/std@0.119.0/http/mod.ts";
export * as path from "https://deno.land/std@0.119.0/path/mod.ts";
```

```typescript
// main.ts
import { path } from "./deps.ts";
```

我觉得这个算是 Deno 的一个毛病吧！ import uri 虽然没有 node_modules 了，但同时也使得依赖管理变得麻烦了，毕竟如果要改版本，就要对所有的 uri 进行替换，问题会很大。

采用 `deps.ts` 基本上就是为了处理这个问题，把所有依赖集中在一起管理，我觉得有点变相 package.json 的意思，而且这个依赖路径写起来也挺麻烦的。

## 移动/重命名文件

```typescript
await Deno.writeTextFile("./hello.txt", "Hello World!");
await Deno.rename("./hello.txt", "./hello-renamed.txt");
console.log(await Deno.readTextFile("./hello-renamed.txt"));

try {
  await Deno.rename("./hello.txt", "./does/not/exist");
} catch (err) {
  console.error(err);
}

Deno.renameSync("./hello-renamed.txt", "./hello-again.txt");

await Deno.writeTextFile("./hello.txt", "Invisible content.");
await Deno.rename("./hello-again.txt", "./hello.txt");
console.log(await Deno.readTextFile("./hello.txt"));
```

涉及到文件读写权限问题，需要加 `--alow-read` 和 `--allow-write` 参数。

Deno 把文件操作也集成到了 `Deno` 对象内，不用像 Node 一样要额外引入 `fs` 。同时 Deno 支持 Top-Level await 。

## `fetch`

```typescript
let resp = await fetch("https://example.com");

console.log(resp.status); // 200
console.log(resp.headers.get("Content-Type")); // "text/html"
console.log(await resp.text()); // "Hello, World!"

resp = await fetch("https://example.com");
await resp.arrayBuffer();
/** or await response2.json(); */
/** or await response2.blob(); */

resp = await fetch("https://example.com");
for await (const chunk of resp.body!) {
  console.log("chunk", chunk);
}

const body = `{"name": "Deno"}`;
resp = await fetch("https://example.com", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "X-API-Key": "foobar",
  },
  body,
});

const req = new Request("https://example.com", {
  method: "DELETE",
});
resp = await fetch(req);

const url = "https://example.com";
new Request(url, {
  method: "POST",
  body: new Uint8Array([1, 2, 3]),
});
new Request(url, {
  method: "POST",
  body: new Blob(["Hello, World!"]),
});
new Request(url, {
  method: "POST",
  body: new URLSearchParams({ "foo": "bar" }),
});

const formData = new FormData();
formData.append("name", "Deno");
formData.append("file", new Blob(["Hello, World!"]), "hello.txt");
resp = await fetch("https://example.com", {
  method: "POST",
  body: formData,
});

const bodyStream = new ReadableStream({
  start(controller) {
    controller.enqueue("Hello, World!");
    controller.close();
  },
});
resp = await fetch("https://example.com", {
  method: "POST",
  body: bodyStream,
});

```

涉及到网络权限问题，需要 `--alow-net` 参数。

这里主要展示了 Deno 对 `fetch` 支持。

## 结尾

除了 API 之类的不同， Deno 还提供了更多的工具，比如 lsp 、 format 、 lint 等，而且 Deno 才刚刚起步，未来还很难说。不过目前 Deno 还缺少杀手级的应用，如果有的话，确实能大放异彩。
