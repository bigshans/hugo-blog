---
title: 在 linux 下搞定 nvidia 双显卡
date: 2018-09-08 09:22:39
tags:
- Bumbeeble
- Linux
- Nvidia
categories:
- Linux
---

终于终于把双显卡整好了，该死的 NVIDIA 。为了双显卡我的桌面崩溃了几次，不过终于整好了。下面讲讲我处理这些的一些过程。
<!--more-->

经过我桌面反复崩溃，查看 xorg 的 log 文件，终于确定 nouveau 不支持我的显卡。于是我终于决定把 nouveau 给卸载了，再把之前装的 bumblebee 给完全卸载了。

```shell
sudo apt-get purge bumblebee
sudo apt-get purge nouveau
```

如果你是双显卡，你不需要担心你卸载了 nvidia 显卡有什么卵用，反正根本就用不起来。之后重装 bumblebee-nvidia ，把闭源驱动装上。

```shell
sudo apt install bumblebee-nvidia
```

这里有很多坑，这样装上是不能用的。首先要修改 /etc/bumblebee/bumblebee.conf 文件， kernelDriver 要改为 nvidia-current ，下面 LibraryPath 每个路径都要加上 current 路径，可以到他们对应的路径下查看，会发现一个 current 文件夹，这个就是每次 optirun 所要加载的文件位置。然而这里还缺了一个加载，通过查找网上的资料，我终于解决了这个问题。

``` shell
sudo apt-get install libgl1-nvidia-glx
```

通过安装这个库，optirun 正常运行。如果你没有重启过的话请重启。建议使用 xfce 桌面去做调整，我的 cinnamon 总是崩溃，在 xfce 下正常运行，如果寻求稳定性话， xfce 还是不错的。

最后，你会发现 nvidia-setting 无法正常运行。请无视，并用以下命令启动：

``` shell
optirun nvidia-settings -c :8
```

千万不要运行 nvidia-x-config ，那是针对单显卡的。