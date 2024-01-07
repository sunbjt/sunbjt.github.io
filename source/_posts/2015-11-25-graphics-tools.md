---
layout: post
title: 用 R 做人工审核图片的小工具
category: 不务正业的 R
tags: 
- pictrue
- tools
status: publish
type: post
published: true
---

好久不写博客，文债太多。其实写了好几篇，不过没润色好，暂时没有放出来。

这两天搞了搞深度神经网络，顺带玩了玩公司的晒单图片，不过需要人工审核每个文件夹（对应一个sku）下面的图片是否可以用于模型。
人工审核的意思就是自己一张一张图片的看，然后删……真是对人性的折磨啊~~

为了加快效率，所以又让R不务正业了一把。大致逻辑是：

1. 获得所有需要人工审核的子目录
2. 将这些子目录下的图片全部拼接成一张照片，第一张是晒单的，后面的商品原图
3. 人工筛选拼装图片，保留可利用的图片
4. 根据剩下的图片id索引原始图片子目录

<!-- more -->

代码如下：

```r
library(jpeg)

readJPG1 <- function (source)
if(file.size(source) == 0) readJPEG(system.file("img", "Rlogo.jpg", package="jpeg")) else { 
readJPEG(source)
} # 容错，一旦文件大小为0，则补充R图片

setwd('C:/Users/liusizhe111/dir') # 生成合并图像位置
path <- 'C:/Users/liusizhe111/liusizhe' # 目标文件夹
tt <- dir(path) # 第一层目录包含的文件夹

for (i in 1:length(tt)){
	d1 <- tt[i] # 第i个子文件夹
	dd <- paste(path, '/',  d1, sep = '') # 拼成全路径
	mm <- dir(dd) # 子文件下面的文件
	n <- length(mm)
	tmp <- list()
	for(j in 1:n){
	file <- paste(dd, '/', mm[j], sep = '')
	tmp[[j]] <- try(readJPG1(file))
}
jpeg(paste(d1, '.jpg', sep = ''), 
			height = 400, width = 400*n) # 按照n生成图片大小
par(mfcol = c(1,n), mar = rep(0,4))
try(
	for(j in 1:n) {
		plot(1:2, type = 'n', axes = FALSE)
		rasterImage(tmp[[j]], 1.1, 1.1, 1.9, 1.9)
		text(1.5, 1.5, mm[j], col = 'red', cex = 1.2)
	}
)
dev.off()
}
```


人工审核图片就简单了，用ACDSee打开图片，保留的就空格下一张，不要的就直接del。这样就剩下了保留的组合。
我们再根据这些图片索引，移动文件夹就可以了。

```r
candi <- 'C:/Users/liusizhe111/dir'
from <- 'C:/Users/liusizhe111/liusizhe'
todir <- 'C:/Users/liusizhe111/finaldir'
candi <- gsub('.jpg', '', dir(candi))
for (i in candi){
	move <- paste('move ', from, '/', i, ' ', todir, sep = '')
	shell(move)
}
```

最后给些福利吧，这代码看起来太枯燥。从人工筛选的图片里抽一张美女晒图照，这个类型的大概仅占10%左右 :)

<img width="660" height="186" src="/upload/pic/haha1.jpg"/>

P.S. 看女人晒单真是好折磨，模特和普通用户差别好大啊~