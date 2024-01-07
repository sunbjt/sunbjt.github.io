---
layout: post
title: R的高性能 http 服务 fiery
category: R 技巧
tags: 
- fiery
- http
status: publish
type: post
published: true
---

> 思路可借鉴，但内容已经过时，请忽视。可转向 https://github.com/rexyai/RestRserve

前文说到使用 opencpu 来搭建 http 服务，opencpu 可以很快速的通过构建 R 包的方式来搭建 http 服务，
很快捷，而且支持各种响应机制。但我们在搭建线上服务时，经常有需求将请求响应的时间控制在100ms以内，opencpu的框架就存在问题了。
这里再介绍R的另外一个包：fiery，部署更加方便且响应优势更加明显（一般30ms以内）。

首先假设我们面对的场景是垃圾邮件预测，已经根据离线数据构建了预测模型：

```
library(xgboost)
library(ElemStatLearn)
x <- as.matrix(spam[, -ncol(spam)])
y <- as.numeric(spam$spam) - 1
m <- xgboost(data = x, label = y, nrounds = 5, objective = 'binary:logistic')
saveRDS(m, file = "model.rds")
```

假定我们线上预测流程是这样：

1. 通过传递邮件id号获取该邮件的特征
2. 用xgboost模型来预测spam的概率
3. json返回预测结果以及埋点结果

<!-- more -->

R中的服务代码见下：

```
## 加载需要的扩展包，静默加载

suppressPackageStartupMessages(library(fiery))
suppressPackageStartupMessages(library(utils))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(xgboost))
suppressPackageStartupMessages(library(rredis))

app <- Fire$new() # 开启一个fiery实例

app$host <- "127.0.0.1"
app$port <- 9123 # 设置服务 ip 地址和端口号

model <- NULL

## 将预先训练好的模型加载到全局变量中
## 预训练模型通过 saveRDS 函数保存，此处略过

app$on("start", function(server, ...) {
  message(sprintf("Running on %s:%s", app$host, app$port))
  model <<- readRDS("model.rds")
  message("Model loaded")
})

## 开启 request的监听
## 初始化定义 response 的 headers 和 body

app$on('request', function(server, id, request, ...) {
  
  response <- list(
    status = 200L,
    headers = list('Content-Type'='text/html'),
    body = ""
  )
  
    ## 获取请求的 path，一旦判断为 /predict 则进行预测
  	path <- get("PATH_INFO", envir = request)
  	if (grepl("^/predict", path)) {
    
    ## 获取 query string，我们期待的结果是 val=##

    query  <- get("QUERY_STRING", envir = request)
    
    ## 解析query, 大概传递的是类似这个：parseQueryString("?foo=1&bar=b%20a%20r")
    ## 一般在前端需要 encoding，input 解析出来是 list 对象
    
    input <- shiny::parseQueryString(query)
    message(sprintf("Input: %s", input$val))
    
    ## 声明获取数据的函数
    ## 这里依旧模拟了从redis缓存取数的逻辑，但并未判断异常情况
    ## 读者可以在此做未获得数据的异常判断
    
    getdata <- function(id = '1'){
      id <- as.character(id)
      rredis::redisConnect(host = "10.0.2.70", port = 9736, password = '')
      z <- numeric(57)
      d <- as.numeric(unlist(rredis::redisHKeys(id)))
      z[d] <- t(as.numeric(rredis::redisHVals(id)))
      rredis::redisClose()
      return(as.matrix(t(z)))
    }
    
    ## 进入模型预测环节
    ## 声明返回 res 是一个 list，传递参数为 input$val
    
    res <- list()
    res$v <-  xgboost:::predict.xgb.Booster(object = model, newdata = getdata(input$val))
    
    ## 增加埋点信息
    
    res$url <- paste("http://cc.bjt.name/data?v=", round(res$v, 5), "&id=", input$val, sep = '')
    
    # 返回JSON
    response$headers <- list("Content-Type"="application/json")
    response$body <- jsonlite::toJSON(res, auto_unbox = TRUE, pretty = TRUE)
    
  }
  
  response
  
})

app$ignite(showcase=FALSE) # 启动服务
```


我们需要将该模型部署在线上。将以上代码命名为 fire.r，直接运行

```
Rscript fire.r 
```

预测服务即为就绪状态。通过 curl 请求调用服务（并测试时间）：

```
time curl http://127.0.0.1:9123/predict?val=235
```

```
{
  "v": 0.8843,
  "url": "http://cc.bjt.name/data?v=0.884290516376495&id=25"
}
real    0m0.020s
user    0m0.000s
sys     0m0.005s
```

或者使用 `microbenchmark:::microbenchmark(system('curl http://127.0.0.1:9123/predict?val=95'))`

```
                                                expr      min       lq     mean
 system("curl http://127.0.0.1:9123/predict?val=95") 23.32366 25.57629 27.30786
   median       uq      max neval
 26.69601 28.37809 40.50802   100
```
