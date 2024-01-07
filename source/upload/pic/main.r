setwd('D:/doc/image/me')
library(ReadImages)
library(sqldf)
me <- read.jpeg('fun.jpg')
meid <- data.frame(z = 1:1200, y = as.numeric(me))
meid <- sqldf('select * from meid order by y')

setwd('D:/doc/image/others')
tmp <- NULL
for(i in dir()) tmp[[i]] <- read.jpeg(i)
id <- sapply(tmp, mean)
id <- data.frame(n = names(id), m = id)
id <- sqldf('select * from id order by m')
idx <- cbind(id, meid)
idx <- sqldf('select * from idx order by z')

setwd('D:/doc/image')
png('me.png', height = 1000, width = 750)
par(mfcol = c(40,30), mar = rep(0,4), xpd = NA)
for(i in idx$n) plot(tmp[[i]])
dev.off()

## ´¦ÀíÍ¼Æ¬ ##
setwd('D:/doc/image/others')
shell("convert *.jpg  -crop 120x120+10+5 thumbnail%03d.png")
shell("del *.jpg")
shell("convert -type Grayscale *.png thumbnail%03d.png")