--- 
title: "Sách về khoa học dữ liệu"
author: "Lã Minh Hiếu"
date: "2024-07-04"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: rstudio/bookdown-demo
description: "Đây là một quyển sách tốt"
---

# Prerequisites

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
 
This is a _sample_ book written in **Markdown**. You can use anything that Pandoc's Markdown supports, e.g., a math equation $a^2 + b^2 = c^2$.

The **bookdown** package can be installed from CRAN or Github:


```r
install.packages("bookdown")
# or the development version
# devtools::install_github("rstudio/bookdown")
```

Remember each Rmd file contains one and only one chapter, and a chapter is defined by the first-level heading `#`.

To compile this example to PDF, you need XeLaTeX. You are recommended to install TinyTeX (which includes XeLaTeX): <https://yihui.name/tinytex/>.


