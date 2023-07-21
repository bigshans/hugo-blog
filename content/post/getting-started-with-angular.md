---
title: Angular 简易入门
date: 2021-12-06T09:29:04+08:00
draft: false
tags:
- 前端
- Angular
categories:
- 前端
---

因为最近重新用了用 Angular ，在有了 Vue 和 React 的使用经验之后，对 Angular 又有了新的理解。 Angular 是真正意义上与 Vue 和 React 区分的框架，因为其思想与二者截然不同。不过我不讨论这个，我是来讲 Angular 入门。

## 前言

Angular 教程，官方有一个非常好的已经提供了，我这里主要是整理一些要点与语法点，方便快速学习 Angular 。当然，按照官方教程走一遍是再好不过的了，我当时跟着教程回忆也不过一两个小时。

Angluar 就其结构而言，是严格规定了编程方法。作为工程而言是相当规范的，但若是作为小项目，则拘束地很了。不过，好处就是， Angular 为各种情况都制定了解决方案。望各位能根据实情选定技术。

## ng cli 安装

首先，需要全局安装 ng 。

```shell
npm install -g @angular/cli
```

Angular 的编程很繁琐，重复代码太多，不少代码是为了设计模式而设计的，与业务本身无关。 ng 的一大作用就是自动生成代码以解决繁琐的重复编码问题。

ng 的另一大作用就是项目的搭建与构建， ng 可以很方便地添加模块并且自动地做好一些默认配置，比如说 SSR ，比如说 zorro ，使用 ng 都可以快速地将代码融入项目。

ng 是 Angular 用以解决自身问题的 cli 工具，本身也是属于 Angular 的一部分，目的就是为了减轻 Angular 本身的繁琐。

## module

如果不是写框架的话，实际上接触到的 module 文件就只有 `app.module.ts` 了。

在 module 里面我们不需要知道太多，经常接触的就只有两个，一个是 `declarations` ，另一个是 `imports` ，前者用于声明组件，后者用于引入 module 。

其他一些配置的内容往往也写于此。

## 生成一个 component

我们一般使用 ng 生成 component 所需的基础代码。

```shell
ng generate component component-name --module=app.module
```

然后 ng 就会生成对应的目录以及文件到 app 目录下。

```
src/app/component-name
├── component-name.component.html
├── component-name.component.css
├── component-name.component.spec.ts
└── component-name.component.ts
```

其中，样式文件也可以是 less 或是 scss ，总之，看你喜欢。

- `.component.html` 组件的模板文件。

- `.component.css` 模板的样式文件。

- `.component.spec.ts` 测试文件。

- `.component.ts` 组件的主要代码。

Angular 是一门很 OO 的框架， `.component.ts` 主要导出了一个 Component 类，主要逻辑都在 Component 类里完成。

新加的组件需要在 `app.component.html` 或相关的内容中被使用。而且一旦声明就是全局使用的， ng 默认会添加入 `declarations` 里，不需要手动处理。

## 生成一个 service

service 这个词，在 Vue 和 React 中已经很少听见了。我们使用 ng 生成 service 代码。

```shell
ng generate service service-name
```

然后生成 `.service.ts` 文件。 service 层主要是为了提供各种无关视图的服务， Vue 和 React 虽然没有名为 service 的文件，但不代码不编写实质为 service 的代码。

一个 service 默认没有被引用，因此也不会被编译，知道被引用为止。

到此为止，编写一个组件所需要的文件基本上是备足了。

## 控制反转和依赖注入

Angular 利用 TypeScript 的装饰器实现了类似与 Java Spring 的控制反转与依赖注入。

在 component 和 service 中，我们都可以使用依赖注入的方式来注入依赖，而不用费劲巴拉地自己写初始化条件。最常用的，可以在 component 中注入各种 service 。

同时，装饰器也作为插错的实现，形式上也更为简洁了。

值得注意地是， Anuglar 一般来说是单例工厂。

依赖注入的写法，我们一般参照官网。

```typescript
constructor(
    private route: ActivatedRoute,
) {}
```

## RxJS

