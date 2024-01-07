---
layout: post
title: 混合整数规划常用方法 R 实现
category: 算法
status: publish
type: post
published: true
---

运筹学（Operational Research）是一门应用于管理有组织系统的科学，最早的朴素思想在中国的古文献中多有记载，比如耳熟能详的田忌赛马的故事。运筹的一般思想是：在各项资源条件优先的情况下，如何确定一个方案，使得预期目标最优；或者为了达到预期目标，确定资源消耗最小的方案。在二次世界大战之后，组织和企业的活动规模更大，信息系统化空前完备（想象一下水晶报表的诞生多么让人兴奋），加之各类数学算法模型层出不穷，研究如何做好决策的运筹学也有了极大的发展。

运筹学方向很多，比如线性规划、非线性规划、整数规划、目标规划、动态规划、排队论、对策论等。笔者偷个懒，找一些在整数规划体系下的例子，让大家感受一下在日常企业中这些方法的应用。

# 1. 一个简化问题

公司有 4 条生产线，每条生产线的月产量分别为 0.56, 3.11, 3.04, 2.11。近期因为经济不景气，需要将月产量总和控制在 5 以内，但出于总成本摊销的考虑，又要保证产出尽可能的大，那么哪几条产线需要被关闭。我们盲猜结果：3 和 4 需要被关闭。当然这个问题手指头可以掰过来，超过十个手指头怎么办？

<!-- more -->

我们先约定一些参数的数学表达：

1.  每条生产线的月产量为 $w_i$
2.  产线是否开启用 $x_i$ 表示，要么是 0 要么是 1

那这个问题就可以用统一框架结构化表述该问题。

1. 设置决策变量 $x_{i} \in \{0, 1\}, i = 1,2,3,4$
2. 目标：最大化 $\sum x_i w_i$
3. 约束条件：$\sum x_i w_i \le 5$
4. 求解 $x_i$

