---
layout: post
title: graphchi 和R 的结合应用
tags: 
- bigdata
- business
status: publish
type: post
published: false
---

export GRAPHCHI_ROOT=/export/home/recsys/liusizhe/graphchi/graphchi-cpp-master

./als --training=/export/home/recsys/liusizhe/graphchi/data/smallnetflix_mm --lambda=0.065 --minval=1 --maxval=5 --max_iter=10 --quiet=1 --R_output_format

x <- read.table('smallnetflix_mm_U.mm', skip = 3, header = F)
y <- read.table('smallnetflix_mm_V.mm', skip = 3, header = F)

	R <- matrix(
	c(5,3,0,1,0,
	4,0,0,1,2,
	1,1,0,5,4,
	1,0,0,4,0,
	0,1,5,4,2,
	2,0,1,5,0), 6, 5, byrow = TRUE)
	library(Matrix)
	writeMM(as(R, 'CsparseMatrix'), file = 'R.mm')

./als --training=/export/home/recsys/liusizhe/graphchi/data/R.mm --D=3 --minval=1 --maxval=5 --max_iter=20 --quiet=1 --halt_on_rmse_increase

./nmf --training=/export/home/recsys/liusizhe/graphchi/data/R.mm --minval=1 --D=3 --maxval=5 --max_iter=20 --quiet=1

setwd('/export/home/recsys/liusizhe/graphchi/data')
x <- matrix(scan('R.mm_U.mm', skip = 3), 6, 3)
y <- matrix(scan('R.mm_V.mm', skip = 3), 5, 3)
x %*% t(y)



./als --training=/export/home/recsys/liusizhe/graphchi/data/rank_label.csv --D=20 --minval=1 --maxval=5 --max_iter=20 --quiet=1



x <- matrix(
c(0,1,0,1,0,0,0,0,
1,1,1,0,0,0,0,0,
0,0,0,1,1,1,1,0,
0,0,0,0,1,0,0,1,
1,1,0,0,0,0,1,0,
0,0,0,0,0,0,1,1,
0,0,0,1,1,0,0,0,
1,0,0,0,0,0,0,0,
0,0,1,0,0,0,1,0), byrow = TRUE, ncol = 8
)
setwd('/export/home/recsys/liusizhe/graphchi/data')

	library(Matrix)
	#writeMM(as(x, 'CsparseMatrix'), file = 'x.mm')
	write.table(data.frame(which(x == 1, arr.ind = TRUE), 1), file = 'x.mm', row.names = F, col.names = F)
	

./als --training=/export/home/recsys/liusizhe/graphchi/data/x.mm --D=3 --max_iter=20 --quiet=1

cosmatrix <- function(x){
cosine <- function(a,b) crossprod(a, b)/sqrt(crossprod(a) * crossprod(b))
m <- matrix(, nrow = nrow(x), ncol = nrow(x))
for(i in 1:nrow(x)) for(j in 1:nrow(x)) m[i,j] <- cosine(x[i,], x[j,])
m[lower.tri(m)] <- NA
diag(m) <- NA
return(m)
}

## 


readmm <- function(file){
	data <- read.table(file, skip = 3)$V1
	n <- read.table(file, skip = 2, nrows = 1)
	m <- matrix(data, nrow = n$V1, ncol = n$V2)
	return(m)
}
U <- readmm('x.mm_U.mm')
V <- readmm('x.mm_V.mm')


http://ziketang.com/2013/04/zz-of-sgd-vs-als/
Both ALS and SGD solve a similar quadratic cost function. ALS operates by starting with a random guess for the users (or movies) and then computes a least square step to compute the movies (or users) alternating between the two. SGD works by starting with a random guess and computing the gradient of the cost function and making a step in the direction of the gradient.
Typically, SGD iteration is faster, since ALS involves a least squares solution which is heavier. However, fewer ALS iterations are typically needed for solving to the same level of accuracy. Also ALS is more parallel since all movies or users can be computed independently in parallel, while SGD may have slower parallel performance in case two different users have seen the same movie, this results in concurrent updates to the gradient of the same movies which slows down the operation.
ALS significantly exploits linear algebra packages and specifically Intel MKL which can give a speedup of x5 – x10.
Bias-SGD is a slightly improved version of SGD, which also computes a bias for each movie and user, thus slightly improving accuracy at the cost of additional computation.
Regarding parameter tuning, SGD has more parameters to tune since you need to carefully select the gradient step size. Both SGD and ALS have regularization parameters to tune, number of iterations, and feature vector width.
Anyway it is hard to estimate which method will work better on which dataset. That is why it is very convenient to use graphlab/graphchi – once you prepare your data to the right format you can immediately test multiple methods.
Let us know if you have any further questions!



./als --training=/export/home/recsys/liusizhe/graphchi/data/smallnetflix_mm --validation=/export/home/recsys/liusizhe/graphchi/data/smallnetflix_mme --lambda=0.065 --minval=1 --maxval=5 --max_iter=6 --quiet=1


./toolkits/collaborative_filtering/als --training=smallnetflix_mm --validation=smallnetflix_mme --lambda=0.065 --minval=1 --maxval=5 --max_iter=6 --quiet=1



x <- read.table('add_degree.csv', skip = 1, sep = '\t') 
iname <- unique(x$V1)
jname <- unique(x$V2)
library(Matrix)
m <- sparseMatrix(i = match(x$V1, iname), j = match(x$V2, jname), x = x$V3)

writeMM(m, file = 'rank_ll')

test <- read.table('test.csv', skip = 1, sep = '\t')
z <- sparseMatrix(i = match(test$V1, iname), j = match(test$V2, jname), x = test$V3)


###
./toolkits/collaborative_filtering/als --training=rank_ll --lambda=0.065 --minval=1 --maxval=5 --max_iter=6 --quiet=1


test <- read.table('test.csv', skip = 1, sep = '\t')




l2wide <- 
function (x, method = c("dense", "sparse"))
{
    method <- match.arg(method)
    if (ncol(x) == 1)
        stop("You can't turn the data frame into widewise!")
    if (nrow(x) != nrow(unique(x)))
        stop("There are duplacated rows!")
    uid <- as.character(unique(x[, 1]))
    pid <- as.character(unique(x[, 2]))
    rowid <- match(x[, 1], uid)
    colid <- match(x[, 2], pid)
    if (method == "sparse") {
        require(Matrix)
        M <- Matrix(0, nrow = length(uid), ncol = length(pid))
    }
    if (method == "dense")
        M <- matrix(0, nrow = length(uid), ncol = length(pid))
    i = cbind(rowid, colid)
    if (ncol(x) == 3)
        M[i] <- x[, 3]
    if (ncol(x) == 2)
        M[i] <- 1
    rownames(M) <- uid
    colnames(M) <- pid
    return(M)
}

hadoop fs -ls /user/recsys/zhuyi/train/trainSet/probeSet/





library(igraph)
g <- random.graph.game(20, 5/20, directed=TRUE)
page.rank(g)$vector

/export/home/recsys/liusizhe/graphchi/graphchi-cpp-master/bin/example_apps/pagerank
./pagerank /export/home/recsys/liusizhe/graphchi/data/amazon0302.txt  niters 10









