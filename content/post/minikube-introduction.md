---
title: Minikube 简介
date: 2021-09-22T15:47:06+08:00
draft: false
tags:
- Minikube
- 运维
categories:
- 后端
---

k8s 是个非常著名的容器编排框架，凡稍有涉足运维后端者，未尝有不曾听闻。但是， k8s 本身非常庞大，安装复杂，对于学习和测试 k8s 来说，空耗于安装之上，未免失于实务，逐于稍末了，故 k8s 团队开发了 minikube 以方便用户学习和开发。

minikube 是个轻量版的 k8s ，它相比 k8s 更易于安装，命令与 k8s 基本保持一致，所以能够很好的用来学习 k8s 的各种指令。但同时， minikube 也舍弃了 k8s 的集群能力，只能单体运行。但这并无大碍，因为在 minikube 上的配置完全可以迁移到 k8s 上去。

不过， minikube 不是唯一的轻量、可单体 k8s ，除此之外还有 mircoK8s 、k3s 等等，有兴趣的同学可以自己去阅览。

## 安装

想要安装 minikube 需要符合以下条件：

- 两核及以上 CPU 。
- 2GB 以上的空闲内存（不包括 swap）。
- 20GB 以上的剩余磁盘空间。
- 网络连接（拉镜像用）。
- 容器或虚拟机管理器，可选择 Docker, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, VMWare 中的一个，默认 Docker 。

建议用新一点的 Minikube 。

### Linux 安装

我个人使用的是 Arch Linux ，community 镜像里默认包含了 minikube ，虽然版本有点老了，但还是能用。

``` shell
sudo pacman -S minikube
```

当然，对于一般 Linux 来说，最通用的做法是使用二进制包。

``` shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Mac 安装

Mac 可以使用 homebrew 。

``` shell
brew install minikube
```

当然也可以二进制。

x86\_64：

``` shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

arm64（M1）：
``` shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
sudo install minikube-darwin-arm64 /usr/local/bin/minikube
```

### Windows 安装

使用包管理其实贼好装。

``` powershell
choco install minikube # chocolatey
winget install minikube # windows package manager
```

上面分别使用了 chocolatey 和 windows package manager 。

当然你也可以使用 exe 安装。

