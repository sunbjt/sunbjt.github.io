---
layout: post
title: 用 R 实现马赛克拼图
category: 不务正业的 R
status: publish
type: post
published: true
---

三天前，在统计之都论坛上问到了如何做[Matrix67](http://www.matrix67.com/blog/archives/519) 博客上的平滑马赛克图，我是好事之徒，颠颠地跑去瞧了一眼。

恩，蛮有意思的，而且非常黄，非常暴力！但比较悲剧的是我不会用 Mathematica，只好用 R 实现了一下。

本来标题党一些，叫做《一千二百个女人和我的故事》，想想还是算了吧，虽说是用了 1200 个漂亮女人组成了我的头像，但我一个也不认识，哈哈。

![](https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/20201228010551.png)

用的原图我就不贴了，实际上我是戴着眼镜的，马赛克平滑以后，不明显了。最后是代码，非常简单，不到 20 行：

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

大概所需要的时间：构思写代码 1 个小时，下载和整理图片时间长点，3个多小时（当然你本地资源和 Matrix67 一样丰富的话另说，哈）。

# 重更新代码

以前的包不能用了，另外不太优雅

```r
library(glue)
library(imager) # mac 需要 X11 的支持
library(jpeg)

## 处理图片 ##
setwd('/Users/liusizhe/bitbucket/code/imagemagick')
## system("convert source_gray.png -colorspace gray source_gray.jpg")
## system("convert source_gray.jpg -resize 50 source40.jpg")

size = 300
s <- 1:size
center <- sample(1:20, size = size, replace = TRUE)
## 基本思想是将照片等距加亮，这样就可以表达所有主体图片了
## -crop 250x250+5+10 的意思是（裁剪）
## 图片的中心店为准，向右 5 个像素点，向下 10 个像素点，取 250x250的图片出来
## 这里为了保证图片不会过于相似，所以做了随机“晃动”
for (i in s){
  cmd <- glue('convert input1.jpg -set option:modulate:colorspace hsb -modulate {s[i]},100 -resize 320 -crop 250x250+{center[i]}+{center[i]} image/modulate{s[i]}.jpg')
  system(cmd)
}
me <- readJPEG("source40.jpg")

## 将前面生成的图片读到一个 list
tmp <- list()
for(i in dir('/Users/liusizhe/bitbucket/code/imagemagick/image')){
  tmp[[i]] <- load.image(paste('image/', i, sep = ''))
}

## 找到主图每个像素点同生成的等距加亮图片，距离最近的那个
id_mean <- sapply(tmp, mean)
image_order <- outer(as.numeric(me), id_mean, '-') |> 
  abs() |> apply(1, which.min)

## 绘制图形
## 这里要注意 height 和 width 必须和 me 的像素一致
jpeg('me.png', height = nrow(me)* 50, width = ncol(me)* 50)
par(mfcol = dim(me), mai = rep(0,4), xpd = FALSE)
for(i in image_order) plot(tmp[[i]], axes = FALSE)
dev.off()

## 删除 image 目录下的临时文件
system("rm image/*")

```

