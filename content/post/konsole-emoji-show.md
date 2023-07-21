---
title: "解决在 Konsole 下的 Emoji 展示问题"
date: 2022-09-09T14:54:41+08:00
draft: false
categories:
- 解决方案
tags:
- Linux
- Konsole
---

解决方法很简单，就是配置 fontconfig 。同时，该方案也解决了在其他一些软件内 emoji 显示异常的问题，比如说 qv2ray 。

这里借助 Noto Emoji 来处理。 Arch 下安装 `noto-fonts-emoji` 包，然后将下面内容保存到 `~/.config/fontconfig/conf.d/99-noto-mono-color-emoji.conf` 中去。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<!--
Noto Mono + Color Emoji Font Configuration.
Currently the only Terminal Emulator I'm aware that supports colour fonts is Konsole.
Usage:
0. Ensure that the Noto fonts are installed on your machine.
1. Install this file to ~/.config/fontconfig/conf.d/99-noto-mono-color-emoji.conf
2. Run `fc-cache`
3. Set Konsole to use "Noto Mono" as the font.
4. Restart Konsole.
-->
<fontconfig>
  <match>
    <test name="family"><string>Noto Mono</string></test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Noto Color Emoji</string>
    </edit>
  </match>
</fontconfig>
```

之后运行 `fc-cache` ，重启 konsole 就可以看到结果了。

总而言之，就是 emoji 没有找到对应的字体去展示，需要自己配置 fontconfig 罢了。
