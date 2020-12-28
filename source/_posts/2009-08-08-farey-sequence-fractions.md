---
layout: post
title: 从小数到分数
tags: 
status: publish
type: post
published: true
---
<p>很多时候，在社会调研中会出现一些小数（或百分数），而这些数字背后隐藏的信息也常常被统计人关注。比如 <a href="http://www.cos.name/" target="_blank">COS 主站</a>上的这篇文章--<a href="http://cos.name/2009/04/from-proportion-to-conclusion/" target="_blank">《从调查报告中的比例数字说统计人如何甄别统计假象》</a>，yihui 生动地为我们展示了一种考量问题的思路。</p>
<p>正如文章中所说的，如果我们对数字足够敏感的话，很容易判断出 0.6667 的分数是 2/3 ，0.625 的分数是 5/8，0.14286 的分数是 1/7。但我们的经验毕竟有限，不可能穷尽所有的数字，通过一个算法来确定分数是十分有必要的。</p>
<p>法里序列（<a href="http://en.wikipedia.org/wiki/Farey_sequence" target="_blank">farey sequence</a>）也是考虑这类问题的一个角度。如果给定法里序列的 n 足够大，那么我们必定能够将逼近出一个和小数相等的分数<em>F</em><sub>i</sub>[j]。</p>
<p>法里序列 <em>F</em><sub>i</sub> （i=1 到 n）：</p>
<dl>
	<dd><em>F</em><sub>1</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
	<dd><em>F</em><sub>2</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>2</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
	<dd><em>F</em><sub>3</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>3</sub>, <sup>1</sup>&frasl;<sub>2</sub>, <sup>2</sup>&frasl;<sub>3</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
	<dd><em>F</em><sub>4</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>4</sub>, <sup>1</sup>&frasl;<sub>3</sub>, <sup>1</sup>&frasl;<sub>2</sub>, <sup>2</sup>&frasl;<sub>3</sub>, <sup>3</sup>&frasl;<sub>4</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
	<dd><em>F</em><sub>5</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>5</sub>, <sup>1</sup>&frasl;<sub>4</sub>, <sup>1</sup>&frasl;<sub>3</sub>, <sup>2</sup>&frasl;<sub>5</sub>, <sup>1</sup>&frasl;<sub>2</sub>, <sup>3</sup>&frasl;<sub>5</sub>, <sup>2</sup>&frasl;<sub>3</sub>, <sup>3</sup>&frasl;<sub>4</sub>, <sup>4</sup>&frasl;<sub>5</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
	<dd><em>F</em><sub>6</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>6</sub>, <sup>1</sup>&frasl;<sub>5</sub>, <sup>1</sup>&frasl;<sub>4</sub>, <sup>1</sup>&frasl;<sub>3</sub>, <sup>2</sup>&frasl;<sub>5</sub>, <sup>1</sup>&frasl;<sub>2</sub>, <sup>3</sup>&frasl;<sub>5</sub>, <sup>2</sup>&frasl;<sub>3</sub>, <sup>3</sup>&frasl;<sub>4</sub>, <sup>4</sup>&frasl;<sub>5</sub>, <sup>5</sup>&frasl;<sub>6</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
	<dd><em>F</em><sub>7</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>7</sub>, <sup>1</sup>&frasl;<sub>6</sub>, <sup>1</sup>&frasl;<sub>5</sub>, <sup>1</sup>&frasl;<sub>4</sub>, <sup>2</sup>&frasl;<sub>7</sub>, <sup>1</sup>&frasl;<sub>3</sub>, <sup>2</sup>&frasl;<sub>5</sub>, <sup>3</sup>&frasl;<sub>7</sub>, <sup>1</sup>&frasl;<sub>2</sub>, <sup>4</sup>&frasl;<sub>7</sub>, <sup>3</sup>&frasl;<sub>5</sub>, <sup>2</sup>&frasl;<sub>3</sub>, <sup>5</sup>&frasl;<sub>7</sub>, <sup>3</sup>&frasl;<sub>4</sub>, <sup>4</sup>&frasl;<sub>5</sub>, <sup>5</sup>&frasl;<sub>6</sub>, <sup>6</sup>&frasl;<sub>7</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
	<dd><em>F</em><sub>8</sub> = {<sup>0</sup>&frasl;<sub>1</sub>, <sup>1</sup>&frasl;<sub>8</sub>, <sup>1</sup>&frasl;<sub>7</sub>, <sup>1</sup>&frasl;<sub>6</sub>, <sup>1</sup>&frasl;<sub>5</sub>, <sup>1</sup>&frasl;<sub>4</sub>, <sup>2</sup>&frasl;<sub>7</sub>, <sup>1</sup>&frasl;<sub>3</sub>, <sup>3</sup>&frasl;<sub>8</sub>, <sup>2</sup>&frasl;<sub>5</sub>, <sup>3</sup>&frasl;<sub>7</sub>, <sup>1</sup>&frasl;<sub>2</sub>, <sup>4</sup>&frasl;<sub>7</sub>, <sup>3</sup>&frasl;<sub>5</sub>, <sup>5</sup>&frasl;<sub>8</sub>, <sup>2</sup>&frasl;<sub>3</sub>, <sup>5</sup>&frasl;<sub>7</sub>, <sup>3</sup>&frasl;<sub>4</sub>, <sup>4</sup>&frasl;<sub>5</sub>, <sup>5</sup>&frasl;<sub>6</sub>, <sup>6</sup>&frasl;<sub>7</sub>, <sup>7</sup>&frasl;<sub>8</sub>, <sup>1</sup>&frasl;<sub>1</sub>}</dd>
</dl>
<p>但这个过程会比较麻烦，<em>F</em><sub>1000</sub> 已经达到300927 个数字。幸好 R 中的 MASS 包提供了 fractions 函数。这个函数使用有理近似的方式，将小数转化为分数（连分数）形式。比如<a href="http://cos.name/2009/04/from-proportion-to-conclusion/" target="_blank">《从调查报告中的比例数字说统计人如何甄别统计假象》</a>中提到的 29.1667% 这个数值：</p>
<p>&gt; fractions(0.291667) <br />
	[1] 7/24</p>
<p>不过，既然是近似算法，这个函数对小数的精确度要求还是蛮高的，而且最好不要用无理数去逗人家。</p>
<p><span dir="ltr">&gt; fractions(pi) <br />
	[1] 4272943/1360120</span></p>
