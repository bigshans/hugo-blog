---
title: "NodeJs 上的大文件问题"
date: 2022-08-07T20:42:17+08:00
draft: false
categories:
- node
tags:
- node
---

大文件的读取与写入问题，一般使用流（stream）就可以很好的处理了。但大文件的问题并不单单是这样，如果仅仅是单纯的读取或写入，那么解决方案到此为止确实也就可以了。一旦涉及到读写组合，大文件问题并不是一个简单的读取与写入的问题，其问题的更广泛形式，是生产者和消费者问题。

我们处理大文件并不是为了将整个大文件放入内存之中，而是将大文件切分成若干个可以处理的小块，然后对这些小块做批处理，按其特征，大如一行，小如一字，因它们出现的顺序流式处理。因此，流之所以能使大文件处理成为可以，就是因为我们对这些大文件的处理具有特殊性。

在 NodeJs 当中，文件的读取与写入都是异步处理，这与 NodeJs 的生命周期密不可分。 NodeJs 对所有 IO 操作都进行了统一的管理，并进行多路复用从而提高 IO 效率，但响应的，程序编写就不得不采取异步的方式完成。使用流进行读取的时候，你可能常常会遇到这个问题，就是 OOM 。虽然使用了，但内存仍然溢出了，不过这并不是流的问题。

NodeJs 的流操作可分为主动操作和被动操作，一般来说，被动操作易于理解，我们一般都用被动操作。所谓被动操作，就是由 NodeJs 主动向发出 `data` 事件，即使你没有完成，事件也仍然在发送，显而易见的，当你的处理速度比不上读取速度，换句话说，就是消费速度比不过生产速度的话，大量事件与数据就会堆积在事件循环中，最终导致 OOM 。同样的道理，在写入的时候也是，如果磁盘写入的速度比不上生产数据的速度， OOM 也会出现。因此，解决流在大文件读取与写入方面的问题，就是要将写入与读取的速度同步，进行降级处理。

关于 NodeJs 大文件读写的文章，我记得古早前有一篇[文章](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)讲过，结论是 NodeJs 自己 stream 不能胜任。但我觉得可以，所以我就改写了她的代码以证明这一点。

[数据](https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip)从这里下载，解压可以看到一个 4G 的文件。她的代码毫无疑问 OOM 了。

改写后的代码：

```javascript
const fs = require('fs');
const now = require('performance-now');

const read = fs.createReadStream('./itcont.txt');

//get line count for file
let lineCount = 0;

// create array list of names
let names = [];

// donations occurring in each month
let dateDonationCount = [];
let dateDonations = {};

// list of first names, and most common first name
let firstNames = [];
let dupeNames = {};

let t0 = now();
let t1;
let t2 = now();
let t3;
let t4 = now();
let t5;
let t6 = now();
let t7;

console.time('line count');
console.time('names');
console.time('most common first name');
console.time('total donations for each month');

function resolve(line) {
  // increment line count
  lineCount++;

  // get all names
  let name = line.split('|')[7];
  if (!name) {
    return;
  }
  names.push(name);

  // get all first halves of names
  let firstHalfOfName = name.split(', ')[1];
  if (firstHalfOfName !== undefined) {
    firstHalfOfName.trim();
    // filter out middle initials
    if (firstHalfOfName.includes(' ') && firstHalfOfName !== ' ') {
      let firstName = firstHalfOfName.split(' ')[0];
      firstName.trim();
      firstNames.push(firstName);
      dupeNames[firstName] = (dupeNames[firstName] || 0) + 1;
    } else {
      firstNames.push(firstHalfOfName);
      dupeNames[firstHalfOfName] = (dupeNames[firstHalfOfName] || 0) + 1;
    }
  }

  // year and month
  let timestamp = line.split('|')[4].slice(0, 6);
  let formattedTimestamp = timestamp.slice(0, 4) + '-' + timestamp.slice(4, 6);
  dateDonationCount.push(formattedTimestamp);
  dateDonations[formattedTimestamp] =
    (dateDonations[formattedTimestamp] || 0) + 1;
}
read.on('readable', () => {
  let line = '';
  let chunk;
  while((chunk = read.read()) !== null) {
    const s = chunk.toString();
    if (/\n/.test(s)) {
      const [pre, after = ''] = s.toString().split('\n');
      line += pre;
      resolve(line);
      line = after;
    } else {
      line += s;
    }
  }
});

read.on('end', () => {
  // total line count
  t1 = now();
  console.log(lineCount);
  console.timeEnd('line count');
  console.log(
    `Performance now line count timing: ` + (t1 - t0).toFixed(3) + `ms`,
  );

  // names at letious points in time
  console.log(names[432]);
  console.log(names[43243]);
  t3 = now();
  console.timeEnd('names');
  console.log(`Performance now names timing: ` + (t3 - t2).toFixed(3) + `ms`);

  // most common first name
  let sortedDupeNames = Object.entries(dupeNames);

  sortedDupeNames.sort((a, b) => {
    return b[1] - a[1];
  });
  console.log(sortedDupeNames[0]);
  t5 = now();
  console.timeEnd('most common first name');
  console.log(
    `Performance now first name timing: ` + (t5 - t4).toFixed(3) + `ms`,
  );
  const name = sortedDupeNames[0][0];
  const nameOccurrences = sortedDupeNames[0][1];
  console.log(
    `The most common name is '${name}' with ${nameOccurrences} occurrences.`,
  );

  // number of donations per month
  logDateElements = (key, value) => {
    console.log(
      `Donations per month and year: ${value} and donation count ${key}`,
    );
  };
  new Map(Object.entries(dateDonations)).forEach(logDateElements);
  t7 = now();
  console.timeEnd('total donations for each month');
  console.log(
    `Performance now donations per month timing: ` +
      (t7 - t6).toFixed(3) +
      `ms`,
  );
});
```

轻松跑完，花了一分多钟。我还顺手写了个复制文件的源码：

```javascript
const fs = require('fs');

const read = fs.createReadStream('./itcont.txt');
const write = fs.createWriteStream('./itcont2.txt');

console.time('time');
read.on('data', (chunk) => {
  read.pause();
  const res = write.write(chunk, (err) => {
    if (err) {
      console.error('写入错误', err);
      process.exit(1);
    }
  });
  if (res) {
    read.resume();
  }
});

write.on('drain', () => {
  read.resume();
});
console.time('timeEnd');
```

也是轻松跑完，完全不需要 `event-stream` ，毕竟是个很久没有更新的库。

不过，这个编写仍然太过麻烦了， Node 现在又提供了新的 API `pipeline` 以通过更安全的管道处理。

```javascript
const fs = require('fs');
const { pipeline } = require('stream');

const read = fs.createReadStream('./itcont.txt');
const write = fs.createWriteStream('./itcont2.txt');

console.time('time');
pipeline(read, write, (err) => {
  if (err)
    console.log(err);
});
write.on('close', () => {
  console.timeEnd('time');
});
```

针对可读流， Node 还提供了迭代器的写法。比如说上面读取的代码，完全可以改写下面的样子：

```javascript
(async () => {
  let line = '';
  for await (const chunk of read) {
    const s = chunk.toString();
    if (/\n/.test(s)) {
      const [pre, after = ''] = s.toString().split('\n');
      line += pre;
      resolve(line);
      line = after;
    } else {
      line += s;
    }
  }
})();
```

其他的一些内容，可以参考[这篇文章](https://juejin.cn/post/6928955027952238599)。
