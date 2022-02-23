---
title: '修复 coc.nvim 和 indentLines 的冲突'
date: 2022-02-23T16:47:18+08:00
draft: false
tags:
  - vim
categories:
  - vim
---

我用的是 indentLines 是 [Yggdrot/indentLine](https://github.com/Yggdroot/indentLine) ，与 [coc.nvim](https://github.com/Yggdroot/neoclide/coc.nvim) 存在冲突，主要是诊断的高亮覆盖了 indentLine 的高亮导致 indentLine 无法显示。当然，并不是所有的 buffer 里都会这样，但是需要诊断的 FileType 都是这样。

使用的时候我发现在启动后再运行 `IndentLinesEnable` 代码仍然生效，说明是可以再覆盖的。于是我就想到了一个 workaround ，只要在所有文件打开后再运行 `IndentLinesEnable` 就没有问题。经过几次修改，代码如下：

```viml
let g:indentLine_fileTypeExclude = [ 'startify', 'coc-explorer', 'which_key', 'markdown' ]
fun! IndentLineStart()
    if &ft =~ 'startify\|coc-explorer\|which_key\|markdown'
        execute('IndentLinesDisable')
        return
    endif
    execute('IndentLinesEnable')
endfun
autocmd BufEnter * call timer_start(200, { tid -> IndentLineStart()})
```

这里我用了 `BufEnter` 来处理而不是 `FileType` ，原因主要是 `FileType` 只会运行一次，但 `BufEnter` 则是每次进入的时候都检测，而 coc 则会在每次进入 bufer 时重新覆盖一遍高亮，因此不得不用 `BufEnter` 来触发。

另外这个方法明显的缺点就是 `IndentLinesToggle` 还有 `IndentLinesDisable` 不是很好用了，如果需要的话，还是建议重写个方法做成命令更实在点。
