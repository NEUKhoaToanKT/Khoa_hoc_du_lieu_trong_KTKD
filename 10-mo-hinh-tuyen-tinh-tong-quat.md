---
output:
  word_document: default
  html_document: default
  pdf_document: default
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
## Classes and Methods for R developed in the
## Political Science Computational Laboratory
## Department of Political Science
## Stanford University
## Simon Jackman
## hurdle and zeroinfl functions by Achim Zeileis
```



# Mô hình tuyến tính tổng quát.
Mô hình tuyến tính tổng quát, Generalized Linear Model hay viết tắt là GLM, được sử dụng rộng rãi trong các doanh nghiệp, các cơ quan tổ chức hoạt động trong lĩnh vực tài chính, ngân hàng, và bảo hiểm. Các chuyên gia quản trị rủi ro trong các ngân hàng sử dụng GLM để chấm điểm tín dụng khách hàng và quyết định phê duyệt tín dụng. Các chuyên gia tính toán thường xuyên sử dụng mô hình GLM để xác định phí thuần của các sản phẩm bảo hiểm, để xác định dự phòng nghiệp vụ, hoặc để phân loại rủi ro mà công ty phải đối mặt. Khái niệm GLM lần đầu tiên được sử dụng trong nghiên cứu của Nelder và Wedderburn (1972) và từ đó đến nay đã có nhiều sách tham khảo tin cậy cho mô hình này như Alan Agresti (2015) hay Annette J. Dobson and Adrian G. Barnett (2018). Đa số các tài liệu tham khảo giới thiệu GLM dưới góc độ toán học và mang nhiều tính lý thuyết. Chương sách này sẽ cố gắng giải thích và tiếp cận GLM từ một góc nhìn mang tính thực hành nhiều hơn. Chúng tôi sẽ không quá đi sâu vào các khía cạnh như giả thiết hay phương pháp ước lượng của mô hình GLM, mà sẽ tập trung vào hướng dẫn bạn đọc ứng dụng GLM trên nhiều kiểu dữ liệu nhất có thể.

Mô hình tuyến tính tổng quát được phát biểu dưới dạng công thức như sau:
\begin{align}
 & Y \sim  \mathcal{F}_{\boldsymbol{\theta}} \\
 & \mathbb{E}(Y|\textbf{X} = \textbf{x}_i) = \mu_i \\ 
 & g(\mu_i) = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p} \\
 & \mu_i = g^{-1}\left(\beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p} \right)
(\#eq:glm1)
\end{align}
với $Y$ là biến mục tiêu, $\mathcal{F}_{\boldsymbol{\theta}}$ là một phân phối xác suất có tham số là một véc-tơ $\boldsymbol{\theta}$. Giá trị trung bình của biến mục tiêu $Y$ phụ thuộc vào giá trị của (các) biến độc lập như sau: với điều kiện véc-tơ biến độc lập $\textbf{X} = (X_1, X_2, \cdots, X_p)$ nhận giá trị $\textbf{x_i} = (x_{i,1}, x_{i,2}, \cdots, x_{i,p})$, giá trị trung bình của biến phụ thuộc với điều kiện $\textbf{X} = x_i$, ký hiệu $Y|\textbf{X} = x_i$ hoặc ngắn gọn hơn là $Y_i$, được xác định bằng giá trị một hàm số ngược của một hàm số thực $g$, ký hiệu là hàm $g^{-1}$, tính tại một tổ hợp tuyến tính của các giá trị $(x_{i,1}, x_{i,2}, \cdots, x_{i,p})$.

Thay vì cố gắng hiểu các khái niệm toán học ở trên, chúng ta hãy thử áp dụng mô hình kể trên trong một trường hợp cụ thể. Chúng ta sẽ xây dựng một mô hình tuyến tính tổng quát mà trong đó biến mục tiêu $Y$ cho biết người mua bảo hiểm xe ô tô có hay không lựa chọn đầy đủ các quyền lợi bảo hiểm khi ký hợp đồng mua bảo hiểm trách nhiệm dân sự. Dữ liệu được sử dụng có tên là $MotoInsurance.csv$. Dữ liệu có 6 biến độc lập là:

- 1. Độ tuổi của người lái xe, biến $age$, nhận giá trị là các số nguyên dương từ 15 đến 92 tuổi.
- 2. Kinh nghiệm lái xe, biến $seniority$, cho biết số năm kinh nghiệm lái xe, giá trị là các số nguyên từ 2 đến 40 năm.
- 3. Giới tính của người lái xe, biến $sex$, nhận giá trị "M" nếu người lái xe là nam giới và "F" nếu người lái xe là nữ giới.
- 4. Nơi xe được đăng ký, biến $urban$, nhận giá trị là 1 nếu xe được đăng ký tại khu vực thành phố và nhận giá trị 0 trong các trường hợp còn lại.
- 5. Loại hình đăng ký xe, biến $private$, nhận giá trị là 1 nếu xe mua bảo hiểm là xe đăng ký theo cá nhân và nhận giá trị 0 trong các trường hợp còn lại.
- 6. Tình trạng hôn nhân của người lái xe, biến $marital$, nhận giá trị "C" nếu đã kết hôn, "S" tương ứng với chưa kết hôn, và "O" tương ứng với đã ly dị.

Biến mục tiêu hay biến phụ thuộc là biến $Y$ nhận một trong hai giá trị, "Yes" nếu người mua bảo hiểm trách nhiệm dân sự đồng ý lựa thêm quyền lợi bảo hiểm bổ sung và "No" nếu người mua bảo hiểm trách nhiệm dân sự không lựa chọn mua quyền lợi bổ sung. Để mô hình ở dạng đơn giản nhất có thể, chúng tôi lựa chọn hai biến độc lập để xây dựng mô hình là biến $age$ và biến $sex$. Chúng ta sẽ sử dụng biến $age$ như một biến kiểu số, trong khi biến $sex$ là một biến kiểu phân loại/rời rạc nhận một trong hai giá trị là "M" tương ứng với nam giới và "F" tương ứng với nữ giới.

Đoạn lệnh R dưới đây được sử dụng để lấy dữ liệu và phân tích nhanh ảnh hưởng của các biến $age$ và $sex$ lên quyết định mua bảo hiểm bổ sung của người sở hữu xe ô tô.

```r
dat<-read.csv("../KHDL_KTKD Final/Dataset/MotoInsurance.csv")

# Đổi các biến Y và sex sang kiểu factor
dat$Y<-as.factor(dat$Y)
dat$sex<-as.factor(dat$sex)

# Thực hiện các phân tích khai phá
p1<-dat%>%ggplot()+geom_boxplot(aes(x = Y, y = age))+
  ggtitle("Mối liên hệ giữa biến age và biến Y")+
  theme_minimal()

p2<-dat%>%ggplot()+geom_bar(aes(x = sex, fill = Y),col = "black")+
  ggtitle("Mối liên hệ giữa biến sex và biến Y")+
  theme_minimal()+
  scale_fill_manual(values = c("white","grey"))

grid.arrange(p1,p2, ncol = 2)
```

<img src="10-mo-hinh-tuyen-tinh-tong-quat_files/figure-html/unnamed-chunk-3-1.png" width="1152" style="display: block; margin: auto;" />

Bạn đọc có thể thấy rằng: đồ thị bên trái cho thấy những người trẻ tuổi hơn có xu hướng đồng ý mua bảo hiểm bổ sung hơn những người nhiều tuổi; đồ thị bên phải cho thấy nữ giới có xu hướng mua bảo hiểm bổ sung cao hơn so với nam giới.

Chúng ta sẽ xây dựng một mô hình tuyến tính tổng quát để xác nhận lại các phân tích ở trên và lượng hóa được ảnh hưởng của các biến $age$ và $sex$ lên quyết định mua bảo hiểm bổ sung. Hàm số dùng để xây dựng và ước lượng mô hình tuyến tính tổng quát trong R là hàm `glm()` của thư viện $stat$:


```r
# Biến Y có phân phối nhị thức
# Hàm g là hàm probit
glm1<-glm(Y ~ age + sex, data=dat, 
          family = binomial(link = "probit")) # khai báo hàm g
