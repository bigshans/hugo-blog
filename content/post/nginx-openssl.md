---
title: 使用 OpenSSL 自建 CA
date: 2018-10-13 12:32:10
tags:
- nginx
- openssl
categories:
- openssl
---

谷歌上找了半天终于找到了，https://www.cnblogs.com/luo630/p/9534734.html 。

当然自己动手就有点不太一样了。这个主要是为了将 pixiv nginx 的 ca 证书进行替换，不依赖于他人，也防止其他的各种问题。

下面是一些步骤总结：

<!--more-->

## 自建 CA

这一步最后生成了 crt 的 CA 认证，将之导入到浏览器就可以不出现非安全链接的问题了。

* 生成 CA 私钥

  ```sh
  openssl genrsa -des3 -out pixiv.key 2048 # 1024 已经不行了，不安全
  ```

  


* 生成 CA 证书请求

  ``` sh
  openssl req -new -key pixiv.key -out ca.csr
  ```

* 生成 CA 根证书

  ``` sh
  openssl x509 -req -in ca.csr -extensions v3_ca -signkey pixiv.key -out
  pixiv.crt # 这里最后生成的文件导入浏览器自建服务端证书
  ```
  
## 自建服务器端证书

* 生成服务器秘钥

  ``` sh
  openssl genrsa -out pixiv.net.key 2048
  ```

* 生成服务器端请求文件

  ``` sh
  openssl req -new -key pixiv.net.key -out pixiv.net.csr
  ```

* 生成服务器端证书

  ```sh
  openssl x509 -days 3650 -req -in pixiv.net.csr -extensions v3_req -CAkey pixiv.key -CA pixiv.crt -CAcreateserial -out pixiv.net.crt -extfile openssl.cnf
  ```
  这里的 openssl.cnf 文件需要自建，我大概就这个模板：

  ``` confg
  [req]
  distinguished_name = pixiv.net.crt
  req_extensions = v3_req
  
  [req_distinguished_name]
  countryName = CN
  countryName_default = CN
  stateOrProvinceName = JiLin
  stateOrProvinceName_default = Guangdong
  localityName = ChangChun
  localityName_default = Shenzhen
  organizationalUnitName  = ...
  organizationalUnitName_default  = ...
  commonName = ...
  commonName_max  = 64
  
  [ v3_req ]
  # Extensions to add to a certificate request
  basicConstraints = CA:FALSE
  keyUsage = nonRepudiation, digitalSignature, keyEncipherment
  subjectAltName = @alt_names
  
  [alt_names]
  DNS.1=*.pixiv.net
  DNS.2=pixiv.net
  DNS.3=*.secure.pixiv.net
  DNS.4=pximg.net
  DNS.5=*.pximg.net
  DNS.6=wikipedia.org
  DNS.7=*.wikipedia.org
  DNS.8=google.com
  DNS.9=*.google.com
  IP.1=127.0.0.1
  ```

  命令执行后会有一大堆文件， 配置服务器用的是服务器端的 *.crt 和 *.key 文件。

  
## 服务器端的配置
``` config
ssl on;
ssl_certificate 服务器端 crt 文件路径
ssl_certificate_key 对应 key 文件路径
```

写入就完事儿了。

重启服务器，打开网页，成功。