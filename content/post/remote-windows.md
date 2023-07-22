---
title: 远程连接 Windows 开发的诸多尝试
date: 2021-09-12T22:04:52+08:00
draft: false
tags:
- Windows
- rdesktop
- freedesktop
categories:
- 解决方案
---

由于最近要用到 uniapp 进行开发，但是，由于项目不是 CLI 项目，所以最终还是要用到 HBuilderX 进行开发，然而，它没有 Linux 版 Orz 。不过好在公司给了我一台 Windows 电脑，所以我就想着，能不能远程连接 Windows 进行开发，因为我实在不想两台电脑换来换去。

方案其实很有限，我大概试了一下：

- Anydesk 远程连接
- VNC 协议
- rdp 协议

说一下这三者的感受吧！

## Anydesk

卡爆了，大概是因为这个是真的走远程吧！我试过虚拟机，真的很卡，我的虚拟机并不卡，但 Anydesk 的延迟却相当高，我个人并不推荐。

## VNC

感觉好了很多，但是呢，本质上是桌面同步，我不管怎样都不能把桌面关上，还有屏幕大小，并不怎么灵活。还有剪切板同步的问题，并不能同步，跟我预期的有些差距。

## rdp

这个只需要打开 Windows 默认的远程桌面功能，重启即可。我尝试了两款 rdp 客户端：freedesktop 和 rdesktop 。首先先说结论， freedesktop 完美符合我的需求。虽然很多人推 rdesktop ，然而其流畅度其实跟 freedesktop 差很多，还有一些 BUG ，比如我就遇到了光标消失的问题，rdesktop 处理起来就很蛋疼，而 freedesktop 则没有这些问题。

freedesktop 的参数还是很有 DOS 风格的，我个人用这些参数：

```
xfreerdp /v:target_ip_address /u:username /p:password /f /audio-mode:0 +fonts +window-drag +clipboard /sound
```

音频也同步了，剪切板也同步了。

以上。