summary(glm1)
```

```
## 
## Call:
## glm(formula = Y ~ age + sex, family = binomial(link = "probit"), 
##     data = dat)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.4495  -0.9278  -0.7382   1.2584   2.0391  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  0.678644   0.079138   8.575   <2e-16 ***
## age         -0.016257   0.001619 -10.041   <2e-16 ***
## sexM        -0.446783   0.047421  -9.422   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 5163.3  on 3999  degrees of freedom
## Residual deviance: 4933.9  on 3997  degrees of freedom
## AIC: 4939.9
## 
## Number of Fisher Scoring iterations: 4
```

Chúng ta có thể thấy rằng các hệ số của biến $age$ và $sex$ đều có ý nghĩa thống kê khi các giá trị $p-value$ đều rất nhỏ. Đúng như chúng nhận định từ phần phân tích khai phá, hệ số tuyến tính của biến $age$ là số âm, bằng -0.016, cho biết người trẻ tuổi hơn có khả năng đồng ý mua bảo hiểm bổ sung cao hơn. Hệ số ứng với biến giới tính nam là số âm, bằng -0.447, điều này cho biết khả năng nam giới đồng ý mua bảo hiểm bổ sung là thấp hơn so với nữ giới.

Chúng ta có thể viết các thành phần của mô hình tuyến tính tổng quát đã xây dựng ở trên như sau

\begin{align}
 & Y \sim  \mathcal{B}(\rho) \\
 & \mathbb{E}(Y_i) = \mathbb{E}\left(Y|(age_i, sex_i)\right) = \rho_i \\ 
 & \Phi^{-1}\left(\rho_i\right) = 0.678 - 0.016 \times age_i - 0.447 \times sex_i \\
 & \rho_i = \Phi\left(0.678 - 0.016 \times age_i - 0.447 \times sex_i\right)
(\#eq:glm2)
\end{align}
trong đó $\rho_i$ là xác suất hay khả năng người $i$ mua đầy đủ các quyền lợi của bảo hiểm sau khi đã mua bảo hiểm trách nhiệm dân sự. Hàm $\Phi$ là hàm phân phối xác suất của biến ngẫu nhiên phân phối chuẩn có trung bình 0 va phương sai bằng 1. Đây là hàm số mà chúng ta lựa chọn để liên kết giữa xác suất mua bảo hiểm bổ sung đến tổ hợp tuyến tính của các biến độc lập.

Từ kết quả của mô hình, chúng ta có thể kết luận rằng khả năng mua bảo hiểm bổ sung phụ thuộc một cách có ý nghĩa thống kê biến độ tuổi ($age$) và giới tính ($sex$) của người tham gia bảo hiểm trách nhiệm dân sự bắt buộc. Sự phụ thuộc này cụ thể như sau: 

1. Xác suất mà một người mua đầy đủ các quyền lợi bảo hiểm sau khi mua bảo hiểm bắt buộc sẽ GIẢM nếu tuổi của người tham gia bảo hiểm TĂNG, điều này có nghĩa là những người trẻ tuổi hơn thường có nhu cầu mua đầy đủ các quyền lợi bảo hiểm hơn những người lớn tuổi.

2. Nam giới ít có khả năng mua đầy đủ quyền lợi bảo hiểm như nữ giới.

Mối liên hệ giữa xác suất mua bảo hiểm đầy đủ và các thuộc tính của người được quan sát được mô tả một cách định lượng thông qua phương trình
\begin{align}
 \rho_i = \Phi\left(0.678 - 0.016 \times age_i - 0.447 \times sex_i\right)
(\#eq:glm3)
\end{align}
trong đó
$age_i$ là tuổi của người tham gia bảo hiểm; $sex_i$ nhận giá trị bằng 1 nếu người đó là nam giới và 0 nếu người đó là nữ giới; và $\Phi$ là hàm phân phối xác suất của biến ngẫu nhiên phân phối chuẩn $\mathcal{N}(0,1)$; miền giá trị của hàm số này đảm bảo cho giá trị xác suất $\rho_i$ được tính ra nằm trong khoảng (0,1).

Bạn đọc có thể nhận thấy được sự khác biệt giữa mô hình tuyến tính tổng quát ở trên với mô hình tuyến tính thông thường ở hai điểm:

- 1. Phân phối xác suất của biến mục tiêu $Y$ là phân phối nhị thức chứ không phải là phân phối chuẩn.

- 2. Mối liên kết giữa giá trị trung bình của biến mục tiêu $Y$ và tổ hợp tuyến tính của các biến độc lập được thể hiện thông qua một hàm số, trong trường hợp này là hàm $\Phi$. Trong mô hình tuyến tính thông thường, giá trị trunh bình của biến mục tiêu được mô tả trực tiếp bằng tổ hợp tuyến tính của các biến độc lập.

Hải điểm nêu trên cũng chính là hai cải tiến quan trọng của mô hình tuyến tính tổng so với mô hình hồi quy tuyến tính thông thường. Việc tổng quát hóa phân phối của biến phụ thuộc và thiết lập một hàm liên kết giữa giá trị trung bình của biến phụ thuộc và với các biến độc lập giúp cho mô hình tuyến tính tổng quát linh hoạt hơn rất nhiều khi làm việc với các dữ liệu cụ thể và vẫn giữ được khả năng suy diễn giống như mô hình hồi quy tuyến tính thông thường. Trong phần tiếp theo của chương chúng ta sẽ thảo luận kỹ hơn về các vấn đề này.

## Các nhược điểm của mô hình hồi quy tuyến tính.

Mô hình hồi quy tuyến tính là nền tảng quan trọng cho hầu hết các mô hình học máy và các mô hình trí tuệ nhân tạo hiện tại. Trước khi những mô hình học máy được nghiên cứu và phát triển mạnh mẽ như hiện nay, những người xây dựng mô hình luôn gặp khó khăn khi sử dụng mô hình hồi quy tuyến tính trong nhiều hoàn cảnh. Nguyên nhân là do giả thiết về phân phối xác suất của biến mục tiêu và miền giá trị trung bình của biến mục tiêu của mô hình hồi quy tuyến tính thông thường là không phù hợp với đa số dữ liệu thực tế.

Thật vậy, mô hình hồi quy tuyến tính được thảo luận trong phần trước của cuốn sách có thể được tóm tắt như sau: người xây dựng mô hình cố gắng nghiên cứu mối quan hệ giữa một biến mục tiêu $Y$ với véc-tơ biến độc lập $\textbf{X} = (X_1, X_2, \cdots, X_p)$ bằng cách cho rằng mối liên hệ giữa $Y$ và $\textbf{X}$ là một hàm tuyến tính. Mối liên hệ đó không đồng nhất nên sai số sẽ tồn tại và những người xây dựng mô hình cho rằng sai số có phân phối chuẩn với trung bình bằng 0 và độ lệch chuẩn là một hằng số $\sigma > 0$. Chúng ta biểu diễn mô hình tuyến tính thông thương như sau

\begin{align}
 & Y = \beta_0 + \beta_1 \cdot X_1 + \beta_2 \cdot X_2 + \cdots + \beta_p \cdot X_p + \epsilon \\
 & \epsilon \sim \mathcal{N}(0, \sigma^2)
(\#eq:glm4)
\end{align}

Bạn đọc có thể thấy rằng trong mô hình hồi quy tuyến tính, biến phụ thuộc $Y$ là biến ngẫu nhiên có phân phối chuẩn có phương sai là $\sigma^2$ và giá trị trung bình phụ thuộc vào véc-tơ biến độc lập $\textbf{X}_i$. Với điều kiện biến độc lập nhận giá trị là $\textbf{x}_i = (x_{i,1}, x_{i,2}, \cdots, x_{i,p})$; chúng ta có mô hình hồi quy tuyến tính như sau: 

\begin{align}
& Y_i \sim  \mathcal{N}(\mu_i, \sigma^2) \\
& \mu_i = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}
(\#eq:glm5)
\end{align}

Ngoài giả thiết về phân phối chuẩn của $Y$, mô hình hồi quy tuyến tính thông thường còn cho rằng giá trị trung bình của biến ngẫu nhiên $Y$ với điều kiện các biến độc lập nhận giá trị $\textbf{x}_i$, ký hiệu $\mu_i$, là một tổ hợp tuyến tính của các biến độc lập. Khi các biến độc lập nhận các giá trị bất kỳ, miền giá trị của $\mu_i$ sẽ là (toàn bộ) tập các số thực $\mathbb{R}$.

Câu hỏi đặt ra là: làm như thế nào để áp dụng mô hình hồi quy tuyến tính trong các trường hợp như sau?

1. Biến mục tiêu $Y$ chỉ nhận hai giá trị là 0 hoặc 1. Đây là trường hợp rất thường gặp phải trong nhiều lĩnh vực khi thực hiện phân tích dữ liệu. Có thể kể đến như: khi biến $Y$ đại diện cho sự kiện một người có hay không tham gia bảo hiểm xã hội; một người có hay không thực hiện rút bảo hiểm xã hội một lần trong thời gian một khoảng thời gian; một khách hàng có hay không gửi yêu cầu thanh toán bảo hiểm; hay tương tự như ví dụ trong phần đầu của cuốn sách, một khách hàng đã mua bảo hiểm bắt buộc có hay không mua thêm các quyền lợi bảo hiểm bổ sung. Ngoài lĩnh vực bảo hiểm, biến mục tiêu $Y$ chỉ nhận giá trị 0 hoặc 1 còn xuất hiện trong lĩnh vực ngân hàng tài chính: biến mục tiêu cho biết một giao dịch trực tuyến có phải là một giao dịch gian lận hay không; một khách hàng có hay không tiếp nhận sản phẩm dịch vụ tài chính với mới; một khách hàng có hay không hoàn trả khoản nợ thẻ tín dụng trong thời gian tới,... Trong tất cả các trường hợp kể trên không thể giả thiết phân phối xác suất của biến mục tiêu là phân phối chuẩn. Hơn thế nữa, giá trị trung bình của biến mục tiêu sẽ luôn nằm trong khoảng 0 đến 1, chứ không phải toàn bộ trục số thực. Nếu sử dụng một tổ hợp tuyến tính của các biến độc lập để tính toán giá trị trung bình của biến mục tiêu, chúng ta sẽ có thể gặp các giá trị nhỏ hơn 0 hoặc các giá trị lớn hơn 1.

2. Biến mục tiêu $Y$ là biến dạng đếm. Chẳng hạn như $Y$ cho biết một người tham gia bảo hiểm xã hội gửi yêu cầu bồi thường bao nhiêu lần trong một năm; biến $Y$ cho biết một khách hàng mua bảo hiểm xe ô tô gây ra bao nhiêu tai nạn trong thời gian được bảo hiểm,... Trong trường hợp này, $Y$ sẽ nhận giá trị kiểu số đếm: $0, 1, 2, \cdots$ tương ứng với số lần khách hàng gửi yêu cầu bảo hiểm. Không thể sử dụng mô hình hồi quy tuyến tính thông thường do biến $Y$ là biến rời rạc đồng thời giá trị trung bình của $Y$ là một số lớn hơn 0.

3. Ngay cả khi trong các trường hợp biến phụ thuộc $Y$ là biến liên tục, sử dụng mô hình tuyến tính thông thường cũng sẽ gặp phải vấn đề. Chẳng hạn như khi $Y$ là số tiền khách hàng yêu cầu bồi thường cho xe ô tô trong trường hợp xảy ra tai nạn. Biến $Y$ chỉ nhận giá trị là số dương và thường có phân phối xác suất lệch phải với đuôi lớn. Sử dụng giả thiết phân phối chuẩn cho biến $Y$ sẽ làm cho mô hình không đánh giá đúng khả mức độ nghiêm trọng của yêu cầu bồi thường do phân phối chuẩn không có khả năng mô tả các rủi ro có đuôi lớn. Đồng thời, giá trị trung bình của số tiền yêu cầu bồi thường luôn là số dương, do đó cũng không thể sử dụng tổ hợp tuyến tính của các biến độc lập để trực tiếp mô tả giá trị trung bình của $Y$.

Có thể tổng kết rằng hai vấn đề thường gặp phải khi sử dụng mô hình hồi quy tuyến tính thông thường trên dữ liệu thực tế là

- Thứ nhất: sự không phù hợp của giả thiết phân phối chuẩn đối với biến mục tiêu $Y$; và

- Thứ hai: miền giá trị trung bình của biến mục tiêu $Y$ không phù hợp với miền giá trị của tổ hợp tuyến tính của biến độc lập. Giá trị $\textbf{x}_i^{'} \boldsymbol{\beta} = \beta_0 + \beta_1 \ x_{i,1} + \beta_2 \ x_{i,2} + \cdots + \beta_p \ x_{i,p}$ có thể nhận bất kỳ giá trị nào trong $\mathbb{R}$, trong khi giá trị trung bình của biến mục tiêu $Y$ trong các dữ liệu thực tế lại thường chỉ là một tập con của $\mathbb{R}$.

Mô hình tuyến tính tổng quát được xây dựng trên cơ sở của mô hình hồi quy tuyến tính thông thường với mục đích khắc phục hai nhược điểm kể trên. 
- Trước hết, mô hình tuyến tính tổng quát giả thiết một phân phối phù hợp cho biến phụ thuộc $Y$, tùy vào dữ liệu sử dụng để phân tích, tạm gọi là phân phối $F$ với tham số $\boldsymbol{\theta}$, ký hiệu là $F_\boldsymbol{\theta}$. 
- Tiếp theo, để đảm bảo miền giá trị của giá trị trung bình của $Y$ với điều kiện các biến độc lập bằng $\textbf{x}_i$, $\mu_i = E(Y|\textbf{X} = \textbf{x}_i)$, phù hợp với miền giá trị của $\textbf{x}_i^{'} \boldsymbol{\beta}$, mô hình tuyển tính tổng quát sử dụng một hàm số đơn điệu $g$, được gọi là hàm liên kết, để biến đổi miền giá trị của $\mu_i$. Chúng ta phát biểu mô hình tuyến tính tổng quát như sau 
\begin{align}
& Y \sim  F_\theta \\
& \mathbb{E}(Y|\textbf{X} = \textbf{x}_i) = \mu_i \\ 
& g(\mu_i) = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}
(\#eq:glm6)
\end{align}

Trước hết, có thể thấy rằng mô hình hồi quy tuyến tính thông thường là trường hợp đặc biệt của mô hình tuyến tính tổng quát khi tham số $\boldsymbol{\theta}$ là $\sigma^2$; phân phối $F$ là phân phối chuẩn; và hàm $g$ là hàm số đồng nhất $g(x) = x$.

Giả thiết đơn điệu của hàm liên kết $g$ đảm bảo sự tồn tại của hàm số ngược $g^{-1}$. Mối liên hệ của $\mu_i$ và $\textbf{x}_i^{'} \boldsymbol{\beta}$ có thể được viết lại dưới dạng hàm ngược của hàm liên kết như sau
\begin{align}
 \mu_i = g^{-1}(\textbf{x}_i^{'} \boldsymbol{\beta})
(\#eq:glm7)
\end{align}

Quay trở lại ví dụ ở phần trước của chương sách, chúng ta phân tích về tác động của độ tuổi và giới tính lên quyết định có tham gia quyền lợi bảo hiểm bổ sung hay không. Mô hình tuyến tính tổng quát được xây dựng như sau:

\begin{align}
 & Y \sim  \mathcal{B}(p) \\
 & \mathbb{E}(Y|age_i, sex_i) = p_i \\ 
 & \Phi^{-1}(p_i) = 0.678 - 0.016 \times age_i - 0.446 \times sex_i
\end{align}

Phân phối xác suất của biến $Y$ là phân phối nhị thức do $Y$ chỉ có thể nhận là 0 hoặc 1. Đồng thời, giá trị trung bình của $Y$ nằm trong khoảng $(0,1)$ chúng ta có thể chọn hàm liên kết $g$ là hàm $\Phi^{-1}$. Đây là hàm ngược của hàm phân phối xác suất của biến ngẫu nhiên phân phối chuẩn $\mathcal{N}(0,1)$ nên thỏa mãn các điều kiện của một hàm liên kết: hàm đơn điệu tăng; có miền xác định là $(0,1)$; và miền giá trị là tập số thực $\mathbb{R}$. Nếu không lựa chọn $\Phi^{-1}$, mọi hàm số đơn điệu, có miền xác định là khoảng $(0,1)$, và miền giá trị là tập số thực $\mathbb{R}$ đều có thể được lựa chọn làm hàm số kết nối.

## Xây dựng mô hình tuyến tính tổng quát
Phần tiếp theo của cuốn sách sẽ thảo luận về cách xây dựng mô hình tuyến tổng quát với các kiểu giá trị khác nhau của biến phụ thuộc $Y$. Xin được nhắc lại rằng đây là cuốn sách dành cho cả các bạn đọc không có nền tảng toán học nâng cao. Do đó, những thảo luận phức tạp liên quan đến các giả thiết của mô hình hay phương pháp ước lượng tham số sẽ được trình bày ở phần sau của chương sách. Chúng ta sẽ hiểu về mô hình tuyến tính tổng quát thông qua việc ứng dụng mô hình cho các các dữ liệu thực tế trước khi đi sâu vào bản chất toán học của mô hình.

### Biến phụ thuộc là biến dạng nhị phân.
Đây là các trường hợp mà biến phụ thuộc chỉ nhận một trong hai giá trị. Ở phần trên chúng ta đã trình bày các ví dụ cho trường hợp này: khách hàng có hay không hoàn trả nợ thẻ tín dụng, khách hàng phản hồi tích cực hay tiêu cực về sản phầm, một yêu cầu bồi thường là trục lợi hay bình thường, một giao dịch rút tiền ngân hàng có hay không phải là giao dịch gian lận, ... Mặc dù đây chỉ là một trường hợp đặc biệt của biến phụ thuộc nhận giá trị rời rạc nhưng qua các ví dụ thực tế lại thấy rằng phần lớn các dữ liệu gặp phải lại có biến phụ thuộc ở dạng nhị phân. Khi $Y$ chỉ nhận hai giá trị, chúng ta sẽ luôn mã hóa giá trị của $Y$ thành hai số là 0 và 1. Một vài cuốn sách khác, hoặc trong một vài lĩnh vực nghiên cứu khác, người xây dựng mô hình có thể mã hóa $Y$ thành -1 và 1. Tuy nhiên hai cách mã hóa này chỉ khác nhau ở hình thức chứ không làm ảnh hưởng đến kết quả của mô hình.

#### Phân phối xác suất của biến phụ thuộc.
Khi biến phụ thuộc là biến dạng nhị phân, một cách tự nhiên, chúng ta sẽ sử dụng phân phối nhị thức, hay còn gọi là phân phối Bernoulli, để mô tả biến phụ thuộc. Biến ngẫu nhiên $B$ có phân phối nhị thức với tham số $\rho$, $0 < \rho < 1$, ký hiệu $\mathcal{B}(\rho)$, là biến ngẫu nhiên chỉ nhận hai giá trị là 0 và 1 với hàm khối lượng xác suất như sau  
\begin{align}
\mathbb{P}(B = x) = \rho^x \times (1-\rho)^{(1-x)} \text{ với } x \in \{0;1\}
(\#eq:glm80)
\end{align}

Chúng ta có giá trị trung bình và phương sai của $\mathcal{B}(\rho)$.
\begin{align}
& \mathbb{E}(B) = \rho \\
& \mathbb{V}(B) = \rho \ (1-\rho) 
(\#eq:glm81)
\end{align}

Có thể thấy rằng phân phối nhị thức có duy nhất một tham số $\rho$ và tham số này cũng chính là giá trị trung bình của biến đó. Phương sai của $\mathcal{B}(\rho)$ nhỏ hơn giá trị trung bình.

#### Lựa chọn hàm liên kết.

Khi biến phụ thuộc $Y$ có phân phối nhị thức, giá trị trung bình của biến phụ thuộc sẽ nằm trong khoảng $(0,1)$. Từ công thức \@ref(eq:glm6), nếu cho $\rho_i$ là giá trị trung bình của biến phụ thuộc với điều kiện các biến độc lập $\textbf{X} = \textbf{x}_i$, ta có 

\begin{align}
& \mathbb{E}(Y|\textbf{X} = \textbf{x}_i) = \rho_i \\ 
& g(\rho_i) = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,3}
(\#eq:bn1)
\end{align}

Như vậy, mọi hàm số đơn điệu có miền xác định là khoảng $(0,1)$ và miền giá trị là toàn bộ tập số thực $\mathbb{R}$ đều có thể được lựa chọn để làm hàm ngược của hàm liên kết. Làm thế nào để có được những hàm số có tính chất như vậy? Chúng ta đều biết rằng các hàm phân phối xác suất của một biến ngẫu nhiên liên tục bất kỳ là các hàm số tăng, có miền xác định là $\mathbb{R}$ và miền giá trị là khoảng $(0,1)$. Do đó, hàm số ngược của các hàm phân phối xác suất, sẽ là các hàm số tăng, có miền xác định là khoảng $(0,1)$ và miền giá trị là $\mathbb{R}$. Nói một cách khác, hàm số ngược của các hàm phân phối xác suất bất kỳ thỏa mãn đầy đủ tính chất của hàm liên kết trong trường hợp $Y$ có phân phối nhị thức.

Trong thực tế, việc lựa chọn hàm liên kết còn có mục tiêu là để mô hình dễ giải thích và quá trình ước lượng mô hình đơn giản nhất có thể. Các hàm phân phối xác suất thường được lựa chọn làm $g^{-1}(.)$ bao gồm có: thứ nhất là hàm phân phối của biến ngẫu nhiên logistic; thứ hai là hàm phân phối của biến ngẫu nhiên phân phối chuẩn; và thứ ba là hàm phân phối của biến ngẫu nhiên phân phối Cauchy.  

1. Hàm phân phối của biến ngẫu nhiên logistic và hàm ngược được cho bởi công thức sau
\begin{align}
& \textit{Hàm phân phối xác suất: } \ g^{-1}(x) = \cfrac{1}{1 + e^{-x}} \\
& \textit{Hàm ngược: } \ g(x) = ln(\cfrac{x}{1- x})
\end{align}

Với biến phụ thuộc $Y$ là có phân phối nhị thức và hàm $g$ là hàm số ngược của hàm phân phối của biến ngẫu nhiên logistic, chúng ta có mô hình tuyến tính tổng quát như sau:

\begin{align}
 & Y_i \sim \mathcal{B}(\rho_i) \\
 & \rho_i = \cfrac{1}{1 + exp(-(\beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}))} \\
 & ln(\cfrac{\rho_i}{1 - \rho_i}) = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}
(\#eq:logit1)
\end{align}

Đây là mô hình được biết đến rộng rãi với tên gọi là hồi quy logistic và cũng là mô hình thường được sử dụng nhất trong khi biến phụ thuộc là biến nhị phân. Mô hình có ưu điểm là sự dễ hiểu khi diễn giải kết quả:

- $\rho_i$ ngoài ý nghĩa là trung bình của biến ngẫu nhiên $Y_i$ còn có ý nghĩa là xác suất xảy ra sự kiện $Y_i = 1$. 

- Giá trị $\cfrac{\rho_i}{1 - \rho_i}$ được gọi là odds của sự kiện $Y_i = 1$. Mối liên hệ giữa quan sát thứ $i$ của biến độc lập $X_j$ là $x_{i,j}$ và obbs của sự kiện $Y_i = 1$ có thể được diễn giải thông qua hệ số $\beta_j$.

2. Hàm phân phối của biến ngẫu nhiên chuẩn $\mathcal{N}(0,1)$ và hàm ngược của hàm phân phối được cho bởi công thức sau
\begin{align}
 & g^{-1}(x) = \Phi(x) \\
 & g(x) = \Phi^{-1}(x) \\
 & \Phi(x) = \cfrac{1}{\sqrt{2 \pi}} \  \int\limits_{-\infty}^x \ exp(-t^2/2)  \\
\end{align}

Chúng ta có mô hình tuyến tính tổng quát như sau

\begin{align}
& Y_i \sim \mathcal{B}(\rho_i) \\
& \rho_i = \Phi(\beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}) \\
& \Phi^{-1}(\rho_i) = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}
(\#eq:probit1)
\end{align}

Hàm số ngược của biến ngẫu nhiên phân phối chuẩn được gọi là hàm probit do đó mô hình GLM trong trường hợp này còn được biết đến với tên gọi là mô hình probit. 

3. Hàm phân phối của biến ngẫu nhiên Cauchy và hàm ngược của hàm phân phối được cho bởi công thức sau
\begin{align}
& g^{-1}(x) = \cfrac{1}{2} + \cfrac{arctan(x)}{\pi} \\
& g(x) = tan\left( \pi \left( x - \cfrac{1}{2} \right) \right)
(\#eq:cauchy1)
\end{align}

Chúng ta có mô hình tuyến tính tổng quát như sau

\begin{align}
& Y_i \sim \mathcal{B}(\rho_i) \\
& p_i = \cfrac{1}{2} + \cfrac{arctan(\beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p})}{\pi}  \\
& tan\left( \pi \left( \rho_i - \cfrac{1}{2} \right) \right) = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}
(\#eq:cauchy2)
\end{align}

Hàm số ngược của phân phối cauchy còn được gọi là hàm cauchit, do đó mô hình tuyến tính tổng quát trong trường hợp này còn được biết đến với tên là mô hình cauchit.

Hình vẽ dưới đây mô tả hình dạng của ba hàm số kết nối

<img src="10-mo-hinh-tuyen-tinh-tong-quat_files/figure-html/unnamed-chunk-5-1.png" width="1440" />

Mô hình tuyến tính tổng quát trong trường hợp $Y$ là biến nhị phân thường được ước lượng bằng phương pháp tối đa hóa hàm likelihood, hay gọi tắt là phương pháp MLE. Để tránh sự phức tạp không cần thiết chúng tôi sẽ trình bày phần ước lượng mô hình trong phần sau của chương sách. 

Trong R, hàm số `glm()` của thư viện $stat$ được sử dụng để xây dựng mô hình tuyến tính tổng quát. Tham số $family$ trong hàm `glm()` dùng để khai báo phân phối xác suất cho biến phụ thuộc $Y$ và để lựa chọn hàm liên kết phù hợp. Trở lại với ví dụ khi $Y$ là biến nhị phân mô tả khách hàng có hay không lựa chọn các quyền lợi đầy đủ khi tham gia bảo hiểm bổ sung, chúng ra thực hiện xây dựng mô hình như sau


```r
# Phân phối Y là nhị thức và hàm liên kết là hàm logit
glm.binomial.logit<-glm(Y ~ age + sex, data=dat, 
          family = binomial(link = "logit"))

