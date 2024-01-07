---
layout: post
title: 曼德布洛特集
tags: 
- Mandelbrot set
- 分形
status: publish
type: post
published: true
---

前一段时间，John Baez 在自己的主页上更新了一篇文章名为[he Beauty of Roots](http://math.ucr.edu/home/baez/roots/) ，这篇文章之后在“科学松鼠会”上被[《多项式的根之美》](http://songshuhui.net/archives/23604.html) 转载。上面提到了[曼德布洛特集](http://en.wikipedia.org/wiki/Mandelbrot_set)，根据其发明者法国数学家[Benoît Mandelbrot](http://commons.wikimedia.org/wiki/Beno%C3%AEt_Mandelbrot) 而命名。

曼德布洛特集是一种分形，从一般分形性质来说：

>客观自然界中许多事物，具有自相似的“层次”结构，在理想情况下，甚至具有无穷层次。适当的放大或缩小几何尺寸，整个结构并不改变。不少复杂的物理现象，背后就是反映着这类层次结构的分形几何学。

常见的曼德布洛特集是这个样子（分辨率原因，部分细节显示不够）：

![](https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/scale1.png)

假如我们把这个集合的下半部分（最下边的小块）分割出来，就是这个样子（8倍放大）：

![](https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/scale2.png)

由于分辨率的提高，所以显示了第一幅图中并没有显示的细节。

继续放大，上图的左上部分的那个小枝（6倍放大）：

![](https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/scale4.png)

再把上图最靠近左边的那个小枝——放大（50/3倍放大）：

![](https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/scale5.png)

继续放大最左边的小枝，似乎在末端又出现了一个类似的小枝（5倍放大）：

![](https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/scale6.png)

如果继续放大下去可能还是这个样子 ：）

注释：

1. 最后一张图相比第一张图来说相当于局部放大了 4000 倍。
2. 高质量的矢量绘图数据量比较大，R 处理起来有些问题，只好使用局部放大的方式。
3. 更多的使用其他软件绘制图形可以见：http://commons.wikimedia.org/wiki/Mandelbrot_set


附代码：

```r
setwd("D:\\doc\\Mandelbrot\\pic")
# Another neat animation of Mandelbrot Set
jet.colors <-
  colorRampPalette(
    c(
      "#00007F",
      "blue",
      "#007FFF",
      "cyan",
      "#7FFF7F",
      "yellow",
      "#FF7F00",
      "red",
      "#7F0000"
    )
  ) # define "jet" palette
m = 400
C = complex(real = rep(seq(-1.8, 0.6, length.out = m), each = m),
            imag = rep(seq(-1.2, 1.2, length.out = m), each = m))
C = matrix(C, m, m)
Z = 0
for (j in 1:20) {
  Z = Z ^ 2 + C
  X = exp(-abs(Z))
}
png("scale1.png")
par(mar = c(0, 0, 0, 0))
image(X, col = jet.colors(1000))
dev.off()



m = 400
C = complex(real = rep(seq(-1.6, -1.3, length.out = m), each = m),
            imag = rep(seq(-0.15, 0.15, length.out = m),      m))
C = matrix(C, m, m)
Z = 0
for (j in 1:20) {
  Z = Z ^ 2 + C
  X = exp(-abs(Z))
}
png("scale2.png")
par(mar = c(0, 0, 0, 0))
image(X, col = jet.colors(1000))
dev.off()


####

m = 400
C = complex(real = rep(seq(-1.4, -1.3, length.out = m), each = m),
            imag = rep(seq(-0.15, -0.05, length.out = m),      m))
C = matrix(C, m, m)
Z = 0
for (j in 1:20) {
  Z = Z ^ 2 + C
  X = exp(-abs(Z))
}
png("scale3.png")
par(mar = c(0, 0, 0, 0))
image(X, col = jet.colors(1000))
dev.off()


m = 400
C = complex(real = rep(seq(-1.35, -1.30, length.out = m), each = m),
            imag = rep(seq(-0.13, -0.08, length.out = m),      m))
C = matrix(C, m, m)
Z = 0
for (j in 1:20) {
  Z = Z ^ 2 + C
  X = exp(-abs(Z))
}
png("scale4.png")
par(mar = c(0, 0, 0, 0))
image(X, col = jet.colors(1000))
dev.off()


m = 400
C = complex(real = rep(seq(-1.3280, -1.3250, length.out = m), each = m),
            imag = rep(seq(-0.1225, -0.1195, length.out = m),      m))
C = matrix(C, m, m)
Z = 0
for (j in 1:20) {
  Z = Z ^ 2 + C
  X = exp(-abs(Z))
}
png("scale5.png")
par(mar = c(0, 0, 0, 0))
image(X, col = jet.colors(1000))
dev.off()


m = 400
C = complex(real = rep(seq(-1.3276, -1.3270, length.out = m), each = m),
            imag = rep(seq(-0.1221, -0.1215, length.out = m),      m))
C = matrix(C, m, m)
Z = 0
for (j in 1:20) {
  Z = Z ^ 2 + C
  X = exp(-abs(Z))
}
png("scale6.png")
par(mar = c(0, 0, 0, 0))
image(X, col = jet.colors(1000))
dev.off()

```