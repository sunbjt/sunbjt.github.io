---
layout: post
title: 火箭对热火比赛(20100116)中，火箭球员的助攻网络关系
tags: 
- networks
- basketball
- sna
status: publish
type: post
published: true
---
本场比赛前7分钟火箭发挥还不错，最高取得了10分的领先（11-21），但受上一场力拼森林狼三个加时影响，火箭诸将体能逐渐不支，慢慢失去优势。虽然巴丁格整场替补发挥出色，无奈，随着阿里扎上篮不进，比分定格在了115-106。

相比热火发烫的53.6%投篮命中率，火箭发挥比较正常，48.7%。火箭唯一问题出现在了失误方面，8-15，如果火箭失误控制的好，也许结果可能是另外一个结果。

比赛过程中，杨毅提到（大致意思）：由于没有超级球星，火箭必须比其他球队付出更多的努力才能获得胜利，也就是说其他球队会从容地为季后赛调整状态。火箭没有这个资本，为了常规赛的成绩，火箭进入疲劳期的时间要更早。要保证后面的球队成绩，要么莫雷尽最大能力交易，补充火箭；要么阿德尔曼通过更加合理细致的轮转，让每个核心球员得到充分休息。

问题来了：在不改变现有火箭球员结构的前提下，火箭的战术轮转体系中，球员的位置如何？

引子：

本场比赛火箭一共20个助攻，Brooks 和 Battier 分别助攻了最高的5个和4个。每次助攻都会涉及两位球员，那么本场比赛所有助攻结果综合在一起，即我们将助攻者和被助攻者之间的关系使用社会网络关系表现出来，会有一些有趣的现象：

![](/upload/pic/hou.png)

注释：

箭头方向是助攻方向，比如最下面的是 Shane Battier 给 Chuck Hayes 的助攻。

整理几个重要的关键点来评论一下：
<ol>
	<li>Brooks 无疑是比赛的发起者，我们发现他的助攻几乎包括了中锋、前锋位置的所有人（但不包括阿里扎，好像我记得有个镜头阿里扎要球，Brooks 没有理会）。</li>
	<li>Battier 既是助攻的受益者，又是助攻的发起者。个人一直比较喜欢的球员，篮球智商非常高。</li>
	<li>Budinger 这场比赛发挥出色，同队友给予其的帮助分不开。我们看到很多个球员对其都有直接帮助。</li>
	<li>Andersen 从助攻网络关系角度看，属于一个策应型中锋，而且是由里向外策应的那类。从比赛中观察，似乎球风有些偏软（本赛季我第一次看直播比赛 ^_^）</li>
	<li><span style="text-decoration: line-through;">Ariza 接受的助攻并不多，只有 Battier 的一次，其他都是给别人的助攻，和 Brooks 一样，属于个人能力比较强，擅于自己创造得分机会的球员。</span></li>
</ol>
假如：

我是教练组成员，我提议（单从本场比赛结果看）：
<ol>
	<li>Brooks、Battier、Ariza、Andersen 在火箭进攻体系中位置比较重要，轮转的时候尽量保证其中的两人或三人同时在场。</li>
	<li>Budinger 属于绝好的替补球员，但似乎不适合同 Battier、Hayes 同时在场。</li>
	<li><span style="text-decoration: line-through;">Lowry 在组织进攻方面能力欠佳，使用上须谨慎。</span></li>
</ol>
更新分割:

<hr />40场比赛助攻数据同时考虑，结果有些凌乱：

![](/upload/pic/hou40.png)

注：这个赛季火箭队有一些球员实际上并没有真正的进入轮转，比如"Tracy McGrady","Mike Harris","Jermaine Taylor","Pops Mensah-Bonsu","Brian Cook"。虽然有些球员（比如麦蒂）的确对球队的（被）助攻仍有帮助，但贡献非常有限。出于结果整洁性的考虑，上图已将这些球员因素剔除。

由于绘图算法使用的是 <a href="http://en.wikipedia.org/wiki/Force-based_algorithms" target="_blank">Force-based_algorithms</a>，也就是说这种算法做出的图，边（edges）会尽可能的少。解释为，对球员关系的影响就是：

<strong>同其他球员关系比较多的球员将绘制的比较靠近中心，而关系较少的球员会绘制在相对靠外的位置。</strong>

重新观察火箭队助攻网络图，发现：

1月16日对热火比赛中，Kyle Lowry 和 Trevor Ariza 发挥的确出了问题，尤其是 Lowry 这点上。

如果我们求解这个网络中各个球员的<a href="http://en.wikipedia.org/wiki/Page_rank" target="_blank"> page rank</a> 值，可以认为是每个球员同其他球员助攻的关键程度。
<table border="1">
<tbody>
<tr>
<th></th>
<th> Name</th>
<th> PageRank</th>
</tr>
<tr>
<td align="right">1</td>
<td>Aaron Brooks</td>
<td align="right">0.1690</td>
</tr>
<tr>
<td align="right">2</td>
<td>Trevor Ariza</td>
<td align="right">0.1496</td>
</tr>
<tr>
<td align="right">5</td>
<td>Luis Scola</td>
<td align="right">0.1334</td>
</tr>
<tr>
<td align="right">3</td>
<td>Kyle Lowry</td>
<td align="right">0.1268</td>
</tr>
<tr>
<td align="right">7</td>
<td>Shane Battier</td>
<td align="right">0.1099</td>
</tr>
<tr>
<td align="right">8</td>
<td>Carl Landry</td>
<td align="right">0.0966</td>
</tr>
<tr>
<td align="right">9</td>
<td>Chase Budinger</td>
<td align="right">0.0741</td>
</tr>
<tr>
<td align="right">4</td>
<td>Chuck Hayes</td>
<td align="right">0.0724</td>
</tr>
<tr>
<td align="right">6</td>
<td>David Andersen</td>
<td align="right">0.0681</td>
</tr>
</tbody>
</table>
Brooks、Ariza、Scola、Lowry、Battier 在助攻重要性角度上，占据球队的前五位。如何使用“田忌赛马”的策略制胜，则是教练组的问题。

让我欣慰的是 Hayes 的重要程度要比 Andersen 要好，单单从上一场比赛上看，Andersen 发挥的有些超常。

P.S. 维基百科上没有区别 “有向网络”和“无向网络”的 page rank ，上个表中的 page rank 值属于“无向网络”值，同上面的图略有区别（有向网络中，Lowry 的关键性仅比 Hayes 高，有些无奈）。