# Phân phối Y là nhị thức và hàm liên kết là hàm probit
glm.binomial.probit<-glm(Y ~ age + sex, data=dat, 
          family = binomial(link = "probit"))

# Phân phối Y là nhị thức và hàm liên kết là hàm cauchit
glm.binomial.cauchy<-glm(Y ~ age + sex, data=dat, 
          family = binomial(link = "cauchit"))
```

Cả ba mô hình tuyến tính tổng quát ở trên đều cho $Y$ là một biến ngẫu nhiên phân phối nhị thức, nhưng mối liên hệ giữa độ tuổi và giới tính đến giá trị trung bình của $Y$ lại được mô tả bằng các công thức khác nhau

1. Trong mô hình logit:
\begin{align}
\mathbb{P}(Y_i = 1| age_i, sex_i) = \cfrac{1}{1 + exp(-(1.109 - 0.026 \times age_{i} - 0.723 \times sex_{i}))}
\end{align}

2. Trong mô hình probit
\begin{align}
\mathbb{P}(Y_i = 1| age_i, sex_i) = \Phi\left(0.678 - 0.016 \times age_{i} - 0.446 \times sex_{i}\right)
\end{align}

3. Trong mô hình cauchit
\begin{align}
\mathbb{P}(Y_i = 1| age_i, sex_i) = \cfrac{1}{2} + \cfrac{arctan\left(0.997 - 0.024 \times age_{i} - 0.624 \times sex_{i}\right)} {\pi}
\end{align}

Cả ba mô hình đều cho cùng một kết quả: người có độ tuổi càng cao thì càng ít có khả năng lựa chọn quyền lợi bảo hiểm bổ sung và xác suất nam giới lựa chọn quyền lợi bảo hiểm bổ sung là ít hơn so với nữ giới. Bảng dưới đây đưa ra khả năng/xác suất chấp nhận của ba mô hình tính dựa trên hai biến độc lập là tuổi và giới tính

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> Người BH </th>
   <th style="text-align:center;"> Độ tuổi </th>
   <th style="text-align:center;"> Giới tính </th>
   <th style="text-align:center;">  Logit  </th>
   <th style="text-align:center;">  Probit  </th>
   <th style="text-align:center;"> Cauchit </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> Nam </td>
   <td style="text-align:center;"> 0.467 </td>
   <td style="text-align:center;"> 0.465 </td>
   <td style="text-align:center;"> 0.466 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:center;"> Nam </td>
   <td style="text-align:center;"> 0.403 </td>
   <td style="text-align:center;"> 0.402 </td>
   <td style="text-align:center;"> 0.394 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 40 </td>
   <td style="text-align:center;"> Nam </td>
   <td style="text-align:center;"> 0.342 </td>
   <td style="text-align:center;"> 0.342 </td>
   <td style="text-align:center;"> 0.331 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> Nam </td>
   <td style="text-align:center;"> 0.286 </td>
   <td style="text-align:center;"> 0.285 </td>
   <td style="text-align:center;"> 0.280 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 60 </td>
   <td style="text-align:center;"> Nam </td>
   <td style="text-align:center;"> 0.236 </td>
   <td style="text-align:center;"> 0.233 </td>
   <td style="text-align:center;"> 0.240 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> Nữ </td>
   <td style="text-align:center;"> 0.643 </td>
   <td style="text-align:center;"> 0.640 </td>
   <td style="text-align:center;"> 0.652 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:center;"> Nữ </td>
   <td style="text-align:center;"> 0.582 </td>
   <td style="text-align:center;"> 0.578 </td>
   <td style="text-align:center;"> 0.586 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 40 </td>
   <td style="text-align:center;"> Nữ </td>
   <td style="text-align:center;"> 0.517 </td>
   <td style="text-align:center;"> 0.515 </td>
   <td style="text-align:center;"> 0.512 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> Nữ </td>
   <td style="text-align:center;"> 0.452 </td>
   <td style="text-align:center;"> 0.451 </td>
   <td style="text-align:center;"> 0.436 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 60 </td>
   <td style="text-align:center;"> Nữ </td>
   <td style="text-align:center;"> 0.389 </td>
   <td style="text-align:center;"> 0.389 </td>
   <td style="text-align:center;"> 0.367 </td>
  </tr>
</tbody>
</table>

Có thể thấy rằng không có sự khác biệt lớn trong tính toán xác suất của $Y$ khi sử dụng hàm liên kết khác nhau. Thực tế thì việc lựa chọn hàm kết nối sẽ không ảnh hưởng lớn đến kết quả của mô hình bằng việc lựa chọn phân phối cho biến phụ thuộc hay việc lựa chọn biến độc lập để giải thích mô hình. 

### Biến phụ thuộc là biến rời rạc không có thứ tự.
Biến rời rạc không có thứ tự, hay còn gọi là biến rời rạc danh nghĩa (non-ordinal variable), là biến ngẫu nhiên mà các giá trị có thể nhận không có ý nghĩa so sánh với nhau. Khi nói đến biến rời rạc không có thứ tự, chúng ta luôn hiểu rằng biến nhận từ ba giá trị trở lên bởi vì trường hợp có hai giá trị sẽ tương tự như biến có phân phối nhị phân. Một ví dụ đơn giản cho biến rời rạc không có thứ tự là màu sắc được chọn khi mua xe ô tô, hoặc loại hình bảo hiểm được lựa chọn bởi các khách hàng của một công ty bảo hiểm.

Giả sử biến rời rạc danh nghĩa $Y$ có thể nhận $J$ giá trị khác nhau lần lượt là $1, 2, \cdots, J$. Với biến danh nghĩa, chúng ta không thể mô tả được mối liên hệ giữa xác suất của hai sự kiện $(Y=i)$ và $(Y=j)$ với $1 \leq i < j \leq J$ dưới dạng tham số. Chính vì thế cấu trúc dạng tham số của mô hình tuyến tính tổng quát như phương trình \@ref(eq:glm1) là không thể áp dụng được.

Một phương pháp tiếp cận cho trường hợp biến mục tiêu $Y$ là biến danh nghĩa là mở rộng mô hình tuyến tính tổng quát với biến nhị phân: với mỗi $j \in {1,2,\cdots,J}$

\begin{align}
\mathbb{P}\left(Y = j\right|\textbf{x}_i) = \cfrac{h(\beta_{j,0} + \beta_{j,1} \cdot x_{i,1} + \cdots + \beta_{j,p} \cdot x_{i,p} ) }{ \sum\limits_{j=1}^J h(\beta_{j,0} + \beta_{j,1} \cdot x_{i,1} + \cdots + \beta_{j,p} \cdot x_{i,p} ) }
(\#eq:sm)
\end{align}

với hàm $h$: $\mathbb{R} \rightarrow \mathbb{R}^+$. Hàm số $h$ thường được lựa chọn là hàm lũy thừa cơ số tự nhiên `exp()`. Hàm số xác định xác suất xảy ra các sự kiện $(Y=j)$ trong phương trình \@ref(eq:sm) được gọi là hàm $softmax$:
\begin{align}
softmax(z_1, z_2, \cdots, z_p) = \left(\cfrac{e^{z_1}}{\sum\limits_{j=1}^p e^{z_j}}, \cfrac{e^{z_2}}{\sum\limits_{j=1}^p e^{z_1}}, \cdots, \cfrac{e^{z_p}}{\sum\limits_{i=1}^p e^{z_j}}  \right)
\end{align}

Các tham số $\beta_{j,k}$ được ước lượng để tối thiểu hóa hàm tổn thất tính bằng cross-entropy:
\begin{align}
\sum\limits_{i=1}^n \sum\limits_{j=1}^J y_{i,j} \cdot \log\left(\mathbb{P}\left(Y = j|\textbf{x}_i\right)\right)
\end{align}

trong đó $\mathbb{P}\left(Y = j|\textbf{x}_i\right)$ được tính toán từ công thức \@ref(eq:sm) và $y_{i,j}$ nhận một trong hai giá trị:

- bằng 1 nếu giá trị quan sát thứ $i$ của biến mục tiêu $Y$ bằng $j$

- bằng 0 nếu giá trị quan sát thứ $i$ của biến mục tiêu $Y$ khác $j$

Lưu ý rằng có $J$ véc-tơ hệ số tuyến tính trong phương trình \@ref(eq:sm). Trong thực tế, khi biến mục tiêu $Y$ có thể nhận $J$ giá trị danh nghĩa, chúng ta xây dựng mô hình với $(J-1)$ véc-tơ hệ số tuyến tính tương ứng với các giá trị danh nghĩa $1, 2, \cdots, (J-1)$, đồng thời cố định giá trị của tất cả các hệ số tuyến tính bằng 0 với giá trị danh nghĩa $J$. Khi tất cả các hệ số tuyến tính bằng 0, chúng ta có $h(.) = exp(0) = 1$ với mọi $\textbf{x}_i$.

\begin{align}
& \mathbb{P}\left(Y = j\right|x_i) = \cfrac{h(\beta_{j,0} + \beta_{j,1} \cdot x_{i,1} + \cdots + \beta_{j,p} \cdot x_{i,p} ) }{1 + \sum\limits_{j=1}^{J-1} h(\beta_{j,0} + \beta_{j,1} \cdot x_{i,1} + \cdots + \beta_{j,p} \cdot x_{i,p} )} \textit{ với } j < J \\
& \mathbb{P}\left(Y = J\right|x_i) = \cfrac{1}{1 + \sum\limits_{j=1}^{J-1} h(\beta_{j,0} + \beta_{j,1} \cdot x_{i,1} + \cdots + \beta_{j,p} \cdot x_{i,p} )} \\
(\#eq:sm1)
\end{align}

Chúng ta sẽ xây dựng mô hình phân loại biến mục tiêu trên dữ liệu "travel insurance.csv". Dữ liệu cung cấp thông tin về các sản phẩm bảo hiểm du lịch từ một đại lý du lịch, với biến mục tiêu là $product.name$ cho biết khách hàng đã lựa chọn sản phẩm sản phẩm bảo hiểm nào. Biến mục tiêu có bốn giá trị tương ứng với bốn loại sản phẩm, mặc dù các sản phẩm này có mức giá khác nhau nhưng việc so sánh các giá trị là không có ý nghĩa. Dữ liệu có 10 biến độc lập, tuy nhiên, để đơn giản hóa, chúng ta chỉ lấy hai biến là giới tính và độ tuổi của người tham gia bảo hiểm.



Mối liên hệ giữa độ tuổi và giới tính của khách hàng đến sản phẩm khách hàng lựa chọn được mô tả qua hình vẽ dưới đây

<img src="10-mo-hinh-tuyen-tinh-tong-quat_files/figure-html/unnamed-chunk-9-1.png" width="1152" />

Có thể thấy rằng có sự khác biệt về độ tuổi của những người lựa chọn các sản phẩm bảo hiểm: những người trẻ tuổi có xu hướng lựa chọn "Bronze Plan" và "Silver Plan" trong khi những người lớn tuổi có xu hướng lựa chọn "Basic Plan" và "Value Plan". Có sự khác biệt về tỷ lệ nam và nữ khi lựa chọn sản phẩ bảo hiểm, tỷ lệ nam giới lựa chọn "Basic Plan" và "Value Plan" cao, trong khi nữ giới có xu hướng lựa chọn "Bronze Plan" và "Silver Plan".

Để xây dựng mô hình tuyến tính tổng quát cho biến phân loại danh nghĩa, chúng ta sử dụng hàm `multinom()` từ thư viện `nnet`:


```
## # weights:  16 (9 variable)
## initial  value 19625.769270 
## iter  10 value 18535.510505
## final  value 18040.676017 
## converged
```

```
## Call:
## multinom(formula = Product.Name ~ Gender + Age, data = dat1)
## 
## Coefficients:
##             (Intercept)    GenderM          Age
## Bronze Plan   1.5631988 -0.5589519 -0.039513361
## Silver Plan   0.6512458 -0.4871457 -0.031596816
## Value Plan   -1.0970424  0.3380718  0.002018711
## 
## Std. Errors:
##             (Intercept)    GenderM         Age
## Bronze Plan  0.07047991 0.04302279 0.001653049
## Silver Plan  0.08280363 0.05117056 0.001938850
## Value Plan   0.08264747 0.05092679 0.001676413
## 
## Residual Deviance: 36081.35 
## AIC: 36099.35
```

Dựa trên kết quả ước lượng, chúng ta có công thức tính xác suất chấp nhận các sản phẩm bảo hiểm du lịch của một người có giới tính là $g_i$ và độ tuổi $a_i$ như sau: với sản phẩm "Basic Plan"
\begin{align}
\mathbb{P}(Y = Basic|g_i, a_i) = \cfrac{1}{S_0}
\end{align}
với
\begin{align}
S_0 = 1 + exp(1.512 - 0.558 \cdot g_i - 0.038 \cdot a_i) + exp(0.563 - 0.489 \cdot g_i - 0.030 \cdot a_i) +  exp(-3.028 - 0.246 \cdot g_i - 0.039 \cdot a_i)
\end{align}
Với các sản phẩm Bronze Plan, Silver Plan và Value Plan, ta có
\begin{align}
& \mathbb{P}(Y = Bronze|g_i, a_i) = \cfrac{exp(1.512 - 0.558 \cdot g_i - 0.038 \cdot a_i)}{S_0} \\
& \mathbb{P}(Y = Silver|g_i, a_i) = \cfrac{exp(0.563 - 0.489 \cdot g_i - 0.030 \cdot a_i)}{S_0} \\
& \mathbb{P}(Y = Value|g_i, a_i) = \cfrac{exp(-3.028 - 0.246 \cdot g_i - 0.039 \cdot a_i)}{S_0}
\end{align}

Bảng dưới đây tính toán xác suất chấp nhận các sản phẩm du lịch theo một vài độ tuổi và giới tính
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> Khách hàng </th>
   <th style="text-align:center;"> Độ tuổi </th>
   <th style="text-align:center;"> Giới tính </th>
   <th style="text-align:center;"> Bronze Plan </th>
   <th style="text-align:center;"> Silver Plan </th>
   <th style="text-align:center;"> Value Plan </th>
   <th style="text-align:center;"> Basic Plan </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 1 </td>
   <td style="text-align:center;border-left:1px solid;"> Nữ </td>
   <td style="text-align:center;border-left:1px solid;"> 10 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.54 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.23 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.06 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.17 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 2 </td>
   <td style="text-align:center;border-left:1px solid;"> Nữ </td>
   <td style="text-align:center;border-left:1px solid;"> 20 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.48 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.22 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.08 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 3 </td>
   <td style="text-align:center;border-left:1px solid;"> Nữ </td>
   <td style="text-align:center;border-left:1px solid;"> 30 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.41 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.21 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.10 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.28 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> Nữ </td>
   <td style="text-align:center;border-left:1px solid;"> 40 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.34 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.19 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.13 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.35 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 5 </td>
   <td style="text-align:center;border-left:1px solid;"> Nữ </td>
   <td style="text-align:center;border-left:1px solid;"> 50 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.27 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.16 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.15 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.41 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 6 </td>
   <td style="text-align:center;border-left:1px solid;"> Nữ </td>
   <td style="text-align:center;border-left:1px solid;"> 60 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.21 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.14 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.18 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.47 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 7 </td>
   <td style="text-align:center;border-left:1px solid;"> Nam </td>
   <td style="text-align:center;border-left:1px solid;"> 10 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.44 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.21 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.11 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.24 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> Nam </td>
   <td style="text-align:center;border-left:1px solid;"> 20 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.37 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.19 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.15 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.30 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 9 </td>
   <td style="text-align:center;border-left:1px solid;"> Nam </td>
   <td style="text-align:center;border-left:1px solid;"> 30 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.30 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.16 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.18 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.36 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 10 </td>
   <td style="text-align:center;border-left:1px solid;"> Nam </td>
   <td style="text-align:center;border-left:1px solid;"> 40 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.23 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.14 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.21 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.42 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 11 </td>
   <td style="text-align:center;border-left:1px solid;"> Nam </td>
   <td style="text-align:center;border-left:1px solid;"> 50 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.18 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.11 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.24 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.47 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 12 </td>
   <td style="text-align:center;border-left:1px solid;"> Nam </td>
   <td style="text-align:center;border-left:1px solid;"> 60 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.13 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.09 </td>
   <td style="text-align:center;border-left:1px solid;"> 0.27 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 0.51 </td>
  </tr>
</tbody>
</table>

Kết quả từ mô hình cho thấy chỉ có "Basic Plan" và "Bronze Plan" được chọn nếu chúng ta chỉ sử dụng hai biến độc lập là giới tính và độ tuổi. Khả năng dự đoán của mô hình không cao do mô hình còn quá đơn giản, chúng tôi muốn nhấn mạnh về cách xây dựng mô hình trước khi cố gắng xây dựng một mô hình có khả năng dự báo tốt. Chúng ta sẽ thảo luận về đánh giá hiệu quả của mô hình ở các phần sau của chương sách.

### Biến phụ thuộc là biến rời rạc có thứ tự.
Biến rời rạc có thứ tự, còn gọi là ordinal categorical variable, là các biến nhận giá trị rời rạc mà các giá trị rời rạc có thể so sánh được với nhau. Một ví dụ điển hình cho biến rời rạc có thứ tự là số lần mà một người đi khám chữa bệnh sử dụng bảo hiểm y tế hoặc một khách hàng gửi yêu cầu bồi thường đến công ty bảo hiểm. Đây là trường hợp mà chúng ta có thể sử dụng một phân phối xác suất rời rạc có tham số để mô tả biến phụ thuộc $Y$ giống như mô hình \@ref(eq:gml1).

#### Biến phụ thuộc có phân phối Poisson.

Phân phối rời rạc thường được lựa chọn cho biến phụ thuộc rời rạc có thứ tự là phân phối Poisson. Hàm phân phối xác suất của biến ngẫu nhiên $Y$ có phân phối Poisson với tham số $\lambda > 0$, ký hiệu $Y \sim \mathcal{P}(\lambda)$ được cho bởi công thức sau
\begin{align}
\mathbb{P}(Y = y) = e^{-\lambda} \cdot \cfrac{\lambda^y}{y!} \text{ với } y = 0, 1, 2, \cdots 
\end{align}

Phân phối Poisson thường được sử dụng để mô tả số lần một hiện tượng xảy ra trong một khoảng thời gian nhất định. Nguyên nhân là do phân phối Poisson này có mối liên hệ trực tiếp đến các mô hình có thời gian chờ có phân phối kiểu mũ. Thật vậy, nếu thời gian chờ giữa hai sự kiện liên tiếp xảy ra của một hiện tượng nào đó là một biến ngẫu nhiên liên tục có hàm phân phối xác suất kiểu mũ với tham số $\gamma$ thì số lần hiện tượng đó xảy ra trong một khoảng thời gian từ $t_1$ đến $t_2$ sẽ là một biến ngẫu nhiên phân phối Poisson với tham số $\lambda = \cfrac{(t_1 - t_2)}{\gamma}$. Thật vậy, với $T$ là khoảng thời gian giữa 2 sự kiện liên tiếp xảy ra và $T$ có phân phối mũ:
\begin{align}
\mathbb{P}(T \leq x) = 1 - exp(-\gamma x)
\end{align}
và nếu $N$ là số lần xảy ra sự kiện (đi khám bệnh, lái xe gây ra tai nạn) giữa hai mốc thời gian $t_1 < t_2$ thì $N$ sẽ có phân phối Poisson với tham số $\lambda$:
\begin{align}
& \mathbb{P}(N = k) = e^{-\lambda} \cdot \cfrac{\lambda^k}{k!}\\
& \lambda = \cfrac{(t_1 - t_2)}{\gamma} 
\end{align}

Biến ngẫu nhiên có phân phối Poisson với tham số $\lambda$, ký hiệu $\mathcal{P}(\lambda)$, có tính chất là giá trị trung bình và phương sai đều bằng tham số của biến đó là $\lambda$. Phân phối Poisson nằm trong họ các phân phối mũ nên sẽ rất thuận tiện trong xây dựng và ước lượng mô hình bằng phương pháp hợp lý tối đa. Ngoài ra, bằng cách cho tham số của phân phối Poisson một phân phối xác suất, chúng ta có thể thu được các phân phối rời rạc linh hoạt hơn trong mô tả các biến ngẫu nhiên dạng đếm được.

Khi xây dựng mô hình tuyến tính với biến mục tiêu $Y$ có phân phối Poisson, giá trị trung bình $Y$ nhận giá trị dương nên chúng ta cần chọn các hàm liên kết $g$ có miền xác định là tập các số thực dương $\mathbb{R}^+$ và miền giá trị là tập số thực $\mathbb{R}$. Hàm số thường được lựa chọn là hàm $log$.

Chúng ta có thể viết mô hình tuyến tính tổng quát khi $Y$ có phân phối Poisson, thường được gọi tắt là hồi quy Poisson, như sau

\begin{align}
& Y_i \sim \mathcal{P}(\lambda_i) \\
& log(\lambda_i) = \left(\beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,p}\right) \\
(\#eq:pois1)
\end{align}

Dữ liệu được sử dụng để mô tả mô hình tuyến tính tổng quát với biến phụ thuộc phân phối Poisson là dữ liệu $SingaporeAuto.csv$. Dữ liệu được tổng hợp bởi Hiệp hội bảo hiểm Singapore trong năm 1993 mô tả số vụ tai nạn ô tô xảy ra cùng với các đặc điểm của người lái và đặc điểm của xe gây tai nạn. Cũng giống như các phần trước, chúng ta sẽ xây dựng mô hình ở mức độ đơn giản nhất để bạn đọc dễ dàng hình dung. Biến phụ thuộc trong mô hình là biến $Clm\_Count$ cho biết số vụ tai nạn mà một lái xe gây ra trong vòng một năm, hai biến phụ thuộc bao gồm có:

- Biến $PC$ là biến nhận hai giá trị là 0 tương ứng với xe được đăng ký theo công ty và nhận giá trị 1 tương ứng với xe được đăng ký theo cá nhân.

- Biến $NCD$, viết tắt của No Claims Discount, cho biết lịch sử gây ra tai nạn của lái xe. Giá trị $NCD$ càng cao nghĩa là lịch sử người lái xe càng gây ra ít tai nạn.

Chúng ta sử dụng hàm `glm()` để xây dựng và ước lượng mô hình tuyến tính tổng quát:


```r
dat<-read.csv("../KHDL_KTKD Final/Dataset/SingaporeAuto.csv")
glm2<-glm(Clm_Count~PC+NCD, data=dat, family = poisson(link = "log"))
summary(glm2)
```

```
## 
## Call:
## glm(formula = Clm_Count ~ PC + NCD, family = poisson(link = "log"), 
##     data = dat)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.4685  -0.3801  -0.3520  -0.3283   4.1716  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -2.641681   0.073836 -35.778  < 2e-16 ***
## PC           0.431980   0.091840   4.704 2.56e-06 ***
## NCD         -0.013943   0.002618  -5.327 9.99e-08 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for poisson family taken to be 1)
## 
##     Null deviance: 2887.2  on 7482  degrees of freedom
## Residual deviance: 2848.3  on 7480  degrees of freedom
## AIC: 3849.4
## 
## Number of Fisher Scoring iterations: 6
```

Bạn đọc có thể thấy rằng cả hai biến $PC$ và $NCD$ đều có tác động đến giá trị trung bình của biến mục tiêu $Clm\_Count$ do các giá trị p-value đều nhỏ. Mối liên hệ giữa số lượng tai nạn xảy ra và các biến $PC$ và $NCD$ được mô tả như sau:

\begin{align}
& Clm\_Count_i \sim \mathcal{P}(\lambda_i) \\
& \log(\lambda_i) = -2.641 + 0.432 \cdot PC_{i} - 0.013 \cdot NCD_{i} \\
& \lambda_i = \exp\left(-2.641 + 0.432 \cdot PC_{i} - 0.013 \cdot NCD_{i} \right)
(\#eq:pois2)
\end{align}

Hệ số của biến $PC$ là số dương, điều này cho biết các xe đăng ký dưới dạng cá nhân có khả năng gây tai nạn cao hơn so với xe đăng ký dưới hình thức doanh nghiệp. Đồng thời, hệ số của biến $NCD$ âm cho biết lái xe có lịch sử lái xe tốt, tương ứng với $NCD$ cao, ít có khả năng gây ra tai nạn hơn lái xe có lịch sử lái xe không tốt, tương ứng với $NCD$ thấp.

#### Phân phối rời rạc có lạm phát tại giá trị 0.
Biến phụ thuộc dạng đếm chứa một tỷ lệ lớn giá trị bằng 0 là các kiểu biến phụ thuộc thường gặp phải khi làm việc trên dữ liệu trong lĩnh vực bảo hiểm. Tỷ lệ lớn ở đây thường được hiểu là trên 90\% giá trị quan sát được. Đa số các phân phối xác suất rời rạc thông thường, bao gồm phân phối Poisson, không mô tả tốt khi biến phụ thuộc $Y$ trong trường hợp này. 

Một giải pháp phổ biến khi làm việc với kiểu dữ liệu như vậy là thay đổi phân phối dạng đếm thông thường để làm tăng tỷ lệ giá trị nhận được tại 0, để thu được các phân phối thường được gọi là các phân phối lạm phát tại 0, hay Zero-inflated variable. Phân phối lạm phát tại 0 là hỗn hợp của hai phân phối xác suất rời rạc, bao gồm một phân phối nhị thức chỉ báo cho trường hợp 0, và một phân phối xác suất dành cho biến đếm thông thường. Hàm phân phối của biến ngẫu nhiên dạng đếm có lạm phát tại 0, ký hiệu $ZI_Y$, có thể được mô tả như sau
\begin{align}
\mathbb{P}(ZI_Y = y) = \begin{cases}
& \omega + (1-\omega) \cdot \mathbb{P}(Y=0) \text{ khi y = 0} \\
& (1-\omega) \cdot \mathbb{P}(Y=y) \text{ khi y > 0}
\end{cases}
(\#eq:zip1)
\end{align}
trong đó biến ngẫu nhiên $Y$ tuân theo phân phối số đếm tiêu chuẩn được. Trong trường hợp tham số $\omega$ bằng 0, phân phối của biến ngẫu nhiên $ZI_Y$ sẽ tương ứng tương ứng với phân phối của biến Y. 

Tất cả các phân phối kiểu đếm đều có thể được sử dụng để tạo ra các biến mới có lạm phát tại 0. Trong các mô hình tuyến tính tổng quát, biến dạng đếm thường được mô tả bằng phân phối cổ điển Poisson. Với việc sử dụng phương trình \@ref(eq:zip1), hàm phân phối của biến ngẫu nhiên Poisson có lạm phát tại 0, ký hiệu là $ZI_\mathcal{P}$ được cho bởi công thức sau:

\begin{align}
\mathbb{P}(ZI_\mathcal{P} = y) = \begin{cases}
& \omega + (1-\omega) \cdot e^{-\lambda} \text{ khi y = 0} \\
& (1-\omega) \cdot e^{-\omega} \cdot \cfrac{\lambda^y}{y!} \text{ khi y > 0}
\end{cases}
(\#eq:zip2)
\end{align}

Chúng ta có thể xác định giá trị trung bình và phương sai của phân phối $ZI_Y$ dựa trên tham số $\omega$ và giá trị trung bình cũng như phương sai của biến $Y$ như sau
\begin{align}
& \mathbb{E}(ZI_Y) = (1-\omega) \cdot \mathbb{E}(Y) \\
& \mathbb{V}(ZI_Y) = (1-\omega) \cdot \mathbb{V}(Y) + \omega(1-\omega) \cdot \mathbb{E}(Y)^2
(\#eq:zip3)
\end{align}

Trong trường hợp $Y$ có phân phối Poission, chúng ta có giá trị trung bình và phương sai của biến $ZI_\mathcal{P}$:
\begin{align}
& \mathbb{E}(ZI_\mathcal{P}) = (1-\omega) \cdot \lambda \\
& \mathbb{V}(ZI_\mathcal{P}) = \mathbb{E}(ZI_\mathcal{P}) \cdot (1 + \lambda - \mathbb{E}(ZI_\mathcal{P}))
(\#eq:zip4)
\end{align}

Với giá trị trung bình và phương sai của biến $ZI_\mathcal{P}$ như phương trình \@ref(eq:zip1), chúng ta có thể xây dựng mô hình tuyến tính tổng quát với biến phụ thuộc là $ZI_\mathcal{P}$ như sau: giá trị trung bình $\left((1-\omega) \cdot \lambda\right)$ sẽ được giải thích thông qua các biến phụ thuộc trong khi tham số $\lambda$ sẽ được ước lượng bằng phương pháp hợp lý tối đa. 

Biến phụ thuộc phân phối $ZI_\mathcal{P}$ sẽ hữu ích cho mục đích lập mô hình trong trường hợp dữ liệu quan sát có sự tập trung quá mức tại giá trị 0. Ngoài phân phối Poisson, các phân phối mở rộng từ phân phối Poisson cũng có thể được sử dụng với để tạo ra các phân phối có lạm phát tại 0, chẳng hạn như biến ngẫu nhiên phân phối Poisson - Gamma, Poisson - Inverse gaussian.

Trong các nghiên cứu thực nghiệm, nhiều tác giả đã chứng minh rằng việc áp dụng phân phối có lạm phát tại 0 để mô hình hóa số lượng yêu cầu bồi thường bảo hiểm là phù hợp để mô tả hành vi của người được bảo hiểm. Thật vậy, trong ngành bảo hiểm không phải tất cả các vụ tai nạn đều được báo cáo, công ty bảo hiểm chỉ có thông tin về các yêu cầu bồi thường được báo cáo. Có hai cách để giải thích cách phân phối có lạm phát tại 0 như sau: (1) Một số người được bảo hiểm không gửi yêu cầu bồi thường dù có xảy ra sự kiện bảo hiểm, do họ không có nhận thức được về việc được bảo hiểm, hoặc không có nhu cầu gửi yêu cầu bảo hiểm. (2) Một cách giải thích khác của mô hình lạm phát tại 0 là xem xét xác suất của mỗi vụ tai nạn được báo cáo. Một hành vi thực tế của người được bảo hiểm là nếu họ đã báo cáo vụ tai nạn đầu tiên thì những vụ tai nạn tiếp theo cũng sẽ được báo cáo, còn nếu vụ tai nạn đầu tiên không được báo cáo thì các vụ tai nạn sau sẽ không được báo cáo. Cả hai cách giải thích dựa trên hành vi này đều dẫn đến việc số lượng biến mục tiêu nhận giá trị bằng 0 cao hơn so với số lượng tai nạn thực tế xảy ra.

Dữ liệu $exposure.csv$ là dữ liệu điển hình cho biến phụ thuộc có lạm phát tại giá trị 0. Dữ liệu được rút gọn chỉ bao gồm hai biến độc lập là tuổi (Age) và giới tính (Gender) của người được bảo hiểm. Biến phụ thuộc là số lần người được bảo hiểm báo cáo tai nạn trong khoảng thời gian một năm. Sự khác nhau giữa mô hình tuyến tính tổng quát với biến phụ thuộc có phân phối Poisson thông thường và mô hình tuyến tính tổng quát với biến phụ thuộc có phân phối Poisson có lạm phát tại 0 được mô tả như sau:
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-13)Khác nhau giữa GLM - Poisson và GLM - ZIP</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Thành phần </th>
   <th style="text-align:left;"> GLM Poisson </th>
   <th style="text-align:left;"> GLM Poisson Zero-inflated </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Phân phối của biến phụ thuộc </td>
   <td style="text-align:left;"> $Y_i \sim \mathcal{P}(\lambda_i)$ </td>
   <td style="text-align:left;"> $Y_i \sim ZI_\mathcal{P}(\lambda_i, \omega)$ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Trung bình của biến phụ thuộc </td>
   <td style="text-align:left;"> $\lambda_i$ </td>
   <td style="text-align:left;"> $\lambda_i \cdot (1-\omega)$ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tham số của biến Poisson </td>
   <td style="text-align:left;"> $\lambda_i = exp(\beta_0 + \beta_1 \cdot Age_i + \beta_2 \cdot Gender_i)$ </td>
   <td style="text-align:left;"> $\lambda_i = exp(\beta_0 + \beta_1 \cdot Age_i + \beta_2 \cdot Gender_i)$ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tham số Zero-inflated </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> $\omega = exp(\alpha_0)$ </td>
  </tr>
</tbody>
</table>

Để xây dựng mô hình tuyến tính tổng quát trong đó biến phụ thuộc có phân phối $ZI_\mathcal{P}$ chúng ta sử dụng hàm số `zeroinfl()` của thư viện $pscl$.


```r
dat<-read.csv("../KHDL_KTKD Final/Dataset/exposure.csv")
# Biến phụ thuộc có phân phối Poisson
glm1<-glm(Claim_Count~Age+Gender,
          family = poisson(link = "log"),
          data=dat)

