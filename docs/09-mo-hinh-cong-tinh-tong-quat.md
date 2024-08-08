---
output:
  pdf_document: default
  html_document: default
---

``` r
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

``` r
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

``` r
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

``` r
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

``` r
library(RColorBrewer)
library(mvtnorm)
library(caret)
```

```
## Loading required package: lattice
```

``` r
library(latex2exp)
library(gam)
```

```
## Loading required package: splines
```

```
## Loading required package: foreach
```

```
## Loaded gam 1.22-3
```

``` r
colorize_style = function(x, color = "#640514", font = "Source Code Pro", style = NULL) {
  apply_style = function(text, style) {
    if (!is.null(style)) {
      if (style == "bold") {
        text = sprintf("\\textbf{%s}", text)
      }else if (style == "it") {
      text = sprintf("\\textit{%s}", text)
      }else if (style == "under") {
      text = sprintf("\\underline{%s}", text)
      }
    }
    return(text)
  }
  if(knitr::is_latex_output()){
    x = apply_style(x, style)
    if (!is.null(font)) {
      sprintf("\\textcolor{%s}{\\textsf{%s}{%s}}", color, font, x)
    }else {
      sprintf("\\textcolor{%s}{%s}", color, x)
    }
  }else if (knitr::is_html_output()){
    if(!is.null(style)){
      if(style == "bold"){
        x = sprintf("<strong>%s</strong>", x)
      }else if (style == "it"){
        x = sprintf("<em>%s</em>", x)
      }else if (style == "under"){
        x = sprintf("<span style='text-decoration: underline;'>%s</span>", x)
      }
    }
    if (!is.null(font)){
    sprintf("<span style='color: %s; font-family: %s;'>%s</span>", color, font, x)
    }else{
    sprintf("<span style='color: %s;'>%s</span>", color, x)
    }
  }else{
  x
  }
}
```


# Các mô hình cộng tính tổng quát
Trong chương trước, chúng ta đã nghiên cứu về mô hình hồi quy tuyến tính. Đây là lớp các mô hình tương đối đơn giản để hiểu và thực hiện, đồng thời có ưu điểm hơn các phương pháp tiếp cận khác do dễ dàng diễn giải và suy luận. Tuy nhiên, các mô hình hồi quy tuyến tính thông thường có thể có những hạn chế về khả năng dự đoán. Điều này là do giả định tuyến tính hiếm khi xảy ra trong dữ liệu thực tế. Chúng ta cũng đã nghiên cứu một vài phương pháp để có thể cải thiện khả năng dự báo của các mô hình tuyến tính bằng cách sử dụng hồi quy *ridge*, hay *Lasso* ..., mà trong đó, khả năng dự báo được cải thiện bằng cách giảm bậc tự do của mô hình tuyến tính với mục đích giảm phương sai của mô hình. Tuy nhiên, các phương pháp cải thiện mô hình đó vẫn giữ nguyên giả thuyết tuyến tính.

Trong chương này, chúng tôi sẽ từng bước nới lỏng giả định tuyến tính trong xây dựng mô hình trong khi vẫn cố gắng duy trì khả năng diễn giải nhiều nhất có thể bằng cách giữ nguyên nguyên tắc cộng tính trong xây dựng mô hình. Chúng ta sẽ bắt đầu chương sách này với các mở rộng đơn giản của các mô hình tuyến tính bao gồm hồi quy đa thức, hồi quy theo hàm bậc thang, sau đó chuyển sang các phương pháp phức tạp hơn như spline, hồi quy cục bộ và sau cùng là mô hình cộng tính tổng quát.

Dữ liệu chúng tôi sử dụng để minh họa các mô hình là dữ liệu về giá nhà tại Boston trong thư viện MASS. Bạn đọc tham khảo mô tả dữ liệu trên R hoặc xem lại chương mô hình tuyến tính để hiểu thêm về dữ liệu.

