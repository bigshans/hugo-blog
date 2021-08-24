---
title: 使用 Sharp 压缩图片、改变图片大小
date: 2021-08-24T18:20:53+08:00
draft: false
tags:
- sharp
- nodejs
- javascript
categories:
- nodejs
---

因为业务需要就写了个图片压缩服务，顺带改变大小，因为用的是 nodejs ，于是我就选择了 [sharp](https://github.com/lovell/sharp) ，基于 libvips。

代码非常好写：

``` javascript
function resize(input, x, y) {
    return sharp(input)
        .resize(x, y, { fit: 'inside' })
        .toBuffer();
}
```

默认是裁剪模式，但我们要保持比例，因此用 “inside” 。因为我们还要调整一下质量，因为原始文件太大了。

``` javascript
function resize(input, x, y) {
    return sharp(input)
        .resize(x, y, { fit: 'inside' })
        .png({ quality: 10 })
        .toBuffer();
}
```

不过我们需要根据图片之类型进行调整，因为有的图片可以调，有的不可以。

最终代码核心如下：

``` javascript
async function resize(inputBuf, x, y) {
  const img = sharp(inputBuf);
  const meta = await img.metadata();
  const buf = await (['gif', 'raw', 'tile'].includes(meta.format)
    ? img.resize(x, y, { fit: 'inside' }).toBuffer()
    : img.resize(x, y, { fit: 'inside' })[meta.format]({ quality: 10 }).toBuffer());
  console.log(buf);
  return {
    buf,
    format: meta.format,
  }
}
```

其中 `gif` 、 `raw` 、 `tile` 不能调整 `quality` 。

不过 arm 的小伙伴似乎不能愉快的使用 sharp 。

