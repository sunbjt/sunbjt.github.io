---
layout: post
title: K means 聚类
tags: 
- 算法
status: publish
type: post
published: false

---
Hierachial clustering 这类的方法最大的问题就在于对计算机内存的占用，当然对计算量也是一个严重的考验。n×m  的矩阵要进行 n×n 次计算，n^2 这个函数估计大家应该记得很清楚，汗~~~~

Partitioning clustering 好处就是将计算量由 x^2 变为 x ，即线性函数。而其典型代表就是kmeans。

图一是kmeans 算法中，增加变量（由1到100）的运算时间，图二是增加单维变量长度（x×1到x×100）。如果增加变量情形下，估计HC应该和PC 一致，但如果同时增加case的话，HC必然崩溃……
