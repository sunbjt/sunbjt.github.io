---
layout: post
title: 商业数据库对R语言的支持
category: 旧闻
status: publish
type: post
published: true

---
一直以来，我们在提到使用R进行数据分析、数据挖掘都会使用RODBC、RJDBC、DBI等相关的包来调用数据库，比如我前面罗嗦的一片文章[数据挖掘之R与SQL](http://bjt.name/2011/08/r-and-sql-datamining/)，但实际基本上各大数据库厂商已有相应的R语言企业级应用产品，这些厂商包括Oracle、IBM、Teradata、Sybase、SAP。


# Oracle R Enterprise #

Oracle R Enterprise是针对于大数据市场下，用于处理日益丰富的数据。这款产品有以下优势：

## 企业级的R应用

- 允许DBA将R语言模型产品化
-	可以将R模型整合到BI仪表盘（BIEE）
- 统计学家可以直接使用数据库，而不需去了解具体SQL
- 减少Oracle数据库外的数据管理成本

## 减少高昂SA$的使用费用

- 可完全替代SA$ base，节省SA$的使用年费
- 分析人员可以直接面对数据库进行个性化分析，而不需要数据导出
- 超过100内置的统计函数可以同Base SA$兼容

## 大数据分析的in-database支持

- 高性能的代数运算(在 R 中整合[ntel's Math Kernel Library](http://software.intel.com/en-us/articles/intel-mkl/)
- R语句的执行的使用并行化运算方式（包括扩展包）
- 高度整合了R语言快速开发、数据库并行计算的优势

众所周知，R 语言将数据置于内存，数据处理能力有限，Oracle R Enterprise 将此瓶颈完全打开，并将性能提升到更高级别。

# [IBM Netezza®](http://www-01.ibm.com/common/ssi/rep_ca/2/897/ENUS212-042/ENUS212-042.PDF)

Netezza 并不隶属于IBM原有产品线，而是针对于“一体机”市场，于2010年17亿美元的价格收购获得，
用以扩张其用于销售、市场营销和产品开发的商务分析产品。Netezza对R语言的支持，主要通过Revolution合作，
通过调用<a href="http://www.revolutionanalytics.com/products/revolution-enterprise-for-ibm-netezza.php"><strong>R Enterprise from Revolution® Analytics</strong></a>平台来实现。Netezza的特点可以总结为：可扩展的、高性能的、大规模内置并行分析平台。

注：除了R语言外，Netezza还支持SAS、PASW等分析软件

# IBM® InfoSphere® BigInsights

IBM BigInsights 同样也整合了R语言资源，提供了Map-Reduce架构的R语言并行化计算环境，包括了大数据集的文本挖掘和机器学习算法。
BigInsights可以将构建的R语言模型发布在Hadoop平台上（同IBM Netezza一样，通过调用<a href="http://www.revolutionanalytics.com/products/revolution-enterprise-for-ibm-netezza.php"><strong>R Enterprise from Revolution® Analytics</strong></a>），极大的满足企业级数据需求。

注：为 IBM 提供R语言商业化应用的公司是 Revolution，关于这家公司可以参考<a href="http://bjt.cos.name/2009/10/spss-norman-nie-r/" target="_blank">这里</a>。

# SAP HANA #

借助SAP BusinessObjects Predictive Analysis平台，分析师们既可以使用内置的预测性算法来构建模型，也可以整合并使用流行的开源数据统计分析语言——R语言。并且，依托SAP HAHA平台可以提供in-database分析。


# Teradata #


Teradata提供了免费的 <a href="http://developer.teradata.com/applications/articles/in-database-analytics-with-teradata-r">teradataR</a> 包，用于在R环境下连接Teradata数据库、创建数据、条用in-database分析函数。

- 避免了从 Tetadata 到 R 之间的数据移动，有效提高了数据运算性能
- 针对于大数据的分析任务，使用 Teradata 的强大并行计算的能力
- 允许在R控制台操作
- 将常用的执行任务嵌入到数据库中执行
- R 和 TetadataR 都是免费的

# Sybase RAP #

Sybase RAP主要是针对于金融市场的实时分析，其中RAPStore组件提供了内置分析函数，包括时间序列分析函数、OLAP函数、R语言整合函数以及用户自定义函数，适用于大数据环境。

同时，还可以在R语言环境下通过RJDBC访问Sybase RAP，进行数据预处理，避免在R中数据清洗占用大量内存。

全文完，请期待 R + Hadoop
