---
layout: post
title: RHive的安装和用法
status: publish
type: post
published: true
category: R 技巧

---

RHive 是一种通过HIVE高性能查询来扩展R计算能力的包。它可以在R环境中非常容易的调用HQL，也允许在Hive中使用R的对象和函数。理论上数据处理量可以无限扩展的Hive平台，搭配上数据挖掘的利器R环境，堪称是一个完美的大数据分析挖掘的工作环境。

<!-- more -->

# 1. 环境配置

`(配置部分是同事搞定的，只记录一些细节)`

RHive 依赖于Rserve，因此在安装R的时候有些变化：

    ./configure --disable-nls --enable-R-shlib
    make
    make install

enable-R-shlib 是将R作为动态库进行安装，这样像Rserve依赖于R动态库的包就可以安装了，但缺点是会`有20%左右的性能下降`。


## 1.1. Rserve的安装

正常的安装R包：

    install.packages('rJava')
    install.packages('Rserve')
    
在安装Rsever用户下，创建一目录，并创建Rserv.conf文件，写入``remote enable''保存并退出。

通过scp -r 命令将Master节点上安装好的Rserve包，以及Rserv.conf文件拷贝到所有slave节点下,

    scp -r /data2/soft/R2.15/library/Rserve slave1:/data2/soft/R2.15/library/
    scp -r /data2/soft/R2.15/library/Rserve slave2:/data2/soft/R2.15/library/
    scp -r /data2/soft/R2.15/library/Rserve slave3:/data2/soft/R2.15/library/
    scp -r /data2/soft/Rserv.conf slave1:/data2/soft/
    scp -r /data2/soft/Rserv.conf slave2:/data2/soft/
    scp -r /data2/soft/Rserv.conf slave3:/data2/soft/

在所有节点启动Rserve

    Rserve --RS-conf /data2/soft/Rserv.conf
    telnet slave1 6311

在Master节点telnet所有slave节点，显示 Rsrv0103QAP1 则表示连接成功


## 1.2. RHive的安装

安装包，并在master节点和所有slave节点创建目录，并授读写权限

    R CMD INSTALL RHive_0.0-7.tar.gz
    cd /data2/soft/
    mkdir -p rhive/data

在master节点和所有slave节点的hadoop用户下配置环境变量

    vi .bash_profile
    export RHIVE_DATA=/data2/soft/R/rhive/data

通过scp -r 命令将Master节点上安装好的RHive包拷贝到所有slave节点下，

    scp -r /data2/soft/R2.15/library/RHive slave1:/data2/soft/R2.15/library/
    scp -r /data2/soft/R2.15/library/RHive slave2:/data2/soft/R2.15/library/
    scp -r /data2/soft/R2.15/library/RHive slave3:/data2/soft/R2.15/library/

查看hdfs文件系统下的jar包是否有读写权限

    hadoop fs -ls /rhive/lib

最后，启动hive远程服务：
rhive是通过thrift连接hiveserver的，需要要启动后台thrift服务，即：在hive客户端启动hive远程服务

    nohup hive --service hiveserver  &

完毕。

# 2. RHive的使用

## 2.1. rhive-api

从HIVE中获得表信息的函数，比如

* rhive.list.tables：获得表名列表，支持pattern参数(正则表达式)，类似于HIVE的show table 
* rhive.desc.table：表的描述，HIVE中的desc table
* rhive.exist.table：

## 2.2. RHive 简单应用

载入Rhive包，并连接HIVE，获取数据：

    library(RHive)
    rhive.connect(host = 'host_ip')
    d <- rhive.query('select * from emp limit 1000')
    class(d)
    m <- rhive.block.sample(data_sku, percent = 0.0001, seed = 0)
    rhive.close()

一般在系统中已经配置了host，因此可以直接`rhive.connect()`进行连接，记得最后要有`rhive.close()`操作。
通过HIVE查询语句，将HIVE中的目标数据加载至R环境下，返回的 d 是一个dataframe。

实际上，`rhive.query`的实际用途有很多，一般HIVE操作都可以使用，比如变更scheme等操作：

    rhive.query('use scheme1')
    rhive.query('show tables')
    rhive.query('drop table emp')
    
但需要注意的是，数据量较大的情况需要使用`rhive.big.query`，并设置memlimit参数。

将R中的对象通过构建表的方式存储到HIVE中需要使用

    rhive.write.table(dat, tablename = 'usertable', sep = ',')
   
而后使用join等HIVE语句获得相关建模数据。其实写到这儿，有需求的看官就应该明白了，这几项 RHive 的功能就足够
折腾些有趣的事情了。

- 注1：其他关于在HIVE中调用R函数，暂时还没有应用，未来更新。
- 注2：`rhive.block.sample`这个函数需要在HIVE 0.8版本以上才能执行。

- 参考：[RHive 的 github 项目](https://github.com/nexr/RHive/)
  