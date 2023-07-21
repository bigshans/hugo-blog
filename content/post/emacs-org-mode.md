---
title: org-mode 个人常用快捷键
date: 2018-12-26 14:46:48
tags:
- Emacs
- Org-mode
categories:
- Emacs
---

最近在用 emacs 的 org-mode 来做一些笔记和 agenda ，个人觉得挺好用的。不认默认的 emacs 快捷键用 ctrl ，用了四天结果我小拇指贼疼，虽然将 ctrl 与 caps 进行交换了，但最后将 ralt 与 rctrl 进行交换，现在稍微好一点。不过我用的是 spacemacs ，用 spacemacs 的快捷键还是很好用的，也能保护好小拇指。

<!--more-->

这里记一些我常用的快捷键。

| 命令                             | emacs 快捷键 | spacemacs 快捷键 | 作用                                                           |
|----------------------------------|--------------|------------------|----------------------------------------------------------------|
| org-agenda-list                  | C-c a        | SPC a o a        | 打开一周的 agenda 计划表                                       |
| org-insert-heading-after-current |              | SPC m h i        | 插入一个同级标题，在 normal 模式下                             |
| org-insert-subheading            |              | SPC m h s        | 插入一个子标题，在 normal 模式下                               |
| org-ctrl-c-ctrl-c                | C-c C-c      | SPC m ,          | 加载 #+TAGS 和 #+SEQ_TODO 等，在普通文本下，表示添加一个新标签 |
| org-set-tags                     | C-c C-q      | SPC m :          | 添加一个tags                                                   |
| org-todo                         | C-c C-t      | t (evil normal)  | 修改当前的 todo 状态                                           |
| org-shiftdown                    | S-down       | SPC m J          | 下调当前任务的优先级                                           |
| org-shiftup                      | S-up         | SPC m K          | 上调当前任务的优先级                                           |
| org-shiftleft                    | S-left       | SPC m H          | 修改当前的 todo 状态（左移）                                   |
| org-shiftright                   | S-right      | SPC m L          | 修改当前的 todo 状态（右移）                                   |
| org-todo-list                    |              | SPC a o t        | 查看所有没有关闭状态的事项                                     |
| org-search-view                  |              | SPC a o s        | 查找事项                                                       |
| org-tag-view                     |              | SPC a o m        | 按标签查询                                                     |
| org-occur-in-agenda-files        |              | SPC a o /        | 查找 org 文件                                                  |
| org-metaleft                     | M-left       |                  | 增加当前标题层级，或改变列表前缀                               |
| org-metaright                    | M-right      |                  | 减小当前标题层级，或改变列表前缀                               |
| org-metaup                       | M-up         |                  | 将当前标题（或列表）及子项上移                                 |
| org-metadown                     | M-down       |                  | 将当前标题（或列表）及子项下移                              |

以后还有再添加。
