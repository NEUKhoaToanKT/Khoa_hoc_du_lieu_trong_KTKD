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



# Boosting và cây quyết định.
Trong một vài cuốn sách, boosting được dịch sang tiếng Việt là học tăng cường, tuy nhiên trong cuốn sách này, chúng tôi giữ nguyên khái niệm này bởi vì chúng tôi không nghĩ rằng học tăng cường giải nghĩa được chính xác ý tưởng của Boosting. Tính đến thời điểm chúng tôi đang viết cuốn sách này, có thể khẳng định rằng boosting là một trong những ý tưởng mạnh mẽ nhất trong lĩnh vực học máy. Ban đầu boosting được áp dụng cho các bài toán phân loại, nhưng bạn đọc sẽ thấy rằng có thể dễ dàng áp dụng boosting cho các bài toán hổi quy để cho kết quả hơn cả mong đợi. Ý tưởng chung của boosting là kết hợp kết quả đầu ra của nhiều hàm phân loại, hoặc hàm hồi quy “yếu”, để tạo ra một hàm phân loại hoặc hồi quy "mạnh". Cùng là kết hợp nhiều hàm phân loại hay hổi quy, tuy nhiên boosting khác bagging hay random forest ở chỗ các hàm phân loại hoặc hồi quy được tạo ra theo thứ tự nhất định mà trong đó hàm phân loại hay hồi quy được tạo ra ở bước thứ $m$ sẽ phụ thuộc vào kết quả của hàm đó tại các bước thứ $1, 2, \cdots, (m-1)$. Trong bagging hay random forest, cách xây dựng hàm phân loại hay hổi quy ở lần thứ $m$ hoàn toàn không phụ thuộc vào kết quả của các bước trước đó.

Khái niệm boosting lần đầu tiên được nhắc đến trong nghiên cứu của Freund và Schapire (1997). Chúng tôi gọi thuật toán được giới thiệu trong nghiên cứu của Freund và Schapire là "AdaBoost.M1" để phân biệt với thuật toán AdaBoost thông dụng được trình bày trong nghiên cứu của Friedman (2000). Trong bài toán phân loại, biến mục tiêu chỉ nhận hai giá trị $Y \in \{-1,1\}$. Hàm phân loại được ký hiệu là $b^C$ và với véc-tơ biến độc lập $\textbf{x}_i$ chúng ta có $b^C(\textbf{x}_i) \in \{-1,1\}$. Sai số của hàm phân loại $b^C$ trên dữ liệu $(\textbf{x},y)$ được tính như sau
\begin{align}
err(\textbf{x},y) = \cfrac{1}{n} \ \sum\limits_{i=1}^n \mathbb{I}\left(b^C(\textbf{x}_i) \neq y_i \right) 
\end{align}

Môt hàm phân loại "yếu" $b^C$ là một hàm phân loại có khả năng dự báo chỉ tốt hơn một chút so với việc phân loại một cách ngẫu nhiên. Ý tưởng của boosting là áp dụng tuần tự các hàm phân loại yếu trên các phiên bản dữ liệu được liên tục cập nhật dựa trên kết quả của các hàm phân loại trước đó. Hàm phân loại cuối cùng thu được bằng cách kết hợp có trọng số tất cả các hàm phân loại:
\begin{align}
f(x) =  sign\left( \sum\limits_{m=1}^M \alpha_m \cdot b_m^C(x)  \right) 
\end{align}
trong đó các hệ số $\alpha_1, \alpha_2, \cdots, \alpha_M$ được tính toán dựa trên khả năng phân loại của các hàm $b^C_1, b^C_2, \cdots,  b^C_M$.

Quá trình cập nhật và thay đổi dữ liệu ở mỗi bước của boosting được thực hiện thông qua thay đổi véc-tơ trọng số $w^{(m)}_1, w^{(m)}_2, \cdots ,w^{(m)}_n$ cho từng quan sát trong dữ liệu xây dựng mô hình $(\textbf{x}_i,y_i)$, với $i = 1, 2, \cdots ,n$, và $m = 1, 2, \cdots, M$.

Ban đầu tất cả các trọng số được cho bằng nhau tại bước thứ nhất $w^{(1)}_i = \cfrac{1}{n}$ với mọi $i$. Trong bước đầu tiên, hàm phân loại được xây dựng trên dữ liệu ban đầu theo cách thông thường. Đối với những lần xây dựng hàm phân loại tiếp theo $m = 2, 3, \cdots ,M$, trọng số $w^{(m)}_i$ của quan sát thứ $i$ thay đổi và hàm phân loại được áp dụng lại cho dữ liệu với trọng số vừa cập nhật. Tại bước thứ $m$, nếu quan sát thứ $i$ bị phân loại sai bởi hàm phân loại ở bước ngay liền trước đó, $b^C_{m-1}(x_i)$, trọng số $w^{(m)}_i$ sẽ được tăng lên. Ngược lại, nếu quan sát thứ $i$ được phân loại đúng ở bước $(m-1)$, trọng số $w^m_i$ sẽ được giảm đi. Khi quá trình kể trên diễn ra lặp đi lặp lại, những quan sát khó phân loại chính xác sẽ nhận càng có tỷ trọng cao trong những bước phân loại tiếp theo. Những hàm phân loại xây dựng cho những bước sau sẽ tập trung vào phân loại những quan sát mà những hàm phân loại ở các bước trước đã bỏ sót.

Thuật toán AdaBoost.M1 được mô tả trong nghiên cứu của Freund và Schapire (1997) được phát biểu như sau:

- 1. Cho $w^{(1)}_i = \cfrac{1}{n}$ với mọi $i = 1, 2, \cdots, n$ với $n$ là số dòng của dữ liệu ban đầu.

- 2. Tại bước thứ $m$, với $m = 1, 2, \cdots, M$,

  - 2.(a) Xây dựng hàm phân loại $b^C_m$ trên dữ liệu ban đầu với véc-tơ trọng số tương ứng với dòng $i$ là $w^{(m)}_i$.

  - 2.(b) Tính toán sai số của hàm phân loại $b^C_m$
  
  \begin{align}
  err_m = \sum\limits_{m=1}^M  w^{(m)}_i \cdot \mathbb{I} \left(b_m^C(\textbf{x}_i) \neq y_i \right)
  \end{align}
  
  - 2.(c) Tính hệ số của hàm phân loại thứ $m$ dựa trên sai số
  
  \begin{align}
  \alpha_m = \log\left( \cfrac{1 - err_m}{err_m} \right)
  \end{align}
 
  - 2.(d). Cập nhật trọng số cho bước tiếp theo
  
  \begin{align}
  w^{(m+1)}_i = w^{(m)}_i \cdot \exp\left[ \alpha_m \cdot \mathbb{I} \left(b_m^C(\textbf{x}_i) \neq y_i \right) \right]
  \end{align}

  - 2.(e). Chuẩn hóa lại trọng số để tổng các trọng số bằng 1.

  \begin{align}
  w^{(m+1)}_i = \cfrac{w^{(m+1)}_i}{\sum\limits_{i=1}^n  w^{(m+1)}_i} 
  \end{align}
  
- 3. Kết thúc lần lặp thứ $M$, trả lại kết quả hàm phân loại cuối cùng:
\begin{align}
f^C(x) =  sign\left( \sum\limits_{m=1}^M \alpha_m \cdot b_m^C(x)  \right) 
\end{align}

Chúng tôi khuyên bạn đọc hãy hiểu ý tưởng của các bước kể trên thay vì cố gắng hiểu chính xác các công thức toán học. Các bước của thuật toán AdaBoost.M1 được trình bày ở trên khá rõ ràng, ngoại trừ bước 2.(a) là "Xây dựng hàm phân loại $b^C_m$ trên dữ liệu ban đầu với véc-tơ trọng số tương ứng với dòng $i$ là $w^{(m)}_i$". Quá trình xây dựng một hàm phân loại luôn luôn bao gồm hai bước: bước thứ nhất là lựa chọn kiểu mô hình và bước thứ hai là ước lượng tham số của mô hình với mục tiêu tối thiểu hóa một hàm tổn thất. Thuật toán AdaBoost.M1 ở trên có thể được áp dụng với mọi hàm phân loại (cây quyết định, hồi quy logistic, ...) nhưng hàm tổn thất được lựa chọn phải là hàm tổn thất kiểu mũ. Trong các phần tiếp theo của cuốn sách bạn đọc sẽ được giải thích rằng công thức tính toán các trọng số $w^{(m)}_i$ ở bước 2.(d) là kết quả của việc lựa chọn hàm tổn thất, trong khi hàm phân loại có thể là bất cứ dạng hàm nào.

