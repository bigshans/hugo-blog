---
title: "如何破解 Gitkraken"
date: 2023-02-18T09:26:22+08:00
markup: pandoc
draft: false
categories:
- 破解
tags:
- 破解
- 私人
---

因为我手头也没有便于支付 Gitkraken 的银行卡，所以只好用破解凑合一下。之前发现了 Gitkraken 的破解项目，但因为违反了版权协议，所以被 ban 了，其实只是转移到了 TG 里去。

对于他们破解 Gitkraken 的原理，我也是阅读过源码，好歹也调试过的。我的方法找到关键的库文件，然后进行替换，他们是找到 Gitkraken 获取 license 的位置进行替换，原理其实差不多。但后来我的代码不好使了，估计是他们改变了库文件的用法。

目前最新版破解还是很好使的，关键核心在这里，除非他们改 license 结构。

```typescript
const bundlePath = path.join(this.dir, "src/main/static/main.bundle.js");

const patchedPattern = '(delete json.proAccessState,delete json.licenseExpiresAt,json={...json,licensedFeatures:["pro"]});';

const pattern1 = /const [^=]*="dev"===[^?]*\?"[\w+/=]+":"[\w+/=]+";/;
const pattern2 = /return (JSON\.parse\(\([^;]*?\)\(Buffer\.from\([^;]*?,"base64"\)\.toString\("utf8"\),Buffer\.from\([^;]*?\.secure,"base64"\)\)\.toString\("utf8"\)\))\};/;
const searchValue = new RegExp(`(?<=${pattern1.source})${pattern2.source}`)
const replaceValue =
  "var json=$1;" +
  '("licenseExpiresAt"in json||"licensedFeatures"in json)&&' +
  '(delete json.proAccessState,delete json.licenseExpiresAt,json={...json,licensedFeatures:["pro"]});' +
  "return json};";

const sourceData = fs.readFileSync(bundlePath, "utf-8");
const sourcePatchedData = sourceData.replace(searchValue, replaceValue);
if (sourceData === sourcePatchedData) {
  if (sourceData.indexOf(patchedPattern) < 0) throw new Error("Can't patch pro features, pattern match failed. Get support from https://t.me/gitkrakencrackchat");
  throw new Error("It's already patched.");
}
fs.writeFileSync(bundlePath, sourcePatchedData, "utf-8");
```

[gitkrakencrackchat TG](https://t.me/gitkrakencrackchat)
