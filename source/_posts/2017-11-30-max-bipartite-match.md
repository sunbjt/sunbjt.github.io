---
layout: post
title: 最大双向匹配
tags: 
- matching
status: publish
type: post
published: false
---




```r
x <- read.table(text = "
a A
a B
a C
b A
b D
c B
c E
d H
d G
d F
e H
", sep = ' ')
library(igraph)
g <- graph_from_data_frame(x, directed = F)
type <- V(g)$name %in% unique(x$V1) # 仅保证 a-e 的单边最大匹配
max_match <- max_bipartite_match(g, type = type)
max_match

library(arules)
d <- data.frame(a = factor(x$V1), b= factor(x$V2))
m <- as(d, "transactions")


library(lpSolve)
res <- lp.assign(as.matrix(m@data), "max")

```








