---
layout: post
title: 素数的求法
category: 算法
status: publish
type: post
published: true
---
COS 上有人问过如何<a href="http://cos.name/bbs/read.php?tid=12781">求1～100的素数</a>。虽说这个问题没准就是计算机系大一新生的一道作业题，但对我这个几乎没有任何 C 编程经验的人来说，似乎还是有些挑战。花了几分钟整理了一下思路，既然素数的定义是只能被1和自身整除，那么： 

1. 如果第 n 个数，不能它前面的所有的数字（不包括1）整除，那么即为定义。但需要遍历所有数字，效率肯定不好。 
2. 如果 n 不能被 n 前面的所有素数整除的话，那么 n 应该是下一个素数（后来知道这个是<a title="算术基本定理" href="http://zh.wikipedia.org/w/index.php?title=算术基本定理&amp;variant=zh-cn">算术基本定理</a>）。 

根据第二点思路，写出 R 代码：

```r
prime2 <- function(m){
    x <- c(2,3,5,7,11)
    for(i in 13:m){
        if(!any(i%%x == 0)) x <- c(x,i)
    }
    return(x)
}
```

即给出前 5 个素数，而后寻找第 6 个素数；再根据 6 个素数找第 7 个；类推……；直至 n。

很快又有两种解法：

1. cloud_wei 的另外的实现方式：glm包的 isprime 函数（这个包似乎没有 Windows 版本）
2. jo3vul31l3 给出了最优的解法，即<a title="埃拉托斯特尼筛法" href="http://zh.wikipedia.org/w/index.php?title=埃拉托斯特尼筛法&amp;variant=zh-cn">埃拉托斯特尼筛法</a>：

```r
prime3<-function(m){
    x<-c(2:m) ; y<-NULL
    repeat{
        z<-x[(x%%x[1])!=0] ; y<-c(y,x[1])
        if(x[1]>sqrt(m))break
        x<-z
    }
    c(y,z)
}
```
