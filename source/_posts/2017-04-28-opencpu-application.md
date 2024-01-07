---
layout: post
title: 利用R和opencpu搭建高可用的HTTP服务
category: R 技巧
tags: 
- opencpu
- json
- http
- redis
status: publish
type: post
published: true
---

> 思路可借鉴，但内容已经过时，请忽视。可转向 https://github.com/rexyai/RestRserve

使用R提供一个高可用的服务一直对R来说都是弱点，比如JRI(Java)或Rserve这些都不是太友好。
OpenCPU的出现彻底解决了这个问题，援引OpenCPU[介绍](https://jeroen.github.io/opencpu-slides/)：

- Interoperable HTTP for data analysis
- RPC and object management
- I/O: JSON, Protocol Buffers, CSV
- Support for parallel/async requests
- Highly configurable security policies
- Native reproducibility
- Client libraries: JavaScript, Ruby, ...

一言以蔽之：可以快速搭建灵活的高可用服务。比如说，对于线上预测的请求，大概在200毫秒左右，很多场景基本上也够用了。

<!-- more -->

OpenCPU支持 GET 和POST 请求，对于Object和file目标响应不同：

|METHOD                                     |TARGET |ACTION        |ARGUMENTS             |EXAMPLE                             |
|:------------------------------------------|:------|:-------------|:---------------------|:-----------------------------------|
|GET                                        |object |read object   |control output format |GET /ocpu/cran/MASS/data/cats/json  |
|POST                                       |object |call function |function arguments    |POST /ocpu/library/stats/R/rnorm    |
|GET                                        |file   |read file     |-                     |GET /ocpu/cran/MASS/scripts/             |
|POST                                       |file   |run script    |control interpreter   |POST /ocpu/cran/knitr/examples/minimal.Rmd |

一般来讲，线上服务我们期待通过传递参数的call funcion的方式，以下是该场景的极简示例。


# opencpu在CentOS 7平台上的安装

不同平台的安装方式不同，这里使用了标配的CentOS 7，该平台需要自行编译rpm包，具体操作过程请参考[这里](https://github.com/jeroen/opencpu-server/blob/master/rpm/buildscript.sh)。

安装结束后，请测试

```
curl http://localhost/ocpu/library/
```

返回了全部的R包列表，则表明安装成功。

可能会涉及 opencpu 的重新启动，直接利用以下命令：

	sudo apachectl restart


# 利用RStudio快速创建服务

使用RStudio做package check&build非常方便，我们可以很轻松在CentOS7上安装一个Server版。
这里有一个小细节，RStudio安装完毕后，利用Web界面登陆（建议用Firefox），此时不能使用root账号直接登录，我们可以add一个名为 bjt 的账号登录，并创建名为 spampred 的包


# 利用线上redis缓存来做预测

## 特征服务的模拟

假设spam的特征数据是实时被写入到缓存的 hashmap，模拟操作利用了pipeline操作

```r
library(ElemStatLearn)
library(rredis)
library(Matrix)
redisConnect()
redisSetPipeline(TRUE)

tr <- function(x) charToRaw(as.character(x))
d <- summary(as(as.matrix(spam[,-ncol(spam)]), 'dgCMatrix'))
for(i in 1:nrow(d)){
	redisHSet(as.character(d[i,1]), as.character(d[i,2]), tr(d[i,3]))
}
resp <- redisGetResponse()
```

我们可以找一些values：

	127.0.0.1:6379> HVALS 2
	 1) "0.21"
	 2) "0.28"
	 3) "0.5"
	 4) "0.14"
	 5) "0.28"
	 6) "0.21"
	 7) "0.07"

关于rredis的使用可以参考以前的[博文](/2014/06/r-redis)

## 模拟一个预测模型

利用xgboost和glmnet包：

