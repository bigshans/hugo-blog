---
title: "重装 arch"
date: 2023-02-26T14:01:31+08:00
markup: pandoc
draft: false
categories:
- linux
tags:
- linux
---

昨天 KDE 不知道什么原因滚挂了，于是我决定重装系统。最近 KDE 在我的机子上经常崩溃，我也不想修了，因为真的修不起来。距离上一次重装不知道什么时候了，但 Arch 的稳定程度其实是可以的，只要你不是故意去 Arch Testing 。

主要参考 Arch 的安装文档，这里主要是做个记录。

## 网络连接

在 livecd 里默认启用了 iwd ，直接用 `iwctl` 进行网络连接即可。

```bash
iwctl
```

然后就会进入到 `iwctl` 的交互 bash 。

```bash
# 启用网络设备
# 在这之前用 device list 查看一下有哪些可用网卡
device wlan0 set-property power on
station wlan0 scan
station wlan0 get-networks
station wlan0 connect WIFI
```

最后 ping 一下，能通就行。

## 分区与格式化

由于我仍然想保留原来的数据和分区，所以重装的时候我仍然要小心不要格式化错误。如果只谈安装 arch 的话，难点几乎就在分区上，你可以选择提前用 gparted 之类的工具分好，他们有提供 gparted 的 livecd ，大可不必非要在命令行界面安装。

我只需要格式化原来的 root 盘就可以了，其他盘不要随便格，交换分区不需要每次都格。

```bash
mkfs.ext4 /dev/root_partition
swapon /dev/swap_partition
```

然后把根目录挂载到 `/mnt` 上去。

```bash
mount /dev/root_partition /mnt
```

由于我的电脑是 EFI 的，所以需要额外再挂载一个 `efi` 目录。

```bash
mount --mkdir /dev/efi_system_partition /mnt/efi
```

不用 `boot` 目录是为了后面装 grub 做准备， `boot` 目录还是要单独创建一个的。

其他的目录也都正常挂到 `/mnt` 上去。

## 正式安装

```bash
pacstrap -K /mnt base linux linux-firmware
```

等待结束就可以了。

## 基本配置

首先是将分区挂载固定到系统上。

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

完成之后用 `arch-chroot` 进入系统进行正式配置。

### 调整时区

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
```

### 本地化

```bash
# vim 需要自己安装，也可以用 nano
# 去掉对应的注释
vim /etc/locale.gen
locale-gen
```

### 设置 hostname

编辑或者创建 `/etc/hostname` 即可。

### 创建 initramfs

```bash
mkinitcpio -P
```

### 重置密码

```bash
passwd
```

### 安装网络环境

```bash
pacman -S iwd dhcpcd
systemctl enable iwd
systemctl enable dhcpcd
```

### 安装 bootloader

```bash
pacman -S grub os-prober efibootmgr dosfstools
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=grub
# 可以编辑 /etc/default/grub ，启用 os prober 来检测其他操作系统
grub-mkconfig -o /boot/grub/grub.cfg
```

### 安装一些软件

```bash
pacman -S rust nodejs go ntfs3g systemd-resolved ruby php sudo git ranger zsh neovim
```

## 安装图形界面

完成基本系统的安装后，重启看看能不能正常进入系统，能不能正常登录。此时，我们的系统是还没有图形界面的。

我还是比较喜欢 plasma ， xfce4 在急用的时候比较多。

```bash
pacman -S plasma-meta plasma-desktop xfce4 sddm xorg-server noto-fonts-cjk noto-fonts-emoji
systemctl enable sddm
```

把 archlinuxcn 源添加进去。

```conf
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
```

安装 paru 。

```bash
pacman -S --needed paru base-devel
```

安装 wine-for-wechat 。

```bash
pacman -S wine-for-wechat wine-wechat-setup
```

安装一些常用软件。

```bash
pacman -S thunderbird birdtray joplin-desktop keepassxc nextcloud-client konsole yakuake fcitx5-im fcitx5-rime bluez telegram-desktop notion-enhanced-app calibre zoxide ccls anki zetter zeal drawio-desktop obsidian okular gitkraken clash kwalletmanager flameshot iwgtk kdeconnect
```

还有很多需要在 AUR 里安装就不多赘述了。

## 添加日常用户

```bash
useradd -m -g users -G wheel -s /bin/zsh username
passwd username
EDITOR=nvim visudo
```

重启进入图形界面，大致就能用了。因为沿袭了之前的数据，所以不需要再次进行配置，只需要在对应位置补上即可。

## 修复 nextcloud 每次都要登录的问题

删除 kwallet 之前的钱包数据。在 `~/.local/share/kwalletd` 下，删除重启。你只需要最后再授权一下，后面就不用再登录了。