# Biến phụ thuộc có phân phối Zero inflated poisson
zip.glm<-zeroinfl(Claim_Count~Age+Gender|1,
                  dist = 'poisson',
                  link = "log",
                  data = dat)
summary(glm1)
summary(zip.glm)
```

Chúng ta có kết quả ước lượng các mô hình

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-15)Kết quả ước lượng GLM - Poisson và GLM - ZIP</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Thành phần </th>
   <th style="text-align:left;"> GLM Poisson </th>
   <th style="text-align:left;"> GLM Poisson Zero-inflated </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Phân phối của biến phụ thuộc </td>
   <td style="text-align:left;"> $Y_i \sim \mathcal{P}(\lambda_i)$ </td>
   <td style="text-align:left;"> $Y_i \sim ZI_\mathcal{P}(\lambda_i, \theta)$ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Trung bình của biến phụ thuộc </td>
   <td style="text-align:left;"> $\lambda_i$ </td>
   <td style="text-align:left;"> $\lambda_i \cdot (1-\theta)$ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tham số của biến Poisson </td>
   <td style="text-align:left;"> $\lambda_i = exp(-0.544 - 0.0214 \cdot Age + 0.106 \cdot Gender)$ </td>
   <td style="text-align:left;"> $\lambda_i = exp(-0.063 - 0.0215 \cdot Age + 0.104 \cdot Gender)$ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tham số Zero-inflated </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> $\theta = exp(-0.971)$ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Giá trị Log Likelyhood </td>
   <td style="text-align:left;"> -6419 </td>
   <td style="text-align:left;"> -6353 </td>
  </tr>
</tbody>
</table>

Có thể thấy rằng mô hình tuyến tính tổng quát với biến phụ thuộc phân phối $ZI_\mathcal{P}$ có giá trị hàm hợp lý tối đa lớn hơn, điều này cũng có nghĩa là phân phối $ZI_\mathcal{P}$ phù hợp hơn phân phối Poisson thông thường khi mô tả biến phụ thuộc trong dữ liệu. Dựa vào kết quả ước lượng từ hai mô hình, chúng ta có thể tính toán xác suất không có tai nạn và xác suất để xảy ra một tai nạn theo độ tuổi và giới tính của người tham gia bảo hiểm như sau

<img src="10-mo-hinh-tuyen-tinh-tong-quat_files/figure-html/unnamed-chunk-16-1.png" width="1152" style="display: block; margin: auto;" />

<img src="10-mo-hinh-tuyen-tinh-tong-quat_files/figure-html/unnamed-chunk-17-1.png" width="1152" style="display: block; margin: auto;" />

Có thể nhận thấy rằng xác suất mà một người được bảo hiểm không để xảy ra tai nạn trong mô hình tuyến tính tổng quát với biến phụ thuộc có phân phối $ZI_\mathcal{P}$ là luôn cao hơn so với mô hình tuyến tính tổng quát với biến phụ thuộc có phân phối Poisson thông thường. Đồng thời, mô hình tuyến tính tổng quát với biến phụ thuộc có phân phối $ZI_\mathcal{P}$ cho kết quả xác suất xảy ra đúng một tai nạn thấp hơn so với mô hình có biến phụ thuộc có phân phối Poisson thông thường.

### Biến phụ thuộc có phân phối liên tục.

Một giả thiết quan trọng của mô hình tuyến tính tổng quát là biến phụ thuộc nằm trong họ các biến ngẫu nhiên có phân phối kiểu mũ, hay exponential family. Chúng ta sẽ thảo luận kỹ hơn về họ các biến ngẫu nhiên có phân phối kiểu mũ trong phần sau của cuốn sách. Lưu ý rằng họ các biến ngẫu nhiên có phân phối kiểu mũ không tương đồng với khái niệm biến ngẫu nhiên có phân phối mũ. Phân phối mũ chỉ là mộ trường hợp đặc biệt của phân phối kiển mũ. Có nhiều biến ngẫu nhiên liên tục khác có phân phối nằm trong họ các phân phối kiểu mũ. Có thể kể đến như phân phối gamma, phân phối chuẩn, phân phối chuẩn ngược...

Các bước để xây dựng mô hình tuyến tính tổng quát trong trường hợp biến phụ thuộc $Y$ là biến ngẫu nhiên liên tục hoàn toàn tương tự như cách xây dựng mô hình tuyến tính tổng quát ở trên, bao gồm bước chọn phân phối xác suất cho biến mục tiêu và lựa chọn hàm liên kết phù hợp. Chúng ta sẽ tiếp tục xây dựng mô hình với dữ liệu "exposure.csv" đã đề cập ở các phần trên. Biến mục tiêu không còn là số lần khách hàng gửi yêu cầu bồi thường, mà là số tiền trung bình mỗi lần khách hàng gửi yêu cầu (biến $Ave\_Amount$). Các biến giải thích vẫn tiếp tục là giới tính ($Gender$) và độ tuổi ($Age$) của người được bảo hiểm.


```r
dat<-read.csv("../KHDL_KTKD Final/Dataset/exposure.csv")
dat<-mutate(dat,Ave_Amount = ifelse(Claim_Count>0,Total_Claim/Claim_Count,0))
dat1<-filter(dat,Claim_Count>0)
```

Mối liên hệ giữa $Ave\_Amount$ được thể hiện qua đồ thị dưới đây

```r
dat1$Gender<-ifelse(dat1$Gender==0,"F","M")
p1<-dat1%>%ggplot()+geom_boxplot(aes(Gender,y = Ave_Amount))+
  ylim(0,200)+ggtitle("Số tiền yêu cầu bồi thường trung bình và giới tính")
