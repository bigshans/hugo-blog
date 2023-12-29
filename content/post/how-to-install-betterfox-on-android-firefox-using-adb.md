---
title: "如何使用 adb 将 Betterfox 安装到 Firefox Android 上"
date: 2023-12-29T21:02:43+08:00
markup: pandoc
draft: false
category:
- software
tags:
- firefox
---

最近使用了 Betterfox 优化了我的 Firefox 效果相当不错。在性能上表现得比之前默认的配置好。在 Betterfox 的 issue 里，有人提到了可以安装 Betterfox 到安卓手机的 Firefox 上。我也尝试了，效果还不错，加载速度比之前快很多。在此我也是非常推荐用 Betterfox 来优化个人的 Firefox 。

PC 端安装 Betterfox 不必多说，主要是安卓端的。原帖是越南语，issue 里把它翻译成中文。

地址：https://github.com/yokoffing/Betterfox/issues/240 。

## 预先准备

首先，需要安装好 adb 。建议使用 Firefox Nightly 或者 Firefox Beta ，有更多的修改空间。

## 步骤

1. 手机连接电脑，确认 adb 能够查找到设备。
![](https://voz.vn/attachments/1694683788719-png.2071759/)

2. 在移动端启用 `Remote Debugging via USB` 。
![](https://voz.vn/attachments/screenshot_20230914_163138-jpg.2071795/)

3. 在 PC 端打开 `about:debugging` ，找到你的安卓设备并连接。
![](https://voz.vn/attachments/1694684065957-png.2071772/)

4. 在移动端打开 `about:support` 。
![](https://voz.vn/attachments/1694684157083-png.2071773/)

5. 在 PC 端监听 `about:support` 页面。
![](https://voz.vn/attachments/1694684362128-png.2071779/)

6. 粘贴如下代码到控制台里。

```javascript
var user_pref = function(pref, val){

  try {
    if(typeof val == "string"){

         Services.prefs.setStringPref(pref, val);    
    }
    else if(typeof val == "number"){

         Services.prefs.setIntPref(pref, val);    
    }
    else if(typeof val == "boolean"){

         Services.prefs.setBoolPref(pref, val);    
    }
  } catch(e){
    console.log("pref:" + pref + " val:" + val + " e:" + e);
  }
}
//paste your user.js file content here
```

7. 最后一步，复制 Betterfox 的代码，例如 Fasterfox 并替换 `//paste your user.js file content here` 然后按 Enter。

然后检查 `about:config` 是否有修改即可。这里只推荐 `Fasterfox` 的配置，其他配置存在着不可知的问题，未必适配移动端。