与 Vue 和 React 不同地是， Angular 没有类似 Vuex 或 Redux 的状态管理库，一般会使用 RxJS 解决。

为什么是 RxJS 呢？ RxJS 是个处理异步数据的框架，而 Angular 引入 RxJS 就是为了让异步更可控、更简单。所谓状态管理，换一个角度看也是同一时间线上不同事件的管理，而 RxJS 恰巧也能做到。因此，用 RxJS 进行状态管理是再合适不过的了。

RxJS 的具体使用我不会在这里讲，下面会提到一点，但不会展开。因为基本上是 RxJS 的基本用法。

## 模板基本语法

对比 Vue 和 React ， Angular 是更基于模板的框架。

在 Angular 中，除了自定义组件外，我们基本上不能使用自定义标签。在模板中，我们可以调用变量，而这些变量则来自于与<u>它对应的组件类</u>的 `public` 部分。

我们可以使用 `{{}}` 进行插值。

而对于标签或组件进行值绑定，我们使用 `[]` ；进行事件绑定，使用 `()` ；进行双向绑定，使用 `[()]` ，需要注意的是，双向绑定需要引入 `FormsModule` 。

对于一般的标签，还需要记忆的是：

- `[ngClass]` ，动态的 `class` 绑定。

- `[ngStyle]` ，动态的 `style` 绑定。

- `[innerHTML]` 等各种与原生属性的绑定。

- `(mouseover)` 等各种事件绑定。

当然，最重要的，还有 if 、 for 等控制流。

### `*ngIf`

`*ngIf` 是个语法糖，比较不幸地是， Angular 没有 else 模板以及 else if 模板。

```html
<div *ngIf="world">
    hello {{world.name}}
</div>
```

如果我们想要表达 else ，我们可以用 if 的否定来表达。

```html
<div *ngIf="world">
    hello {{world.name}}
</div>
<div *ngIf="!world">
    hello world
</div>
```

在 Angular ，还可以使用 `ng-template` 来实现 else 。

```html
<div *ngIf="world; else ElseWorld">
    hello {{world.name}}
</div>
<ng-template #ElseWorld>
    hello world
</ng-template>
```

这种方法缺点也很明显，污染了命名空间。

### `*ngFor`

Angular 的循环写起来是最方便的。

```html
<div *ngFor="let img of imgs">
    <img [src]="img" />
</div>
```

如果我们需要 index 的话也可以拿到。

```html
<div *ngFor="let img of imgs; let i = index;">
    <img [src]="img" [alt]="i" />
</div>
```

### 事件处理

值得注意的是， Angular 绑定事件并不是那么直觉。

比如，如下代码中的 `click` 事件并不会被触发。

```html
<i (click)="click">Click Me</i>
```

除非你显式调用：

```html
<i (click)="click()">Click Me</i>
```

但这样我们并没有获得事件的输入，在 Angular 中，我们需要显式引用 `$event` 变量。

```html
<i (click)="click($event)">Click Me</i>
```

这样的写法更多地是在提醒你，这个是事件绑定，而不是类似于 React 的函数传递。

## 自定义插槽

Angular 中自定义插槽需要在对应的组件类里实现。

`@Input()` 定义插槽的输入参数， `@Output()` 定义插槽的发送事件。

### 定义入参

入参的定义其实非常简单。

```typescript
@Input() n: number;
```

这样我们就定义了一个参数 `n` ，类型为 `number` ，该参数需要我们传入：

```html
<component-a [n]="5"></component-a>
```

如果我们要定义必传参数，就需要修改组件类的 `selector` 。比如上面的例子，如果我们要令 `n` 为必传，则须这样定义 `selector` 。

```typescript
selector: 'component-a[n]'
```

### 定义事件

定义事件就稍微复杂一点，我们需要定义一个 `EventEmitter` 对象。

```typescript
@Output() onBuy = new EventEmitter();
```

其中，变量名就是可绑定的事件名。

`EventEmitter` 是一个模板类，默认类型是 `any` 。向外部发送事件我们使用 `emit(value?: any)` 方法。

```typescript
this.onBuy.emit(p);
```

其他组件想要绑定事件的方法我上面讲过了。

