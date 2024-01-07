suppressPackageStartupMessages(library(fiery))
suppressPackageStartupMessages(library(utils))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(xgboost))
suppressPackageStartupMessages(library(rredis))

app <- Fire$new() # 开启一个fiery实例

app$host <- "127.0.0.1"
app$port <- 9123 # completely arbitrary selection, make it whatevs

model <- NULL

## 将预先训练好的模型加载到全局变量中

app$on("start", function(server, ...) {
  message(sprintf("Running on %s:%s", app$host, app$port))
  model <<- readRDS("model.rds")
  message("Model loaded")
})

## 开启 request的监听
##  

app$on('request', function(server, id, request, ...) {
  
  response <- list(
    status = 200L,
    headers = list('Content-Type'='text/html'),
    body = ""
  )
  
  # this helps us see what the path is
  path <- get("PATH_INFO", envir = request)
  if (grepl("^/predict", path)) {
    
    # this gets the query string; we're expecting val=##
    # but aren't going to do any error checking here.
    # You also would want to ensure there is nothing
    # malicious in the query string.
    query  <- get("QUERY_STRING", envir = request)
    
    # handy helper function from the Shiny folks
    input <- shiny::parseQueryString(query)
    
    message(sprintf("Input: %s", input$val))
    
    # run the prediction and add the input var value to the list
    
    getdata <- function(id = '1'){
      id <- as.character(id)
      rredis::redisConnect()
      z <- numeric(57)
      d <- as.numeric(unlist(rredis::redisHKeys(id)))
      z[d] <- t(as.numeric(rredis::redisHVals(id)))
      rredis::redisClose()
      return(as.matrix(t(z)))
    }
    
    res <- list()
    res$v <-  xgboost:::predict.xgb.Booster(object = model, newdata = getdata(input$val))
    res$url <- paste("http://cc.bjt.name/data?v=", res, "&id=", input$val, sep = '')
    
    # we want to return JSON
    response$headers <- list("Content-Type"="application/json")
    response$body <- jsonlite::toJSON(res, auto_unbox=TRUE, pretty=TRUE)
    
  }
  
  response
  
})

# don't fire off a browser call
app$ignite(showcase=FALSE)
