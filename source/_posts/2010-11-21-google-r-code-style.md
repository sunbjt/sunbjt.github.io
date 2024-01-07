---
layout: post
title: R语言的代码规范
tags: 
- emacs
- google
status: publish
type: post
published: true
---
前些天在准备<a href="http://cos.name/chinar/chinar-2010/" target="_blank">中国第三届R语言会议（上海）</a>的时候，
翻到以前记录在Google Notebook里的一些材料，
一篇是关于Google Codes关于<a href="https://google.github.io/styleguide/Rguide.xml">R代码的规范</a>，非常值得借鉴。

规范这个东西平时多多注意一些还是有好处的，就和作文一样，漂亮的字体总能有不错的加分。这里就不翻译原文了，摘一些 tips 供大家参考：


## R风格规范

### 文件命名

以 .R 结尾的文件必须有实际意义，比如

	GOOD: predict_ad_revenue.R 
	BAD: foo.R

### 变量名和函数名

- 变量名建议使用小写字母和dots，比如 `variable.name`，`variableName` 也是可以被接受的 
- 函数名起始字母为大写，不能包含dots，如 `FunctionName`


### 间隔和间距

- 所有的二元运算符（=, +, -, <-, etc.）两端均需要有空格。
- 不要在逗号前增加空格，但逗号后必须有一个

比如：

	tab.prior <- table(df[df$days.from.opt < 0, "campaign.id"])
	total <- sum(x[, 1])
	total <- sum(x[1, ])

- 在左括号前应增加空格，除了 function call 情况

```
	# GOOD: 
	if (debug)

	# BAD: 
	if(debug)
```

- 多余的空格是允许的，比如为了对齐增加可读性：

	plot(x    = x.coord,
	     y    = data.mat[, MakeColName(metric, ptiles[1], "roiOpt")],
	     ylim = ylim,
	     xlab = "dates",
	     ylab = metric,
	     main = (paste(metric, " for 3 samples ", sep = "")))

### 大括号

左大括号不能独立成行，右大括号必须独立成行（除else情况），比如

	if (is.null(ylim)) {
	  ylim <- c(0, 0.06)
	}
	
else情况的标准写法：

	if (condition) {
	  one or more lines
	} else {
	  one or more lines
	}

### 行长度

不应超过80个字符

### 缩进

严格使用两个空格，不能使用 tabs

### 赋值

尽量使用 `<-`，而不要使用 `=`

### 一般性声明

如果我们遵循一致的声明，对代码的阅读和理解会更快更准确。这里包含

	1. Copyright statement comment
	2. Author comment
	3. File description comment, including purpose of program, inputs, and outputs
	4. source() and library() statements
	5. Function definitions
	6. Executed statements, if applicable (e.g., print, plot)

### 注释

- 一定要注意在代码间增加你的注释。长注释以 # 开始，后跟一个空格
- 短注释发生在代码后，两个空格间隔，# 开始，后跟一个空格

```
	# Create histogram of frequency of campaigns by pct budget spent.
	hist(df$pct.spent,
	     breaks = "scott",  # method for choosing number of buckets
	     main   = "Histogram: fraction budget spent by campaignid",
	     xlab   = "Fraction of budget spent",
	     ylab   = "Frequency (count of campaignids)")
```

### 函数定义

- 函数的定义，优先无默认参数值的参数，有参数值的参数在后。
- 每行一个参数是允许的，但有参数值的赋值不能断开。

```
	# GOOD:
	PredictCTR <- function(query, property, num.days,
	                       show.plot = TRUE)
	# BAD:
	PredictCTR <- function(query, property, num.days, show.plot =
	                       TRUE)
```

### 函数文档

- 函数在定义完成之后需要紧跟注释内容
- 注释内容包含一句话对函数的描述，每个参数（arguments）的描述，用 `Args` 表示；以及返回值的描述，用 `Returns` 表示。
- 注释必须非常清楚，调用者可以不用读后续任何代码就可直接调用。

示例：

```
	CalculateSampleCovariance <- function(x, y, verbose = TRUE) {
	  # Computes the sample covariance between two vectors.
	  #
	  # Args:
	  #   x: One of two vectors whose sample covariance is to be calculated.
	  #   y: The other vector. x and y must have the same length, greater than one,
	  #      with no missing values.
	  #   verbose: If TRUE, prints sample covariance; if not, not. Default is TRUE.
	  #
	  # Returns:
	  #   The sample covariance between x and y.
	  n <- length(x)
	  # Error handling
	  if (n <= 1 || n != length(y)) {
	    stop("Arguments x and y have different lengths: ",
	         length(x), " and ", length(y), ".")
	  }
	  if (TRUE %in% is.na(x) || TRUE %in% is.na(y)) {
	    stop(" Arguments x and y must not have missing values.")
	  }
	  covariance <- var(x, y)
	  if (verbose)
	    cat("Covariance = ", round(covariance, 4), ".\n", sep = "")
	  return(covariance)
	}
```

### TODO注释

用于指明临时代码、短期解决方案或足够好但还不够完美的地方。username处写的是了解该问题详细情况的人的名字，并不是指实际解决该问题的人。因此，当你建立一个TODO时，写上你自己的名字就可以了。
例如:

```
	# TODO(liusizhe): Remove this code after the NewService has been checked in.
```

## R语言规范

### attach

避免使用它

### 对象和方法

- 在S语言体系下有两套对象的定义，S3和S4，且都可以在R中使用。
- S3体系的方法更加灵活、交互性更好，S4更加正式和严格。两套体系方法可以参考[这里](https://cran.r-project.org/doc/Rnews/Rnews_2004-1.pdf) 
- 尽量使用S3体系，除非有足够的理由使用S4
- 绝对要避免混合使用 S3 和 S4 的情况


