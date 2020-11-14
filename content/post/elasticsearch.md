---
title: elasticsearch 的简单使用
date: 2020-03-30 15:54:50
tags:
- elasticsearch
categories:
- elasticsearch
---

最近由于业务的增长，所以决定使用 elasticsearch 。

<!--more-->

## 安装

由于是 Debian 系统，所以可以使用 deb ，官方提供了源可以安装。

``` sh
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch
```
运行以上命令即可，但是呢，由于国内网速不给力，会下的很慢，所以我挂了代理下载 deb 包。
``` sh
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.1-amd64.deb
sudo dpkg -i elasticsearch-7.6.1-amd64.deb
```
挂上代理之后飞速下载安装。

## 启动

elasticsearch 不会在安装后启动更新，所以要手动启动。我们用的是 systemd ，所以只要执行一下命令就行了。
``` sh
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
```

运行一下:
```sh
curl -X http://127.0.0.1:9200/
```
返回：
``` json
{
  "name" : "Cp8oag6",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "AT69_T_DTp-1qgIJlatQqA",
  "version" : {
    "number" : "7.6.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "f27399d",
    "build_date" : "2016-03-30T09:51:41.449Z",
    "build_snapshot" : false,
    "lucene_version" : "8.4.0",
    "minimum_wire_compatibility_version" : "1.2.3",
    "minimum_index_compatibility_version" : "1.2.3"
  },
  "tagline" : "You Know, for Search"
}
```
启动成功。

## CURD

elasticsearch 有个 index 的概念，index 更像关系型的 Database ，而实际上在 elasticsearch 7.6.1 中更像是 table ，里面可以对任意的 document 进行 CURD 。

elasticsearch 都使用 restful 接口进行操作。

### 增加一个 index

```sh
curl -X PUT http://127.0.0.1:9200/index
```

### 增加一个 document

```sh
curl -X POST http://127.0.0.1:9200/index/_create/1 -H 'Content-Type: application/json' -d '{
    "username" : "jack",
    "password" : "1.2.3"
}'
```

### 删除一个 document

```sh
curl -X DELETE http://127.0.0.1:9200/index/_doc/1
```

### 修改一个 document

``` sh
curl -X POST http://127.0.0.1:9200/index/_update/1 -H 'Content-Type: application/json' -d '{"doc" : {"username":"hello"}}'
```

### 按条件修改一个 document

``` sh
curl -L -X POST 'http://127.0.0.1:9200/index/_update_by_query' \
         -H 'Content-Type: application/json' \
         --data-raw '{
             "query": {
                 "username":"jack"
             },
                 "script": {
                     "inline": "ctx._source.password = '122'"
                 }
         }'
```

貌似不能用 doc 进行部分更新，只能用 script 。

### 按条件删除一个 document

```sh
curl -L -X POST 'http://127.0.0.1:9200/index/_delete_by_query?conflicts=proceed' \
         -H 'Content-Type: application/json' \
         --data-raw '{
             "query": {
                 "match_all": {}
             }
         }'
```

### 搜索 document

``` sh
curl -L -X POST 'http://127.0.0.1:9200/index/_search' \
         -H 'Content-Type: application/json' \
         --data-raw '{
             "query" : {
                 "match": {
                     "username": "jack"
                 }
             },
         }'
```

elasticsearch 的搜索语法被称为 [DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html) ，这里简单对几个语法做介绍。

``` json
{
    "query" : {
        "match": {
            "username": "jack"
        }
    }
}
```
`match` 里对字段进行模糊搜索，会对字段进行分词。如果不想要分词可以使用 `term` 。

``` json
{
    "query" : {
        "term": {
            "username": "jack"
        }
    }
}
```
但两者都只能对单一字段进行查询，如果要分字段查询，需要使用 `bool`。

```json
{
    "query": {
        "bool": {
            "should": [
            {"term": {"username": "jack"}},
            {"term": {"password": "1234"}}
            ]
        }
    }
}
```

## 总结

elasticsearch 整体用下来还是非常顺畅的，之前压崩 mongo 的查询量交给 elasticsearch 还是很轻松的。不过，对比单纯的数据库有失灵活，但想要两全哪有那么好的东西呢？
