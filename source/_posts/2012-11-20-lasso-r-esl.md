---
layout: post
title: "LASSO"
tags: 
- bigdata
- tips
status: unpublish
type: post
published: false
---

#关于glmnet中实现的LASSO

# 最小角回归LARS

对于模型选择（model selection）问题，我们一般通过逐步回归的方法处理，比如All Subsets，Forward Selection，Backward Elimination。
一般的，我们会有很多变量，但需要从中选择出较少的变量但能够对响应变量进行有效的预测。Least Angle Regression(LARS)则是一种处理
上述问题的新方法，它比传统的Forward Selection的效果要更好（useful and less greedy）。

这衍生出了三种主要属性：

- LARS算法简单的修改则实现了Lasso，一个更加积极的，包含“回归系数绝对值加和”的最小二乘版本；LARS的修改版本计算了所有的给定问题的
所有可能的Lasso估计，但是用的计算时间则远远小于以前的方法。

- 向前法最小二乘

- Cp估计

## 简介

LARS和一些传统的最优子模型选取有关系，比如“Forward Selection”或者称为“forward stepwise regression”。逐步向前回归的思想是，
选取同响应变量y绝对相关系数最大的x_{j1}，而后构建x_{j1}和y的简单线性回归模型，模型的残差同x_{j1}正交，这个残差被当作下一个
响应变量，我们保护引入的预测变量同x_{j1}正交，而后重复这一过程。在k步之后，会得到一个预测变量的集合x_{j1}，x_{j2}，x_{j2}……x_{jk}，
然后使用普通的线性回归模型进行预测。但Forward Selection是一个侵略性较强的算法，也许在第二步选择的预测变量很可能同x_{j1}有强烈
相关。

Forward Stagewise是Forward Selection更小心的版本，它在达到最终模型前做了上千次细小的步子。这也是LARS算法最初的动机，使用一个
简单的公式允许Forward Stagewise的步子更大，但又比经典的Forward Selection的步子要小，这样能极大的降低计算消耗。