Thuật toán AdaBoost.M1 được Friedman (2000) gọi là thuật toán AdaBoost phân loại vì các hàm $b^C_m$ được xây dựng ở bước thứ $m$ luôn là các dạng hàm phân loại. Nghiên cứu của Friedman (2000) điều chỉnh AdaBoost.M1 để phù hợp hơn cho cả bài toán phân loại và bài toán hồi quy. Hàm phân loại trong nghiên cứu của Friedman luôn luôn có dạng là một cây quyết định có 1 node duy nhất, còn được gọi là một "stump". Một stump chỉ là một hàm phân loại yếu, nhưng bằng cách kết hợp các stump như ý tưởng của AdaBoost.M1, khả năng dự đoán của hàm phân loại cuối cùng là đáng kinh ngạc. Thuật toán được giới thiệu trong nghiên cứu của Friedman (2000) chính là thuật toán AdaBoost được áp dụng rộng rãi hiện nay. 


<!-- - Phần thứ nhất: Chúng tôi chứng minh rằng AdaBoost phù hợp với mô hình cộng tính trong trình học cơ sở, tối ưu hóa hàm mất mũ mới. Hàm mất này rất giống với khả năng ghi nhật ký nhị thức (âm) (Phần 10.2– 10.4). • Bộ giảm thiểu dân số của hàm mất mũ được biểu diễn bằng log-odds của các xác suất của lớp (Phần 10.5). • Chúng tôi mô tả các hàm mất mát cho hồi quy và phân loại mạnh hơn sai số bình phương hoặc mất mát theo cấp số nhân (Phần 10.6). • Người ta lập luận rằng cây quyết định là một trình học cơ sở lý tưởng cho các ứng dụng khai thác dữ liệu tăng cường (Phần 10.7 và 10.9). • Chúng tôi phát triển một lớp mô hình tăng cường độ dốc (GBM), để tăng cường cây có bất kỳ chức năng mất nào (Phần 10.10). • Tầm quan trọng của “học chậm” được nhấn mạnh và được thực hiện bằng cách thu gọn từng thuật ngữ mới đưa vào mô hình (Phần 10.12), cũng như ngẫu nhiên hóa (Phần 10.12.2). • Mô tả các công cụ giải thích mô hình phù hợp (Phần 10.13) -->

