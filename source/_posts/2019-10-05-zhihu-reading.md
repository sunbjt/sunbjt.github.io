---
layout: post
title: 2019 年建议阅读书目
category: 有意思的
tags: 
- reading
- crawler
status: publish
type: post
published: true
---

国庆期间闲逛知乎，恰巧碰到一则问题 [2019年你的书单有什么书？](https://www.zhihu.com/question/306249128)，这个问题有 

> 988 个回答，18326 个关注者，284 万的浏览量

接近 1000 个回答，全部翻完且不说时间会爆炸，脑子里能不能记住这些信息更是问题。如果能抓取每个回答列出来的书名，汇总以后便是这 988 个回答者的书目投票。方法虽说暴力，但也算是变相了解大家在 2019 年的阅读倾向。工具呢？当然是我擅长使用的 R 了，哈哈！

闲话不多说，直接给出结果（大于 10 位回答者提及的书目）：

<!-- more -->

| 书名                 | 提到的数量 |
| :-------------------| ---------: |
| 《人类简史》         |         35 |
| 《乌合之众》         |         33 |
| 《三体》             |         29 |
| 《如何阅读一本书》   |         25 |
| 《白夜行》           |         25 |
| 《红楼梦》           |         24 |
| 《平凡的世界》       |         24 |
| 《霍乱时期的爱情》   |         24 |
| 《百年孤独》         |         23 |
| 《亲密关系》         |         22 |
| 《非暴力沟通》       |         22 |
| 《月亮与六便士》     |         22 |
| 《活着》             |         22 |
| 《围城》             |         20 |
| 《人间失格》         |         19 |
| 《毛泽东选集》       |         17 |
| 《浮生六记》         |         17 |
| 《挪威的森林》       |         16 |
| 《小王子》           |         16 |
| 《未来简史》         |         16 |
| 《少有人走的路》     |         16 |
| 《白鹿原》           |         16 |
| 《苏菲的世界》       |         15 |
| 《原则》             |         15 |
| 《万历十五年》       |         15 |
| 《国富论》           |         15 |
| 《金字塔原理》       |         15 |
| 《我们仨》           |         15 |
| 《局外人》           |         14 |
| 《西方哲学史》       |         14 |
| 《乡土中国》         |         14 |
| 《影响力》           |         13 |
| 《穷查理宝典》       |         13 |
| 《诗经》             |         13 |
| 《1984》             |         13 |
| 《娱乐至死》         |         12 |
| 《菊与刀》           |         12 |
| 《自控力》           |         12 |
| 《自卑与超越》       |         12 |
| 《人性的弱点》       |         12 |
| 《房思琪的初恋乐园》 |         12 |
| 《学会提问》         |         11 |
| 《全球通史》         |         11 |
| 《雪国》             |         11 |
| 《今日简史》         |         11 |
| 《道德经》           |         11 |
| 《社会心理学》       |         11 |
| 《史记》             |         11 |
| 《许三观卖血记》     |         11 |
| 《薛兆丰经济学讲义》 |         10 |
| 《瓦尔登湖》         |         10 |
| 《黄金时代》         |         10 |
| 《杀死一只知更鸟》   |         10 |
| 《月亮和六便士》     |         10 |

这份书单我大概都知道名字，但真正读完的不超过 1/4，比如很早就读完的《1984》、《史记》、《人性的弱点》，《人类简史》、《金字塔原理》、《穷查理宝典》。但像《三体》拖拉了很久，买了该有 5、6 年了，依然还在垫显示器。有些书看过一些影视作品，比如《活着》、《平凡的世界》、《红楼梦》等。

《如何阅读一本书》读了两遍，确实值得细细的品读。《毛泽东选集》被人推荐了好几年，今年才算开始了正式的阅读，收获真的很大。包括《薛兆丰经济学讲义》、《原则》，这些是近两年内读的，内容非常不错。综上，这个书单的质量还是非常不错的。通过这个书单对比一下脑海里感兴趣的内容，接下来几个月的阅读计划顺次是：

1. 《国富论》
2. 《西方哲学史》
3. 《菊与刀》
4. 《自控力》
5. 《自卑与超越》
6. 《学会提问》

大约会在过年前完成这个计划。

最后再说一下这个知乎 R 爬虫，代码量很少，全部代码 95 行，核心代码不超过 40 行。基本的思路如下：

1. 找到知乎返回内容的 api，这个稍稍会花一些时间
2. 通过了解 api 的结果设计爬虫的逻辑
3. 用`《*?》` 的正则表达式，解析每篇'回答'中的所有书名
4. 统计所有书名出现的次数，完工

当然也可以通过书和书之间的协同关系给出网络图，谁有兴趣可以提供我一下后续内容，我暂时没时间，这里就省略了。

## 附代码：

```r

library(magrittr)
library(jsonlite)
library(stringi)
library(futile.logger)
library(utils)
library(purrr)
## 重定义 retry 函数
retry <-
  function(expr,
           isError = function(x)
             "try-error" %in% class(x),
           maxErrors = 5,
           sleep = rnorm(1, 8, 2)) {
    attempts = 0
    retval = try(eval(expr))
    while (isError(retval)) {
      attempts = attempts + 1
      if (attempts >= maxErrors) {
        msg = sprintf("retry: too many retries [[%s]]", capture.output(str(retval)))
        flog.fatal(msg)
        stop(msg)
      } else {
        msg = sprintf(
          "retry: error in attempt %i/%i [[%s]]",
          attempts,
          maxErrors,
          capture.output(str(retval))
        )
        flog.error(msg)
        warning(msg)
      }
      if (sleep > 0)
        Sys.sleep(sleep)
      retval = try(eval(expr))
    }
    return(retval)
  }


## 构造从内容到书名的函数
## 简单的想法是获取书名号中的内容
## 如果不在书名号中，则会导致失效
## 重构 read_html 和 html_text 函数，增加稳定性
read_html_beta <- function(x){
  x <- try(read_html(x))
}
html_text_beta <- function(x){
  x <- try(html_text(x))
}

Content2tittle <- function(content) {
  title <- content %>%
    purrr::map_chr('content') %>%
    map(read_html_beta) %>%
    map(html_text_beta) %>%
    stri_extract_all_regex('《.*?》') %>%
    map(unique)
  return(title)
}

raw_data <- list()
## 获取知乎的 API 接口数据
url <- 'https://www.zhihu.com/api/v4/questions/306249128/answers?data[*].author.follower_count,badge[*].topics=&data[*].mark_infos[*].url=&include=data[*].is_normal,admin_closed_comment,reward_info,is_collapsed,annotation_action,annotation_detail,collapse_reason,is_sticky,collapsed_by,suggest_edit,comment_count,can_comment,content,editable_content,voteup_count,reshipment_settings,comment_permission,created_time,updated_time,review_info,relevant_info,question,excerpt,relationship.is_authorized,is_author,voting,is_thanked,is_nothelp,is_labeled,is_recognized,paid_info,paid_info_content&limit=10&offset=0&platform=desktop&sort_by=default'

## 循环获取所有数据
i <- 1
is_end <- FALSE
while (!is_end) {
  m <- retry(readLines(url)) %>%
    fromJSON(simplifyVector = FALSE)
  content <- m$data
  next_url <- m$paging$'next' # 接下来需要解析的 url
  url <- next_url
  raw_data[[i]] <- Content2tittle(content)
  is_end <- m$paging$is_end # 利用 is_end 来判断是否结束
  cat('This is ', i, 'round', '\n')
  i <- i + 1
  Sys.sleep(runif(1, 4, 10))
}

## 踢掉一些没有信息的 answer
removed_data <- raw_data[raw_data %>% map(length) != 0]
nid <- raw_data %>% map(function(x)map(x, length)) %>% unlist()
fnid <- rep(1:length(nid), times = nid)

## 返回所有的书目
data <- data.frame( title = unlist(removed_data), id = fnid) %>%
  transform(title = as.character(title)) %>%
  na.omit() %>%
  subset(nchar(title) <= 20)

library(data.table)
data <- data.table(data)
data[, .N, title][order(-N)][N >= 10]


```