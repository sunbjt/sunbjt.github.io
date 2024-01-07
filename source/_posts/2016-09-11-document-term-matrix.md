---
layout: post
title: 使用 R 原生函数来做文本挖掘
category: R 技巧
tags: 
- jiebaR
status: publish
type: post
published: true
---

最近有几位同学问到我如何利用tm包做文本挖掘，比较抱歉的是时间不太充足，不能完整更新文档。在这里只好给大家一些 tips，来利用R的原生函数来完成文本挖掘的核心步骤。

```r
setwd('C:/Users/Administrator/Downloads')
options(width = 150)
library(data.table)
x <- fread('comment.txt', sep = '\t', header = FALSE)
x$V3 <- iconv(x$V3, 'UTF-8', 'GBK') # 第三类为文本内容，字符集转化
x <- x[which(nchar(x$V3) > 3),]
n <- 10000 # 设置抽样数量，保证计算时长
x <- x[sample(1:nrow(x),n),]

library(jiebaR)
library(Matrix)

JR = worker(user = 'D:/source/RecModels/prototype/TagGen/userdict.txt')
seg_raw <- sapply(x$V3, segment, JR) # 执行分词

id <- unique(unlist(seg_raw)) # 生成Term
id <- id[nchar(id) >=2 & nchar(id) <= 5] # 将Term太长和太短的去掉，比如“强”
col_id <- as.vector(unlist(sapply(seg_raw, match, id)))
NA_index <- !is.na(col_id) 
col_id <- col_id[NA_index] # 去除列的空值位置号
row_num <- sapply(seg_raw, length)
row_id <- rep(1:length(seg_raw), times = row_num)
row_id <- row_id[NA_index] # 去除行的空值位置号
## 生成DTMatirx
m <- sparseMatrix(i = row_id, j = col_id)
```


核心思想是创造 Term 和原始文档分词之后对应的索引，来创造 Document Term Matrix。当然中间涉及各种 Term 的预处理，这时候使用标准函数即可操作。

DTM有了之后，`接下来就请enjoy it`！
