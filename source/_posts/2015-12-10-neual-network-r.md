---
layout: post
title: 神经网络初步
category: 算法
status: publish
type: post
published: true
---



```r
# input dataset
X <- as.matrix(iris[iris$Species != 'versicolor', 1:4])
# output dataset  
y <- c(rep(0, 50), rep(1, 50))

# sigmoid function
nonlin <- function(x, deriv = FALSE) {
	if(deriv == TRUE) x * (1 - x)
	else 1/(1 + exp(-x))
}

set.seed(1)

# initialize weights randomly with mean 0
w <- rnorm(4, 0, 0.1)
tmp <- list() # 记录w的变化
for (i in 1:100){
	l0 <- X
	l1 <- nonlin(l0 %*% w)
	l1_delta <- (y - l1) * nonlin(l1, deriv = TRUE)
  # update weights
  w <- w + 0.01 * t(l0) %*% l1_delta
  tmp[[i]] <- w
}
l1
table(l1 > 0.5, y)

## Coef's solution path
ts.plot(t(do.call(cbind, tmp)))

```




```r
## include hidden layer
## input dataset
X <- as.matrix(iris[iris$Species != 'versicolor', 1:4])
# output dataset  
y <- c(rep(0, 50), rep(1, 50))

# sigmoid function
nonlin <- function(x, deriv = FALSE) {
	if(deriv == TRUE) x * (1 - x)
	else 1/(1 + exp(-x))
}

set.seed(1)

m <- ncol(X)
n <- 2 # number of cells of hidden layer
syn0 = matrix(rnorm(m*n, 0, 0.1), nrow = m, ncol = n)
syn1 = rnorm(n, 0, 0.1)

iter <- 500

M <- matrix(0, iter * 3, 3) # 测试scale后的效果和中值后的
M[,1] <- rep(1:iter, 3)
M[,3] <- rep(1:3, each = iter)

for(j in 1:iter){
	l0 <- X
	l1 <- nonlin(l0 %*% syn0)
	l2 <- nonlin(l1 %*% syn1)
	l2_delta = (y - l2) * nonlin(l2, deriv = TRUE)
	l1_error = l2_delta %*% t(syn1) # how much did each l1 value contribute to the l2 error (according to the weights)?
	l1_delta = l1_error * nonlin(l1, deriv = TRUE)
	## update weights
  syn1 <- syn1 + 0.01 * t(l1) %*% l2_delta
  syn0 <- syn0 + 0.01 * t(l0) %*% l1_delta
  M[j,2] <- sd(y - l2)
}


m <- ncol(X)
n <- 2 # number of cells of hidden layer
syn0 = matrix(rnorm(m*n, 0, 0.1), nrow = m, ncol = n)
syn1 = rnorm(n, 0, 0.1)

for(j in 1:iter){
	l0 <- scale(X)
	l1 <- nonlin(l0 %*% syn0)
	l2 <- nonlin(l1 %*% syn1)
	l2_delta = (y - l2) * nonlin(l2, deriv = TRUE)
	l1_error = l2_delta %*% t(syn1) # how much did each l1 value contribute to the l2 error (according to the weights)?
	l1_delta = l1_error * nonlin(l1, deriv = TRUE)
	## update weights
  syn1 <- syn1 + 0.01 * t(l1) %*% l2_delta
  syn0 <- syn0 + 0.01 * t(l0) %*% l1_delta
  M[j + iter,2] <- sd(y - l2)
}


m <- ncol(X)
n <- 2 # number of cells of hidden layer
syn0 = matrix(rnorm(m*n, 0, 0.1), nrow = m, ncol = n)
syn1 = rnorm(n, 0, 0.1)

for(j in 1:iter){
	l0 <- t(t(X) - colMeans(X))
	l1 <- nonlin(l0 %*% syn0)
	l2 <- nonlin(l1 %*% syn1)
	l2_delta = (y - l2) * nonlin(l2, deriv = TRUE)
	l1_error = l2_delta %*% t(syn1) # how much did each l1 value contribute to the l2 error (according to the weights)?
	l1_delta = l1_error * nonlin(l1, deriv = TRUE)
	## update weights
  syn1 <- syn1 + 0.01 * t(l1) %*% l2_delta
  syn0 <- syn0 + 0.01 * t(l0) %*% l1_delta
  M[j + 2*iter,2] <- sd(y - l2)
}

M <- data.frame(M)
M <- transform(M, X3 = as.factor(X3))	
names(M) <- c('iter','MSE','Class')
library(ggplot2)
ggplot(data = M, mapping = aes(x = iter, y = MSE, colour = Class)) + geom_line(size = 1.5) + ylim(0,.65)
```