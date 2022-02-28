---
title: 在 vim 下修改自然码码表
date: 2019-01-31 11:27:53
tags:
  - rime
  - vim
  - fcitx
  - 正则表达式
categories:
  - vim
---

最近想要用 fcitx 来替代搜狗输入法，因为搜狗输入法占用真的太大了，所以我决定尝试替换。我首先尝试了给 fcitx-pinyin 添加词库，不过效果不是特别好，单字表不能再添加一些字，所以我决定换用别的输入法。 fcitx-sunpinyin 可以添加用户词典，但添加新的单词的时候会严重卡顿，而且打某些字的时候也会卡顿，体验极其糟糕，所以我决定尝试一下 fcitx-rime 。

rime 是个高可配置的输入法，所以我决定搜寻一下配置。 rime 的配置方案还是很多的，我首先尝试了 double-pinyin 方案，因为我日常使用双拼。然后我往其中添加了大字库，词库丰富之后超级好用。不过 double-pinyin 只是 luna_pinyin 的一个修改，不能使用辅助码。我想，能不能自己配置一个呢？说干就干。

我首先查了一下，看看有没有人配置好了自然码+辅助码的方案，不过，虽然有但链接往往又不能下载，搞得我很不高兴。然后，我就查到了一个自然码 2000 的方案，我喜不自胜地挂载到我的小狼毫里，发现竟然不能用！我又郁闷了会，参照网上某些人配置的方案修改了一下，终于能正常使用了！然后我就切换了一下发现，整个体验跟我想得不太一样。我更想要再双拼的基础上，需要时再添加辅助码，像 windows 下的搜狗那样。想了想既然这样，我还是自己修改得到一份自己的方案吧！

## 修改码表

首先我搜寻了如何制作 rime 辅助码的相关信息，找到了佛振大佬的帖子。佛振大佬用的是 vim ，不过有很多替换命令不太能对应，所以我只能自己多思考一下。

第一步是去除所有词组，针对 zrm2000.dict.yaml 修改，命令是：

```vimscript
	:,$s/.\{2,}\t.*\n//
```

第二步，去除非汉字的编码，这个手动修改，首先先`:,$sort`一下，然后就可以按照顺序删除了。这里我仍然保留了一点。

第三步，将辅助码与双拼分离。自然码的特点是前两个是双拼，后两个是辅助码，所以可以用一下命令修改：

```vimscript
:,$s/\t(\w{2})(\w*)/\t\1;\2/
```

第四步，去除所有的子码，就是大量的类似 yi;a 、yi;aa 这样的东西，合并为 yi;aa 。采用一下命令，需要多次执行：

```vimscript
:,$s/^\(.*\)\n\1/\1/
```

通过以上的步骤，就可以得到一个用 `;`区分双拼和辅助码的自然码表了。说实话，这么操作一通，我的正则水平上升了不少。

## 配置方案

然后要修改一下方案，如果直接用的话，你必须自己把整个码打出来，体验极差。

主要是修改 algebra 的正则。rime 的正则就是用的 perl 的，所以了解 perl 的正则语法就行了。

最后的 speller 如下：

```yaml
speller:
  alphabet: 'zyxwvutsrqponmlkjihgfedcba;'
  delimiter: " '"
  algebra:
    - derive/^(\w*);(\w)(\w)$/$1;$2$3/    ＃ 完全自然码
    - derive/^(\w*);(\w)(\w)$/$1;$2/         ＃ 使用部分自然码
    - derive/^(\w*);(\w)(\w)$/$1/               ＃ 使用纯双拼
```

rime 原来的自然双拼会把双拼展开成拼音，这个功能我也想要，这个要改一下 preedit_format 。只需要在原来自然双拼的基础上进行略微修改即可。

最终的 translator 如下：

```yaml
translator:
  dictionary: zrm_pinyin
  prism: zrm_pinyin
  preedit_format:
    - xform/(?<!;)([bpmnljqxy])n/$1in/
    - xform/(?<!;)(\w)g/$1eng/
    - xform/(?<!;)(\w)q/$1iu/
    - xform/(?<!;)([gkhvuirzcs])w/$1ua/
    - xform/(?<!;)(\w)w/$1ia/
    - xform/(?<!;)([dtnlgkhjqxyvuirzcs])r/$1uan/
    - xform/(?<!;)(\w)t/$1ve/
    - xform/(?<!;)([gkhvuirzcs])y/$1uai/
    - xform/(?<!;)(\w)y/$1ing/
    - xform/(?<!;)([dtnlgkhvuirzcs])o/$1uo/
    - xform/(?<!;)(\w)p/$1un/
    - xform/(?<!;)([jqx])s/$1iong/
    - xform/(?<!;)(\w)s/$1ong/
    - xform/(?<!;)([jqxnl])d/$1iang/
    - xform/(?<!;)(\w)d/$1uang/
    - xform/(?<!;)(\w)f/$1en/
    - xform/(?<!;)(\w)h/$1ang/
    - xform/(?<!;)(\w)j/$1an/
    - xform/(?<!;)(\w)k/$1ao/
    - xform/(?<!;)(\w)l/$1ai/
    - xform/(?<!;)(\w)z/$1ei/
    - xform/(?<!;)(\w)x/$1ie/
    - xform/(?<!;)(\w)c/$1iao/
    - xform/(?<!;)([dtgkhvuirzcs])v/$1ui/
    - xform/(?<!;)(\w)b/$1ou/
    - xform/(?<!;)(\w)m/$1ian/
    - xform/(?<!;)([aoe])\1(\w)/$1$2/
    - "xform/(?<!;)(^|[ '])v/$1zh/"
    - "xform/(?<!;)(^|[ '])i/$1ch/"
    - "xform/(?<!;)(^|[ '])u/$1sh/"
    - xform/(?<!;)([jqxy])v/$1u/
    - xform/(?<!;)([nl])v/$1ü/
```

这样我们就可以不影响辅助码了。

## 感受

这次修改过程，就像一次大型的正则表达式应用案例一样，我还顺便看了一下 perl 的语法，总体来说受益匪浅，得到的成功也较为满意，可以使用辅码，可以使用外挂词库，使得部署时内存占用减小，去除卡顿，比搜狗还要好用。

最后附上我方案的 github 地址：https://github.com/bigshans/rime-zrm

引用：

1. [佛振大佬的帖子](http://tieba.baidu.com/p/2094178562)
2. [rime 输入方案入门指导](https://github.com/rime/home/wiki/RimeWithSchemata)
3. [自然码 2000](https://github.com/henices/rime)

---

更新：

最近修改了一下词库，因为原来的词库确实问题比较多。结合了 luna_pinyin 的内容，再顺便加了些表情和颜文字之类的内容，原来的内容似乎要重新调教了，不过新的词库准是准了很多，各有优劣吧！
