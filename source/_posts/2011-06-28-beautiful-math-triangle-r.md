---
layout: post
title: "一个美丽的三角形"
tags: 
- "算法"
status: publish
type: post
published: false
---
yanlinlin 站长放出个问题，按照<a href="http://blog.sciencenet.cn/home.php?mod=space&amp;uid=576779&amp;do=blog&amp;id=456080">《魔方与数学》</a>一文的后记上记录的：


>请将1、11、111、1111、……的平方写下来，从最小的开始，每个占一行，并且全部居中书写，图形的样子？


问题不难，不外乎就是将这些数字平方，在按照要求放置。但，存在一个小问题，计算机一个单元存储数据的数据长度不是无限制的，而且精度也有所限制，所以当11111111平方的时候，R给出的数据已经是约数了。帖子讨论详见（<a href="http://cos.name/cn/topic/104640" target="_blank">这里</a>）

还好，这些数据的平方比较简单，可以通过模拟平方的运算过程来得到精确的结果，代码如下：

![](/upload/pic/code.jpg)

生成的图形有些像<a href="http://zh.wikipedia.org/wiki/%E6%9D%A8%E8%BE%89%E4%B8%89%E8%A7%92%E5%BD%A2" target="_blank">杨辉三角</a>，也是非常漂亮：

![](/upload/pic/111.jpg)


但我想应该还有更好的实现方式，期待跟帖出现。
