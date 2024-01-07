---
layout: post
title: 在 R 中实现流程图
category: 不务正业的 R
tags: 
- 流程图
status: publish
type: post
published: true
---

> 以下请忽视，流程图最好工具是 [plantuml](www.plantuml.com)，支持对象图、组件图、状态图、用例图等

一般来说，流程图大家比较习惯用 MS 的visio 来实现，或退而求其次使用 MS word 或 <a rel="nofollow" href="http://pcwin.com/Business___Finance/FlowBreeze_Standard_Flowchart_Software/screen.htm" target="_blank">Excel</a> 也可以实现相同功能。其实流程图是一种很简单的图形模式，R 的diagram 包也提供了 Flow Chart 功能，只不过使用命令行来实现：

```r
library(diagram)
pos <- coordinates(pos = c(3, 3, 3, 3, 3, 3))
cc <- c("Start", LETTERS[2:16], "End")
openplotmat(main = "Flow Chart")
for (i in seq(1, 15, by = 3))
  straightarrow(from = pos[i, ] , to = pos[i + 3, ])
for (i in c(2, 5, 8))
  straightarrow(from = pos[i, ] , to = pos[i + 6, ])
segmentarrow(
  from = pos[16, ],
  to = pos[2, ],
  path = "RVL",
  dd = 0.15
)
bentarrow(from = pos[8, ], to = pos[6, ], path = 'H')
bentarrow(from = pos[6, ], to = pos[2, ], path = 'V')
straightarrow(from = pos[14, ], to = pos[17, ])
for (i in c(2, 7, 13, 14, 16))
  textrect(pos[i, ],
           radx = 0.08,
           rady = 0.04,
           lab = cc[i])
for (i in c(1, 17))
  textround(pos[i, ],
            radx = 0.08,
            rady = 0.04,
            lab = cc[i])
textdiamond(
  mid = pos[8, ],
  radx = 0.15,
  rady = 0.08,
  lab = c("Has", "Detect?")
)
textmulti(
  mid = pos[4, ],
  radx = 0.1,
  rady = 0.05,
  nr = 6
)
textmulti(
  mid = pos[6, ],
  radx = 0.1,
  rady = 0.05,
  nr = 5
)
textellipse(mid = pos[10, ], radx = 0.1, rady = 0.05)
text(pos[8, 1] + 0.2, pos[8, 2] + 0.03, "YES", cex = 0.8)
text(pos[11, 1] + 0.04, pos[11, 2], "NO", cex = 0.8)
```

以上代码呈现的结果是这样的：

<img src="https://pic-1300049111.cos.ap-beijing.myqcloud.com/img/20201227180020.png"/>
