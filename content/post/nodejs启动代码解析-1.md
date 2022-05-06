---
title: NodeJs 启动代码解析（一）
date: 2022-05-06T10:04:22+08:00
draft: false
categories:
- nodejs
tags:
- nodejs
---

NodeJs 的 main 函数在 node_main.cc 文件中， NodeJs 区分了 `WIN32` 、 `UNIX` 、 `LINUX` 。我们主要分析 Linux 部分。

简化一下代码，我们得到 main 函数的主要代码。

```cpp
int main(int argc, char* argv[]) {
  node::per_process::linux_at_secure = getauxval(AT_SECURE);
  // Disable stdio buffering, it interacts poorly with printf()
  // calls elsewhere in the program (e.g., any logging from V8.)
  setvbuf(stdout, nullptr, _IONBF, 0);
  setvbuf(stderr, nullptr, _IONBF, 0);
  return node::Start(argc, argv);
}
```

`node` 是 NodeJs 部分的 namespace ，与 V8 的相区分。

`node::Start(argc, argv)` 则是整个 Node 开始的部分。

## `node::Start(argc, argv)`

代码在 node.cc 源文件里。

```cpp
int Start(int argc, char** argv) {
  InitializationResult result = InitializeOncePerProcess(argc, argv);
  if (result.early_return) {
    return result.exit_code;
  }

  {
    Isolate::CreateParams params;
    const std::vector<size_t>* indices = nullptr;
    const EnvSerializeInfo* env_info = nullptr;
    bool use_node_snapshot =
        per_process::cli_options->per_isolate->node_snapshot;
    if (use_node_snapshot) {
      v8::StartupData* blob = NodeMainInstance::GetEmbeddedSnapshotBlob();
      if (blob != nullptr) {
        params.snapshot_blob = blob;
        indices = NodeMainInstance::GetIsolateDataIndices();
        env_info = NodeMainInstance::GetEnvSerializeInfo();
      }
    }
    uv_loop_configure(uv_default_loop(), UV_METRICS_IDLE_TIME);

    NodeMainInstance main_instance(&params,
                                   uv_default_loop(),
                                   per_process::v8_platform.Platform(),
                                   result.args,
                                   result.exec_args,
                                   indices);
    result.exit_code = main_instance.Run(env_info);
  }

  TearDownOncePerProcess();
  return result.exit_code;
}
```

首先，与以前的 Node 相比，新版的 Node 多了 snapshot 功能，因此代码在这里也多了一层 snapshot 检测。

```cpp
InitializationResult result = InitializeOncePerProcess(argc, argv);
if (result.early_return) {
    return result.exit_code;
}
```

`InitializeOncePerProcess` 函数调用了它自身的另一个多态方法。该方法初始化了一些 C++ 模块，比如说 `crypto` ，然后初始化了 V8 引擎。

`uv_loop_configure` 函数对 libuv 进行了配置。

之后创建了 `NodeMainInstance` 实例。

`TearDownOncePerProcess` 则是程序运行完成后的收尾处理。

## `InitializeOncePerProcess(argc, argv)`

`InitializeOncePerProcess(argc, arg)` 默认启用了一些参数。

```cpp
InitializationResult InitializeOncePerProcess(int argc, char** argv) {
  return InitializeOncePerProcess(argc, argv, kDefaultInitialization);
}
```

其中 `kDefaultInitialization` 是一个枚举值。

```cpp
enum InitializationSettingsFlags : uint64_t {
  kDefaultInitialization = 1 << 0,
  kInitializeV8 = 1 << 1,
  kRunPlatformInit = 1 << 2,
  kInitOpenSSL = 1 << 3
};
```

`InitializeOncePerProcess` 源码非常长，在此就不列出来了，它也在 node.cc 源文件中。

在初始化 V8 前，首先需要对传入参数进行解析。

```cpp
  InitializationResult result;
  result.args = std::vector<std::string>(argv, argv + argc);
  std::vector<std::string> errors;

  // This needs to run *before* V8::Initialize().
  {
    result.exit_code = InitializeNodeWithArgs(
        &(result.args), &(result.exec_args), &errors, process_flags);
    for (const std::string& error : errors)
      fprintf(stderr, "%s: %s\n", result.args.at(0).c_str(), error.c_str());
    if (result.exit_code != 0) {
      result.early_return = true;
      return result;
    }
  }
```

`result` 就是最后要传出去的值。

`InitializeNodeWithArgs` 主要对内建模块进行了初始化，同时设置了环境变量，并解析传入的参数格式，如果格式错误就会报错。

后续主要是判断是否可以启用 crypto 模块，完成后便设置进 V8 里面。

最后就启动 V8 。

```cpp
  per_process::v8_platform.Initialize(
      static_cast<int>(per_process::cli_options->v8_thread_pool_size));
  if (init_flags & kInitializeV8) {
    V8::Initialize();
  }

  performance::performance_v8_start = PERFORMANCE_NOW();
  per_process::v8_initialized = true;
```

## Node 实例

