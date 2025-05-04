---
layout: post
title: AB 实验之方差缩减技术
status: publish
type: post
category: 因果推断
published: true
---

# 1. 前序知识

话说实施 AB 实验有一个非常关键的点就是可靠的统计分析，当然这个分析会涉及非常多的统计学知识，比如：

1. 统计结果的理解是否正确：置信度、区间估计、显著性、Power 值、MDE、样本量……

2. 实验分析的过程是否正确：AA 实验、反转实验、DID、幸存者偏差、辛普森悖论、CUPED、局部到全局……

这些概念构成了 AB 实验分析的基础框架，比如置信度和显著性帮助我们判断实验结果的可信度，而 Power 值和样本量则确保实验有足够的灵敏度检测到真实的效应。

有一个名词估计大家有点眼生，那就是 CUPED，这个方法的全称是 Controlled-experiment Using Pre-Experiment Data，中文翻译为：使用预实验数据进行控制的实验。CUPED 的核心目标是提升 AB 实验的统计显著性。其关键在于利用预实验数据调整指标，通过缩减方差来增强检测效果。

<!-- more -->

# 2. 基本原理

为了验证 AB 实验是否显著，我们经常使用 t 检验，t 检验的基本思想是：

1. 计算实验中两个组的均值差异；
2. 计算均值差异的标准误差；
3. 计算 t 值；如果大于临界值，则拒绝原假设，认为实验结果显著；否则，不拒绝原假设，认为实验结果不显著。

t 值的构建公式如下（以总体方差相等情况为例）：

$$
\begin{equation}
t=\frac{\bar{X}_1-\bar{X}_2}{\sqrt{s_c^2\left(\frac{1}{n_1}+\frac{1}{n_2}\right)}}
\end{equation}
$$

其中，$\bar{X}_1$ 和 $\bar{X}_2$ 分别为两组的样本均值，$s_c^2$ 是合并方差（pooled variance），$n_1$ 和 $n_2$ 为样本量。

从 t 值的公式我们可以观察到，要想实验结果有显著性，有三个思路：

1. 指标的变动较大（$\bar{X}_1-\bar{X}_2$），策略非常有效，然而多数情况下这种情况可遇而不可求；
2. 增加实验的样本量（$n$），可通过提高实验流量配比或者让实验持续更长时间来实现；
3. 缩减指标的方差（$s_c^2$），指标的方差越小，t 值越大；

在 1、2 两种方式基本不太现实的情况下，方差缩减一种技术上很值得尝试的技术策略。它的基本思想是通过某种方法，将实验中的多个样本组合成一个样本，从而减少实验结果的方差。

在一个在线广告点击率的研究为例，$y$ 可能是用户在实验期间对新广告设计的点击行为，而 $x$ 则可能是用户在过去一个月内的平均点击次数或者购买次数。

$$
\hat{Y}=Y-\theta(X-E[X])
$$

这里

1. $Y$ 是原始的目标变量（实验结果）。
2. $X$ 预实验协变量（pre-experiment data），实验前就存在的数据。
3. $𝐸[𝑋]$ 是协变量 $X$ 的期望值或均值。
4. $\theta$：待估计参数，表示 $X$ 对 $Y$ 的影响程度

# 3. 推导过程

推导过程并不复杂，有基本的概率论和高等数学知识即可完成。

我们可以找到一个协变量 $X$，对于每个数对 $(y_i, x_i)$ 都有 $\hat{y_i}=y_i - \theta x_i + \theta E(x)$，其中 $\theta$ 是一个未知参数。很容易确定 $\hat{y_i}$ 是 $y_i$ 的无偏估计量，因为：

$$
\begin{aligned}
E(\hat{Y_i}) &= E(Y_i - \theta X_i + \theta E(X)) \\ 
             &= E(Y_i) - \theta E(X_i) + \theta E(X) \\
             &= E(Y_i) - \theta (E(X_i) - E(X)) \\ 
             &= E(Y_i)
\end{aligned}
$$

计算 $\hat{Y}_i$ 的方差：

$$
\begin{aligned}
\text{Var}(\hat{Y}_i) &= \text{Var}(Y_i - \theta(X_i - E[X])) \\
&= \text{Var}(Y_i - \theta X_i + \theta E[X]) \\
&= \text{Var}(Y_i - \theta X_i) \quad \text{(因为 } \theta E[X] \text{ 是常数)} \\
&= \text{Var}(Y_i) - 2\theta \cdot \text{Cov}(Y_i, X_i) + \theta^2 \cdot \text{Var}(X_i)
\end{aligned}
$$

我们希望找到一个 $\theta$，使得 $\text{Var}(\hat{Y}_i)$ 最小。对上述表达式关于 $\theta$ 求导，并令导数为0，可找到最优的 $\theta^*$ 值：

$$
\frac{d}{d\theta} \text{Var}(\hat{Y}_i) = -2 \cdot \text{Cov}(Y_i, X_i) + 2\theta \cdot \text{Var}(X_i) = 0
$$

解得：

$$
\theta^* = \frac{\text{Cov}(Y_i, X_i)}{\text{Var}(X_i)}= \beta_{OLS}
$$

这就是最优的 $\theta$ 值 —— **最小二乘回归系数**。

将 $\theta^* = \frac{\text{Cov}(Y,X)}{\text{Var}(X)}$ 代入原方差公式：

