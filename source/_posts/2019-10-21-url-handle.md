---
layout: post
title: 在 R 中各种码的转换
category: R 技巧
status: publish
type: post
published: true
---

各位看官在平时用 R 处理网页的过程中，一定会被各种乱码、转码所困扰，这里做一些小型的总结，会涉及到：

1. encode 和 decode
2. md5 加密
3. 字符集转换
4. 繁体转化为简体
5. 字体的指定

逐个解释如何处理：

Encode 和 Decode 处理最为简单，因为在 R 中自带的 utils 就存在方法，具体函数是 `URLencode` 和 `URLdecode`。

<!-- more -->

```r
> URLencode('我是谁')
[1] "%E6%88%91%E6%98%AF%E8%B0%81"
> URLdecode("%E6%88%91%E6%98%AF%E8%B0%81")
[1] "我是谁"
```

Md5 加密使用 openssl 中的 `md5` 函数即可，同理 `sha256` 和 `sha512` 加密算法。

```r
library(openssl)
> md5('我是谁')
[1] "0bb5fa2e7bd96c77ae436ff352e3664d"
> sha256('我是谁')
[1] "63621be272d0f8266518e62bc739d97793c03b8b70a077345ce20914410de441"
```

字符集转化使用的是自带 base 包中的 `iconv` 函数，可以将两种字符集任意转换。

 ```r
> iconv('我是谁', 'UTF-8', 'GBK')
[1] "\xce\xd2\xca\xc7˭"
 ```

简繁体转化，需要使用 `ropencc` 这个包

```r
library(ropencc)
cc = converter(S2T)
## T2S means Traditional Chinese to Simplified Chinese.
## S2T means Simplified Chinese to Traditional Chinese.
run_convert(cc, '我是谁')
[1] "我是誰"
```

字体一般可以通过全局变量 par 中的 family 来设定，但有些需要特殊设定，比如 igraph 包中的绘图情况：

```r
library(igraph)
library(tidyverse)
x <- read.table(textConnection("
物理,化学
化学,生物
英语,数学
数学,语文
语文,化学"), sep = ',', stringsAsFactors = F)
x <- x %>%
  mutate(
    V1 = iconv(V1, 'UTF-8', 'UTF-8'),
    V2 = iconv(V2, 'UTF-8', 'UTF-8')
  )

g <- graph_from_data_frame(x)
plot(g, vertex.label.family= 'Noto Sans SC Light')
```
