---
title: "使用 coc 配置 @delance/runtime"
date: 2024-02-16T10:16:38+08:00
lastmod: 2024-03-01T15:33:27Z
markup: pandoc
draft: false
category:
- vim
tags:
- vim
---

首先需要安装 `delance-langserver`。

```shell
npm install @delance/runtime
```

安装完成，第一次使用时报错，通过阅读源码发现是因为第一次安装需要连接网络。由于需要翻墙，所以加个代理即可。直接运行 `delance-langserver --sdtio` 就会自动去下载内容，然后就会正常运行。

接下来我们配置 `coc-settings.json` 。

```jsonc
{
    "languageserver": {
        "delance": {
            "command": "delance-langserver",
            "args": ["--stdio"],
            "filetypes": ["python"],
            "initializationOptions": {},
            "settings": {
                "python": {
                    "analysis": {
                        "typeCheckingMode": "basic",
                        "diagnosticMode": "openFilesOnly",
                        "stubPath": "./typings",
                        "autoSearchPaths": true,
                        "extraPaths": [],
                        "diagnosticSeverityOverrides": {},
                        "useLibraryCodeForTypes": true
                    }
                }
            }
        }
    }
}
```

按 `pyright` 或者 `pylance` 配置即可。

---

自 `v2024.2.105` 之后，接受环境变量 `DELANCE_VSIX` 传入本地的 vsix 文件。

```shell
DELANCE_VSIX=/path/to/pylance-visx npm install @delance/runtime
```

安装完成后直接运行 `delance-langserver --sdtio` 即可。
