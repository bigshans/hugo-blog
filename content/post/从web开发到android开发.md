---
title: "从 Web 开发到 Android 开发"
date: 2022-12-04T16:59:11+08:00
markup: pandoc
draft: true
categories:
- Android
tags:
- Android
---

## 从 `AndroidManifest.xml` 开始

一个安卓项目里必定会包含各种 XML 、 Java 文件，对于 Web 开发者来说，初次见到稍微有点混乱。因为 res 目录的下文件看起来像是 HTML 页面，但由于组件也往里面放置，又有点类似于组件，而 Java 似乎与这些 XML 文件看不出什么强联系起来。

首先，我们应该打开一个 `AndroidManifest.xml` 文件，下面我给出一个示例。

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <application
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Note"
        tools:targetApi="31">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:label="@string/app_name"
            android:theme="@style/Theme.Note.NoActionBar">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <meta-data
                android:name="android.app.lib_name"
                android:value="" />
        </activity>
    </application>

</manifest>
```

`application` 定义了我们的应用，而 `activity` 则类似于 Web 开发一个路由，类似于 React 或者 Vue 那样的，它指向了一个具体的的类，并设定它为启动时的入口。我们是否可以设置多个启动类呢？是可以的，但是要不同的类。如果你在每一个 activity 里都设置了 `android.intent.category.LAUNCHER` ，那么就会有多个入口显示在桌面上，点击可以启动多个 activity ，但与 Web 不同的是，这些 activity 都运行在一个应用上。如果只有一个被显示设置，那么只会启动那一个 activity 作为入口界面。

`android:name` 属性为我们指向到了一个具体的 Java 类，即 `MainActivity` 。我们看到了一些与 XML 文件相关的内容，比如说 `android:label` 、`android:theme` 等等，可以在具体的 XML 里找到，但目前我们还没有找到 `layout` 下的 XML ，明明它看起来跟页面如此相关，那么它在哪里被使用了呢？

## 从 XML 到视图

我们到 MainActivity 类里找，因为应用启动首先到了这里。我们先暂时不管生命周期。

一般来说， Android Studio 会替我们创建好一个基本的代码模板，在一些代码里，我们会看到 `R` 这个对象， `R` 对应 `res` 文件夹下 xml 文件里的内容，比如说 `R.id.activity_main` ，就是对应 id 为 `activity_main` 的 XML 标签。当然，你也可能看不到，但在类里可能会有 `ActivityMainBinding` 类，这是由 `activity_main.xml` 文件转化而来的。 `R.id.activity_main` 是一个标签，`ActivityMainBinding` 是一个具体的类。

现在，我们将 XML 文件绑定到应用上。

```java
binding = ActivityMainBinding.inflate(getLayoutInflater());
setContentView(binding.getRoot());
// 或者单纯的使用 R
// setContentView(R.layout.activity_main);
```

如果我们不这样设置，页面就不会在应用上显示。

我们深入理解这一维。无论是 `R.id.activity_main` 还是 `ActivityMainBinding` ，本质上都是代表这 XML 文件，如果 XML 没有在代码中被显示绑定，那么仅仅只有 XML 是无用的。这里有一个很自然的想法，就是 XML 文件所做的，我们都可以用 Java 代码实现，而且，实际上是这样的， XML 本身只是声明，除了它自身声明的样式，它什么也不代表。在 XML 中编写的控件，我们都可以转换成一个 Java 对象。本质上，这是一个控制反转。

那么， `id` 又是怎么一回事呢？

`id` 之所以令人困惑，还是因为 `findViewById()` 的用法。 `findViewById` ，顾名思义，就是根据 `id` 查找视图，但是 `findViewById` 是在哪里查找呢？第一感， Web 开发者会以为是全局的，类似 `getElementById()` ，但事实上不是的。还记得我们首先做的一层绑定吗？在 MainActivity 上，我们是在 `activity_main.xml` 里面根据 `id` 查找视图，如果 `activity_main.xml` 里面没有，就会查找不到。实际上，我们也可以根据 XML 文件生成一个新的 layout ，并绑定到另一个类上，让 `findViewById` 在这个新的 layout 上查找（相当于一个新的 activity）。我们可以将同一个 layout 生成两次，但这两个 layout 在各自内部是相互独立，它们拥有相同的控件和相同的 id ，分别查询这两个 layout 得到的同 id 控件对象，其实是不同的。但如果两个 layout 隶属于一个更大的 layout （常见的 Fragment 形式），并在这个更大的 layout 里根据 id 查找会怎么样呢？它会返回其中的一个，这实际上会造成混乱，最好的办法是先查找到具体的 layout ，再在 layout 里查找控件。

这里意味着几个事实：

1. `id` 标志着它在 res 下的具有唯一性，但它在运行时的全局唯一性是可疑的。
2. layout 下的 XML 更类似于模板，我们根据模板生成类。绑定 layout 到具体界面，相当于实例化类或者说克隆类。类比的话，类似于组件。
3. `findViewById()` 不生成控件，控件是在创建 layout 时生成好的。
4. 使用 `findViewById()` 需要注意它在哪里查找 `id` 。

如果说 XML 文件可以生成对应的控件对象，事实上，所有由 XML 完成的工作，都可以由 Java 代码来完成。这一点是显而易见的。
