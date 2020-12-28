---
layout: post
title: 那只奔跑的马
category: 不务正业的 R
tags: 
- animation
status: publish
type: post
published: true
---

话说到，去年在上海财经大学讲 `R与统计图形`时，提到了Edward Muybridge (1830-1904)的赛马动画。在准备材料的时候，我也比较八卦的翻了翻关于赛马动画的历史，结果发现：这幅图型不但是统计动画的鼻祖，同样是现代电影的先驱。


从 Edward Muybride 拍摄赛马动画后，美国的电影产业开始高速的发展，从此加利福尼亚州顺理成章地成为人类电影发展上的重镇，加州的好莱坞产生了大量的电影技术的创新，好莱坞电影也成为美国文化的主要代表之一。

电影、动画的原理，我就不八卦了，一般理科生大概都有些了解。关于这个赛马动画的产生，很有意思：

- 1872年，前美国加州州长 [Leland Stanford](http://en.wikipedia.org/wiki/Leland_Stanford)（也是斯坦福大学的创立者）是一个狂热的赛马爱好者，为了证明马在奔跑的时候会有一刻所有的蹄子同时悬空，和人打赌，赌金非常高，达到了$25,000。
- 而在那个年代很难用肉眼确定马在奔跑时的状态（可以想象一下为什么`马踏飞燕`是那个样子？）。于是 Stanford 找到并雇佣 Muybridge 这个摄影家帮他解决这个问题。
- Muybridge 本来在 1872 年的时候已经接受了 Stanford 的邀请，为 Stanford 提供那旷世赌博的摄像证据。但这家伙怀疑自己老婆有个情人Larkyns，并且冲动的枪杀了 Larkyns。
- 直到1877年，Muybridge 被判无罪（Stanford 提供的辩护资助），才又继续他的奔马实验，于是有了这个：

<img src="https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/20201225154627.png"/>

后来 Muybridge 根据这些赛马的图片，创作了人类历史上的第一个小电影。下面这个动画就是用最上面的几张图合并而成的（因为偷懒用[ImageMagick](http://www.imagemagick.technocozy.com/)自动切割，所以这个小电影有点晃～～）

<img src="https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/sbjyi.gif"/>

当然，还有一个效果更好的：

![](http://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Muybridge_race_horse_animated.gif/220px-Muybridge_race_horse_animated.gif)

哈，这便是统计动画的原理，也是现代电影的最初版本～～