## 组件路由

Angular 的路由配置主要在 `app-routing.module.ts` 文件中。一般如果你需要路由的话，那你在初始化项目的时候选择就有了。即使没有，后续 ng 安装 @angular/router 模块也可以。

配置核心在 `Routes` 数组。

```typescript
const routes: Routes = [
    { path: '', component: HomeComponent },
    { path: 'detail/:id', component: DetailComponent },
];
```

以上是一个简单的示例。

完成基本的路由配置后，我们如何将值展示出来呢？我们使用 `router-outlet` 组件。

```html
<div>
    <router-outlet></router-outlet>
</div>
```

### 路由跳转

#### 编程式跳转

说白了就是编写代码进行路由跳转。为了实现这一点，我们需要首先注入路由对象，也就是 `Router` 对象，如果需要暴露给组件，则需要定义为 `public` 。

跳转代码举个例子：

```typescript
this.router.navigate(['/detail'], {queryParams: {url: v}})
```

#### 导航式跳转

```html
<div routerLink="['/path']" [queryParams]="{id:key}" >跳转</div>
```

### 获取参数

首先需要注入一个 `ActivatedRoute` 。

```typescript
const id = this.route.snapshot.paramMap.get('id') || this.route.snapshot.queryParams.id;
const url = this.route.snapshot.queryParams.url;
```

参数位于 `snapshot` 属性中。

## 组件引用

有些时候我们会需要在代码中操作 DOM ，这时候我们就需要获取到组件对象，对于一般的 DOM 对象我们可以用 `querySelector()` 等方法进行获取，但对于组件就不行了。 Vue 和 React 都提供了 ref ， Angular 也提供了类似的方案。

引用组件首先需要为组件赋予名字。

```html
<component-a #comp></component-a>
```

`#` 之后跟着的就是组件的名字，之后我们使用 `@ViewChild()` 获取组件引用。

```typescript
@ViewChild('comp') compA: ElementRef;
```

然后组件引用就会自动注入到组件中。除了 `ElementRef` 外， `TemplateRef` 也是可以的，但 `TemplateRef` 用于 `ng-template` 。

对于 DOM 对象，我们可以以同样的方式获取。

```typescript
compA.nativeElement;
```

上面将获得原生 DOM 元素的引用。

除此之外，我们也可以直接注入。

```typescript
constructor(private el:ElementRef){}

ngOnInit(){
    console.log(this.el.nativeElement);
    console.log(this.el.nativeElement.querySelector('.box'));
}
```

## `ng-template`

Angular 的 `ng-template` 跟 Vue 和 React 的 `template` 是完全不一样的。 Angular 的 `ng-template` 是不会在代码中被展示的。 `ng-template` 常被作为变量的值来传入到其他组件内，类似 `slots` 的作用。

## RxJS 的使用

在 Angular 中大量使用了 `RxJS` ，比如 Angular 自带的 `HttpClient` 就是使用 RxJS 的。