我们尝试使用 R 包 [ompr](https://cran.r-project.org/package=ompr) 来实现上述过程（Optimization Modeling Package）：

```r
library(ompr)
library(ompr.roi)
library(ROI.plugin.glpk)

max_capacity <- 5
n <- 4
weights <- c(0.56, 3.11, 3.04, 2.11)
m <- MIPModel() |>
  add_variable(x[i], i = 1:n, type = "binary") |>
  set_objective(sum_over(weights[i] * x[i], i = 1:n), "max") |>
  add_constraint(sum_over(weights[i] * x[i], i = 1:n) <= max_capacity) |>
  solve_model(with_ROI(solver = "glpk")) |>
  get_solution(x[i])

> m
  variable i value
1        x 1     1
2        x 2     1
3        x 3     0
4        x 4     0
```

果然和我们猜想一样，3 和 4 需要被关闭。

P.S.

ompr 这个包非常优秀，将设置决策变量、最优化目标、约束条件，以及求解四个步骤，很清晰地通过管道操作来表达。具体细节各位看官可以参考官方文档。

# 2. 排班

假设某培训机构，周一到周日所需要的老师数为3782, 3718, 2580, 2912, 4112, 7862, 7007，设为 $b$，且要保证老师每周有连续两天的休息，有两个问题需要回答：

1. 机构需要准备多少老师
2. 这些老师该如何排班

首先生成所有的排班可能 $A_{ij}$，表示第$i$天的第 $j$ 个班型需要的人数，同时假设第 $i$ 天的工作人数为 $x_{i}$，那么满足

$$
\min z= \sum_{i} x_i \\
$$

$$
s.t. \sum_i\sum_j x_i A_{i,j} \le b_i
$$

```r
## 周一到周日所需要的分配老师数
b <- c(3782, 3718, 2580, 2912, 4112, 7862, 7007)

## 老师每周需要有连续 2 天的休息
A <- matrix(1, nrow = 7, ncol = 7)
for(i in 1:7){
  A[i, i %% 7 + 1] <- 0; A[i, (i + 1) %% 7 + 1] <- 0;
}
m <- MIPModel() |>
  add_variable(x[i], i = 1:7, type = "integer", lb = 0) |>
  set_objective(sum_over(x[i], i = 1:7), "min") |>
  add_constraint(sum_over(A[i,j] * x[i], j = 1:7) >= b[i], i = 1:7) |>
  solve_model(with_ROI(solver = "glpk")) |>
  get_solution(x[i])

> m
  variable i value
1        x 1   757
2        x 2   744
3        x 3   516
4        x 4   583
5        x 5   823
6        x 6  1573
7        x 7  1402
```

排班的班型和结果如下：

| 周1| 周2| 周3| 周4| 周5| 周6| 周7| 数量|
|--:|--:|--:|--:|--:|--:|--:|-------:|
|  1|  0|  0|  1|  1|  1|  1|     757|
|  1|  1|  0|  0|  1|  1|  1|     744|
|  1|  1|  1|  0|  0|  1|  1|     516|
|  1|  1|  1|  1|  0|  0|  1|     583|
|  1|  1|  1|  1|  1|  0|  0|     823|
|  0|  1|  1|  1|  1|  1|  0|    1573|
|  0|  0|  1|  1|  1|  1|  1|    1402|

看一下差异有多大

```r
> m$value * A |> colSums()
[1] 3785 3720 2580 2915 4115 7865 7010
> b
[1] 3782 3718 2580 2912 4112 7862 7007
```

# 3. 装箱问题

有一堆物品长度分别为 $w_i$，若干长度为 $C$ 的箱子（$w_i \le C$）。问：最少需要几个箱子才能把所有物品全部装进箱子？

最坏的情况是一个箱子装一个物品，最好的情况是物品恰好可以完美的放入在箱子内，那么箱子数为$\sum w_i/C$，所以说取值应该在这两个值之间。抽象一下这个问题，我们希望最小化箱子数量，设

1. $y_i = 1$，表示第 $i$ 个箱子被使用
2. $x_{ij} = 1$，表示 第 $j$ 个物品被放入了第 $i$ 个箱子中

那么优化的目标是：

$$
\min z = \sum_{i=1}^{n} y_i
$$
约束条件是：


$$
\begin{aligned}
&\sum_{j=1}^n w_i x_{i j} \leq C y_i, \quad i=1,2, \ldots, n\\
&\sum_{i=1}^n x_{i j}=1, \quad j=1,2, \ldots, n\\
&y_i \in\{0,1\}, \quad i=1,2, \ldots, n\\
&x_{i j} \in\{0,1\}, \quad i, j=1,2, \ldots, n
\end{aligned}
$$
用一个例子来说明：

```r
max_bins <- 10 # 箱子的最大个数
bin_size <- 3 # 每个箱子的size
n <- 10 # 有多少个物品
weights <- runif(n, max = bin_size) # 随机生成物品的大小，不大于 bin_size
## 按照上面的模型设置参数
MIPModel() |>
  add_variable(y[i], i = 1:max_bins, type = "binary") |>
  add_variable(x[i, j], i = 1:max_bins, j = 1:n, type = "binary") |>
  set_objective(sum_over(y[i], i = 1:max_bins), "min") |>
  add_constraint(sum_over(weights[j] * x[i, j], j = 1:n) <= y[i] * bin_size, i = 1:max_bins) |>
  add_constraint(sum_over(x[i, j], i = 1:max_bins) == 1, j = 1:n) |>
  solve_model(with_ROI(solver = "glpk", verbose = TRUE)) |>
  get_solution(x[i, j]) |>
  filter(value > 0) |>
  arrange(i)
```

# 4. 指派问题

指派的标准问题是，有 $n$ 个人和 $n$ 件事，已知第 $i$ 个人做第 $j$ 个事的费用为 $C_{ij}$，要求确定人和事之间的关系，使得这 $n$ 件事情的总费用最小。

数学模型可以写成：

$$
\min z=\sum\limits_{i=1}^n\sum\limits_{j=1}^n c_{ij}x_{ij}
$$

$$
\mathrm{s.t}
\begin{cases}
\sum\limits_{i=1}^n x_{ij}=1,\quad i=1,2,\cdots,n  \\ 
\sum\limits_{j=1}^n x_{ij}=1,\quad j=1,2,\cdots,n  \\ 
x_{ij} \in \{0,1\}, \quad i,j=1,2,\cdots,n  \end{cases}
$$

模拟一个示例做演示：

```r
set.seed(1)
cost <- rnorm(16, 4, 1) |> round(2) |> matrix(4, 4)
m <- MIPModel() |>
  add_variable(x[i,j], i = 1:4, j = 1:4, type = "binary") |>
  set_objective(sum_over(cost[i,j] * x[i,j], i = 1:4, j = 1:4), "min") |>
  add_constraint(sum_over(x[i, j], i = 1:4) == 1, j = 1:4) |>
  add_constraint(sum_over(x[i, j], j = 1:4) == 1, i = 1:4) |>
  solve_model(with_ROI(solver = "glpk")) |>
  get_solution(x[i,j])

> cost
     [,1] [,2] [,3] [,4]
[1,] 3.37 4.33 4.58 3.38
[2,] 4.18 3.18 3.69 1.79
[3,] 3.16 4.49 5.51 5.12
[4,] 5.60 4.74 4.39 3.96
> z <- matrix(0, 4, 4)
> z[cbind(m$i, m$j)] <- m$value
> z # 人和事的分配关系
     [,1] [,2] [,3] [,4]
[1,]    0    1    0    0
[2,]    0    0    0    1
[3,]    1    0    0    0
[4,]    0    0    1    0
```


# 5. 最优传输问题

最优传输比指派问题稍复杂一点点：假如有 6 个生产点和 8 个销售点，他们之间的存在距离成本矩阵。且约束条件有：

-   A1-A6 的产量是：60,55,51,43,41,52
-   B1-B8 的销量是：35,37,22,32,41,32,43,38

```r
costs<-matrix(c(6,4,5,7,2,5,2,9,2,6,3,5,6,5,1,7,9,
2,7,3,9,3,5,2,4,8,7,9,7,8,2,5,4,2,2,1,5,8,3,7,6,4,
9,2,3,1,5,3), nrow = 6) # 运费矩阵

n_row <- nrow(costs)
n_col <- ncol(costs)
row.rhs <- c(60,55,51,43,41,52) # 产量约束向量
col.rhs <- c(35,37,22,32,41,32,43,38) # 销量约束向量
```

构建传输模型，假设生产点的产量为 $P_i$, 销售点的预期销量为 $S_j$，生产点到销售点运费矩阵为 $C_{ij}$，不考虑对于每次传输的限制，销售点的需求必须满足：

$$
\begin{gathered}
min \sum_i \sum_j C_{ij} X_{ij} \\
s.t. \\
\sum_{i}\sum_j X_{ij} \le P_i;i = 1,2...,M \\
\sum_{i}\sum_j X_{ij} = S_j;j = 1,2,...,N \\
\end{gathered}
$$ 

构建混合整数规划模型：

```r
tm <- MIPModel() |>
  # 添加长度为 i * j 变量组  
  add_variable(x[i,j], i = 1:n_row, j = 1:n_col, type = "integer", lb = 0) |>
  set_objective(sum_over(costs[i,j] * x[i,j], i = 1:n_row, j = 1:n_col), "min") |>
  add_constraint(sum_over(x[i,j], j = 1:n_col) <= row.rhs[i], i = 1:n_row) |>
  add_constraint(sum_over(x[i,j], i = 1:n_row) == col.rhs[j], j = 1:n_col) |>
  solve_model(with_ROI(solver = "glpk")) |>
  get_solution(x[i,j])
m <- matrix(0, n_row, n_col)
index <- cbind(tm$i, tm$j)
m[index] <- tm$value

> m
     [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
[1,]    0   19    0    0   41    0    0    0
[2,]    1    0    0   32    0    0    0    0
[3,]    0   11    0    0    0    0   40    0
[4,]    0    0    0    0    0    5    0   38
[5,]   34    7    0    0    0    0    0    0
[6,]    0    0   22    0    0   27    3    0
```


# 6. 分货优化

最优传输问题是一个相对简化的模型，我们将这个问题更一般化。假设有 M 个大仓，N 个门店。第 $i$ 个大仓的分货限额为 $C_i=1,2,3,...,M$，需要将 $C_i$ 分配给各个门店，第 $i$ 个门店分得 $X_{ij}, i=1,2,3,...,M,j=1,2,...,N$，使得

$$
min(OBJ)
$$

约束条件为

$$
\sum_{j}^{N} X_{i, j} \leq C_{i}, i=1,2, \ldots, M
$$

这里的 OBJ 是某种可以衡量分货策略好坏的函数，分货策略越好，该函数值越小。举个简单的例子，OBJ 可以是该分货策略的预期缺货量，那么显然，缺货量越小，说明分货策略越好。当然，在实际生产决策中，衡量分货策略好坏往往是从多个维度来考量，诸如现货率、补货次数、补货周期等核心优化指标均要纳入考虑。

## 6.1. 传输优先级

构建最简化的模型，仅仅考虑一个约束条件，传输的优先级（该情况即为最优传输模型）。$j$ 个门店的库存为 0，完全达成门店要求。 此时抽象的公式为：

$$
min \sum_{i}\sum_{j} P_{ij} X_{ij}
$$ 设门店的目标要求为 $V_j$，约束条件为：

$$
\begin{gathered}
\sum_{j}^{M} X_{i, j} \leq C_{i}, i=1,2, \ldots, M \\
\sum_{i}^{N} X_{i, j} = V_{j}, j=1,2, \ldots, N
\end{gathered}
$$

构建模型，及结果是：

```{r}
## 大仓总量
wh_capacity <- c(100, 300)
## 门店目标库存水平
store_target <- c(100, 80, 120)
## 大仓优先级
priority <- matrix(c(0.9, 0.1, 0.9, 0.1, 0.05, 0.95), 2, 3)
## 构建模型
tm1 <- MIPModel() |>
  # 添加长度为 i * j 变量组  
  add_variable(x[i,j], i = 1:2, j = 1:3, type = "integer", lb = 0) |>
  ## 设置目标函数
  set_objective(sum_over(priority[i,j] * x[i,j], i = 1:2, j = 1:3), "min") |>
  ## 增加约束
  add_constraint(sum_over(x[i,j], j = 1:3) <= wh_capacity[i], i = 1:2) |>
  add_constraint(sum_over(x[i,j], i = 1:2) == store_target[j], j = 1:3) |>
  solve_model(with_ROI(solver = "glpk")) |>
  get_solution(x[i,j])

> tm1
  variable i j value
1        x 1 1     0
4        x 2 1   100
2        x 1 2     0
5        x 2 2    80
3        x 1 3   100
6        x 2 3    20
```

## 6.2. 考虑实际库存

上面的抽象模型显然太过于理想化，事实上门店显然是有库存的。

假设目标库存车辆数是 $Tar_j \ge 0$，当前库存数车辆数为 $Inv_j \ge 0$，$X_{ij} \ge 0$ 为从 $i$ 位置到 $j$ 站点的调度量，$S_j \ge 0$ 为站点 $j$ 取得调度量之后的未满足量。那么则有这样的限制条件：

$$
Inv_j + \sum_j^N X_{ij} + S_j \ge Tar_j
$$

显然我们希望`未满足量`最小：

$$
min \sum_j^N S_j
$$ 也就是说我们需要的目标是两个同时优化：

$$
\min (\sum_i^M \sum_j^N P_{ij} X_{ij} + \sum_{j} S_{j})
$$

约束条件是：

$$
\begin{gathered}
\sum_{j} X_{ij} \leq C_{i}, i=1,2, \ldots, M \\
I n v_{j}+\sum_{i} X_{ij}+S_{j} \geq Tar_{j}, j=1,2, \ldots, N
\end{gathered}
$$

这个混合整数规划问题变成了更复杂的样子：

```r
## 门店库存水平
store_inv <- c(50, 20, 30)
store_mip <- MIPModel() |>
  add_variable(x[i,j], i = 1:2, j = 1:3, type = "integer", lb = 0) |>
  add_variable(b[j], j = 1:3, type = 'integer', lb = 0) |>
  ## 设置目标函数
  set_objective(sum_over(priority[i,j] * x[i,j], i = 1:2, j = 1:3) + sum_over(1000*b[j], j = 1:3), "min") |>
  ## 增加约束
  add_constraint(sum_over(x[i,j], j = 1:3) <= wh_capacity[i], i = 1:2) |>
  add_constraint(sum_over(x[i,j], i = 1:2) + store_inv[j] +  b[j] >= store_target[j], j = 1:3) |>
  solve_model(with_ROI(solver = "glpk")) |>
  get_solution(x[i,j])

> store_mip
  variable i j value
1        x 1 1     0
4        x 2 1    50
2        x 1 2     0
5        x 2 2    60
3        x 1 3    90
6        x 2 3     0
```

## 6.3. 最小分货单元

因为分货的车每次只能装载 6 件商品，因此我们还有一个条件：分货量必须为 6 的倍数。可以考虑引入一个辅助变量 $O_{ij}$，引入 mlc 之后约束条件增加

$$
\begin{gathered}
mlc \times O_{ij} = X_{ij}\
\end{gathered}
$$ 模型又发生了一些改变：

```r
## Minimum loading capacity
mlc <- 6
store_mip <- MIPModel() |>
  add_variable(x[i,j], i = 1:2, j = 1:3, type = "integer", lb = 0) |>
  add_variable(b[j], j = 1:3, type = 'integer', lb = 0) |>
  add_variable(o[i,j], i = 1:2, j = 1:3, type = 'integer', lb = 0) |>
  ## 设置目标函数
  set_objective(sum_over(priority[i,j] * x[i,j], i = 1:2, j = 1:3) + sum_over(b[j], j = 1:3), "min") |>
  ## 增加约束
  add_constraint(sum_over(x[i,j], j = 1:3) <= wh_capacity[i], i = 1:2) |>
  add_constraint(sum_over(x[i,j], i = 1:2) + store_inv[j] +  b[j] >= store_target[j], j = 1:3) |>
  add_constraint(mlc * o[i,j] == x[i,j], i = 1:2, j = 1:3) |>
  solve_model(with_ROI(solver = "glpk")) |>
  get_solution(x[i,j])

> store_mip
  variable i j value
1        x 1 1     0
4        x 2 1    54
2        x 1 2     0
5        x 2 2    60
3        x 1 3    90
6        x 2 3     0
```

当然，以上示例均为演示而构造，实际生产过程会远比这些示例复杂，有些明确需要使用其他方法来进行拟合或逼近。