Node 实例的源码在源文件 node_main_instance.cc 源文件中。

### 初始化

```cpp
NodeMainInstance::NodeMainInstance(
    Isolate::CreateParams* params,
    uv_loop_t* event_loop,
    MultiIsolatePlatform* platform,
    const std::vector<std::string>& args,
    const std::vector<std::string>& exec_args,
    const std::vector<size_t>* per_isolate_data_indexes)
    : args_(args),
      exec_args_(exec_args),
      array_buffer_allocator_(ArrayBufferAllocator::Create()),
      isolate_(nullptr),
      platform_(platform),
      isolate_data_(nullptr),
      owns_isolate_(true) {
  // ...

  isolate_ = Isolate::Allocate();
  CHECK_NOT_NULL(isolate_);
  // Register the isolate on the platform before the isolate gets initialized,
  // so that the isolate can access the platform during initialization.
  platform->RegisterIsolate(isolate_, event_loop);
  SetIsolateCreateParamsForNode(params);
  Isolate::Initialize(isolate_, *params);

  isolate_data_ = std::make_unique<IsolateData>(isolate_,
                                                event_loop,
                                                platform,
                                                array_buffer_allocator_.get(),
                                                per_isolate_data_indexes);
  // ...
  isolate_data_->max_young_gen_size =
      params->constraints.max_young_generation_size_in_bytes();
}
```

我缩减了一些代码。由于我的代码稍微有点老，所以与当前的源码有所区别。

Node 在此创建了一个 `Isolate` ， `Isolate` 是 V8 里面的概念，对应 JS 引擎实例。

出了创建实例之外， Node 还设置了新生代最大空间。

### `Run(env_info)`

`Run` 方法有两个重载，这是其中一个。

```cpp
int NodeMainInstance::Run(const EnvSerializeInfo* env_info) {
  Locker locker(isolate_);
  Isolate::Scope isolate_scope(isolate_);
  HandleScope handle_scope(isolate_);

  int exit_code = 0;
  DeleteFnPtr<Environment, FreeEnvironment> env =
      CreateMainEnvironment(&exit_code, env_info);
  CHECK_NOT_NULL(env);

  Context::Scope context_scope(env->context());
  Run(&exit_code, env.get());
  return exit_code;
}
```

Node 首先对 `isolate_` 上了锁，并创建了一个作用域。 `env` 就是根据系统环境生成的环境信息。

### `Run(&exit_code, env.get())`

```cpp
void NodeMainInstance::Run(int* exit_code, Environment* env) {
  if (*exit_code == 0) {
    LoadEnvironment(env, StartExecutionCallback{});

    *exit_code = SpinEventLoop(env).FromMaybe(1);
  }

  ResetStdio();
  // ...
}
```

如果能够正常运行的话，就会启动 libuv 做事件循环。`LoadEnvironment(env, StartExecutionCallback{});` 进行初始化，并加载内部库。

```cpp
MaybeLocal<Value> LoadEnvironment(
    Environment* env,
    StartExecutionCallback cb) {
  env->InitializeLibuv();
  env->InitializeDiagnostics();

  return StartExecution(env, cb);
}
```

事件循环的主体在 `SpinEventLoop(env)` 里，代码主要在一个 `do-while` 里运行。

```cpp
Maybe<int> SpinEventLoop(Environment* env) {
  CHECK_NOT_NULL(env);
  MultiIsolatePlatform* platform = GetMultiIsolatePlatform(env);
  CHECK_NOT_NULL(platform);

  Isolate* isolate = env->isolate();
  HandleScope handle_scope(isolate);
  Context::Scope context_scope(env->context());
  SealHandleScope seal(isolate);

  if (env->is_stopping()) return Nothing<int>();

  env->set_trace_sync_io(env->options()->trace_sync_io);
  {
    bool more;
    env->performance_state()->Mark(
        node::performance::NODE_PERFORMANCE_MILESTONE_LOOP_START);
    // 循环主体
    do {
      if (env->is_stopping()) break;
      uv_run(env->event_loop(), UV_RUN_DEFAULT);
      if (env->is_stopping()) break;

      platform->DrainTasks(isolate);

      more = uv_loop_alive(env->event_loop());
      if (more && !env->is_stopping()) continue;

      if (EmitProcessBeforeExit(env).IsNothing())
        break;

      // Emit `beforeExit` if the loop became alive either after emitting
      // event, or after running some callbacks.
      more = uv_loop_alive(env->event_loop());
    } while (more == true && !env->is_stopping());
    env->performance_state()->Mark(
        node::performance::NODE_PERFORMANCE_MILESTONE_LOOP_EXIT);
  }
  if (env->is_stopping()) return Nothing<int>();

  env->set_trace_sync_io(false);
  env->PrintInfoForSnapshotIfDebug();
  env->VerifyNoStrongBaseObjects();
  return EmitProcessExit(env);
}
```

这里的代码位于 embed_helpers.cc 源文件内。

从这里可以看出 Node 确实是单线程的。
