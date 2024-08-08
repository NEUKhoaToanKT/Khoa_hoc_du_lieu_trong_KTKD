---
output:
  pdf_document: default
  html_document: default
header-includes:
- \usepackage{tikz}
- \usepackage{pgfplots}
- \usetikzlibrary{arrows,automata,positioning,calc}
- \usepackage[utf8]{inputenc}
- \usepackage[utf8]{vietnam}
- \usepackage{etoolbox}
- \usepackage{xcolor}
- \usepackage{hyperref}
- \usepackage{fontawesome5}
- \makeatletter
- \preto{\@verbatim}{\topsep=0pt \partopsep=-0pt}
- \makeatother
- \DeclareMathOperator*{\argmax}{arg\,max}
- \newcommand\tstrut{\rule{0pt}{3ex}}
- \newcommand\bstrut{\rule[-2.5ex]{0pt}{0pt}}
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
## Loading required package: shape
```



# Các mạng học sâu điển hình {#neuralnetwork1}

Mô hình mạng nơ-ron có nhiều lớp ẩn và trong mỗi lớp ẩn có nhiều đơn vị thường được gọi với tên gọi khác là các mạng học sâu (deep neural network). Như chúng ta đã thấy trong phần thực hành của chương trước, mạng học sâu không có ưu thế về khả năng diễn giải hoặc dự đoán so với các mô hình học máy khác khi dữ liệu dùng để xây dựng mô hình là dữ liệu nhỏ và ở dạng quan sát - thuộc tính chẳng hạn như dữ liệu Boston. Ngoài ra, đặc điểm của mạng học sâu là mô hình cho phép sử dụng số lượng tham số rất lớn để mô tả dữ liệu. Đây vừa là nhược điểm cũng vừa là ưu điểm của mô hình mạng học sâu. Sử dụng nhiều tham số rất dễ dẫn đến hiện tượng overfitting đặc biệt là khi dữ liệu xây dựng mô hình nhỏ. Ngược lại, khi gặp dữ liệu lớn và phức tạp, cần có các mô hình có lượng tham số đủ lớn để mô tả sự phức tạp đó, điều này giải thích tại sao các mạng học sâu lại vượt trội hơn các mô hình học máy khác khi mô tả dữ liệu phức tạp như ảnh, video, âm thanh hay dữ liệu kiểu văn bản.

Khó khăn lớn nhất khi xây dựng mô hình mạng học sâu là ước lượng các tham số của mô hình. Như chúng ta đã thấy ở phần 


## Mạng nơ-ron tích chập
Mô hình mạng nơ-ron quay trở lại thành công vào những năm 2010 gắn liền với những thành công lớn trong các mô hình phân loại hình ảnh. Vào khoảng thời gian này, với sự bùng nổ của điện thoại thông minh và kết nối internet, các bộ dữ liệu khổng lồ về hình ảnh được thu thập và gắn nhãn nhằm phục vụ cho xây dựng các thuật toán phân loại hình ảnh. Mộ ví dụ về một cơ sở dữ liệu như vậy là dữ liệu CIFAR100 - dữ liệu bao gồm 60 nghìn hình ảnh về 100 đối tượng hình ảnh khác nhau được mã hóa bằng một số tự nhiên từ 0 đến 99.


<div class="figure" style="text-align: center">
<img src="12-1-Cac-mo-hinh-mang-noron-dien-hinh_files/figure-html/fgdl001-1.png" alt="Năm mươi bức ảnh đại diện cho 10 nhóm được mã hóa bằng các số từ 0 đến 9. Mỗi cột tương ứng với một đối tượng. Cột đầu tiên là các bức ảnh về quả táo (apple) được mã hóa thành số 0, cột thứ hai là các bức ảnh về cá cảnh (aquarium fish) tương ứng với số 1, ..., và cột thứ mười tương ứng với các bức ảnh của chai lọ (bottle) được mã hóa bằng số 9." width="672" />
<p class="caption">(\#fig:fgdl001)Năm mươi bức ảnh đại diện cho 10 nhóm được mã hóa bằng các số từ 0 đến 9. Mỗi cột tương ứng với một đối tượng. Cột đầu tiên là các bức ảnh về quả táo (apple) được mã hóa thành số 0, cột thứ hai là các bức ảnh về cá cảnh (aquarium fish) tương ứng với số 1, ..., và cột thứ mười tương ứng với các bức ảnh của chai lọ (bottle) được mã hóa bằng số 9.</p>
</div>

Khác với hình ảnh trong dữ liệu MNIST, ảnh trong dữ liệu CIFAR100 là ảnh màu. Đối tượng dùng để lưu trữ một bức ảnh màu là một mảng 3 chiều thay vì một ma trận khi lưu trữ ảnh đen trắng. Kích thước của mỗi bức ảnh trong dữ liệu CIFAR100 là $32 \times 32 \times 3$, nghĩa là độ phân giải của mỗi bức ảnh là $32 \times 32$ pixel, và chiều thứ ba cho biết màu sắc của các điểm ảnh được kết hợp từ ba màu đỏ, xanh lục và xanh lam như thế nào. 

Một kỹ thuật xây dựng mạng nơ-ron được gọi là mạng nơ-ron tích chập (Convolution Neural Network hay CNN) đã được phát triển với mục đích phân loại các hình ảnh như trong dữ liệu CIFAR100 và đã cho kết quả thành công vượt trội so với các phương pháp trước đây. Mạng CNN phỏng theo cách con người phân loại hình ảnh bằng cách nhận dạng các đặc điểm hoặc đặc trưng cụ thể nằm ở bất kỳ điểm nào trong hình ảnh để phân biệt các đối tượng cụ thể. Hình 10.6 minh họa ý tưởng xây dựng mạng nơ-ron tích chập để xác định hình ảnh một ............


Nguyên tắc xây dựng mạng nơ-ron tích chập là sử dụng các lớp để xác định các đặc điểm nhỏ trong hình ảnh đầu vào, chẳng hạn như các mảng màu sắc, các hình dạng nhỏ, các cạnh nhỏ, và những thứ tương tự. Các đặc điểm nhỏ này sau đó được kết hợp để tạo thành các đặc điểm lớn hơn, chẳng hạn như các bộ phận của mắt, mũi, tai trong hình ... Cuối cùng, mạng nơ-ron kết hợp các đặc điểm lớn lại để tính toán xác suất các đặc điểm này xuất hiện đồng thời trên một đối tượng cụ thể. Nguyên tắc xây dựng mạng nơ-ron tích chập cho phân loại ảnh là sử dụng các lớp tích chập để tìm kiếm các đặc điểm nhỏ trong hình ảnh sau đó sử dụng các lớp tổng hợp để tìm kiếm một tập hợp các đặc điểm nổi bật của ảnh. Để đạt được kết quả vượt trội, kiến trúc mạng nơ-ron cần sử dụng nhiều lớp tích chập và lớp gộp. Cách xây dựng các lớp này được trình bày trong phần tiếp theo của chương sách.

### Lớp tích chập trong mạng CNN

Một lớp tích chập được tạo thành từ một số lượng lớn các bộ lọc mà mỗi bộ lọc có vai trò để xác định xem một đặc điểm cụ thể có xuất hiện trong một hình ảnh hay không. Bộ lọc tích chập dựa trên một thao tác rất đơn giản đó là nhân liên tục các phần tử ma trận rồi cộng các kết quả. Để hiểu cách hoạt động của bộ lọc, bạn đọc có thể xem xét một ví dụ đơn giản về hình ảnh có kích thước 4 × 3:

\begin{align}
\text{Ảnh } =  

\begin{bmatrix} 
a_{11} & a_{12} & a_{13} \\
a_{21} & a_{22} & a_{23} \\
a_{31} & a_{32} & a_{33} \\
a_{41} & a_{42} & a_{43} \\
\end{bmatrix}

\end{align}

Một bộ lọc tích chập kích thước 2 × 2 tương ứng với một ma trận có kích thước tương ứng:
\begin{align}
\text{Bộ lọc tích chập } =  

\begin{bmatrix} 
\alpha & \beta \\
\gamma & \delta \\
\end{bmatrix}
\end{align}

Bức ảnh sau khi được tích chập với bộ lọc sẽ là một ma trận kích thước $3 \times 3$ được tính toán như sau
\begin{align}
\text{Ảnh được tích chập} =  

\begin{bmatrix} 
\alpha \cdot a_{11} + \beta \cdot a_{12} + \gamma \cdot a_{21} + \delta \cdot a_{22} & \alpha \cdot a_{12} + \beta \cdot a_{13} + \gamma \cdot a_{22} + \delta \cdot a_{23} \\
\alpha \cdot a_{21} + \beta \cdot a_{22} + \gamma \cdot a_{31} + \delta \cdot a_{32} & \alpha \cdot a_{22} + \beta \cdot a_{23} + \gamma \cdot a_{32} + \delta \cdot a_{33} \\
\alpha \cdot a_{31} + \beta \cdot a_{32} + \gamma \cdot a_{41} + \delta \cdot a_{42} & \alpha \cdot a_{32} + \beta \cdot a_{33} + \gamma \cdot a_{42} + \delta \cdot a_{43} \\
\end{bmatrix}
\end{align}

Bức ảnh được tính chập là một ma trận kích thước $3 \times 2$ với phần tử trên cùng bên trái thu được từ việc nhân từng phần tử trong ma trận bộ lọc với phần tử tương ứng ở ma trận con kích thước $2 \times 2$ trên cùng bên trái của hình ảnh ban đầu và sau đó cộng các kết quả lại. Các phần tử khác thu được theo cách tương tự: bộ lọc tích chập được áp dụng cho mọi ma trận con kích thước $2 \times 2$ của ảnh gốc để thu được ảnh tích chập. Nếu ma trận con 2 × 2 của ảnh ban đầu giống với bộ lọc thì phép tích chập sẽ dẫn đến giá trị lớn trong kết quả, ngược lại, nếu ma trận con không giống như bộ lọc, giá trị trong kết quả sẽ nhỏ. Chính vì lý do này, phép tích chập ảnh sẽ làm nổi bật các vùng của hình ảnh gốc giống với bộ lọc tích chập. Các bộ lọc tích chập nói chung là các mảng nhỏ có kích thước $k_1 \times k_2$, với $k_1$ và $k_2$ là các số nguyên dương nhỏ không nhất thiết phải bằng nhau. Bức ảnh ban đầu có kích thước $n_1 \times n_2$ thì ảnh tích chập sẽ có kích thước tương ứng là $(n_1 - k_1 + 1) \times (n_2 - k_2 + 1)$.

<div class="figure">
<img src="12-1-Cac-mo-hinh-mang-noron-dien-hinh_files/figure-html/fgdl002-1.png" alt="Bộ lọc tích chập làm nổi bật các cạnh có hình ảnh giống với bộ lọc. Hình phía trên bên trái: Hình ảnh ban đầu. Hình phía trên bên phải: Bộ lọc là ma trận kích thước 15 * 15 có tất cả các giá trị bằng không ngoại trừ hàng thứ bảy. Hình phía dưới bên trái: Bộ lọc là ma trận kích thước 15 * 15 có tất cả các giá trị bằng không ngoại trừ cột thứ bảy. Hình phía dưới bên phải: Bộ lọc là ma trận kích thước 15 * 15 có tất cả các giá trị bằng không ngoại trừ đường chéo chính." width="672" />
<p class="caption">(\#fig:fgdl002)Bộ lọc tích chập làm nổi bật các cạnh có hình ảnh giống với bộ lọc. Hình phía trên bên trái: Hình ảnh ban đầu. Hình phía trên bên phải: Bộ lọc là ma trận kích thước 15 * 15 có tất cả các giá trị bằng không ngoại trừ hàng thứ bảy. Hình phía dưới bên trái: Bộ lọc là ma trận kích thước 15 * 15 có tất cả các giá trị bằng không ngoại trừ cột thứ bảy. Hình phía dưới bên phải: Bộ lọc là ma trận kích thước 15 * 15 có tất cả các giá trị bằng không ngoại trừ đường chéo chính.</p>
</div>

Hình \@ref(fgdl002) minh họa ứng dụng của bộ lọc tích chập cho một hình ảnh bao gồm các đường kẻ ngang, kẻ dọc và các đường chéo được hiển thị ở góc phía trên bên trái. Mỗi bộ lọc tích chập là một ma trận $15 \times 15$ chứa tất cả giá trị bằng 0 (màu đen) và một dải các số 1 (màu trắng) được định hướng theo chiều dọc, chiều ngang, hoặc đường chéo trong ảnh.

- Hình phía trên bên phải có ma trận bộ lọc có dải số 1 nằm ở cột thứ bảy trong khi tất cả các giá trị còn lại là số 0. Bạn đọc có thể nhận thấy rằng hình ảnh sau khi lọc có các đường nằm ngang và đường chéo đã bị làm mờ trong khi các đường thẳng (giống với hình ảnh bộ lọc) vẫn giữ nguyên được độ nét. 

- Hình phía dưới bên trái có ma trận bộ lọc có dải số 1 nằm ở hàng thứ bảy trong khi tất cả các giá trị còn lại là số 0. Bạn đọc có thể nhận thấy rằng hình ảnh sau khi lọc có các đường dọc và đường chéo đã bị làm mờ trong khi các đường ngang vẫn giữ nguyên được độ nét. 

- Sau cùng, hình phía dưới bên phải có ma trận bộ lọc có dải số 1 nằm ở đường chéo chính của ma trận trong khi tất cả các giá trị còn lại là số 0. Bạn đọc có thể nhận thấy rằng hình ảnh sau khi lọc có các đường chéo chính và các đường song song với đường chéo chính vẫn giữ nguyên được độ nét trong khi tất cả các đường khác đều đã bị làm mờ.

Trong mạng CNN, chúng ta có thể coi các hệ số của ma trận lọc là các tham số đi từ lớp đầu vào đến lớp ẩn, với một đơn vị ẩn tương ứng với một pixel trong ảnh tích chập. Tuy nhiên, không giống như một mô hình mạng neural network thông thường, không phải tất cả các đơn vị trong lớp đầu vào đều được kết nối đến tất cả các đơn vị trong lớp ẩn.

Kích thước của bộ lọc thường được lựa chọn để phù hợp với kích thước của ảnh. Các bức ảnh trong hình \@ref(fgdl002) có kích thước $500 \times 500$ và bộ lọc có kích thước là $15 \times 15$. Đối với dữ liệu CIFAR100, các bức ảnh có kích thước $32 \times 32$ do đó bộ lọc tích chập có kích thước $3 \times 3$ là phù hợp. Một lưu ý đó là các bức ảnh trong dữ liệu CIFAR100 là bức ảnh màu được biểu thị qua ba kênh (channel) thay vì một kênh duy nhất như các bức ảnh đen trắng. Mỗi kênh của bức ảnh màu là một ma trận kích thước $32 \times 32$ đại diện cho một màu đỏ, xanh lá cây, hoặc xanh lam.

Để tương thích với ba kênh của một bức ảnh màu, bộ lọc tích chập đối với những bức ảnh này cũng sẽ có ba kênh, mỗi kênh có kích thước $3 \times 3$, với các hệ số của ma trận tích chập trong mỗi kênh có thể khác nhau. Kết quả của ba phép tích chập là ba ma trận có cùng kích thước sẽ được cộng lại lấy tổng để tạo thành một ma trận duy nhất. Nói cách khác, nếu chúng ta sử dụng $K$ bộ lọc, mỗi bộ lọc bao gồm ba kênh mà mỗi kênh là một ma trận kích thước $3 \times 3$, chúng ta sẽ có lớp ẩn thứ nhất có $K$ kênh mà mỗi kênh là một ma trận hai chiều.

Hàm kích hoạt thường được sử dụng trong mạng CNN là hàm ReLU. Trong nhiều trường hợp việc áp dụng hàm ReLU còn được coi như một lớp riêng biệt trong mạng nơ-ron tích chập. Chúng ta sẽ thảo luận về vấn đề này trong phần thực hành.












Hiệu quả của deep learning trong chương này khá ấn tượng. Nó đã giải quyết được vấn đề phân loại chữ số và các CNN sâu đã thực sự cách mạng hóa việc phân loại hình ảnh. Chúng tôi xem báo cáo hàng ngày về những câu chuyện thành công mới về học sâu. Nhiều trong số này liên quan đến các nhiệm vụ phân loại hình ảnh, chẳng hạn như chẩn đoán máy chụp quang tuyến vú hoặc hình ảnh X-quang kỹ thuật số, quét mắt nhãn khoa, chú thích quét MRI, v.v. Tương tự như vậy, RNN đã đạt được rất nhiều thành công trong việc dịch ngôn ngữ và giọng nói, dự báo và mô hình hóa tài liệu. Câu hỏi đặt ra sau đó là: chúng ta có nên loại bỏ tất cả các công cụ cũ hơn và sử dụng deep learning cho mọi vấn đề với dữ liệu không? Để giải quyết câu hỏi này, chúng tôi xem lại tập dữ liệu Hitters từ Chương 6. Đây là một bài toán hồi quy, trong đó mục tiêu là dự đoán Mức lương của một cầu thủ bóng chày năm 1987 bằng cách sử dụng số liệu thống kê hiệu suất của anh ta từ năm 1986. Sau khi loại bỏ những cầu thủ thiếu câu trả lời, chúng tôi còn lại 263 người chơi và 19 biến. Chúng tôi chia ngẫu nhiên dữ liệu thành tập huấn luyện gồm 176 người chơi (hai phần ba) và tập thử nghiệm gồm 87 người chơi (một phần ba). Chúng tôi đã sử dụng ba phương pháp để tạo mô hình hồi quy cho những dữ liệu này. • Một mô hình tuyến tính được sử dụng để tính toán dữ liệu huấn luyện và đưa ra dự đoán về dữ liệu thử nghiệm. Mô hình có 20 tham số. • Mô hình tuyến tính tương tự được thực hiện với phép điều chỉnh Lasso. Tham số điều chỉnh được chọn bằng cách xác thực chéo 10 lần trên dữ liệu huấn luyện. Nó đã chọn một mô hình với 12 biến có hệ số khác 0. • Một mạng lưới thần kinh với một lớp ẩn bao gồm 64 đơn vị ReLU được kết nối với dữ liệu. Model này có 1.345 thông số.



Chương sách này thảo luận một chủ đề quan trọng có ứng dụng rộng rãi nhất trong lĩnh vực trí tuệ nhân tạo là mô hình mạng học sâu (deep learning). Tại thời điểm nhóm tác giả viết cuốn sách (2023), học sâu là một lĩnh vực nghiên cứu tích cực nhất không chỉ trong khoa học máy tính, công nghệ thông tin mà còn cả trong các lĩnh vực khác như kinh tế, tài chính, y tế, xây dựng,... Nền tảng của mô hình mạng học sâu là mô hình mạng nơ-ron (hay neural network). Mô hình mạng nơ-ron đã được biết đến đến rộng rãi vào cuối những năm 1980 bởi cách vận hành của mô hình mô tả lại cách thức mà hệ thống thần kinh của con người xử lý thông tin. Mặc dù các đặc tính của mô hình mạng nơ-ron được phân tích bởi những nhà toán học và nhà thống kê nhiều thuật toán liên quan đến mô hình này đã được cải thiện với sự ra đời của các phương pháp học máy khác như SVM, rừng ngẫu nhiên, học tăng cường,..., mà mô hình mạng nơ-ron phần nào không được ưa chuộng.

Từ những năm 2010, với nhu cầu xử lý các dữ liệu ngày càng phức tạp và sự ra đời của các kiến trúc máy tính lớn, mô hình mạng nơ-ron đã quay trở lại với tên mới là mạng học sâu (deep learning). Mạng học sâu vượt trội hoàn toàn các mô hình học máy thông thường trong phân loại hình ảnh/video và mô hình hóa ngôn ngữ tự nhiên bao gồm dữ liệu kiểu văn bản và giọng nói (natural langugue processing hay NLP). Các nhà khoa học trong lĩnh vực này tin rằng lý do chính cho những thành công của mô hình mạng nơ-ron là càng ngày những người xây dựng mô hình càng chú trọng vào xây dựng các bộ dữ liệu khổng lồ để huấn luyện môn hình và cấu trúc của mô hình cho phép nó đáp ứng được với bất kỳ tập kích thước dữ liệu nào.

<!-- ## Mạng nơ-rơn có một lớp ẩn {#nnonelayer} -->
<!-- Mô hình mạng nơ-ron lấy một véc-tơ đầu vào gồm $p$ biến $\textbf{X} = (X_1, X_2, \cdots , X_p)$ và xây dựng một hàm phi tuyến $\hat{f}$ để dự đoán biến mục tiêu $Y$ . Chúng ta đã xây dựng các mô hình dự đoán phi tuyến trong các chương trước, ví dụ như mô hình cộng tính tổng quát, mô hình cây quyết định, mô hình rừng ngẫu nhiên, mô hình tăng cường. Điều làm nên sự khác biệt của mô hình mạng nơ-ron là cấu trúc xây dựng của mô hình. Hình \@ref(fig:fgnn001) mô tả một mạng nơ-ron chuyển tiếp để mô hình biến mục tiêu $Y$ định lượng từ $p = 3$ biến giải thích là $X_1$, $X_2$, và $X_3$.  -->

<!-- ```{r fgnn001, warning = FALSE, message=FALSE, echo=FALSE,fig.cap = "Mô hình mạng nơ-ron có p = 3 đơn vị trong lớp đầu vào, một lớp ẩn có năm đơn vị, và một đơn vị đầu ra."} -->
<!-- draw_neural_network(c(3,5,1),showall = TRUE) -->
<!-- ``` -->

<!-- Theo thuật ngữ chuyên môn, ba biến giải thích $X_1$, $X_2$, và $X_3$ là các đơn vị (unit) của lớp đầu vào (input layer). Các mũi tên được dùng để mô tả rằng mỗi đơn vị đầu vào sẽ chuyển tiếp thông tin vào $k = 5$ đơn vị của lớp ẩn (hidden layer) được ký hiệu là $H_i$ với $i = 1, 2, \cdots, k$. Dạng của hàm $f$ trong mô hình mạng nơ-ron nhân tạo sẽ được viết như sau: -->
<!-- \begin{align} -->
<!-- f(\textbf{X}) & = \beta_0 + \sum\limits_{i = 1}^k \beta_i \cdot h_i\left(\textbf{X}\right) \\ -->
<!-- & = \beta_0 + \sum\limits_{i = 1}^k \beta_i \cdot g\left(w_{i,0} + \sum\limits_{j=1}^p w_{i,j} \cdot X_j\right) -->
<!-- (#eq:nn001) -->
<!-- \end{align} -->
<!-- trong đó $g$ là một hàm số phi tuyến được xác định trước, được gọi theo thuật ngữ chuyên môn là các hàm kích hoạt (activation function). Các $\beta_i$ và $w_{i,j}$ là các hằng số và cũng là các tham số cần được ước lượng của mô hình. Hàm $f$ trong phương trình \@ref(eq:nn01) được xây dựng theo hai bước:  -->

<!-- - Bước thứ nhất, các đơn vị $H_i$ trong lớp ẩn được tính bằng hàm kích hoạt tính trên tổ hợp tuyến tính của các biến đầu vào: -->

<!-- \begin{align} -->
<!-- H_i = g\left(w_{i,0} + \sum\limits_{j=1}^p w_{i,j} \cdot X_j\right) -->
<!-- (#eq:nn002) -->
<!-- \end{align} -->

<!-- - Bước thứ hai, $k$ đơn vị của lớp ẩn là yếu tố đầu vào để tính toán giá trị biến đầu ra định lượng: -->
<!-- \begin{align} -->
<!-- Y = \beta_0 + \sum\limits_{i = 1}^k \beta_i \cdot H_i -->
<!-- (#eq:nn003) -->
<!-- \end{align} -->

<!-- Quá trình tính toán đi từ lớp đầu vào qua các lớp ẩn và kết thúc ở mạng đầu ra được gọi là quá trình chuyển tiếp, và hàm $f$ trong phương trình \@ref(eq:nn001) được gọi là một mạng nơ-ron chuyển tiếp. Tất cả các tham số $\beta_0$, $\beta_1$, $\cdots$, $\cdots$ , $\beta_k$ và $w_{1,0}$ , $\cdots$ , $w_{k,p}$ được ước lượng từ dữ liệu. Các hàm kích hoạt thường được sử dụng là hàm Sigmoid và hàm ReLU. Hàm sigmoid là hàm được thường xuyên sử dụng trong hồi quy logistic để chuyển hàm tuyến tính thành xác suất giữa 0 và 1 trong khi hàm ReLU là hàm phi tuyến được xây dựng một cách đơn giản nhất nhằm mục đích dễ dàng tuyến tính trong các mạng phức tạp. -->
<!-- \begin{align} -->
<!-- \text{Sigmoid: } & g(x) = \cfrac{e^x}{1 + e^{x}} = \cfrac{1}{1 + e^{-x}} \\ -->
<!-- \text{ReLU: } & g(x) = max(x , 0) = (x)^+ -->
<!-- \end{align} -->

<!-- ```{r fgnn002, warning = FALSE, message=FALSE, echo = FALSE, fig.cap = "Hàm kích hoạt sigmoid và hàm kích hoạt ReLU. Hàm Sigmoid có đạo hàm tại mọi điểm trong khi hàm ReLU không có đạo hàm tại 0"} -->
<!-- ggplot(data.frame(x = seq(-3, 3, length=1000)), aes(x)) + -->
<!--   stat_function(aes(color = "Hàm ReLU"), fun=function(x) ifelse(x>0,x,0))+ -->
<!--   stat_function(aes(color = "Hàm Sigmoid"), fun=function(x) 1/(1+exp(-x)))+ -->
<!--   theme_classic()+ -->
<!--   scale_color_manual(values=c("black","blue"))+geom_vline(xintercept = 0, linetype = 2, color = "grey90") -->
<!-- ``` -->

<!-- Hình \@ref(fig:fgnn002) mô tả giá trị của hàm Sigmoid và hàm ReLU trên đoạn từ -4 đến 4. Trong thời kỳ đầu của mô hình mạng nơ-ron, hàm Sigmoid được ưa chuộng vì hàm số này có đạo hàm liên tục tại mọi giát trị của $x$. Sau đó, hàm ReLU lại là lựa chọn ưa thích trong các mô hình mạng nơ-ron hiện đại vì hàm số này đơn giản, dễ tính toán và cho hiệu quả tốt hơn so với hàm Sigmoid.  -->

<!-- Có thể tóm tắt lại mô hình được mô tả trong Hình \@ref(fig:fgnn001) như sau: từ 3 biến giải thích ban đầu là $X_1$, $X_2$, và $X_3$ chúng ta tạo ra năm biến giải thích mới là $H_1$, $H_2$, $H_3$, $H_4$ và $H_5$ được tính toán bằng giá trị của hàm kích hoạt $g(.)$ trên các tổ hợp tuyến tính của các biến giải thích ban đầu. Sau đó chúng ta sử dụng năm biến giải thích $H_i$, $i = 1, 2, 3, 4, 5$ để xây dựng một mô hình hồi quy tuyến tính mà trong đó biến phụ thuộc là $Y$. Tham số của các mô hình bao gồm các hệ số $w_{i,j}$ để tính các biến $H_i$, và các hệ số $\beta_j$ trong mô hình hồi quy tuyến tính $Y$ theo các biến $H$. -->

<!-- Mô hình có tên là mạng nơ-ron bởi vì cấu trúc của mô hình bao gồm các đơn vị $H_i$ hoạt động giống như các tế bào thần kinh trong não bộ của con người. Các đơn vị $H_i$ xấp xỉ hoặc bằng 0 giống như các tế bào thần kinh im lặng (slient neuron), những tế bào ít bị kích hoạt trong quá trình lan truyền thông tin, trong khi các đơn vị $H_i$ lớn (khi sử dụng hàm ReLU), hoặc xấp xỉ 1 (khi sử dụng hàm Sigmoid) giống như những tế bào bị kích hoạt mạng trong quá trình lan truyền thông tin. -->

<!-- Sử dụng các hàm kích hoạt $g(.)$ phi tuyến là đặc biệt quan trọng tong vì nếu không hàm $f$ sẽ suy biến thành mô hình tuyến tính thông thường với $p = 3$ biến giải thích trong $X_1$, $X_2$, và $X_3$. Ngoài ra, hàm kích hoạt phi tuyến cho phép mô hình mạng nơ-ron mô tả được những mối liên hệ phi tuyến và phức tạp giữa các biến giải thích $\textbf{X}$ và biến mục tiêu $Y$.  -->

<!-- Giả sử trong mô hình mạng nơ-ron được mô tả trong Hình \@ref(fig:fgnn001), chúng ta có hàm kích hoạt $g(x) = x^2$ và giá trị của các hệ số $\boldsymbol{\beta} = (\beta_0, \beta_1, \beta_2, \beta_3, \beta_4, \beta_5)$ và $w_{i,j}$, với $1 \leq i \leq 5$ và $0 \leq j \leq 3$, được cho như sau -->
<!-- \begin{align} -->
<!-- & \text{hệ số chặn: } \beta_0 = w_{1,0} = w_{2,0} = w_{3,0} = w_{4,0} = w_{5,0} 0 \\ -->
<!-- & \\ -->
<!-- & \begin{pmatrix}  -->
<!-- \beta_1 \\ -->
<!-- \beta_2 \\ -->
<!-- \beta_3 \\ -->
<!-- \beta_4 \\ -->
<!-- \beta_5 -->
<!-- \end{pmatrix} = \begin{pmatrix}  -->
<!-- 0.5 \\ -->
<!-- 0.5 \\ -->
<!-- 0.5 \\ -->
<!-- 1 \\ -->
<!-- 2 -->
<!-- \end{pmatrix} \ \text{ và } \ \begin{pmatrix}  -->
<!-- w_{1,1} & w_{1,2} & w_{1,3} \\ -->
<!-- w_{2,1} & w_{2,2} & w_{2,3} \\ -->
<!-- w_{3,1} & w_{3,2} & w_{3,3} \\ -->
<!-- w_{4,1} & w_{4,2} & w_{4,3} \\ -->
<!-- w_{5,1} & w_{5,2} & w_{5,3} -->
<!-- \end{pmatrix} = \begin{pmatrix}  -->
<!-- 1 & -1 & 1 \\ -->
<!-- 1 & 2 & -1 \\ -->
<!-- 0 & 0 & 0 \\ -->
<!-- 0 & 0 & 0 \\ -->
<!-- 0 & 0 & 0 -->
<!-- \end{pmatrix} -->
<!-- (#eq:nn004) -->
<!-- \end{align} -->

<!-- Trước hết, để tránh sự phức tạp chúng tôi cho giá trị các hàng 3, 4, và 5 của ma trận $\boldsymbol{w}$ đều bằng 0, điều này dẫn đến giá trị tại các đơn vị $H_3$, $H_4$ và $H_5$ của lớp ẩn sẽ bằng 0. Các đơn vị này hoạt động như các tế bào im lặng trong mạng nơ-rơn và không có ảnh hưởng đến biến mục tiêu $Y$. Chúng ta có giá trị tại $H_1$ và $H_2$ được tính theo các biến giải thích và hàm kích hoạt: -->
<!-- - Giá trị tại $H_1$ -->
<!-- \begin{align} -->
<!-- H_1\left(X_1, X_2, X_3\right) & = g\left(w_{1,1} \cdot X_1 + w_{1,2} \cdot X_2 + w_{1,3} \cdot X_3\right) \\ -->
<!-- & = \left(w_{1,1} \cdot X_1 + w_{1,2} \cdot X_2 + w_{1,3} \cdot X_3\right)^2 \\ -->
<!-- & = \left(X_1 - X_2 + X_3\right)^2 -->
<!-- (#eq:nn005) -->
<!-- \end{align} -->

<!-- - Giá trị tại $H_2$ -->
<!-- \begin{align} -->
<!-- H_2 \left(X_1, X_2, X_3\right) & = g\left(w_{2,1} \cdot X_1 + w_{2,2} \cdot X_2 + w_{2,3} \cdot X_3\right) \\ -->
<!-- & = \left(w_{2,1} \cdot X_1 + w_{2,2} \cdot X_2 + w_{2,3} \cdot X_3\right)^2 \\ -->
<!-- & = \left(X_1 + 2 \cdot X_2 - X_3\right)^2 -->
<!-- (#eq:nn006) -->
<!-- \end{align} -->

<!-- Giá trị của hàm số $f(\text{X})$ là đầu ra của mạng nơ-ron được xác định như sau: -->
<!-- \begin{align} -->
<!-- f(X_1, X_2, X_3) & = 0.5 \cdot H_1\left(X_1, X_2, X_3\right) + 0.5 \cdot H_2 \left(X_1, X_2, X_3\right) \\ -->
<!-- & = X_1^2 + 2.5 \cdot X_2^2 + X_3^2 + X_1 \cdot X_2 - 3 \cdot X_2 \cdot X_3 -->
<!-- (#eq:nn007) -->
<!-- \end{align} -->

<!-- Bạn đọc có thể thấy rằng, việc sử dụng hàm kích hoạt phi tuyến cho phép chúng ta có hàm đầu ra bao gồm hàm phi tuyến trên các giá trị biến đầu vào, mà còn tính đến cả biến tương tác giữa các biến ban đầu. Trong ví dụ ở phương trình \@ref(eq:nn007) là các giá trị $X_1 \cdot X_2$ và $3 \cdot X_2 \cdot X_3$. Trong thực tế, chúng ta sẽ không sử dụng hàm bậc hai hay hàm đa thức cho hàm kích hoạt $g(.)$ do hàm kích hoạt đa thức sẽ dẫn tới kết quả cũng chỉ là dạng hàm đa thức. Các hàm kích hoạt Sigmoid hoặc ReLU không bị giới hạn như vậy.  -->

<!-- Trong ví dụ trên chúng ta đã cho trước các tham số bao gồm các hệ số $\boldsymbol{\beta}$ và ma trận $\boldsymbol{w}$. Tuy nhiên trong thực tế, các tham số này được lựa chọn để giảm thiểu sai số giữa giá trị dự đoán và giá trị quan sát của biến mục tiêu: -->
<!-- \begin{align} -->
<!-- (\hat{\boldsymbol{\beta}},\hat{\boldsymbol{w}}) = \underset{\boldsymbol{\beta},\boldsymbol{w}}{\operatorname{argmin}} \sum\limits_{i=1}^n \left( y_i - f(\textbf{x}_i) \right)^2 -->
<!-- (#eq:nn008) -->
<!-- \end{align} -->

<!-- Chúng ta sẽ thảo luận về ước lượng tham số cho mô hình mạng nơ-ron trong phần \@ref(nnestimation). -->

<!-- ## Mạng nơ-ron có nhiều lớp ẩn {#nnmultilayer} -->
<!-- Mô hình mạng nơ-ron được sử dụng hiện tại thường có nhiều hơn một lớp ẩn và có nhiều đơn vị trên mỗi lớp. Về lý thuyết, một lớp ẩn duy nhất với số lượng lớn các đơn vị có khả năng xấp xỉ hầu hết các dạng hàm $f$. Tuy nhiên, thực tế chỉ ra rằng xây dựng những cấu trúc nhiều lớp và mỗi lớp có kích thước hợp lý là giải pháp tốt hơn so với cấu trúc chỉ có một lớp ẩn và có rất nhiều đơn vị trên cùng một lớp. -->

<!-- Cấu trúc có thể mở rộng của mô hình mạng nơ-ron nhân tạo cho phép nó có khả năng mô hình hóa tốt những bộ dữ liệu phức tạp, mà điển hình là dữ liệu dạng ảnh, dạng văn bản, hay dạng tín hiệu. Để minh họa cho khả năng phù hợp của mô hình với những dữ liệu phức tạp, chúng ta sẽ xây dựng một cấu trúc mạng nơ-ron có nhiều lớp ẩn để dự đoán dữ liệu là ảnh chứa các chữ số viết tay. Dữ liệu được sử dụng để huấn luyện mô hình là tập dữ liệu chữ số viết tay nổi tiếng $\textbf{MNIST}$. Hình \@ref(fig:fgnn003) minh họa một số quan sát trong dữ liệu về các chữ số viết tay được lưu trữ trong dữ liệu $\textbf{MNIST}$. Mỗi quan sát của dữ liệu sử dụng để xây dựng mô hình là một hình ảnh có kích thước $p = 28 \times 28 = 784$ pixel và biến mục tiêu là giá trị số của hình ảnh xuất hiện trong biến giải thích. Có tất cả 10 giá trị khác nhau cho biến mục tiêu là các chữ số viết tay tương ứng từ 0 đến 9. -->

<!-- ```{r fgnn003, warning = FALSE, message=FALSE, fig.align='center',echo = FALSE, fig.cap = "Năm mươi giá trị đầu tiên trong dữ liệu số viết tay MNIST. Mỗi số viết tay là một quan sát trong dữ liệu. Một bức ảnh được lưu dưới dạng một véc-tơ có độ dài p = 784. Mỗi giá trị trong véc-tơ là một số tự nhiên nhận giá trị từ 0 đến 255 cho biết độ tối của điểm ảnh."} -->
<!-- mnist<-readRDS("small_train_mnist.rds") -->
<!-- par(mfrow = c(5,10), xaxt='n', yaxt='n', ann=FALSE, mar = c(0,0,0,0)+0.05) -->
<!-- for (i in 1:50){ -->
<!--   M<-matrix(mnist$x[i,,],28,28) -->
<!--   M<-M[28:1,] -->
<!--   image(t(M),col = gray(255:0/255) ) -->
<!-- } -->
<!-- ``` -->

<!-- Ý tưởng là xây dựng một mô hình để phân loại các hình ảnh thành chữ số từ 0 đến 9. Chúng ta sẽ sử dụng cấu trúc mạng nơ-ron với hai lớp ẩn được minh họa trong Hình \@ref(fig:fgnn004) để xây dựng mô hình phân loại hình ảnh số viết tay. -->

<!-- ```{r fgnn004, warning = FALSE, message=FALSE, fig.align='center',echo = FALSE, fig.cap = "Mạng nơ-ron xây dựng trên dữ liệu MNIST có hai lớp ẩn, mỗi lớp ẩn có nhiều đơn vị và lớp đầu ra có 10 đơn vị tương ứng với m = 10 giá trị có thể của các số viết tay từ 0 đến 9. Lớp đầu vào có p = 784 đơn vị tương ứng với 784 điểm ảnh."} -->
<!-- draw_neural_network(c(8,6,5,4),showall = FALSE, w = 8, h = 6, lsize = 1) -->
<!-- ``` -->

<!-- Giá trị đầu ra trong cấu trúc mạng nơ-ron trong Hình \@ref(fig:fgnn004) là biến kiểu factor, được biểu thị bằng véc-tơ $\textbf{Y} = (Y_1, Y_2, \cdots , Y_{m})$ với $m = 10$. Dữ liệu \textbf{MNIST} có 60 nghìn bức ảnh được sử dụng để huấn luyện mô hình và 10 nghìn bức ảnh được sử dụng để kiểm tra mô hình. Cấu trúc mạng trong Hình \@ref(fig:fgnn004) có hai lớp ẩn thay vì một lớp ẩn giống như trước.  -->

<!-- - Lớp ẩn thứ nhất có $k_1$ đơn vị được tính toán từ $p$ đầu vào ban đầu với hàm kích hoạt $g_1(.)$. Giả sử các nút trong lớp ẩn đầu tiên lần lượt là $H^{(1)}_1$, $H^{(1)}_2$, $\cdots$, $H^{(1)}_{k_1}$. Ta có $H^{(1)}_j$ được tính toán từ các đầu vào với $(p+1)$ tham số $w^{(1)}_{j,i}$ với $0 \leq i \leq p$ như sau: -->
<!-- \begin{align} -->
<!-- H^{(1)}_j = g_1\left( w^{(1)}_{j,0} + w^{(1)}_{j,1} X_1 + w^{(1)}_{j,2} X_2 + \cdots + w^{(1)}_{j,p} X_p \right)  -->
<!-- (#eq:nn009) -->
<!-- \end{align} -->
<!-- Có thể thấy rằng, để tính toán tất cả $k_1$ đơn vị trong lớp ẩn thứ nhất, chúng ta cần sử dụng $k_1 \times (p+1)$ tham số.  -->

<!-- - Lớp ẩn thứ hai có $k_2$ đơn vị được tính toán từ $k_1$ đơn vị của lớp ẩn thứ nhất và hàm kích hoạt $g_2(.)$. Gọi các nút trong lớp ẩn thứ hai lần lượt là $H^{(2)}_1$, $H^{(2)}_2$, $\cdots$, $H^{(2)}_{k_2}$. Ta có $H^{(2)}_j$ được tính toán từ lớp ẩn thứ nhất vào với $(k_1+1)$ tham số $w^{(2)}_{j,i}$ với $0 \leq i \leq k_1$ như sau: -->
<!-- \begin{align} -->
<!-- H^{(2)}_j = g_2\left( w^{(2)}_{j,0} + w^{(2)}_{j,1} H^{(2)}_1 + w^{(2)}_{j,2} H^{(2)}_1 + \cdots + w^{(2)}_{j,k_1} H^{(2)}_{k_1} \right)  -->
<!-- (#eq:nn010) -->
<!-- \end{align} -->
<!-- Để tính toán tất cả $k_2$ đơn vị trong lớp ẩn thứ hai, chúng ta cần sử dụng $k_2 \times (k_1+1)$ tham số.  -->

<!-- - Trong lớp đầu ra, do đây là bài toán phân loại, nên chúng ta sử dụng $m = 10$ đơn vị tương ứng với 10 chữ số viết tay từ 0 đến 9. Trong bài toán phân loại, hàm kích hoạt để tính toán các đơn vị trong lớp đầu ra thường là hàm softmax. Giá trị tại đơn vị $Y_j$ với $1 \leq m$ trong lớp đầu ra được xác định như sau: -->
<!-- \begin{align} -->
<!-- Z_j &= \beta_{j,0} + \beta_{j,1} H^{(2)}_1 + \beta_{j,2} H^{(2)}_2 + \cdots +\beta_{j,k_2} H^{(2)}_{k_2} \\ -->
<!-- \textbf{Y} &= softmax(\textbf{Z}) \rightarrow Y_j = \cfrac{exp(Z_j)}{exp(Z_1) + exp(Z_2) + \cdots + exp(Z_m)} -->
<!-- (#eq:nn011) -->
<!-- \end{align} -->
<!-- Để tính toán $m$ đơn vị trong lớp đầu ra, chúng ta cần $m \times (k_2 + 1)$ tham số. Lưu ý rằng khi sử dụng hàm softmax thì tổng giá trị của các đơn vị trong lớp đầu ra luôn bằng 1. -->

<!-- Như vậy, để tính toán được $m = 10$ giá trị đầu ra cho cấu trúc mạng nơ-ron được trình bày trong Hình \@ref(fig:fgnn004), số lượng tham số cần sử dụng là -->
<!-- \begin{align} -->
<!-- k_1 \cdot (p + 1) + k_2 \cdot (k_1 + 1) + m \cdot (k_2+1) -->
<!-- \end{align} -->

<!-- Ví dụ, nếu chúng ta sử dụng 512 đơn vị trong lớp ẩn thứ nhất và 256 đơn vị trong lớp ẩn thứ hai, số lượng tham số của mạng nơ-ron với 784 đơn vị đầu vào và 10 đơn vị đầu ra là  -->
<!-- \begin{align} -->
<!-- 512 \cdot (784 + 1) + 256 \cdot (512 + 1) + 10 \cdot (256 + 1) = 535.818 -->
<!-- \end{align} -->
<!-- Nói cách khác, mô hình sử dụng hơn 500 nghìn tham số để tính toán 10 đơn vị đầu ra từ 784 đơn vị đầu vào. Các tham số này được tính toán sao cho sai số giữa véc-tơ đầu ra tính toán từ mô hình và giá trị đầu ra quan sát được trên dữ liệu là nhỏ nhất. Trong bài toán phân loại, sai số thường được sử dụng là hàm cross-entropy. Với quan sát thứ $i$ của biến giải thích $\textbf{x}_i$ thì quan sát $y_i$ tương ứng của biến mục tiêu (nhận một trong các giá trị từ $1$ đến $m$) sẽ được viết dưới dạng véc-tơ đầu ra $\textbf{y}_i = (y^{i}_{1},y^i_2,\cdots,y^i_m)$ sao cho -->
<!-- \begin{align} -->
<!-- y^i_j &= 1 \text{ nếu } y_i = j \\ -->
<!-- y^i_j &= 0 \text{ nếu } y_i \neq j -->
<!-- (#eq:nn012) -->
<!-- \end{align} -->
<!-- Cách biến đổi biến này thường được gọi là one-hot encoding. Với véc-tơ đầu ra được tính toán từ véc-tơ đầu vào $\textbf{x}_i$ theo cấu trúc mạng nơ-ron bằng các phương trình \@ref(eq:nn009), \@ref(eq:nn010), và \@ref(eq:nn011) là $\hat{\textbf{y}}_i = (\hat{y}^{i}_{1},\hat{y}^i_2,\cdots,\hat{y}^i_m)$ thì sai số tính bằng cross-entropy tại quan sát thứ $i$ là -->
<!-- \begin{align} -->
<!-- \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \log(\hat{y}^{i}_{j}) = y^{i}_{1} \cdot \log(\hat{y}^{i}_{1}) + y^{i}_{2} \cdot \log(\hat{y}^{i}_{2}) + \cdots + y^{i}_{m} \cdot \log(\hat{y}^{i}_{m}) -->
<!-- (#eq:nn013) -->
<!-- \end{align} -->
<!-- và sai số tính bằng cross-entropy trên $n$ dữ liệu huấn luyện mô hình là -->
<!-- \begin{align} -->
<!-- CE\_loss = \sum\limits_{i=1}^n \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \log(\hat{y}^{i}_{j}) -->
<!-- (#eq:nn014) -->
<!-- \end{align} -->

<!-- Trong mô hình mạng nơ-ron, để đơn giản hóa ký hiệu, chúng ta sẽ sử dụng ký hiệu dạng ma trận. Cấu trúc mạng nơ-ron có hai lớp ẩn được mô tả trong hình \@ref(fig:fgnn004) có ba ma trận tham số $\boldsymbol{w}_1$, $\boldsymbol{w}_2$, và $\boldsymbol{\beta}$ được định nghĩa như sau -->
<!-- \begin{align} -->
<!-- \boldsymbol{\beta} &= \begin{pmatrix} -->
<!-- \beta_{1,0} & \beta_{1,1} & \cdots & \beta_{1,k_2} \\ -->
<!-- \beta_{2,0} & \beta_{2,1} & \cdots & \beta_{2,k_2} \\ -->
<!-- \cdots & \cdots & \cdots & \cdots \\ -->
<!-- \beta_{m,0} & \beta_{m,1} & \cdots & \beta_{m,k_2} -->
<!-- \end{pmatrix} \\ -->
<!-- & \\ -->
<!-- \boldsymbol{w}_1 &= \begin{pmatrix} -->
<!-- w^{(1)}_{1,0} & w^{(1)}_{1,1} & \cdots & w^{(1)}_{1,p} \\ -->
<!-- w^{(1)}_{2,0} & w^{(1)}_{2,1} & \cdots & w^{(1)}_{2,p} \\ -->
<!-- \cdots & \cdots & \cdots & \cdots \\ -->
<!-- w^{(1)}_{k_1,0} & w^{(1)}_{k_1,1} & \cdots & w^{(1)}_{k_1,p} -->
<!-- \end{pmatrix};  -->
<!-- \boldsymbol{w}_2 = \begin{pmatrix} -->
<!-- w^{(2)}_{1,0} & w^{(2)}_{1,1} & \cdots & w^{(2)}_{1,k_1} \\ -->
<!-- w^{(2)}_{2,0} & w^{(2)}_{2,1} & \cdots & w^{(2)}_{2,p} \\ -->
<!-- \cdots & \cdots & \cdots & \cdots \\ -->
<!-- w^{(2)}_{k_2,0} & w^{(2)}_{k_2,1} & \cdots & w^{(2)}_{k_2,k_1} -->
<!-- \end{pmatrix} -->
<!-- (#eq:nn015) -->
<!-- \end{align} -->

<!-- Quá trình ước lượng tham số cho mạng nơ-ron là quá trình tìm các ma trận tham số $\boldsymbol{w}_1$, $\boldsymbol{w}_2$, và $\boldsymbol{\beta}$ để tối thiểu hóa tổn thất tính bằng cross-entropy -->
<!-- \begin{align} -->
<!-- (\hat{\boldsymbol{w}}_1, \hat{\boldsymbol{w}}_2, \hat{\boldsymbol{\beta}}) = \underset{\boldsymbol{w}_1, \boldsymbol{w}_2, \boldsymbol{\beta}}{\operatorname{argmin}} \sum\limits_{i=1}^n \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \log(\hat{y}^{i}_{j}) -->
<!-- (#eq:nn016) -->
<!-- \end{align} -->

<!-- Như chúng tôi đã đề cập ở phía trước, các mô hình mạng nơ-ron có nhiều lớp ẩn với số lượng đơn vị trong các lớp ẩn không quá nhiều thường cho kết quả tốt hơn so với các mô hình có ít lớp ẩn và sử dụng nhiều đơn vị trong một lớp. Tuy nhiên khi tăng số lớp ẩn lên sẽ làm cho số lượng tham số cần được ước lượng tăng lên rất nhanh, khiến cho mô hình mạng nơ-ron rất dễ rơi vào tình trạng overfitting, nghĩa là sai số trên tập dữ liệu huấn luyện mô hình nhỏ nhưng sai số trên dữ liệu kiểm tra mô hình lại rất lớn. Chính vì thế, trong quá trình ước lượng tham số, người xây dựng mô hình thường sử dụng thêm các ràng buộc tham số, chẳng hạn như ràng buộc tham số kiểu hồi quy ridge. Nghĩa là tổn thất của mô hình tính bằng cross-entropy sẽ được điều chỉnh để cân bằng giữa phương sai và độ lệch của mô hình. Chúng ta sẽ thảo luận về vấn đề này trong phần ước lượng tham số cho mạng nơ-ron.  -->

<!-- ## Ước lượng tham số của mạng nơ-ron {#nnestimation} -->

<!-- Tham số của mạng nơ-ron được chia thành hai nhóm: -->

<!-- - Nhóm thứ nhất bao gồm các siêu tham số như số lượng lớp ẩn trong cấu trúc mạng và trong mỗi lớp ẩn có bao nhiêu đơn vị. Chẳng hạn như cấu trúc được mô tả trong hình \@ref(fig:fgnn004) có hai lớp ẩn, lớp ẩn thứ nhất có 512 đơn vị, lớp ẩn thứ hai có 256 đơn vị. Trong trường hợp chúng ta có sử dụng ràng buộc tham số, chúng ta có thêm một tham số điều chỉnh sự đánh đổi giữa sai lệch và phương sai giống như tham số $\lambda$ trong hồi quy ridge. -->

<!-- - Với mỗi lựa chọn cho các tham số trong nhóm thứ nhất, chúng ta có các tham số để tính toán cấu trúc mạng bao gồm các ma trận $\boldsymbol{w}$ và ma trận $\boldsymbol{\beta}$ được định nghĩa trong phương trình \@ref(eq:nn015). Quá trình ước lượng các tham số này là quá trình giải bài toán tối thiểu hóa hàm tổn thất dạng tổng sai số bình phương trong bài toán hồi quy hoặc hàm cross-entropy trong bài toán phân loại. Nhìn chung, không thể tính toán được lời giải chính xác cho bài toán tối ưu mà chúng ta sẽ phải ước lượng tham số bằng các phương pháp giải số, mà cụ thể là phương pháp stochastic gradient descent. Do đó, chúng ta thường phải xác định định thêm các tham số như tốc độ học, số lượng dữ liệu được sử dụng trong mỗi bước tính toán, hay số vòng lặp của thuật toán gradient descent. -->

<!-- Lựa chọn tham số trong nhóm thứ nhất có thể ảnh hưởng lớn đến kết quả của mô hình mạng nơ-ron, nhưng lại không có phương pháp chính xác nào để xác định các tham số này. Nếu nguồn lực tính toán cho phép, các tham số này sẽ được xác định bằng cách thử nghiệm và lựa chọn. Nếu nguồn lực tính toán không cho phép, người xây dựng mô hình thường lựa chọn các tham số này dựa trên kinh nghiệm và cấu trúc mạng đã có sẵn trên các bộ dữ liệu tương tự. -->

<!-- Trong phần này, chúng tôi sẽ tập trung vào các tham số cần được ước lượng trong nhóm thứ hai, nghĩa là tập trung vào ước lượng các ma trận $\boldsymbol{w}$ và ma trận $\boldsymbol{\beta}$ khi chúng ta đã có một cấu trúc mạng cụ thể. -->

<!-- ### Ước lượng tham số cho mạng nơ-ron hồi quy có một lớp ẩn -->
<!-- Quá trình ước lượng mạng nơ-ron đòi hỏi kiến thức và các kỹ thuật toán học khá phức tạp và chúng tôi sẽ cố gắng chỉ trình bày tổng quan và ngắn gọn. Bạn đọc cảm thấy khó khăn về phần này này có thể yên tâm bỏ qua và chuyển sang phần tiếp theo bởi chúng ta có thể sử dụng các thư viện như \textbf{keras} hay \textbf{neuralnet} để ước lượng mô hình mà không cần hiểu quá sâu về các chi tiết kỹ thuật trong quy trình xây dựng mô hình. -->

<!-- Chúng ta sẽ bắt đầu bằng mô hình mạng nơ-ron hồi quy có một lớp ẩn duy nhất được trình bày trong hình \@ref(fig:fgnn001) và phương trình \@ref(eq:nn001). Để mô hình giữ nguyên tính tổng quát, chúng tôi sử dụng $p$ là số tham số đầu vào, $k$ là số lượng đơn vị trong lớp ẩn. Chúng ta cần tìm các tham số là véc-tơ $\boldsymbol{\beta}$ và ma trận $\boldsymbol{w}$ để tối thiểu hóa tổng sai số bình phương: -->

<!-- \begin{align} -->
<!-- RSS\left( \boldsymbol{\beta}, \boldsymbol{w} \right) & = \cfrac{1}{2} \ \sum\limits_{i=1}^n \ \left(y_i - f_{\boldsymbol{\beta}, \boldsymbol{w}}\left(\textbf{x}_i\right) \right)^2 \\ -->
<!--  & = \cfrac{1}{2} \sum\limits_{i=1}^n \ \left(y_i - \beta_0 - \sum\limits_{t = 1}^k \beta_t \cdot g\left(z_{t,i}\right) \right)^2 -->
<!--  (#eq:nn017) -->
<!-- \end{align} -->
<!-- với -->
<!-- \begin{align} -->
<!-- z_{i,t} = w_{t,0} + \sum\limits_{j=1}^p w_{t,j} \cdot x_{i,j} -->
<!--  (#eq:nn018) -->
<!-- \end{align} -->
<!-- Mặc dù hàm $RSS\left( \boldsymbol{\beta}, \boldsymbol{w} \right)$ trong phương trình \@ref(eq:nn017) không quá phức tạp, nhưng để giải bài toán tối thiểu hóa hàm số này trên dữ liệu $(\textbf{x}_i,y_i)$ với $i = 1, 2, \cdots, n$ và hàm số $g$ cho trước không phải là một nhiệm vụ dễ dàng. Trước hết, mặc dù chúng ta có dạng hàm tường minh cho các tham số, nhưng đây không phải là hàm số lồi theo các tham số, do đó quá trình giải bài toán tối ưu thường chỉ cho đáp số là một điểm cực tiểu địa phương chứ không chắc chắn là điểm cực tiểu toàn cục. Thứ hai, không thể có lời giải chính xác cho bài toán tối ưu nên chúng ta sẽ cần tìm lời giải số, trong trường hợp này là phương pháp gradient descent. Việc lựa chọn các tham số cho thuật toán này cũng sẽ là câu hỏi cần được giải đáp cho quá trình xây dựng mô hình. Thứ ba, mô hình mạng nơ-ron có rất nhiều tham số, do đó rất dễ dẫn đến hiện tượng mô hình quá khớp với dữ liệu huấn luyện mô hình. Hàm mục tiêu thường sẽ bằng RSS cộng thêm một hàm phạt, khiến cho quá trình giải số trở nên khó khăn hơn. -->

<!-- Trước tiên, giả sử bài toán tối ưu trong \@ref(eq:nn017) không có ràng buộc tham số, chúng ta cần xác định gradient của RSS theo $\boldsymbol{\beta}$ và $\boldsymbol{w}$. Để đơn giản hóa, chúng ta giả sử bình phương của sai số thứ $i$ là $RSS_i$ -->
<!-- \begin{align} -->
<!-- RSS_i = \cfrac{1}{2} \ \left[y_i - \beta_0 - \sum\limits_{t = 1}^k \beta_t \cdot g\left(z_{i,t}\right) \right]^2 -->
<!-- \end{align} -->

<!-- - Đạo hàm của bình phương sai số thứ $i$ theo $\beta_l$, với $0 \leq l \leq k$, được xác định như sau -->
<!-- \begin{align} -->
<!-- \cfrac{\partial RSS_i}{\partial \beta_l} & = \begin{cases}  -->
<!-- -\left(y_i - f\left(\textbf{x}_i\right) \right) & \text{ nếu } l = 0 \\ -->
<!-- -g\left(z_{i,l}\right)  \left(y_i - f\left(\textbf{x}_i\right) \right) & \text{ nếu } l > 0 -->
<!-- \end{cases} -->
<!--  (#eq:nn019) -->
<!-- \end{align} -->

<!-- - Đạo hàm của bình phương sai số thứ $i$ theo $w_{l,j}$, với $1 \leq l \leq k$ và $0 \leq j \leq p$, được xác định như sau -->

<!-- \begin{align} -->
<!-- \cfrac{\partial RSS_i}{\partial w_{l,j}} & = - \cfrac{\partial  \beta_l \cdot g\left(z_{i,l}\right) }{\partial w_{l,j}} \left(y_i - f\left(\textbf{x}_i\right) \right) \\ -->
<!-- & =  -->
<!-- \begin{cases} -->
<!-- - \beta_l \cdot g^{'}\left(z_{i,l}\right) \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) & \text{ nếu } j = 0 \\ -->
<!-- - \beta_l \cdot x_{i,j} \cdot g^{'}\left(z_{i,l}\right) \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) & \text{ nếu } j > 0 -->
<!-- \end{cases} -->
<!-- (#eq:nn020) -->
<!-- \end{align} -->

<!-- Trước tiên, có thể thấy rằng cả hai biểu thức đạo hàm của sai số bình phương này đều chứa phần dư $\left(y_i − f(\textbf{x}i)\right)$. Trong công thức \@ref(eq:nn019) chúng ta thấy rằng giá trị tuyệt đối của gradient theo các $\beta_l$ bằng phần dư nhân với giá trị $g\left(z_{i,l}\right)$, chính là giá trị tại nút $H_l$ tính theo đầu vào $\textbf{x}_i$. Tiếp theo, trong công thức \@ref(eq:nn020) chúng ta thấy sự thay đổi của RSS theo tham số $w_{l,j}$, tương ứng với hệ số của đầu vào $X_j$ khi tính toán đơn vị $H_l$ của mạng nơ-ron một lớp ẩn, cũng phụ thuộc vào phần dư. Sự ảnh hưởng của phần dư lên đạo hàm theo từng tham số của mô hình được gọi là quá trình lan truyền ngược trong mô hình mạng nơ-ron. -->

<!-- Các công thức đạo hàm ở trên luôn yêu cầu tính toán giá trị của hàm kích hoạt và đạo hàm tại các điểm $z_{i,l}$. Về lý thuyết, mọi hàm đơn điệu tăng, có đạo hàm, và không tuyến tính đều có thể được sử dụng làm hàm kích hoạt. Tuy nhiên, nếu dạng hàm quá phức tạp, việc tính toán sẽ trở nên phưc tạp, nhất là khi sử dụng nhiều lớp ẩn và trong mỗi lớp ẩn có nhiều đơn vị. Điều này giải thích tại sao hàm ReLU thường xuyên được sử dụng làm hàm kích hoạt để tính toán gradient là đơn giản nhất có thể. Giả sử hàm $g$ trong các công thức \@ref(eq:nn019) và \@ref(eq:nn020) là hàm ReLU, chúng ta có thể đơn giản hóa các đạo hàm như sau: -->

<!-- - Đạo hàm theo hệ số $\beta_l$: -->

<!-- \begin{align} -->
<!-- \cfrac{\partial RSS_i}{\partial \beta_l} & = \begin{cases}  -->
<!-- -\left(y_i - f\left(\textbf{x}_i\right) \right) & \text{ nếu } l = 0 \\ -->
<!-- -\mathbb{I}(z_{i,l} > 0) \cdot z_{i,l} \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) & \text{ nếu } l > 0  -->
<!-- \end{cases} -->
<!--  (#eq:nn021) -->
<!-- \end{align} -->

<!-- - Đạo hàm theo $w_{l,0}$,  -->

<!-- \begin{align} -->
<!--   \cfrac{\partial RSS_i}{\partial w_{l,0}} & = - \beta_l \cdot \mathbb{I}(z_{i,l} > 0) \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) -->
<!--   (#eq:nn022) -->
<!-- \end{align} -->

<!-- - Đạo hàm theo $w_{l,j}$, với $j > 0$ thì  -->

<!-- \begin{align} -->
<!-- \cfrac{\partial RSS_i}{\partial w_{l,j}} & =  -->
<!-- - \beta_l \cdot \mathbb{I}(z_{i,l} > 0) \cdot x_{i,j} \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) -->
<!-- (#eq:nn023) -->
<!-- \end{align} -->

<!-- Gradient của tổng các $RSS_i$ được xác định như sau: -->

<!-- - Theo $\beta_0$ -->

<!-- \begin{align} -->
<!-- \cfrac{\partial RSS}{\partial \beta_0} &= \sum\limits_{i=1}^n \cfrac{\partial RSS_i}{\partial \beta_0} \\ -->
<!-- & = - \sum\limits_{i=1}^n \left(y_i - f\left(\textbf{x}_i\right) \right) -->
<!-- (#eq:nn024) -->
<!-- \end{align} -->

<!-- - Theo $\beta_l$ với $l > 0$ -->

<!-- \begin{align} -->
<!-- \cfrac{\partial RSS}{\partial \beta_l} &= \sum\limits_{i=1}^n \cfrac{\partial RSS_i}{\partial \beta_l} \\ -->
<!-- & = - \sum\limits_{i=1}^n \mathbb{I}(z_{i,l} > 0) \cdot z_{i,l} \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) -->
<!-- (#eq:nn025) -->
<!-- \end{align} -->

<!-- - Theo $w_{l,0}$, -->

<!-- \begin{align} -->
<!-- \cfrac{\partial RSS_i}{\partial w_{l,0}} & =  - \beta_l \sum\limits_{i=1}^n \mathbb{I}(z_{i,l} > 0) \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) -->
<!-- (#eq:nn026) -->
<!-- \end{align} -->

<!-- - Theo $w_{l,j}$ với j > 0 -->
<!-- \begin{align} -->
<!-- \cfrac{\partial RSS_i}{\partial w_{l,j}} & = - \beta_l \sum\limits_{i=1}^n \mathbb{I}(z_{i,l} > 0) \cdot x_{i,j} \cdot \left(y_i - f\left(\textbf{x}_i\right) \right) -->
<!-- (#eq:nn027) -->
<!-- \end{align} -->

<!-- Sau khi tính toán gradient của RSS theo các tham số, quá trình ước lượng sẽ được thực hiện thông qua thuật toán Stochastic gradient descent. Bạn đọc tham khảo thuật toán này trong Phụ lục \@ref(sec:sgd) của chương Kiến thức R nâng cao. Kết quả của thuật toán Stochastic gradient descent phụ thuộc rất lớn vào giá trị khởi tạo ban đầu của các tham số, và nhất là khi số lượng tham số là rất lớn.  -->

<!-- Để mô tả quá trình ước lượng tham số của mạng nơ-ron, chúng ta sẽ sử dụng dữ liệu mô phỏng. Ma trận biến giải thích $\textbf{X}$ có kích thước $10^4 \times 3$ là các số ngẫu nhiên độc lập có phân phối chuẩn $\mathcal{N}(0,1)$. Hàm $f$ được tạo bởi mô hình mạng nơ-ron với 3 đơn vị của lớp đầu vào, một lớp ẩn với 5 đơn vị, và một đơn vị trong lớp đầu đầu ra. Hàm kích hoạt được sử dụng là hàm ReLU. Biến giải thích $Y$ được tính toán từ hàm $f(\textbf{X})$ công thêm một sai số độc lập với $\textbf{X}$ là một biến ngẫu nhiên phân phối chuẩn với trung bình bằng 0 và độ lệch chuẩn là 0.5. Các tham số dùng để tính toán $f$ được đơn giản hóa: $\beta_l = 2 \forall l = 0, 1, \cdots, 5$ và $w_{l,j} = 1 \forall l = 1, 2, , $ và $j = , $. Quá trình tối thiểu hóa tổng sai số bình phương được mô tả thông qua hình \@ref(fig:fgnn005) -->

<!-- ```{r fgnn005, warning = FALSE, message=FALSE,echo = FALSE, fig.cap = "Sai số của mô hình mạng nơ-ron giảm dần trong quá trình ước lượng tham số sử dụng thuật toán stochastic gradient descent. Hình bên trái: điểm bắt đầu của các tham số là biến ngẫu nhiên phân phối chuẩn độc lập có trung bình bằng 0 và phương sai bằng 3. Hình bên phải: điểm bắt đầu của các tham số expression{beta} là biến ngẫu nhiên có trung bình bằng 2 và phương sai bằng 1. Điểm bắt đầu của các tham số w là biến ngẫu nhiên có trung bình bằng 1 và phương sai bằng 1"} -->
<!-- dat1<-readRDS("sgd_simulation_1") -->
<!-- dat1<-as.tibble(t(dat1)) -->
<!-- names(dat1)<-paste("Lần",1:ncol(dat1)) -->
<!-- p1<-dat1%>%mutate("Số vòng lặp" = 1:nrow(dat1))%>% -->
<!--   pivot_longer(-"Số vòng lặp", values_to = "RSS")%>% -->
<!--   ggplot(aes(x=`Số vòng lặp`,y = RSS))+geom_line(aes(group = name),color = "grey", alpha = 0.8, size = 0.5)+ -->
<!--   ylim(c(0,500))+theme_classic()+ -->
<!--   geom_hline(yintercept = 49.409, color = "orange", size = 0.7, linetype = 2)+ -->
<!--   theme(legend.position = "none")+ -->
<!--   ggtitle("Điểm bắt đầu ngẫu nhiên") -->

