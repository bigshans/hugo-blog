---
title: python3 下使用 base64
date: 2018-10-17 17:23:44
tags:
- python
- base64
categories:
- python
---

用自带库 base64 。

```python
import base64
encode = base64.b64encode(b'i love python') # 加密
print(str(encode, 'utf-8')) # aSBsb3ZlIHB5dGhvbg==
encode = base64.b64decode(b'aSBsb3ZlIHB5dGhvbg==')
print(encode) #解密
```

