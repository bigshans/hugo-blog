---
title: 写一个 vim 窗口跳转
date: 2019-01-17 21:37:36
tags:
- Vim
- VimScript
categories:
- Vim
---

spacemacs 的 which-key 可以实现 <leader> <number> 选择对应窗口，这个功能在 spacevim 上面都有，我挺喜欢的，不过不知道怎么实现的。之前我安装了 space-vim 项目的 vim-which-key 插件，根据 vim-leader-guide 改的，跟 which-key 很像，可以拿来用了。于是我这几天将我原来的 vim 配置做了一个大幅度的调整，并把这个功能给实现了。

<!--more-->

实现起来很简单，我是从 space-vim 那里抄的。以下是实现的代码：

```vim
for s:i in range(1, 9)
    " <Leader>[1-9] move to window [1-9]
     execute 'nnoremap <Leader>' . s:i . ' :' . s:i . 'wincmd w<CR>'
endfor
```

然后我要在 airline 上显示窗口编号，我原本按照 airline 给的样例写，但总是给我报错，没有办法，于是我用别的方法解决了。

```vim
    function! AirlineInit()
        let g:airline_section_a=airline#section#create_left(['mode','❖ %{winnr()} %'])
    endfunction
    function! g:AirlineInactive(...)
        let builder = a:1
        let context = a:2
        call builder.add_section('winnr', "❖  ".context['winnr'])
        call builder.split()
        call builder.add_section('file', '%F')
        call builder.split()
        call builder.add_section('airline_z', '%p%%')
        return 1
    endfunction
    autocmd User AirlineAfterInit call AirlineInit()
    autocmd User AirlineAfterInit call airline#add_inactive_statusline_func('AirlineInactive')
```

个人觉得还行。大家可以试一试。
