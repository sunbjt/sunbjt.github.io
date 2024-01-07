---
layout: post
title: 生成不同的网站登录密码
tags: 
- secure hash 
- password
status: publish
category: 工具技巧
type: post
published: true
---

随着我们注册的网站和 App 越来越多，有一个问题一直困扰着我：

> 我的密码真心不够用！

经常几个可能密码重复的尝试，时不时网站就报超过尝试次数。以及还有一个更为可怕的风险：如果所有的网站如果使用同样的密码，任意一个网站只要发生安全泄露（这几年发生次数不少），那基本你在其他网站就属于裸奔了，其他人可以利用你的`统一密码`作出一系列你不能想象的行为。

[1Password](https://1password.com/zh-cn/) 给我了一些启发，它可以保证你每个网站的密码都不同。这款软件安全性怎样，收费多少先不提，我们简单思考一下这个软件的原理貌似是容易实现的，基本要素和逻辑猜测有以下要点：

1. 不同的网站或者 app 会导致密码的不同
2. 自己有一个私钥种子，这是唯一要保存的
3. 将 1 和 2 的信息加密之后返回加密信息
4. 将加密信息的内容通过一定的规则给出显式密码
5. 显式密码包含特殊字符，英文的大小写字母

这样做的最大好处是，我只需要记住 2 的种子，即便暴露了 4 的规则，也不担心密码会被反向破译。

<!-- more -->

既然已知原理，那么闲话少说，实现这个逻辑。

```r
n <- 12 # 生成密码长度，见过最长的为 vivaldi，注册长度为 12
initChar <- 'bjt.name' # 私人秘钥
specialChar <- '@!#&^*_+=-'
require(openssl)
require(magrittr)

password <- function(webORapp = 'twitter.com'){
  Char <- paste(initChar, webORapp, sep = '') 
  zchar <- Char %>% 
    sha256() %>%
    strsplit(split = '') %>%
    unlist()
  ## 根据组合信息生成随机数
  nsep <- zchar %>% 
    sapply(charToRaw) %>%
    as.numeric() %>% 
    sum()
  set.seed(nsep)
  ## 将一半的字符大写化，如果是字母的话
  upp <- sample(64, 32)
  zchar[upp] <- zchar[upp] %>% 
    toupper()
  zspec <- specialChar %>% 
    strsplit(split = '') %>%
    unlist() %>%
    sample(1)
  
  ## 保证必须有一个特殊字符
  id <- sample(1:n, 1)
  password <- sample(zchar, n)
  password[id] <- zspec
  password %>%
    paste(collapse = '') %>%
    return()
}


library(shiny)

app <- shinyApp(
ui <- fluidPage(
  textInput("caption", "The name of Web or App", "iciba.com"),
  verbatimTextOutput("value")
),

server <- function(input, output) {
  output$value <- renderText({ password(input$caption) })
}
)
# Run the application 
runApp(app, launch.browser = TRUE)

```

给出来的结果是 `9a8e0A9cB-9c`，在 Twitter 上给出的密码安全强度是 strong。以上代码可以直接放在 rstudio 里直接运行调出一个网页出来，更方便。

> 如果用户名也会出现注册网站也有冲突的情况，那看官就自行改一个生成用户名的机制就好了。

## 关于加密算法

比较出名的加密算法有

- md5
- sha1
- sha256
- BLAKE

md5 和 sha1 可以通过碰撞的方式破解，当然前提是算力够强。有一次我和同事打赌，能不能在 3 小时内将我随意 md5 加密的手机号码破解，他找了一段 Java 程序，狂算了 3 小时，最后还是无解。给我的一点启发是，理论上 md5 和 sha1 确实有缺陷，但实际生活中基本也够用了。

sha1 广泛应用于各种互联网协议，比如 SSL 等，我们在点击流签名认证也使用了该技术。这个场景我用了sha2，显然只是不同的一个函数而已。