$$
\begin{aligned}
\text{Var}(\hat{Y}) 
&= \text{Var}(Y) - 2\theta \text{Cov}(Y,X) + \theta^2 \text{Var}(X) \\
&= \text{Var}(Y) - 2 \cdot \frac{\text{Cov}(Y,X)}{\text{Var}(X)} \cdot \text{Cov}(Y,X) + \left( \frac{\text{Cov}(Y,X)}{\text{Var}(X)} \right)^2 \cdot \text{Var}(X) \\
&= \text{Var}(Y) - \frac{\text{Cov}^2(Y,X)}{\text{Var}(X)}
\end{aligned}
$$

因此：

$$
\text{Var}(\hat{Y}) = \text{Var}(Y)(1 - \rho^2) \le \text{Var}(Y)
$$

其中 $\rho = \text{Corr}(Y, X)$，是 $Y$ 和 $X$ 的相关系数。所以只要 $X$ 和 $Y$ 存在非零相关性，调整后的方差就会小于原始方差。因此这个方法可以提升实验的统计功效。

注：$X$ 不能受到 treatment 的影响。

# 4. 模拟

模拟一些数据来看下结果是否如我们所想。

```r
library(tidyverse)

# 设置随机种子
set.seed(0)
N <- 10000 # 样本大小
tau <- 0.2 # 真实的 treatment 影响
theta_true <- 0.6 # x 和 y 之间的相关系数
treatment <- rbinom(N, 1, 0.5) # treatment
x <- rnorm(N) # 实验前变量
y <- theta_true * x + treatment * tau + rnorm(N) # 响应变量
df <- data.frame(y = y, t = treatment, x = x)

# 计算 \theta 使用 OLS 回归
model <- lm(y ~ x, data = df)
theta_hat <- coef(model)[2] # 获取 x 的回归系数

# 应用 CUPED 调整
df <- df |>
  mutate(y_adj = y - theta_hat * (x - mean(x)))

# 进行后续分析，如评估 treatment 效应
model_adjusted <- lm(y_adj ~ t, data = df)
summary(model_adjusted)
# 观察原始的参数估计得方差变化
summary(lm(y ~ t, data = df))
```
可以观察到对 treatment 的效应估计，t 值从 8.213 提高到了 10.103；同时也可以看到方差变小的现象：

```r
data_long <- df %>%
  mutate(Group = ifelse(t == 1, "Treatment", "Control")) %>%
  select(Group, y, y_adj) %>%
  tidyr::gather(key = "Metric", value = "Value", -Group)

ggplot(data_long, aes(x = Group, y = Value, fill = Metric)) +
  geom_boxplot(alpha = 0.7) +
  labs(
    title = "CUPED 调整前后的指标分布",
    subtitle = "调整后（Y_adj）的方差更小，更容易检测效应",
    y = "指标值",
    x = "实验分组"
  ) +
  theme_minimal(base_family = 'Noto Sans SC')
```

![](/upload/pic/cuped.svg)

如图所示，调整后的指标（y_adj）的箱体更紧凑，说明方差明显减小。这种分布变化使得实验组和对照组的差异更容易被检测到。

# 5. 经验谈

根据微软 2013 年的实验研究，协变量的选择应遵循以下原则：

1. 选择实验运行之前的指标数据最好；
2. 时间粒度较长的历史数据（如30天）比短期数据（如7天）更稳定。

实验前数据并不是 $X$ 的唯一选择，只要是不会被实验干预影响的变量，都可以选择。比如用户加入实验的日期。

# 6. 扩展机器学习

在 CUPAC（Controlled-experiment Using Predicted Pre-Experiment Data）框架中，我们并不直接估计一个单一的 $\theta$ 值，而是通过训练机器学习模型来预测每个个体的潜在结果（即基线表现）。这种方法与传统的 CUPED 有所不同，在 CUPED 中，$\theta$ 是基于协变量和目标变量之间的线性关系计算出来的。而在 CUPAC 中，我们使用机器学习模型来捕捉更复杂的模式，并利用这些预测值作为调整目标变量的基础。

在CUPAC中，关键步骤是训练一个机器学习模型来预测每个个体在没有实验干预情况下的潜在结果。以下是具体步骤：

1. 使用历史数据（预实验数据）作为训练集。这些数据应该包含所有相关的特征（如用户的浏览历史、购买记录等），以及目标变量的历史表现。
2. 选择合适的机器学习模型进行训练。可以是线性回归、随机森林、梯度提升树（GBM）、神经网络等。选择哪种模型取决于数据的特性和复杂性。
3. 使用历史数据训练模型，以预测每个个体在没有实验干预情况下的表现。假设我们的目标是预测点击率（CTR），则训练的目标是让模型能够根据历史行为预测未来的 CTR。
4. 使用训练好的模型对实验期间的数据进行预测，得到每个个体的基线表现 $\hat{Y}_{pre}$。
5. 利用预测的基线表现 $\hat{Y}_{pre}$ 来调整实际观察到的目标变量 $Y$。调整后的目标变量 $\hat{Y}$ 可以表示为：

$$
\hat{Y} = Y - \hat{Y}_{pre}
$$

相比于单一的 $\theta$ 值，机器学习模型能够捕捉到更复杂的非线性关系和交互作用，提供更加个性化的预测。这意味着对于每个个体，我们可以更准确地估计其基线表现，从而更精确地调整目标变量 $Y$，显著提升实验设计的精度和可靠性。