1. 下载 [最新版本](https://storage.googleapis.com/minikube/releases/latest/minikube-installer.exe) ，如果你有 `curl` 可以像下面一样使用。

``` powershell
curl -Lo minikube.exe https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe
New-Item -Path "c:\" -Name "minikube" -ItemType "directory" -Force
Move-Item .\minikube.exe c:\minikube\minikube.exe -Force
```

2. 添加到 `PATH` 。一下使用 Powershell ad Administrator 。

``` powershell
$oldpath=[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
if($oldpath -notlike "*;C:\minikube*"){`
  [Environment]::SetEnvironmentVariable("Path", $oldpath+";C:\minikube", [EnvironmentVariableTarget]::Machine)`
}
```


在完成安装之后，请再安装 kubectl ，这是用于管理 k8s 的工具，也可用于 minikube 的管理。

除此之外，我推荐使用 Docker 作为 VM ，这样能与 k8s 很好地契合，虽然其他 VM 也可以。

## 启动 minikube

运行如下命令即可：

``` shell
minikube start
```

初次启动，不出意外的话， minikube 将会初始化 minikube ，并建立一个 cluster 到本地。这里请保证镜像获取的网络畅通，否则将启动失败。

## 查看 pods

安装完成并成功启动之后，我们可以借助 kubectl 查看当前跑的 pods ，

```shell
kubectl get po -A
```

`-A` 会把隐藏的 pods 也给打印出来，目前，除了 minikube 默认跑的 pods 之外，没有别的 pods 在运行。

我们也可以在 dashboard 上查看，首先我们需要打开 dashboard 。

``` shell
minikube dashboard
```

然后 minikube 会帮我们打开默认浏览器以浏览 dashboard 。

## 部署应用

首先，我们创建一个 deployment 并暴露出去。

```shell
kubectl create deployment hello-minikube --image=registry.cn-hangzhou.aliyuncs.com/google_containers/echoserver:1.10
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```

这个 deployment 就是我们的 pod ，就是应用。此时，我们的 pod 还没有正式暴露到外面。

那么，我们如何正式暴露到外部呢？

``` shell
minikube service hello-minikube
```

运行完成后将会为我们打开对应服务的网页。

我们也可以使用 kubectl 为我们做端口转发。

``` shell
kubectl port-forward service/hello-minikube 7080:8080
```

我们使用如下命令可以得知 `hello-minikube` 服务的一个状态：

``` shell
kubectl get services hello-minikube
```

如果我们想要获取我们服务的 url ，可以使用下面的命令：

``` shell
minikube service hello-minikube --url
```

## 集群管理

这里的集群是在单机上由 container 或 VM 组成的集群。

下面是集群管理的一些简单的命令：

``` shell
minikube pause # 暂停
minikube unpause # 取消暂停
minikube stop # 关闭
minikube restart # 重启
minikube config set memory 16384 # 设置参数，需要重启生效
minikube delete --all # 删除所有集群，不建议用
```

## 编写 `deployment.yaml` 配置

我们可以编写 yaml 来配置 minikube 。 yaml 是个与 json 很类似的文件格式。这里我们直接放出代码。

``` yaml 文件
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rss-site
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: front-end
          image: nginx
          ports:
            - containerPort: 80
        - name: rss-reader
          image: nickchase/rss-php-nginx:v1
          ports:
            - containerPort: 88
```

我们简要的讲一下这些字段：

- `appVersion` ， k8s 的 api 版本。
- `kind` ，创建的对象类型，在这里是一个部署（Deployment）。
- `metadata` ，对象的标识信息，下属的 `name` 和 `labels` 分别是名字和标签。
- `spec` ，对象的状态描述。
    - `replicas` ，副本数。
    - `selector` ，可控制的 Pod 。
        - `matchLabels` ， 如名所示，匹配的标签。
    - `template` ，Pod 模板。

执行一下命令生效：

``` shell
kubectl apply -f deployment.yaml
```

获取 deployment 看一下是否创建成功：

``` shell
kubectl get deployment
```

## 更新 Deployment

我们同样可以使用 `apply` 来更新配置。

``` shell
kubectl apply -f deployment.yaml
```

我们也可以使用 `edit` 来更新指令，它打开编辑器来编辑容器中实际的 yaml 文件。

``` shell
kubectl edit deployment.v1.apps/rss-site
```

## 伸缩 deployment

使用 `scale` 我们扩容或缩容容器。

``` shell
kubectl scale deployment.v1.apps/rss-site --replicas=5
```

使用 `autoscale` 可以帮助我们自动扩容。

``` shell
kubectl autoscale deployment.v1.apps/rss-site --min=3 --max=20 --cpu-percent=60
```

## 开启 service

我们继续在上面 `deployment.yaml` 的基础上再编写一个 service 。

``` yaml
---
apiVersion: v1
kind: Service
metadata:
  name: rss-site
  namespace: default
spec:
  ports:
    - port: 8080
      protocol: TCP
      targetPort: 8080
  selector:
    app: web
  type: NodePort
```

然后运行 `kubectl apply -f deployment.yaml` ，deployment 和 service 都部署成功，现在我们的功能正式暴露给外网了，我们来获取一下。

``` shell
minikube service --url rss-site
```

完美。

完整文件如下：

``` yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rss-site
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: front-end
          image: nginx
          ports:
            - containerPort: 80
        - name: rss-reader
          image: nickchase/rss-php-nginx:v1
          ports:
            - containerPort: 88
---
apiVersion: v1
kind: Service
metadata:
  name: rss-site
  namespace: default
spec:
  ports:
    - port: 8080
      protocol: TCP
      targetPort: 8080
  selector:
    app: web
  type: NodePort
```

## 删除 deployment

我们需要按照顺序删除。

1. 删除服务： `kubectl delete service rss-site`
2. 删除部署： `kubectl delete deployment rss-site`

此时我们 `get` 应该是拿不到数据的。


以上就是 minikube 相关的一点介绍。
