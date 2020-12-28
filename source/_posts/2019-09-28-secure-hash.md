---
layout: post
title: 利用 R 函数生成差异化密码
tags: 
- secure hash 
- password
status: publish
type: post
published: true
---

随着我们注册的网站和 App 越来越多，有一个问题一直困扰着我：

> 我的密码真心不够用！

以及还有一个更为可怕的风险：如果所有的网站如果使用同样的密码，任意一个网站只要发生安全泄露，那基本你在其他网站就属于裸奔了，其他人可以利用你的`共用密码`作出一系列你不能想象的行为。

[1Password](https://1password.com/zh-cn/) 给我了一些启发，它可以保证你每个网站的密码都不同。这款软件安全性怎样，收费多少先不提，我们简单思考一下这个软件的原理貌似是容易实现的，基本要素和逻辑应该有以下要点：

1. 不同的网站或者 app 会导致密码的不同
2. 自己有一个私钥种子，这是唯一要保存的
3. 将 1 和 2 的信息加密之后返回加密信息
4. 将加密信息的内容通过一定的规则给出显式密码

这样做的最大好处是，我只需要记住 2 的种子，即便暴露了 4 的规则，也不担心密码会被反向破译。

闲话少说，直接给出代码参考，稍稍利用了一下 R 中的 `set.seed` 特性。

```{r}
n <- 10 # 生成密码长度
initChar <- 'bjt.name' #私人秘钥
webORapp <- 'twitter.com' # 任意网站或 App
specialChar <- '@!#&^*_+=-'
library(openssl)
library(magrittr)
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
  paste(collapse = '')

```

给出来的结果是 `ceA=cB90`，在 Twitter 上给出的密码安全强度是 strong。

写到最后，发现貌似用户名存在一样的问题，经常注册网站也会有冲突的情况，那看官就自行改一个生成用户名的机制好了。

## 关于加密算法

比较出名的加密算法有

- md5
- sha1
- sha256
- BLAKE

md5 和 sha1 可以通过碰撞的方式破解，当然前提是算力够强。有一次我和同事打赌，能不能在 3 小时内将我随意 md5 加密的手机号码破解，他找了一段 Java 程序，狂算了 3 小时，最后还是无解。给我的一点启发是，理论上 md5 和 sha1 确实有缺陷，但实际生活中基本也够用了。

sha1 广泛应用于各种互联网协议，比如 SSL 等，我们在点击流签名认证也使用了该技术。这个场景我用了sha2，显然只是不同的一个函数而已。