RxJS 的教程我就不赘述了，具体可以参看我之前写的[文章](https://bigshans.github.io/post/rxjs-exploration/)。在 Angular 中，我们用的比较多的是各种 `Observable` 还有 `Subject` 们， RxJS 可以很方便地帮我们实现多播，以及各种 watch 。

需要注意的是，组件在订阅完成之后，不要忘了及时取消订阅，不然容易出现内存泄漏的问题。

关于这个问题，我建议阅读这篇文章 [RxJS：所有订阅都需要调用 unsubscribe 取消订阅？](https://limeii.github.io/2019/08/rxjs-unsubscribe/) 。

## `HttpClient`

Angular 非常贴心地内置了 Ajax 库，若单论好用，是真的称不上好用的，但不用再添加一个外部依赖，且与 Angular 风格贴合，总的来说是推荐使用的。

`HttpClient` 需要自己注入到类里，我个人是倾向于封装成一个通用的请求方法并放在一个 Service 里处理。其中， `HttpClient` 有几个坑点我说一下。

```typescript
get<R=any, T = any>(api: string, param?: T) {
  const params = param ? generateHttpParam(param) : new HttpParams();
  return this.http.get<GlobalResponse<R>>(
    this.genUrl(api),
    {
      headers: this.headers,
      params
    });
}
```

`HttpClient` 的 `get()` 方法有一个问题就是 `params` 不是那么好处理，我写的时候就觉得这玩意儿有点反直觉。

```typescript
function generateHttpParam(param: any) {
  let params = new HttpParams();
  params = Object.keys(param)
    .reduce((x: HttpParams, k: string) =>
      x.set(k, param[k as any]), params);
  return params;
}
```

`params` 必须不停地被覆盖。

对比之下， POST 就比较简单了。

```typescript
post<R=any, T = any>(api: string, body?: T) {
  return this.http.post<GlobalResponse<R>>(
    this.genUrl(api),
    body,
    {
      headers: this.headers,
    });
}
```

需要注意， httpClient 的方法是异步的，所以返回的都是 `Obserable` ，想要获取返回值需要 `subscribe()` 。

```typescript
this.http.get<string>('https://example.com/ping').subscribe(rep => {
    console.log(rep);
});
```

不过我们不需要自行取消订阅， Angular 帮我们处理好了。

## Angular 的生命周期

了解一个框架，了解它的生命周期是必要的。

![angular life cycle](https://v2.angular.io/resources/images/devguide/lifecycle-hooks/hooks-in-sequence.png)

### 生命周期钩子

Angular中从一个组件的创建到销毁一个有八个生命周期钩子它们,按照先后顺序.它们分别是:

- `ngOnChanges()`
- `ngOnInit()`
- `ngDoCheck()`
- `ngAfterContentInit()`
- `ngAfterContentChecked()`
- `ngAfterViewInit()`
- `ngAfterViewChecked()`
- `ngOnDestroy()`

其中： `ngOnInit()` 、 `ngAfterContentInit()` 、 `ngAfterViewInit()` 和 `ngOnDestroy()` 在一个组件的生命周期中只会被调用一次，其它的都有可能会被多次调用。

一般用得比较多的是 `ngOnInit()` 、 `ngOnChanges()` 、 `ngAfterViewInit()` 、 `ngOnDesctroy()`。

#### `ngOnInit()`

`ngOnInit()` 是在 Angular 生命周期中必定存在的一个钩子，默认也会在生成的代码里面， implements `OnInit` 生命周期接口可以更规范。

作用是绑定数据，类似于 Vue 中的 `created()` 。

#### `ngOnChanges()`

用于监听输入属性和绑定属性变化，如果你不想用 RxJS 实现 watch 的话也可以用 `ngOnChanges()` 。但 `ngOnChanges()` 只有一个，难免会痈肿，而且并不能完全监听所有属性。

但 `ngOnChanges()` 还是很有用的。

```typescript
@Input()
public name: string;

ngOnChanges(changes: SimpleChanges): void {
  console.log(changes);
  // name:SimpleChange {previousValue: "a", currentValue: "ab", firstChange: false}
}
```

**同时,还有一点需要注意：** 输入属性为引用类型和为基本类型时，其表现是不同的。当输入属性是基本类型时，你的每一次改变，都会触发 `ngOnChanges()` 生命周期钩子，而当你的输入属性是引用类型时，你改变你引用类型**当中**的属性时，并不会触发 `ngOnChanges()` 生命周期钩子。只有当你将<u>所引用数据之指针</u>指向<u>另一块内存地址</u>的时，才会触发 `ngOnChanges()` 生命周期钩子.

#### `ngAfterViewInit()`

所有组件及视图完成加载之后被调用，有点类似于 `mounted()` 。

#### `ngOnDestory()`

组件被摧毁的时候调用，一般是用来清理事件监听和订阅取消较多，反之内存泄漏。

## 结尾

以上便是 Angular 入门的一个简单的教程，其实你可以跟着官方的教程一起对照着本篇文章。既然我们已经完成了基本的入门，那么我们来写一个简单的 Angular 项目吧 ：）

![](https://img.moegirl.org.cn/common/f/f0/%E7%BC%96%E7%A8%8B%E6%95%B0%E5%AD%A6%E4%B9%A6.jpg)
