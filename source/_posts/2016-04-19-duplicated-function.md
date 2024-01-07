---
layout: post
title: 词向量的唯一化
category: 算法 
status: publish
type: post
published: ture
---

最近[duoshuo社会化评论](duoshuo.com)崩溃了，上千条评论就这么没了，各种手段恢复无果。只能怪我太懒，不爱经常做备份。果断将博客评论迅速转移到[disqus](http://disqus.com)，希望以后不会有事（后来还是有事了，所有评论都没了，额）。


# 表意一致问题

言归正传，最近和工程师讨论词向量表征商品特征的思路时，遇到一个很有意思的现象：一个商品很可能标记了

- 维达纸巾
- 纸巾维达

这两个特征的意义实际一致，从权重角度考虑，应该做合并处理。工程师给了一个 Python 版本，我也忍不住给了一个 R 版本，大家可以看看使用 match 索引和 duplicated 函数的作用。

<!-- more -->

```r
txt <- scan(textConnection('
维达纸巾
维达
卫生纸
纸巾维达
纸巾
tempo纸巾抽纸
纸巾抽纸tempo
纸巾tempo抽纸
抽纸
'), what = 'character')

m <- lapply(iconv(txt, toRaw=T), function(x)paste(sort(as.character(x)), collapse = ''))
m <- unlist(m)
z <- match(m, unique(m))
data.frame(txt, b = txt[!duplicated(m)][z])
```

思路很简单，将所有的字排序之后，再做raw vectors拼接，如果一样，则认为是同样的表意。最后通过索引返回同样表意的原始词汇。这段代码百万级别重复词汇是完全可以处理，且性能可靠。


# 益辉的建议

上述代码可能确实存在误分的风险，需做完全切割：

```r
m = lapply(strsplit(txt, ''), function(x) {
  paste(sort(x), collapse = '')
})
```
