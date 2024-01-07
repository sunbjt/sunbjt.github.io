---
layout: post
title: 利用 JDBC 驱动连接 R 和 Hive
category: R 技巧
status: publish
type: post
published: true
---

更新在最前面：

以下工作已经被团队小伙伴打成了 R 包，具体安装可以参考 lengyuyeke 的 github 项目，位置是这里 https://github.com/lengyuyeke/RHJDBC



# 一次更新

几年前写过一篇简单的[博客](http://bjt.name/2012/12/RHive-install)来讲如何利用 RHive 协同操作 Hive 和 R。这个包貌似很久未做维护，不是太好用，其实 RHive 包底层通过 JDBC 调用数据，所以通过 RJDBC 其实是更简单的方式。废话少说，直接贴代码：


```r
  library("DBI")
  library("rJava")
  library("RJDBC")
  for(l in list.files('/opt/org/apache/hive/1.1.1/hive-on-mr/lib/', full.names = TRUE)){ .jaddClassPath(l)}
  drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/opt/org/apache/hive/1.1.1/hive-on-mr/lib/hive-jdbc-1.1.1-standalone.jar")
  for(l in list.files('/opt/org/apache/hadoop/2.7.3/share/hadoop/common/', full.names = TRUE)){ .jaddClassPath(l)}
  conn <- dbConnect(drv, "jdbc:hive2://10.0.2.9:10000/default", "", "")
  
  show_databases <- dbGetQuery(conn, "describe dwd.dwd_user_dim_user_base")
  library(knitr)
  kable(show_databases) # table's meta data, for gollum wiki
  
  ## Get data from hive
  d <- dbGetQuery(conn, 'select * from ods.user limit 10')
```

<!-- more -->

配置是同事帮忙搞定的，团队在很顺畅的使用。如果有客官能解释一下细节的原理，善赞善哉~~

# 二次更新

```r
require("DBI")
require("rJava")
require("RJDBC")
# .jclassLoader()$setDebug(1L)
cp <- dir("/opt/drv/jdbclib",full.names = TRUE)
.jinit(classpath = cp) 

username <- ''
password <- ''

options( java.parameters = "-Xmx8g" )
drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/opt/drv/jdbclib/hive-jdbc-1.1.1.jar")

# make sure disconnect the connection after the query
conn <- dbConnect(drv, "jdbc:hive2://10.0.2.9:10000/default", username, password)
options(width = 160)
data <- dbGetQuery(conn, 'select * from ods_talk.user limit 10')
```

`/opt/drv/jdbclib`目录下的文件有：

```
1. hadoop-common-2.7.3.jar       
2. hive-jdbc-1.1.1-standalone.jar
3. hive-jdbc-1.1.1.jar           
4. hive-service-1.1.1.jar        
5. httpclient-4.2.5.jar          
6. httpcore-4.2.5.jar            
7. libthrift-0.9.2.jar 
```