p2<-dat1%>%ggplot(aes(x=Age,y = Ave_Amount))+geom_point(alpha=0.2)+
  geom_smooth(col="black", size = 1, se = FALSE)+ylim(0,200)+
  ggtitle("Số tiền yêu cầu bồi thường trung bình và độ tuổi")
grid.arrange(p1,p2,ncol=2)
```

<img src="10-mo-hinh-tuyen-tinh-tong-quat_files/figure-html/unnamed-chunk-19-1.png" width="672" />

Đồ thị bên trái cho thấy số tiền yêu cầu bồi thường trung bình của nữ là cao hơn nam giới. Phân phối xác suất của số tiền yêu cầu bồi thương trung bình là phân phối liên tục lệch phải, có đuôi bên phải lớn. Đồ thị bên phải cho thấy số tiền yêu cầu bồi thường trung bình có xu hướng tăng theo độ tuổi.

Số tiền bảo hiểm trung bình là số dương nên chúng ta sẽ sử dụng phân phối $gamma$ với hàm liên kết là hàm `log()`. Lưu ý rằng phân phối `gamma()` là phân phối có hai tham số, thường được ký hiệu là $\alpha$ và $\gamma$, với hàm mật độ xác suất, giá trị trung bình, và phương sai như sau
\begin{align}
& f_Y(y) = \cfrac{\beta^\alpha}{\Gamma(\alpha)} \ y^{\alpha-1} \ e^{-\gamma y} \\
& \mathbb{E}(X) = \cfrac{\alpha}{\gamma} \\
& \mathbb{V}(X) = \cfrac{\alpha}{\gamma^2} 
\end{align}

Khi phân phối $gamma$ được sử dụng cho biến phụ thuộc, giá trị trung bình được tính bằng $\alpha/\gamma$, sẽ được mô tả thông qua các biến độc lập trong khi tham số $\alpha$ sẽ được ước lượng dựa trên hàm hợp lý tối đa:


```r
dat<-read.csv("../KHDL_KTKD Final/Dataset/exposure.csv")
dat<-mutate(dat,Ave_Amount = ifelse(Claim_Count>0,Total_Claim/Claim_Count,0))
dat1<-filter(dat,Claim_Count>0)
glm3<-glm(Ave_Amount~Age+Gender, family = Gamma(link = "log"),data = dat1)
summary(glm3)
```

```
## 
## Call:
## glm(formula = Ave_Amount ~ Age + Gender, family = Gamma(link = "log"), 
##     data = dat1)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -4.3309  -0.9498  -0.3047   0.3360   2.9954  
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -0.047535   0.065517  -0.726    0.468    
## Age          0.079089   0.001534  51.563   <2e-16 ***
## Gender      -0.534010   0.041951 -12.730   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for Gamma family taken to be 0.9241118)
## 
##     Null deviance: 4666.5  on 2110  degrees of freedom
## Residual deviance: 2205.7  on 2108  degrees of freedom
## AIC: 15710
## 
## Number of Fisher Scoring iterations: 6
```

Ngoài các hệ số của các biến độc lập trong mô hình tuyến tính tổng quát, hàm `glm()` còn cung cấp giá trị ước lượng được cho tham số $\phi$ (disperson paramter hay tham số phân tán) là $0.924$. Tham số phân tán được định nghĩa trong họ các phân phối kiểu mũ sẽ được thảo luận trong phần tiếp theo. Đối với phân phối $gamma$, tham số phân tán được tính bằng $\phi = 1/\alpha$. 

Giá trị số tiền bồi thường trung bình được được mô tả bằng mô hình tuyến tính tổng quát như sau:
\begin{align}
& Y_i \sim Gamma(\mu_i = \alpha_i/\gamma_i , \phi_i = 1/\alpha_i) \\
& \phi_i = 0.924 \\
& log(\mu_i) = -0.0475 + 0.079 \cdot Age_i + 0.534 \cdot Gender_i
\end{align}

Trước khi đi vào chi tiết các thành phần của mô hình, chúng tôi muốn kết luận rằng mô hình tuyến tính tổng quát có thể được sử dụng để mô hình hóa dữ liệu trong nhiều hoàn cảnh khác nhau. Việc xây dựng mô hình tuyến tính tổng quát luôn được bắt đầu bằng việc lựa chọn phân phối cho biến phụ thuộc và lựa chọn hàm số liên kết. Có các quy tắc chung trong việc lựa chọn phân phối và hàm liên kết giống như chúng tôi đã trình bày ở phần trên. Tuy nhiên để đưa ra được mô hình tuyến tính tổng quát phù hợp cho từng dữ liệu cụ thể, hoặc để có thể mở rộng được mô hình tuyến tính tổng quát trong các kiểu dữ liệu phức tạp hơn, bạn đọc cần am hiểu sâu hơn về các đặc điểm kỹ thuật của các mô hình này. Các kiến thức này sẽ được trình bày trong các phần tiếp theo của chương.

## Các thành phần của mô hình tuyến tính tổng quát.
Như chúng ta đã thảo luận trong phần trước, mô hình tuyến tính tổng quát khắc phục hai giả thiết, cũng là hai nhược điểm của mô hình tuyến tính thông thường, đó là i) biến phụ thuộc có phân phối chuẩn, và ii) giá trị trung bình của biến phụ thuộc bằng một tổ hợp tuyến tính của các biến độc lập. Trong phần này của cuốn sách, chúng tôi sẽ thảo luận kỹ hơn vào cách tiếp cận để khắc phục các hạn chế kể trên. 

- Thứ nhất, thay vì sử dụng phân phối chuẩn, mô hình tuyến tính tổng quát giả thiết rằng biến phụ thuộc có phân phối nằm trong họ các phân phối kiểu mũ (exponential family). Phân phối chuẩn chỉ là một trường hợp đặc biệt của họ các phân phối này.

- Thứ hai, mô hình tuyến tính tổng quát sử dụng một hàm $g$, được gọi là hàm liên kết, để mô tả mối liên hệ giữa giá trị trung bình của biến phụ thuộc với tổ hợp tuyến tính của các biến độc lập. Lựa chọn hàm $g$ có ý nghĩa quan trọng không chỉ trong cách luận giải kết quả của mô hình, mà còn ở việc dễ dàng ước lượng tham số của mô hình.

### Họ các biến ngẫu nhiên có phân phối kiểu mũ.
Thay vì giả thiết rằng $Y$ có phân phối chuẩn trong mô hình tuyến tính thông thường, mô hình tuyến tính tổng quát giả thiết biến phụ thuộc $Y$ nằm trong họ các biến ngẫu nhiên có phân phối kiểu mũ. Họ các biến ngẫu nhiên có phân phối kiểu mũ (exponential family) có hàm mật độ xác suất có thể viết dưới dạng như sau:
\begin{align}
f(y;\theta,\phi) = \exp\left[ \cfrac{y \theta - b(\theta)}{a(\phi)} + c(y,\phi) \right]
\end{align}
trong đó 

- Tham số $\theta$ được gọi là tham số $chính$ $tắc$ của phân phối kiểu mũ.
- Tham số $\phi$ được gọi là tham số $phân$ $tán$. Nguyên nhân là do giá trị trung bình của biến ngẫu nhiên $Y$ không phụ thuộc vào $\phi$. Tham số $\phi$, mà tổng quát hơn là hàm $a(\phi)$ sẽ xác định phương sai của biến phụ thuộc.
- Các hàm số $b(\theta)$, $a(\phi)$ và $c(y,\phi)$ sẽ quyết định kiểu phân phối của biến phụ thuộc.

Giá trị trung bình và phương sai của biến phụ thuộc $Y$ được cho bởi các công thức sau:
\begin{align}
& \mathbb{E}(Y) = b^{'}(\theta) \\
& \mathbb{V}(Y) = a(\phi) \cdot b^{''}(\theta)
(\#eq:EF1)
\end{align}
với $b^{'}(\theta)$ và $b^{''}(\theta)$ lần lượt là đạo hàm bậc một và đạo hàm bậc hai của hàm số $b$ theo biến $\theta$.

Họ các biến ngẫu nhiên có phân phối kiểu mũ bao gồm đa số các biến ngẫu nhiên liên tục thông thường như phân phối chuẩn, phân phối mũ, phân phối Gamma, phân phối chuẩn ngược. Các biến ngẫu nhiên phân phối rời rạc như phân phối nhị thức, phân phối binomial, hoặc phân phối Poisson cũng nằm trong họ các biến ngẫu nhiên có phân phối kiểu mũ.

- Ví dụ 1: phân phối Poisson thường được sử dụng để mô tả phân phối của biến đếm trong mô hình tuyến tính tổng quát. Hàm phân phối của biến ngẫu nhiên Poisson với tham số $\lambda$, ký hiệu $\mathcal{P}(\lambda)$, được cho bởi công thức
\begin{align}
\mathbb{P}(Y = y; \lambda) = exp(-\lambda) \ \cfrac{\lambda^y}{y!}
\end{align}
Chúng ta có thể viết phân phối $\mathcal{P}(\lambda)$ dưới dạng phân phối mũ như sau 
\begin{align}
\mathbb{P}(Y = y; \theta) = exp\left[ \cfrac{\theta y - exp(\theta)}{1} - log(\Gamma(y+1)) \right] \text{ với } \lambda = exp(\theta)
\end{align}
Đây là hàm phân phối của biến ngẫu nhiên nằm trong họ các phân phối kiểu mũ với $a(\phi) = 1$; $b(\theta) = exp(\theta)$ và $c(y,\phi) = log\left(\Gamma(y+1)\right)$. Bạn đọc có thể tính toán trung bình và phương sai của phân phối $\lambda$ dựa theo công thức \@ref(eq:EF1)
\begin{align}
& \mathbb{E}(Y) = b^{'}(\theta) = exp(\theta) = \lambda \\
& \mathbb{V}(Y) = a(\phi) \cdot b^{''}(\theta) = 1 \cdot exp(\theta) = \lambda
\end{align}

- Ví dụ 2: phân phối chuẩn là một biến ngẫu nhiên nằm trong họ các phân phối kiểu mũ. Thật vậy, chúng ta có hàm mật độ của biến ngẫu nhiên phân phối chuẩn với trung bình $\mu$ và độ lệch chuẩn $\sigma$, ký hiệu $\mathcal{N}(\mu,\sigma)$, như sau
\begin{align}
f(y,\mu,\sigma) = \cfrac{1}{\sqrt{2 \pi \sigma^2}} \exp\left[ \cfrac{-(y - \mu)^2}{2 \ \sigma^2} \right]
\end{align}
Hàm phân phối của $\mathcal{N}(\mu,\sigma)$ có thể được viết dưới dạng phân phối kiểu mũ
\begin{align}
\cfrac{1}{\sqrt{2 \pi} \sigma} \exp\left[ \cfrac{-(y - \mu)^2}{2 \ \sigma^2} \right] &= \exp\left[ \cfrac{-(y - \mu)^2}{2 \ \sigma^2} - \cfrac{1}{2} log(2 \pi \sigma^2) \right] \\
&= \exp\left[ \cfrac{\mu y - \mu^2/2} {\sigma^2} - \cfrac{y^2}{2\sigma^2} - \cfrac{1}{2} log(2 \pi \sigma^2) \right]
\end{align}
Với $\theta = \mu$ và $\phi = \sigma^2$ chúng ta có hàm mật độ của biến ngẫu nhiên $\mathcal{N}(\mu,\sigma)$ là hàm mật độ của biến ngẫu nhiên nằm trong họ các phân phối kiểu mũ, với $a(\phi) = \phi$, $b(\theta) = \theta^2/2$ và
\begin{align}
c(y,\phi) = -\cfrac{y^2}{2\phi} - \cfrac{1}{2} log(2 \pi \phi)
\end{align}
Bạn đọc có thể kiểm tra giá trị trung bình và phương sai của phân phối $\mathcal{N}(\mu,\sigma)$ dựa theo công thức \@ref(eq:EF1)
\begin{align}
& \mathbb{E}(Y) = b^{'}(\theta) = \theta = \mu \\
& \mathbb{V}(Y) = a(\phi) \cdot b^{''}(\theta) = \phi \cdot 1 = \phi = \sigma^2
\end{align}

- Ví dụ 3: phân phối $Gamma(\alpha,\gamma)$ nằm trong họ các phân phối kiểu mũ. Thật vậy
\begin{align}
f(y) &= \cfrac{\gamma^\alpha}{\Gamma(\alpha)} \ y^{\alpha-1} \ e^{-\gamma \cdot y} \\
&= \exp\left[ -\gamma \cdot y + \alpha \log(\gamma) - \log(\Gamma(\alpha)) - (\alpha-1) \cdot \log(y)    \right]
\end{align}
Với $\theta = -\gamma/\alpha$ và $\phi = 1/\alpha$ ta có
\begin{align}
f(y) & = \exp\left[ \cfrac{\theta y + \log(-\theta)}{1/\alpha} - \cfrac{\log(\alpha)}{1/\alpha} - \log(\Gamma(\alpha)) - (\alpha-1) \cdot \log(y)    \right] \\
& = \exp\left[ \cfrac{\theta y + \log(-\theta)}{\phi} + \cfrac{\log(\phi)}{\phi} - \log(\Gamma(1/\phi)) - (1/\phi-1) \cdot \log(y)    \right]
\end{align} 
Chúng ta có phân phối kiểu mũ với $a(\phi) = \phi$, $b(\theta) = \log(-\theta)$, và 
\begin{align}
c(y,\phi) = \cfrac{\log(\phi)}{\phi} - \log(\Gamma(1/\phi)) - (1/\phi-1) \cdot \log(y)
\end{align}
Chúng ta kiểm tra giá trị trung bình và phương sai của phân phối $Gamma(\alpha,\beta)$ theo công thức \@ref(eq:EF1)
\begin{align}
& \mathbb{E}(Y) = b^{'}(\theta) = - \cfrac{1}{\theta} = \cfrac{\alpha}{\gamma} \\
& \mathbb{V}(Y) = a(\phi) \cdot b^{''}(\theta) = \cfrac{1}{\alpha} \cdot \cfrac{\alpha^2}{\gamma^2} = \cfrac{\alpha}{\gamma^2}
\end{align}

Trong trường hợp hàm số $a(\phi)$ là hàm số tuyến tính theo $\phi$, nghĩa là tồn tại số $\omega$ sao cho $a(\phi) = \cfrac{\phi}{\omega}$ chúng ta có hàm mật độ của biến ngẫu nhiên có phân phối kiểu mũ như sau
\begin{align}
f(y;\theta,\phi) = \exp\left[ \cfrac{y \theta - b(\theta)}{\phi/\omega} + c(y,\phi) \right]
\end{align}
Giá trị trung bình và phương sai của biến ngẫu nhiên $Y$ trong trường hợp này được xác định như sau:
\begin{align}
& \mathbb{E}(Y) = b^{'}(\theta) \\
& \mathbb{V}(Y) = \cfrac{\phi}{\omega} \cdot b^{''}(\theta)
\end{align}

Giả sử hàm $b^{'}(.)$ là hàm số đơn điệu và tồn tại hàm số ngược ${b^{'}}^{-1}(.)$ thì $\theta = {b^{'}}^{-1}\left(\mathbb{E}(Y)\right)$. Do đó mối liên hệ giữa phương sai của biến ngẫu nhiên $Y$ và giá trị trung bình của biến $Y$ được thể hiện qua công thức sau
\begin{align}
\mathbb{V}(Y) = \cfrac{\phi}{\omega} \cdot b^{''}({b^{'}}^{-1}(\mathbb{E}(Y)))
\end{align}

Hàm số $V(\cdot) = b^{''}({b^{'}}^{-1}(\cdot))$ được gọi là hàm phương sai của phân phối kiểu mũ. Tại sao chúng ta cần định nghĩa một hàm số phức tạp như vậy? Bởi vì hàm $V(\cdot)$ là cơ sở để người xây dựng mô hình kiểm soát phương sai của biến ngẫu nhiên kiểu mũ. 

Giả sử biến phụ thuộc quan sát được là $Y_1, Y_2, \cdots, Y_n$ có cùng phân phối kiểu mũ với cùng tham số $\phi$, cùng hàm $b(\cdot)$ và $c(\cdot)$, nhưng có giá trị $\omega_i$ khác nhau. Giá trị trung bình của biến $Y_i$, ký hiệu là $\mu_i$ được giải thích thông qua các biến độc lập và không phụ thuộc vào $\omega_i$, trong khi phương sai của biến $Y_i$ phụ thuộc vào $\omega_i$ và giá trị trung bình $\mu_i$: 
\begin{align}
\mathbb{V}(Y_i) = \cfrac{\phi}{\omega_i} \cdot V(\mu_i)
\end{align}

Khi ước lượng mô hình tuyến tính tổng quát trên một dữ liệu cụ thể, giá trị hàm phương sai $V$ phụ thuộc vào cách chúng ta lựa chọn hàm $b$ và giá trị trung bình của $Y_i$. Tham số $\phi$ không phụ thuộc vào quan sát $Y_i$, do đó hệ số $w_i$ có ý nghĩa quyết định trong xác định phương sai của $Y_i$. Chúng ta có thể lựa chọn đơn giản là cho $w_i$ bằng 1 với mọi $i$, nếu chúng ta tin rằng tỷ lệ $\cfrac{V(\mu_i)}{\mathbb{V}(Y_i)}$ là hằng số. Trong một số trường hợp, $\cfrac{V(\mu_i)}{\mathbb{V}(Y_i)}$ thay đổi theo $i$, đó là lúc chúng ta cần lựa chọn $w_i$ để cho kết quả tốt nhất. Chúng ta sẽ tiếp tục thảo luận về hàm phương sai của biến phụ thuộc trong phần hàm hợp lý tối đa của biến ngẫu nhiên nằm trong họ phân phối các phân phối kiểu mũ. 

### Hàm liên kết.
Hàm số liên kết $g(\cdot)$ liên kết giá trị trung bình của biến phụ thuộc với tổ hợp tuyến tính của các biến độc lập luôn được lựa chọn trong nhóm các hàm số đơn điệu và có đạo hàm trên miền xác định của hàm số đó. Các giả thiết này đảm bảo để hàm liên kết có hàm số ngược $g^{-1}(\cdot)$ cũng là hàm đơn điệu và có đạo hàm trên miền xác định. Một yếu tố quan trọng khác khi lựa chọn hàm liên kết đó là $g(\cdot)$ có miền xác định trùng với miền xác định của giá trị trung bình của biến phụ thuộc và miền giá trị của $g(\cdot)$ là tập số thực $\mathbb{R}$.
 
Xin được nhắc lại rằng mối liên hệ giữa trung bình của biến phụ thuộc và tổ hợp tuyến tính của biến độc lập được mô tả thông qua hàm liên kết như sau:
\begin{align}
& g(\mu_i) = \beta_0 + \beta_1 \cdot x_{i,1} +  \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,d} \\
& \mu_i = g^{-1}\left( beta_0 + \beta_1 \cdot x_{i,1} +  \beta_2 \cdot x_{i,2} + \cdots + \beta_p \cdot x_{i,d} \right)
\end{align}

Danh sách các hàm số thường được sử dụng làm hàm liên kết được cho trong bảng dưới đây

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Tên hàm số </th>
   <th style="text-align:left;"> Hàm $g(\mu)$ </th>
   <th style="text-align:left;"> Hàm $g^{-1}(\mu)$ </th>
   <th style="text-align:left;"> Miền xác định </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Identily </td>
   <td style="text-align:left;"> $\mu$ </td>
   <td style="text-align:left;"> $\mu$ </td>
   <td style="text-align:left;"> (-\infty,+\infty) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log </td>
   <td style="text-align:left;"> $\log(\mu)$$ </td>
   <td style="text-align:left;"> $\exp(\mu)$ </td>
   <td style="text-align:left;"> (0,+\infty) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Logit </td>
   <td style="text-align:left;"> $\log(\mu/(1-\mu)$ </td>
   <td style="text-align:left;"> $e^{\mu}/(1+e^\mu)$ </td>
   <td style="text-align:left;"> (0,1) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Probit </td>
   <td style="text-align:left;"> $\Phi^{-1}(\mu)$ </td>
   <td style="text-align:left;"> $\Phi(\mu)$ </td>
   <td style="text-align:left;"> (0,1) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log-log </td>
   <td style="text-align:left;"> $\log(-\log(1-\mu))$ </td>
   <td style="text-align:left;"> $1 - \exp(-\exp(\mu))$ </td>
   <td style="text-align:left;"> (0,1) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Inverse </td>
   <td style="text-align:left;"> $1/\mu$ </td>
   <td style="text-align:left;"> $1/\mu$ </td>
   <td style="text-align:left;"> (-\infty,+\infty)/0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Inverse squared </td>
   <td style="text-align:left;"> $1/\mu^2$ </td>
   <td style="text-align:left;"> $1/\sqrt{\mu}$ </td>
   <td style="text-align:left;"> (0,+\infty) </td>
  </tr>
</tbody>
</table>

- Ví dụ 1: khi $Y$ mô tả số lần khách hàng gửi yêu cầu bảo hiểm, giá trị trung bình của $Y$ sẽ là số thực dương. Các hàm số có miền xác định là tập các số thực dương sẽ phù hợp trong trường hợp này. Có thể thấy trong bảng trên các hàm $g(\mu) = \log(\mu)$ và hàm $g(\mu) = 1/\mu^2$ là các hàm số có thể lựa chọn là hàm liên kết.

- Ví dụ 2: khi $Y$ mô tả khách hàng có gửi yêu cầu bảo hiểm hay không, hoặc mô tả sự kiện tai nạn có xảy ra hay không, giá trị trung bình của $Y$ nằm trong khoảng $(0,1)$. Do đó các hàm $Logit$, hàm $Probit$, hàm $Log-Log$, hoặc hàm $Cauchit$ sẽ là lựa chọn phù hợp cho hàm liên kết.

Khi lựa chọn hàm liên kết bạn đọc cần cân nhắc đến khả năng giải thích của mô hình và sự khó khăn có thể gặp phải khi ước lượng của tham số trong mô hình. Ví dụ như khi biến mục tiêu chỉ nhận giá trị 0 hoặc 1, hàm logit thường xuyên được sử dụng bởi vì khả năng giải thích tốt hơn hàm $Probit$ hay $Log-Log$. Hoặc khi cân nhắc lựa chọn giữa hàm $log$ và hàm $inverse$ $squared$, hàm $log$ thường được ưu tiên lựa chọn. Có thể so sánh mối liên hệ giữa $\mu_i$ với các biến độc lập như dưới đây thông qua hàm $log$ hoặc hàm $inverse$ $squared$ như sau
\begin{align}
&\text{ Hàm log: } \mu_i = exp(\beta_0) \cdot exp(\beta_1 \cdot x_{i,1}) \cdots exp(\beta_p \cdot x_{i,p}) \\
&\text{ Inverse squared: } \mu_i = \cfrac{1}{\sqrt{\beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{i,p}}}
\end{align}
Khi sử dụng hàm $log$, mỗi biến độc lập tác động lên giá trị trung bình của biến phụ thuộc một cách độc lập với nhau theo quy tắc nhân, trong khi đó không dễ để đánh giá tác động của một biến độc lập lên biến phụ thuộc trong công thức của hàm $inverse$ $squared$. Hay nói cách khác, sử dụng hàm $log$ thường sẽ dễ dàng giải thích kết quả hơn so với khi sử dụng hàm $inverse$ $squared$. 

Với $Y$ là biến ngẫu nhiên nằm trong họ các phân phối kiểu mũ ta có $\mathbb{E}(Y_i) = b^{'}(\theta_i)$. Khi chúng ta lựa chọn hàm liên kết là $g(\cdot) = (b^{'})^{-1}(\cdot)$ thì mối liên hệ giữa tham số chính tắc $\theta_i$ với các biến độc lập sẽ là tuyến tính. Thật vậy,
\begin{align}
& \mu_i = g^{-1}(\theta_i) \\
& g(\mu_i) = \beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{i,p}\\
& \rightarrow \theta_i = \beta_0 + \beta_1 \cdot x_{i,1} + \beta_2 \cdot x_{i,2} \cdots + \beta_p \cdot x_{i,p}
\end{align}

Như vậy, với lựa chọn hàm liên kết $g(\cdot) = (b^{'})^{-1}(\cdot)$, tham số chính tắc $\theta_i$ của biến ngẫu nhiên phân phối mũ $Y_i$ bằng tổ hợp tuyến tính của các biến độc lập. Trong trường hợp này, hàm liên kết $(b^{'})^{-1}(\cdot)$ còn được gọi là hàm liên kết chính tắc của biến phụ thuộc $Y$.

- Ví dụ 1: khi $Y$ là biến ngẫu nhiên có phân phối chuẩn $\mathcal{N}(\mu, \sigma)$, chúng ta có $b(\mu) = \mu^2/2$ và $b^{'}(\mu) = \mu$ do đó hàm liên kết chính tắc của biến ngẫu nhiên phân phối chuẩn $\mathcal{N}(\mu, \sigma)$ là $g(\mu) = \mu$.

- Ví dụ 2: khi $Y$ là biến ngẫu nhiên có phân phối $gamma(\alpha,\gamma)$, chúng ta có $b(\mu) = \log(-\mu)$, và $b^{'}(\mu) = -1/\mu$, do đó hàm liên kết chính tắc của biến ngẫu nhiên phân phối gamma là $g(\mu) = -1/\mu$. Trong trường hợp này hàm liên kết không có miền xác định là tập các số thực dương. Có thể thấy rằng lựa chọn hàm liên kết chính tắc không phải là một lựa chọn phù hợp.

## Hàm hợp lý tối đa và ước lượng mô hình.
Hệ số tuyến tính của các biến độc lập $\boldsymbol{\beta} =  (\beta_0, \beta_1, \cdots, \beta_p)$ được ước lượng từ dữ liệu $\textbf{y} = (y_1, y_2, \cdots y_n)$ và $\textbf{x} = (\textbf{x}_1, \textbf{x}_2, \cdots \textbf{x}_n)$ bằng phương pháp tối đa hóa hàm hợp lý, hay còn gọi là hàm likelihood. Khi biến mục tiêu $Y_i$ có phân phối kiểu mũ, hàm likelihood được viết như sau
\begin{align}
L(\textbf{y},\boldsymbol{\beta}) = \prod\limits_{i=1}^n \ \exp\left[ \cfrac{y_i \theta - b(\theta)}{a_i(\phi)} + c_i(y_i,\phi) \right]
\end{align}
Trong hầu hết các trường hợp, chúng ta sẽ thực hiện tính toán trên hàm Log-likelihood thay vì hàm likelihood. Hàm Log-likelihood được ký hiệu $l(\textbf{y},\beta)$ được xác định như sau

\begin{align}
l(\textbf{y},\beta) &= \log \left( \prod\limits_{i=1}^n \ \exp\left[ \cfrac{y_i \theta_i - b(\theta_i)}{a_i(\phi)} + c_i(y_i,\phi) \right] \right) \\
&= \sum\limits_{i=1}^n  \left(\cfrac{y_i \theta_i - b(\theta_i)}{a_i(\phi)} + c_i(y_i,\phi)\right)
\end{align}
Véc-tơ hệ số $\boldsymbol{\beta}$ được ước lượng sao cho giá trị của hàm Log-likelihood đạt giá trị lớn nhất. Như vậy $\boldsymbol{\beta}$ là nghiệm của hệ phương trình
\begin{align}
\cfrac{\partial l(\textbf{y},\boldsymbol{\beta})}{\partial \beta_j} & = 0 \ \ \forall j = 1,2, \cdots, p
\end{align}
Lưu ý rằng $b^{'}(\theta_i) = \mu_i$ nên trong các thành phần của hàm mật độ xác suất của biến $Y_i$ chỉ có hàm số $b(\cdot)$ và tham số $\theta_i$ phụ thuộc vào hệ số $\boldsymbol{\beta}$. Đạo hàm của hàm Log-likelihood theo $\beta$ có thể viết được như sau
\begin{align}
\cfrac{\partial l(\textbf{y},\beta)}{\partial \beta_j} & = \sum\limits_{i=1}^n  \cfrac{1}{a_i(\phi)} \left(y_i \cfrac{\partial \theta_i}{\partial \beta_j} - \cfrac{\partial b(\theta_i)}{\partial \beta_j} \right) \\
& = \sum\limits_{i=1}^n  \cfrac{y_i - b^{'}(\theta_i)}{a_i(\phi)} \cfrac{\partial \theta_i}{\partial \beta_j}
\end{align}

Lưu ý rằng $\mu_i = b^{'}(\theta_i)$, đo đó 
\begin{align}
\theta_i = (b^{'})^{-1}(\mu_i) = (b^{'})^{-1}\left(g^{-1}(\beta_0 + \beta_1 \cdot x_{i,1} + \cdots \beta_p \cdot x_{i,p})\right)
\end{align}
đồng thời, đạo hàm của hàm ngược được của các hàm $b^{'}(\cdot)$ và $g(\cdot)$ được xác định như sau
\begin{align}
& \left((b^{'})^{-1}\right)^{'}(\mu_i) = \cfrac{1}{(b^{''}\left((b^{'})^{-1}(\mu_i)\right)} = \cfrac{1}{b^{''}(\theta_i)} \\
& (g^{-1}(\psi_i))^{'} = \cfrac{1}{(g^{'}(g^{-1}(\psi_i))} =  \cfrac{1}{g^{'}(\mu_i)}
\end{align}
với $\psi_i = \beta_0 + \beta_1 \cdot x_{i,1} + \cdots \beta_p \cdot x_{i,p}$.

Như vậy, đạo hàm của $\theta_i$ theo $\beta_j$ được tính như sau
\begin{align}
\cfrac{\partial \theta_i}{\partial \beta_j} = \cfrac{\partial (b^{'})^{-1}(g^{-1}(\psi_i(\beta_j)))}{\partial \beta_j} = \cfrac{x_{i,j}}{b^{''}(\theta_i) \cdot g^{'}(\mu_i)}
\end{align}

Ta có đạo hàm của hàm Log-likelihood theo các tham số $\beta_j$ 
\begin{align}
\cfrac{\partial l(\textbf{y},\beta)}{\partial \beta_j} = \sum\limits_{i=1}^n  \cfrac{(y_i - \mu_i) \cdot x_{i,j}}{a_i(\phi) \cdot b^{''}(\theta_i) \cdot g^{'}(\mu_i)} 
\end{align}

Với lựa chọn $a_i(\phi) = \cfrac{\phi}{\omega_i}$, do phương sai của biến phụ thuộc là $a_i(\phi) \cdot b^{''}(\theta_i)$ nên ta có thể viết hàm Log-likelihood theo các tham số $\beta_j$ theo giá trị trung bình và phương sai của biến phụ thuộc
\begin{align}
\cfrac{\partial l(\textbf{y},\boldsymbol{\beta})}{\partial \beta_j} &= \sum\limits_{i=1}^n  \cfrac{(y_i - \mu_i) \cdot x_{i,j}}{\mathbb{V}(y_i) \cdot g^{'}(\mu_i)} \\
& = \sum\limits_{i=1}^n w_i \cfrac{(y_i - \mu_i) \cdot x_{i,j}}{\phi V(\mu_i) \cdot g^{'}(\mu_i)} \\
& =\cfrac{1}{\phi} \sum\limits_{i=1}^n w_i \cfrac{x_{i,j}}{V(\mu_i) \cdot g^{'}(\mu_i)} (y_i - \mu_i) 
\end{align}
Có thể thầy rằng:

- Thứ nhất, $\beta_j$ là nghiệm của phương trình $\cfrac{\partial l(\textbf{y},\beta)}{\partial \beta_j} = 0$ sẽ không phụ thuộc vào giá trị của tham số phân tán $\phi$. 

- Thứ hai, giá trị của $\mu_i$ phụ thuộc vào giá trị của các biến độc lập $\textbf{x}_i$ và phụ thuộc vào các hệ số $\boldsymbol{\beta}$, do đó giá trị $\cfrac{x_{i,j}}{V(\mu_i) \cdot g^{'}(\mu_i)}$ không phụ thuộc hoàn toàn vào cách chúng ta xây dựng mô hình. 

- Thứ ba, giá trị $w_i$ không phụ thuộc vào dữ liệu do đó có thể được sử dụng linh hoạt để ước lượng mô hình có kết quả tốt nhất. 

Giải hệ phương trình với ẩn là véc-tơ tham số $\boldsymbol{\beta}$ như trên thường phải sử dụng các phương pháp giải số. Phương pháp thường được sử dụng là thuật toán Newton Raphson.

Hàm `glm()` sử dụng xuyên suốt trong chương sách cho phép bạn đọc ước lượng mô hình tuyến tính tổng quát cho đa số các phân phối thường gặp của $Y_i$. Tham số $weight$ trong hàm `glm()` là véc-tơ tham số $w_i$ như chúng ta đã trình bày ở trên. Lựa chọn giá trị cho $w_i$ hoàn toàn do cách tiếp cận của người xây dựng mô hình.

- Ví dụ 1: khi lựa chọn $Y_i$ có phân phối Poisson với tham số $\lambda_i = exp(\theta_i)$ và hàm liên kết là hàm $g(\cdot) = log(\cdot)$. Chúng ta có $a(\phi) = 1$ do đó $w_i = 1 \forall i$. 
\begin{align}
& g(\mu_i) = log(\mu_i) \rightarrow g^{'}(\mu_i) = 1/\mu_i \\
& b(\theta) = exp(\theta) \rightarrow b^{'}(\theta) = b^{''}(\theta) = exp(\theta) \rightarrow (b^{'})^{-1}(\theta) = \log(\theta) \rightarrow V(\theta) = b^{''}(b^{'})^{-1})(\theta) = \theta
\end{align}
Đạo hàm của hàm Log-likelihood theo $\beta_j$ trở thành 
\begin{align}
\sum\limits_{i=1}^n w_i \cdot \cfrac{x_{i,j}}{\phi V(\mu_i) \cdot g^{'}(\mu_i)} (y_i - \mu_i) &= \sum\limits_{i=1}^n x_{i,j} (y_i - \mu_i) \\
&= \sum\limits_{i=1}^n x_{i,j} \left[y_i - \exp(\beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{i,p})\right]
\end{align}
hay nói một cách khác, véc-tơ tham số $\beta$ để tối đa hóa giá trị của hàm Log-likelihood là nghiệm của hệ phương trình 
\begin{align}
\sum\limits_{i=1}^n x_{i,j} \left[y_i - \exp \left(\beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{i,p} \right) \right] = 0 \ \forall j
\end{align}

- Ví dụ 2: khi $Y_i$ có phân phối Gamma với tham số $\alpha$, $\gamma_i$ chúng ta có $b(\theta_i) = log(-\theta_i)$ với $\theta_i = - \cfrac{\gamma_i}{\alpha}$ đồng thời $a(\phi) = \phi$ do đó $w_i = 1$ $\forall i$. Giả sử hàm liên kết được lựa chọn là hàm $log$: $g(\cdot) = log(\cdot)$.
\begin{align}
& g(\mu_i) = log(\mu_i) \rightarrow g^{'}(\mu_i) = 1/\mu_i \\
& b(\theta_i) = log(-\theta_i) \rightarrow b^{'}(\theta_i) = -1/\theta_i \rightarrow b^{''}(\theta) = 1/\theta^2 \rightarrow (b^{'})^{-1}(\theta) = -1/\theta \rightarrow V(\mu) = b^{''}(b^{'})^{-1})(\mu) = \mu^2 
\end{align}
Đạo hàm của hàm Log-likelihood theo $\beta_j$ trở thành 
\begin{align}
\sum\limits_{i=1}^n w_i \cdot \cfrac{x_{i,j}}{\phi V(\mu_i) \cdot g^{'}(\mu_i)} (y_i - \mu_i) &= \sum\limits_{i=1}^n \cfrac{x_{i,j}}{\mu_i} (y_i - \mu_i) 
\end{align}
véc-tơ tham số $\boldsymbol{\beta}$ để tối đa hóa giá trị của hàm Log-likelihood là nghiệm của hệ phương trình 
\begin{align}
\sum\limits_{i=1}^n x_{i,j} \left\{y_i \cdot \exp\left[-(\beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{i,p}) \right] - 1 \right\} = 0 \ \forall j
\end{align}

- Ví dụ 3: khi $Y_i$ là số tiền bồi thường trung bình cho 1 tai nạn trong vòng 1 năm của một khách hàng, biết rằng khách hàng được bồi thường $n_i$ lần trong năm và số tiền bồi thường của một vụ tai nạn là biến ngẫu nhiên $Y^*_i$ phân phối Gamma với tham số $\alpha$, $\beta_i$. Do $Y_i$ là giá trị trung bình của $n_i$ biến phân phối Gamma độc lập với cùng tham số $\alpha$, $\beta_i$ nên $Y_i$ sẽ có phân phối Gamma với tham số $(n_i \alpha)$ và $(n_i \beta_i)$. Khi viết $Y_i$ dưới dạng phân phối kiểu mũ, chúng ta có $b(\theta_i) = log(-\theta_i)$ với $\theta_i = - \cfrac{\beta_i}{\alpha}$ và $a(\phi) = \phi/n_i$. Véc-tơ tham số $\boldsymbol{\beta}$ để tối đa hóa giá trị của hàm Log-likelihood là nghiệm của hệ phương trình 
\begin{align}
\sum\limits_{i=1}^n n_i \cdot \ x_{i,j} \cdot  \left[y_i \cdot \exp\left(-(\beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{i,p}) \right) - 1 \right] = 0 \ \forall j
\end{align}

## So sánh và lựa chọn mô hình tuyến tính tổng quát.
Nắm được các nguyên tắc chung bạn đọc có thể tự xây dựng nhiều mô hình tuyến tính tổng quát khác nhau cho một dữ liệu cụ thể. Thách thức đặt ra là một mô hình liệu có thực sự có tốt hơn các mô hình khác, hay trong số các mô hình bạn lựa chọn mô hình nào là phù hợp nhất? Phần này của chương sẽ thảo luận về vấn đề so sánh mô hình và lựa chọn mô hình. Các chỉ tiêu thống kê được sủ dụng để so sánh mô hình sẽ xoay quanh giá trị của hàm hợp lý tối đa, bao gồm có thước đo deviance, chỉ tiêu AIC, AICC, hay BIC.

### Thước đo deviance
Thước đo được gọi là deviance thường được sử dụng để đánh giá và so sánh các mô hình tuyến tính tổng quát có cùng phân phối của biến độc lập. Chỉ tiêu này được tính toán dựa trên giá trị hàm Log-likelihood. Khi $Y$ là biến ngẫu nhiên trong nhóm các phân phối mũ, hàm log-likelihood được viết như sau
\begin{align}
l(\textbf{y},\theta) & = \sum\limits_{i=1}^n  \left(\cfrac{y_i \theta_i - b(\theta_i)}{a_i(\phi)} + c_i(y_i,\phi)\right)
\end{align}
với $\boldsymbol{\theta}$ là véc-tơ các tham số chính tắc, $\boldsymbol{\theta} = (\theta_1, \theta_2, \cdots, \theta_n)$. Sau khi phân phối của $Y$ và hàm liên kết được lựa chọn, chúng ta ước lượng được véc-tơ tham số $\boldsymbol{\beta}$ là hệ số của các biến độc lập bằng cách tối đa hóa hàm log-likelihood. Sau khi đã xác định được véc-tơ tham số $\boldsymbol{\beta}$, với mỗi lựa chọn cho phân phối của $Y$ và hàm liên kết, chúng ta sẽ tính toán được các tham số chính tắc của mô hình tuyến tính tổng quát. Nếu hàm liên kết được lựa chọn là hàm liên kết chính tắc, $g(\cdot) = (b^{'})^{-1}(\cdot)$, chúng ta có các tham số chính tắc chính là tổ hợp tuyến tính của các biến độc lập $\boldsymbol{\theta}^M = (\theta^M_1, \theta^M_2, \cdots, \theta^M_n)$ với
\begin{align}
\theta^M_i = \beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{i,p}
(\#eq:compa1)
\end{align}

Với mỗi lựa chọn cho mô hình tuyến tính tổng quát, bao gồm lựa chọn cho phân phối của $Y$ và hàm liên kết $g$, tạm gọi là mô hình $M$, chúng ta gọi $l(\textbf{y},\boldsymbol{\theta}^M)$ là giá trị của hàm Log-likelihood tại tham số $\boldsymbol{\theta}^M$ được xác định qua phương trình \@ref(eq:compa1). Lưu ý rằng véc-tơ $\boldsymbol{\theta}^M$ có độ dài là $n$, bằng với kích thước của dữ liệu, tuy nhiên các tham số này được tính toán từ $(p+1)$ giá trị $\beta$ ước lượng được và giá trị của biến độc lập.

Điều gì xảy ra nếu tham số chính tắc $\boldsymbol{\theta}$ hoàn toàn tự do và không phụ thuộc vào biến độc lập? Hàm Log-likelihood sẽ đạt giá trị cực đại tại $\theta^S = (\theta^S_1, \theta^S_2, \cdots, \theta^S_n)$ với $\theta^S_i$ là giá trị sao cho đạo hàm của hàm Log-likelihood tại $\theta^S_i$ bằng 0. Do $\theta$ hoàn toàn tự do nên chỉ có thành phần thứ $i$ của hàm Log-likelihood phụ thuộc vào $\theta^S_i$
\begin{align}
\cfrac{\partial l(\textbf{y},\theta)}{\partial \theta_i} & =  \cfrac{y_i - b^{'}(\theta_i)}{a_i(\phi)}
\end{align}
Cho đạo hàm của $l(\textbf{y},\theta)$ theo $\theta_i$ bằng 0 chúng ta có $y_i - b^{'}(\theta^S_i) = 0$ hay  $\theta^S_i = (b^{'})^{-1}(y_i)$. 

Bạn đọc lưu ý rằng giá trị hàm Log-likelihood đạt cực đại tại $\boldsymbol{\theta}^S$ không có nghĩa là tham số $\boldsymbol{\theta}^S$ là lựa chọn tốt nhất cho mô hình tuyến tính tổng quát bởi tham số có đến $n$ bậc tự do. $\boldsymbol{\theta}^S$ cho chúng ta thông tin về giá trị cận trên của $l(\textbf{y},\theta)$ khi $\theta$ thay đổi. Thước đo deviance của mô hình $M$, ký hiệu $D*(y,\theta^M)$ được định nghĩa là hai lần khoảng cách từ $l(\textbf{y},\boldsymbol{\theta}^M)$ đến giá trị tối đa $l(\textbf{y},\boldsymbol{\theta}^S)$. Deviance của một mô hình cho biết mô hình được lựa chọn gần với phân phối quan sát được như thế nào, và mô hình có deviance càng nhỏ thì càng giải thích tốt hơn biến phụ thuộc
\begin{align}
D^{*}(y, \theta^M) &= 2 \left( l(\textbf{y},\theta^S) - l(\textbf{y},\theta^M) \right) \\
& = 2 \sum\limits_{i=1}^n  \cfrac{y_i (\theta^S_i - \theta^M_i) - (b(\theta^S_i) - b(\theta^M_i))}{a_i(\phi)} 
\end{align}

Trong trường hợp hàm $a_i(\phi)$ là tuyến tính theo $\phi$; $a_i(\phi) = \cfrac{\phi}{w_i}$, ta có 
\begin{align}
D^{*}(y, \theta^M) & = \cfrac{1}{\phi} \sum\limits_{i=1}^n 2w_i \cdot \left[y_i (\theta^S_i - \theta^M_i) - (b(\theta^S_i) - b(\theta^M_i)) \right]  = \cfrac{D(y, \theta^M)}{\phi}
\end{align}
với 
\begin{align}
D(y, \theta^M) & = \sum\limits_{i=1}^n 2w_i \cdot \left[y_i (\theta^S_i - \theta^M_i) - (b(\theta^S_i) - b(\theta^M_i)) \right]
\end{align}
trong đó $D(y, \theta^M)$ là thước đo deviance bỏ qua ảnh hưởng của tham số dispersion $\phi$.

- Ví dụ 1: biến mục tiêu $Y_i$ có phân phối chuẩn: $Y_i \sim \mathcal{N}(\mu_i, \sigma)$ và hàm liên kết $g(x) = x$. Có thể viết hàm mật độ của $Y_i$ dưới dạng phân phối mũ như sau
\begin{align}
f(y, \theta_i, \phi) & = \exp\left[ \cfrac{\theta_i y - \theta_i^2/2} {\phi} - \cfrac{y^2}{2\phi} - \cfrac{1}{2} log(2 \pi \phi) \right]
\end{align}
với $\theta_i = \mu_i$ và $\phi = \sigma^2$.  Ta có $\theta^S_i = (b^{'})^{-1}(y_i) = y_i$, do đó deviance tính trên quan sát $\textbf{y}$ được xác định như sau
\begin{align}
D(y, \theta^M) & = \sum\limits_{i=1}^n 2 \cdot \left[y_i (\theta^S_i - \theta^M_i) - (b(\theta^S_i) - b(\theta^M_i)) \right] \\
& = \sum\limits_{i=1}^n (y_i - \theta^M_i)^2 \\
& = \sum\limits_{i=1}^n \left[y_i -  (\beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{p,1}) \right]^2
\end{align}
Trong trường hợp hồi quy tuyến tính thông thường, deviance chính là tổng bình phương sai số.

- Ví dụ 2: biến mục tiêu $Y_i$ có phân phối Poisson $Y_i \sim \mathcal{P}(\lambda_i)$ và hàm liên kết $g(\cdot) = log(\cdot)$. 
\begin{align}
f(y; \theta_i) = exp\left[ \cfrac{\theta_i y - exp(\theta_i)}{1} - log(\Gamma(y+1)) \right] \text{ với } \lambda_i = exp(\theta_i)
\end{align}
Ta có $\theta^S_i = (b^{'})^{-1}(y_i) = log(y_i)$, do đó deviance tính trên quan sát $\textbf{y}$ được xác định như sau
\begin{align}
D(y, \theta^M) & = \sum\limits_{i=1}^n 2 \cdot \left[y_i (\theta^S_i - \theta^M_i) - (b(\theta^S_i) - b(\theta^M_i)) \right] \\
& = \sum\limits_{i=1}^n 2 \cdot \left[y_i (log(y_i) - \theta^M_i) - (y_i - exp(\theta^M_i)) \right] \\
& = \sum\limits_{i=1}^n 2 \cdot \left[y_i \left(log(y_i) - log(\mu^M_i)\right) - (y_i - \mu^M_i) \right] 
\end{align}
với $\mu^M_i = \exp(\beta_0 + \beta_1 \cdot x_{i,1} + \cdots + \beta_p \cdot x_{p,1})$.

Kết quả ước lượng khi sử dụng hàm `glm()` trong R hiển thị hai giá trị là Null deviance và Residual deviance. Null deviance được tính toán với giả thiết là chỉ có hệ số chặn $\beta_0$, còn Residual deviance được tính toán với véc-tơ $\boldsymbol{\beta}$ đầy đủ.

Giá trị Residual deviance ngoài sử dụng để so sánh hai mô hình có cùng phân phối của biến phụ thuộc còn được sử dụng để lựa chọn biến trong mô hình. Giả sử hai mô hình $M1$ và $M2$ có cùng phân phối cho biến phụ thuộc và có cùng hàm liên kết $g(.)$, mô hình $M1$ có $m_1$ biến độc lập trong khi mô hình $M_2$ có $m_2$ biến độc lập, bao gồm tất cả các biến độc lập của mô hình $M1$. Nói một cách khác, $M_2$ có nhiều hơn $M_1$ là $(m_2 - m_1)$ biến độc lập. Mô hình $M_2$ sẽ có deviance lớn hơn mô hình $M_1$ do có nhiều biến độc lập hơn, tuy nhiên việc thêm $(m_2 - m_1)$ biến độc lập vào mô hình có ý nghĩa thống kê nếu hiệu số giữa $D^*(y, \theta^{M_2})$ và $D^*(y, \theta^{M_1})$ là đủ lớn. 

Có thể chứng minh được rằng khi kích thước dữ liệu đủ lớn, hiệu số giữa $D^*(y, \theta^{M_2})$ và $D^*(y, \theta^{M_1})$ là một biến ngẫu nhiên phân phối xấp xỉ phân phối $\chi^2$ với bậc tự do $(m_2 - m_1)$
\begin{align}
D^{*}(y, \theta^{M_1}) - D^{*}(y, \theta^{M_2}) = 2 \cdot \log\left( \cfrac{L(y,\theta^{M_2})}{L(y,\theta^{M_1})} \right) \sim \chi^2(m_2 - m_1)
\end{align}

- Ví dụ 3: trong dữ liệu $exposure.csv$, khi biến $Claim\_Count$ được giả thiết có phân phối Poisson và giá trị trung bình được giải thích bằng độ tuổi, hoặc giới tính của người được bảo hiểm, hoặc cả hai biến. Chúng ta gọi mô hình $M_1$ là mô hình mà giá trị trung bình của biến phụ thuộc được giải thích bằng biến độ tuổi, mô hình $M_2$ là mô hình mà giá trị trung bình của biến phụ thuộc được giải thích bằng cả biến giới tính, và mô hình $M_3$ là mô hình mà biến phụ thuộc phụ thuộc vào cả độ tuổi và giới tính của khách hàng.

```r
dat<-read.csv("../KHDL_KTKD Final/Dataset/exposure.csv")

