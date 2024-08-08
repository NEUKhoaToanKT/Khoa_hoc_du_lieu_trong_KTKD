---
output:
  pdf_document: default
  html_document: default
---


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

```
## 
## Attaching package: 'kableExtra'
```

```
## The following object is masked from 'package:dplyr':
## 
##     group_rows
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

```
## 
## Attaching package: 'pryr'
```

```
## The following object is masked from 'package:dplyr':
## 
##     where
```

```
## Loading required package: lattice
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

```
## randomForest 4.7-1.1
```

```
## Type rfNews() to see new features/changes/bug fixes.
```

```
## 
## Attaching package: 'randomForest'
```

```
## The following object is masked from 'package:gridExtra':
## 
##     combine
```

```
## The following object is masked from 'package:ggplot2':
## 
##     margin
```

```
## The following object is masked from 'package:dplyr':
## 
##     combine
```

# (PART) PHẦN V: MÔ HÌNH CÂY QUYẾT ĐỊNH {-}


# Mô hình cây quyết định

Trong chương này, chúng tôi trình bày các phương pháp hồi quy và phân loại dựa trên cây quyết định. Mô hình dạng cây quyết định liên quan đến kỹ thuật phân chia miền giá trị của các biến giải thích hành các miền nhỏ có tính chất tương tự nhau. Để đưa ra dự đoán cho một quan sát, mô hình cây quyết định hồi quy sử dụng giá trị trung bình của các quan sát nằm trong miền tương ứng. Đối với bài toán phân loại, cây quyết định thường sử dụng giá trị mode của các quan sát nằm trong miền này. Các quy tắc dùng để phân tách miền xác định của các biến giải thích được sử dụng có thể được mô tả theo kiểu một cây quyết định nên các kiểu xây dựng mô hình như vậy thường được gọi là mô hình dạng cây quyết định. 

Các phương pháp hồi quy và phân loại dựa trên cây quyết định khá đơn giản và dễ dàng trong việc diễn giải. Tuy nhiên, các phương pháp này thường không so sánh được về khả năng dự đoán chính xác so với các phương pháp học máy có giám sát đã được trình bày trong các chương trước, chẳng hạn như hồi quy Splines, Smoothing Splines, hoặc mô hình cộng tính tổng quát khi có nhiều biến giải thích. Tuy nhiên, mô hình dạng cây quyết định lại thích hợp khi sử dụng kết hợp vơi các kỹ thuật thống kê hiện đại như rừng ngẫu nhiên hoặc học tăng cường để cho kết quả dự đoán chính xác vượt trội. Một lợi thế khác của mô hình dạng cây quyết định đó là mô hình này có thể sử dụng trực tiếp với cả bài toán hồi quy và phân loại mà không cần một sự biến đổi đáng kể nào về cách tiếp cận. 

Trong chương này chúng tôi sẽ trình bày về mô hình dạng cây quyết định sử dụng trong bài toán hồi quy và phân loại và sau đó giới thiệu đến bạn đọc thuật toán kỹ thuật kết hợp nhiều cây quyết định để cải thiện khả năng dự đoán của mô hình còn được biến đến với tên gọi là thuật toán $rừng$ $ngẫu$ $nhiên$. Kỹ thuật học tăng cường (boosting) sẽ được giới thiệu đến bạn đọc trong chương tiếp theo.

## Cơ bản về mô hình cây quyết định
Như chúng tôi đã đề cập, cây quyết định có thể được áp dụng cho cả bài toán hồi quy và bài toán phân loại. Chúng ta xem xét bài toán hồi quy trước sau đó chuyển sang cây quyết định phân loại. Bạn đọc sẽ thấy rằng cách xây dựng mô hình cây quyết định và cây quyết định hồi quy là hoàn toàn tương tự nhau, chỉ khác nhau về mục tiêu tối thiểu hóa.

