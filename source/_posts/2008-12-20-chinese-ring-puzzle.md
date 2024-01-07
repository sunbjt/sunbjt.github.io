---
layout: post
title: n 连环的解法与实际步骤数
category: 算法
status: publish
type: post
published: true
---
九连环这个玩具，最早在高中的时候摸过，记得解它的时候因为很多重复步骤，所以恨不得要把它拆掉，还好最后解开了，
不然我又得加条"亵渎古人智力"的罪名，呵呵。闲话少扯，下面是 n 连环实际步骤数的求法：

```r
ggg <- function(n) {
  a <- numeric(n)
  a[1] <- 1
  a[2] <- 1
  for (i in 3:n) {
    a[i] <- a[i - 1] + 2 * a[i - 2] + 1
  }
  return(a)
}
```

比如九连环的实际步骤：

```r
gg(9)
[1]   1   1   4   7  16  31  64 127 256
```