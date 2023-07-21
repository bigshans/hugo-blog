---
title: "在 Linux 上用 C 写一个守护进程"
date: 2022-07-30T23:26:25+08:00
draft: false
categories:
- Linux
tags:
- C
- Linux
---

因为打算写点东西，所以就看了看如何实现一个守护进程。在 Linux 实现守护进程的步骤都是类似的，即使使用不同的语言，其骨架都是类似的。因为都要用到 `fork()` 方法。

`fork()` 是由系统提供的方法，该方法会复制一份父进程作为子进程，同时并返回 pid 。 `pid > 0` 代表本进程是父进程， `pid == 0` 代表本进程是子进程，而 `pid < 0` 则代表分配失败。

成为守护进程的基本步骤主要有四步：

1. 创建一个父进程。
2. 父进程使用 `fork()` 创建一个子进程。
3. 父进程退出。
4. 子进程设置 `setsid()` 。

首先，父进程退出不代表子进程退出，如果子进程正常运行，但父进程忽然退出而没有处理子进程的话，此时子进程则成为了孤儿进程。此时子进程通过 `setsid()` 重新获取了自身的所有权，子进程此时则真正成为了一个独立的守护进程。

以下是一个简单的例子。

```C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>

int main(int argc, char *argv[])
{
    FILE *fp = NULL;
    pid_t pid = 0;
    pid_t sid = 0;
    pid = fork();
    if (pid < 0) {
        printf("fork failed\n");
        return 1;
    }
    if (pid > 0) {
        printf("process id of child process %d \n", pid);
        return 0;
    }
    umask(0);
    sid = setsid();
    if (sid < 0) {
        return 1;
    }
    chdir("/tmp/t");
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
    fp = fopen("Log.txt", "w+");
    while (1) {
        sleep(1);
        fprintf(fp, "Logging info...\n");
        fflush(fp);
    }
    fclose(fp);
    return 0;
}
```
