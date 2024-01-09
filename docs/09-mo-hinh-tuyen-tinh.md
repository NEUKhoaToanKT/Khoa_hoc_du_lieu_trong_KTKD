---
output:
  pdf_document: default
  html_document: default
---

```r
library(readxl)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(knitr)
library(kableExtra)
```

```
## 
## Attaching package: 'kableExtra'
```

```
## The following object is masked from 'package:dplyr':
## 
##     group_rows
```

```r
library(ggplot2)
library(forcats)
library(ggpubr)
library(grid)
library(gridExtra)
```

```
## 
## Attaching package: 'gridExtra'
```

```
## The following object is masked from 'package:dplyr':
## 
##     combine
```

```r
library(forcats)
library(pryr)
```

```
## 
## Attaching package: 'pryr'
```

```
## The following object is masked from 'package:dplyr':
## 
##     where
```


```r
colorize <- function(x, color) {
 if (knitr::is_latex_output()) {
 sprintf("\\textcolor{%s}{%s}", color, x)
 } else if (knitr::is_html_output()) {
 sprintf("<span style='color: %s;'>%s</span>", 
 color,
 x)
 } else x
}
```

# Mô hình hồi quy tuyến tính

## Mô hình hổi quy tuyến tính đơn

## Mô hình hồi quy tuyến tính đa biến

## Những cân nhắc khi xây dựng mô hình hồi quy tuyến tính

## Mở rộng mô hình hồi quy tuyến tính

## Thực hành: Xây dựng mô hình hổi quy tuyến tính cho dữ liệu Sales

## Thực hành: Mô hình hổi quy tuyến tính mở rộng






<!-- # REFERENCE -->

<!-- ### Source from thesis -->

<!-- **1.** Chen, Chun-houh, Wolfgang Karl Härdle, and Antony Unwin, eds (2007). *Handbook of data visualization.* \ -->
<!-- **2.** Aparicio, Manuela, and Carlos J. Costa. (2015). *Data visualization - Communication design quarterly review.* \ -->
<!-- **3.** Hadley Wickham. (2010). *A Layered Grammar of Graphics.* \ -->

<!-- ### Souce from website -->

<!-- **4.** [https://www.tableau.com/learn/articles/data-visualization](https://www.tableau.com/learn/articles/data-visualization) \ -->
<!-- **5.** [https://www.r-graph-gallery.com/ggplot2-package.html](https://www.r-graph-gallery.com/ggplot2-package.html) \ -->
<!-- **6.** [http://r-statistics.co/ggplot2-Tutorial-With-R.html](http://r-statistics.co/ggplot2-Tutorial-With-R.html) \ -->
<!-- **7.** [https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf](https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf) \ -->
<!-- **8.** [https://www.kaggle.com/](https://www.kaggle.com/) \ -->
