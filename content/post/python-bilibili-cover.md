---
title: python 爬虫获取 bilibili 封面
date: 2018-08-29 17:01:17
tags:
- Python
- 爬虫
categories:
- 爬虫
---

以前写的一个脚本，获取 B 站视频封面的脚本，使用了 urllib 来爬虫，用 feh 来打开图片。

以下是代码：

<!--more-->

```python
#!/usr/bin/python3
#coding:utf-8
from lxml import etree
import urllib.request
import os
import threading
import re
import sys
import json

all_file = []


def feh_display(i):
    l = len(all_file)
    if (i == l):
        for file_dir in all_file:
            threading.Thread(target=os.system, args=('feh ./' + file_dir,)).start()
    elif i < l:
        threading.Thread(target=os.system, args=('feh ./' + all_file[i], )).start()


def display():
    if len(all_file) == 1:
        c = input('需要打开吗？(y/n)')
        if (c == 'y' or c == 'Y'):
            os.system('feh '+'./' + all_file[0])
    else:
        print('需要打开以下吗？')
        i = 0
        for file_dir in all_file:
            print('[%d]%s'%(i,file_dir))
            i += 1
        print('[%d]%s'%(i,'所有都打开'))
        i += 1
        print('[%d]所有都不打开'%(i))
        c = map(int, str(input('请选择以上哪些项:')).split(' '))
        c = list(c)
        if i in c:
            return
        elif i-1 in c:
            feh_display(i-1)
        else:
            for index in c:
                feh_display(index)

def cover(av):
    request_url = 'https://www.bilibili.com/video/av'+ av +'.html'
    headers = {
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'Accept-Language':'zh-CN,zh;q=0.9',
        'Connection':'keep-alive',
        'Host':'m.bilibili.com',
        'Host': 'm.bilibili.com',
        'Referer':'https://www.bilibili.com/video/av' + av,
        'User-Agent':'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Mobile Safari/537.36)'
       }
    page = urllib.request.urlopen(urllib.request.Request(request_url, headers=headers)).read().decode('utf-8')
    page = page.split('\n')
    data = ''
    begin = False
    for eve in page:
        if eve == '<script type="application/ld+json">':
            if begin == False:
                begin = True
                continue
        if begin :
            if eve !=  '</script>':
                data += eve
            else:
                begin = False
                break
    data = re.sub('\s','', data)
    data = json.loads(data)
    url = re.findall('(.*)@\w*\.*?',data['images'][0])[0]
    # os.chdir('~/')
    if not os.path.exists('cover') :
        os.mkdir('cover')
    print('"' + data['title'] + '"的封面正在获取...')
    file_type = re.findall('\.(\w*)',url)[-1]
    file_dir = 'cover/' + av + '.' + file_type
    with open(file_dir,'wb') as f:
        f.write(urllib.request.urlopen(url).read())
    print("获取完毕,保存至./" + file_dir)
    all_file.append(file_dir)

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("    ./cover.py av_num1 av_num2 ...")
        sys.exit()

    av = sys.argv[1:]
    for av_num in av:
        cover(av_num)
    display()

if __name__ == '__main__':
    main()
```

其实获取手机网页端的封面，在查看 API 时发现 json 文件在直接传来的网页里， lxml 一直没有取到，于是手动解析代码。转出来的图片重新按 av 号命名，放在 cover 文件夹里，还是很好用的。