## Những cơ sở của kỹ thuật boosting.
### Nguyên tắc chung của boosting
Xây dựng mô hình dựa trên kỹ thuật boosting về cơ bản là kết hợp tuyến tính một tập hợp các hàm cơ bản nhằm cải thiện khả năng giải thích hoặc dự đoán. Một cách tổng quát, hàm $f$ thu được từ kỹ thuật boosting có thể viết dưới dạng tổng của $M$ hàm phân loại hoặc hồi quy như sau:
\begin{align}
f(\textbf{x}) = \sum\limits_{m=1}^M \ \lambda_m \cdot b(\textbf{x},\Theta_m)
(\#eq:boosting1)
\end{align}
trong đó $\lambda_m$ là hệ số tuyến tính, $b(\textbf{x},\Theta_m)$ là một hàm phân loại hoặc hồi quy cơ bản có tham số là $\Theta_m$. Dạng tham số của hàm $b$ thường được xác định trước khi xây dựng hàm $f$ trong khi các tham số $\lambda_m$ và $\Theta_m$ được ước lượng tại mỗi bước nhằm tối thiểu hóa hàm tổn thất. Quá trình ước lượng tham số của mô hình \@ref(eq:boosting1) được thực hiện thông qua các bước như sau:

- Bước 1: Lựa chọn hàm tổn thất $\sum\limits_{i=1}^n L(y_i, \hat{y}_i)$, dạng hàm cơ bản $b(\textbf{x},\Theta)$, và cho $f_0(\textbf{x}) = 0$.

- Bước 2: với mỗi $m = 1, 2, \cdots, M$, tìm tham số ($\lambda_m$,$\Theta_m$) như sau
\begin{align}
(\lambda_m,\Theta_m) = \underset{\lambda,\Theta}{\operatorname{argmax}} \sum\limits_{i=1}^n L\left( y_i, f_{m-1}(x_i) + \lambda \cdot b(\textbf{x}_i,\Theta) \right)
(\#eq:boosting10)
\end{align}

- Bước 3: cho $f_m(\textbf{x}) = f_{m-1}(\textbf{x}) + \lambda_m \cdot b(\textbf{x}_i,\Theta_m)$.

Tại mỗi bước $m = 1, 2, \cdots, M$, chúng ta cần phải tìm các tham số ($\lambda_m$,$\theta_m$) để tối thiểu hóa một hàm tổn thất. Khi giải bài toán tối ưu, lời giải chính xác luôn được ưu tiên trước, nếu không thể giải bằng lời giải chính xác mới cần sử dụng phương pháp số. Việc tồn tại hay không tồn tại lời giải chính xác cho mỗi bước $m$ phụ thuộc vào lựa chọn hàm tổn thất $L$ và hàm cơ bản $b$. Hàm cơ bản $b$ thường được lựa chọn ở mức độ đơn giản nhất, chẳng hạn như 1 cây quyết định với 1 node. Hàm tổn thất có thể là hàm tổn thất kiểu mũ, hàm tổn thất kiểu trung bình sai số, hàm hợp lý,...

- Ví dụ 1: trong bài toán hồi quy, khi hàm tổn thất là hàm tổng sai số bình phương,
\begin{align}
L(y_i, \hat{y}_i) = \cfrac{1}{2} \sum\limits_{i=1}^n (y_i - \hat{y}_i)^2
\end{align}
tham số $(\lambda_m,\theta_m)$ là lời giải của bài toán tối ưu sau
\begin{align}
(\lambda_m,\theta_m) & = \underset{\lambda,\theta}{\operatorname{argmin}} \cfrac{1}{2} \sum\limits_{i=1}^n \left(y_i - f_{m-1}(x_i) - \lambda \cdot b(\textbf{x}_i,\theta) \right)^2 \\
& = \underset{\lambda,\theta}{\operatorname{argmin}} \cfrac{1}{2} \sum\limits_{i=1}^n \left(\epsilon_{i,m-1}  - \lambda \cdot b(\textbf{x}_i,\theta) \right)^2
\end{align}
trong đó $\epsilon_{i,m-1}$ là sai số của thuật toán Boosting sau bước thứ $(m-1)$. Bạn đọc có thể thấy rằng nếu chúng ta chọn hàm tổn thất là tổng sai số bình phương, tại bước thứ $m$ của quá trình boosting, chúng ta sẽ cần tìm các hệ số $(\lambda_m,\theta_m)$ sao cho tổng sai số giữa $\lambda_m \cdot b(\textbf{x}_i,\theta_m)$ và sai số tại bước thứ $(m-1)$, $\epsilon_{i,m-1}$ là nhỏ nhất.

- Ví dụ 2: trong bài toán phân loại mà biến mục tiêu $y$ chỉ nhận hai giá trị là -1 hoặc 1, Freund và Schapire (1997) lựa chọn hàm tổn thất kiểu mũ
\begin{align}
L(y_i, \hat{y}_i) = \sum\limits_{i=1}^n exp(- y_i \cdot \hat{y_i})
\end{align}
tham số $(\lambda_m,\theta_m)$ là lời giải của bài toán tối ưu sau
\begin{align}
(\lambda_m,\theta_m) & = \underset{\lambda,\theta}{\operatorname{argmin}} \sum\limits_{i=1}^n \exp\left[- y_i  \cdot \left(f_{m-1}(x_i) + \lambda \cdot b(\textbf{x}_i,\theta) \right) \right] \\
& = \underset{\lambda,\theta}{\operatorname{argmin}} \sum\limits_{i=1}^n \exp\left[ - y_i  \cdot f_{m-1}(x_i)\right]  \cdot \exp\left[- y_i \cdot \lambda \cdot b(\textbf{x}_i,\theta)  \right] \\
& = \underset{\lambda,\theta}{\operatorname{argmin}} \sum\limits_{i=1}^n w_i^{(m)}  \cdot \exp\left[- \lambda \cdot y_i \cdot b(\textbf{x}_i,\theta)  \right]
\end{align}
với $w_i^{(m)} = \exp\left[ - y_i  \cdot f_{m-1}(x_i)\right]$. Bạn đọc có thể thấy rằng $w_i^{(m)}$ không phụ thuộc vào $\lambda$ hay $\theta$ nên có thể coi như trọng số tương ứng với dữ liệu thứ $i$. 

Từ kết quả của ví dụ 2, chúng ta đã có thể giải thích các bước trong thuật toán AdaBoost.M1. Với mọi $\lambda > 0$ và với một lựa chọn của hàm $b$, tham số $\theta_m$ là giá trị tối thiểu hóa hàm tổn thất
\begin{align}
(\theta_m) & = \underset{\theta}{\operatorname{argmin}} \sum\limits_{i=1}^n w_i^{(m)}  \cdot \exp\left[- \lambda \cdot y_i \cdot b(\textbf{x}_i,\theta)  \right] \\
(\#eq:boosting2)
\end{align}
Biến đổi công thức phía bên phải của phương trình \@ref(eq:boosting2) chúng ta có
\begin{align}
\sum\limits_{i=1}^n w_i^{(m)}  \cdot \exp\left[- \lambda \cdot y_i \cdot b(\textbf{x}_i,\theta)  \right] & = \sum\limits_{i=1}^n w_i^{(m)}  \cdot \left[ e^{-\lambda} \cdot \mathbb{I}(y_i = b(\textbf{x}_i,\theta)) + e^{\lambda} \cdot \mathbb{I}(y_i \neq b(\textbf{x}_i,\theta))  \right]\\
& = \sum\limits_{i=1}^n w_i^{(m)}  \cdot e^{-\lambda} +  \sum\limits_{i=1}^n w_i^{(m)}  \cdot \left[ e^{\lambda} - e^{-\lambda} \right] \cdot \mathbb{I}(y_i \neq b(\textbf{x}_i,\theta)) \\
& = e^{-\lambda} \cdot \sum\limits_{i=1}^n w_i^{(m)}  + \left[ e^{\lambda} - e^{-\lambda} \right] \cdot  \sum\limits_{i=1}^n w_i^{(m)}  \cdot  \mathbb{I}(y_i \neq b(\textbf{x}_i,\theta))
(\#eq:boosting3)
\end{align}

Do $e^{\lambda} - e^{-\lambda} > 0$ và các $w_i^{(m)}$ không phụ thuộc vào $\theta$ nên ta có giá trị $\theta_m$ tối thiểu hóa hàm tổn thất trong phương trình \@ref(eq:boosting2) cũng là giá trị $\theta_m$ tối thiểu hóa sai số dự đoán
\begin{align}
(\theta_m) & = \underset{\theta}{\operatorname{argmin}} \sum\limits_{i=1}^n w_i^{(m)}  \cdot  \mathbb{I}(y_i \neq b(\textbf{x}_i,\theta))
(\#eq:boosting4)
\end{align}

Với mỗi $\theta_m$ là lời giải của \@ref(eq:boosting4), chúng ta có giá trị $\lambda_m$ để tối thiểu hóa giá trị hàm tổn thất trong phương trình \@ref(eq:boosting2) là lời giải của phương trình 
\begin{align}
\sum\limits_{i=1}^n w_i^{(m)}  \cdot \cfrac{\partial \exp\left[- \lambda \cdot y_i \cdot b(\textbf{x}_i,\theta_m)  \right]}{\partial \lambda} = 0 \\
\end{align}

Lấy đạo hàm của vế phải của phương trình \@ref(eq:boosting4) theo $\lambda$ chúng ta có:
\begin{align}
& - e^{-\lambda_m} \cdot \sum\limits_{i=1}^n w_i^{(m)}  + \left[ e^{\lambda_m} + e^{-\lambda_m} \right] \cdot  \sum\limits_{i=1}^n w_i^{(m)}  \cdot  \mathbb{I}(y_i \neq b(\textbf{x}_i,\theta_m)) = 0 \\
& \rightarrow \lambda_m = \cfrac{1}{2} \cdot \log\left(\cfrac{1}{err_m} - 1 \right)
\end{align}
với $err_m$ là sai số của hàm phân loại $b(\textbf{x}_i,\theta_m)$
\begin{align}
err_m = \cfrac{\sum\limits_{i=1}^n w_i^{(m)}  \cdot  \mathbb{I}(y_i \neq b(\textbf{x}_i,\theta_m))}{\sum\limits_{i=1}^n w_i^{(m)}}
\end{align}

Chúng ta cập nhật trọng số cho bước tiếp theo như sau
\begin{align}
w_i^{(m+1)}& = \exp\left[- y_i \cdot f_m(x_i)\right] \\
& = exp\left[- y_i \cdot f_{m-1}(x_i) - y_i \lambda_m b(x_i,\theta_m) \right] \\
& = w_i^{(m)} \cdot \exp\left[ \lambda_m \cdot(2 \mathbb{I}(b(x_i,\theta_m) \neq y_i) - 1)  \right] \\
& = w_i^{(m)} \cdot \exp\left[ (2\lambda_m) \cdot \mathbb{I}(b(x_i,\theta_m) \neq y_i)  \right] \cdot \exp(-\lambda_m)
\end{align}
Công thức ở trên tương đương với bước 2.(d) trong thuật toán AdaBoost.M1 với $(2\lambda_m) = \alpha_m$. Giá trị $\exp(-\lambda_m)$ không ảnh hưởng đến trọng số vì không phụ thuộc vào $i$.


- Ví dụ 1: chúng ta sẽ áp dụng thuật toán AdaBoost.M1 trên một dữ liệu có 10 quan sát như dưới đây. Dữ liệu có biến mục tiêu $Y$ nhận giá trị 1 khi khách hàng đồng ý mua sản phẩm và nhận giá trị -1 khi khách hành không đồng ý. Có bốn biến giải thích là độ tuổi ($Age$), số năm kinh nghiệm lái xe ($seniority$), giới tính ($sex$) và thành thị ($urban$). Hàm phân loại chúng ta lựa chọn là cây quyết định có 1 node duy nhất.


``` r
df<-read.csv("../KHDL_KTKD Final/Dataset/AdaBoostM1Example1.csv")
knitr::kable(df, booktabs = T,
      col.names = c("Tuổi", "Kinh nghiệm", "Giới tính", "Thành thị", "Lựa chọn"),
      escape=F, align = 'r') %>%
  #column_spec(c(1,4,5,6,7),border_left = T) %>% column_spec(7,border_right = T) %>% 
  kable_styling(latex_options = "scale_down",full_width = F)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Tuổi </th>
   <th style="text-align:right;"> Kinh nghiệm </th>
   <th style="text-align:right;"> Giới tính </th>
   <th style="text-align:right;"> Thành thị </th>
   <th style="text-align:right;"> Lựa chọn </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 58 </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 65 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 64 </td>
   <td style="text-align:right;"> 24 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> -1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> -1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 63 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -1 </td>
  </tr>
</tbody>
</table>
Tại bước $m=1$ chúng ta có tỷ trọng của mỗi hàng dữ liệu là $w^{(1)}_i = 0.1$; để xây dựng mô hình cây quyết định với 1 node và tôi thiểu hóa sai số trên dữ liệu, chúng ta thử trên từng cột dữ liệu

- Cột $age$, bạn đọc có thể kiểm tra rằng tại điểm cắt 55.5 (tuổi), cây quyết định cho sai số có trọng số $w^{(1)}_i$ nhỏ nhất là 0.3. Lưu ý rằng điểm cắt 48 tuổi cũng có sai số là 0.3 tuy nhiên điểm cắt này chia dữ liệu thành một phần chỉ có 2 quan sát và một phần có 8 quan sát nên ít tối ưu hơn so với điểm cắt 55.5.

- Cột $seniority$, điểm cắt tối ưu là 24.5 (năm) và cũng cho sai số có trọng số là 0.3

- Cột $sex$ chỉ có một lựa chọn là chia dữ liệu thành hai phần, Male và Female, cho sai số có trọng số là 0.3

- Cột $urban$ chỉ có một lựa chọn là chia dữ liệu thành 0 và 1, cũng cho sai số có trọng số là 0.4

Chúng ta chọn cây quyết định dựa trên biến $age$ với điểm cắt là 55.5 tuổi là hàm phân loại tại $m = 1$. Cây quyết định cho giá trị là 1 khi biến $age$ nhỏ hơn 55.5 và cho giá trị là -1 khi biến $age$ cho giá trị lớn hơn 1. Hệ số của hàm phân loại thứ nhất trong hàm phân loại tổng là
\begin{align}
\alpha_1 = log(\cfrac{1 - err_1}{err_1}) = log(\cfrac{1-0.3}{0.3}) = 0.8473
\end{align}

Trọng số cho bước thứ 2 được cập nhật, theo công thức 2.(d) như sau
\begin{align}
w^{(2)}_i = w^{(1)}_i \cdot \exp\left[ 0.8473 \cdot \mathbb{I} \left(f_m^C(\textbf{x}_i) \neq y_i \right) \right] = 
  \begin{cases}
  0.1 \cdot e^0 \textit{ nếu }  f_m^C(\textbf{x}_i) = y_i \\
  0.1 \cdot e^{0.8473} \textit{ nếu }  f_m^C(\textbf{x}_i) \neq y_i
  \end{cases}
\end{align}

Bạn đọc có thể thấy rằng trọng số cho 3 hàng bị dự đoán sai đã được tăng lên thành $0.1 \times e^{0.8473}$ trong khi trọng số cho 7 hàng được dự đoán đúng vẫn là 0.1. Chuẩn hóa lại trọng số để có tổng bằng 1 chúng ta có bảng sau

``` r
df<-mutate(df, w1 = 0.1, pred1 = ifelse(age<48,1,-1))
df<-mutate(df, w2 = ifelse(Y == pred1, 0.1,exp(0.8573)))
df<-mutate(df, w2 = round(w2/sum(w2),3))
knitr::kable(df, booktabs = T,
      col.names = c("Tuổi", "Kinh nghiệm", "Giới tính", "Thành thị", "Y", "$w^{(1)}$", "$b(x_i,\\theta_1)$", "$w^{(2)}$" ),
      escape=F, align = 'r') %>%
  kable_styling(latex_options = "scale_down",full_width = F)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Tuổi </th>
   <th style="text-align:right;"> Kinh nghiệm </th>
   <th style="text-align:right;"> Giới tính </th>
   <th style="text-align:right;"> Thành thị </th>
   <th style="text-align:right;"> Y </th>
   <th style="text-align:right;"> $w^{(1)}$ </th>
   <th style="text-align:right;"> $b(x_i,\theta_1)$ </th>
   <th style="text-align:right;"> $w^{(2)}$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 58 </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.013 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.013 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 65 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.303 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.303 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.303 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 64 </td>
   <td style="text-align:right;"> 24 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.013 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.013 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 63 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> F </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.013 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.013 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> M </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:right;"> 0.013 </td>
  </tr>
</tbody>
</table>

Tại bước $m=2$, chúng ta cần tìm cây quyết định để tối thiểu hóa sai số có trọng số $w^{(2)}$ như bảng ở trên.

- Cột $age$, bạn đọc có thể kiểm tra rằng tại điểm cắt 64.5 (tuổi), cây quyết định cho sai số có trọng số $w^{(2)}_i$ nhỏ nhất là 0.342

- Cột $seniority$, điểm cắt tối ưu là 24.5 (năm) cho sai số có trọng số là 0.329

- Cột $sex$ chỉ có một lựa chọn là chia dữ liệu thành hai phần, Male và Female, cho sai số có trọng số là 0.329

- Cột $urban$ chỉ có một lựa chọn là chia dữ liệu thành 0 và 1, cũng cho sai số có trọng số là 0.342

Như vậy, cây quyết định tại bước thứ hai có thể dựa trên biến $seniority$ hoặc $sex$. Chúng ta sẽ lựa chọn biến $seniority$ với điểm cắt là 24.5 (năm). Cây quyết định trả lại giá trị là $1$ khi $seniority > 24.5$ và trả lại giá trị $-1$ khi $seniority < 24.5$. Hệ số của hàm phân loại thứ hai trong hàm phân loại tổng là
\begin{align}
\alpha_2 = log(\cfrac{1-0.342}{0.342}) = 0.654
\end{align}

Với $M = 2$ chúng ta có hàm phân loại từ thuật toán AdaBoost.M1 được xây dựng như sau
\begin{align}
f^C = sign(0.8473 \cdot f^C_1 + 3.204 \cdot f^C_2) = \begin{cases}
1 \textit{ nếu } age < 55.5 \textit{ và } seniority < 24.5 \\
-1 \textit{ nếu } age > 55.5 \textit{ và } seniority > 24.5 \\
1 \textit{ nếu } age < 55.5 \textit{ và } seniority < 24.5 \\
-1 \textit{ nếu } age > 55.5 \textit{ và } seniority > 24.5 
\end{cases}
\end{align}

### Hàm cơ bản dạng cây quyết định
Cây quyết định thảo luận trong phần trước là kỹ thuật chia không gian tất cả các biến giải thích thành $K$ phần không giao nhau, $R_1, R_2, \cdots, R_K$, mỗi phần được mô tả bởi một lá của cây quyết định. Một hằng số $\gamma_k$ được gán cho giá trị của mỗi vùng $R_k$ và nguyên tắc dự báo đơn giản là:
\begin{align}
x \in R_k \rightarrow f(x) = \gamma_k
\end{align}
Nói cách khác, cây quyết định có thể được viết dưới dạng như sau
\begin{align}
T(x; \Theta) =  \sum\limits_{k=1}^K \gamma_k \cdot \mathbb{I}(x \in R_k)
\end{align}
Tham số của cây quyết định bao gồm có 1. cách phân vùng không gian các biến độc lập $R_1, R_2, \cdots, R_K$; và 2. các hằng số $\gamma_k$, $k = 1, 2, \cdots K$.

Ước lượng tham số của cây quyết định bao gồm việc xác định phân vùng $\{R_k\}$ và xác định các tham số $\gamma_k$. Thông thường thì ước lượng tham số sẽ bao gồm hai bước 

- Thứ nhất: với mỗi phân vùng $\{R_k\}$ cho trước, xác định $\gamma_k$ để tối thiểu hóa hàm tổn thất trên miền $R_k$ tương ứng
\begin{align}
\gamma_k = \underset{\gamma}{\operatorname{argmin}} \sum\limits_{x_i \in R_k} L(y_i, \gamma)
\end{align}
Tùy vào hàm $L$ mà giá trị của $\gamma_k$ sẽ có quy tắc xác định khác nhau: với hàm $L$ là tổng bình phương sai số, $\gamma_k$ là giá trị trung bình của $y_i$ trên phân vùng $R_k$; với hàm $L$ là tổng giá trị tuyệt đối sai số, $\gamma_k$ là giá trị trung vị của $y_i$ trên phân vùng $R_k$; với $L$ là sai số phân loại, $\gamma_k$ là giá trị mode của $y_i$,...

- Thứ hai: là việc xác định phân vùng $\{R_k\}$. Đây là một vấn đề không đơn giản và không có lời giải chính xác. Hướng tiếp cận thường là giống như cách xác định cây quyết định như trong phần trước. Chúng ta thử phân vùng trên từng biến giải thích riêng lẻ và lựa chọn phân vùng tốt nhất dựa trên sai số phân loại, hệ số gini, hoặc hệ số entropy và tiếp tục quá trình đó cho đến khi một số chỉ tiêu đạt được. 

Chúng ta ký hiệu các hàm cơ bản là $T$ (viết tắt của Tree) thay vì $b$ như trong phần trước. Sau $M$ bước boosting, chúng ta có hàm phân loại (hoặc hồi quy) có dạng 
\begin{align}
f(\textbf{x}) = \sum\limits_{m=1}^M \lambda_m \cdot T(\textbf{x},\Theta_m)
\end{align}

Do hàm $T(.)$ nhận giá trị là hằng số trên mỗi phân vùng nên việc thêm tham số $\lambda_m$ là không cần thiết. Do đó các tham số cần ước lượng chỉ bao gồm tham số $\Theta_m$. Tại mỗi bước $m$, chúng ta cần tìm tham số $\Theta_m$ của cây quyết định $T(\textbf{x},.)$ sao cho
\begin{align}
(\Theta_m) = \underset{\Theta_m}{\operatorname{argmin}} \sum\limits_{i = 1}^n L\left(y_i, f_{m-1}(\textbf{x}_i) + T(\textbf{x}_i, \Theta) \right)
(\#eq:boosttree1)
\end{align}
Nhắc lại rằng tham số $\Theta_m$ bao gồm có phân vùng $\{R^{(m)}_k\}$ tại bước thứ $m$ và hằng số $\gamma^{(m)}_k$ của vùng $R^{(m)}_k$. Tương tự như bài toán ước lượng tham số của cây quyết định thông thường, tại bước thứ $m$ trong kỹ thuật boosting, nếu cho trước vùng $R^{(m)}_k$, $\gamma^{(m)}_k$ sẽ được xác định như sau
\begin{align}
(\gamma^{m}_k) = \underset{\gamma}{\operatorname{argmin}} \sum\limits_{\textbf{x}_i \in R^{(m)}_k} L\left(y_i, f_{m-1}(\textbf{x}_i) + \gamma \right)
\end{align}

Việc xác định phân vùng $\{R^{(m)}_k\}$ là không đơn giản, thậm chí còn khó khăn hơn so với việc tìm phân vùng cho một cây quyết định riêng lẻ. Trong một vài trường hợp, tìm kiếm phân vùng tối ưu sẽ có lời giải:

- Ví dụ 1: trong bài toán hồi quy và hàm tổn thất là hàm tổng bình phương sai số, tìm cây quyết định $T(\textbf{x}_i, \Theta_m)$ tương đương với bài toán tìm cây quyết định với ma trận biến giải thích $\textbf{x}$ và biến mục tiêu là $y - f_{m-1}(\textbf{x})$. Với mỗi phân vùng $\{R^{(m)}_k\}$, giá trị $\gamma^{(m)}_k$ là giá trị trung bình của $y - f_{m-1}(\textbf{x})$ trên miền $R^{(m)}_k$.

- Ví dụ 2: trong bài toán phân loại nhị phân và hàm tổn thất kiểu mũ, ước lượng tham số cho cây quyết định trong phương trình \@ref(eq:boosttree1) được viết lại như sau
\begin{align}
(\Theta_m) = \underset{\Theta_m}{\operatorname{argmin}} \sum\limits_{i = 1}^n w^{(m)}_i \exp\left[- y_i T(\textbf{x}_i, \Theta) \right]
(\#eq:boosttree2)
\end{align}
với $w^{(m)}_i = \exp(-y_i f_{m-1}(\textbf{x}_i))$. Để giải bài toán tối ưu ở trên, phương pháp tiếp cận sẽ là thử qua các phân vùng có thể tìm kiếm được phân vùng tốt nhất (tìm kiếm tham lam). Trên mỗi vùng $R^{(m)}_k$, giá trị $\gamma^{(m)}_k$ tối thiểu hóa giá trị hàm tổn thất trên vùng đó là
\begin{align}
\gamma^{(m)}_k = \log \left(\cfrac{\sum\limits_{x_i \in R^{(m)}_k} w^{(m)}_i \mathbb{I}(y_i = 1)}{\sum\limits_{x_i \in R^{(m)}_k} w^{(m)}_i \mathbb{I}(y_i = -1)} \right)
\end{align}

### Hàm tổn thất
Thuật toán AdaBoost.M1 mặc dù được giải thích dựa trên hàm tổn thất kiểu mũ, nhưng phương pháp tiếp cận ban đầu của thuật toán này lại không bắt đầu từ hàm tổn thất. Sau khi thuật toán được công bố thì mối liên hệ của thuật toán này và hàm phân loại kiểu mũ mới được tìm ra. Hàm tổn thất kiểu mũ trong ngữ cảnh của boosting có ưu điểm là cho phép tính toán nhanh và cho công thức chính xác của tỷ trọng trong các bước của quá trình boosting. Trong phần này của chương sách, chúng ta sẽ thảo luận kỹ hơn về hàm tổn thất kiểu mũ nói riêng các hàm tổn thất khác nói chung được sử dụng thường xuyên trong các bài toán hồi quy và phân loại.

Với biến mục tiêu chỉ nhận hai giá trị là -1 và 1, có thể chứng minh được rằng giá trị $\hat{y}^*$ để tối thiểu giá trị trung bình của $\exp(-Y \hat{y} )$ được xác định như sau
\begin{align}
\hat{y}^* = \underset{\hat{y}}{\operatorname{argmin}} \mathbb{E}\left( \exp(-Y \hat{y}) \right) = \cfrac{1}{2} \cdot \log \left( \cfrac{\mathbb{P}(Y = 1)}{\mathbb{P}(Y = -1)}\right)
\end{align}
Giá trị tối ưu này giải thích tại sao trong bước (3). của AdaBoost.M1 lại lấy dấu của hàm $f^C(x_i) = \left( \sum\limits_{m=1}^M \alpha_m \cdot f_m^C(x_i)  \right)$ để dự đoán giá trị của $y_i$. Quy tắc đơn giản là nếu $f^C(x_i) > 0$, do $f^C(x_i)$ được xây dựng để xấp xỉ đến $\hat{y_i}^*$ nên ta có $\log \left( \cfrac{\mathbb{P}(Y = 1)}{\mathbb{P}(Y = -1)}\right) > 0$ hay $\mathbb{P}(Y_i = 1) > \mathbb{P}(Y_i = -1)$ do đó $Y_i$ có khả năng nhận giá trị bằng 1 cao hơn so với khả năng nhận giá trị là -1.

Hàm tổn thất kiểu mũ khác cũng cho giá trị tối ưu tương đương như hàm tổn thất kiểu mũ trong bài toán phân loại nhị phân là hàm cross-entropy. Hàm tổn thất cross-entropy hay còn gọi là $deviance$ được sử dụng trong trường hợp biến $Y^{'}$ có phân phối nhị thức với tham số $p$ (chưa biết)  
\begin{align}
l(Y^{'},\hat{p}) = - \left(Y^{'} log(\hat{p}) + (1 - Y^{'}) log(1 - \hat{p})\right)
(\#eq:entropyloss)
\end{align}
với $\hat{p} \in (0,1)$. Giá trị $\hat{p}$ để tối thiểu giá trị trung bình của hàm tổn thất là $\hat{p}^* = \mathbb{P}(Y^{'} = 1)$.

Với $\hat{p} \in (0,1)$, cho 
\begin{align}
\hat{y} = \cfrac{1}{2} \log\left( \cfrac{\hat{p}}{1-\hat{p}} \right)
\end{align}
và $Y = 2 \times Y^{'} - 1$, chúng ta sẽ thấy rằng bài toán tìm $\hat{p}$ để tối thiểu giá trị trung bình của hàm tổn thất trong \@ref(eq:entropyloss) tương đương với việc tìm $\hat{y}$ để tối thiểu hóa hàm tổn thất kiểu mũ. 

Hàm tổn thất cross-entropy thường xuyên được sử dụng trong bài toán phân loại mà $Y$ có thể nhận $J$ giá trị. Giả sử các giá trị $Y$ có thể nhận được mã hóa thành $J$ số tự nhiên là $1, 2, \cdots, J$. Trong trường hợp này, hàm $f^C$ là một véc-tơ có độ dài $J$ mỗi phần tử trong véc-tơ là một hàm số thực. Giá sử $f^C_j$ là phần tử thứ $j$ của hàm $f^C$, hàm tổn thất kiểu cross-entropy trong bài toán phân loại được viết như sau
\begin{align}
L(Y, \hat{p}) & = - \sum\limits_{j = 1}^J \mathbb{I}(Y = j) \log(\hat{p}_j) \\
& = - \sum\limits_{j = 1}^J \mathbb{I}(Y = j) \cdot f^C_j + \log \left(\sum\limits_{j = 1}^J e^{f^C_j} \right) \text{ với } \hat{p}_j & = \cfrac{e^{f^C_l}}{\sum\limits_{l = 1}^J e^{f^C_l}}
\end{align}

Quá trình ước lượng hàm $f^C$ trong kỹ thuật boosting bao gồm ước lượng các hàm $f^C_l$ mà mỗi hàm đại diện cho 1 biến phân loại. Thông thường chúng ta sẽ cố định một thành phần bằng 0 để số lượng hàm số cần ước lượng tại mỗi bước là $(J-1)$.

Những lý thuyết cơ bản về boosting mà chúng tôi trình bày từ đầu chương sách có thể gây khó hiểu cho bạn đọc không có nền tảng nâng cao về toán học. Tuy nhiên, các kiến thức này là cần thiết nếu bạn đọc muốn giải mã các thuật toán boosting cập nhật nhất hiện nay. Tại thời điểm chúng tôi viết cuốn sách này, các thuật toán như XGBoost hay LGBoost là các thuật toán học máy chiếm ưu thế hoàn toàn trong các cuộc thi về khoa học dữ liệu. Các thuật toán này dựa trên nền tảng lý thuyết mà chúng tôi đã trình bày ở trên kết hợp với một vài kỹ thuật tối ưu hóa bằng phương pháp số thay vì tối ưu hóa bằng lời giải chính xác như lý thuyết. Ý tưởng tối ưu hóa tại mỗi bước của kỹ thuật boosting dựa trên nguyên lý "gradient desent", hay còn gọi là gradient boosting là chìa khóa để thuật toán boosting có thể được áp dụng với bất kỳ kiểu hàm tổn thất thất nào, và do đó có thể được sử dụng trong cả bài toán hồi quy, bài toán phân loại nhị phân, hay bài toán phân loại nói chung.

## Gradient boosting
Trong kỹ thuật boosting, tại mỗi bước $m$ sẽ cần phải giải bài toán tối ưu. Bài toán tối ưu chỉ có lời giải với một số hàm tổn thất cụ thể như hàm tổn thất kiểu mũ trong bài toán phân loại nhị phân, hay hàm tổn thất kiểu tổng sai số bình phương trong bài toán hồi quy. Thêm vào đó, việc liên tục tìm kiếm giá trị tối ưu tại mỗi bước nhiều khả năng dẫn đến overfitting, nghĩa là hàm phân loại hay hồi quy tìm được sẽ cho sai số rất nhỏ trên tập dữ liệu huấn luyện mô hình, nhưng sai số trên tập kiểm thử sẽ lớn. 

Thay vì cố gắng giải bài toán tối ưu tại từng bước $m$, kỹ thuật boosting theo gradient của hàm tổn thất, hay còn gọi là gradient boosting là một phương pháp tiếp cận có thể áp dụng với mọi hàm tổn thất và hạn chế được hiện tượng overfitting. Chúng ta sẽ thảo luận về kỹ thuật này trong các phần tiếp theo: trước tiên, chúng tôi sẽ giới thiệu về gradient boosting nói chung cùng với các ví dụ trên dữ liệu cụ thể, sau đó chúng tôi sẽ giới thiệu một kỹ thuật gradient boosting có ưu điểm vượt trội nhất hiện nay là eXtreme Gradient Boosting hay viết tắt là XGBoost.

### Cơ sở toán học của gradient boosting.
Nguyên lý chung của boosting là tại bước thứ $m$, tìm một hàm cơ sở $b(\textbf{x},\Theta_m)$ sao cho hàm tổn thất $L(y, \hat{y})$ tính tại $\hat{y} = f_m(\textbf{x}) = f_{m_1}(\textbf{x}) + \lambda_m b(\textbf{x},\Theta_m)$ đạt giá trị nhỏ nhất. Tại bước thứ $(m-1)$ chúng ta có giá trị hàm tổn thất là $L(\textbf{y}, \hat{y})$ đã được xác định trước. Chúng ta coi $f_{m_1}$ là một véc-tơ có $n$ thành phần $f_{m-1}(\textbf{x}_i)$ tương ứng với mỗi dữ liệu quan sát được và bỏ qua ràng buộc $b(\textbf{x},\Theta_m)$ phải là một hàm có tham số $\Theta_m$ tính trên dữ liệu $\textbf{x}$. Khi đó cách tốt nhất để làm giảm giá trị của hàm tổn thất $L(y, f_{m-1}(\textbf{x}))$ khi thay đổi giá trị $f_{m-1}(\textbf{x}))$ là cho mỗi thành phần $f_{m-1}(\textbf{x}_i)$ thay đổi tỷ lệ nghịch với giá trị đạo hàm của hàm $L(y, f_{m-1}(\textbf{x}))$ tính tại $f_{m-1}(\textbf{x}_i)$. Gọi $g_{m-1,i}$ là đạo hàm của hàm $L(y_i, f_{m-1}(\textbf{x}))$ theo $f_{m-1}(\textbf{x}_i)$ 
\begin{align}
g_{m-1,i} = \cfrac{ \partial L(y_i, f_{m-1}(\textbf{x}))}{\partial f_{m-1}(\textbf{x}_i)}
\end{align}
thì cách tốt nhất để giảm giá trị hàm tổn thất $L(\textbf{y}, \hat{y})$ tính tại $\hat{y} = f_{m-1}(\textbf{x})$ là thay đổi $\hat{y}$ như sau
\begin{align}
\hat{y}_i = f_{m-1}(\textbf{x}_i) - \lambda_m \cdot g_{m-1,i}
\end{align}
với $\lambda_m$ là hằng số không phụ thuộc vào $i$ làm thiểu hóa giá trị hàm tổn thất
\begin{align}
\lambda_m = \underset{\lambda}{\operatorname{argmin}} \sum\limits_{i = 1}^n L\left(y_i,  f_{m-1}(\textbf{x}_i) - \lambda \cdot g_{m-1,i}\right)
(\#eq:GB1)
\end{align}

Như vậy, nếu có thể tìm được hàm $f_m(\textbf{x})$ mà mỗi thành phần của nó thỏa mãn $f_m(\textbf{x}_i) = f_{m-1}(\textbf{x}_i) - \lambda_m \cdot g_{m-1,i}$ chúng ta có thể chắc chắn rằng hàm tổn thất $L(\textbf{y}, \hat{y})$ sẽ nhỏ đi khi cho $\hat{y}$ thay đổi từ $f_{m-1}(\textbf{x})$ đến $f_{m}(\textbf{x})$. Đây là nguyên tắc cơ bản trong các thuật toán tìm điểm tối ưu của một hàm số nhiều biến bằng phương pháp số hay còn gọi là phương pháp gradient descent.

Hàm $f_m$ được xây dựng như trên bao gồm $n$ thành phần được xây dựng độc lập với nhau và hoàn toàn phụ thuộc vào dữ liệu huấn luyện mô hình. Mục tiêu của chúng ta là xây dựng hàm $f_m$ vận hành tốt trên dữ liệu ngoài mô hình chứ không phải trên dữ liệu huấn luyện, do đó sử dụng $n$ thành phần độc lập là không khả thi. Thay vì tìm một hàm số $f_m$ tối thiểu hóa giá trị hàm tổn thất tại bước thứ $m$ như phương trình \@ref(eq:boosting1), ý tưởng của gradient boosting là hãy tìm một hàm số cơ bản, hay cụ thể hơn là một cây quyết định $T(\textbf{x},\Theta_m)$ sao cho sai số giữa cây quyết định với các gradient ($-g_{m-1,i}$) của hàm tổn thất là nhỏ nhất
\begin{align}
\Theta_m = \underset{\Theta}{\operatorname{argmin}} \sum\limits_{i = 1}^n \left(-g_{m-1,i} -  T(\textbf{x}_i,\Theta_m) \right)^2
(\#eq:GB2)
\end{align}
Như vậy, miễn là hàm tổn thất là hàm số có đạo hàm theo $\hat{y}$, dù là bài toán hồi quy hay phân loại, tại bước thứ $m$ của kỹ thuật gradient boosting, chúng ta luôn luôn phải tìm một cây quyết định hồi quy. 

- Ví dụ 1: trong bài toán hồi quy với hàm tổn thất kiểu tổng sai số bình phương, gradient của hàm tổn thất tại $\hat{y}_i$ là
\begin{align}
& g_{i} = \cfrac{ \partial (y_i - \hat{y}_i)^2 }{\partial \hat{y}_i} = 2 \cdot (\hat{y}_i - y_i) \\
& \rightarrow - g_{,i} = 2 \cdot (y_i - \hat{y}_i) 
\end{align}
Lưu ý rằng hàm sai số dạng tổng bình phương sai số thường được nhân với 0.5 để gradient tại $\hat{y}_i$ là $(y_i - \hat{y}_i)$.

- Ví dụ 2: trong bài toán hồi quy với hàm tổn thất kiểu tổng giá trị tuyệt đối sai số, gradient của hàm tổn thất tại $\hat{y}_i$ là
\begin{align}
& g_{i} = \cfrac{ \partial |y_i - \hat{y}_i| }{\partial \hat{y}_i} = sign(\hat{y}_i - y_i) \\
& \rightarrow - g_{i} = sign(y_i - \hat{y}_i)
\end{align}

- Ví dụ 3: trong bài toán phân loại nhị phân với biến mục tiêu $y_i$ nhận giá trị 0 hoặc 1 và hàm tổn thất là hàm cross-entropy, gradient của hàm tổn thất tại $\hat{y}_i$ là

\begin{align}
& g_{i} = - \cfrac{ \partial y_i \times \hat{y}_i - \log(1 + e^{\hat{y}_i}) }{\partial \hat{y}_i} = \cfrac{e^{\hat{y}_i}}{1 + e^{\hat{y}_i}} - y_i \\
& \rightarrow - g_{i} = y_i - \cfrac{e^{\hat{y}_i}}{1 + e^{\hat{y}_i}}
\end{align}

- Ví dụ 4: trong bài toán phân loại mà biến mục tiêu $y_i$ có thể nhận $J$ giá trị được mã hóa là $1, 2, \cdots, J$ thì hàm tổn thất cross-entropy được viết như sau 
\begin{align}
L(y_i, \hat{y}_i) &= - \sum\limits_{j=1}^J \mathbb{I}(y_i = j) \cdot \log\left(\cfrac{e^{\hat{y}_{i,j}}}{ \sum\limits_{l=1}^J  e^{\hat{y}_{i,l}}} \right) \\
&=  \log\left( \sum\limits_{j=1}^J  e^{\hat{y}_{i,j}} \right) - \sum\limits_{j=1}^J \mathbb{I}(y_i = j) \cdot \hat{y}_{i,j}
\end{align}
Thành phần thứ $J$ của $\hat{y}_i$ được cố định bằng 0 do đó gradient của hàm tổn thất theo thành phần thứ $J$ của $\hat{y}_i$ cũng sẽ bằng 0. Với $1 \leq j \leq (J-1)$ ta có
\begin{align}
& g_{i,j} = \cfrac{e^{\hat{y}_{i,j}}}{ \sum\limits_{l=1}^J  e^{\hat{y}_{i,l}}} - \mathbb{I}(y_i = j) \\
& \rightarrow - g_{i,j} =  \mathbb{I}(y_i = j) - \cfrac{e^{\hat{y}_{i,j}}}{ \sum\limits_{l=1}^J  e^{\hat{y}_{i,l}}}
\end{align}
Trong trường hợp này, tại bước thứ $m$ của kỹ thuật gradient boosting có $(J-1)$ cây quyết định hồi quy được xây dựng độc lập nhau là $T(\textbf{x}, \Theta_{m,j})$ với biến mục tiêu tương ứng là $-g_{m-1,i,j}$.

Thuật toán gradient boosting được phát biểu như sau:

- 1. Với $m = 0$ cho 
\begin{align}
f_0 = \underset{\gamma}{\operatorname{argmin}} \sum\limits_{i = 1}^n L\left(y_i, \gamma \right)
(\#eq:GB1)
\end{align}

- 2. Tại bước thứ $m$, với $m = 1, 2, \cdots, M$,

  - 2.(a). Với mỗi $i = 1, 2, \cdots, n$ tính
  
  \begin{align}
    g_{m,i} = \cfrac{ \partial L(y_i, f_{m-1}(\textbf{x}))}{\partial f_{m-1}(\textbf{x}_i)}
  \end{align}

  - 2.(b). Tìm cây quyết định hồi quy $T(\textbf{x},\Theta_m)$ trên ma trận biến giải thích $\textbf{x}$ và biến mục tiêu là $(-g_{m,i})$, tham số của cây quyết định $\Theta_m$ bao gồm phân vùng $\{R_{m,k}\}$ với $k = 1, 2, \cdots K_m$ và hằng số $\gamma_{m,k}$
  
  \begin{align}
  \gamma_{m,k} = \underset{\gamma}{\operatorname{argmin}} \sum\limits_{i \in R_{m,k}}^n L\left(y_i, f_{m-1}(\textbf{x}_i) + \gamma \right)
  \end{align}
  
  - 2.(c). Cập nhật hàm $f_m(\textbf{x})$

    \begin{align}
      f_m(\textbf{x}) =  f_{m-1}(\textbf{x}) + \lambda \cdot T(\textbf{x},\Theta_m)
    \end{align}

- 3. Kết thúc vòng lặp, cho $f(\textbf{x}) = f_M(\textbf{x})$

Một vài lưu ý đối với thuật toán gradient boosting ở trên:

- Chúng tôi không nói về $\lambda_m$ tại mỗi bước của gradient boosting bởi vì tham số này không có ý nghĩa trong quá trình tối ưu hóa cây quyết định mà cho $\lambda_m$ nhận giá trị bằng một hằng số $\lambda$ tại bước 2.(c). Giá trị của $\lambda$ luôn nhỏ hơn 1 với vai trò như một biến kiểm soát nhằm trách hiện tượng overfitting. Chúng ta sẽ thảo luận về $\lambda$ trong phần tiếp theo. 

- Trong bài toán phân loại mà biến mục tiêu nhận $J$ giá trị, tại bước 2.(a) có $(J-1)$ véc-tơ gradient cần phải tính và tại bước 2.(b) có $(J-1)$ cây quyết định hồi quy cần được ước lượng.

Trong quá trình thực hiện gradient boosting, có ba tham số điều khiển chất lượng của mô hình là số bước lặp $M$, kích thước của cây quyết định $T(\textbf{x},\Theta_m)$ tại mỗi bước, và tham số $\lambda$ - thường được gọi là "learning rate". Chúng ta sẽ thảo luận về các tham số này trong phần tiếp theo của chương.

### Những cân nhắc khi thực hiện gradient boosting
Những vấn đề được thảo luận dưới đây phần nhiều dựa trên kinh nghiệm của những người xây dựng mô hình hơn là dựa trên những cơ sở toán học vững chắc. Nói một cách khác, không có lời giải chính xác cho các tham số điều khiển kỹ thuật gradient boosting được thảo luận dưới đây. Với những tham số như vậy, cách duy nhất để đưa ra ước lượng phù hợp là sử dụng xác thực chéo. 

#### Kích thước của cây quyết định
Tại mỗi bước $m$, bạn đọc có thể tùy chọn kích thước của cây quyết định để đảm bảo cây quyết định cho kết quả gần với các gradient của hàm tổn thất. Nếu tại mỗi bước, chúng ta luôn cố gắng tìm một kích thước cây tối ưu thì sẽ gặp phải các vấn đề là: thứ nhất thời gian thực hiện thuật toán chậm, và thứ hai dễ gặp hiện tượng overfitting. Cách tiếp cận như vậy luôn cho kết quả là các cây quyết định ban đầu sẽ cho kích thước lớn do sai số lớn ở các bước ban đầu, sau đó các cây quyết định phía sau sẽ có kích thước nhỏ do sai số đã giảm đáng kể sau khi xây dựng các cây lớn ở các bước ban đầu. 

Một chiến lược đơn giản để khắc phục hai vấn đề kể trên là cố định kích thước của cây quyết định tại tất cả các bước $K_m = K$ $\forall m$. Tham số $K$ khi đó trở thành siêu tham số của thuật toán và sẽ được ước lượng thông qua xác thực chéo. Để trả lời cho câu hỏi là miền giá trị nào của $K$ nên là miền để tìm kiếm $K$ trong xác thực chéo, chúng ta cần hiểu thêm một chút về kích thước các cây ảnh hưởng đến giá trị hàm $\hat{f}$ như thế nào.

Mục tiêu của các thuật toán học máy là tìm hàm $\hat{f}$ sao cho
\begin{align}
  \hat{f} = \underset{f}{\operatorname{argmin}} \mathbb{E}\left(Y,f(\textbf{x})\right)
\end{align}
Với ma trận $\textbf{x}$ bao gồm các biến $(\textbf{x}_1, \textbf{x}_2, \cdots, \textbf{x}_p)$, mọi hàm $f(\textbf{x})$ có thể được viết dưới dạng sau
\begin{align}
  f(\textbf{x}) = \sum\limits_j f_j(\textbf{x}_j) + \sum\limits_{j,k} f_{j,k}(\textbf{x}_j, \textbf{x}_k) + \sum\limits_{j,k,l} f_{j,k,l}(\textbf{x}_j, \textbf{x}_k, \textbf{x}_l) + \cdots
  (\#eq:gbtreesize)
\end{align}
trong đó $f_j(\textbf{x}_j)$ là thành phần của hàm mục tiêu chỉ bao gồm 1 biến duy nhất, $f_{j,k}(\textbf{x}_j, \textbf{x}_k)$ là thành phần của hàm mục tiêu có tính toán đến tác động giữa hai biến, $f_{j,k,l}(\textbf{x}_j, \textbf{x}_k, \textbf{x}_l)$ là thành phần tính đến tác động giữa ba biến,... Đa số dữ liệu thực tế cho thấy rằng phân rã hàm $f$ trong phương trình \@ref(eq:gbtreesize) các thành phần mô tả tương tác giữa một số nhỏ các biến luôn chiếm ưu thế.

Phân tích kể trên có liên quan chặt chẽ đến kích thước của cây quyết định. Thật vậy, khi $K = 2$ nghĩa là mỗi cây quyết định chỉ có duy nhất một biến giải thích. Khi $K = 3$, cây quyết định có không quá 2 biến giải thích, ... và nói chung, cây quyết định có kích thước bằng $K$ nghĩa là cây quyết định có không quá $(K-1)$ biến giải thích. Như vậy, nếu hàm $f$ có các thành phần ban đầu chiếm ưu thế, các cây quyết định với 2 hoặc 3 lá sẽ là phù hợp, còn với các hàm $f$ có các thành phần phía sau chiếm ưu thế, cây quyết định cần có kích thước lớn hơn để mô tả sự tương tác giữa nhiều biến. Như chúng ta đã nói, đa số các dữ liệu thực tế có các thành phần ban đầu trong phương trình \@ref(eq:gbtreesize) chiếm ưu thế, do đó kích thước của các cây quyết định trong Gradient boosting thường không lớn. Thực nghiệm cho thấy hiếm khi cần kích thước cây quyết định $K > 10$. Nếu tính toán cho phép bạn đọc nên sử dụng xác thực chéo để lựa chọn $K$ nhận giá trị từ 2 đến 10. Nếu thời gian và nguồn lực không cho phép, lựa chọn $K = 6$ thường được áp dụng.

#### Số lượng cây quyết định và tốc độ học
Ngoài kích thước của các cây, số lượng cây quyết định $M$ cũng là một siêu tham số. Sau mỗi bước $m$, giá trị hàm tổn thất $L(\textbf{y}, f_m)$ sẽ giảm, nghĩa là hàm $f_m$ sẽ ngày càng phù hợp hơn với dữ liệu huấn luyện mô hình. Tuy nhiên, mục tiêu của chúng ta là tìm kiếm hàm $f$ vận hành tốt trên dữ liệu kiểm thử chứ không phải dữ liệu huấn luyện, do đó tăng $M$ không phải luôn là lựa chọn tốt. Không có  
câu trả lời chính xác cho số lượng cây tối ưu, tham số này chỉ có thể được xác định thông qua xác thực chéo.

Một tham số khác cũng cần được cân nhắc khi triển khai gradient boosting là tốc độ học $\lambda$. Tham số $lambda$ xuất hiện trong bước 2.(c). của thuật toán gradient boosting cho biết đóng góp của mỗi cây quyết định vào kết quả cuối cùng. Cũng giống như khi triển khai thuật toán gradient decent thông thường, khi tốc độ học $\lambda$ nhỏ, quá trình tìm kiếm điểm tối ưu sẽ chậm hơn nhưng khả năng tìm được đúng điểm tối ưu sẽ lớn hơn. Nói cách khác, khi lựa chọn tham số $\lambda$ nhỏ, khoảng tìm kiếm của $M$ cần phải ưu tiên các giá trị lớn hơn, thời gian thực hiện thuật toán sẽ lâu hơn và khả năng tìm được hàm $f$ tối ưu sẽ lớn hơn.

Nghiên cứu của Friedman (2001) đã chỉ ra rằng lựa chọn $\lambda$ nhỏ hơn sẽ làm cho sai số trên tập kiểm tra tốt hơn và yêu cầu các giá trị $M$ lớn hơn tương ứng. Chiến lược tốt nhất để thực hiện boosting là cho $\lambda$ nhận giá trị rất nhỏ, thường là nhỏ hơn $0.1$ và sau đó chọn M bằng cách dừng sớm. Cách tiếp cận này cải thiện đáng kể sai số trên tập kiểm tra cho cả bài toán hồi quy và phân loại so với việc sử dụng $\lambda = 1$. Sự đánh đổi ở đây là thời gian và nguồn lực để thực hiện tính toán: $\lambda$ càng nhỏ thì càng cần phải làm tăng giá trị $M$ làm cho thời gian và nguồn lực tính toán tăng lên tỷ lệ thuận. Tuy nhiên, với khả năng tính toán của đa số các máy tính hiện nay, cách tiếp cận này là khả thi ngay cả trên các tập dữ liệu rất lớn.

#### Stochastic gradient boosting
Stochastic gradient boosting là một cải tiến của gradient boosting mà tại mỗi bước $m$, thay vì sử dụng toàn bộ dữ liệu huấn luyện để xây dựng cây quyết định, chúng ta chỉ sử dụng một mẫu ngẫu nhiên của dữ liệu để xây dựng cây quyết định. Tỷ lệ mẫu ngẫu nhiên so với dữ liệu huấn luyện được ký hiệu là $\eta$ và thường được lựa chọn bằng $0.5$. Khi kích thước dữ liệu $n$ lớn, có thể lựa chọn $\eta$ nhỏ hơn.

Lợi thế trước tiên của stochastic gradient boosting đó là giảm thời gian tính toán do dữ liệu để xây dựng cây quyết định nhỏ hơn đáng kể so với dữ liệu huấn luyện. Một lợi thế đáng kể khác của cách tiếp cận này là trong nhiều trường hợp nó còn có thể tìm được điểm tối ưu tốt hơn so với gradient boosting thông thường. Không có cách giải thích toán học đáng tin cậy nào về kết luận này, tuy nhiên có thể hiểu rằng khi xây dựng các cây quyết định trên một mẫu ngẫu nhiên của dữ liệu, nếu kích thước dữ liệu đủ lớn thì phân phối xác suất của mẫu và toàn bộ dữ liệu là tương đương, trong khi trong khi các quan sát nhiễu hay ngoại lai của dữ liệu huấn luyện ít có khả năng rơi vào mẫu ngẫu nhiên, việc này làm cho các cây quyết định ít bị ảnh hưởng bởi nhiễu hoặc các giá trị ngoại lai, đặc biệt là trong các bài toán hồi quy.


### Thực hiện gradient boosting trên R.
Thư viện để thực hiện gradient boosting trên R là thư viện $gbm$. Tại thời điểm chúng tôi viết chương sách này, thư viện $gbm$ được sử dụng đang ở phiên bản 2.1.8.1. Thư viện được xây dựng dựa trên nghiên cứu của Greg Ridgeway (1999) với ý tưởng hoàn toàn giống như chúng tôi đã trình bày trong các phần trước. Hàm số để thực hiện gradient boosting là hàm số `gbm()`. 

``` r
library(gbm)
? gbm
```

Bạn đọc có thể đọc hướng dẫn ngắn gọn của R về các tham số và cách sử dụng trong hàm `gbm()` hoặc tìm hướng dẫn đầy đủ về thư viện `gbm()` theo đường dẫn \textit{https://cran.r-project.org/web/packages/gbm/gbm.pdf}. Chúng tôi chỉ tập trung giải thích vào các tham số quan trọng của thuật toán:

- $formula$: cách sử dụng tương tự như hàm $lm$ hay $glm$; cần khai báo tên biến phụ thuộc và các biến giải thích.

- $distribution$: là phân phối xác suất của biến mục tiêu. Mặc dù không phải tham số bắt buộc nhưng lời khuyên của chúng tôi là bạn đọc hãy luôn luôn khai báo biến này để đảm bảo cách xây dựng mô hình đúng với ý định. Tham số này không được khai báo, hàm `gbm()` sẽ dựa trên kiểu biến mục tiêu để dự đoán phân phối xác suất: nếu $Y$ có dạng factor và chỉ nhận hai giá trị phân phối nhị thức sẽ được sử dụng, nếu $Y$ nhận nhiều hơn 2 giá trị, phân phối multinomial sẽ được sử dụng. Nếu $Y$ là biến dạng số, phân phối Gaussian sẽ được sử dụng. Các giá trị có thể nhận được của tham số $distribution$
  - $"gaussian"$: cho bài toán hồi quy và hàm tổn thất hàm tổng sai số bình phương.
  - $"laplace"$: cho bài toán hồi quy và hàm tổn thất hàm tổng giá trị tuyệt đối sai số.
  - $"bernoulli"$: cho bài toán phân loại nhị phân và hàm tổn thất cross-entropy.
  - $"adaboost"$: cho bài toàn phân loại nhị phân và hàm tổn thất kiểu mũ.
  - $"multinomial"$: cho bài toán phân loại chung và hàm tổn thất cross-entropy.

- $data$ là dữ liệu huấn luyện mô hình.

- $n.trees$ tương đương với tham số $M$ trong gradient boosting, là số lượng cây quyết định trong thuật toán.

- $interaction.depth$ cho biết kích thước (số node) của các cây phân loại. Giá trị mặc định là 1 cho biết các cây phân loại được mặc định là các stump.

- $shrinkage$ là tham số $\lambda$ trong gradient boosting. Giá trị mặc định là 0.1. Giá trị tham số $shrinkage$ được gợi ý là khoảng từ 0.001 đến 0.1.

- $bag.fraction$ là tham số $\eta$ trong stochastic gradient boosting. Giá trị mặc định của tham số này là 0.5 nghĩa là tại mỗi bước xây dựng cây quyết định chỉ có 50\% dữ liệu huấn luyện được sử dụng để xây dựng mô hình. Lưu ý khi sử dụng $bag.fraction < 1$ bạn đọc cần khởi tạo lại hàm sinh ngẫu nhiên (`set.seed()`) để đảm bảo kết quả các lần chạy giống nhau. 

- $cv.folds$ là tham số cho biết có sử dụng xác thực chéo hay không. Nếu $cv.folds > 1$ thì xác thực chéo sẽ được thực hiện và sai số xác thực chéo sẽ được lưu lại trong output có tên là $cv.error$.





<!-- ### Source from thesis -->
**1.** Freund, Y. and Schapire, R. (1997). *A decision-theoretic generalization of online learning and an application to boosting*

**2.** G. Ridgeway (1999). *The state of boosting*

**3.** J.H. Friedman, T. Hastie, R. Tibshirani (2000). *Additive Logistic Regression: a Statistical View of Boosting* 

**4.** J.H. Friedman (2001). *Greedy Function Approximation: A Gradient Boosting Machine* 

<!-- ### Souce from website -->

<!-- **4.** [https://www.tableau.com/learn/articles/data-visualization](https://www.tableau.com/learn/articles/data-visualization) \ -->
<!-- **5.** [https://www.r-graph-gallery.com/ggplot2-package.html](https://www.r-graph-gallery.com/ggplot2-package.html) \ -->
<!-- **6.** [http://r-statistics.co/ggplot2-Tutorial-With-R.html](http://r-statistics.co/ggplot2-Tutorial-With-R.html) \ -->
<!-- **7.** [https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf](https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf) \ -->
<!-- **8.** [https://www.kaggle.com/](https://www.kaggle.com/) \ -->
