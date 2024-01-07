---
layout: post
title: NBA联盟50位顶级球员的指标表现
tags: 
- heatmap
- 篮球
status: publish
type: post
published: true
---
有点标题党的嫌疑，实际是介绍如何使用 R 绘制 heatmap 的文章。

今天无意间在<a href="http://flowingdata.com/about/" target="_blank">Flowingdata</a>看到一篇关于如何使用 R 来做 heatmap 的文章（请移步到<a href="http://flowingdata.com/2010/01/21/how-to-make-a-heatmap-a-quick-and-easy-solution/" target="_blank">这里</a>）。虽然 heatmap 只是 R 中一个很普通的图形函数，但这个例子使用了2008-2009赛季 NBA 50个顶级球员数据做了一个极佳的演示，效果非常不错。对 R 大致了解的童鞋可以直接在 R console 上敲

<strong>？heatmap</strong>

直接查看帮助即可。

没有接触过 R 的童鞋继续围观，下面会仔细介绍如何使用 R 实现 NBA 50位顶级球员指标表现热图：

关于 heatmap，中文一般翻译为“热图”，其统计意义<a href="http://en.wikipedia.org/wiki/Heatmap" target="_blank">wiki</a>上解释的很清楚：
<blockquote>A <strong>heat map</strong> is a graphical representation of data where the values taken by a <a title="Variable (mathematics)" href="http://en.wikipedia.org/wiki/Variable_%28mathematics%29">variable</a> in a two-dimensional map are represented as colors.Heat maps originated in 2D displays of the values in a data matrix. Larger values were represented by small dark gray or black squares (pixels) and smaller values by lighter squares.</blockquote>
下面这个图即是<a href="http://flowingdata.com/about/" target="_blank">Flowingdata</a>用一些 <a href="http://www.r-project.org" target="_blank">R</a> 函数对2008-2009 赛季NBA 50名顶级球员指标做的一个热图（点击参看<a href="http://bjt.cos.name/wp-content/uploads/2010/01/heatmap1.png" target="_blank">大图</a>）：
<p style="text-align: center;"><a href="http://bjt.cos.name/wp-content/uploads/2010/01/heatmap1.png"></a></p>
<p style="text-align: center;"><a href="http://bjt.cos.name/wp-content/uploads/2010/01/heatmap1.png"><img class="aligncenter size-medium wp-image-10542" title="heatmap1" src="http://bjt.cos.name/wp-content/uploads/2010/01/heatmap1-300x289.png" alt="" width="300" height="289" /></a></p>
<strong>先解释一下数据：</strong>

这里共列举了50位球员，估计爱好篮球的童鞋对上图右边的每个名字都会耳熟能详。这些球员每个人会有19个指标，包括打了几场球（G)、上场几分钟（MIN)、得分（PTS)……这样就行成了一个50行×19列的矩阵。但问题是，数据有些多，需要使用一种比较好的办法来展示，So it comes, heatmap!

简单的说明：

比如从上面的热图上观察得分前3名（Wade、James、Bryant）PTS、FGM、FGA比较高，但Bryant的FTM、FTA和前两者就差一些；Wade在这三人中STL是佼佼者；而James的DRB和TRB又比其他两人好一些……

姚明的3PP（3 Points Percentage）这条数据很有意思，非常出色！仔细查了一下这个数值，居然是100%。仔细回想一下，似乎那个赛季姚明好像投过一个3分，并且中了，然后再也没有3p。这样本可真够小的！

<strong>最后是如何做这个热图（做了些许修改）：</strong>

<span style="color: #993366;">Step 0. Download R</span>

R 官网：<a href="http://www.r-project.org">http://www.r-project.org</a>，它是免费的。官网上面提供了Windows,Mac,Linux版本（或源代码）的R程序。

<span style="color: #993366;">Step 1. Load the data</span>

R 可以支持网络路径，使用读取csv文件的函数read.csv。

读取数据就这么简单：
<pre lang="rsplus">read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep=",")</pre>
<span style="color: #993366;">Step 2. Sort data</span>

按照球员得分，将球员从小到大排序：

<pre lang="rsplus">nba <- nba[order(nba$PTS),]</pre>

<code>当然也可以选择MIN,BLK,STL之类指标</code>

<span style="color: #993366;">Step 3. Prepare data</span>

把行号换成行名（球员名称）：

<pre lang="rsplus">row.names(nba) <- nba$Name</pre>

<code>去掉第一列行号：</code>

<pre lang="rsplus">nba <- nba[,2:20] # or nba <- nba[,-1]</pre>

<span style="color: #993366;">Step 4. Prepare data, again</span>

把 data frame 转化为我们需要的矩阵格式：

<pre lang="rsplus">nba_matrix <- data.matrix(nba)</pre>

<span style="color: #993366;">Step 5. Make a heatmap</span>

R 的默认还会在图的左边和上边绘制 dendrogram，使用Rowv=NA, Colv=NA去掉

<pre lang="rsplus">heatmap(nba_matrix, Rowv=NA, Colv=NA, col=cm.colors(256), revC=FALSE, scale='column')</pre>

<code>这样就得到了上面的那张热图。</code>

<span style="color: #993366;">Step 6. Color selection</span>

或者想把热图中的颜色换一下：

<pre lang="rsplus">heatmap(nba_matrix, Rowv=NA, Colv=NA, col=heat.colors(256), revC=FALSE, scale="column", margins=c(5,10))</pre>

<code><strong>延伸阅读：</strong></code>

<code>来自于kerimcan和<a href="http://periscopic.com/">krees</a>这些人的讨论：</code>

<code><strong><a rel="nofollow" href="http://sekhon.polisci.berkeley.edu/stats/html/heatmap.html">http://sekhon.polisci.berkeley.edu/stats/html/heatmap.html</a>
<a rel="nofollow" href="http://enotacoes.wordpress.com/2007/11/16/easy-guide-to-drawing-heat-maps-to-pdf-with-r-with-color-key/">http://enotacoes.wordpress.com/2007/11/16/easy-guide-to-drawing-heat-maps-to-pdf-with-r-with-color-key/</a></strong></code>

<strong>补充：</strong>

早上起来发现 David Smith 同样更新了<a href="http://blog.revolution-computing.com/2010/01/how-to-make-a-heat-map-in-r.html" target="_blank">博客</a>。唉，这厮嗅觉也忒灵敏！哈哈
