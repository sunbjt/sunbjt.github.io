---
layout: post
title: 用 R 实现马赛克拼图
category: 不务正业的 R
status: publish
type: post
published: true
---
三天前，<a href="http://cos.name/cn/profile/371112">itux</a> 在统计之都论坛上问到了如何做 <a href="http://www.matrix67.com/blog/archives/519" target="_blank">Matrix67</a> 博客上的平滑马赛克图，我是好事之徒，颠颠地跑去瞧了一眼。恩，蛮有意思的，而且非常黄，非常暴力！但比较悲剧的是我不会用Mathematica，只好用R实现了一下。

本来想标题改的彪悍一些——《一千二百个女人和我的故事》，想想还是算了吧，虽说是用了 1200 个漂亮女人组成了我的头像，但她们我一个也不认识，哈哈。

<img src="https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/20201228010551.png"/>

用的原图我就不贴了，实际上我是戴着眼镜的，马赛克平滑以后，不明显了。最后是代码，非常简单，不到20行：

```r
setwd('D:/doc/image/me')
library(ReadImages)
library(sqldf)
me <- read.jpeg('fun.jpg')
meid <- data.frame(z = 1:1200, y = as.numeric(me))
meid <- sqldf('select * from meid order by y')

setwd('D:/doc/image/others')
tmp <- NULL
for(i in dir()) tmp[[i]] <- read.jpeg(i)
id <- sapply(tmp, mean)
id <- data.frame(n = names(id), m = id)
id <- sqldf('select * from id order by m')
idx <- cbind(id, meid)
idx <- sqldf('select * from idx order by z')

setwd('D:/doc/image')
png('me.png', height = 1000, width = 750)
par(mfcol = c(40,30), mar = rep(0,4), xpd = NA)
for(i in idx$n) plot(tmp[[i]])
dev.off()

## 处理图片 ##
setwd('D:/doc/image/others')
shell("convert *.jpg  -crop 120x120+10+5 thumbnail%03d.png")
shell("del *.jpg")
shell("convert -type Grayscale *.png thumbnail%03d.png")
```

大概所需要的时间：构思写代码 1 个小时，下载和整理图片时间长点，3个多小时（当然你本地资源和<a href="http://www.matrix67.com/blog" target="_blank">Matrix67</a>一样丰富的话另说，哈）。
