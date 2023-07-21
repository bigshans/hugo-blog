---
title: happy hacking emacs
date: 2019-10-31 19:16:23
tags:
- Emacs
categories:
- Emacs
---

最近在折腾 emacs ，不得不说这个曲线真的是非常陡峭啊！但有些有趣的东西的确让人欲罢不能。今天就在这里跟大家分享一下折腾过程中出现的问题，希望能能给大家带来一点帮助。

<!--more-->

## 中文输入问题

这个坑是最大的，最后是使用内置输入法来解决。换句话说，其实无解。

emacs 内置输入法是 [pyim](https://github.com/tumashu/pyim) 。用起来还可以，抄作者自己的配置就很好用了。这里我没做什么改动，就是官网上的例子。

``` lisp
(use-package pyim
  :ensure nil
  :demand t
  :config
  ;; 激活 basedict 拼音词库，五笔用户请继续阅读 README
  (use-package pyim-basedict
    :ensure nil
    :config (pyim-basedict-enable))

  (setq default-input-method "pyim")

  ;; 我使用全拼
  (setq pyim-default-scheme 'quanpin)

  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;; 开启拼音搜索功能
  (pyim-isearch-mode 1)

  ;; 使用 popup-el 来绘制选词框, 如果用 emacs26, 建议设置
  ;; 为 'posframe, 速度很快并且菜单不会变形，不过需要用户
  ;; 手动安装 posframe 包。
  (setq pyim-page-tooltip 'popup)

  ;; 选词框显示5个候选词
  (setq pyim-page-length 5)

  :bind
  (("M-j" . pyim-convert-string-at-point) ;与 pyim-probe-dynamic-english 配合
   ("C-;" . pyim-delete-word-from-personal-buffer)))
```
使用的时候，按 `M-j` 激活。如果在写代码，则在注释块激活。

## lsp-mode 定义 language-id-configuration

这个官网没有说，我反复遇到这个问题，说让我定义 language-id-configuration ，但我明明定义了。
language-id-configuration 是要在外部定义的，而不应该在 use-package 里面定义。

``` lisp
(setq lsp-language-id-configuration '((java-mode . "java")

(python-mode . "python")

(gfm-view-mode . "markdown")

(rust-mode . "rust")

(css-mode . "css")

(xml-mode . "xml")

(c-mode . "c")

(c++-mode . "cpp")

(objc-mode . "objective-c")

(web-mode . "html")

(html-mode . "html")

(sgml-mode . "html")

(mhtml-mode . "html")

(go-mode . "go")

(haskell-mode . "haskell")

(php-mode . "php")

(json-mode . "json")

(js2-mode . "javascript")

;;(typescript-mode . "typescript")

))
```

## Org Tab 键失效

确认是否是最新版本的 org，主要原因是 org 团队去除了该功能如果想要恢复该功能，使用如下语句即可：
``` lisp
(require 'org-tempo) 
```
如果你使用 use-package 的话，则是：
``` lisp
(use-package org-tempo)
```

## 总结

由于我是从头开始搭建自己的配置，所以有很多坑很正常。比起用别人的配置，还是自己手搭的更加舒服，这里也感谢 emacs telegram 群友给予的帮助。
