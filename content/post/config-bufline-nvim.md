---
title: '配置 bufferline.nvim'
date: 2022-04-20T15:55:27+08:00
draft: false
tags:
- nvim
- extension
categories:
- nvim
---

眼馋这个 bufferline 很久了，最近想尝试一下。

## 安装

首先，安装就是很简单的使用 vim-plug 。

```vimscript
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
```

然后需要在 lua 的配置文件中再次 setup 一下。

```lua
require('bufferline').setup{}
```

如此，安装就安装完成了。

## 配置

bufferline 默认的配置对我来说有些不太适应，应为之前我更习惯使用 tab ，不过纯 tab 弊病也挺多的，于是我改变了一下思维方式。

整体的配置思路是这样的，将一个 tab 作为一个 workspace ，切换到对应的 tab 下会隐藏其他 tab 下的 buffer ，而一个 tab 下的 buffer 和各个 tab id 的展示就交由 bufferline 来处理。切换 buffer 借助 bufferline.nvim 提供命令来执行。

这里要额外处理的工作是，需要再绑定一个 `autocmd` 来记录各个 tab 下有哪些 buffer 被打开。之所以需要额外记录，是因为当你使用 `BufferLineGoto` 进行跳转时会把其他 buffer 都给隐藏掉。

然后是 lua 配置：

```lua
function plugin_config:bufferline()
    local tab_group = {}
    local tabpagenr = vim.fn['tabpagenr'];
    local bufnr = vim.fn['bufnr']
    local buflisted = vim.fn['buflisted']
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = '*',
        callback = function ()
            local tabId = tabpagenr()
            local buf = bufnr()
            if tab_group[tabId] then
                for _, v in ipairs(tab_group[tabId]) do
                    if v == buf then
                        return
                    end
                end
                table.insert(tab_group[tabId], buf)
            else
                tab_group[tabId] = { buf }
            end
        end
    })
    vim.api.nvim_create_autocmd({ "BufDelete" }, {
        pattern = '*',
        callback = function ()
            local tabId = tabpagenr()
            if tab_group[tabId] then
                local new_tab_group = {}
                for k, tab_list in ipairs(tab_group) do
                    local list = {}
                    for _, v in ipairs(tab_list) do
                        if buflisted(v) > 0 then
                            table.insert(list, v)
                        end
                    end
                    if #list ~= 0 then
                        new_tab_group[k] = list
                    end
                end
                tab_group = new_tab_group
            end
        end
    })
    require('bufferline').setup{
        options = {
            enforce_regular_tabs = false,
            diagnostics = "coc",
            diagnostics_update_in_insert = true,
            diagnostics_indicator = function(count, level)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end,
            numbers = function(opts)
                return string.format(' %s/%s', vim.fn['tabpagenr'](), opts.ordinal)
            end,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left"
                },
                {
                    filetype = "coc-explorer",
                    text = function()
                        return vim.fn.getcwd()
                    end,
                    highlight = "Directory",
                    text_align = "left"
                },
                {
                    filetype = 'vista',
                    text = function()
                        return vim.fn.getcwd()
                    end,
                    highlight = "Tags",
                    text_align = "right"
                }
            },
            separator_style = "slant",
            custom_filter = function (buf_number)
                if string.match(vim.fn['bufname'](buf_number), "term") then
                    return false
                end
                local tabId = tabpagenr()
                if tab_group[tabId] then
                    for _, p in ipairs(tab_group[tabId]) do
                        if p == buf_number then
                            return true
                        end
                    end
                end
                return false
            end
        }
    };
end

```

然后 keybindings 在 vim 中配置：

```vimscript
function BufferLineKeys()
    nnoremap <silent><M-1> <Cmd>BufferLineGoToBuffer 1<CR>
    nnoremap <silent><M-2> <Cmd>BufferLineGoToBuffer 2<CR>
    nnoremap <silent><M-3> <Cmd>BufferLineGoToBuffer 3<CR>
    nnoremap <silent><M-4> <Cmd>BufferLineGoToBuffer 4<CR>
    nnoremap <silent><M-5> <Cmd>BufferLineGoToBuffer 5<CR>
    nnoremap <silent><M-6> <Cmd>BufferLineGoToBuffer 6<CR>
    nnoremap <silent><M-7> <Cmd>BufferLineGoToBuffer 7<CR>
    nnoremap <silent><M-8> <Cmd>BufferLineGoToBuffer 8<CR>
    nnoremap <silent><M-9> <Cmd>BufferLineGoToBuffer 9<CR>
    nnoremap <silent><leader>bn  :BufferLineCycleNext<CR>
    nnoremap <silent><leader>bp  :BufferLineCyclePrev<CR>
    nn <silent> gb :BufferLinePick<CR>
endfunction
```

不过，虽然配置好了，但这个退出的快捷键我仍然不够满意，因为现在的命令是绑定 `:q` 的，使得我们不得不拆称两个快捷键来处理。一个用来退出，一个用来杀死 buffer 。

于是我写了个方法来处理。

```vimscript
function! functions#bufQuit() abort
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
        execute 'bdelete'
    else
        execute 'quit'
    endif
endfunction
```

然后快捷键绑定就可以了。

```vimscript
nmap <silent><leader>q :call functions#bufQuit()<CR>
```

现在，这个 buffer 就真的像是 tab 了。
