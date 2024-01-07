---
layout: post
title: 用 OpenBLAS 加速 R 的矩阵运算
category: R 技巧
tags: 
- parallel
status: publish
type: post
published: true
---

话说 2010 年我和鸟兄去豆瓣做一个技术交流，阿稳现场展示了并行化计算的 R 环境，矩阵运算瞬间跑满了所有的 CPU，当时让我羡慕不已。多年之后在 [第六届 R 语言会议](http://cos.name/2013/05/6th-china-r-beijing-summary/) 上，张先轶为大家展示了他们负责跟进研发的开源线性代数计算库 [OpenBLAS](http://xianyi.github.io/OpenBLAS/)，这个库建立在已经停止开发的 GotoBLAS2 上，对 Intel Sandy Bridge 有非常好的支持（性能上甚至同 MKL 不相上下）。

线性代数库是 R 底层天然的并行运算的极好支持（Revolution R 使用的 MKL 库的支持），可以有效的提高 R 的计算效率。这里要再次感谢中科院张先轶的贡献！

# 1. OpenBLAS 的编译

OpenBLAS 的编译还是比较方便的，如果没有特殊要求，下载直接执行快速安装即可

```
make
make install
```

即可自行依照环境安装相关组件。

<!-- more -->

# 2. R 的编译

OpenBLAS 环境安装完毕后，即可安装 R 环境，同一般安装 R 类似，需要增加如下参数：

```
./configure --disable-nls --with-blas="-lopenblas" --with-lapack --enable-R-shlib 
make
make install
```

编译的时候可能会报 BLAS 相关的 so 找不到，按照错误代码信息将文件拷贝至目录即可（或建 link）。如果需要增加tcltk支持（比如说要使用sqldf包），在configure时还需要增加如下参数：

```
		--with-tcl-config=/usr/lib/tcl8.5/tclConfig.sh --with-tk-config=/usr/lib/tk8.5/tkConfig.sh
```

接下来我们对比一下个人电脑的两种平台的计算情况：

* Windows 64 位系统无 BLAS 支持，原生 R
* Ubuntu 64 位系统下 OpenBLAS 支持的 R

先看 Windows 平台原生 R 环境下两个 6000 x 6000 矩阵相乘的结果：

```
> x <- matrix(1:(6000 * 6000), 6000, 6000)
> system.time(tmp <- x %*% x)
   user  system elapsed 
 163.67 0.11  163.94 
> system.time(tmp <- x %*% x)
   user  system elapsed 
 163.71 0.11  163.99 
```

再看使用 Open BLAS 加速的 R 的运算结果：

```
x <- matrix(1:(6000 * 6000), 6000, 6000)
system.time(tmp <- x %*% x)
   user  system elapsed 
 37.964   0.320  19.434 
system.time(tmp <- x %*% x)
   user  system elapsed 
 38.156   0.256  19.495 
```

下图是我的 PC 双核欢快的跑满（物理双核，虚拟四线程）资源的样子：

<img src="https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/blas.png"/>

可见 Open BLAS 对于 R 的底层矩阵运算的提升非常明显，可以想象如果在 R 中如果大量的使用向量化编程思路，计算所损耗的时间将会大大缩短。

最后请注意：还未仔细尝试其兼容性，请酌情使用！