glm_M1<-glm(Claim_Count~Age, family = poisson(link="log"), data = dat)
glm_M2<-glm(Claim_Count~Gender, family = poisson(link="log"), data = dat)
glm_M3<-glm(Claim_Count~Age+Gender, family = poisson(link="log"), data = dat)

summary(glm_M1)
summary(glm_M2)
summary(glm_M3)
```

Giá trị residual deviance của ba mô hình được tổng hợp ở bảng dưới đây
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> Mô hình </th>
   <th style="text-align:center;"> Biến phụ thuộc </th>
   <th style="text-align:center;"> Deviance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;width: 2; font-weight: bold;border-right:1px solid;"> $M_1$ </td>
   <td style="text-align:center;border-left:1px solid;"> Age </td>
   <td style="text-align:center;border-left:1px solid;"> 8324.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;width: 2; font-weight: bold;border-right:1px solid;"> $M_2$ </td>
   <td style="text-align:center;border-left:1px solid;"> Gender </td>
   <td style="text-align:center;border-left:1px solid;"> 8540.5 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;width: 2; font-weight: bold;border-right:1px solid;"> $M_3$ </td>
   <td style="text-align:center;border-left:1px solid;"> Age, Gender </td>
   <td style="text-align:center;border-left:1px solid;"> 8316.8 </td>
  </tr>
</tbody>
</table>
Mô hình $M_1$ và $M_2$ đều chỉ có một biến độc lập và $M_1$ có deviance nhỏ hơn $M_2$ do đó mô hình $M_1$ tốt hơn $M_2$. So sánh mô hình $M_1$ với 1 biến độc lập là $Age$ với mô hình $M_3$ có 2 biến độc lập là $Age$ và $Gender$ cần dựa trên kiểm định $\chi^2$. Ta có $D^{*}(y, \theta^{M_1}) - D^{*}(y, \theta^{M_2}) = 8324.2 - 8316.8 = 7.4$. Giá trị 7.4 tương ứng với mức xác suất $0.994$ của phân phối $\chi^2(1)$. Điều này có ý nghĩa là ở mức độ tin cậy 99\%, có thể kết luận rằng thêm biến $Gender$ vào mô hình $M_1$ là có ý nghĩa thống kê, tuy nhiên việc thêm biến $Gender$ lại không có ý nghĩa thống kê ở mức độ tin cậy $99.5\%$.

### Giá trị hàm log-likelihood, AIC và BIC
Deviance là một thước đo hữu ích trong so sánh các mô hình có cùng phân phối của biến phụ thuộc và hàm liên kết. Khi các mô hình cần so sánh không có chung phân phối của biến phụ thuộc thì hiệu giữa hai hàm log-likelihood sẽ không có phân phối $\chi^2$ và khi đó việc so sánh các mô hình là không thế thực hiện được. 

Trong phần trước, chúng ta đã định nghĩa $l(y,\theta^M)$ là giá trị tối đa của hàm log-likelihood cho mô hình M với tập hợp các biến độc lập đã lựa chọn. Nhìn chung, giá trị của $l(y,\theta^M)$ không cho biết nhiều thông tin về độ phù hợp của mô hình, nhưng người xây dựng mô hình thường mong muốn giá trị này càng lớn thì càng tốt. Tuy nhiên, có một vấn đề khi so sánh trực tiếp giá trị $l(y,\theta^M)$ giữa các mô hình là: một mô hình bao gồm nhiều biến độc lập hơn thì rất có thể có giá trị $l(y,\theta^M)$ lớn hơn. Để giải quyết vấn đề này, có ba thước đo được điều chỉnh từ $l(y,\theta^M)$ thường được sử dụng cho mô hình tuyến tính tổng quát với mục đích đánh giá và so sánh giữa các mô hình là AIC, AICC và BIC.

Chỉ tiêu AIC, viết tắt của Akaike information criterion, là chỉ tiêu đơn giản nhất được tính toán từ công thức như sau
\begin{align}
AIC = 2 \left(-l(y,\theta^M)+r\right)
\end{align}
trong đó $r$ là số lượng tham số cần ước lượng trong mô hình. Giá trị $AIC$ càng nhỏ thì mô hình càng khớp hơn với dữ liệu. 

Chỉ tiêu AICC (hoặc AICs) được điều chỉnh từ AIC, được sử dụng khi kích thước dữ liệu không quá lớn để thay thế cho AIC, và được tính bởi công thức như sau
\begin{align}
AICC = AIC + \cfrac{2r(r+1)}{n-r-1}
\end{align}
Khi kích thước dữ liệu $n$ lớn, AIC và AICC sẽ tương đương nhau do $\cfrac{2r(r+1)}{n-r-1}$ nhỏ. 

Chỉ tiêu thứ ba là BIC, là viết tắt của Bayesian information criterion. Trong một vài tài liệu BIC còn được gọi là SBC. Cũng giống như AIC và AICC, BIC là chỉ tiêu được tính toán từ giá trị cực đại của hàm log-likelihood điểu chỉnh để phản ánh số lượng tham số sử dụng trong mô hình là nhiều hay ít
\begin{align}
BIC = 2 \left(-l(y,\theta^M)+r log(n)\right)
\end{align}

Cơ sở lý thuyết cho các chỉ tiêu AIC, AICC, và BIC bạn đọc có thể tìm thấy trong bất kỳ tài liệu thống kê toán nào, do đó chúng tôi sẽ không trình bày trong cuốn sách này. Chúng tôi muốn nhấn mạnh vào góc độ ứng dụng của các chỉ tiêu này khi sử dụng để so sánh các mô hình. 

- Ví dụ 1: chúng ta quay trở lại dữ liệu "MotoInsurance.csv" khi biến mục tiêu $Y$ chỉ nhận hai giá trị là "No" hoặc "Yes". Biến $Y$ có thể là biến dạng nhị phân hoặc vừa có thể là biến dạng đếm nếu chúng ta cho tương đương giá trị "No" tương đương với 0 và giá trị "Yes" tương ứng với 1. Khi xây dựng mô hình tuyến tính tổng quát, chúng ta có thể sử dụng phân phối Poisson cho biến mục tiêu với hàm liên kết $g(\cdot) = log(\cdot)$.

```r
dat<-read.csv("../KHDL_KTKD Final/Dataset/MotoInsurance.csv")
dat$Y<-ifelse(dat$Y=="Yes",1,0)
dat$sex<-as.factor(dat$sex)
dat$urban<-as.factor(dat$urban)
glm.pois<-glm(Y~age+sex+urban+seniority,data=dat, family = poisson(link = "log"))
summary(glm.pois)
```

```
## 
## Call:
## glm(formula = Y ~ age + sex + urban + seniority, family = poisson(link = "log"), 
##     data = dat)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.0824  -0.7362  -0.5465   0.5711   1.9556  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -0.286511   0.105615  -2.713  0.00667 ** 
## age         -0.034131   0.002546 -13.406  < 2e-16 ***
## sexM        -0.491418   0.057331  -8.572  < 2e-16 ***
## urban1       0.625032   0.053999  11.575  < 2e-16 ***
## seniority    0.070888   0.004257  16.652  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for poisson family taken to be 1)
## 
##     Null deviance: 2938.1  on 3999  degrees of freedom
## Residual deviance: 2418.7  on 3995  degrees of freedom
## AIC: 5202.7
## 
## Number of Fisher Scoring iterations: 5
```
Do $Y$ là biến nhị phân nên một cách tự nhiên, bạn đọc sẽ cân nhắc sử dụng phân phối nhị phân cho $Y$. Chúng ta xây dựng mô hình tuyến tính tổng quát với phân phối nhị thức cho $Y$ và hàm liên kết là hàm $logit$. Thay vì sử dụng cả 4 biến độc lập, chúng ta chỉ sử dụng hai biến độc lập là $age$ và $sex$,

```r
dat$Y<-as.factor(dat$Y) # đổi biến Y thành factor
glm.binom.logit<-glm(Y~age+sex,data=dat, family = binomial(link = "logit"))
summary(glm.binom.logit)
```

```
## 
## Call:
## glm(formula = Y ~ age + sex, family = binomial(link = "logit"), 
##     data = dat)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.4544  -0.9261  -0.7396   1.2607   2.0088  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.109828   0.130876   8.480   <2e-16 ***
## age         -0.026603   0.002709  -9.822   <2e-16 ***
## sexM        -0.723479   0.076585  -9.447   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 5163.3  on 3999  degrees of freedom
## Residual deviance: 4935.3  on 3997  degrees of freedom
## AIC: 4941.3
## 
## Number of Fisher Scoring iterations: 4
```
Tương tự như mô hình $glm.pois$, mô hình $glm.binom.logit$ cũng có tất cả các hệ số của biến độc lập khác 0. Làm thế nào để biết rằng mô hình $glm.pois$ sử dụng phân phối Poisson với 4 biến độc lập hay mô hình $glm.binom.logit$ với phân phối nhị thức cho $Y$ và 2 biến độc lập là tốt hơn? Nếu chúng ta sử dụng thước đo deviance thì kết quả sẽ không chính xác vì các mô hình có phân phối của biến phụ thuộc khác nhau. Chỉ tiêu $AIC$ được tính toán sẵn từ hàm $glm$ có thể được sử dụng để so sánh hai mô hình trong trường hợp này. Chỉ tiêu AIC của $glm.pois$ là 5202.7 trong khi chỉ tiêu AIC của $glm.binom.logit$ là 4941.3. Mô hình $glm.binom.logit$ có AIC nhỏ hơn nên sẽ tốt hơn để mô hình hóa dữ liệu trong trường hợp này.

- Ví dụ 2: chúng ta sẽ tiếp tục với dữ liệu "MotoInsurance.csv". Một cách tự nhiên, khi sử dụng phân phối nhị thức cho biến phụ thuộc, bạn đọc sử dụng hàm liên kết là hàm $logit$. Liệu lựa chọn này có là tốt nhất để mô hình hóa dữ liệu mà chúng ta đang nghiên cứu? Bạn đọc có thể sử dụng chỉ tiêu AIC để lựa chọn hàm liên kết phù hợp. Chúng ta sẽ sử dụng 4 biến độc lập là $age$, $sex$, $urban$, và $seniority$ để giải thích giá trị trung bình của biến phụ thuộc khi xây dựng mô hình

```r
glm.binom.logit<-glm(Y~age+sex+seniority+urban,data=dat, family = binomial(link = "logit"))
glm.binom.probit<-glm(Y~age+sex+seniority+urban,data=dat, family = binomial(link = "probit"))
summary(glm.binom.logit)
```

```
## 
## Call:
## glm(formula = Y ~ age + sex + seniority + urban, family = binomial(link = "logit"), 
##     data = dat)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.4424  -0.8115  -0.5046   1.0440   2.7439  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  0.793757   0.144541   5.492 3.98e-08 ***
## age         -0.058754   0.003525 -16.668  < 2e-16 ***
## sexM        -0.983040   0.085377 -11.514  < 2e-16 ***
## seniority    0.133569   0.006808  19.618  < 2e-16 ***
## urban1       1.174515   0.078060  15.046  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 5163.3  on 3999  degrees of freedom
## Residual deviance: 4295.8  on 3995  degrees of freedom
## AIC: 4305.8
## 
## Number of Fisher Scoring iterations: 4
```

```r
summary(glm.binom.probit)
```

```
## 
## Call:
## glm(formula = Y ~ age + sex + seniority + urban, family = binomial(link = "probit"), 
##     data = dat)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.4931  -0.8168  -0.4987   1.0639   2.9359  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  0.449579   0.085724   5.244 1.57e-07 ***
## age         -0.034482   0.002009 -17.163  < 2e-16 ***
## sexM        -0.577303   0.050821 -11.360  < 2e-16 ***
## seniority    0.077888   0.003890  20.021  < 2e-16 ***
## urban1       0.697759   0.046129  15.126  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 5163.3  on 3999  degrees of freedom
## Residual deviance: 4292.4  on 3995  degrees of freedom
## AIC: 4302.4
## 
## Number of Fisher Scoring iterations: 5
```
Mô hình $glm.binom.probit$ có deviance và AIC nhỏ hơn $glm.binom.logit$, điều này cho biết sử dụng hàm liên kết $probit$ sẽ cho kết quả tốt hơn so với hàm liên kết $logit$.






# REFERENCE 

<!-- ### Source from thesis -->

**1.** Annette J. Dobson and Adrian G. Barnett (2018). *An Introduction to Generalized Linear Models.* \
**2.** Alan Agresti. (2015). *Foundations of Linear and Generalized Linear Models.* \
<!-- **3.** Hadley Wickham. (2010). *A Layered Grammar of Graphics.* \ -->

<!-- ### Souce from website -->

<!-- **4.** [https://www.tableau.com/learn/articles/data-visualization](https://www.tableau.com/learn/articles/data-visualization) \ -->
<!-- **5.** [https://www.r-graph-gallery.com/ggplot2-package.html](https://www.r-graph-gallery.com/ggplot2-package.html) \ -->
<!-- **6.** [http://r-statistics.co/ggplot2-Tutorial-With-R.html](http://r-statistics.co/ggplot2-Tutorial-With-R.html) \ -->
<!-- **7.** [https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf](https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf) \ -->
<!-- **8.** [https://www.kaggle.com/](https://www.kaggle.com/) \ -->