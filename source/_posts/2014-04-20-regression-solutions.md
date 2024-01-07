---
layout: post
title: 回归的几种实现方法
tags: 
- bigdata
- business
status: publish
type: post
published: false
---

在孔乙己曾经用茴香豆的茴字有几种写法，颇有些酸腐秀才的感觉。

回归分析（regression analysis）这个领域的内容实在太多，比如不同的参数
估计方式会引出不同的分类，

回归（regression）估计是所有统计系的入门的必学课程之一，一般课本中出现的方法无外乎就是 $\beta$ 的求解，

在 $X$ 是满秩的条件下，最小二乘的估计为

$$\hat{\beta}_{ols} = (X^T X)^{-1}X^T y$$

直接计算 $(X^T X)^{-1}$ 会存在一些稳定性问题，因此一般使用的矩阵正交分解的技术（尽管可能会更慢），比如 QR 分解。


# 为什么要使用R语言

