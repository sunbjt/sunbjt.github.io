---
layout: post
title: 法航被流星击中的概率
category: 算法
status: publish
type: post
published: true
---
以前由于职业的原因，经常全国各地的乱飞。虽说飞机的出事概率仅仅相当于陆上交通工具的百分之一，但每次上飞机前，总会怯怯的问自己："这次上去能不能好好的下来？"上去的话，一般都是塞上耳机，打开笔记本--看 R。说实话，我还是更喜欢心灵的飞翔，而不是坐着飞机去感受加速度。

一般商用喷气式飞机的稳定性很高，即使有突然事件造成损害，大部分飞机都能保证安全或部分安全地着陆。引发安全问题的事件可能是：

- skin or door failure leading to cabin pressure explosion
- gross upset leading to airspeeds and/or G loadings far in excess of design limits
- attack by military weapons * bird strike * flight through volcanic ash
- engine explosion
- collision with ground structures during takeoff
  
但如果被流星击中呢？流星的速度可以达到 25,000 km/hr（约 7000m/s ），还是很可怕的。

David Smith 在 <a href="http://blog.revolution-computing.com/2009/06/how-much-of-a-threat-are-meteors-to-aviation.html" target="_blank">How much of a threat are meteors to aviation?</a> 这篇博客里给出了，法航客机被流星击中的概率，计算方法比较科学：

1. 每小时有 125 颗流星"光临"地球，且都是超音速飞行的；
2. 平均飞机的面积占地球总面积的5.7e-13；
3. 法航 447 客机预计飞行的时间为 11 小时。

这种小概率事件我们可以使用 Poisson 分布去拟合，那么飞机被击中的概率就是

```
1 - ppois(0,5.7e-13*125*11) 
[1] 7.8375e-10
```

飞机被流星击中的概率为7.8375e-10，即<span class="post-footers">第一位7前面有10个零。观众可能没有直观印象，举个例子：双色球的中一等奖的概率是 5.642994e-08</span>，飞机被流星击中的概率是它的百分之一，<span class="post-footers">相差两个数量级。</span>

<span class="post-footers">David Smith 而后又给了一个今后 20 年，所有飞机至少有一架被击中的概率（他给的数据没看明白，直接引用 <a href="http://blogs.discovermagazine.com/cosmicvariance/author/jconway/">John</a> 给的数据）：</span>

```r
1 - ppois(0,720e6*5.7e-13*125)
[1] 0.05000637
```

很可怕吧！今后二十年，至少有一架被陨石击中的概率达到了 5% ！已经不是小概率事件了！
