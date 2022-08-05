---
title: "琐碎备录"
date: 2022-08-05T16:46:36+08:00
draft: false
---

## Makefile

`.PHONY` 可以用来重复编译，本意是将对应的对象视为虚假，从而强制执行编译。

## Joi

`joi.string().allow('').allow(null).empty('').optional()` ，允许字符串为空。