## Hồi quy splines
Khi thảo luận về xây dựng mô hình tuyến tính, chúng tôi đã đề cập đến vấn đề khi tồn lại mối liên hệ phi tuyến giữa biến mục tiêu và biến giải thích. Một phương pháp giải quyết vấn đề này là mở rộng hồi quy tuyến tính mà trong đó biến mục tiêu được mô tả thông qua biến giải thích và các hàm mũ của biến đó, hay nói một cách khác là được mô tả bằng một đa thức của biến giải thích. Ví dụ như chúng ta thay thế mô hình tuyến tính đơn biến
\begin{align}
y_i = \beta_0 + \beta_1 \cdot x_i + \epsilon_i
\end{align}
bằng một mô hình hồi quy đa thức
\begin{align}
y_i = \beta_0 + \beta_1 \cdot x_i + \beta_2 \cdot x_i^2 + \cdots + \beta_d \cdot x_i^d + \epsilon_i
(#eq:gam001)
\end{align}
với $\epsilon_i$ là phần dư và $d$ là bậc của đa thức. Khi bậc của đa thức $d$ là lớn, đa thức sẽ có càng nhiều điểm uốn và độ cong đủ lớn để mô tả các mối liên hệ phi tuyến. Lưu ý rằng các hệ số trong \@ref(eq:gam001) có thể được ước lượng dễ dàng bằng cách sử dụng phương pháp bình phương nhỏ nhất vì đây là mô hình tuyến tính thông thường với các biến giải thích $x_i, x_i^2, \cdots , x_i^d$. Khi sử dụng hồi quy đa thức cần lưu ý là khi sử dụng bậc của đa thức quá lớn, ví dụ như $d \geq 4$, thì đa thức sẽ có hình dạng khá kỳ lạ tại các điểm giới hạn của biến giải thích. Các điểm giới hạn bao gồm các điểm dữ liệu rất nhỏ và rất lớn của biến giải thích. 

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam01-1.png" alt="Hồi quy đa thức biến giá nhà (nghìn USD) theo biến tỷ lệ người sống dưới mức trung bình (%) trên dữ liệu Boston. Hình bên trái: sử dụng đa thức bậc ba. Hình ở giữa: sử dụng đa thức bậc bốn. Hình bên phải: sử dụng đa thức bậc năm" width="768" />
<p class="caption">(\#fig:fggam01)Hồi quy đa thức biến giá nhà (nghìn USD) theo biến tỷ lệ người sống dưới mức trung bình (%) trên dữ liệu Boston. Hình bên trái: sử dụng đa thức bậc ba. Hình ở giữa: sử dụng đa thức bậc bốn. Hình bên phải: sử dụng đa thức bậc năm</p>
</div>

Hình \@ref(fig:fggam01) mô tả mô hình hồi quy đa thức trong đó biến mục tiêu là giá nhà (nghìn USD) theo biến tỷ lệ người sống dưới mức trung bình (%) trên dữ liệu về giá nhà tại Boston. Hình bên trái cho thấy sử dụng đa thức bậc ba mô tả khá đầy đủ hình dạng mối liên hệ tuyến tính giữa hai biến: giá nhà có xu hướng giảm tại các khu vực có tỷ lệ người sống dưới mức trung bình lớn. Tốc độ giảm của giá nhà theo biến giải thích có sự khác biệt, giá nhà giảm nhanh khi tỷ lệ sống dưới mức trung bình tăng từ 5\% lên 15\%, tốc độ giảm chậm dần khi biến giải thích nhận giá trị trong khoảng 15\% đến 25\%, sau đó tốc độ giảm của giá nhà lại tăng khi tỷ lệ sống dưới mức trung bình cao hơn 25\%. Hình ở giữa trong Hình \@ref(fig:fggam01) sử dụng đa thức bậc bốn. Bạn đọc có thể nhận thấy ngay rằng đa thức bậc bốn là không phù hợp để mô tả mối liên hệ giữa biến mục tiêu và biến giải thích khi hàm số có giá trị tăng trên khoảng tỷ lệ sống dưới mức trung bình cao hơn 30\%. Hình bên phải trong Hình \@ref(fig:fggam01) sử dụng đa thức bậc năm để mô tả mối liên hệ giữa giá nhà và tỷ lệ sống dưới mức trung bình. Không có sự khác biệt nhiều giữa đa thức bậc ba và đa thức bậc năm trong miền 5\% đến 30\%, tuy nhiên đa thức bậc năm lại cho hình dạng kỳ lạ khi biến giải thích lớn hơn 25\%!

Nhìn chung, kinh nghiệm cho thấy rằng sử dụng đa thức bậc lớn hơn ba trong hồi quy đa thức thường không đem lại hiệu quả trong mô tả dữ liệu. Thay vì tăng bậc của đa thức để giải thích tốt hơn mối liên hệ giữa biến mục tiêu và biến giải thích, những người xây dựng mô hình sử dụng một dạng hàm $f(x)$ mà với mỗi khoảng giá trị khác nhau của $x$ hàm $f$ là một đa thức khác nhau. Nói một cách khác, mối liên hệ giữa $Y$ và $X$ được mô tả bằng một *splines*. Thay vì tăng bậc cho đa thức bậc ba:
\begin{align}
y_i = \beta_0 + \beta_1 \cdot x_i + \beta_2 \cdot x_i^2 +\beta_3 \cdot x_i^3 + \epsilon_i
(#eq:gam002)
\end{align}
chúng ta có thể thay thế bằng cách hồi quy hai đa thức bậc ba trên hai miền giá trị khác nhau của $x_i$
\begin{align}
y_i = \begin{cases} 
\beta_{01} + \beta_{11} \cdot x_i + \beta_{21} \cdot x_i^2 +\beta_{31} \cdot x_i^3 + \epsilon_i \text{ nếu } x_i < c \\
\beta_{02} + \beta_{12} \cdot x_i + \beta_{22} \cdot x_i^2 +\beta_{32} \cdot x_i^3 + \epsilon_i \text{ nếu } x_i \geq c \\
\end{cases}
(#eq:gam003)
\end{align}

Chúng ta chia dữ liệu thành hai phần: phần dữ liệu thứ nhất bao gồm các quan sát có $x_i < c$ và phần dữ liệu thứ hai bao gồm các quan sát có $xi \geq c$. Đa thức bậc ba thứ nhất có các hệ số $\beta_{01}$, $\beta_{11}$, $\beta_{21}$ và $\beta_{31}$ được ước lượng trên phần dữ liệu thứ nhất và đa thức bậc ba thứ hai có các hệ số $\beta_{02}$, $\beta_{12}$, $\beta_{22}$ và $\beta_{32}$ được ước lượng trên phần dữ liệu thứ hai. Cả hai đa thức đều có thể được ước lượng bằng cách sử dụng phương pháp bình phương nhỏ nhất giống như trong hồi quy đa biến. Điểm $c$ chia dữ liệu làm hai miền được gọi là một nút hay một điểm cắt. Việc sử dụng nút sẽ giúp cho mô hình linh hoạt hơn là tăng bậc của đa thức và sử dụng càng nhiều nút sẽ càng làm cho hàm $f$ trở nên linh hoạt. Nếu chúng ta sử dụng $k$ nút khác nhau trên miền giá trị của biến $X$ thì chúng ta có $k+1$ miền dữ liệu và tương ứng là $k+1$ đa thức cần ước lượng. Lưu ý rằng chúng ta không nhất thiết phải sử dụng đa thức bậc ba. Thay vào đó chúng ta có thể sử dụng các hàm tuyến tính hoặc đa thức bậc hai, hoặc thậm chí là một hằng số (đa thức bậc không) trên từng phần của dữ liệu.



Hình \@ref(fig:fggam02) mô tả sử dụng hồi quy đa thức các đa thức bậc khác nhau trên từng phần dữ liệu. Mặc dù đã hạn chế được hình dạng kỳ lạ của tại các điểm giới hạn của biến $X$, nhưng bạn đọc có thể nhận thấy ngay vấn đề: các đa thức có giá trị không liên tục tại điểm cắt và nếu chúng ta sử dụng hai đa thức bậc ba, sẽ có tổng số tám tham số hay tám bậc tự do để mô tả mối liên hệ giữa biến mục tiêu và biến giải thích. Một cách tổng quát, nếu chúng ta sử dụng $k$ nút, và các đa thức từng phần đều là các đa thức bậc ba, thì sẽ có tổng số $4 \times (k+1)$ tham số cần được ước lượng. Việc này rất dễ dẫn đến hiện tượng mô hình khớp quá mức.

Để khắc phục vấn đề giá trị của các đa thức không liên tục tại các điểm cắt, trong quá trình ước lượng tham số chúng ta có thể thêm vào rằng buộc là giá trị của các đa thức tại các điểm cắt phải bằng nhau. Ngoài ràng buộc giá trị của đa thức bằng nhau tại nút $c$, người xây dựng mô hình còn thêm các rằng buộc về sự liên tục của đạo hàm bậc một và đạo hàm bậc hai của các đa thức. Nói cách khác ước lượng các tham số $\beta_{01}$, $\beta_{11}$, $\beta_{21}$ và $\beta_{31}$ của đa thức thứ nhất và các tham số $\beta_{02}$, $\beta_{12}$, $\beta_{22}$ và $\beta_{32}$ của đa thức thứ hai trở thành bài toán tối ưu:
\begin{align}
\hat{\boldsymbol{\beta}} = \underset{\boldsymbol{\beta}}{\operatorname{argmin}} \sum\limits_{i=1}^n \left[\mathbb{I}_{\{x_i < c\}} \left(y_i - \beta_{01} - \beta_{11} \cdot x_i - \beta_{21} \cdot x_i^2 - \beta_{31} \cdot x_i^3 \right)^2 + \\
 \ \ \ \ \ \ \ \ \  \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \mathbb{I}_{\{x_i \geq c\}} \left(y_i - \beta_{02} - \beta_{12} \cdot x_i - \beta_{22} \cdot x_i^2 - \beta_{32} \cdot x_i^3 \right)^2 \right]
\end{align}
với các ràng buộc
\begin{align}
& \beta_{01} + \beta_{11} \cdot c + \beta_{21} \cdot c^2 +\beta_{31} \cdot c^3 = \beta_{02} + \beta_{12} \cdot c + \beta_{22} \cdot c^2 +\beta_{32} \cdot c^3 \\
& \beta_{11}  + 2 \beta_{21} \cdot c + 3 \beta_{31} \cdot c^2 = \beta_{12} + 2 \beta_{22} \cdot c +3 \beta_{32} \cdot c^2 \\
& 2 \beta_{21} + 6 \beta_{31} \cdot c = 2 \beta_{22}  + 6 \beta_{32} \cdot c 
(#eq:gam004)
\end{align}

Mỗi ràng buộc mà chúng ta áp đặt lên các đa thức bậc ba sẽ làm số lượng tham số, hay bậc tự do của mô hình, giảm đi một bậc tự do. Điều này cũng đồng nghĩa với việc giảm đi sự phức tạp của mô hình và tránh được hiện tượng mô hình khớp quá mức. Với ba ràng buộc trong phương trình \@ref(eq:gam004) bao gồm ràng buộc về sự liên tục của đa thức, của đạo hàm bậc nhất và của đạo hàm bậc hai, mô hình sẽ còn năm bậc tự do. Hàm số được xây dựng trên cơ sở các đa thức từng phần bậc $d$ với các ràng buộc về sự liên tục của đạo hàm đến bậc $d-1$ tại các nút được gọi chung là các *splines* bậc $d$. Về lý thuyết bạn đọc có thể chọn $d \geq 4$ nhưng kinh nghiệm cho thấy bậc của *splines* không nên vượt quá $d = 3$. Nếu muốn tăng sự phức tạp cho *splines*, giải pháp là tăng số nút chứ không nên tăng bậc. Trong trường hợp tổng quát, một *splines* bậc ba với $k$ nút sẽ có $4 \times (k+1)$ tham số cần được ước lượng, đồng thời có $3 \times k$ ràng buộc tại $k$ nút, do đó số bậc tự do sẽ là $k + 4$. Để ước lượng tham số của *splines*, chúng ta không giải bài toán tối ưu có ràng buộc như phương trình \@ref(eq:gam004) mà thực hiện biến đổi tham số và sau đó sử dụng phương pháp bình phương nhỏ nhất thông thường. Bạn đọc tham khảo phần \@ref(gamapen1) để hiểu về cách biến đổi tham số. 

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam03-1.png" alt="Hồi quy giá nhà (medv) theo splines bậc ba của biến giải thích là tỷ lệ người sống dưới mức trung bình (lstat) trong dữ liệu Boston. Hình bên trái: sử dụng một nút tại 15%. Hình bên phải: sử dụng hai nút tại 10% và 20%" width="672" />
<p class="caption">(\#fig:fggam03)Hồi quy giá nhà (medv) theo splines bậc ba của biến giải thích là tỷ lệ người sống dưới mức trung bình (lstat) trong dữ liệu Boston. Hình bên trái: sử dụng một nút tại 15%. Hình bên phải: sử dụng hai nút tại 10% và 20%</p>
</div>

Hình \@ref(fig:fggam03) mô tả mô hình hồi quy *splines* giá nhà theo tỷ lệ người sống dưới mức trung bình trên dữ liệu Boston. Hình bên trái mô tả biến mục tiêu là một *splines* bậc ba với một nút duy nhất là $c = 15\%$; Hình bên phải mô tả *splines* bậc ba với hai nút là $c_1 = 10\%$ và $c_2 = 20\%$. Với các ràng buộc về sự liên tục của các đa thức và đạo hàm đến bậc hai tại các nút, không thể nhận ra sự khác biệt của các đa thức tại các nút. 

Khi xây dựng một *splines*, chúng ta cần trả lời câu hỏi là nên đặt bao nhiêu nút hoặc đặt các nút ở đâu? Tại sao trong ví dụ kể trên chúng ta lại sử dụng một nút tại 15%, hay sử dụng hai nút tại 10% và 20% ? Và sau cùng là giữa các cách đặt nút như vậy thì cách nào tối ưu hơn. Trước hết, có thể thấy rằng đường hồi quy linh hoạt hơn ở những khoảng giá trị có nhiều nút vì ở những khoảng giá trị đó hệ số đa thức có thể thay đổi nhanh chóng. Do đó, một gợi ý cho việc đặt nút là nên cho nhiều nút hơn ở những nơi mà chúng ta nhận thấy hàm số có thể thay đổi nhanh nhất và đặt ít nút thắt hơn ở những nơi có vẻ ổn định hơn. Hướng tiếp cận này khá cảm tính và đòi hỏi người xây dựng mô hình cần có nhiều kinh nghiệm. 

Một tiếp cận khác khi đặt nút là dựa theo các quantile của biến giải thích. Khi đặt $k$ nút $c_1 < c_2 < \cdots < c_k$, nút $c_j$ sẽ là giá trị quantile tương ứng với mức xác suất $\frac{j}{k+1}$, hay nói một cách khác, có $\frac{n \times j}{k+1}$ quan sát của biến giải thích nhỏ hơn $c_j$ và $\frac{n\times(k+1-j)}{k+1}$ quan sát của biến giải thích lớn hơn $c_j$ với $n$ là số lượng quan sát.

Không có câu trả lời chính xác cho câu hỏi là cần đặt bao nhiêu nút khi xây dựng *splines*. Kinh nghiệm cho thấy rằng sử dụng xác thực chéo để lựa chọn số lượng nút thường cho lựa chọn tốt. Tham số $k$ tương ứng với sai số xác thực chéo nhỏ nhất sẽ là số nút tối ưu. Tuy nhiên xác thực chéo chỉ có thể thực hiện khi có một hoặc một vài biến giải thích. Khi chúng ta xây dựng mô hình mà biến mục tiêu phụ thuộc vào một số lượng lớn biến giải thích, sử dụng xác thực chéo để lựa chọn số lượng nút cho từng biến giải thích sẽ yêu cầu khối lượng tính toán tăng nhanh theo hàm mũ.

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam04-1.png" alt="Lựa chọn số nút tối ưu bằng xác thực chéo khi hồi quy giá nhà (medv) theo splines của biến giải thích là tỷ lệ số người có mức sống dưới mức trung bình (lstat). Tham số của xác thực chéo (số folds) được lựa chọn là K = 5. Hình bên trái sử dụng splines bậc hai. Hình bên phải sử dụng splines bậc ba." width="672" />
<p class="caption">(\#fig:fggam04)Lựa chọn số nút tối ưu bằng xác thực chéo khi hồi quy giá nhà (medv) theo splines của biến giải thích là tỷ lệ số người có mức sống dưới mức trung bình (lstat). Tham số của xác thực chéo (số folds) được lựa chọn là K = 5. Hình bên trái sử dụng splines bậc hai. Hình bên phải sử dụng splines bậc ba.</p>
</div>

Hình \@ref(fig:fggam04) mô tả cách lựa chọn số nút cho mô hình hồi quy biến mục tiêu giá nhà theo splines của biến giải thích là tỷ lệ số người có mức sống dưới trung bình bằng cách sử dụng xác thực chéo. Chúng tôi sử dụng xác thực chéo với tham số $K$ bằng 5. Nếu splines có bậc hai, số lượng nút cho sai số xác thực chéo nhỏ nhất là $k = 8$. Còn khi splines có bậc ba, số lượng nút cho sai số của xác thực chéo nhỏ nhất là $k=5$. Có thể giải thích là khi bậc của splines nhỏ hơn, các đa thức từng phần sẽ ít linh hoạt hơn, do đó cần số nút lớn hơn để mô tả tốt mối liên hệ phi tuyến giữa biến mục tiêu và biến giải thích. 

Khái niệm cuối cùng mà chúng tôi muốn giới thiệu đến bạn đọc trước khi chuyển sang phần chính của chương là khái niệm về *natural splines*. Bạn đọc có thể nhận thấy rằng với hầu hết các dữ liệu, tại các giá trị giới hạn của biến giải thích, mật độ của các điểm dữ liệu thường khá thưa thớt. Do đó nếu sử dụng các đa thức bậc lớn hơn hoặc bằng hai để mô tả mối liên hệ giữa biến mục tiêu và biến giải thích có thể dẫn đến các đường cong có hình dạng kỳ lạ. Để tránh gặp phải tình trạng như vậy, người xây dựng mô hình sẽ thêm vào các rằng buộc rằng đa thức phải có bậc một tại các giá trị giới hạn của biến giải thích. Nói một cách khác, hàm $f$ phải là hàm tuyến tính trong các vùng biến giải thích $X$ nhỏ hơn nút nhỏ nhất và $X$ lớn hơn nút lớn nhất. *Natural splines* đơn giản là một *splines* với ràng buộc tuyến tính tại các giá trị giới hạn của biến giải thích. Ràng buộc bổ sung này giúp cho hàm $f$ tự nhiên hơn và tạo ra các ước tính ổn định hơn ở điểm biên. 

Sử dụng *natural splines* dựa trên đa thức bậc ba thay thế cho Splines bậc ba sẽ giúp giải phóng bốn bậc tự do vì ở mỗi vùng giới hạn chúng ta giảm đi hai tham số. Nói một cách khác, *natural splines* bậc ba sẽ có $(k+4)-4 = k$ tham số. Ước lượng tham số cho *natural splines* không được thực hiện thông qua giải bài toán tối ưu mà được thông qua phép biến đổi tham số giống như khi ước lượng tham số cho *splines*. Bạn đọc tham khảo chi tiết tại \@ref(gamapen2).

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam05-1.png" alt="So sánh giữa splines thông thường và natural splines khi sử dụng véc-tơ các nút giống nhau. Hình bên trái: Giá nhà tại Boston là một splines bậc ba theo tỷ lệ sống dưới mức trung bình; splines sử dụng 5 nút tại các giá trị quantile tương ứng với các mức xác suất 1/6, 2/6, 3/6, 4/6, 5/6 của biến giải thích. Hình bên phải: Giá nhà tại Boston là một natural splines; splines sử dụng 5 nút tại các giá trị quantile tương ứng với các mức xác suất 1/6, 2/6, 3/6, 4/6, 5/6 của biến giải thích." width="672" />
<p class="caption">(\#fig:fggam05)So sánh giữa splines thông thường và natural splines khi sử dụng véc-tơ các nút giống nhau. Hình bên trái: Giá nhà tại Boston là một splines bậc ba theo tỷ lệ sống dưới mức trung bình; splines sử dụng 5 nút tại các giá trị quantile tương ứng với các mức xác suất 1/6, 2/6, 3/6, 4/6, 5/6 của biến giải thích. Hình bên phải: Giá nhà tại Boston là một natural splines; splines sử dụng 5 nút tại các giá trị quantile tương ứng với các mức xác suất 1/6, 2/6, 3/6, 4/6, 5/6 của biến giải thích.</p>
</div>
Bạn đọc có thể nhận thấy từ Hình \@ref(fig:fggam05) rằng *natural splines* sẽ cho kết quả là một hàm tuyến tính tại các vùng mà biến giải thích lớn hơn nút nhỏ nhất hoặc lớn hơn nút lớn nhất. Không có sự khác biệt nhiều giữa splines thông thường và natural splines trong khoảng biến giải thích nhỏ hơn nút nhỏ nhất, tuy nhiên có sự khác biệt rõ ràng trong vùng biến giải thích lớn hơn nút lớn nhất. Trong vùng này, *splines* thông thường cho thấy xu thế giảm nhanh sau đó đi ngang và cuối cùng là đi lên khi biến giải thích tăng dần. Trong khi đó khi sử dụng *natural splines* chỉ có một xu thế duy nhất là giảm tại vùng giá trị giới hạn này. Cần dựa trên sai số khi thực hiện xác thực chéo để biết mô hình nào tốt hơn thay vì dựa trên các nhận xét cảm tính, tuy nhiên chắc chắn rằng mô hình được xây dựng từ *natural spline* sẽ cho dự đoán ổn định hơn, hay nói một cách khác là có phương sai nhỏ hơn so với splines thông thường. 

Trong phần tiếp theo, chúng ta sẽ thảo luận về một hướng tiếp cận khác khi xây dựng mô hình mô tả mối liên hệ phi tuyến giữa biến mục tiêu và biến giải thích nhưng cũng cho kết quả là một *splines*. Kết quả này còn được biết đến với tên gọi là *smoothing* *splines*.

## Smoothing splines
Trong các phần trước, chúng ta đã thảo luận về cách xây dựng các đường hồi quy phi tuyến tính được tạo ra bằng cách sử dụng một tập hợp các nút của biến giải thích và các đa thức bậc $d$ trên các vùng được xác định bởi các nút. Tham số của các đường hồi quy phi tuyến được ước lượng bằng phương pháp bình phương nhỏ nhất sau khi thực hiện phép biến đổi tham số. Trong phần này, chúng tôi giới thiệu một cách tiếp cận khác nhưng cũng cho kết quả là một splines. Một cách tổng quát, mục tiêu khi chúng ta muốn xây dựng hàm số mô tả mối liên hệ giữa biến mục tiêu $Y$ và biến giải thích $X$, tạm gọi là hàm $f$, để phù hợp tối đa với dữ liệu được quan sát: nghĩa là chúng ta muốn

\begin{align}
RSS = \sum\limits_{i=1}^n (y_i − f(x_i))^2
\end{align}

càng nhỏ càng tốt. Tuy nhiên, nếu chúng ta không đặt bất kỳ ràng buộc nào lên hàm $f$ thì chúng ta luôn có thể làm cho *RSS* bằng 0 bằng cách chọn $f$ đủ phức tạp sao cho $f(x_i) = y_i \ \forall i$. Một hàm $f$ như vậy sẽ quá phù hợp với dữ liệu huấn luyện mô hình nhưng sẽ không cho kết quả tốt trên dữ liệu kiểm thử mô hình. Hàm $f$ mà chúng ta thực sự cần xây dựng là một hàm làm cho *RSS* nhỏ nhưng cũng cần có sự ràng buộc về sự linh hoạt của hàm $f$. Đường hồi quy được xây dựng trong Hình \@ref(fig:fggam06) mô tả một hàm $f$ quá khớp với dữ liệu huấn luyện mô hình. Rất khó để các hàm như vậy có thể cho kết quả tốt cho kết quả tốt trên dữ liệu kiểm tra mô hình do phương sai của hàm $f$ là quá lớn.

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam06-1.png" alt="Xây dựng hàm f quá linh hoạt. Sai số trên tập huấn luyện mô hình sẽ nhỏ nhưng sai số trên dữ liệu kiểm tra mô hình sẽ lớn." width="672" />
<p class="caption">(\#fig:fggam06)Xây dựng hàm f quá linh hoạt. Sai số trên tập huấn luyện mô hình sẽ nhỏ nhưng sai số trên dữ liệu kiểm tra mô hình sẽ lớn.</p>
</div>

Làm thế nào chúng ta có thể đảm bảo rằng hàm $f$ đạt được mức độ linh hoạt cần thiết để mô tả được mối liên hệ giữa biến mục tiêu và biến giải thích nhưng cũng không quá linh hoạt vì dễ dẫn đến mô hình khớp quá mức? Câu trả lời là cần có ràng buộc cho sự linh hoạt của hàm $f$.

Nếu như đạo hàm của hàm $f$ tại điểm $x_i$ cho biết độ dốc của hàm $f$ tại điểm này, thì đạo hàm bậc hai của hàm $f$ cho biết độ dốc của hàm $f$ thay đổi nhanh hay chậm. Trên một khoảng giá trị $[a,b]$ bất kỳ, nếu tổng giá trị tuyệt đối, hoặc tổng bình phương, của các đạo hàm bậc hai của một hàm càng lớn thì hàm số đó sẽ càng linh hoạt. Nói một cách khác, hàm số $f$ sẽ càng linh hoạt nếu $\int\limits_a^b f^{''}(t)^2 dt$ càng lớn và ngược lại, giá trị này càng gần 0 thì hàm càng ít linh hoạt. Giá trị $\int\limits_a^b f^{''}(t)^2 dt$ có thể được coi như một thước đo cho sự linh hoạt của hàm $f$ trên khoảng $[a,b]$. Lưu ý rằng bất kỳ hàm tuyến tính nào trên khoảng $[a,b]$ cũng sẽ có $\int\limits_a^b f^{''}(t)^2 dt = 0$, nghĩa là hàm tuyến tính là hàm ít linh hoạt nhất.

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam07-1.png" alt="Sự linh hoạt của các hàm số so với hàm không linh hoạt là hàm tuyến tính. Hình bên trái: Hàm số ít linh loạt. Hình bên phải: Hàm số rất linh hoạt." width="672" />
<p class="caption">(\#fig:fggam07)Sự linh hoạt của các hàm số so với hàm không linh hoạt là hàm tuyến tính. Hình bên trái: Hàm số ít linh loạt. Hình bên phải: Hàm số rất linh hoạt.</p>
</div>
Hình bên trái của Hình \@ref(fig:fggam07) mô tả một hàm $f$ có miền xác định trên đoạn $[-1,1]$ có độ dốc (đạo hàm cấp một) thay đổi nhưng tốc độ thay đổi của đạo hàm cấp một không quá nhanh. Hình bên phải của Hình \@ref(fig:fggam07) mô tả một hàm $f$ có độ dốc thay đổi liên tục khi $x$ chạy từ -1 đến 1. Kết quả là độ linh hoạt của hàm số ở hình bên phải đo bằng $\int\limits_a^b f^{''}(t)^2 dt$ lớn gấp 40 lần so với độ linh hoạt của hàm được mô tả ở hình bên trái. Để cân bằng giữa sai số RSS và độ linh hoạt của hàm $f$, thay vì tìm hàm $f$ để tối thiểu hóa RSS, người xây dựng mô hình sẽ tìm hàm $f$ để tối thiểu hóa giá trị RSS cộng thêm một hàm phạt cho sự linh hoạt
\begin{align}
\hat{f} = \underset{f}{\operatorname{argmin}} \sum\limits_{i=1}^n (y_i - f(x_i))^2 + \lambda \cdot \int\limits_a^b f^{''}(t)^2 dt
(#eq:gam005)
\end{align}
trong đó $[a,b]$ là miền giá trị mà người xây dựng mô hình muốn đặt ràng buộc cho sự linh hoạt của hàm $f$. Thông thường thì cận dưới $a$ thường được lựa chọn là giá trị nhỏ nhất của biến giải thích trong khi cận trên $b$ là giá trị lớn nhất của biến giải thích. Tham số $\lambda > 0$ đóng vai trò điều chỉnh sự linh hoạt của hàm $f$: nếu $\lambda$ nhỏ thì kết quả của bài toán tối ưu \@ref(eq:gam005) sẽ là hàm linh hoạt hơn so với khi $\lambda$ nhận giá trị lớn. Khi $\lambda$ rất lớn thì hàm $\hat{f}$ sẽ xấp xỉ với hàm tuyến tính trong khi $\lambda$ xấp xỉ 0 sẽ cho kết quả là một hàm nội suy lại chính xác dữ liệu dùng để huấn luyện mô hình. Tương tự như trong hồi quy ridge hay lasso, tham số $\lambda$ được sử dụng với vai trò cân bằng giữa sự sai lệch và phương sai của mô hình. 

Điều thú vị là lời giải $\hat{f}$ của bài toán tối ưu \@ref(eq:gam005) có tính chất đặc biệt:

* 1. Hàm $\hat{f}$ là một splines bậc ba với các nút tại các giá trị duy nhất của $x_1$, $x_2$, $\cdots$, $x_n$ 
* 2. Hàm $\hat{f}$ có các đạo hàm bậc nhất và bậc hai liên tục tại mỗi nút. 
* 3. Hơn nữa, tại các khoảng giá trị nhỏ hơn nút nhỏ nhất và lớn hơn nút lớn nhất hàm số là hàm tuyến tính. Hay nói cách khác, hàm $\hat{f}$ là một *natural splines* bậc ba với các nút đặt tại $x_1$, $x_2$, $\cdots$, $x_n$. Tuy nhiên, $\hat{f}$ không chính xác là một *natural splines* với $n$ tham số tương ứng với $n$ nút giống như chúng ta đã đề cập ở phần trước của chương, mà các tham số bị ràng buộc theo tham số $\lambda$. Để tham khảo nguyên nhân tại sao $\hat{f}$ lại là một *natural splines*, bạn đọc tham khảo phần \@ref(gamapen3)

Khi thảo luận về bậc tự do của các hàm có ràng buộc tham số, cũng giống như trong hồi quy ridge, chúng ta cần nhắc đến khái niệm bậc tự do hiệu quả. Tham số $\lambda$ kiểm soát độ linh hoạt của hàm $\hat{f}$ do đó tham số này cũng quyết định bậc tự do hiệu quả của mô hình. 

* Khi $\lambda \rightarrow + \infty$, hàm $\hat{f}$ sẽ tiến đến một đường tuyến tính có thước đo độ linh hoạt bằng 0 và do đó có bậc tự do hiệu quả bằng 2, tương ứng với 2 tham số là hệ số chặn và hệ số góc. 
* Khi $\lambda = 0$, $\hat{f}$ là một *natural splines* có $n$ nút và không có ràng buộc, nghĩa là số bậc tự hiệu quả bằng $n$. Nếu định nghĩa $d_{\hat{f}}(\lambda)$ là bậc tự do hiệu quả của hàm $\hat{f}$ thì $d_{\hat{f}}(\lambda)$ là một hàm giảm từ $n$ về 2 khi $\lambda$ nhận giá trị từ 0 đến $+\infty$.

Với mỗi giá trị $\lambda > 0$, hàm $\hat{f}$ ước lượng được từ dữ liệu được gọi là một *smoothing splines*. Quá trình ước lượng tham số cho hàm $\hat{f}$ yêu cầu những chứng minh khá phức tạp. Bạn đọc có thể tham khảo tại \@ref(gamapen4). Tuy nhiên, điều thú vị khi ước lượng một hàm *smoothing splines* là chúng ta không cần phải quan tâm là cần bao nhiêu nút hoặc đặt các nút ở đâu. Tất cả các tham số cần khai báo chỉ là bậc tự do hiệu quả của *smoothing splines* đó! Lựa chọn tham số $\lambda$ được thực hiện thông qua xác thực chéo, nghĩa là giá trị $\lambda$ được lựa chọn sao cho sai số xác thực chéo trên dữ liệu huấn luyện mô hình là nhỏ nhất. 

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam08-1.png" alt="Giá nhà tại Boston được hồi quy theo smoothing splines của biến giải thích là tỷ lệ người sống dưới mức độ trung bình với bậc tự do hiệu quả khác nhau. Hình bên trái: Khi bậc tự do hiệu quả bằng 2, smoothing splines là một hàm tuyến tính. Hình ở giữa: bậc tự do hiệu quả bằng 10 cho kết quả một đường cong mịn và khớp với dữ liệu. Hình bên phải: Bậc tự do hiệu quả quá lớn làm cho hàm số trở nên quá linh hoạt và dễ dẫn đến mô hình khớp quá mức." width="768" />
<p class="caption">(\#fig:fggam08)Giá nhà tại Boston được hồi quy theo smoothing splines của biến giải thích là tỷ lệ người sống dưới mức độ trung bình với bậc tự do hiệu quả khác nhau. Hình bên trái: Khi bậc tự do hiệu quả bằng 2, smoothing splines là một hàm tuyến tính. Hình ở giữa: bậc tự do hiệu quả bằng 10 cho kết quả một đường cong mịn và khớp với dữ liệu. Hình bên phải: Bậc tự do hiệu quả quá lớn làm cho hàm số trở nên quá linh hoạt và dễ dẫn đến mô hình khớp quá mức.</p>
</div>

Hình \@ref(fig:fggam08) mô tả mối liên hệ giữa giá nhà và tỷ lệ người có thu nhập thấp trên dữ liệu <span style='color: #640514; font-family: Source Code Pro;'>Boston</span> sử dụng *smoothing splines*. Khi bậc tự do hiệu quả bằng 2 tương đương với tham số $\lambda = +\infty$, *smoothing splines* trở thành đường tuyến tính giống như đồ thị bên trái. Nếu chúng ta tăng bậc tự do hiệu quả, hay giảm $\lambda$, *smoothing splines* sẽ trở nên linh hoạt hơn và khớp tốt hơn với dữ liệu huấn luyện mô hình, tuy nhiên khi bậc tự do hiệu quả quá lớn thì hàm $f$ sẽ trở nên quá linh hoạt như đồ thị phải của Hình \@ref(fig:fggam08).

Trước khi đi vào nội dung chính của chương này là mô hình cộng tính tổng quát, chúng ta sẽ thảo luận về một phương pháp tiếp cận cũng thường được sử dụng và cho hiệu quả tương đương như khi sử dụng *splines* để mô tả mối liên hệ phi tuyến giữa biến mục tiêu và biến giải thích. Cách tiếp cận này được gọi là hồi quy từng đoạn, *local regression* hay viết tắt là *loess*

## Hồi quy từng đoạn
Hồi quy từng đoạn hay hồi quy cục bộ là một cách tiếp cận khác để mô tả mối liên hệ phi tuyến tính giữa biến mục tiêu $Y$ và biến giải thích $X$. Khái niệm *cục bộ*  có nghĩa là, tại một điểm $x_0$ nằm trong miền giá trị của biến giải thích $X$, biến mục tiêu $Y$ được mô tả thông qua một hàm tuyến tính $\hat{f}$ được ước lượng từ những giá trị quan sát được của biến $X$ nằm gần với giá trị $x_0$.

* Thứ nhất, trong hồi quy cục bộ luôn luôn phải có định nghĩa rõ ràng cho khái niệm các điểm dữ liệu gần và xa so với điểm $x_0$. Người xây dựng mô hình phải định nghĩa một tham số $k$; $2 \leq k \leq n$, để với mỗi $x_0$ chúng ta sử dụng đúng $k$ điểm dữ liệu quan sát được gần với $x_0$ nhất để ước lượng hàm $f$. Một cách tổng quát hơn là định nghĩa tham số *span* được tính bằng $k/n$ để mô tả cho tỷ lệ dữ liệu sử dụng trong hồi quy cục bộ. Dễ thấy rằng *span* nhận giá trị trong khoảng $(0,1]$. Đồng thời khi *span* rất gần 0, số lượng điểm dữ liệu để sử dụng để ước lượng hàm $\hat{f}$ là rất nhỏ. Ngược lại, khi *span* rất gần 1 thì số lượng điểm dữ liệu sử dụng để ước lượng hàm $\hat{f}$ là gần như toàn bộ dữ liệu dùng để huấn luyện mô hình.

* Thứ hai, hồi quy từng đoạn không chỉ loại bỏ các điểm dữ liệu cách xa $x_0$, mà còn ước lượng hàm $\hat{f}$ bằng phương pháp bình phương nhỏ nhất có trọng số. Trọng số cho các điểm dữ liệu nằm gần $x_0$ thường lớn hơn trọng số của các điểm nằm xa $x_0$ để đảm bảo rằng các điểm nằm gần $x_0$ có tác động mạnh hơn đến hình dạng của hàm $\hat{f}$. Hàm số được sử dụng để định nghĩa trọng số thường là hàm tính trên khoảng cách từ các điểm dữ liệu đến điểm $x_0$. Hàm số phải đảm bảo tính chất là nhận giá trị trên tập các số thực dương và là hàm tăng. Hàm trọng số trên một điểm dữ liệu $x_i$ khi ước lượng hàm hồi quy cục bộ thường được sử dụng để ước lượng hàm $\hat{f}$ là 

\begin{align}
w(x_i) = \left[(1 - d^3)\right]^3
\end{align}
trong đó  
\begin{align}
d = \cfrac{|x_i - x_0|}{\text{maxdist}}
\end{align}
với *maxdist* là khoảng cách xa nhất từ các điểm được lựa chọn đến điểm $x_0$. Các hình \@ref(fig:fggam09a) và \@ref(fig:fggam09b) mô tả phương pháp hồi quy cục bộ trên một dữ liệu mô phỏng từ hàm $f(x) = 2*(x-1)^2$ với hai lựa chọn khác nhau của tham số *span*. Dữ liệu được cộng thêm nhiễu có phân phối chuẩn có độ lệch chuẩn bằng 0.5.  

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam09a-1.png" alt="Hàm số phi tuyến được xây dựng bằng phương pháp hồi quy cục bộ. Đường màu xanh da trời là giá trị thật của hàm f. Tham số span được sử dụng trong hồi quy cục bộ là 0.3" width="672" />
<p class="caption">(\#fig:fggam09a)Hàm số phi tuyến được xây dựng bằng phương pháp hồi quy cục bộ. Đường màu xanh da trời là giá trị thật của hàm f. Tham số span được sử dụng trong hồi quy cục bộ là 0.3</p>
</div>


<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam09b-1.png" alt="Hàm số phi tuyến được xây dựng bằng phương pháp hồi quy cục bộ. Đường màu xanh da trời là giá trị thật của hàm f. Tham số span được sử dụng trong hồi quy cục bộ là 0.7" width="672" />
<p class="caption">(\#fig:fggam09b)Hàm số phi tuyến được xây dựng bằng phương pháp hồi quy cục bộ. Đường màu xanh da trời là giá trị thật của hàm f. Tham số span được sử dụng trong hồi quy cục bộ là 0.7</p>
</div>

Hình \@ref(fig:fggam09a) và \@ref(fig:fggam09b) minh họa ý tưởng xây dựng hàm $\hat{f}$ bằng phương pháp hồi quy cục bộ trên một dữ liệu mô phỏng. Hình \@ref(fig:fggam09a) sử dụng tham số span bằng 0.3, nghĩa là mỗi lần ước lượng hàm $f$ chỉ có 30\% điểm dữ liệu được đưa vào trong mô hình hồi quy. Đường màu xanh mô tả hàm số được sử dụng để tạo ra dữ liệu trong khi đường nét đứt là hàm được ước lượng bằng phương pháp hồi quy cục bộ. Tại điểm $x_0 = 0.25$ hàm $\hat{f}$ là đường tiếp tuyến được ước lượng dựa trên phương pháp bình phương nhỏ nhất có trọng số dựa trên 30\% điểm nằm gần $x_0$ nhất (là các điểm màu cam). Trong hình \@ref(fig:fggam09b), đường màu cam là ước lượng của hàm $f$ với tham số span bằng 0.7. Đường tiếp tuyến tại điểm $x_0 = 1.5$ là ước lượng của hàm $f$ tại điểm này. Có thể thấy rằng khi tham số span càng gần 1 thì hàm $\hat{f}$ càng ít linh hoạt.

Quá trình ước lượng hàm $\hat{f}$ tại điểm $x_0$ bằng phương pháp hồi quy cục bộ có thể được mô tả qua các bước sau đây

1. Lựa chọn tham số *span* và sau đó tính $k$ là phần nguyên của *span* $\times$ $n$ với $n$ là số lượng quan sát. Lựa chọn ra $k$ điểm trong số $n$ điểm có khoảng cách gần với điểm $x_0$ nhất.

2. Lựa chọn hàm trọng số $w(x_i) = h(d)$ là hàm số nhận giá trị dương và tăng theo $d$, với $d = \cfrac{|x_i - x_0|}{\text{maxdist}}$ là khoảng cách từ một điểm $x_i$ trong $k$ điểm được chọn trong bước (1.) và *maxdist* là khoảng cách từ điểm xa nhất đến $x_0$ để đảm bảo $d$ luôn nằm trong khoảng (0,1].

3. Tìm các tham số $\hat{\beta}_0$, $\hat{\beta}_1$ để tối thiểu hóa *RSS*
\begin{align}
RSS  = \sum\limits_{i = 1}^k w(x_i) \cdot (y_i - \beta_0 - \beta_1 \cdot x_i)^2
\end{align}

4. Trả lại giá trị $\hat{f}(x_0) = \hat{\beta}_0 + \hat{\beta}_1 \cdot x_1$.

Bạn đọc có thể thấy rằng, để xây dựng được một đường hồi quy liên tục như trong Hình \@ref(fig:fggam09a) và \@ref(fig:fggam09b) chúng ta sẽ phải liên tục cập nhật các điểm $x_0$ mới trên miền giá trị của biến giải thích, và với mỗi một điểm $x_0$ mới, chúng ta lại thực hiện một ước lượng bình phương nhỏ nhất có trọng số trên một tập dữ liệu mới. Điều này khiến cho khối lượng tính toán của phương pháp này lớn hơn rất nhiều so với hồi quy *splines*. Đây cũng là nhược điểm chính của phương pháp hồi quy từng đoạn.

Tham số *span* được sử dụng để điều chỉnh độ sai lệch và phương sai của đường hồi quy. Khi *span* nhỏ, hàm $\hat{f}$ sẽ rất linh hoạt nhưng có phương sai lớn và ngược lại, nếu *span* lớn hàm $\hat{f}$ sẽ ít linh hoạt hơn và đánh đổi lại là phương sai sẽ nhỏ hơn. Cũng giống như tham số $\lambda$ của smoothing splines, tham số *span* cần được lựa chọn dựa trên xác thực chéo. 

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam10-1.png" alt="Giá nhà được hồi quy cục bộ theo biến giải thích là tỷ lệ người có thu nhập thấp. Tham số span được lựa chọn bằng xác thực chéo." width="672" />
<p class="caption">(\#fig:fggam10)Giá nhà được hồi quy cục bộ theo biến giải thích là tỷ lệ người có thu nhập thấp. Tham số span được lựa chọn bằng xác thực chéo.</p>
</div>


Ý tưởng hồi quy cục bộ có thể được khái quát theo trong trường hợp có nhiều biến giải thích $X_1, X_2, \cdots, X_p$ và thường cho kết quả tốt hơn so với mô hình hồi quy tuyến tính đa biến khi có các biến giải thích có tính chất cục bộ mà điển hình là biến thời gian. Khi có biến mục tiêu phụ thuộc vào biến giải thích là thời gian thì rất thường gặp phải trường hợp mà hệ số tuyến tính liên tục thay đổi, điều mà mô hình tuyến tính đa biến không thể mô tả được. Tuy nhiên, hồi quy cục bộ lại thường hoạt động không hiệu quả khi số lượng biến giải thích $p$ lớn do rất khó để tìm được các điểm lân cận có tính chất tương tự điểm $x_0$ khi số chiều tăng lên.

Một lưu ý cuối cùng cho bạn đọc về hồi quy cục bộ đó là việc lựa chọn dạng của hàm $\hat{f}$ trong hồi quy cục bộ không nhất thiết phải là hàm tuyến tính theo $x_i$. Bạn đọc có thể sử dụng các dạng hàm phức tạp hơn, chẳng hạn như sử dụng các đa thức bậc hai. Khi đó, các tham số cần được ước lượng là $\beta_0$, $\beta_1$, và $\beta_2$ để tối thiểu hóa
\begin{align}
RSS  = \sum\limits_{i = 1}^k w(x_i) \cdot (y_i - \beta_0 - \beta_1 \cdot x_i - \beta_2 \cdot x_i^2)^2
\end{align}

## Mô hình hồi quy cộng tính tổng quát {#gammodel}
Trong các phần trước của Chương, chúng tôi trình bày một số phương pháp xây dựng các hàm phi tuyến nhằm mô tả mối liên hệ giữa biến mục tiêu $Y$ dựa vào một biến giải thích $X$ duy nhất. Những phương pháp này có thể được coi là sự mở rộng của hồi quy tuyến tính đơn biến. Trong mô hình cộng tính tổng quát, chúng ta thảo luận về vấn đề dự đoán hay đánh giá một biến mục tiêu Y trên cơ sở các hàm phi tuyến của $p$ biến giải thích $X_1$, $X_2$, $\cdots$ , $X_p$. Mô hình cộng tính tổng quát cũng có thể hiểu như là một sự mở rộng của hồi quy tuyến tính đa biến. Các mô hình cộng tính tổng quát (Genaralized Additive Model hay viết tắt là GAM) mở rộng mô hình tuyến tính tiêu chuẩn bằng cách mô tả biến mục tiêu thông qua tổng các hàm phi tuyến tính của từng biến giải thích. Nếu như mô hình hồi quy tuyến tính mô tả biến mục tiêu bằng phương trình
\begin{align}
Y = \beta_0 + \beta_1 \cdot X_1 + \beta_2 \cdot X_2 + \cdots + \beta_p  \cdot X_p + \epsilon
\end{align}
thì mô hình GAM mô tả biến giải thích thông qua phương trình
\begin{align}
Y = \beta_0 + f_1(X_1) + f_2(X_2) + \cdots + f_p(X_p) + \epsilon
(#eq:gam006)
\end{align}
trong đó $f_j$ có thể là hàm phi tuyến với mọi $1 \leq j \leq p$. Cụ thể hơn, $f_j$ có thể là bất kỳ hàm số nào trong các hàm số mà chúng ta đã thảo luận trong khác phần trước của chương: $f_j(x)$ có thể đơn giản là một đa thức bậc $d$ của $x$, có thể là một splines bậc $d$, một natural splines, smoothing splines, hay là một hàm hồi quy cục bộ theo các miền giá trị của $x$. Và điều quan trọng là, với $p$ lựa chọn khác nhau cho dạng hàm $f_i$, có thể sử dụng một phương pháp được gọi là *backfitting* để ước lượng tất cả các hàm $f_i$ mà người xây dựng mô hình lựa chọn. Phương pháp *backfitting* được giới thiệu trong nghiên cứu của Leo Breiman (1985) với mục tiêu để ước lượng các mô hình cộng tính tổng quát được mô tả bởi phương trình \@ref(eq:gam006). Các ràng buộc bổ sung cho các hàm $f_j$ cho quá trình *backfitting* là
\begin{align}
\sum\limits_{i=1}^n \ f_j(X_{i,j}) = 0 \ \ \ \forall{j}  
(#eq:gam007)
\end{align}
để đảm bảo nghiệm của quá trình ước lượng tham số cho kết quả duy nhất. Với ràng buộc \@ref(eq:gam007) chúng ta có thể ước lượng các hàm $f_j$ như sau:

- Bước thứ nhất: Tính toán ước lượng cho tham số $\beta_0$ bằng trung bình biến mục tiêu:
\begin{align}
\beta_0 = \cfrac{1}{n} \sum\limits_{i=1}^n y_i
(#eq:gam008)
\end{align}
và cho $\hat{f}_j = 0$ với mọi $1 \leq j \leq p$.

- Bước thứ hai: Với mỗi $j$ bằng $1, 2, \cdots, p$: Ước lượng hàm $\hat{f}_j$ theo dạng hàm đã lựa chọn với biến mục tiêu là
\begin{align}
y_i - \hat{\beta}_0 - \sum\limits_{m=1,m \neq j}^{p} \hat{f}_m(x_{i,m})
(#eq:gam009)
\end{align}
và sau đó để đảm bảo ràng buộc \@ref(eq:gam007) chúng ta điều chỉnh $\hat{f}_j$ như sau
\begin{align}
\hat{f}_j = \hat{f}_j - \sum\limits_{i=1}^n \hat{f}_j(x_{i,j})
(#eq:gam010)
\end{align}

- Bước thứ ba: Lặp lại bước thứ hai cho đến khi các hàm $\hat{f}_j$ không thay đổi đáng kể sau mỗi lần cập nhật.

Chi tiết của phương pháp backfitting sẽ được thảo luận trong phần \@ref(gamapen5). Bạn đọc có thể hiểu quá trình *backfitting* một cách đơn giản như khi chúng ta ước lượng mô hình hồi quy tuyến tính thông thường biến $Y$ phụ thuộc vào hai biến giải thích là $X_1$ và $X_2$ mà không ước lượng các hệ số $\beta_1$ của $X_1$ và $\beta_2$ của $X_2$ một cách đồng thời. Thật vậy,

- Bước thứ nhất: tương tự như thuật toán phát biểu ở trên, chúng ta cho $\hat{\beta_0} = \bar{y}$

- Bước thứ hai: Ước lượng mô hình tuyến tính
\begin{align}
(Y - \hat{\beta}_0) \sim X_1
\end{align}
và thu được hệ số chặn $\hat{\beta}_{10}$ và hệ số góc $\hat{\beta}_{11}$. Do biến mục tiêu $(Y - \hat{\beta}_0)$ có trung bình bằng 0 nên ta có $\hat{\beta}_{10} + \hat{\beta}_{11} \cdot \bar{x_1} = 0$. Nói cách khác, hàm $\hat{f}_1(x) = \hat{\beta}_{10} + \hat{\beta}_{11} \cdot x$ đã được tự động điều chỉnh để thỏa mãn ràng buộc \@ref(eq:gam007). Với $\hat{\beta}_{10}$ và $\hat{\beta}_{11}$ ước lượng được chúng ta ước lượng mô hình tuyến tính 
\begin{align}
(Y - \hat{\beta}_0 - hat{\beta}_{10} + \hat{\beta}_{11} \cdot X_1) \sim X_2
\end{align}
để thu được hệ số chặn $\hat{\beta}_{20}$ và hệ số góc $\hat{\beta}_{21}$. Tương tự như hàm $\hat{f}_1(x)$, hàm $\hat{f}_2(x)$ cũng tự động thỏa mãn ràng buộc \@ref(eq:gam007).

- Bước thứ ba: Lặp lại bước thứ hai cho đến khi các hệ số $\hat{\beta}_{10}$, $\hat{\beta}_{11}$, $\hat{\beta}_{20}$ và $\hat{\beta}_{21}$ không thay đổi đáng kể sau mỗi bước lặp.

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam11-1.png" alt="Tốc độ hội tụ khi sử dụng phương pháp backfitting trong ước lượng tham số của mô hình hồi quy đa biến với biến giải thích là medv và các biến phụ thuộc là rm và lstat. Hình trên bên trái: Hệ số chặn của hàm tuyến tính của biến rm. Hình trên bên phải: Hệ số góc của hàm tuyến tính của biến rm. Hình dưới bên trái: Hệ số chặn của hàm tuyến tính của biến lstat. Hình dưới bên phải: Hệ số góc của hàm tuyến tính của biến lstat." width="672" />
<p class="caption">(\#fig:fggam11)Tốc độ hội tụ khi sử dụng phương pháp backfitting trong ước lượng tham số của mô hình hồi quy đa biến với biến giải thích là medv và các biến phụ thuộc là rm và lstat. Hình trên bên trái: Hệ số chặn của hàm tuyến tính của biến rm. Hình trên bên phải: Hệ số góc của hàm tuyến tính của biến rm. Hình dưới bên trái: Hệ số chặn của hàm tuyến tính của biến lstat. Hình dưới bên phải: Hệ số góc của hàm tuyến tính của biến lstat.</p>
</div>

Hình \@ref(fig:fggam11) mô tả sự hội tụ của các hệ số chặn và hệ số góc của các hàm $f_1$ và $f_2$ lần lượt là các hàm tuyến tính của biến <span style='color: #640514; font-family: Source Code Pro;'>rm</span> và biến <span style='color: #640514; font-family: Source Code Pro;'>lstat</span> trong mô hình hồi quy đa biến với biến mục tiêu là biến <span style='color: #640514; font-family: Source Code Pro;'>medv</span> trên dữ liệu <span style='color: #640514; font-family: Source Code Pro;'>Boston</span>. Trước hết bạn đọc có thể thấy rằng các hệ số tuyến tính hội tụ rất nhanh chỉ sau hơn 10 bước lặp. Thứ hai, các hàm ước lượng được từ *backfitting* là
\begin{align}
\hat{\beta}_0 &= \bar{y} = 22.533 \\
\hat{f}_1(rm) &= \hat{\beta}_{10} + \hat{\beta}_{11} \cdot rm = -32.019 + 5.095 \cdot rm \\
\hat{f}_2(lstat) &= \hat{\beta}_{20} + \hat{\beta}_{21} \cdot lstat = 8.127 - 0.642 \cdot lstat 
(#eq:gam011)
\end{align}
sẽ cho ước lượng cộng tính cho hàm $f$ là
\begin{align}
\hat{f}(rm, lstat) & = \hat{\beta}_0 + \hat{f}_1(rm) + \hat{f}_2(lstat) \\
& = - 1.358 +  5.095 \cdot rm - 0.642 \cdot lstat 
(#eq:gam012)
\end{align}

Bạn đọc có thể sử dụng ước lượng hồi quy đa biến thông thường để xác nhận rằng kết quả của hồi quy đa biến băng phương pháp bình phương nhỏ nhất cho kết quả không khác so với phương trình \@ref(eq:gam012).

Trong thực tế, bạn đọc không cần phải viết vòng lặp để ước lượng mô hình cộng tính tổng quát mà sử dụng thư viện <span style='color: #640514; font-family: Source Code Pro;'>gam</span>. Hàm số được sử dụng để xây dựng và ước lượng mô hình cộng tính tổng quát trên R là hàm cùng tên với thư viện, hàm <span style='color: #640514; font-family: Source Code Pro;'>gam()</span>. Chúng ta sẽ sử dụng hàm số này nhiều hơn trong phần thực hành. 

Đối với mô hình cộng tính tổng quát, thách thức với người xây dựng mô hình là chọn dạng hàm cho từng biến giải thích và số bậc tự do tương ứng. Tiêu chí để đánh giá mô hình thường được sử dụng là sai số xác thực chéo. Tuy nhiên, cần nhắc lại với bạn đọc rằng sử dụng xác thực chéo khi số lượng biến giải thích lớn sẽ khiến cho thời gian tính toán tăng lên đáng kể. 

Quay trở lại ví dụ khi chúng ta xây dựng mô hình cộng tính tổng quát khi biến mục tiêu medv phụ thuộc vào hai biến giải thích là <span style='color: #640514; font-family: Source Code Pro;'>lstat</span> và <span style='color: #640514; font-family: Source Code Pro;'>rm</span>. Giả sử chúng ta lựa chọn dạng hàm cho <span style='color: #640514; font-family: Source Code Pro;'>lstat</span> và <span style='color: #640514; font-family: Source Code Pro;'>rm</span> đều là các *smoothing spline*. Tham số duy nhất của *smoothing spline* là bậc tự do hiệu quả. Tìm bậc tự do hiệu quả cho <span style='color: #640514; font-family: Source Code Pro;'>lstat</span> và <span style='color: #640514; font-family: Source Code Pro;'>rm</span> phải thực hiện đồng thời và dựa trên sai số xác thực chéo 

<div class="figure" style="text-align: center">
<img src="09-mo-hinh-cong-tinh-tong-quat_files/figure-html/fggam12-1.png" alt="Sai số xác thực chéo khi lựa chọn tham số bậc tự do hiệu quả cho smoothing spline của biến lstat và bậc tự do hiệu quả cho smoothing spline của biến rm." width="672" />
<p class="caption">(\#fig:fggam12)Sai số xác thực chéo khi lựa chọn tham số bậc tự do hiệu quả cho smoothing spline của biến lstat và bậc tự do hiệu quả cho smoothing spline của biến rm.</p>
</div>

Hình \@ref(fig:fggam12) mô tả quá trình tìm kiếm tham số bậc tự do hiệu quả cho biến <span style='color: #640514; font-family: Source Code Pro;'>lstat</span> và tham số bậc tự do hiệu quả cho biến <span style='color: #640514; font-family: Source Code Pro;'>rm</span> dựa trên sai số xác thực chéo. Có thể thấy rằng tham số cho sai số xác thực chéo nhỏ nhất là $df = 7.9$ đối với biến <span style='color: #640514; font-family: Source Code Pro;'>lstat</span> và $df = 5.9$ đối với biến <span style='color: #640514; font-family: Source Code Pro;'>rm</span>. 

Cũng giống như mô hình tuyến tính thông thường, mô hình cộng tính tổng quát hoàn toàn có thể sử dụng trong các bài toán phân loại. Mô hình tuyến tính thông thường không thể sử dụng trực tiếp cho bài toán phân loại mà cần có sự biến đổi cho phù hợp với phân phối xác suất của biến mục tiêu. Các mô hình tuyến tính dùng cho mục đích phân loại là lớp các mô hình thường được gọi là mô hình tuyến tính tổng quát mà ở đó chúng ta có thể bỏ qua giả thuyết về phân phối chuẩn của biến mục tiêu. Các mô hình này sẽ được trình bày trong phần sau của cuốn sách. Mô hình *GAM* cho mục đích phân loại cũng cần xây dựng dựa trên nền tảng của mô hình tuyến tính tổng quát do đó sẽ được đề cập trong các chương tiếp theo.  

## Thực hành

### Hồi quy spline trên dữ liệu <span style='color: #640514; font-family: Source Code Pro;'>Boston</span>

### Hồi quy cục bộ trên dữ liệu <span style='color: #640514; font-family: Source Code Pro;'>Boston</span>

### Mô hình công tính tổng quát trên dữ liệu <span style='color: #640514; font-family: Source Code Pro;'>Boston</span>

## Phụ lục

### Ước lượng tham số cho *splines* bậc ba và $k$ nút {#gamapen1}
Ước lượng tham số cho *splines* bậc ba không được thực hiện thông qua bài toán tối ưu như phương trình \@ref(eq:gam004) mà cần có sự biến đổi tham số. Giả sử $k=1$ và nút duy nhất được lựa chọn là $c$. Các tham số ($\beta_{01}$, $\beta_{11}$, $\beta_{21}$, $\beta_{31}$) của đa thức thứ nhất và các tham số ($\beta_{02}$, $\beta_{12}$, $\beta_{22}$, $\beta_{32}$) của đa thức thứ hai thỏa mãn các ràng buộc trong bài toán tối ưu như phương trình \@ref(eq:gam004), có thể chứng minh được rằng tồn tại các tham số $\beta_0$, $\beta_1$, $\cdots$, $\beta_4$ sao cho hàm số $f$ là nghiệm của bài tối ưu thỏa mãn
\begin{align}
f(x) = \beta_0 + \beta_1 \cdot x + \beta_2 \cdot x^2 + \beta_3 \cdot x^3 + \beta_4 \cdot \left[(x-c)^3\right]^+
\end{align}
Nói một cách khác, thay vì giải bài toán tối ưu có điều kiện ràng buộc, chúng ta chỉ cần sử dụng phương pháp bình phương nhỏ nhất thông thường để tìm các hệ số tuyến tính $\beta_0$, $\beta_1$, $\cdots$, $\beta_4$ tương ứng với các biến giải thích lần lượt là $1$, $x_i$, $x_i^2$, $x_i^3$, $\left[(x_i-c)^3\right]^+$.

Để tránh sự nhầm lẫn khi viết các hệ số $\beta$ với chỉ số, chúng ta viết lại bài toán hai đa thức như sau: Cho hai đa thức bậc ba $P_1$ và $P_2$ như sau
\begin{align}
& P_1(x) = a_0 + a_1 x + a_2 x^2 + a_3 x^3 \\
& P_2(x) = b_0 + b_1 x + b_2 x^2 + b_3 x^3
\end{align}
và nút $c$ sao cho
\begin{align}
P_1(c) = P_2(c); \ \ \ P^{'}_1(c) = P{'}_2(c); \ \ \ P{''}_1(c) = P{''}_2(c)
\end{align}
Hàm số $f$ được xác định bởi
\begin{align}
f(x) = \mathbb{I}_{\{x_i < c\}} \cdot P_1(x) + \mathbb{I}_{\{x_i \geq c\}} \cdot P_2(x)
\end{align}
Chúng ta sẽ chứng minh rằng $f(x)$ có thể được viết dưới dạng
\begin{align}
f(x) = a_0 + a_1 x + a_2 x^2 + a_3 x^3 + (b_3 - a_3) \cdot \left[(x-c)^3\right]^{+}
\end{align}

Trước hết, chúng ta viết lại đa thức $P_2(x)$ như sau
\begin{align}
P_2(x) = d_0 + d_1 (x-c) + d_2 (x-c)^2 + b_3 (x-c)^3
\end{align}
do $P_1(c) = P_2(c)$,  $P^{'}_1(c) = P{'}_2(c)$, và $P{''}_1(c) = P{''}_2(c)$ nên chúng ta có $d_0 = P_1(c)$; $d_1 = P^{'}_1(c)$, và $d_2 = P{''}_1(c)/2$. 

Khi $x < c$ có thể dễ dàng thấy rằng $f(x) = P_1(x)$. Với $x > c$, chúng ta có 
\begin{align}
f(x) & = a_0 + a_1 x + a_2 x^2 + a_3 x^3 + (b_3 - a_3) \cdot (x-c)^3 \\
& = (a_0 + a_3 c^3) + (a_1 - 3 a_3 c^2) x + (a_2 + 3 a_3 c) x^2 + b_3 (x-c)^3 
\end{align}

Với $t = x - c$,
\begin{align}
f(x) & = (a_0 + a_3 c^3) + (a_1 - 3 a_3 c^2) (y + c) + (a_2 + 3 a_3 c) (y + c)^2 + b_3 y^3 \\
& = (a_0 + a_3 c^3 + a_1 c + a_2 c^2) + (a_1 + 3 a_3 c^2 + 2 a_2) y + (a_2 + 3 a_3 c) y^2 + b_3 y^3 \\
& = d_0 + d_1 y + d_2 y^2 + b_3 y^3
\end{align}
hay nói cách khác $f(x) = P_2(x)$ khi $x > c$!

Trong trường hợp tổng quát, ước lượng một splines bậc ba với $k$ nút $c_1 < c_2 < \cdots < c_k$ sẽ tương đương với ước lượng $k+4$ tham số $\beta_0$, $\beta_1$, $\cdots$, $\beta_{(k+3)}$ với các biến giải thích $1$, $x_i$, $x_i^2$, $x_i^3$, $\left[(x_i-c_1)^3\right]^+$, $\left[(x_i-c_2)^3\right]^+$, $\cdots$, $\left[(x_i-c_k)^3\right]^+$.

### Ước lượng tham số cho natural splines bậc ba có $k$ nút {#gamapen2}
Ước lượng tham số cho một $natural$ $splines$ không được thực hiện thông qua bài toán tối ưu có ràng buộc tại $k$ nút, mà được thực hiện thông qua giải bài toán bình phương nhỏ nhất thông thường của biến mục tiêu $Y$ với $k$ biến giải thích được tính toán từ biến giải thích $X$. Giả sử $k$ nút được xắp xếp theo thứ tự tăng dần $c_1 < c_2 < \cdots < c_k$, ta có $k$ biến giải thích: $X_1 = 1$, $X_2 = x$ và với $j = 3, \cdots, k$
\begin{align}
X_j = \cfrac{\left[(x-c_{j-2})^3\right]^+ - \left[(x-c_k)^3\right]^+ }{c_k - c_{j-2}} - \cfrac{\left[(x-c_{k-1})^3\right]^+ - \left[(x-c_k)^3\right]^+}{c_k - c_{k-1}}
\end{align}

Hàm $\hat{f}$ thu được bằng cách hồi quy tuyến tính $Y$ theo $X_1$, $X_2$, $\cdots$, $X_k$ có dạng
\begin{align}
\hat{f}(x) = \hat{\beta}_1 \cdot X_1(x) + \hat{\beta}_2 \cdot X_2(x) + \cdots + \hat{\beta}_k \cdot X_k(x)
\end{align}
là một natural splines vì:

1. Khi $x$ nhỏ hơn $c_1$ hoặc $x$ lớn hơn $c_k$ hàm $f$ là một hàm tuyến tính. Thật vậy

- Với $x < c_1$ ta có $X_j(x) = 0$ với mọi $j \geq 3$, do đó
\begin{align}
\hat{f}(x) = \hat{\beta}_1 \cdot X_1(x) + \hat{\beta}_2 \cdot X_2(x) = \hat{\beta}_1 + \hat{\beta}_2 \cdot x
\end{align}
là một hàm tuyến tính.

- Với $x > c_k$ ta có: hệ số của $x^3$ của $X_j$ là 
\begin{align}
\cfrac{1 - 1}{c_k - c_{j-2}} - \cfrac{1 - 1}{c_k - c_{k-1}} = 0 - 0 = 0
\end{align}
và hệ số của $x^2$ của $X_j$ là
\begin{align}
\cfrac{-3c_{j-2} + 3c_k}{c_k - c_{j-2}} - \cfrac{-3c_{k-1} + 3c_k}{c_k - c_{k-1}} = 3 - 3 = 0
\end{align}

Nói cách khác, hàm $\hat{f}(x)$ là một hàm tuyến tính theo $x$ khi $x$ nhỏ hơn $c_1$ hoặc $x$ lớn hơn $c_k$.

2. Khi $x$ nhận giá trị bất kỳ giữa hai nút $c_{j-1}$ và $c_j$, hàm $f$ là một đa thức bậc ba.

3. Hàm $f$ có liên tục, và có các đạo hàm đến bậc hai liên tục tại nút $c_j$ bất kỳ. Điều này hiển nhiên vì tất cả các hàm $X_j(x)$ đều liên tục và có đạo hàm đến bậc hai liên tục tại nút $c_j$ bất kỳ, do đó tổ hợp tuyến tính của các hàm $X_j(x)$ cũng có tính chất này.

### Tại sao smoothing splines lại là một natural spline {#gamapen3}
Trước hết, nếu $f(x)$ là một natural spline trên đoạn $[a,b]$ đi qua $n$ điểm $(x_i, z_i)$ với $n$ nút thắt tại $x_1, x_2, \cdots, x_n$ thì với mọi hàm số $g(x)$ có đạo hàm bậc hai liên tục và cũng đi qua $n$ điểm $(x_i, z_i)$, ta sẽ có
\begin{align}
\int\limits_{a}^b \ \left[g^{''}(x)\right]^2 dx \geq \int\limits_{a}^b \ \left[f^{''}(x)\right]^2 dx
\end{align}
nói một cách khác, trong tất cả các hàm có đạo hàm bậc hai liên tục đi qua $n$ điểm cho trước $(x_i, z_i)$, natural spline là hàm số ít linh hoạt nhất.

Thật vậy, cho $h(x) = g(x) - f(x)$, ta có $h^{''}(x) = g^{''}(x) - f(x)^{''}$ và
\begin{align}
\int\limits_{a}^b f^{''}(x) h^{''}(x) dx = \left[f^{''}(x) h'(x) \right]^b_a - \int\limits_{a}^b f^{'''}(x) h^{'}(x) dx
\end{align}

Dễ thấy 
\begin{align}
\left[f^{''}(x) h'(x) \right]^b_a = f^{''}(b) h'(b) - f^{''}(a) h'(a) = 0
\end{align}
do $f^{''}(b) = f^{''}(a) = 0$ vì $f$ là hàm tuyến tính khi $x < x_1$ và $x > x_n$. Thêm vào đó
\begin{align}
\int\limits_{a}^b f^{'''}(x) h^{'}(x) dx & = \int\limits_{x_1}^{x_n} f^{'''}(x) h^{'}(x) dx \\
& = \sum\limits_{i=1}^n \int\limits_{x_1}^{x_{i+1}} f^{'''}(x) h^{'}(x) dx \\
& = \sum\limits_{i=1}^n \left[f^{'''}(x) h(x) \right]^{x_{i+1}}_{x_i} -  \sum\limits_{i=1}^n \int\limits_{x_1}^{x_{i+1}} f^{(4)}(x) h(x) dx
\end{align}

Ta có $h(x_i) = g(x_i) - f(x_i) = z_i - z_i = 0$ do cả hai hàm $g$ và $f$ đều đi qua điểm $(x_i, z_i)$. Đồng thời $f^{(4)}(x) = 0$ với mọi $x$ do $f$ là một hàm bậc 3. Nói cách khác, giá trị của biểu thức $\int\limits_{a}^b f^{''}(x) h^{''}(x) dx$ cũng bằng 0.

Dựa vào kết quả trên, có thể thấy rằng
\begin{align}
\int\limits_{a}^b \ \left[g^{''}(x)\right]^2 dx & = \int\limits_{a}^b \ \left[f^{''}(x) + h^{''}(x)\right]^2 dx \\
& = \int\limits_{a}^b \ \left[f^{''}(x)\right]^2 dx + 2 \cdot \int\limits_{a}^b f^{''}(x) h^{''}(x) dx + \int\limits_{a}^b \ \left[h^{''}(x)\right]^2 dx \\
& = \int\limits_{a}^b \ \left[f^{''}(x)\right]^2 dx + \int\limits_{a}^b \ \left[h^{''}(x)\right]^2 dx \\
& \geq \int\limits_{a}^b \ \left[f^{''}(x)\right]^2 dx
\end{align}
và dấu bằng xảy ra chỉ khi $h^{''}(x) = 0$ với mọi $x$. Điều này chỉ xảy ra khi $h$ là một hàm tuyến tính. Tuy nhiên, ta lại có $h(x_i) = 0$ với mọi $i$, do đó $h(x) = 0$ với mọi $x$.

Quay trở lại với Smoothing spline, giả sử $\hat{f}$ là lời giải của bài toán tối ưu
\begin{align}
\hat{f} = \underset{f}{\operatorname{argmin}} \sum\limits_{i=1}^n (y_i - f(x_i))^2 + \lambda \cdot \int\limits_a^b f^{''}(t)^2 dt
\end{align}

Gọi $\tilde{f}$ là natural spline đi qua các điểm $(x_i, \hat{f}(x_i))$ và có nút tại tất cả các $x_i$ với $1 \leq i \leq n$ thì theo kết quả ở trên ta có 
\begin{align}
\int\limits_{a}^b \ \left[\hat{f}^{''}(x)\right]^2 dx \geq \int\limits_{a}^b \ \left[\tilde{f}^{''}(x)\right]^2 dx
\end{align}
ngoài ra 
\begin{align}
\sum\limits_{i=1}^n (y_i - \hat{f}(x_i))^2 = \sum\limits_{i=1}^n (y_i - \tilde{f}(x_i))^2
\end{align} 
hay nói một cách khác
\begin{align}
\sum\limits_{i=1}^n (y_i - \hat{f}(x_i))^2 + \lambda \cdot \int\limits_a^b \hat{f}^{''}(t)^2 dt \geq \sum\limits_{i=1}^n (y_i - \tilde{f}(x_i))^2 + \lambda \cdot \int\limits_a^b \tilde{f}^{''}(t)^2 dt
\end{align}
điều này chỉ có thể xảy ra khi $\hat{f}(x) = \tilde{f}(x)$ với mọi $x$

### Ước lượng smoothing splines {#gamapen4}
Do smoothing splines là một natural spline nên dạng hàm của smoothing spline có thể viết dưới dạng
\begin{align}
\hat{f}(x) = \hat{\beta}_1 \cdot X_1(x) + \hat{\beta}_2 \cdot X_2(x) + \cdots + \hat{\beta}_k \cdot X_k(x)
\end{align}
với
\begin{align}
X_j = \cfrac{\left[(x-c_{j-2})^3\right]^+ - \left[(x-c_k)^3\right]^+ }{c_k - c_{j-2}} - \cfrac{\left[(x-c_{k-1})^3\right]^+ - \left[(x-c_k)^3\right]^+}{c_k - c_{k-1}}
\end{align}

Có thể chứng minh được rằng các hệ số $\boldsymbol{\hat\beta}$ để hàm $\hat{f}$ là nghiệm của bài toán tối ưu 
\begin{align}
\hat{f} = \underset{f}{\operatorname{argmin}} \sum\limits_{i=1}^n (y_i - f(x_i))^2 + \lambda \cdot \int\limits_a^b f^{''}(t)^2 dt
\end{align}
là nghiệm của bài toán tối ưu tương ứng
\begin{align}
\boldsymbol{\hat\beta} = \underset{\boldsymbol{\beta}}{\operatorname{argmin}} \left(\textbf{y} - \textbf{x} \boldsymbol{\beta}\right)^T \left(\textbf{y} - \textbf{x} \boldsymbol{\beta}\right) + \lambda \cdot \boldsymbol{\beta}^T \Omega \boldsymbol{\beta}
\end{align}
với $\lambda > 0$, $\textbf{x}$ là ma trận kích thước $n \times k$ các biến giải thích có phần tử nằm ở hàng thứ $i$ cột thứ $j$ là $X_j(x_i)$ và  $\Omega$ là ma trận kích thước  $k \times k$ và
\begin{align}
\Omega_{j,l} = \int\limits_{a}^b X_j(t) X_l(t) dt
\end{align}
với $1 \leq j,l \leq n$. Có thể thấy rằng ước lượng smoothing spline cũng tương tự như ước lượng tham số của hồi quy ridge. Ta có lời giải chính xác cho các hệ số tuyến tính:
\begin{align}
\boldsymbol{\hat\beta} = \left( \textbf{x}^T \textbf{x} + \lambda \Omega \right)^{-1} \textbf{x}^T \textbf{y}
\end{align}

Tương tự như hồi quy ridge, giá trị $\lambda$ sẽ quyết định mức độ linh hoạt của smoothing spline: nếu $\lambda$ lớn thì sự linh hoạt của các smoothing spline sẽ giảm và ngược lại, nếu $\lambda$ giảm thì mức độ linh hoạt của hàm sẽ tăng. Mức độ linh hoạt thường được đo lường bằng khái niệm bậc tự do hiệu quả. Với hệ số $\boldsymbol{\hat\beta}$ ước lượng được như trên, chúng ta có giá trị ước lượng cho biến mục tiêu $\hat{y}$ như sau
\begin{align}
\hat{y} & = \textbf{x} \boldsymbol{\hat\beta} \\
& = \textbf{x} \left( \textbf{x}^T \textbf{x} + \lambda \Omega \right)^{-1} \textbf{x}^T \textbf{y} \\
& = \textbf{S}_{\lambda} \textbf{y}
\end{align}
với
\begin{align}
\textbf{S}_{\lambda} = \textbf{x} \left( \textbf{x}^T \textbf{x} + \lambda \Omega \right)^{-1} \textbf{x}^T
\end{align}

Bậc tự do hiệu quả của smoothing spline được xác định cũng giống như trong hồi quy ridge, là vết của ma trận $\textbf{S}_{\lambda}$, được ký hiệu là $trace\left(\textbf{S}_{\lambda}\right)$. 



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