```r
library(xgboost)
library(glmnet)
library(ElemStatLearn)
x <- as.matrix(spam[, -ncol(spam)])
y <- as.numeric(spam$spam) - 1
m <- xgboost(data = x, label = y, nrounds = 5, objective = 'binary:logistic')
save(m, file="data/xgb.rda")
g <- cv.glmnet(x = x, y = y, family = 'binomial')
save(g, file="data/glm.rda")
```

保存模型的结果 `xgb.rda`至新建包的`data`目录下，保证lazyload可以直接使用该对象。

## 创建R包

以下就非常容易了，在RStudio中

> File - New Project - New Directory - R package

填写包名 `spampred`，进入R子目录，将 `hello.R` 文件`mv hello.R predxgb.R`，打开predxgb.R 文件，将以下代码贴入：

```r
getdata <- function(id = '1'){
  id <- as.character(id)
  rredis::redisConnect()
  z <- numeric(57)
  d <- as.numeric(unlist(rredis::redisHKeys(id)))
  z[d] <- t(as.numeric(rredis::redisHVals(id)))
  rredis::redisClose()
  return(as.matrix(t(z)))
}


spampred <- function(id = '1'){
  v = xgboost:::predict.xgb.Booster(object = m, newdata = getdata(id))
  v = as.character(v)
  return(list(class = v,
              url = paste("cc.bjt.name/data?v=", v, "&id=", id, sep = '')))
}

linearpred <- function(id = '1'){
	v = glmnet:::predict.cv.glmnet(object = g, newx = getdata(id), s = "lambda.min", type = 'response')
	v = as.character(v)
  return(list(class = v,
              url = paste("cc.bjt.name/data?v=", v, "&id=", id, sep = '')))	
}

```

在DESCRIPTION文件中修改以及增加

```
LazyData: false
Imports:
    xgboost,
    rredis
```

将man中的 `hello.Rd` 文件改为 `spampred.Rd`，同时修改函数的说明和定义。

## 提高 http 服务的性能

在 `spampred/R` 目录下增加 `onLoad.R`文件（提高载入性能），文件内容如下：

```r
.onLoad <- function(lib, pkg){
  #automatically loads the dataset when package is loaded
  #do not use this in combination with lazydata=true
  utils::data(xgb, package = pkg, envir = parent.env(environment()))
  utils::data(glm, package = pkg, envir = parent.env(environment()))
}
```

修改opencup服务参数，文件位于 `/etc/opencpu/server.conf`，增加预加载的包

```
"preload": ["jsonlite","ggplot2","xgboost","glmnet","spampred", "lattice","ocputest","randomForest","rredis"]
```

增加参数之后，重启opencpu服务。

`Ctrl + Shift + E` check 一下包是否有问题。没有问题的话，可以选择 Build Binary Package。
返回服务器，在创建好的包目录执行

	R CMD INSTALL spampred_0.1.0_R_x86_64-redhat-linux-gnu.tar.gz 

此时我们的函数通过R包生效。
  
# 通过opencpu提供服务


opencpu贴心的提供了测试页面，对于我来说是

	http://47.92.114.121:8004/ocpu/test/
	
在 HTTP request options 中变更请求方式为post，Endpoint 为 `../library/spampred/R/spampred`，同时增加 Param Name 和 Param Value，
请求Ajax，看到

```
/ocpu/tmp/x023b988e25/R/.val
/ocpu/tmp/x023b988e25/stdout
/ocpu/tmp/x023b988e25/source
/ocpu/tmp/x023b988e25/console
/ocpu/tmp/x023b988e25/info
/ocpu/tmp/x023b988e25/files/DESCRIPTION
```

说明服务是正常的。


当然既然服务已就绪，在其他段上可以直接调用返回JSON结果，比如我的是

```
[root@iz8vbblvp84015jmqwu5tlz sunbjt]# time curl http://47.92.114.121:8004/ocpu/library/spampred/R/spampred/json -d "id=1" 
{
  "class": ["0.875068128108978"],
  "url": ["cc.bjt.name/data?v=0.875068128108978&id=1"]
```
