---
title: '在 Arch 上启用 QCY-T8 蓝牙耳机'
date: 2022-03-05T15:57:05+08:00
draft: false
tags:
  - linux
categories:
  - linux
---

突然发现原来可以用的蓝牙耳机突然又不能在 linux 上启用了 →_→ ，虽然安装了 bt-module ，但只是可以找出设备，不能正确识别。

经过查找我发现了 pipeware ，一个 pulseaudio 的替代方案。根据 ArchWiki 的步骤，我装了 pipeware-pulse ，然而蓝牙还是没有正常检测到。然后我根据 ArchWiki 提供的配置，添加了一个文件。

`/etc/pipewire/media-session.d/bluez-monitor.conf`:

```
rules = [
{
    actions = {
        update-props = {
            bluez5.autoswitch-profile = true
        }
    }
}
]
```

然后重启就能正常发现耳机了。

但还有个问题，蓝牙虽然发现了，但耳机效果奇差。我觉得可能还是协议问题，应该是 AAC 的问题，于是查了查，有人说降级 bluez 和 bluez-libs 到 5.58 就行了。目前最新的已经到 5.6 以上了，于是我从 Archive 仓库里找到了历史版本，降级重启之后，耳机音质恢复正常。接下来就是锁版本了，完美 （￣ ▽ ￣） 。
