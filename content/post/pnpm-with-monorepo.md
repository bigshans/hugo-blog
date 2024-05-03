---
title: "使用 pnpm 管理 monorepo"
date: 2024-05-03T13:50:38+08:00
markup: pandoc
draft: false
categories:
- 包管理器
tags:
- pnpm
---

心血来潮使用 `pnpm` 将项目改为了 monorepo 的结构。最重要的是 `pnpm-workspace.yaml` 文件，我们可以简单写一个放到根目录下面：

```yaml
packages:
  - packages/**
```

这代表在目录 `packages` 下寻找子仓库，且深度只有一层。如果你的包结构是多层嵌套的，那你需要将每个嵌套的父层级也写进去。比如说我的：

```yaml
packages:
  - packages/**
  - packages/@shared/**
```

举个例子，目录结构为：

```
├── package.json
├── packages
│   ├── pkg1
│   │   └── package.json
│   └── @shared
│       └── toolkit
│           └── package.json
└── pnpm-workspace.yaml
```

那么被识别的仓库，除了根目录外，分别是 `pkg1` 、`toolkit` 。

## 依赖安装

依赖可以只安装给单独的子包，也可以安装给根目录。给根目录安装的包可以供全局使用。给子目录安装只需要到对应的子包路径下安装即可，根目录安装需要多加一个 `-w` 参数。

```shell
pnpm add -w @types/node -D
```

如何在子包里引用其他包呢？举个例子，我需要在 `pkg1` 包添加 `toolkit` 这个包，包名为 `@shared/toolkit` ，就需要到 `pkg1` 包下添加依赖：

```json
{
  "dependencies": {
    "@shared/toolkit": "workspace:*"
  }
}
```

然后 `pnpm install` 一下就好了。

## 多包构建

多包构建需要自己手动处理，我个人的方法是写一个脚本进行编译。如果你的包之间的编译顺序并不直接影响你的编译结果，可直接递归运行各个子包的编译脚本。

`-r` 选项将会递归运行脚本到各个子包内，比如说 `pnpm -r run ts:check` 就会依次在各个子包内运行 `pnpm run ts:check` 。我们也可以通过 `--filter` 参数来对我们作用的子包进行筛选，比如说 `pnpm -r --filter @shared/toolkit run build` 就是对包名为 `@shared/toolkit` 的包执行 `pnpm run build` ，`--filter` 接受模糊匹配。
