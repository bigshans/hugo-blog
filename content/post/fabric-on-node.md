---
title: "在 Node 上使用 FabricJs"
date: 2024-03-24T23:18:40+08:00
markup: pandoc
draft: false
categories:
- Node
tags:
- Node
- FabricJs
---

最近开发项目用到 FabricJs ，记录一下使用的坑点。FabricJs 的文档非常难用，许多关键的点都没有讲。FabricJs 的 TypeScript 类型标注也非常难用，经常货不对板，跟文档不一致，跟用例也不一致，不知道他们怎么处理的。但还是选择 FabricJs ，主要原因还是 FabricJs 的 SVG 到 Canvas 的操作非常舒服。

## 安装

FabricJs 现在有两个版本，一个是 v5 版本，一个是 v6 的 beta 版本。有 Node 支持的是 beta 版本，安装 `fabric@beta` 包即可。默认安装的 `fabric` 包是 v5 版本，会自动安装 `node-canvas` ，支持非常不完善，不建议使用。我个人使用 `pnpm` 安装，有额外的坑点存在。如果你的 `node-canvas` 安装出错了，单纯删除 `node_modules` 是无用的，需要运行 `pnpm store prune` 清理链接，然后运行 `pnpm rebuild` 重新编译。

## FabricImage 使用 dataURL

`FabricImage` 默认不会将远程链接转换成 dataURL 格式，且也没有相关支持（至少我没有找到）。目前的方法是手动拉图片，然后自己转成 dataURL 格式。Node 自己没有相关支持，我也懒的再加一个包，就写代码手动处理了。

```typescript
async function createFabricImage(url: string) {
  const base64 = await fetch(url)
    .then((res) => res.arrayBuffer())
    .then((b) => Buffer.from(b).toString('base64'))
  const ext = url.split('.').slice(-1)[0]
  const dataURL = `data:image/${ext};base64,${base64}`
  const img = await util.loadImage(dataURL)
  return new FabricImage(img)
}
```

效果还可以。

## Fabric 转 SVG、PNG 等

Fabric 在 Node 下使用 `node-canvas` 进行转换，本质上就是用 `node-canvas` 的原生接口。

```typescript
canvas.getNodeCanvas().toBuffer('image/png')
```

直接参考 `node-canvas` 官方文档即可，Fabric 也是直接调用的。

`node-canvas` 转 `svg` 也有坑，官网上说用 `image/svg+xml` 参数，但 TypeScript 的标注则没有它。实际上只要你创建 canvas 时用的是 `SVG`，那么使用 `raw` 参数也可以正常导出 `svg` 格式的 `Buffer` 。不过 Fabric 自己的 `toSVG()` 已经足够好了，虽然它的类型标注也有点问题。

## `loadSVGFormString` 的使用

这里的类型标注存在问题，实际用的时候怎么也对不上。

```typescript
async function createSVG(svg: string) {
  const svgOutput = await loadSVGFromString(svg)
  const svgData = util.groupSVGElements(svgOutput.objects as any)
  return svgData
}
```

然后 `add()` 就可以了。

## 切割图片

因为我需要一整个图片的一小块，我尝试使用 `Rect` 等用 `clipPath` 来进行裁剪的方法，都不太好用。后来我发现我之需要简单调整一下画布大小和图片位置就可以了。

```typescript
// 等价用图片，一样的
// createSVG 就是我上面写的方法
const svgEl = await createSVG(svg)
const width = right - left
const height = bottom - top
// 将零点设置为我们需要裁剪的位置
svgEl.setX(-left)
svgEl.setY(-top)
canvas.setDimensions({
    width,
    height,
})
canvas.add(svgEl)
canvas.renderAll()
```

然后导出即可，建议导出为 `png` 等格式，会比 `svg` 小很多，因为 `svg` 保留了原来的图片。
