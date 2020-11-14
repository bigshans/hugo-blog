---
title: 在 Debian 下使用 PPA
date: 2019-06-26 11:24:44
tags:
- linux
- ppa
- debian
categories:
- linux
---

仅仅使用 Debian 源里的软件包并不是很够，所以不可避免的，我们会使用一些第三方的软件源，比如 Arch 下的 aur ， Ubuntu 的 PPA ，等等。由于 Ubuntu 是 Debian 系的发行版，两者的包管理是相通的，所以我们可以借用一下 Ubuntu 的 PPA 来扩充我们的软件库。然而，两者毕竟不是同一发行版，所以还是会有很多的差别，我们并不能保证两者的软件包一定能通用，毕竟打包并不是针对 Debian 的，不过， Ubuntu 能用的， Debian 基本能用，所以，把 Ubuntu 的 ppa 拉过来还是很有意义的。

<!--more-->

## 如何加入 PPA 源

可以使用 add-apt-repository 来加入源，不过，由于 ppa 主要是针对 Ubuntu ，所以往往会有版本不对的情况，导致 add-apt-repository 不能正常使用，这个该如何解决呢？

### 直接加入

add-apt-repository 是个 python 脚本，它的主要作用是生成 deb 仓库地址，加入到 sources.list.d 里，然后添加密钥。我们可以直接将源加入到 sources.list 中。

我们以 Chromium-beta 为例，正常是使用一下命令加入 PPA 。

```sh
sudo add-apt-repository ppa:saiarcot895/chromium-beta
sudo apt-get update
```

我们简单转换一下就得到地址， `deb http://ppa.launchpad.net/saiarcot895/chromium-beta/ubuntu cosmic main ` 。其中的 	`cosmic` 是 Ubuntu 的版本，任意选取一个能用的就行了。将该地址加入到 sources.list 中。

然后我们加入密钥。

我们进入 PPA 的页面，点开 `Technical details about this PPA` ，在 `Signing key` 下选取 `/` 后的部分，这部分就是密钥。

我们可以运行命令添加密钥。

```sh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E6200BDA4A746F2A1F7FFD3FE6A17451DC058F40
```

`E6200BDA4A746F2A1F7FFD3FE6A17451DC058F40` 就是我们选取的密钥。

然后我们运行更新命令，我们的源就能使用了。

```sh
sudo apt-get update
```

如果我们不进入 PPA 的页面，我们可以运行一下命令先获取公钥。

```sh
sudo apt-get update | grep "NO_PUBKEY" | awk '{print $3}'
```

最底下的那行就是公钥。

然后我们运行以下命令即可，其中， `$KEY` 就是你的公钥。

```sh
sudo apt-key --keyserver keyserver.ubuntu.com --recv-keys $KEY
```

### 脚本化

我们可以将我们以上的步骤进行脚本化。所以我写了个小脚本去解决这个问题。

```sh
#!/bin/bash
if [ $# -eq 1 ]
    NM=$(uname -a && date)
    NAME=$(echo $NM | md5sum | cut -f1 -d" ")
then
    ppa_name=$(echo "$1" | cut -d":" -f2 -s)
    version_name=$2
    if [ -z "$version_name" ]
    then
        version_name="cosmic"
    fi
    if [ -z "$ppa_name" ]
    then
        echo "PPA name not found"
        echo "Utility to add PPA repositories in your debian machine"
        echo "add_ppa ppa:user/ppa-name [version]"
    else
        echo "$ppa_name"
        echo "deb http://ppa.launchpad.net/$ppa_name/ubuntu $version_name main"
        sudo add-apt-repository "deb http://ppa.launchpad.net/$ppa_name/ubuntu $version_name main"
        echo "Get the public key from apt-get update"
        sudo apt-get update | grep "NO_PUBKEY" > /tmp/${NAME}_apt_add_key.txt
        key=$(cat /tmp/${NAME}_apt_add_key.txt | awk '{print $3}')
        echo "Get the public key $key"
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key
        rm -rf /tmp/${NAME}_apt_add_key.txt
    fi
else
    echo "Utility to add PPA repositories in your debian machine"
    echo "add_ppa ppa:user/ppa-name [version]"
fi
```

这个脚本是对 add-apt-responsitory 进行了简单的 wrapper ，像使用 add-apt-respository 一样使用该脚本即可。