<!-- dat1<-readRDS("sgd_simulation_2") -->
<!-- dat1<-as.tibble(t(dat1)) -->
<!-- names(dat1)<-paste("Lần",1:ncol(dat1)) -->
<!-- p2<-dat1%>%mutate("Số vòng lặp" = 1:nrow(dat1))%>% -->
<!--   pivot_longer(-"Số vòng lặp", values_to = "RSS")%>% -->
<!--   ggplot(aes(x=`Số vòng lặp`,y = RSS))+geom_line(aes(group = name), color = "grey", alpha = 0.8, size = 0.5)+ -->
<!--   ylim(c(0,500))+theme_classic()+ -->
<!--   geom_hline(yintercept = 49.409, color = "orange", size = 0.7, linetype = 2)+ -->
<!--   theme(legend.position = "none")+ -->
<!--   ggtitle("Có thêm thông tin về điểm bắt đầu") -->

<!-- grid.arrange(p1,p2,ncol = 2) -->
<!-- ``` -->

<!-- Hình \@ref(fig:fgnn005) mô tả quá trình tối thiểu hóa sai số tính bằng RSS trên dữ liệu mô phỏng bằng phương pháp stochastic gradient descent. Tổng số tham số cần được ước lượng của mô hình là 26, bao gồm 6 giá trị của véc-tơ $\boldsymbol{\beta}$ và 20 giá trị của ma trận $\boldsymbol{w}$. Chúng tôi sử dụng 5 nghìn lần lặp và trong mỗi lần lặp sử dụng 5% dữ liệu để tính các gradient. -->

<!-- Hình bên trái mô tả 10 quá trình ước lượng tham số mà các điểm bắt đầu của $\boldsymbol{\beta}$ và $\boldsymbol{w}$ là hoàn toàn ngẫu nhiên. Chúng tôi cho các giá trị ban đầu là các biến ngẫu nhiên phân phối chuẩn với trung bình bằng 0 và phương sai bằng 3. Hình bên phải mô tả 10 quá trình ước lượng tham số với các điểm bắt đầu của $\boldsymbol{\beta}$ có giá trị trung bình là 2 bằng với giá trị dùng để mô phỏng dữ liệu và $\boldsymbol{w}$ có giá trị trung bình là 1 cũng bằng với giá trị dùng để mô phỏng dữ liệu. Phương sai của 26 tham số khởi đầu đều bằng 1. Có thể thấy rằng khi các tham số khởi đầu là hoàn toàn ngẫu nhiên thì về trung bình các quá trình hội tụ về giá ngưỡng nho nhất của RSS chậm hơn khi chúng ta có các giá trị khởi đầu tốt hơn. Có hai trên tám quá trình sau 5000 bước lặp vẫn chưa cho sai số tiệm cận đến giá trị RSS nhỏ nhất. Trong hình bên phải thì các quá trình đều cho kết quả gần với giá trị RSS nhỏ nhất. -->

<!-- ### Ước lượng tham số cho mạng nơ-ron phân loại có hai lớp ẩn -->
<!-- Giả sử cấu trúc mạng nơ-ron có hai lớp ẩn như hình \@ref(fig:fgnn004). Các tham số cần ước lượng của mô hình bao gồm các ma trận $\boldsymbol{w}_1$, $\boldsymbol{w}_2$, và $\boldsymbol{\beta}$ được cho bởi phương trình \@ref(eq:nn015). Do đây là bài toán phân loại nên hàm mục tiêu được sử dụng là hàm cross-entropy -->
<!-- \begin{align} -->
<!-- (\hat{\boldsymbol{w}}_1, \hat{\boldsymbol{w}}_2, \hat{\boldsymbol{\beta}}) &= \underset{\boldsymbol{w}_1, \boldsymbol{w}_2, \boldsymbol{\beta}}{\operatorname{argmin}} \sum\limits_{i=1}^n \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \log(\hat{y}^{i}_{j}) \\ -->
<!-- (#eq:nn028) -->
<!-- \end{align} -->

<!-- Giá trị của hàm cross-entropy tính trên quan sát thứ $i$ có thể được rút gọn như sau -->
<!-- \begin{align} -->
<!-- \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \log(\hat{y}^{i}_{j}) &= \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \log\left(\cfrac{exp\left(z_{i,j}\right)}{exp\left(z_{i,1}\right)+exp\left(z_{i,2}\right)+\cdots+exp\left(z_{i,m}\right)}\right) \\ -->
<!-- & = \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \left(z_{i,j} -  \log\left(exp\left(z_{i,1}\right)+exp\left(z_{i,2}\right)+\cdots+exp\left(z_{i,m}\right)\right) \right)\\ -->
<!-- & =  \sum\limits_{j=1}^m \ y^{i}_{j} \cdot z_{i,j} - \log\left(\sum\limits_{j=1}^m exp\left(z_{i,j}\right)\right) -->
<!-- (#eq:nn029) -->
<!-- \end{align} -->
<!-- với $z_{i,j}$ là tổ hợp tuyến tính của giá trị các nút ẩn thứ hai tính theo đầu vào $\textbf{x}_i$  -->
<!-- \begin{align} -->
<!-- z_{i,j} = \beta_{j,0} + \beta_{j,1} h^{(2)}_{i,1} + \beta_{j,2} h^{(2)}_{i,2} + \cdots + \beta_{j,k_2} h^{(2)}_{i,k_2} -->
<!-- (#eq:nn030) -->
<!-- \end{align} -->

<!-- Với mọi tham số $\theta$ được sử dụng để tính toán giá trị tại các nút đầu ra, đạo hàm của hàm cross-entropy sẽ được tính toán thông qua các $z_{i,j}$ -->
<!-- \begin{align} -->
<!-- \cfrac{\partial CE\_Loss_i}{\partial \theta} &= \sum\limits_{j=1}^m \ y^{i}_{j} \ \cfrac{\partial z_{i,j}}{\partial \theta} - \sum\limits_{j=1}^m \cfrac{\partial z_{i,j}}{\partial \theta} \cfrac{exp(z_{i,j})}{\sum exp\left(z_{i,j}\right)} \\ -->
<!-- & = \sum\limits_{j=1}^m  \cfrac{\partial z_{i,j}}{\partial \theta} \left(y^{i}_{j} - p_{i,j}\right) -->
<!-- (#eq:nn031) -->
<!-- \end{align} -->
<!-- trong đó -->
<!-- \begin{align} -->
<!-- p_{i,j} = \cfrac{exp(z_{i,j})}{\sum\limits_{j=1}^m exp\left(z_{i,j}\right)} -->
<!-- (#eq:nn032) -->
<!-- \end{align} -->

<!-- Từ công thức \@ref(eq:nn030) có thể thấy rằng: véc-tơ dữ liệu đầu ra $\textbf{y}_i = (y^{i}_{1}, y^{i}_{2}, \cdots, y^{i}_{m})$ nhận giá trị bằng 1 tại một vị trí và nhận giá trị bằng 0 tại $m-1$ vị trí còn lại, trong khi đó $p_{i,j}$ có thể được hiểu là xác suất mà đầu ra thứ $i$ nhận giá trị bằng $j$ được xác định bởi mô hình mạng nơ-ron. Đạo hàm của hàm tổn thất tính bằng cross-entropy theo tham số $\theta$ bất kỳ, là một phần tử của ma trận $\boldsymbol{\beta}$ hoặc các $\boldsymbol{w}$, phụ thuộc vào sai số giữa véc-tơ xác suất từ dữ liệu quan sát được $\textbf{y}^i$ và véc-tơ xác suất được xác định bởi mô hình mạng nơ-ron $\textbf{p}_{i} = (p_{i,1}, p_{i,2}, \cdot, p_{i,m})$. Như vậy, gradient của hàm tổn thất theo từng tham số phụ thuộc vào sai số của mô hình hiện tại. Nói một cách khác, sai số của mô hình trong bước hiện tại sẽ tác động đến việc cập nhật tham số trong bước tiếp theo khi chúng ta sử dụng phương pháp gradient descent. Đây là quá trình lan truyền ngược trong mô hình mạng nơ-ron mà chúng tôi đã đề cập đến trong phần mô hình mạng nơ-ron hồi quy có một lớp ẩn.  -->

<!-- Quá trình tính toán đạo hàm của $z_{i,j}$ theo các tham số của ma trận $\boldsymbol{\beta}$ là khá hiển nhiên do $z_{i,j}$ là hàm tuyến tính theo các tham số này. Để tính toán đạo hàm của $z_{i,j}$ theo các tham số của các ma trận $\boldsymbol{w}$, chúng ta sử dụng nguyên tắc chain-rule đã trình bày trong phụ lục của phần Kiến thức R nâng cao. Do chỉ số của các tham số trong ma trận là quá phức tạp nên chúng tôi sẽ chỉ trình bày cách tính đạo hàm mang tính tổng quát. Ta có mỗi $z$ được tính từ phương trình \@ref(eq:nn030) được xác định từ dữ liệu đầu vào $x$ thông qua các hàm kích hoạt $g_1$ và $g_2$ như sau -->
<!-- \begin{align} -->
<!-- z & = \beta h^{(2)} \\ -->
<!-- h^{(2)} &= g_2(w^{(2)}\cdot h^{(1)}) \\ -->
<!-- h^{(1)} &= g_1(w^{(1)}\cdot x) -->
<!-- (#eq:nn033) -->
<!-- \end{align} -->

<!-- Trong đó $\beta$, $w^{(2)}$, và $w^{(1)}$ là các tham số của mô hình. Giá trị đạo hàm của $z$ theo các tham số được xác định như sau -->

<!-- - Theo $\beta$ -->
<!-- \begin{align} -->
<!-- \cfrac{\partial z}{\partial \beta} = h^{(2)} -->
<!-- (#eq:nn034) -->
<!-- \end{align} -->

<!-- - Theo $w^{(2)}$, chúng ta áp dụng nguyên tắc chain-rule -->
<!-- \begin{align} -->
<!-- \cfrac{\partial z}{\partial w^{(2)}} & = \cfrac{\partial z}{\partial h^{(2)}} \times \cfrac{\partial h^{(2)}}{\partial w^{(2)}} \\ -->
<!-- & =  \beta \cdot h^{(1)} \cdot  g^{'}_2(w^{(2)}\cdot h^{(1)}) -->
<!-- (#eq:nn035) -->
<!-- \end{align} -->

<!-- - Theo $w^{(1)}$, áp dụng nguyên tắc chain-rule -->
<!-- \begin{align} -->
<!-- \cfrac{\partial z}{\partial w^{(1)}} & = \cfrac{\partial z}{\partial h^{(2)}} \times \cfrac{\partial h^{(2)}}{\partial h^{(1)}} \times \cfrac{\partial h^{(1)}}{\partial w^{(1)}} \\ -->
<!-- & =  \beta \cdot w^{(2)} \cdot g^{'}_2(w^{(2)}\cdot h^{(1)}) \cdot x \cdot g^{'}_1(w^{(1)}\cdot x) -->
<!-- (#eq:nn036) -->
<!-- \end{align} -->

<!-- Số lượng tham số cần được tính toán trong mô hình mạng nơ-ron phân loại với $p$ đầu vào, $m$ đầu ra, hai lớp ẩn với số lượng đơn vị lần lượt là $k_1$ và $k_2$ là -->

<!-- - $m \cdot (k_2+1)$ tham số trong ma trận $\boldsymbol{\beta}$, -->

<!-- - $k_2 \cdot (k_1 + 1)$ tham số trong ma trận $\boldsymbol{w}_2$ -->

<!-- - $k_1 \cdot (p + 1)$ tham số trong ma trận $\boldsymbol{w}_1$ -->

<!-- Số lượng tham số quá lớn sẽ dẫn đến các vấn đề bao gồm sự phức tạp khi tiến hành tính toán, khối lượng tính toán lớn, và rất dễ dẫn đến overfitting. Để khắc phục vấn đề này, mô hình mạng nơ-ron thường phải sử dụng thêm các kỹ thuật để thêm ràng buộc tham số hoặc loại bỏ đơn vị trong các lớp. Chúng ta sẽ thảo luận các kỹ thuật này trong phần tiếp theo. -->

<!-- ### Khắc phục hiện tượng khớp quá mức của mạng nơ-ron -->
<!-- Phương pháp trước hết để hạn chế mô hình khớp quá mức là sử dụng ràng buộc tham số. Nguyên tắc ràng buộc tham số trong mô hình mạng nơ-ron cũng tương tự trong hồi quy ridge. Ví dụ, với mô hình mạng nơ-ron hồi quy được trình bày trong phần \@ref(nnonelayer) hàm mục tiêu cần được tối thiểu hóa là tổng bình phương sai số cộng thêm một hàm phạt có dạng tổng bình phương các tham số sử dụng trong mô hình. -->

<!-- \begin{align} -->
<!-- (\hat{\boldsymbol{\beta}},\hat{\boldsymbol{w}}) = \underset{\boldsymbol{\beta},\boldsymbol{w}}{\operatorname{argmin}} = \sum\limits_{i=1}^n \ \left(y_i - f_{\boldsymbol{\beta}, \boldsymbol{w}}\left(\textbf{x}_i\right) \right)^2 + \lambda_1 \cdot \sum\limits_{j} \beta_j^2 + \lambda_2 \sum\limits_{l,j} w_{l,j}^2 -->
<!--  (#eq:nn037) -->
<!-- \end{align} -->

<!-- Trong mô hình mạng nơ-ron phân loại có hai lớp ẩn trong phần \@ref(nnmultilayer), hàm mục tiêu tính bằng cross-entropy cũng được biến đổi bằng cách thêm vào một hàm phạt dạng tổng bình phương của các tham số: -->
<!-- \begin{align} -->
<!-- (\hat{\boldsymbol{w}}_1, \hat{\boldsymbol{w}}_2, \hat{\boldsymbol{\beta}}) &= \underset{\boldsymbol{w}_1, \boldsymbol{w}_2, \boldsymbol{\beta}}{\operatorname{argmin}} \sum\limits_{i=1}^n \sum\limits_{j=1}^m \ y^{i}_{j} \cdot \log(\hat{y}^{i}_{j}) + \lambda_1 \sum\limits_{j,l} \beta_{j,l}^2 + \lambda_2 \sum\limits_{j,l} w^{(1)}_{j,l}^2 + \lambda_3 \sum\limits_{j,l} w^{(2)}_{j,l}^2 -->
<!-- (#eq:nn038) -->
<!-- \end{align} -->

<!-- Người xây dựng mô hình có thể sử dụng các hàm phạt khác như hàm tổng giá trị tuyệt đối trong hồi quy Lasso, hoặc kết hợp giữa Lasso và ridge. Một lưu ý khác khi sử dụng ràng buộc tham số đó là người xây dựng mô hình thường không sử dụng ràng buộc tham số trực tiếp tính lớp đầu ra, nghĩa là thường cho $\lambda_1$ trong các phương trình \@ref(eq:nn037) và \@ref(eq:nn038) bằng 0. Với mỗi giá trị của các tham số $\lambda$, chúng ta tiến hành ước lượng tham số của mạng nơ-ron giống như đã trình bày trong phần \@ref(nnestimation). -->

<!-- Một phương pháp khác để giảm bớt hiện tượng khớp quá mức của mạng nơ-ron là phương pháp loại bỏ đơn vị (unit dropout). Các đơn vị của lớp đầu vào và các lớp ẩn có thể tham gia vào mô hình mạng nơ-ron với xác suất là $p$ và không tham gia vào mô hình với xác suất $(1-p)$ trong mỗi bước của quá trình huấn luyện mô hình, trong đó $p$ là tham số của kỹ thuật dropout. Ý tưởng của phương pháp này hoàn toàn tương tự như ý tưởng của thuật toán rừng ngẫu nhiên áp dụng trên cây quyết định. Quá trình ước lượng tham số của mô hình mạng nơ-ron bao gồm hai quá trình: quá trình chuyển tiếp từ đầu vào, qua các lớp ẩn, và kết thúc tại lớp đầu ra, và quá trình lan truyền ngược, khi sai số tính tại lớp đầu ra được sử dụng để tính toán sự thay đổi cho tất cả các tham số của mô hình hiện tại. Nếu trong tất cả các lần chuyển tiếp và lan truyền ngược, chúng ta giữ nguyên cấu trúc của mạng, trong mỗi lớp đầu vào hoặc lớp ẩn có thể có một hoặc một số đơn vị chiếm ưu thế so với các đơn vị khác, làm cho kết quả tại đầu ra phụ thuộc rất lớn vào các đơn vị này. Cũng giống như ý tưởng của thuật toán rừng ngẫu nhiên, trong mỗi lần chuyển tiếp và lan truyền ngược tương ứng, tại lớp đầu vào và các lớp ẩn, người xây dựng mô hình chỉ lựa chọn một số ngẫu nhiên các đơn vị vào trong quá trình tính toán tham số. Nói cách khác, mỗi đơn vị được lựa chọn vào quá trình tính toán với xác suất là $p$. Chúng tôi sẽ mô tả cách thực hiện kỹ thuật dropout trong phần thực hành. -->


<!-- Hàng thứ hai trong Bảng 10.1 được dán nhãn dropout. Đây là một dạng chính quy hóa tương đối mới bị loại bỏ và hiệu quả, tương tự ở một số khía cạnh với chính quy hóa đường gờ. Lấy cảm hứng từ các khu rừng ngẫu nhiên (Phần 8.2), ý tưởng là loại bỏ ngẫu nhiên một phần φ của các đơn vị trong một lớp khi tạo mô hình. Hình 10.19 minh họa điều này. Việc này được thực hiện riêng biệt mỗi khi xử lý quan sát đào tạo. Các đơn vị còn sống thay thế cho những đơn vị bị thiếu và trọng số của chúng được tăng lên theo hệ số 1/(1 − φ) để bù đắp. Điều này ngăn các nút trở nên chuyên biệt hóa quá mức và có thể được coi là một hình thức chính quy hóa. Trong thực tế, việc bỏ học đạt được bằng cách đặt ngẫu nhiên các kích hoạt cho các đơn vị “bị bỏ” về 0, trong khi vẫn giữ nguyên kiến trúc. -->



## Pickands dependent function
\begin{align}
C(u,v) = exp\left( log(uv) \cdot A\left(\cfrac{log(v)}{log(u)+log(v)} \right) \right)
\end{align}

Đạo hàm của $C(u,v)$ tính theo $A$
\begin{align}
\cfrac{\partial C(u,v)}{\partial u} &= C(u,v) \times \cfrac{1}{u} \cdot \left(A(t) - A^{'}(t) \cdot t \right) \\
\cfrac{\partial C(u,v)}{\partial v} &= C(u,v) \times \cfrac{1}{v} \cdot \left(A(t) + A^{'}(t) \cdot (1-t) \right) \\
\end{align}
with $t = \cfrac{log(v)}{log(u)+log(v)}$

Density của $C(u,v)$
\begin{align}
\cfrac{\partial^2 C(u,v)}{\partial u \partial v}  &= C(u,v) \times \cfrac{1}{uv} \cdot \left[ \left(A(t) - A^{'}(t) \cdot t \right) \cdot \left(A(t) + A^{'}(t) \cdot (1-t) \right) - \cfrac{A^{''}(t) t(1-t)}{log(uv)} \right]\\
\end{align}

## Nhóm các hàm A(t) để C(u,v) là một copula

- Các điều kiện biên: $C(0,v) = 0$, $C(u,v) = 0$, $C(1,v) = v$, và $C(u,1) = u$

  - Khi $u \rightarrow 0$ thì $t \rightarrow 0$ và khi $v \rightarrow 0$ thì $t \rightarrow 1$

\begin{align}
C(0,v) = exp\left( log(0 \cdot v) \cdot A\left(0 \right) \right) = 0^1 = 0
\end{align}

\begin{align}
C(u,0) = exp\left( log(u \cdot 0) \cdot A\left(0 \right) \right) = 0^1 = 0
\end{align}

  - Khi $u \rightarrow 1$ thì $t \rightarrow 1$ và khi $v \rightarrow 1$ thì $t \rightarrow 0$

\begin{align}
C(1,v) = exp\left( log(1 \cdot v) \cdot A\left(1 \right) \right) = v^1 = v
\end{align}

\begin{align}
C(u,1) = exp\left( log(u \cdot 1) \cdot A\left(0 \right) \right) = u^1 = u
\end{align}

- Các hàm $C_u(u,v)$ và $C_v(u,v)$ là hàm phân phối xác suất: $C_u(u,v)$ là hàm phân phối xác suất của biến $V$ với mọi $u$: Khi $v \rightarrow 0$,

\begin{align}
C(u,v) \times \cfrac{1}{u} \cdot \left(A(t) - A^{'}(t) \cdot t \right) &\rightarrow C(u,0) \times \cfrac{1}{u} \cdot \left(A(1) - A^{'}(1) \cdot 1 \right)\\
& = 0 \times \cfrac{1}{u} \cdot \left(A(1) - A^{'}(1) \right) \\
& = 0
\end{align}

Khi $v \rightarrow 1$,

\begin{align}
C(u,v) \times \cfrac{1}{u} \cdot \left(A(t) - A^{'}(t) \cdot t \right) &\rightarrow C(u,1) \times \cfrac{1}{u} \cdot \left(A(0) - A^{'}(0) \cdot 0 \right)\\
& = 1 \times 1 \\
& = 1
\end{align}

Đạo hàm của hàm $C_u(u,v)$ theo $v$ là hàm tăng theo $v$: Nếu $A^{''}(t) \geq 0$ $\forall t$ thì
\begin{align}
C(u,v) \times \cfrac{1}{uv} \cdot \left[ \left(A(t) - A^{'}(t) \cdot t \right) \cdot \left(A(t) + A^{'}(t) \cdot (1-t) \right) - \cfrac{A^{''}(t) t(1-t)}{log(uv)} \right] \geq 0
\end{align}
với mọi $u,v$










### Cách thứ nhất để tham số hóa đa thức từng phần

Hàm $f$ là đa thức từng phần thỏa mãn điều kiện thành pickand dependent function
\begin{align}
\theta \in [0.5,1] \\
\lambda_1 \geq \theta \\
\lambda_2 = \cfrac{ \left(\cfrac{\theta^3}{6}+\lambda_1 \cdot \cfrac{\theta^2}{2}\right) \cdot \theta - \left(\theta+\lambda_1\right) \cdot \left(\cfrac{\theta^3}{6}-\cfrac{\theta}{2}+\cfrac{1}{3}\right)  }{\cfrac{(1-\theta)^2\cdot(\theta+\lambda_1)}{2} - \left(\cfrac{\theta^3}{6}+\lambda_1 \cdot \cfrac{\theta^2}{2}\right)}
\end{align}


### Cách thứ hai
Chọn điểm cắt $\theta$, lựa chọn hàm $A(t)$ như sau
\begin{align}
A(t) = \mathbb{I}_{(t \leq \theta)} \left(a_0 + a_1 \cdot x + a_2 \cdot x^2 + a_3 \cdot x^3\right) +
\mathbb{I}_{(t > \theta)} \left(b_0 + b_1 \cdot (1-x) + b_2 \cdot (1-x)^2 + b_3 \cdot (1-x)^3\right)
\end{align}
với các ràng buộc:

- Hàm $A(t)$ có đạo hàm cấp 0,1,2 liên tục tại $\theta$

\begin{align}
& \begin{pmatrix}
(1-\theta) & (1-\theta)^2 & (1-\theta)^3 \\
- 1 & - 2\cdot(1 - \theta) & -3(1-\theta)^2 \\
0 & 1 & 3(1-\theta)\\
\end{pmatrix} \times
\begin{pmatrix}
b_1\\
b_2\\
b_3\\
\end{pmatrix} =
\begin{pmatrix}
\theta & \theta^2 & \theta^3 \\
1 & 2\theta & 3\theta^2 \\
0 & 1 & 3\theta\\
\end{pmatrix} \times
\begin{pmatrix}
a_1\\
a_2\\
a_3\\
\end{pmatrix} \\
& \\
\rightarrow &
\begin{pmatrix}
(1-\theta) & (1-\theta)^2 & (1-\theta)^3 \\
- 1 & - 2\cdot(1 - \theta) & -3(1-\theta)^2 \\
0 & 1 & 3(1-\theta)\\
\end{pmatrix}^{-1}
\times \begin{pmatrix}
\theta & \theta^2 & \theta^3 \\
1 & 2\theta & 3\theta^2 \\
0 & 1 & 3\theta\\
\end{pmatrix} \times
\begin{pmatrix}
a_1\\
a_2\\
a_3\\
\end{pmatrix} = \begin{pmatrix}
b_1\\
b_2\\
b_3\\
\end{pmatrix}
& \\
\rightarrow &
\begin{pmatrix}
\cfrac{3}{1-\theta} & 2 & 1 - \theta \\
- \cfrac{3}{(1-\theta)^2} & - \cfrac{3}{1-\theta} & -2 \\
\cfrac{1}{(1-\theta)^3} & \cfrac{1}{(1-\theta)^2} & \cfrac{1}{(1-\theta)}\\
\end{pmatrix}
\times \begin{pmatrix}
\theta & \theta^2 & \theta^3 \\
1 & 2\theta & 3\theta^2 \\
0 & 1 & 3\theta\\
\end{pmatrix} \times
\begin{pmatrix}
a_1\\
a_2\\
a_3\\
\end{pmatrix} = \begin{pmatrix}
b_1\\
b_2\\
b_3\\
\end{pmatrix}
& \\
\rightarrow &
\begin{pmatrix}
\cfrac{2+\theta}{1-\theta} & \cfrac{2\theta+1}{1-\theta} & \cfrac{3\theta}{1 - \theta} \\
- \cfrac{3}{(1-\theta)^2} & \cfrac{\theta^2-2\theta-2}{(1-\theta)^2} & \cfrac{3\theta^2-6\theta}{(1-\theta)^2} \\
\cfrac{1}{(1-\theta)^3} & \cfrac{1}{(1-\theta)^3} & \cfrac{1 - (1-\theta)^3}{(1-\theta)^3}\\
\end{pmatrix}
\times
\begin{pmatrix}
a_1\\
a_2\\
a_3\\
\end{pmatrix} = \begin{pmatrix}
b_1\\
b_2\\
b_3\\
\end{pmatrix}


\end{align}


<!-- ## Copula có 2 Kendall tau -->
<!-- Nếu $U$ là phân phối Uniform thì  -->

<!-- - $U/\alpha|U<\alpha$ cũng là biến ngẫu nhiên phân phối Uniform -->
<!-- \begin{align} -->
<!-- \mathbb{P}(U/\alpha|U<\alpha \leq x) & = \cfrac{\mathbb{P}(U \alpha \leq x)}{\mathbb{P}(U \leq \alpha)} \\ -->
<!-- & = \cfrac{\alpha x}{\alpha} = x -->
<!-- \end{align} -->

<!-- - $(U - \alpha)/(1-\alpha)|(U > \alpha)$ cũng là biến ngẫu nhiên phân phối Uniform -->
<!-- \begin{align} -->
<!-- \mathbb{P}((U - \alpha)/(1-\alpha)|(U > \alpha) \leq x) & = \cfrac{\mathbb{P}(U > \alpha, (U - \alpha) < x (1-\alpha) )}{\mathbb{P}(U > \alpha)} \\ -->
<!-- & = \cfrac{\mathbb{P}(\alpha \leq U < x (1-\alpha) + \alpha )}{\mathbb{P}(U > \alpha)} \\ -->
<!-- & = \cfrac{x (1-\alpha)}{(1 - \alpha)} \\ -->
<!-- & = x -->
<!-- \end{align} -->

<!-- Copula của $U/\alpha|U<\alpha$ và $V$ là $C_1(u,v)$ và Copula của $(U - \alpha)/(1-\alpha)|(U > \alpha)$ và $V$ là $C_2(u,v)$ và  -->
<!-- \begin{align} -->
<!-- \mathbb{P}(U \leq u, V \leq v) & =  \mathbb{P}(U \leq u, V \leq v, U \leq \alpha) + \mathbb{P}(U \leq u, V \leq v, U > \alpha) \\ -->
<!-- & =  \mathbb{P}(U \leq u, V \leq v | U \leq \alpha) \times \alpha + \mathbb{P}(U \leq u, V \leq v| U > \alpha) \times (1 - \alpha) -->

<!-- \end{align} -->

## Copula có 2 kendall tau
Khi Kendall tau bằng 0 thì chưa chắc 2 biến đã độc lập, có thể xảy ra trường hợp copula là mix của 2 copula, 1 copula có kendall tau dương và một copula có kendall tau âm. Cách mix các copula thông thường có thể như sau
\begin{align}
c(u,v) = p \times c_1(u,v) + (1 - p) c_2(u,v)
\end{align}
trong đó copula $C_1$ là Copula có kendall tau dương và $C_2$ là copula có kendall tau âm. Để ước lượng copula như vậy có thể sử dụng thuật toán EM sau đó dùng ML (thường phải giải bằng phương pháp số chứ không có lời giải chính xác).

Cách thứ hai để mix copula như sau
\begin{align}
c(u,v) = \mathbb{I}_{\{u \leq p\}} \cdot c_1\left(\cfrac{u}{p},v \right) + 
\mathbb{I}_{\{u > p\}} \cdot c_2\left(\cfrac{u - p}{1 - p},v \right)
\end{align}



## Hàm A(t) là đa thức bậc k
Nếu A(t) chỉ đến bậc 3 thì A(t) nhỏ nhất là 0.666 trong khi giá trị cần là 0.5 -> cần sử dụng đa thức bậc cao hơn.

Chọn điểm cắt $\theta$, lựa chọn hàm $A(t)$ như sau
\begin{align}
A(x) = \mathbb{I}_{(x \leq \theta)} \left(a_0 + a_1 \cdot x + a_2 \cdot x^2 + \cdots + a_k \cdot x^k\right) +
\mathbb{I}_{(t > \theta)} \left(b_0 + b_1 \cdot (1-x) + b_2 \cdot (1-x)^2 + \cdots +  b_k \cdot (1-x)^k\right)
\end{align}

Do $A(0) = A(1) = 0$ nên $a_0 = b_0 = 1$

Với các ràng buộc đạo hàm cấp 0, 1, 2 tại $\theta$ liên tục

\begin{align}
& \begin{pmatrix}
(1-\theta) & (1-\theta)^2 &  (1-\theta)^3 & \cdots & (1-\theta)^k  \\
- 1 & - 2\cdot(1 - \theta) & -3(1-\theta)^2 & \cdots & -k(1-\theta)^{k-1} \\
0 & 2 & 6(1-\theta) & \cdots & k(k-1) (1-\theta)^{k-2} \\
\end{pmatrix} \times
\begin{pmatrix}
b_1\\
b_2\\
b_3\\
\cdots \\
b_k \\
\end{pmatrix} =
\begin{pmatrix}
\theta & \theta^2 & \theta^3 & \cdots & \theta^k \\
1 & 2\theta & 3\theta^2 & \cdots & k \theta^{k-1} \\
0 & 2 & 6\theta & \cdots & k(k-1) \theta^{k-2} \\
\end{pmatrix} \times
\begin{pmatrix}
a_1\\
a_2\\
a_3\\
\cdots \\
a_k \\
\end{pmatrix} 
\end{align}

- $\cfrac{\partial C(u,v)}{\partial u} > 0$ nên $A(t) - A'(t).t > 0$ với mọi $t$. Do $A''(t) > 0$ nên điều kiện đủ là $b_1 < 1$

- $\cfrac{\partial C(u,v)}{\partial v} > 0$ nên $A(t) + A'(t).(1-t) > 0$ với mọi $t$. Do $A''(t) > 0$ nên điều kiện đủ là $a_1 > -1$



## Thực hành:

### Mô hình mạng nơ-ron trên dữ liệu Boston

### Mô hình mạng nơ-ron để phân loại khách hàng

## Phụ lục

## Bài tập




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



<!-- ### Hồi quy logistic là một mạng nơ-ron không có layer ẩn -->
<!-- Trước khi giới thiệu về cấu trúc của một mô hình mạng nơ-ron, chúng ta sẽ xem xét lại cách hồi quy logistic hoạt động. Sau đó, khi nhìn nhận cách vận hành của hổi quy logistic như một mạng nơ-ron đơn giản, bạn đọc sẽ có hình dung cụ thể hơn về cách xây dựng mô hình mạng nơ-ron.  -->

<!-- Dữ liệu dùng để xây dựng mô hình hồi quy logistic được xây dựng dựa trên dữ liệu bao gồm 5 quan sát được cho trong bảng dưới đây -->

<!-- ```{r table70 input, include=FALSE} -->
<!-- Col0 <- c("A","B","C","D","E","F") -->
<!-- Col1 <- c(1,2,4,3,1.5,3) -->
<!-- Col2 <- c(2,1,1,3,3.0,2) -->
<!-- Col3 <- c("blue", "red", "red", "blue", "blue", "?") -->
<!-- ``` -->

<!-- ```{r, echo=FALSE} -->
<!-- #lik50.tab -->
<!-- df1 <- data.frame(x0 = Col0, x1 = Col1, x2 = Col2, y = Col3) -->
<!-- kable(df1, booktabs = T, -->
<!--       col.names = c("Dữ liệu","x1", -->
<!--         "x2",  -->
<!--         "Màu sắc"), -->
<!--       caption = "Dữ liệu cho hồi quy Logistic",  -->
<!--       escape=F) %>% -->
<!--   column_spec(c(2,3)) %>%  -->
<!--   kable_styling(latex_options = "scale_down") -->
<!-- ``` -->

<!-- ```{r plot1, echo =FALSE} -->
<!-- ggplot(df1, aes(x1,x2,fill=y))+ -->
<!--   geom_point(size=15,alpha=0.8,color="black", shape = 23)+ -->
<!--   geom_text(aes(label=x0),color="black")+ -->
<!--   scale_fill_manual(values=c("grey","red","blue"))+ -->
<!--   xlim(c(0,5))+ylim(c(0,4))+ -->
<!--   theme_classic()+ -->
<!--   xlab("")+ylab("")+ -->
<!--   theme(legend.position = "none") -->
<!-- ``` -->

<!-- Với mỗi điểm dữ liệu bất kỳ, giả sử là điểm A có với các thuộc tính $x_1(A) = $ và $x_2(A) = $, chúng ta sẽ thực hiện hai phép biến đổi kế tiếp nhau: -->

<!-- - Phép biến đổi tuyển tính: với bộ 3 số thực bất kỳ $(b_0, b_1, b_2)$, chúng ta luôn có thể thực hiện phép biến đổi tuyến tính: -->

<!-- $$  -->
<!-- A(1, x_1, x_2) \rightarrow b_0 \times 1 + b_1 \times x_1 + b_2 \times x_2 -->
<!-- $$ -->
<!-- - Phép biến đổi phi tuyến tính: chúng ta sử dụng hàm số $f(x) = sigmoid(x) = \cfrac{1}{1+e^{x}}$ để thực hiện phép biến đổi thứ hai -->

<!-- $$  -->
<!-- b_0 + b_1 x_1 + b_2 x_2 \rightarrow \cfrac{1}{1+e^{b_0 + b_1 x_1 + b_2 x_2}} -->
<!-- $$ -->
<!-- Sau khi thực hiện các phép biến đổi với từng điểm dữ liệu, chúng ta sẽ thu được với mỗi điểm dữ liệu một số nằm trong khoảng $(0,1)$.  -->

<!-- ```{r table701 input, include=FALSE} -->
<!-- Col0 <- c("A","B","C","D","E") -->
<!-- Col1 <- c(1,2,4,3,1.5) -->
<!-- Col2 <- c(2,1,1,3,3.0) -->
<!-- Col3 <- c("blue", "red", "red", "blue", "blue") -->
<!-- Col4 <- c(1,0,0,1,1) -->
<!-- Col5 <- c("$(1+exp(b_0+ b_1+2 b_2))^{-1}$", -->
<!--           "$(1+exp(b_0+2 b_1+ b_2))^{-1}$", -->
<!--           "$(1+exp(b_0+4 b_1+ b_2))^{-1}$", -->
<!--           "$(1+exp(b_0+3 b_1+3 b_2))^{-1}$", -->
<!--           "$(1+exp(b_0+1.5 b_1+3 b_2))^{-1}$") -->

