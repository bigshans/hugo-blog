---
title: 如何编写一个 Chrome 扩展
date: 2021-08-15T14:48:54+08:00
draft: false
tags:
- javascript
- chrome
categories:
- javascript
---

最近工作需要用到 Chrome 扩展，于是就特意学习了一下。起初，我以为 Chrome 扩展权限挺大，操作起来应该挺方便的，但是，实际情况各种权限需要申请，而且有些操作还要不停的绕过，写起来也是挺烦的。

不过我还是决定记录一下，毕竟是个挺有用的开发能力。

以 Chrome 官方的教程为例。

## 编写 mainfest.json

此文件相当于扩展程序的投名状，用于描述扩展的名字、图标、功能简介、权限、脚本位置等等。

``` json
{
  "name": "Getting Started Example",
  "description": "Build an Extension!",
  "version": "1.0",
  "manifest_version": 3,
  "background": {
    "service_worker": "background.js"
  },
  "permissions": ["storage", "activeTab", "scripting"],
  "action": {
    "default_popup": "popup.html",
    "default_icon": {
      "16": "/images/get_started16.png",
      "32": "/images/get_started32.png",
      "48": "/images/get_started48.png",
      "128": "/images/get_started128.png"
    }
  },
  "icons": {
    "16": "/images/get_started16.png",
    "32": "/images/get_started32.png",
    "48": "/images/get_started48.png",
    "128": "/images/get_started128.png"
  },
  "options_page": "options.html"
}
```

教程中使用的是 v3 版本，现在网上搜到的很多是 v2 版本，这个区别要注意。

具体需要什么权限，请到 Chrome 扩展 API 那里查看。你需要使用什么 API 就申请什么权限。

这里还有几个没有提到的选项，也是很重要的：

`host_permissions`，控制扩展生效的网址，值是个字符串数组。

`content_scripts`，控制扩展在特定网址下嵌入到文档的资源，值是个字符串对象，其中 `matches` 是个字符串数组，是必填内容， `js` 、 `css` 等是选填的。

## 编写 background.js

此脚本的位置对应的就是在 mainfest.json 中的 `background.service_worker` 。

此脚本位于后台运行，没有界面。

``` javascript
let color = '#3aa757';

chrome.runtime.onInstalled.addListener(() => {
  chrome.storage.sync.set({ color });
  console.log('Default background color set to %cgreen', `color: ${color}`);
});
```

## 编写 popup.html 和 popup.js

我们在 `action.default_popup` 生命了该页面的位置。跟编写一般的 HTML 页面不同的是， popup.html 不能内嵌 js ，只能使用 script 标签引用。

``` html
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="button.css">
  </head>
  <body>
    <button id="changeColor"></button>
    <script src="popup.js"></script>
  </body>
</html>
```

不要写 title ，因为它不是一个网页。

popup.js 是由 popup.html 引用的，它不需要在 mainfest.json 里再度声明。

``` javascript
// Initialize butotn with users's prefered color
let changeColor = document.getElementById("changeColor");

chrome.storage.sync.get("color", ({ color }) => {
  changeColor.style.backgroundColor = color;
});

// When the button is clicked, inject setPageBackgroundColor into current page
changeColor.addEventListener("click", async () => {
  let [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

  chrome.scripting.executeScript({
    target: { tabId: tab.id },
    function: setPageBackgroundColor,
  });
});

// The body of this function will be execuetd as a content script inside the
// current page
function setPageBackgroundColor() {
  chrome.storage.sync.get("color", ({ color }) => {
    document.body.style.backgroundColor = color;
  });
}
```

这里用了新的 api 去获取当前页。

``` javascript
let [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
```

`chrome.scripting.executeScript` 是像页面内注入函数，作用与 `content_scripts` 是一样的。

## 编写 options.html 与 options.js

位置对应 `options_page` 字段，编写与 popup 大致相同，编写完成后菜单会多一个名叫选项的选项，点击之后就可进入选项页。

```html
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="button.css">
  </head>
  <body>
    <div id="buttonDiv">
    </div>
    <div>
      <p>Choose a different background color!</p>
    </div>
  </body>
  <script src="options.js"></script>
</html>
```

``` javascript
let page = document.getElementById("buttonDiv");
let selectedClassName = "current";
const presetButtonColors = ["#3aa757", "#e8453c", "#f9bb2d", "#4688f1"];

// Reacts to a button click by marking marking the selected button and saving
// the selection
function handleButtonClick(event) {
  // Remove styling from the previously selected color
  let current = event.target.parentElement.querySelector(
    `.${selectedClassName}`
  );
  if (current && current !== event.target) {
    current.classList.remove(selectedClassName);
  }

  // Mark the button as selected
  let color = event.target.dataset.color;
  event.target.classList.add(selectedClassName);
  chrome.storage.sync.set({ color });
}

// Add a button to the page for each supplied color
function constructOptions(buttonColors) {
  chrome.storage.sync.get("color", (data) => {
    let currentColor = data.color;

    // For each color we were provided…
    for (let buttonColor of buttonColors) {
      // …crate a button with that color…
      let button = document.createElement("button");
      button.dataset.color = buttonColor;
      button.style.backgroundColor = buttonColor;

      // …mark the currently selected color…
      if (buttonColor === currentColor) {
        button.classList.add(selectedClassName);
      }

      // …and register a listener for when that button is clicked
      button.addEventListener("click", handleButtonClick);
      page.appendChild(button);
    }
  });
}

// Initialize the page by constructing the color options
constructOptions(presetButtonColors);
```

## 结语

我个人仅仅用了一部分进行开发，由于页面编写需要一些逻辑和效果，我直接使用 svelte 框架融合进项目里进行开发， build 后的产物还是十分轻量的。如果页面和逻辑比较复杂的，我推荐还是使用一些库为好。
