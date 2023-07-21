---
title: 使用 jest 和 supertest 进行接口测试
date: 2021-02-28T17:04:24+08:00
draft: false
tags:
- Jest
- Supertest
- Node
categories:
- 后端
---

最近写接口代码尝试用测试，用了一下，感觉还是很爽的，提前解决了很多 bug 。不过因为不太熟练，所以常常在解决 supertest 的问题，在这里总结一下。

## 登录测试

有些接口需要登录测试，而这些登录测试往往需要前后一致的 session ，这里我们可以通过取 cookie 解决。当然，如果是 token 直接取 token 就行了。

简单写一下就行了，举个例子：

```javascript
const request = require('supertest');
const server = request.agent('http://localhost/');

describe('测试', () => {
    it('需要登录后测试'， async done => {
       // 获取登录的 session 或者 cookie
       server
       		.post('/login')
        	.send({username: 'username', password: 'password'});
       // 继承了已经登录的 server
       const res = server
       		.get('/getList')
    		.query({name: 'ddd'});
    	expect(res.status).toBe(200);
       	done();
    });
});
```

## Expect 使用的经验

```javascript
expect(str).toBe('123'); // 最为基础的 str === '123'
expect({a: 1}).toStrictEqual({a : 1}); // 严格相等，判断对象结构类型是否相等
const mock = jest.fn(); // spy 函数
mock(5); // 添加数据
expect(mock).toBeCalledWith(expect.any(Number)); // toBeCalledWith 回调函数，expect.any 判断数据为任意类型
expect(mock).toBeCalledWith(expect.anything()); // expect.anything() 为 任意类型
mock.mockRestore(); // 清空数据
expect(true).toBeTruthy(); // 判断事都为真，不在乎是否是 true 值
```

目前我常用的就是这一些了，以后有的话可以再补充。