<!-- ``` -->

<!-- ```{r, echo=FALSE} -->
<!-- #lik50.tab -->
<!-- df1 <- data.frame(x0 = Col0, x1=Col1,x2= Col2,y= Col3, yi=Col4, transformation=Col5) -->
<!-- kable(df1, booktabs = T, -->
<!--       col.names = c("Dữ liệu","$x_1$", -->
<!--         "$x_2$",  -->
<!--         "Màu sắc", "Biến mục tiêu ($y_i$)" , "Dữ liệu sau chuyển đổi ($p_i$)"), -->
<!--       caption = "Dữ liệu cho hồi quy Logistic",  -->
<!--       escape=F) %>% -->
<!--   column_spec(c(2,6)) %>%  -->
<!--   kable_styling(latex_options = "scale_down") -->
<!-- ``` -->

<!-- Hàm tổn thất, tính bằng Cross Entropy qua năm điểm dữ liệu A, B, C, D, và E, sẽ là một hàm số của ba biến $(b_0, b_1, b_2)$ như sau -->

<!-- $$ -->
<!-- Loss(b_0, b_1, b_2) = - \sum\limits_{Data = A}^E [y_i \times log(p_i) + (1-y_i) \times log(1-p_i)] -->
<!-- $$ -->
<!-- với giá trị của $y_i$ và $p_i$ được cho bởi bảng ở trên. Bằng thuật toán gradient descent, chúng ta có thể tính toán được giá trị của $(b_0, b_1, b_2)$ sao cho hàm $Loss$ đạt giá trị nhỏ nhất bằng $(25,15,-30)$. Vậy có thể tính toán khả năng điểm $F$ có màu xanh là -->
<!-- $$ -->
<!-- \mathbb{P}(F = blue) = (1+exp(25 + 3 \times 15 + 3 \times -30))^{-1} = 1 -->
<!-- $$ -->
<!-- Như vậy, trong hổi quy logistic, chúng ta đã sử dụng 2 phép biến đổi dữ liệu bao gồm một phép biến đổi tuyến tính thông qua một véc-tơ $b$ và sau đó là một phép biến đổi phi tuyến (hàm sigmoid) để thu được một giá trị duy nhất cho mỗi điểm dữ liệu. Quá trình ước lượng mô hình logistic là quá trình tìm kiếm các tham số $b$ sao cho giá trị đầu ra sau các phép biến đổi của mỗi điểm dữ liệu gần với kết quả mong muốn nhất có thể. -->