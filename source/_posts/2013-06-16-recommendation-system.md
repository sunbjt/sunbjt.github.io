---
layout: post
title: 协同过滤和推荐引擎
category: 算法
status: publish
type: post
published: true
mathjax: true
---

推荐系统在个性化领域有着广泛的应用，从技术上讲涉及概率、抽样、最优化、机器学习、数据挖掘、搜索引擎、自然语言处理等多个领域。东西太多，我也不准备写连载，今天仅从基本算法这个很小的切入点来聊聊推荐引擎的原理。

# 1. 推荐系统的策略

推荐引擎（系统）从不同的角度看有不同的划分，比如：

- 按照数据的分类：协同过滤、内容过滤、社会化过滤
- 按照模型的分类：基于近邻的模型、矩阵分解模型、图模型

<!-- more -->

上面的这种说法有点乱，换个说法：一般我们将推荐系统归纳于两项策略，一种是基于内容的过滤（content-based filtering）以及基于用户行为的协同过滤（collaborative filtering）。

基于内容的过滤创建了每个商品、用户的属性（或是组合）用来描述其本质。比如对于电影来说，可能包括演员、票房程度等。用户属性信息可能包含地理信息、问卷调查的回答等。这些属性信息关联用户用户后即可达到匹配商品的目的。当然基于内容的策略极有可能因为信息收集的不便而导致无法实施。

一个比较成功的内容过滤是 pandora.com 的音乐基因项目，一个训练有素的音乐分析师会对每首歌里几百个独立的特征进行打分。这些得分帮助pandora推荐歌曲。还有一种基于内容的过滤是基于用户人口统计特征的推荐，先根据人口统计学特征将用户分成若干个先验的类。对后来的任意一个用户，首先找到他的聚类，然后给他推荐这个聚类里的其他用户喜欢的物品。这种方法的虽然推荐的粒度太粗，但可以有效解决注册用户的冷启动(Cold Start)的问题。

与基于内容的过滤算法相对的另一种策略是：依赖于用户过去的行为的协同过滤，行为可以是过往的交易行为和商品评分，这种方式不需要显性的属性信息。协同过滤通过分析用户和商品的内在关系来识别新的 user-item 关系。一般来说基于用户行为的协同过滤方法要优于基于内容的技术，但会有冷启动的问题。对于新系统来说，基于内容的推荐则更优。

协同过滤领域主要的两种方式是最近邻（neighborhood）方法和潜在因子（latent factor）模型。最近邻方法主要集中在 item 的关系或者是 user 的关系，是比较基础的过滤引擎。而潜在因子模型并不是选取所有的关系，而是通过矩阵分解的技术将`共现矩阵`的分解，比如提取20-100个因子，来表示原始矩阵信息（可以对比上面提到的音乐基因，只不过潜在因子模型是通过计算机化的实现）。


# 2. 近邻协同过滤

矩阵分解技术稍稍复杂一点，暂不介绍，下面着重说一下 item based 最近邻的协同过滤。

对于一般的协同过滤引擎，首先会有一个 item-item 的相似矩阵 $S$，比如下图所示（来自于 recommenderlab 包的 vignette 文档），它记录了每两个 item 间的相似情况。但由于计算量和内存的考虑，一般在构建推荐引擎时不会这么暴力的存储全部的相似信息，而是使用部分信息。比如（按行来看）和 $i_1$ 最相关的三个item是 $i_4, i_5, i_6$，而另外的两个 item $i_2, i_8$ 则不参与计算。

<img src="https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/item-based2.png"/>

介绍完相似矩阵，接下来就的最近邻协同过滤就非常简单了，假如用户 $u_\alpha$ 对 $i_1, i_5, i_8$ 分别打了 2，4，5 分，根据相似阵 $S$ 中 item 的相似程度，来计算其余未打分的 item 的评分，即

>对于每个 item （相似）加权平均后的得分，再过滤已评分的 item

最后的 $r_\alpha$ 则是对 item 的预测结果。

既然逻辑都讲清楚了，那不实现一下推荐引擎就有点说不过去了。首先介绍一下原始的输入数据，共三列：第一列代表用户，第二列表示购买的 item 的名称，第三列表是用户在这个 item 上的评分：

```r
x <- read.csv(textConnection("
  1,101,5.0
  1,102,3.0
  1,103,2.5
  2,101,2.0
  2,102,2.5
  2,103,5.0
  2,104,2.0
  3,101,2.5
  3,104,4.0
  3,105,4.5
  3,107,5.0
  4,101,5.0
  4,103,3.0
  4,104,4.5
  4,106,4.0
  5,101,4.0
  5,102,3.0
  5,103,2.0
  5,104,4.0
  5,105,3.5
  5,106,4.0  
"), header = FALSE)
```

接下来是根据上述用户行为，预测用户没有评分的 item 的得分：

```r
rn <- sort(unique(x$V1))
cn <- sort(unique(x$V2))
library(Matrix)
y <-
  sparseMatrix(i = match(x$V1, rn),
               j = match(x$V2, cn),
               x = x$V3)
h <- as.matrix(dist(t(y), diag = TRUE) ^ 2)
h <- 1 / (1 + h)
diag(h) <- 0
## 推荐引擎的四个参数：相似矩阵、购买了什么，得分是多少，推荐几个
recommend <- function(h = h,
                      k = c(3, 5),
                      score = c(4, 5),
                      m = 1) {
  if (length(k) > 1)
    v <- colSums(h[k, ] * score) / colSums(h[k, ])
  else
    v <- h[k, ]
  v[k] <- 0
  od <- order(v, decreasing = T)[1:m]
  return(list(colnames(h)[od], v[od]))
}
recommend(h,
          k = c(1, 3),
          score = c(1, 5),
          m = 2)
```

这也算是上代码量最短的协同过滤引擎之一了吧。


# 3. 最后

我们在返回来说几句推荐系统大逻辑，如果仅仅将推荐看作是算法（尤其是协同过滤）的确很简单，但对于一个登录用户：

1. 任意时刻都用一个算法推荐，鬼才搭理你；
2. 如果有脏数据在构建模型前要优先搞定；
3. 网站页面设计差，用户体验很烂，同样没用。

借用张栋在 2011 推荐系统论坛曾提出的说法：

> 一个成功的resys推荐系统的影响权重：UI/UE 40%，data:30%, knowledge: 20, algorithm:10%

推荐这事儿不那么简单。