### Mô hình cây quyết định hồi quy
#### Xây dựng cây quyết định hồi quy trên dữ liệu Boston
Để bắt đầu với cây quyết định hồi quy, chúng ta bắt đầu bằng một ví dụ đơn giản trên một cây hồi quy đơn biến. Chúng tôi sử dụng dữ liệu Boston để dự đoán biến mục tiêu là giá nhà tại các vùng (biến $medv$, đơn vị là nghìn USD) dựa trên tỷ lệ số người có mức sống thấp trong vùng đó (biến $lstat$, đơn vị là \%). Hình \@ref(fig:fgtree01) mô tả một cây hồi quy phù hợp với dữ liệu này.

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree01-1.png" alt="Cây quyết định hồi quy kích thước bằng 3 mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình trên dữ liệu Boston. Tại mỗi điểm phân nhánh, ký hiệu lstat &lt; c chỉ định phân nhánh sang bên trái, nghĩa là các điểm dữ liệu thuộc có tính chất lstat &lt; c nằm trong nhánh bên trái trong khi các điểm dữ liệu có lstat lớn hơn hoặc bằng c sẽ nằm sang nhánh bên phải. Cây quyết định ở trên có hai nút và ba lá tương ứng với ba tập hợp con của dữ liệu." width="672" />
<p class="caption">(\#fig:fgtree01)Cây quyết định hồi quy kích thước bằng 3 mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình trên dữ liệu Boston. Tại mỗi điểm phân nhánh, ký hiệu lstat < c chỉ định phân nhánh sang bên trái, nghĩa là các điểm dữ liệu thuộc có tính chất lstat < c nằm trong nhánh bên trái trong khi các điểm dữ liệu có lstat lớn hơn hoặc bằng c sẽ nằm sang nhánh bên phải. Cây quyết định ở trên có hai nút và ba lá tương ứng với ba tập hợp con của dữ liệu.</p>
</div>

Bạn đọc có thể thấy rằng một cây quyết định bao gồm một chuỗi các quy tắc phân chia, bắt đầu từ ngọn cây xuống dưới. Phần phân chia trên cùng chỉ định các quan sát có $lstat < 9.725 (\%)$ cho nhánh cây bên trái và các quan sát có $lstat \geq 9.725(\%)$ cho nhánh bên phải. Giá nhà cho các vùng có tỷ lệ người có thu nhập thấp lớn hơn hoặc bằng 9.725% được dự đoán bằng giá trị trung bình của các quan sát trong dữ liệu huấn luyện và bằng 17.34 nghìn USD. 
Những vùng có $lstat \geq 9.725(\%)$ được chỉ định vào nhánh bên trái và sau đó lại được chia nhỏ hơn thành hai nhánh, nhánh bên phải là các quan sát có $lstat < 4.65(\%)$ và nhánh bên phải là các quan sát có $lstat \geq 4.65(\%)$. Giá nhà được dự đoán tại các vùng có $lstat < 4.65(\%)$ là giá trị trung bình của các ngôi nhà trong dữ liệu huấn luyện mô hình có tính chất tương ứng và bằng 39.72 nghìn USD. Tương tự, tại các vùng có $lstat$ nhận giá trị từ 4.65% đến 9.725% giá nhà được dự đoán là 26.65 nghìn USD. Ba tập con riêng biệt của dữ liệu về giá nhà ở Boston được phân tách theo cây quyết định dựa trên biến $lstat$ và giá trị ước lượng tương ứng cho giá nhà được tổng kết lại như sau:
\begin{align}
R_1 &= \{X \ | lstat < 4.65\} \rightarrow \hat{y} = 39.72 \\
R_2 &= \{X \ | lstat \geq 4,65 \ \ \& \ \ lstat < 9.725 \} \rightarrow \hat{y} = 26.65  \\
R_3 &= \{X \ | lstat \geq 9.725 \} \rightarrow \hat{y} = 17.34 
(#eq:tree001)
\end{align}

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree02-1.png" alt="Hàm f được ước lượng từ mô hình cây quyết định có dạng hàm bậc thang nhận giá trị bằng hằng số trên các miền giá trị được phân tách của biến giải thích." width="672" />
<p class="caption">(\#fig:fgtree02)Hàm f được ước lượng từ mô hình cây quyết định có dạng hàm bậc thang nhận giá trị bằng hằng số trên các miền giá trị được phân tách của biến giải thích.</p>
</div>

Hình \@ref(fig:fgtree02) mô tả hàm số được ước lượng theo cây quyết định khi có một biến giải thích duy nhất. Bạn đọc có thể thấy rằng trong trường hợp chỉ có một biến, cây quyết định cũng giống như các hồi quy theo đa thức theo từng đoạn, với bậc của các đa thức là bằng 0. Nói cách khác, hàm $f$ là hằng số trên các khoảng giá trị khác nhau của biến giải thích. Các nút chia dữ liệu ra thành các miền con là 9.725 và 4.65 được tính toán sao cho sai số (RSS) trên dữ liệu huấn luyện mô hình là nhỏ nhất. Chúng ta sẽ thảo luận chi tiết về ước lượng mô hình cây quyết định ở phần tiếp theo của chương.  
Điều gì xảy ra nếu chúng ta sử dụng đồng thời hai biến là biến $lstat$ và biến $rm$. Biến $rm$ cho biết trung bình trong một ngôi nhà ở vùng quan sát có bao nhiêu phòng. Hình \@ref(fig:fgtree03) mô tả một cây quyết định hồi quy khi sử dụng đồng thời hai biến $lstat$ biến $rm$

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree03-1.png" alt="Cây quyết định hồi quy kích thước bằng ba mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình và số lượng phòng trung bình của mỗi ngôi nhà trên dữ liệu Boston. Điểm phân nhánh (nút) đầu tiên phụ thuộc vào biến rm. Nút thứ hai phụ thuộc vào biến lstat." width="672" />
<p class="caption">(\#fig:fgtree03)Cây quyết định hồi quy kích thước bằng ba mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình và số lượng phòng trung bình của mỗi ngôi nhà trên dữ liệu Boston. Điểm phân nhánh (nút) đầu tiên phụ thuộc vào biến rm. Nút thứ hai phụ thuộc vào biến lstat.</p>
</div>

Bạn đọc có thể nhận thấy sự khác biệt giữa mô hình cây quyết định có một biến giải thích trong Hình \@ref(fig:fgtree01) và mô hình cây quyết định có hai biến giải thích \@ref(fig:fgtree03). Khi có hai biến giải thích, nút đầu tiên được sử dụng để phân tách dữ liệu là $rm < 6.941$ và nút thứ hai sử dụng để phân tách dữ liệu là $lstat < 14.4$. Tuy nhiên, cần lưu ý rằng nút phân tách thứ hai không được thực hiện trên toàn bộ dữ liệu, mà chỉ được thực hiện trên miền bên trái của nút $rm < 6.941$. Như vậy, ba miền dữ liệu được định nghĩa theo cây quyết định này và giá trị ước lượng tương ứng cho giá nhà có thể được tóm tắt như sau
\begin{align}
R_1 &= \{X \ | rm < 6.941 \ \ \& \ \  lstat < 14.4 \} \rightarrow \hat{y} = 23.35 \\
R_2 &= \{X \ | rm < 6.941 \ \ \& \ \ lstat \geq 14.4  \} \rightarrow \hat{y} = 14.96  \\
R_3 &= \{X \ | rm \geq 6.941 \} \rightarrow \hat{y} = 37.24
(#eq:tree002)
\end{align}

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree04-1.png" alt="Mô hình cây quyết định hồi quy chia hình chữ nhật thành ba phần R1, R2, và R3 và giá nhà trong mỗi miền là hằng số" width="672" />
<p class="caption">(\#fig:fgtree04)Mô hình cây quyết định hồi quy chia hình chữ nhật thành ba phần R1, R2, và R3 và giá nhà trong mỗi miền là hằng số</p>
</div>

Mô hình cây quyết định hồi quy được mô tả trong các hình \@ref(fig:fgtree03), \@ref(fig:fgtree04), hoặc phương trình \@ref(eq:tree001) có thể được giải thích rất dễ dàng như sau: ở những vùng có số phòng trung bình lớn hơn 6.941 (miền R3) giá nhà được dự đoán là 37.24 nghìn USD, ở những vùng số phòng trung bình nhỏ hơn 6.941 và tỷ lệ số người thu nhập thấp dưới 14.4(%) (miền R1) thì giá nhà được dự đoán là 23.35 nghìn USD, và cuối cung ở những vùng số phòng trung bình nhỏ hơn 6.941 và tỷ lệ số người thu nhập thấp lớn hơn 14.4(%) (miền R2) thì giá nhà được dự đoán là 14.96 nghìn USD. Bạn đọc có thể thấy rằng các mô hình dạng cây quyết định là rất dễ dàng để giải thích, thậm chí còn dễ dàng hơn so với các mô hình hồi quy tuyến tính.

Một cách tổng quát, có thể tóm tắt lại quá trình xây dựng một cây quyết định hồi quy để mô tả mối liên hệ giữa biến mục tiêu $Y$ và các $p$ biến giải thích $X_1$, $X_2$, $\cdots$, $X_p$ như sau:

Thứ nhất: Chúng ta chia không gian các giá trị có thể có của các biến giải thích thành $J$ các vùng riêng biệt và không chồng lấn lên nhau, tạm gọi là $R_1$, $R_2$, $\cdots$ , $R_K$. 

Thứ hai: Đối với tất cả quan sát rơi vào vùng $R_k$, với $1 \leq k \leq K$, chúng ta đưa ra dự đoán giống nhau là giá trị trung bình của các giá trị của biến mục tiêu $Y$ của các quan sát của dữ liệu huấn luyện nằm trong vùng $R_k$. Ví dụ: giả sử ở bước thứ nhất, chúng ta có hai vùng, $R_1$ và $R_2$, và trung bình của biến mục tiêu của các quan sát trong dữ liệu huấn luyện ở vùng $R_1$ là 5, trong khi trung bình của biến mục tiêu của các quan sát trong dữ liệu huấn luyện ở vùng $R_2$ là 10. Khi đó, đối với một quan sát bất kỳ $X = x$, nếu $x \in R_1$ chúng ta sẽ dự đoán biến mục tiêu là 5 và nếu $x \in R_2$ chúng ta sẽ dự đoán biến mục tiêu là 10.

#### Ước lượng tham số mô hình cây quyết định
Về lý thuyết, ước lượng tham số cho mô hình cây quyết định là quá trình tìm cách xây dựng các vùng $R_1$, $R_2$, $\cdots$, $R_K$? Các vùng này có thể có hình dạng bất kỳ miễn là các vùng không có chồng lấn và hợp của các vùng là miền giá trị của các biến giải thích. Tuy nhiên, nếu lựa chọn chia không gian các biến giải thích thành vùng có dạng hình chữ nhật nhiều chiều thì mô hình sẽ dễ diễn giải và ước lượng hơn rất nhiều. Một vùng hình chữ nhật nhiều chiều có thể được hiểu là một vùng mà mỗi biến giải thích $X_j$ chỉ bị giới hạn bởi hai giá trị đầu mút là $a_j$ và $b_j$ và không chịu tác động từ các biến giải thích khác:
\begin{align}
\cup_{j=1}^p \{X_j \in [a_j, b_j] \}
\end{align}

Với $R_k$ là các hình chữ nhật nhiều chiều, chúng ta cần tìm cách phân chia miền giá trị của các biến giải thích ra thành $K$ hình chữ nhật như vậy với mục tiêu là tối thiểu hóa sai số RSS. Lưu ý rằng RSS được tính dựa trên dự báo cho mỗi miền $R_k$ bằng $\hat{y}_{R_k}$ là giá trị trung bình của biến mục tiêu trong miền này. Tuy nhiên khó khăn thực tế là không thể tính toán được hết mọi phân vùng có thể có của không gian các biến giải thích. Các tiếp cận khả thi để tìm kiếm phân vùng theo cách phân tách nhị phân từ trên xuống:

- Tại bước thứ nhất: chúng ta tìm cách chia toàn bộ không gian biến giải thích thành hai hình chữ nhật sao cho sai số RSS trên dữ liệu huấn luyện mô hình là nhỏ nhất.

- Tại bước thứ hai: chúng ta tìm cách chia một trong hai hình chữ nhật thu được trong bước thứ nhất sao cho sai số RSS trên dữ liệu huấn luyện mô hình là nhỏ nhất.

- ...

- Tại bước thứ $K$: chúng ta tìm cách chia một trong $K-1$ hình chữ nhật thu được trong bước thứ $K-1$ thành hai hình chữ nhật con sao cho sai số RSS tính từ $K$ hình chữ nhật là nhỏ nhất.

Đây là quá trình tìm kiếm $tham$ $lam$ bởi vì tại mỗi bước của quá trình xây dựng cây quyết định, chúng ta luôn tìm kiếm sự phân tách tốt nhất có thể dựa trên kết quả của bước tốt nhất trước đó. Cách tìm kiếm này là khả thi nhưng không chắc chắn rằng chúng ta có thể tìm được phân vùng tối ưu. Trong một hình hộp bất kỳ, để thực hiện phân tách thành hai phần, chúng ta cần lựa chọn biến giải thích $X_j$ và điểm cắt $s$ nằm trong miền giá trị của $X_j$ sao cho khi chia hình chữ nhật thành hai vùng: vùng các biến giải thích có $X_j < s$ và vùng các biến giải thích $X_j \leq s$
\begin{align}
R_1(X_j, s) = \{\textbf{X} | X_j < s \} \\
R_2(X_j, s) = \{\textbf{X} | X_j \leq s \}
(#eq:tree003)
\end{align}
sau đó chúng ta cần tìm $j$ và $s$ sao cho tổng bình phương sai số là nhỏ nhất:
\begin{align}
\sum\limits_{x_i \in R_1} (y_i - \hat{y}_{R_1})^2 + \sum\limits_{x_i \in R_2} (y_i - \hat{y}_{R_2})^2
(#eq:tree004)
\end{align}
trong đó $\hat{y}_{R_1}$ là giá trị trung bình của biến mục tiêu trong miền $R_1$ và $\hat{y}_{R_2}$ là giá trị trung bình của biến mục tiêu trong miền $R_2$. Quá trình tìm các giá trị của $j$ và $s$ để tối thiểu hóa \@ref(eq:tree004) có thể được thực hiện khá nhanh, đặc biệt khi số lượng biến giải thích $p$ không quá lớn. Chúng ta sẽ lặp lại quy trình tìm kiếm biến giải thích tốt nhất và điểm cắt tốt nhất trên biến giải thích đó để tiếp tục phân tách dữ liệu và để giảm RSS. Quá trình tiếp tục cho đến khi cây quyết định đạt đến một tiêu chí dừng nào đó. Chúng ta cần đặt ra các tiêu chí dừng bởi vì nếu tiếp tục quá trình phân tách dữ liệu cho đến $n$ bước với $n$ là số quan sát trong dữ liệu huấn luyện mô hình thì mô hình cây quyết định sẽ chia dữ liệu ra thành $n$ vùng và mỗi vùng tương ứng với một quan sát. Một cây quyết định như vậy có sai số trên huấn luyện mô hình bằng 0 nhưng không có ý nghĩa trong diễn giải hoặc dự đoán biến mục tiêu. Các tiêu chí dừng thường được sử dụng thường là số lượng dữ liệu nằm trong một vùng không được phép ít hơn một số nào đó. Nếu mọi sự phân tách đều dẫn đến việc số lượng điểm dữ liệu trong một lá nhỏ hơn một ngưỡng, thường là 5 hoặc 10 điểm dữ liệu, thì chúng ta nên dừng quá trình phân tách.

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree05-1.png" alt="Cây quyết định hồi quy kích thước bằng 4, mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình và số lượng phòng trung bình của mỗi ngôi nhà trên dữ liệu Boston. So với cây quyết định có 3 lá ở trên, vùng R3 đã được chia thành hai phần là R3-1 và R3-2. Các vùng R1 và R2 không thay đổi" width="672" />
<p class="caption">(\#fig:fgtree05)Cây quyết định hồi quy kích thước bằng 4, mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình và số lượng phòng trung bình của mỗi ngôi nhà trên dữ liệu Boston. So với cây quyết định có 3 lá ở trên, vùng R3 đã được chia thành hai phần là R3-1 và R3-2. Các vùng R1 và R2 không thay đổi</p>
</div>

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree06-1.png" alt="Cây quyết định hồi quy kích thước bằng 5, mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình và số lượng phòng trung bình của mỗi ngôi nhà trên dữ liệu Boston. So với cây quyết định có 4 lá ở trên, vùng R1 đã được chia thành hai phần là R1-1 và R1-2. Các vùng R2, R3-1, và R3-2 không thay đổi" width="672" />
<p class="caption">(\#fig:fgtree06)Cây quyết định hồi quy kích thước bằng 5, mô tả giá nhà phụ thuộc vào tỷ lệ người sống dưới mức trung bình và số lượng phòng trung bình của mỗi ngôi nhà trên dữ liệu Boston. So với cây quyết định có 4 lá ở trên, vùng R1 đã được chia thành hai phần là R1-1 và R1-2. Các vùng R2, R3-1, và R3-2 không thay đổi</p>
</div>

Các Hình \@ref(fig:fgtree05) và \@ref(fig:fgtree06) mô tả các bước thứ tư và bước thứ năm trong xây dựng mô hình cây quyết định mô tả biến giá nhà ($medv$) phụ thuộc vào hai biến $lstat$ và $rm$. Để xây dựng mô hình cây quyết định có 4 lá, từ ba vùng $R_1$, $R_2$, và $R_3$ thu được trong Hình \@ref(fig:fgtree03), có sáu lựa chọn để chia không gian các biến giải thích thành hai vùng (có 3 vùng và mỗi vùng có hai lựa chọn để phân chia theo một trong hai biến là $rm$ hoặc $lstat$). Trong số các lựa chọn đó, phân chia vùng $R3$ theo biến $rm$ tại điểm cắt $rm = 7.437$ là cách phân chia làm cho giá trị RSS là nhỏ nhất. Kết quả thu được là một cây quyết định có bốn lá tương ứng với bốn vùng là $R_1$, $R_2$, $R_3-1$, và $R_3-2$.

Quá trình ước lượng cây quyết định có năm lá cũng diễn ra tương tự. Từ bốn vùng thu được từ bước trước, chúng ta có 8 lựa chọn để tiếp tục phân chia dữ liệu thành năm vùng (4 vùng và 2 biến giải thích). Trong số các lựa chọn đó, phân chia vùng $R_1$ thành hai vùng theo biến $lstat$ tại điểm 4.91 là phân chia làm cho RSS giảm đi nhiều nhất. Kết quả thu được là một cây quyết định có năm lá tương ứng với năm vùng $R_1-1$, $R_1-2$, $R_2$, $R_3-1$, và $R_3-2$.

Như chúng tôi đã đề cập ở trên, nếu chúng ta tiếp tục quá trình phân chia dữ liệu sẽ thu được một cây quyết định đủ lớn để có thể nội suy lại chính xác biến mục tiêu. Kể cả khi chúng ta đặt ra các tiêu chí dừng, các cây quyết định có kích thước lớn thường gặp phải hiện thượng overfitting. Do đó, tham số kích thước của cây quyết định $K$ thường được lựa chọn dựa trên xác thực chéo. Các cây quyết định có ưu điểm là đơn giản và không tốn nguồn lực tính toán nhiều, do đó xác thực chéo hoàn toàn có thể thực hiện được trong đa số các trường hợp.

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree07-1.png" alt="Mô hình cây quyết định biến medv phụ thuộc vào lstat và rm trên dữ liệu Boston. Kích thước cây quyết định được lựa chọn dựa trên xác thực chéo. Số lượng lá cho sai số xác thực chéo nhỏ nhất là 9" width="672" />
<p class="caption">(\#fig:fgtree07)Mô hình cây quyết định biến medv phụ thuộc vào lstat và rm trên dữ liệu Boston. Kích thước cây quyết định được lựa chọn dựa trên xác thực chéo. Số lượng lá cho sai số xác thực chéo nhỏ nhất là 9</p>
</div>

Trước khi chuyển sang phần cây quyết định phân loại, chúng tôi sẽ thảo luận về lựa chọn điểm cắt phù hợp để tách dữ liệu thành hai phần. Chúng ta quay trở lại với mô hình cây quyết định với một biến giải thích duy nhất là $lstat$ trong Hình \@ref(fig:fgtree01), khi mà điểm cắt đầu tiên được ước lượng là 9.725%. Nguyên tắc ước lượng ra điểm cắt này như sau: với biến giải thích $X_j$ là biến liên tục, chúng ta loại bỏ các quan sát của biến $X_j$ bị trùng lặp và sắp xếp lại các quan sát này theo thứ tự tăng dần, chẳng hạn như $x_{1j}$ < $x_{2j}$ < $\cdots$ < $x_{nj}$. Khi đó, có $n-1$ điểm cắt cần được tính toán tổng sai số bình phương (RSS) là các điểm
\begin{align}
\cfrac{x_{1j} + x_{2j}}{2}, \cfrac{x_{2j} + x_{3j}}{2}, \cdots, \cfrac{x_{(n-1)j} + x_{nj}}{2}
\end{align}
và điểm cắt tối ưu là điểm cắt có RSS nhỏ nhất. Bạn đọc có thể thấy rằng điểm cắt 9.725 là giá trị trung bình của hai giá trị quan sát được của biến $medv$ trong dữ liệu là điểm 9.71 và điểm 9.74.

Nếu biến giải thích $X_j$ là biến dạng rời rạc hoặc biến định tính với có thể nhận $k$ giá trị khác nhau. Khi đó chúng ta xắp xếp $k$ giá trị đó theo thứ tự mà giá trị trung bình của biến mục tiêu tính trên nhóm đó tăng dần. Chẳng hạn như $k$ giá trị của $X_j$ được xắp xếp theo thứ tự là $c_{1} \rightarrow c_{2} \rightarrow \cdots \rightarrow c_k$, nghĩa là giá trị trung bình của biến mục tiêu trong miền $X_j = c_i$ nhỏ hơn giá trị trung bình của biến mục tiêu trong miền $X_j = c_{i+1}$. Khi đó, có $k-1$ cách phân chia dữ liệu cần được cân nhắc
\begin{align}
&\text{Cách 1. Vùng 1: } X_j = c_1 \text{ và vùng 2: } X_j \in \{c_2, c_3, \cdots, c_k\} \\
&\text{Cách 2. Vùng 1: } X_j \in \{c_1, c_2\} \text{ và vùng 2: } X_j \in \{c_3, c_4, \cdots, c_k\} \\
&\cdots \\
&\text{Cách (k-1). Vùng 1: } X_j \in \{c_1, c_2, \cdots, c_{k-1}\} \text{ và vùng 2: } X_j = c_k
\end{align}
và lựa chọn phân vùng tối ưu là lựa chọn phân vùng có RSS nhỏ nhất. Ví dụ, chúng ta xây dựng mô hình cây quyết định trong đó biến mục tiêu $medv$ phụ thuộc vào biến $rad$ là biến rời rạc mô tả khả năng kết nối với đường cao tốc của vùng. Biến $rad$ trong dữ liệu Boston có 9 giá trị riêng biệt là các số tự nhiên từ 1 đến 8 và số 24. Lưu ý rằng đây là biến rời rạc danh nghĩa không có ý nghĩa so sánh giữa các giá trị với nhau. Giá trị trung bình của biến mục tiêu theo các giá trị riêng biệt của $rad$ được cho trong bảng \@ref(tab:tbtree01)

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbtree01)(\#tab:tbtree01)Giá nhà trung bình tính theo các giá trị riêng biệt của biến rời rạc rad</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Biến rad </th>
   <th style="text-align:right;"> Giá nhà trung bình </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 24 </td>
   <td style="text-align:right;"> 16.40379 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 20.97692 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 21.38727 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 24.36500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 25.70696 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 26.83333 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:right;"> 27.10588 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 27.92895 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:right;"> 30.35833 </td>
  </tr>
</tbody>
</table>

Dựa theo tính toán từ bảng \@ref(tab:tbtree01), có 8 cách phân vùng có thể khi sử dụng biến $rad$ để phân vùng được liệt kê như sau
\begin{align}
&\text{Cách 1. Vùng 1: } rad = 24 \text{ và vùng 2: } rad \in \{6, 4, 1, 5, 2, 7, 3, 8 \} \\
&\text{Cách 2. Vùng 1: } rad \in \{24, 6 \} \text{ và vùng 2: } rad \in \{4, 1, 5, 2, 7, 3, 8\} \\
&\text{Cách 3. Vùng 1: } rad \in \{24, 6, 4 \} \text{ và vùng 2: } rad \in \{1, 5, 2, 7, 3, 8\} \\
&\text{Cách 4. Vùng 1: } rad \in \{24, 6, 4, 1 \} \text{ và vùng 2: } rad \in \{5, 2, 7, 3, 8\} \\
&\text{Cách 5. Vùng 1: } rad \in \{24, 6, 4, 1, 5 \} \text{ và vùng 2: } rad \in \{2, 7, 3, 8\} \\
&\text{Cách 6. Vùng 1: } rad \in \{24, 6, 4, 1, 5, 2 \} \text{ và vùng 2: } rad \in \{7, 3, 8\} \\
&\text{Cách 7. Vùng 1: } rad \in \{24, 6, 4, 1, 5, 2, 7 \} \text{ và vùng 2: } rad \in \{3, 8\} \\
&\text{Cách 8. Vùng 1: } rad \in \{24, 6, 4, 6, 4, 1, 5, 2, 7 \} \text{ và vùng 2: } rad = 8
\end{align}
và cách phân vùng cho RSS nhỏ nhất sẽ là phân vùng được lựa chọn. Hình \@ref(fig:fgtree08) mô tả cây quyết định có hai lá trong đó biến mục tiêu là $medv$ và biến giải thích là biến $rad$.

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree08-1.png" alt="Cây quyết định hồi quy kích thước bằng hai mô tả giá nhà phụ thuộc vào biến rời rạc là khả năng kết nối của ngôi nhà đến đường cao tốc trên dữ liệu Boston." width="672" />
<p class="caption">(\#fig:fgtree08)Cây quyết định hồi quy kích thước bằng hai mô tả giá nhà phụ thuộc vào biến rời rạc là khả năng kết nối của ngôi nhà đến đường cao tốc trên dữ liệu Boston.</p>
</div>
Như vậy phân vùng có RSS nhỏ nhất là cách phân vùng thứ 3. Các giá trị rời rạc 24, 4, 6 của biến $rad$ được cho vào nhánh bên trái cây quyết định với dự đoán cho giá nhà là 18.89 nghìn USD trong khi các giá trị rời rạc còn lại được cho vào nhánh bên phải của cây quyết định với dự đoán cho giá nhà là 26.63 nghìn USD

### Cây quyết định phân loại
Cây quyết định có lợi thế là có thể sử dụng cho cả bài toán hồi quy và bài toán phân loại mà không cần có sự biến đổi đáng kể nào về mặt mô hình. Thay đổi duy nhất để cây quyết định phù hợp với bài toán phân loại đó là thay đổi hàm tổn thất từ RSS sang các hàm tổn thất phù hợp với bài toán phân loại. RSS không phù hợp trong bài toán phân loại vì giá trị dự đoán chúng ta đưa ra tại mỗi lá của cây quyết định là giá trị xuất hiện với tần suất lớn nhất chứ không phải giá trị trung bình của các biến nằm trong lá đó.

Quá trình xây dựng cây quyết định phân loại hoàn toàn tương tự như quá trình xây dựng cây quyết định hồi quy. Chúng ta sử dụng chuỗi các phân tách nhị phân để phân vùng không gian giá trị các biến giải thích thành $k$ vùng $R_1, R_2, \cdots, R_K$ không chồng lấn lên nhau và ở mỗi vùng $R_k$ chúng ta đưa ra một dự đoán $\hat{y}_{R_k}$ cho biến mục tiêu. Trong mô hình hồi quy giá trị dự đoán là giá trị trung bình của biến mục tiêu tương ứng với các quan sát nằm trong vùng $R_k$ còn trong bài toán phân loại giá trị dự đoán $\hat{y}_{R_k}$ là giá trị của biến mục tiêu xuất hiện với tần suất lớn nhất tương ứng với các quan sát trong vùng $R_k$. 

Như đã trình bày trong cây phân loại hồi quy, để thực hiện phân tách một vùng thành hai phần, chúng ta cần lựa chọn biến giải thích $X_j$ và điểm cắt $s$ nằm trong miền giá trị của $X_j$ sao cho khi chia hình chữ nhật thành hai vùng: vùng các biến giải thích có $X_j < s$ và vùng các biến giải thích $X_j \leq s$
\begin{align}
R_1(X_j, s) = \{\textbf{X} | X_j < s \} \\
R_2(X_j, s) = \{\textbf{X} | X_j \leq s \}
\end{align}
với các dự đoán cho biến mục tiêu tương ứng với hai vùng là $\hat{y}_{R_1}$ và $\hat{y}_{R_2}$, chúng ta cần tìm $j$ và $s$ để tối thiểu hóa sai số của bài toán phân loại. Để lượng hóa sai số của bài toán phân loại, có nhiều cách tiếp cận. Cách tiếp cận tự nhiên và đơn giản nhất là sử dụng $tỷ$ $lệ$ $dự$ $đoán$ $sai$ (còn được gọi là classification error rate hay viết tắt là CER). Cho một véc-tơ $\textbf{y}$ có độ dài $n$ chỉ nhận các giá trị rời rạc là $1, 2, \cdots, m$ và tần suất xuất hiện của các giá trị rời rạc này lần lượt là $n_1$, $n_2$, $\cdots$, $n_m$. Nếu $\textbf{y}$ là các giá trị của biến mục tiêu quan sát được trong một vùng của biến giải thích thì giá trị dự đoán cho biến mục tiêu sẽ là $h \in \{1, 2, \cdots, m \}$ sao cho $n_h = max(n_1, n_2, \cdots, n_m)$. Tỷ lệ dự đoán sai trên véc-tơ $\textbf{y}$ được tính như sau
\begin{align}
CER(\textbf{y}) = 1 - \cfrac{n_h}{n}
(#eq:tree005)
\end{align}
Có thể thấy rằng CER là tỷ lệ số dự đoán sai trên véc-tơ $\textbf{y}$ khi sử dụng đoán là $h = mode(\textbf{y})$. CER có ưu điểm là dễ hiểu và đơn giản, tuy nhiên nhược điểm lớn nhất của CER là chỉ tính đến giá trị xuất hiện với tần suất nhiều nhất mà không tính đến các giá trị khác, do đó chỉ tiêu này không phù hợp khi sử dụng để phân vùng các cây phân loại, đặc biệt là trong trường hợp biến giải thích nhận nhiều hơn 2 giá trị.

Hai chỉ số khác thường xuyên được sử dụng thay thế cho nhau để tìm ra phân vùng tối ưu trong cây quyết định phân loại là chỉ số Gini và chỉ số Entropy. Hai chỉ số này có ưu điểm là tính toán đến sự xuất hiện của tất cả các giá trị có xuất hiện trong véc-tơ $\textbf{y}$
\begin{align}
Gini(\textbf{y}) &= \sum\limits_{l = 1}^m \ \cfrac{n_l}{n} \ \left( 1 - \cfrac{n_l}{n}\right) \\
Entropy(\textbf{y}) &= - \sum\limits_{l = 1}^m \ \cfrac{n_l}{n} \ \log\left(\cfrac{n_l}{n}\right)
(#eq:tree006)
\end{align}
Các chỉ số Gini và Entropy còn được gọi là các thước đo độ thuần (purity) của véc-tơ $\textbf{y}$. Do $n_l/n$ nằm trong đoạn $[0,1]$ và tổng các tần suất $n_l/n$ bằng 1 nên các chỉ số Gini và Entropy sẽ có giá trị nhỏ khi tồn tại một giá trị $n_l/n$ xấp xỉ 1 và các giá trị còn lại xấp xỉ 0. Nếu cố định $n_h/n$ với $h$ là giá trị xuất hiện nhiều nhất trong $y$ và thay đổi các $n_l$ khác thì CER sẽ không thay đổi trong khi Gini và Entropy sẽ thay đổi. Đây là lý do tại sao chỉ số Gini và Entropy sẽ phù hợp hơn khi đo lường độ thuần của một véc-tơ. 

Để thấy được sự phù hợp của chỉ số Gini và chỉ số Entropy trong lựa chọn phân vùng giá trị của biến giải thích, hãy quan sát ví dụ trong Hình \@ref(fig:fgtree09)

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree09-1.png" alt="Ví dụ về hai lựa chọn phân vùng khác nhau cho véc-tơ biến mục tiêu bao gồm ba giá trị riêng biệt là 1, 2, và 3 với tần suất xuất hiện là 6 lần, 3 lần và 3 lần. Nếu sử dụng chỉ số tỷ lệ dự đoán sai thì hai cách phân vùng là không có sự khác biệt. Nếu sử dụng chỉ số Entropy hoặc Gini thì cách phân vùng thứ 2 tốt hơn" width="672" />
<p class="caption">(\#fig:fgtree09)Ví dụ về hai lựa chọn phân vùng khác nhau cho véc-tơ biến mục tiêu bao gồm ba giá trị riêng biệt là 1, 2, và 3 với tần suất xuất hiện là 6 lần, 3 lần và 3 lần. Nếu sử dụng chỉ số tỷ lệ dự đoán sai thì hai cách phân vùng là không có sự khác biệt. Nếu sử dụng chỉ số Entropy hoặc Gini thì cách phân vùng thứ 2 tốt hơn</p>
</div>
Giả sử chúng ta phải đưa ra lựa chọn đâu là phân vùng tốt hơn giữa hai cách phân vùng được mô tả trong hình \@ref(fig:fgtree09). Một cách trực giác, bạn đọc có thể nhận thấy rằng cách phân vùng thứ hai sẽ dẫn đến một cây phân loại tốt hơn vì đã tách biệt được hoàn toàn giá trị 2 và giá trị 3 vào hai vùng. Với cách phân vùng như vậy, nếu chúng ta tiếp tục thực hiện phân vùng thì nhiều khả năng trong bước tiếp theo chúng ta sẽ phân loại được hoàn toàn giá trị 1 và giá trị 2 trong vùng $R_1$ và phân loại được hoàn toàn giá trị 1 và giá trị 3 trong vùng $R_2$. Trái lại, trong cách phân vùng thứ nhất, không thể phân tách hai giá trị 2 và 3 ra thành các vùng riêng biệt. Nếu chúng ta tiếp tục phát triển thêm 1 lá cho cây quyết định như trong cách thứ nhất, không thể thu được phân loại chính xác cho cả ba giá trị của biến mục tiêu.

Bạn đọc có thể sử dụng các chỉ số sai số phân loại, Gini và Entropy để so sánh hai cách phân vùng như sau:

- Cho cách phân vùng thứ nhất:
\begin{align}
CER & = \cfrac{6}{12} \times \cfrac{3}{6} + \cfrac{6}{12} \times \cfrac{3}{6} = 0.5 \\
Gini & = \cfrac{6}{12} \times \left[\cfrac{3}{6}\left(1 - \cfrac{3}{6}\right) + \cfrac{2}{6}\left(1 - \cfrac{2}{6}\right) + \cfrac{1}{6}\left(1 - \cfrac{1}{6}\right) \right] + \\
& \cfrac{6}{12} \times \left[\cfrac{3}{6}\left(1 - \cfrac{3}{6}\right) + \cfrac{1}{6}\left(1 - \cfrac{1}{6}\right) + \cfrac{2}{6}\left(1 - \cfrac{2}{6}\right) \right] = 0.61\\
Entropy & = - \cfrac{6}{12} \times \left[\cfrac{3}{6} \log\left(\cfrac{3}{6}\right) + \cfrac{2}{6}\log\left(\cfrac{2}{6}\right) + \cfrac{1}{6}\log\left(1 - \cfrac{1}{6}\right) \right] + \\
& \cfrac{6}{12} \times \left[\cfrac{3}{6}\log\left(\cfrac{3}{6}\right) + \cfrac{1}{6}\log\left(\cfrac{1}{6}\right) + \cfrac{2}{6}\log\left( \cfrac{2}{6}\right) \right] = 1.01
\end{align}

- Cho cách phân vùng thứ hai
\begin{align}
CER & = \cfrac{6}{12} \times \cfrac{3}{6} + \cfrac{6}{12} \times \cfrac{3}{6} = 0.5 \\
Gini & = \cfrac{6}{12} \times \left[\cfrac{3}{6}\left(1 - \cfrac{3}{6}\right) + \cfrac{3}{6}\left(1 - \cfrac{3}{6}\right)\right] + \\
& \cfrac{6}{12} \times \left[\cfrac{3}{6}\left(1 - \cfrac{3}{6}\right) + \cfrac{3}{6}\left(1 - \cfrac{3}{6}\right) \right] = 0.5\\
Entropy & = - \cfrac{6}{12} \times \left[\cfrac{3}{6} \log\left(\cfrac{3}{6}\right) + \cfrac{3}{6} \log\left(\cfrac{3}{6}\right) \right] + \\
& \cfrac{6}{12} \times \left[\cfrac{3}{6} \log\left(\cfrac{3}{6}\right) + \cfrac{3}{6} \log\left(\cfrac{3}{6}\right) \right] = 0.69
\end{align}

Bạn đọc có thể thấy rằng chỉ số CER trong hai cách phân vùng bằng nhau và bằng 0.5, nghĩa là CER không có khả năng phân biệt giữa cách phân vùng thứ nhất và cách phân vùng thứ hai. Chỉ số Gini và Entropy của phân vùng thứ hai đều nhỏ hơn cho với cách phân vùng thứ nhất, điều này cho thấy hai chỉ số này có khả năng phân biệt cách phân vùng tốt hơn so với CER.

Hình \@ref(fig:fgtree10) mô tả cây quyết định được xây dựng trên dữ liệu OJ, dữ liệu chứa thông tin về 1070 lần khách hàng mua một trong hai loại sản phẩm nước cam Citrus Hill hoặc Minute Maid, với biến mục tiêu là $Purchase$ chứa một trong hai giá trị là $CH$ hoặc $MM$ cho biết sản phẩm được mua tương ứng là Citrus Hill hay Minute Maid. Dữ liệu có 17 biến giải thích bao gồm các biến có nhiều khả năng cho ý nghĩa quan trọng trong xây dựng mô hình như sự khác biệt về giá của hai loại sản phẩm (biến $PriceDiff$) cho biết giá của $MM$ cao hơn giá của $CH$ như thế nào, hoặc biến $LoyalCH$ là biến đo sự trung thành của khách hàng với nhãn hiệu Citrus Hill. Sự trung thành của khách hàng là thước đo sự mua hàng lặp lại trên một nhãn hiệu dựa trên đánh giá về chất lượng hoặc dịch vụ tốt hơn các đối thủ cạnh tranh và không phụ thuộc vào giá cả của nhãn hiệu đó.

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree10-1.png" alt="Cây quyết định phân loại cho biết quyết định mua sản phẩm nước cam của khách hàng dựa vào các biến giải thích khác sử dụng dữ liệu OJ." width="672" />
<p class="caption">(\#fig:fgtree10)Cây quyết định phân loại cho biết quyết định mua sản phẩm nước cam của khách hàng dựa vào các biến giải thích khác sử dụng dữ liệu OJ.</p>
</div>

Có thể thấy rằng biến $LoyalCH$ xuất hiện ở hầu hết các nút của cây quyết định, điều này cho thấy sự trung thành của khách hàng với nhãn hiệu sản phẩm quyết định rất lớn đến quyết định mua hàng của khách hàng. Chúng ta có thể giải thích cây quyết định phân loại trên như sau: 

- Khi lòng trung thành của khách hàng với sản phẩm Citrus Hill thấp (nhỏ hơn 0.5), tương ứng với nhánh cây quyết định bên trái của nút trên cùng, thì đa số các khách hàng sẽ lựa chọn sản phẩm Minute Maid. Trong nhánh bên trái này, những khách hàng có chỉ số lòng trung thành với Citrus Hill dưới 0.27 sẽ chọn sản phẩm Minute Maid bất kể sự khác biệt về giá cả. Còn những khách hàng có chỉ số trung thành với sản phẩm Citrus Hill từ 0.27 trở lên sẽ có thay đổi quyết định để mua sản phẩm Citrus Hill nếu giá của Minute Maid không lớn hơn giá của Citrus Hill cộng thêm 0.05.

- Khi lòng trung thành của khách hàng với sản phẩm Citrus Hill lớn (lớn hơn 0.5), tương ứng với nhánh cây quyết định bên phải của nút trên cùng, thì đa số các khách hàng sẽ lựa chọn sản phẩm Citrus Hill. Trong nhánh này, những khách hàng có chỉ số lòng trung thành với Citrus Hill trên 0.76 sẽ chọn sản phẩm Citrus Hill bất kể sự khác biệt về giá cả. Còn những khách hàng có chỉ số trung thành với sản phẩm Citrus Hill dưới 0.76 sẽ có thay đổi quyết định và mua sản phẩm Minute Maid nếu giá của Minute Maid thấp hơn giá của Citrus Hill 0.165

Một sự khác biệt trong kết quả của cây quyết định phân loại và cây phân loại hồi quy đó là hai lá tách ra từ một nút vẫn có thể nhận kết quả giống nhau. Chẳng hạn như trong hình \@ref(fig:fgtree10) bạn đọc có thể thấy rằng tại nút $LoyalCH < 0.0356$, cả hai lá đều cho kết quả là $MM$. Nguyên nhân là do chúng ta sử dụng chỉ số Gini để phân vùng dữ liệu. Sai số phân loại của cây quyết định sẽ không giảm nếu hai lá từ một nút cho cùng một kết quả là $MM$ nhưng độ thuần (purity) của các nút sẽ giảm.

### Cây quyết định và mô hình tuyến tính
Cây quyết định hồi quy và cây quyết định phân loại có cách tiếp cận hoàn toàn khác so với các mô hình tuyến tính mà chúng tôi thảo luận trong cá chương trước. Nếu như mô hình tuyến tính cho rằng hàm $f$ mô tả mối liên hệ giữa biến mục tiêu $Y$ và các biến giải thích $X_1$, $X_2$, $\cdots$, $X_p$ có dạng tuyến tính
\begin{align}
f(\textbf{X}) = \beta_0 + \sum\limits_{j=1}^p \beta_j \cdot X_j
\end{align}
thì mô hình cây quyết định sử dụng dạng của hàm $f$ như sau
\begin{align}
f(\textbf{X}) = \sum\limits_{m=1}^M c_m \cdot \mathbb{I}_{\textbf{X} \in R_m}
\end{align}
trong đó $R_1, R_2, \cdots, R_M$ là một phân vùng của miền xác định của véc-tơ biến giải thích $\textbf{X}$. Không có câu trả lời cho câu hỏi là mô hình nào tốt hơn. Câu trả lời hoàn toàn tùy thuộc vào dữ liệu mà chúng ta xây dựng mô hình. Nếu mối liên hệ của biến mục tiêu và biến giải thích là mối liên hệ tuyến tính, mô hình tuyến tính sẽ cho kết quả tốt hơn, còn nếu mối liên hệ đó là phi tuyến, mô hình cây quyết định sẽ cho kết quả tốt hơn. Tất nhiên, với một dữ liệu cụ thể, không thể biết được chính xác mối liên hệ giữa biến mục tiêu với các biến khác là tuyến tính hay phi tuyến, do đó cách tốt nhất để biết mô hình nào tốt hơn là xây dựng cả hai dạng mô hình và sau đó sử dụng sai số xác thực chéo để đưa ra kết luận.

Việc lựa chọn mô hình cũng phụ thuộc vào mục tiêu của người xây dựng mô hình. Nếu mục tiêu của xây dựng mô hình là để suy diễn, đánh giá tác động của các biến giải thích lên biến mục tiêu thì mô hình cây quyết định là mô hình dễ diễn giải và mô tả dữ liệu hơn cả. Mô hình tuyến tính thông thường cũng có khả năng diễn giải kết quả tốt trong khi các mở rộng của mô hình tuyến tính như hồi quy Splines, hay mô hình cộng tính tổng quát dẫn đến các kết quả ít có ý nghĩa diễn giải. Ngược lại, nếu mục tiêu của người xây dựng mô hình là dự đoán biến mục tiêu, nghĩa là để giảm thiểu sai số dự đoán trên dữ liệu kiểm thử mô hình, các mở rộng của mô hình tuyến tính sẽ cho sai số dự báo tốt hơn nhiều so với mô hình cây quyết định.

Trước khi chuyển sang phần tiếp theo, chúng ta có thể tổng kết lại những điểm mạnh và điểm yếu của mô hình cây quyết định như sau:

- Lợi thế thứ nhất của mô hình cây quyết định trước tiên là khả năng diễn giải mô hình. Bạn đọc có thể thấy rằng mô hình cây quyết định thậm chí còn dễ giải thích hơn cả mô hình hồi quy tuyến tính thông thường. Một trong những nguyên nhân khiến cho cây quyết định dễ diễn giải là do cách cây quyết định được xây dựng có mối liên hệ chặt chẽ với việc ra quyết định của não bộ của con người. 

- Thứ hai, mô hình cây quyết định có thể được trực quan hóa bằng đồ họa và có thể dễ dàng để hiểu được ngay cả với người không có nền tảng về toán học.

- Thứ ba, mô hình cây quyết định có thể sử dụng cho dữ liệu có biến giải thích và biến mục tiêu định tính mà không cần có thay đổi đáng kể nào. Bạn đọc có thể thấy rằng gần như không có sự khác biệt trong cách xây dựng cây quyết định hồi quy và cây quyết định phân loại. Đồng thời cách xây dựng cây quyết định dựa trên biến giải thích định lượng và định tính gần như không có sự khác biệt.

- Để nói về những hạn chế khi sử dụng mô hình dạng cây, trước hết phải khẳng định rằng mô hình cây quyết định trình bày trong các phần trước không có khả năng dự báo chính xác như các mô hình khác. Đó cũng là sự đánh đổi mà bạn đọc thường xuyên gặp phải khi xây dựng mô hình trên dữ liệu, luôn có sự đánh đổi giữa khả năng dự báo và khả năng diễn giải của mô hình.
 
- Nhược điểm thứ hai, cũng là nguyên nhân giải thích nhược điểm thứ nhất, đó là mô hình cây quyết định là các mô hình có phương sai lớn, nghĩa là chỉ cần có một thay đổi nhỏ trong dữ liệu xây dựng mô hình, kết quả của mô hình sẽ có sự thay đổi đáng kể.

Trong phần cuối của chương sách này và trong chương sau, chúng tôi sẽ giới thiệu đến bạn đọc các kỹ thuật thống kê hiện đại có thể sử dụng kết hợp với mô hình cây quyết định để khắc phục được nhược điểm của mô hình này. Các kỹ thuật này bao gồm có mô hình rừng ngẫu nhiên (còn gọi là random forest) và kỹ thuật học tăng cường (còn được gọi là boosting).

## Thực hành: xây dựng mô hình cây quyết định sử dụng R

### Cây quyết định hồi quy trên dữ liệu Boston

### Cây quyết định phân loại trên dữ liệu Titanic

## Thuật toán rừng ngẫu nhiên

### Phương pháp lấy mẫu lặp lại
Phương pháp lấy mẫu lặp lại (thường gọi là boostrap) là một công cụ vô cùng quan trọng trong thống kê hiện đại. Phương pháp này liên quan đến việc lấy mẫu lặp lại nhiều lần từ dữ liệu huấn luyện ban đầu và ước lượng mô hình trên mỗi mẫu để có thông tin đầy đủ về mô hình hay tham số của mô hình mà chúng ta đang nghiên cứu. Ví dụ: để đánh giá mô hình hồi quy tuyến tính đơn biến trong đó biến mục tiêu $Y$ phụ thuộc vào biến giải thích $X$ dựa trên dữ liệu quan sát được: $(x_i, y_i)$ với $1 \leq i \leq n$, nếu chúng ta sử dụng toàn bộ $n$ quan sát để ước tính hệ số chặn và hệ số góc, chúng ta chỉ có một ước lượng điểm duy nhất. Nếu không có giả thiết quan trọng của mô hình hồi quy tuyến tính là $Y$ có phân phối chuẩn thì chúng ta sẽ không đưa ra được phân phối xác suất hay các khoảng tin cậy cho hệ số của mô hình tuyến tính. Kỹ thuật lấy mẫu lặp tiếp cận theo hướng hoàn toàn khác, thay vì xuất phát từ phân phối xác suất của biến mục tiêu, chúng ta có thể liên tục lấy các mẫu khác nhau từ dữ liệu huấn luyện ban đầu, với mỗi mẫu lấy được chúng ta ước lượng được một hệ số chặn và một hệ số góc, từ đó thu được một phân phối xác suất của các hệ số. 

Để mô tả phương pháp lấy mẫu lặp lại, chúng ta sử dụng ví dụ về dữ liệu Quảng cáo mà trong đó doanh thu bán sản phẩm phụ thuộc vào các biến giải thích là chi phí quảng cáo trên truyền hình ($TV$), chi phí quảng cáo trên mạng xã hội ($Social\_Media$) và chi phí quảng cáo qua tờ rơi ($Flyer$). Do biến quảng cáo qua tờ rơi không có ý nghĩa trong mô hình hồi quy đa biến nên mô hình được lựa chọn chỉ bao gồm hai biến giải thích là $TV$ và $Social\_Media$. 
\begin{align}
Sales = \beta_0 + \beta_1 \cdot TV + \beta_2 \cdot Social\_Media + \epsilon

\end{align}

Hệ số ước lượng của mô hình tuyến tính đa biến như sau

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbtree02)(\#tab:tbtree02)Các hệ số ước lượng trong mô hình hồi quy đa biến trên dữ liệu Quảng cáo.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
   <th style="text-align:right;"> Ước lượng </th>
   <th style="text-align:right;"> Độ lệch chuẩn </th>
   <th style="text-align:right;"> Thống kê t </th>
   <th style="text-align:right;"> p-value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:right;"> 4.0642 </td>
   <td style="text-align:right;"> 0.7349 </td>
   <td style="text-align:right;"> 5.5302 </td>
   <td style="text-align:right;"> 0.0000011 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TV </td>
   <td style="text-align:right;"> 0.0192 </td>
   <td style="text-align:right;"> 0.0049 </td>
   <td style="text-align:right;"> 3.9600 </td>
   <td style="text-align:right;"> 0.0002289 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Social_Media </td>
   <td style="text-align:right;"> 0.0699 </td>
   <td style="text-align:right;"> 0.0128 </td>
   <td style="text-align:right;"> 5.4746 </td>
   <td style="text-align:right;"> 0.0000013 </td>
  </tr>
</tbody>
</table>

Từ kết quả ước lượng, chúng ta có các hệ số \beta = $\beta_0$, $\beta_1$, $\beta_2$ là các biến ngẫu nhiên phân phối chuẩn với giá trị trung bình lần lượt là 4.0642, 0.0192, 0.0699 và độ lệch chuẩn lần lượt là 0.7349, 0.0049, 0.0128. Các tính toán này được dựa trên giả thiết quan trọng là phần dư $\epsilon$ có phân phối chuẩn $\mathcal{N}(0,\sigma^2)$. Phương pháp lấy mẫu lặp không cần tính đến giả thiết phân phối của phần dư, mà sử dụng phép lấy mẫu lặp lại từ dữ liệu quảng cáo. Mỗi lần lấy mẫu lặp, chúng ta tạo ra một dữ liệu có số quan sát đúng bằng số quan sát của dữ liệu ban đầu, tuy nhiên một quan sát có thể bị lặp lại nhiều lần. Với mỗi mẫu lặp như vậy, chúng ta thực hiện một ước lượng bằng phương pháp bình phương nhỏ nhất để thu được các hệ số. Phân phối xác suất của các hệ số bằng phương pháp hồi quy truyền thống và phương pháp lấy mẫu lặp được trình bày trong hình \@ref(fig:fgtree11)
 
<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree11-1.png" alt="Phân phối xác suất của các hệ số của mô hình hồi quy tuyến tính đa biến. Cột bên trái: phân phối xác suất được tính toán từ phương pháp bình phương nhỏ nhất truyền thống. Cột bên phải: phân phối xác suất được tạo thành từ 1000 lần lấy mẫu lặp. Hàng thứ nhất: phân phối xác suất của hệ số chặn. Hàng thứ hai: phân phối xác suất của hệ số tuyến tính của biến TV. Hàng thứ ba: phân phối xác suất của hệ số tuyến tính của biến Social_Media. Các đường màu đỏ ở giữa cho biết giá trị trung bình của hệ số." width="672" />
<p class="caption">(\#fig:fgtree11)Phân phối xác suất của các hệ số của mô hình hồi quy tuyến tính đa biến. Cột bên trái: phân phối xác suất được tính toán từ phương pháp bình phương nhỏ nhất truyền thống. Cột bên phải: phân phối xác suất được tạo thành từ 1000 lần lấy mẫu lặp. Hàng thứ nhất: phân phối xác suất của hệ số chặn. Hàng thứ hai: phân phối xác suất của hệ số tuyến tính của biến TV. Hàng thứ ba: phân phối xác suất của hệ số tuyến tính của biến Social_Media. Các đường màu đỏ ở giữa cho biết giá trị trung bình của hệ số.</p>
</div>

Bạn đọc có thể thấy rằng phân phối xác suất của các hệ số tính toán từ phương pháp lấy mẫu lặp không khác đáng kể so với phân phối xác suất được ước lượng với giả thiết phân phối chuẩn. Như vậy với phương pháp lấy mẫu lặp, bạn đọc có thể tính toán được giá trị trung bình của các hệ số và sai số của ước lượng mà không cần thêm bất kỳ giả thiết nào về hình dạng của phân phối. Đánh đổi lại, để thực hiện ước lượng tham số bằng lấy mẫu lặp, nguồn lực tính toán tăng lên theo số lần chúng ta lấy mẫu.

### Thuật toán rừng ngẫu nhiên
Phương pháp lấy mẫu lặp lại, hay bootstrap, được giới thiệu trước bởi vì đó là ý tưởng chủ đạo trong mô hình rừng ngẫu nhiên. Các mô hình cây quyết định được biết đến là các mô hình có phương sai lớn, nghĩa là chỉ cần có một thay đổi nhỏ trong dữ liệu huấn luyện, mô hình có thể sẽ thay đổi đáng kể. Như bạn đọc đã biết, một phương pháp đơn giản để không làm thay đổi giá trị trung bình và giảm phương sai của dự đoán đó là dự đoán nhiều lần và sử dụng kết quả trung bình của các dự đoán. Nói một cách khác, giả sử chúng ta sử dụng một biến ngẫu nhiên $Z_1$ có giá trị trung bình $\mu$ (không biết) để làm dự đoán cho $\mu$. Bằng một cách nào đó, thay vì sử dụng một dự đoán duy nhất, nếu chúng ta có thể tạo ra một dãy các biến ngẫu nhiên $Z_1$, $Z_2$, $\cdots$, $Z_n$ và sử dụng $\bar{Z}$ là giá trị trung bình của các biến ngẫu nhiên kể trên, thì phương sai trong dự đoán sẽ nhỏ hơn phương sai khi sử dụng một dự đoán duy nhất. Trong trường hợp đặc biệt, nếu các $Z_i$ độc lập với nhau, phương sai của $\bar{Z}$ bằng $\frac{1}{n}$ phương sai của một dự đoán duy nhất, với $n$ là số lần dự đoán.

Với ý tưởng tương tự như vậy, để giảm phương sai của các mô hình có phương sai lớn, chúng ta cần xây dựng nhiều mô hình dự đoán riêng bằng cách sử dụng nhiều dữ liệu huấn luyện và sử dụng giá trị trung bình để dự đoán kết quả. Nói cách khác, nếu chúng ta có $T$ dữ liệu huấn luyện mô hình, chúng ta có thể xây dựng $T$ mô hình cây quyết định (phân loại hoặc hồi quy) $\hat{f}_1$, $\hat{f}_2$, $\cdots$  ,$\hat{f}_T$ và sau đó lấy trung bình của các mô hình này để thu được một mô hình có phương sai thấp
\begin{align}
\hat{f}_{avg} = \cfrac{1}{T} \ \sum\limits_{t = 1}^T \ \hat{f}_t
(#eq:tree007)
\end{align}

Tất nhiên, chúng ta không thể có được $T$ tập dữ liệu huấn luyện mô hình để xây dựng $T$ mô hình dự đoán. Thay vào đó, chúng ta có thể thực hiện phương pháp lấy mẫu lặp lại $T$ lần trên dữ liệu huấn luyện mô hình ban đầu. Với mỗi dữ liệu thu được, chúng ta xây dựng một cây quyết định và mô hình thu được sau cùng là giá trị trung bình của $T$ mô hình thu được giống như phương trình \@ref(eq:tree007). Với cây quyết định hồi quy giá trị trung bình được hiểu đúng với ý nghĩa, nghĩa là nếu một biến mục tiêu $y_i$ được dự đoán từ $T$ cây quyết định hồi quy lần lượt là $\hat{y}_{i,1}$, $\hat{y}_{i,2}$, $\cdots$, $\hat{y}_{i,T}$ thì giá trị dự đoán của mô hình trung bình là
\begin{align}
\hat{y}_i = \cfrac{1}{T} \sum\limits_{t = 1}^T \ \hat{y}_{i,t}
\end{align}
Đối với cây quyết định phân loại, giá trị dự đoán trong mô hình trung bình là mode của véc-tơ các giá trị dự đoán, nghĩa là nếu biến mục tiêu $y_i$ được dự đoán từ $T$ cây quyết định phân loại lần lượt là $\hat{y}_{i,1}$, $\hat{y}_{i,2}$, $\cdots$, $\hat{y}_{i,T}$ thì giá trị dự đoán của mô hình trung bình là
\begin{align}
\hat{y}_i =  mode\left(\hat{y}_{i,1}, \hat{y}_{i,2}, \cdots, \hat{y}_{i,T} \right)
\end{align}

Sử dụng giá trị trung bình của nhiều mô hình để dự đoán cho phép cải thiện đáng kể khả năng dự đoán và có thể sử dụng trong nhiều kiểu mô hình khác nhau. Cách tiếp cận này đặc biệt hữu ích trên mô hình cây quyết định và thuật ngữ "forest" có thể hiểu đơn giản là sử dụng nhiều cây quyết định kết hợp với nhau thành một mô hình duy nhất. Mỗi cây quyết định riêng lẻ có phương sai cao nhưng độ lệch thấp, và trung bình của $T$ cây như vậy có thể làm giảm phương sai. Thực tế chỉ ra rằng kỹ thuật này mang lại những cải tiến vượt bậc về độ chính xác trong dự đoán khi kết hợp hàng trăm hoặc thậm chí hàng nghìn cây vào một mô hình duy nhất. 

Chúng tôi đã giải thích thuật ngữ "forest", tiếp theo sẽ là thuật ngữ $"random"$. Quay trở lại ý tưởng khi sử dụng nhiều biến ngẫu nhiên $Z_i$ để dự đoán giá trị trung bình $\mathbb{E}(Z_i) = \mu$. Nếu các biến $Z_i$ có tương quan dương rất cao với nhau, thì phương sai của $\bar{Z}$ sẽ không được giảm đi một cách đáng kể so với phương sai của một biến duy nhất. Các cây quyết định được xây dựng để đưa ra dự đoán duy nhất trong phương trình \@ref(eq:tree007) rất có khả năng là có tương quan cao với nhau, bởi vì các cây được xây dựng từ các dữ liệu được lấy mẫu lặp lại từ một dữ liệu huấn luyện mô hình, và các cây có cùng một tập hợp các biến giải thích cho cùng một biến mục tiêu. Hiện tượng tương quan cao với nhau giữa các cây thường xảy ra khi trong tập hợp các biến giải thích có một biến có ý nghĩa giải thích mạnh vượt trội so với các biến giải thích khác. Khi chúng ta xây dựng các cây quyết định trên các dữ liệu được lấy mẫu từ dữ liệu ban đầu, biến giải thích này luôn luôn chiếm ưu thế và xuất hiện trong các nút phân vùng đầu tiên. Việc này làm cho kết quả dự đoán từ các cây quyết định có tương quan rất cao với nhau và dẫn đến phương sai của mô hình trung bình không được giảm đi đáng kể so với một cây quyết định riêng lẻ.

Để tránh gặp phải hiện tượng này, khi xây dựng cây quyết định từ một dữ liệu được boostrap từ dữ liệu huấn luyện mô hình, chúng ta chỉ sử dụng một tập hợp con bao gồm $m$ biến giải thích, $m < p$, được lựa chọn một cách ngẫu nhiên từ $p$ biến giải thích từ mô hình ban đầu. Trong trường hợp dữ liệu có một hoặc một vài biến giải thích mạnh, khả năng mà một biến này được sử dụng trong mô hình là $\cfrac{m}{p}$. Nói một cách khác, bằng cách chỉ sử dụng ngẫu nhiên $m$ biến trong số $p$ biến giải thích tại mỗi lần xây dựng cây quyết định, chúng ta có thể xây dựng được các cây quyết định ít có tương quan cao với nhau hơn, và do đó có thể thu được một mô hình trung bình có phương sai nhỏ hơn.

Khi xây dựng mô hình rừng ngẫu nhiên bao gồm $T$ cây quyết định, tại bước thứ $t$ chúng ta có dữ liệu $Data_t$ được boostrap từ dữ liệu huấn luyện mô hình,  người xây dựng mô hình lựa chọn ngẫu nhiên $m_t$ biến giải thích từ $p$ biến giải thích ban đầu, sau đó xây dựng một cây quyết định $\hat{f}_t$ với kích thước $L_t$ để mô tả mối quan hệ giữa biến giải thích và các biến mục tiêu. Các tham số $m_t$ và $L_t$ tại mỗi bước $t$ và số lượng cây quyết định $T$ là các tham số của mô hình rừng ngẫu nhiên. Thông thường thì tại mỗi bước $t$, kích thước cây $L_t$ sẽ được xác định bằng một tiêu chí dừng nào đó, giống như cách xây dựng một cây quyết định thông thường. Số lượng biến giải thích $m_t$ nếu nhận giá trị khác nhau tại các bước thì rất khó để điều khiển mô hình, do đó người xây dựng mô hình rừng ngẫu nhiên thường sử dụng $m_t$ cố định . Nói một cách khác, mô hình rừng ngẫu nhiên có hai tham số cần phải ước lượng là: 1. Số lượng cây quyết định (tham số $T$) và 2. Số lượng biến giải thích để ước lượng cây quyết định $m$. Các tham số này thường được tính toán sao cho sai số từ xác thực chéo là nhỏ nhất.

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree12-1.png" alt="Sai số xác thực chéo theo số lượng cây khi sử dụng thuật toán rừng ngẫu nhiên. Mỗi đường thể hiện cho một lựa chọn khác nhau của tham số m là số lượng biến giải thích được lựa chọn trong mỗi cây." width="672" />
<p class="caption">(\#fig:fgtree12)Sai số xác thực chéo theo số lượng cây khi sử dụng thuật toán rừng ngẫu nhiên. Mỗi đường thể hiện cho một lựa chọn khác nhau của tham số m là số lượng biến giải thích được lựa chọn trong mỗi cây.</p>
</div>
Hình \@ref(fig:fgtree12) mô tả quá trình sử dụng xác thực chéo để tìm tham số $T$ và tham số $m$ khi xây dựng mô hình rừng ngẫu nhiên trên dữ liệu Boston với biến mục tiêu là biến giá nhà ($medv$). Cặp tham số cho sai số xác thực chéo nhỏ nhất là $T = 120$ cây và $m = 6$ biến. Do giới hạn của khả năng tính toán nên chúng ta chỉ có thể thử trên các lựa chọn là $m = 2, 4$ hoặc $6$ và $T \leq 500$. Trên thực tế, $m$ thương được lựa chọn xung quang giá trị của $p/2$ nếu $p$ nhỏ và $\sqrt{p}$ nếu $p$ lớn trong khi $T$ chỉ có thể được lựa chọn thông qua xác thực chéo. Đồng thời, khi $m$ nhỏ thì tương quan giữa các cây quyết định sẽ thấp hơn nhưng khả năng dự đoán của các cây quyết định riêng lẻ sẽ kém đi nên thường cần nhiều cây quyết định hơn để đưa một kết quả có độ chính xác tương đương như khi $m$ lớn. Bạn đọc có thể thấy rằng khi $m = 2$ hoặc $m = 4$ thì sai số xác thực chéo có xu hướng tiếp tục giảm kể cả khi chúng ta tăng $T$ hơn 500, trong khi khi $m = 6$ thì điểm tối ưu đạt được ngay khi $T = 120$.

Bạn đọc có thể nhận thấy ngay sự khác biệt trong khả năng dự đoán của mô hình rừng ngẫu nhiên trong Hình \@ref(fig:fgtree12) và mô hình cây quyết định trong Hình \@ref(fig:fgtree07). Sai số xác thực chéo của mô hình rừng ngẫu nhiên với $m = 6$ và $T = 120$ là khoảng 3100 nghìn USD trong khi sai số xác thực chéo của cây quyết định tốt nhất là 4600 USD. Tuy nhiên, giải thích hay suy diễn kết quả của một cây quyết định là khá đơn giản trong khi việc diễn giải kết quả cho mô hình rừng ngẫu nhiên là vô cùng khó khăn. Đây chính là sự đánh đổi thường phải chấp nhận đối với người xây dựng mô hình.

Khi cố gắng giải thích một mô hình rừng ngẫu nhiên người xây dựng mô hình thường sử dụng thước đo sự quan trọng của từng biến giải thích. Có hai cách để định nghĩa sự quan trọng của biến giải thích: thứ nhất là tính toán giá trị trung bình của sự suy giảm độ chính xác của các mô hình cây quyết định khi biến đó không được tính vào trong mô hình, và thứ hai là tính toán tổng của sự suy giảm trong độ thuần (purity) của các nút có chứa biến đó trên tất cả các cây quyết định. Các thước đo này tính trên một biến giải thích lớn tương đối so với các biến giải thích khác nghĩa là biến đó quan trọng hơn và có nhiều ý nghĩa hơn trong mô hình rừng ngẫu nhiên. Bạn đọc có thể tham khảo thêm về cách tính toán mức độ quan trọng của các biến của mô hình rừng ngẫu nhiên trong phần \@ref(treeappen1).

<div class="figure">
<img src="11-mo-hinh-cay-quyet-dinh_files/figure-html/fgtree13-1.png" alt="Mức độ quan trọng của các biến trong mô hình rừng ngẫu nhiên trên dữ liệu Boston. Hình bên trái: sự quan trọng tính bằng sự suy giảm trung bình trong khả năng dự báo của các cây quyết định khi bỏ biến giải thích ra khỏi mô hình. Hình bên phải: sự quan trọng tính bằng tổng sự suy giảm trong độ thuần của các nút khi sử dụng biến giải thích." width="672" />
<p class="caption">(\#fig:fgtree13)Mức độ quan trọng của các biến trong mô hình rừng ngẫu nhiên trên dữ liệu Boston. Hình bên trái: sự quan trọng tính bằng sự suy giảm trung bình trong khả năng dự báo của các cây quyết định khi bỏ biến giải thích ra khỏi mô hình. Hình bên phải: sự quan trọng tính bằng tổng sự suy giảm trong độ thuần của các nút khi sử dụng biến giải thích.</p>
</div>

Hình \@ref(fig:fgtree13) cho thấy hai biến quan trọng nhất khi sử dụng mô hình rừng ngẫu nhiên để dự đoán giá nhà là $rm$ và $lstat$, nhóm các biến quan trọng thứ hai bao gồm có $dis$, $nox$, $ptratio$, và $crim$. Nhóm các biến ít có ý nghĩa trong dự đoán giá nhà là $chas$, $zn$ và $rad$.

## Thực hành: mô hình rừng ngẫu nhiên

### Xây dựng mô hình rừng ngẫu nhiên trên dữ liệu Boston

### Xây dựng mô hình rừng ngẫu nhiên trên dữ liệu OJ

## Bài tập

### Bài tập lý thuyết

### Bài tập thực hành

## Phụ lục

### Tính toán sự quan trọng của biến giải thích trong mô hình rừng ngẫu nhiên






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