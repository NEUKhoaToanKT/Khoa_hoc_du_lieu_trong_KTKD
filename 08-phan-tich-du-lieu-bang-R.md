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
## The following object is masked from 'package:pryr':
## 
##     where
```

```
## The following object is masked from 'package:gridExtra':
## 
##     combine
```

```
## The following object is masked from 'package:kableExtra':
## 
##     group_rows
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
## Attaching package: 'lubridate'
```

```
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```



# Nhập dữ liệu vào R

Trong phần này của cuốn sách, bạn sẽ tìm hiểu về các kỹ thuật phân tích dữ liệu, bao gồm có tiền xử lý dữ liệu, sắp xếp dữ liệu và trực quan hóa dữ liệu.

- Tiền xử lý dữ liệu bao gồm tất cả các kỹ thuật biến đổi dữ liệu thô thành định dạng để có thể thực hiện phân tích. Dữ liệu thô bao gồm dữ liệu nhận được từ người khác hoặc dữ liệu mà người phân tích tự tìm kiếm từ các nguồn khác nhau.

- Sắp xếp dữ liệu bao gồm các bước biến đổi, chuyển hóa dữ liệu thành định dạng để có thể trực quan hóa, thực hiện phân tích tính toán và xây dựng mô hình trên dữ liệu.

- Trực quan hóa dữ liệu là một nghệ thuật biến đổi dữ liệu (thường được hiển thị dưới dạng các con số, chuỗi ký tự,...) thành các biểu đồ, đồ thị hay hình ảnh sử dụng hình dạng, màu sắc, khoảng cách để con người dễ dàng nhận thức và hiểu về dữ liệu. Trực quan hóa dữ liệu còn có thể giúp người phân tích tìm ra những giá trị ẩn chứa trong dữ liệu.

Tuy nhiên, trước khi có thể bắt đầu bước tiền xử lý, chúng ta cần nhập dữ liệu vào R trước. Trong một vài trường hợp, nhập dữ liệu chỉ đơn giản là nhập từ một bảng excel có sẵn. Trong một số trường hợp khác, quá trình nhập dữ liệu có thể phức tạp hơn, chẳng hạn như từ một (vài) phần nào đó trong một hoặc nhiều bảng excel, hoặc từ một cơ sở dữ liệu được lưu trữ trong các máy tính server, hoặc đôi khi cần có thể cần viết các vòng lặp để lấy dữ liệu từ các trình duyệt web. Đây là chủ đề mà chúng ta sẽ thảo luận trong chương đầu của phần phân tích dữ liệu. 

## Đối tượng dùng để lưu dữ liệu trong R
Hai kiểu đối tượng thường được dùng để lưu dữ liệu trong R là data.frame và tibble. Chúng ta sẽ thảo luận về data.frame trước vì đây là kiểu lưu dữ liệu phổ biến và xuất hiện trước. Đối tượng kiểu tibble, với một vài ưu điểm hơn data.frame, sẽ được thảo luận trong phần tiếp theo.

### data.frame là gì? 

Data.frame là đối tượng phổ biến nhất để lưu trữ dữ liệu trên môi trường làm việc của R. Hiểu một cách đơn giản, một data.frame giống như một bảng excel mà mỗi cột tương ứng với một véc-tơ và mỗi dòng tương ứng với một quan sát. Ngay khi cài đặt R, đã có nhiều đối tượng là dữ liệu kiểu data.frame đã được lưu trữ trong R và đã sẵn sàng được sử dụng mà không cần gọi thư viện bổ sung. Để biết trên cửa sổ Rstudio đang sử dụng có những dữ liệu nào, bạn đọc sử dụng câu lệnh `data()` 

```r
data()
```

Bạn đọc có thể thấy trên cửa sổ $script$ xuất hiện một cửa sổ mới với danh sách tất cả các dữ liệu sẵn có trong R và những dữ liệu sẵn có trong các thư viện được cài đặt thêm đang được gọi ra trên cửa sổ làm việc. Để biết trong một thư viện đang được gọi ra trên cửa sổ Rstudio có những dữ liệu nào, bạn đọc có thể sử dụng lệnh `data()` kèm với tùy chọn `package` như sau:

```r
library(dslabs) # Gọi thư viện dslabs 
data(package = "dslabs") # Liệt kê những data trong dslabs
```

Trong danh sách dữ liệu của thư viện $\textf{dslabs}$, bạn đọc có thể thấy một đối tượng có tên $\textbf{murders}$. Đây là một data.frame. Thật vậy, bạn đọc có thể kiểm tra kiểu của đối tượng này bằng hàm `class()`:

```r
class(murders) # Trả lại kết quả là một data frame
```

```
## [1] "data.frame"
```

Thông thường để có hiểu biết ban đầu về một đối tượng kiểu data.frame, bạn đọc nên bắt đầu bằng đọc mô tả về dữ liệu (nếu có) bằng cách sử dụng `?` nếu đây là một dữ liệu có sẵn trong các thư viện của R:

```r
? murders # Cửa sổ help sẽ hiển thị mô tả về murders
```

Nhóm các câu lệnh dưới đây giúp bạn đọc hiểu được cấu trúc của dữ liệu trong một data.frame:

```r
View(murders) # Hiển thị data.frame dưới dạng bảng 
head(murders,k = 5) # Hiển thị k dòng đầu tiên của data.frame
str(murders) # Hiển thị cấu trúc của data.frame
```

- Hàm `head()` hiển thị nhanh các dòng đầu tiên của dữ liệu cho bạn đọc cái nhìn ban đầu, tuy nhiên hàm `head()` không hiệu quả khi dữ liệu có nhiều cột. 

- Hàm `View()` cho hiển thị về dữ liệu dễ nhìn nhất. Hàm `View()` có hạn chế khi dữ liệu có quá nhiều dòng hoặc nhiều cột và thời gian hiển thị lâu hơn so với `head()`. 

- Hàm `str()` là cách hiển thị dữ liệu một cách tổng quát và hiệu quả hơn so với `head()` hoặc `View()`. Kết quả từ hàm `str()` với dữ liệu $\textbf{murders}$ cho thấy đây là một dữ liệu dạng bảng với 5 cột (còn gọi là variables) và 51 dòng (còn gọi là observations). Ngoài ra, sử dụng hàm `str()` bạn đọc có thể thấy được kiểu dữ liệu của từng cột; chẳng hạn như cột state là cột chứa dữ liệu kiểu chuỗi ký tự; cột region có kiểu dữ liệu là factor,... 

Một hàm số hiệu quả khác thường được sử dụng để bạn đọc có cái nhìn tổng quan về dữ liệu là hàm `summary()`. Chúng ta có thể quan sát kết quả khi sử dụng hàm `summary()` với dữ liệu $\textbf{murders}$ như sau

```r
summary(murders)
```

```
##     state               abb                      region     population      
##  Length:51          Length:51          Northeast    : 9   Min.   :  563626  
##  Class :character   Class :character   South        :17   1st Qu.: 1696962  
##  Mode  :character   Mode  :character   North Central:12   Median : 4339367  
##                                        West         :13   Mean   : 6075769  
##                                                           3rd Qu.: 6636084  
##                                                           Max.   :37253956  
##      total       
##  Min.   :   2.0  
##  1st Qu.:  24.5  
##  Median :  97.0  
##  Mean   : 184.4  
##  3rd Qu.: 268.0  
##  Max.   :1257.0
```

Hàm `summary()` cho biết thông chi tiết hơn về giá trị trong mỗi cột. 

- Cột state và cột abb là cột mà giá trị trong đó là kiểu chuỗi ký tự;

- Cột region là kiểu factor, có thể nhận một trong bốn giá trị là Northeast, South, North Central, hoặc West và cho biết mỗi giá trị xuất hiện bao nhiêu lần trong cột dữ liệu.

- Các cột population và total là các cột kiểu số. Chúng ta có thể thấy các giá trị lớn nhất, nhỏ nhất, giá trị trung bình và các giá trị tứ phân vị. Bạn đọc có thể hình dung ra phân phối của các giá trị trong cột giá trị kiểu số.

- Trong trường hợp cột có giá trị không quan sát được, hàm `summary()` cũng sẽ cho biết có bao nhiêu giá trị này trong mỗi cột.

Để lấy ra một cột dữ liệu của một data.frame chúng ta sử dụng $\$$. Chẳng hạn như để lấy giá trị cột population của dữ liệu murders:


```r
murders$population # in ra màn hình cột population của data.frame murders
```

Như chúng tôi đã đề cập, kiểu dữ liệu của cột $region$ là kiểu $factor$. Về bản chất, véc-tơ kiểu $factor$ là một véc-tơ kiểu chuỗi ký tự nhưng được lưu theo một cách hiệu quả hơn, tiết kiệm bộ nhớ, và thuận lợi cho người sử dụng khi phân tích dữ liệu.

- Véc-tơ kiểu factor sẽ tương ứng với véc-tơ kiểu chuỗi ký tự nhưng được lưu dưới dạng vec-tơ số tự nhiên, bắt đầu từ 1 đến số lượng chuỗi ký tự khác biệt xuất hiện trong véc-tơ và mỗi chuỗi ký tự sẽ được cho tương ứng với một số tự nhiên. Các lưu này hiệu quả hơn về bộ nhớ khi làm việc với các véc-tơ kiểu chuỗi ký tự nếu có nhiều chuỗi ký tự bị lặp lại trong véc-tơ. Để biết một vec-tơ dạng factor có bao nhiêu giá trị riêng biệt, mỗi giá trị riêng biệt được cho tương ứng với số tự nhiên nào, và mỗi giá trị riêng biệt được lặp lại bao nhiêu lần trong véc-tơ, bạn đọc sử dụng hàm `summary()` hoặc hàm `table()`

```r
# summary(murders$region) # Tổng hợp thông tin của vec-tơ dạng factor
table(murders$region) # cho kết quả tương tự như summary
```

```
## 
##     Northeast         South North Central          West 
##             9            17            12            13
```

Kết quả từ hàm `table()` cho thấy cột $region$ có 4 giá trị; cách cho tương ứng mỗi chuỗi ký tự với các số lần lượt là $Northeast \rightarrow 1$ ; $South \rightarrow 2$; $North Central \rightarrow 3$, và $West \rightarrow 4$; tần suất xuất hiện của mỗi giá trị cũng được cho trong bảng: có 9 giá trị $Northeast$, có 17 giá trị $South$, có 12 giá trị $North Central$, và 13 giá trị $West$.

Một lưu ý khác khi sử dụng véc-tơ kiểu factor thay vì kiểu chuỗi ký tự nghĩa là bạn đọc đang định nghĩa dữ liệu là kiểu biến rời rạc hay các biến định tính. Các biến này có thể trực tiếp đưa vào các mô hình và không cần thực hiện thêm biến đổi nào khác.

Trong hầu hết các trường hợp, bạn đọc sẽ dùng R để xử lý dữ liệu từ nguồn ngoài vào. Chúng ta sẽ sử dụng các hàm có sẵn trong R đọc dữ liệu và kết quả đầu ra của hàm này sẽ là các $data.frame$. Trong một vài trường hợp, bạn đọc sẽ phải tự tạo $data.frame$. Câu lệnh để tạo một $data.frame$ (tên $df$) với các cột có tên lần lượt là $id$, $names$, $grades$, và $result$ được viết như sau:

```r
df<-data.frame( # Hàm data.frame() dùng để tạo data.frame tên df
      id = paste("SV",1:5), # Cột có tên là ID nhận giá trị "SV1",...,"SV5"
      names = c("You", "Me", "Him", "Her", "John"), # Cột names
      grades = c(5.5, 1.5, 10.0, 9.0, 7.6), # Cột grades
      result = c(TRUE, FALSE,TRUE, TRUE, TRUE)) # Cột result
```

Đối tượng kiểu $data.frame$ có một vài nhược điểm khi sử dụng để lưu dữ liệu từ các nguồn khác nhau vào R. Do đó kiểu đối tượng mới được phát triển để khắc phục các nhược điểm này, đó là $tibble$. Phần tiếp theo chúng ta sẽ thảo luận về đối tượng này.

### $tibble$ là một cải tiến của $data.frame$?
Về cơ bản một $tibble$ là cũng có thể hiểu là một $data.frame$ với một vài điều chỉnh để giúp việc lấy dữ liệu từ nguồn bên ngoài vào và phân tích trở nên dễ dàng hơn. Thực tế thì ở mức độ phân tích dữ liệu thông thường, sự khác khác nhau giữa $tibble$ và $data.frame$ là không đáng kể. Để liệt kê ra sự khác nhau cơ bản giữu hai đối tượng này thì có thể kể đến:

- Thứ nhất: khi in một $tibble$ ra màn hình sẽ chỉ có 10 dòng đầu được hiển thị và số lượng cột của một $tibble$ luôn luôn khớp với kích thước cửa sổ R Console, đồng thời kiểu dữ liệu của mỗi cột sẽ được hiển thị ngay dưới tên cột

```r
library(tibble)
trump_tweets # in một data frame ra màn hình sẽ không hiệu quả
# Hàm as_tibble đổi data.frame sang tibble
as_tibble(trump_tweets) # Hiển thị 1 tibble hiệu quả hơn.
```

- Thứ hai: khi lấy dữ liệu từ bên ngoài vào trong R, $tibble$ không đổi tên cột dù tên cột không phải là kiểu tên được phép trong R. Đồng thời, khi tạo một $tibble$, bạn đọc có thể đặt tên cột là một kiểu tên không được phép sử dụng với tên biến thông thường.

- Cuối cùng, khi dữ liệu từ bên ngoài được lưu vào một $tibble$, kiểu dữ liệu sẽ không thay đổi.

Để tạo một $tibble$, bạn đọc có thể sử dụng hàm `tibble()`. Bạn đọc có thể tạo ra một dữ liệu có 3 cột mà tên các cột đều không thể được sử dụng làm tên biến trong R như sau

```r
tib<-tibble( # hàm tibble dùng để tạo tibble
  ":D" = c(1,2,3), # có thể dùng tên cột là ":D"
  ":p" = c("X","Y","Z"), # có thể dùng tên cột là ":p"
  "1" = 2 # có thể dùng tên cột là "1"
)
tib
```

```
## # A tibble: 3 × 3
##    `:D` `:p`    `1`
##   <dbl> <chr> <dbl>
## 1     1 X         2
## 2     2 Y         2
## 3     3 Z         2
```

Nếu thay thế đoạn lệnh trên bằng hàm `data.frame()` thì hàm $data.frame$ được tạo thành sẽ tự động thay đổi tên cột

```r
df<-data.frame( # tạo data.frame thay vì tibble
  ":D" = c(1,2,3), # data.frame sẽ đổi tên cột cho phù hợp
  ":p" = c("X","Y","Z"), # data.frame sẽ đổi tên cột cho phù hợp
  "1" = 2 # data.frame sẽ đổi tên cột cho phù hợp
)
df # hãy quan sát xem tên cột của df thay đổi như thế nào
```

```
##   X.D X.p X1
## 1   1   X  2
## 2   2   Y  2
## 3   3   Z  2
```

Bạn đọc có thể thấy rằng dữ liệu có tên $df$ nếu được lưu dưới dạng $data.frame$ thì tên các cột đã được tự động thay đổi cho thích hợp với tên biến. Những điểm khác nhau giữa $tibble$ và $data.frame$ sẽ được tiếp tục thảo luận ở các phần tiếp theo khi chúng tôi giới thiệu về các hàm dùng để nhập dữ liệu vào R.

## Nhập dữ liệu bằng hàm sẵn có.
Danh sách các hàm sẵn có trong R và kiểu dữ liệu tương ứng có thể nhập được liệt kê trong các bảng \@ref(tab:tbptdl001)
<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl001 )Danh sách hàm có sẵn để lấy dữ liệu từ nguồn bên ngoài</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Hàm số </th>
   <th style="text-align:left;"> Sử dụng trong trường hợp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> read.table() </td>
   <td style="text-align:left;"> Đọc các file có đuôi dạng .txt </td>
  </tr>
  <tr>
   <td style="text-align:left;"> read.csv() </td>
   <td style="text-align:left;"> file dạng csv mà giá trị được ngăn cách bằng dấu ',' </td>
  </tr>
  <tr>
   <td style="text-align:left;"> read.csv2() </td>
   <td style="text-align:left;"> file dạng csv mà giá trị được ngăn cách bằng dấu ';' </td>
  </tr>
  <tr>
   <td style="text-align:left;"> read.delim() </td>
   <td style="text-align:left;"> Các file dạng text, các giá trị cách nhau bởi ký tự mà bạn đọc định nghĩa </td>
  </tr>
  <tr>
   <td style="text-align:left;"> readRDS() </td>
   <td style="text-align:left;"> Dữ liệu được lưu dưới dạng .rds </td>
  </tr>
  <tr>
   <td style="text-align:left;"> load() </td>
   <td style="text-align:left;"> Dữ liệu kiểu data có sẵn trong R </td>
  </tr>
</tbody>
</table>

Khi lấy dữ liệu từ các nguồn bên ngoài vào bằng các câu lệnh có sẵn, tên của các cột dữ liệu có thể bị thay đổi do một số tên cột không thể được dùng để đặt tên của $data.frame$. Do đó, bạn đọc hãy luôn kiểm tra lại tên các cột dữ liệu sau khi đọc. Hàm `names()` cho biết tên các cột của một $data.frame$.

```r
df<-read.csv(header = TRUE, 
              text = "@1,@2 
                      1,2 
                      3,4") # sử dụng read.csv để đọc đoạn text
names(df) # hiển thị tên của các cột
```

```
## [1] "X.1" "X.2"
```

Để đổi tên của $data.frame$ ở trên, bạn đọc cần gán $names(df)$ bằng một véc-tơ chứa tên các cột. Hãy đảm bảo rằng độ dài của vec-tơ chứa tên cột bằng số cột của $data.frame$ 

```r
names(df)<-c("@1","@2") # đổi tên 2 cột của data.frame df
df # in data.frame df
```

```
##   @1 @2
## 1  1  2
## 2  3  4
```

## Nhập dữ liệu bằng thư viện $\textbf{readr}$.

Các câu lệnh để đọc dữ liệu của thư viện $readr$ tương tự như các câu lệnh sẵn có, nhưng đặc biệt hiệu quả hơn về thời gian đọc dữ liệu. Chẳng hạn như hàm số dùng để đọc các file định dạng $csv$ trong thư viện $readr$ là hàm `read_csv()` được dùng thay thế cho `read.csv()` khi chúng ta cần đọc các file có dung lượng lớn. Để so sánh thời gian đọc dữ liệu của hàm `read_csv()` và hàm `read.csv()` bạn đọc có thể thực hiện ví dụ sau: chúng ta sẽ tạo hai file dữ liệu bao gồm `test1.csv` và `test2.csv` là các file chứa các số được sinh ngẫu nhiên. Dữ liệu `test1.csv` có $10^2$ hàng và $10^4$ cột trong khi dữ liệu `test2.csv` có $10^2$ hàng và $10^5$ cột. Các dữ liệu này có thể được tạo và lưu bằng các câu lệnh dưới đây:

```r
x<-matrix(rnorm(10^6),10^2,10^4) # Ma trận 100 hàng, 10^4 cột
write.csv(x,"test1.csv") # Ma tran thanh file .csv
x<-matrix(rnorm(10^7),10^2,10^5) # Ma trận 100 hàng, 10^5 cột
write.csv(x,"test2.csv") # Ma tran thanh file .csv
```

Bạn đọc có thể kiểm tra kích thước của các file $test1.csv$ và $test2.csv$ trên máy tính để thấy rằng dung lượng của các file lần lượt là 18 Mega byte và 180 Mega byte. Chúng ta sẽ kiểm tra thời gian mà các hàm `read.csv()` và `read_csv()` nhập dữ liệu đối với dữ liệu test1.csv trước: 

```r
start<-proc.time() # lưu lại thời điểm trước khi chạy read.csv
dat<-read.csv("test1.csv") # dùng hàm read.csv để load dữ liệu 
proc.time() - start # tính thời gian hàm read.csv chạy

start<-proc.time() # lưu lại thời điểm trước khi chạy read_csv
dat<-read_csv("test1.csv") # dùng hàm read_csv để load dữ liệu 
proc.time() - start # tính thời gian hàm read_csv chạy
```

Đối với dữ liệu `test1.csv` thì thời gian nhập dữ liệu của `read_csv()` có nhanh hơn nhưng không có sự khác biệt đáng kể. Tuy nhiên sự khác biệt sẽ rõ ràng khi nhập dữ liệu $test2.csv$. Bạn đọc cân nhắc khi dùng hàm `read.csv()` đọc dữ liệu bởi thời gian nhập dữ liệu với những file có dung lượng hơn 100 Mega bytes có thể lên đến hơn 20 phút.


```r
start<-proc.time() # lưu lại thời điểm trước khi chạy read.csv
dat<-read.csv("test2.csv") # !!! THỜI GIAN CHẠY CÓ THỂ LÊN ĐẾN 20-25 phút
proc.time() - start # tính thời gian hàm read.csv chạy

start<-proc.time() # lưu lại thời điểm trước khi chạy read_csv
dat<-read_csv("test2.csv") # dùng hàm read_csv để load dữ liệu 
proc.time() - start # tính thời gian hàm read_csv chạy
```

Trên máy tính của chúng tôi, hàm `read_csv()` sẽ mất khoảng 2 phút để đọc dữ liệu `test2.csv`, nghĩa là thời gian tiết kiêm lên đến hơn 10 lần. Ngoài hàm `read_csv()`, thư viện $\textbf{readr}$ còn có các hàm để đọc các kiểu định dạng file khác nhau. Danh sách các hàm thường hay dùng được liệt kê trong bảng \@ref(tab:tbptdl002)



<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-18)Danh sách hàm đọc dữ liệu của thư viện readr</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Hàm số </th>
   <th style="text-align:left;"> Sử dụng trong trường hợp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> read_csv() </td>
   <td style="text-align:left;"> file dạng csv mà giá trị được ngăn cách bằng dấu ',' </td>
  </tr>
  <tr>
   <td style="text-align:left;"> read_csv2() </td>
   <td style="text-align:left;"> file dạng csv mà giá trị được ngăn cách bằng dấu ';' </td>
  </tr>
  <tr>
   <td style="text-align:left;"> read_tsv() </td>
   <td style="text-align:left;"> Các file dạng text mà các giá trị cách nhau bởi khoảng trống </td>
  </tr>
  <tr>
   <td style="text-align:left;"> read_delim() </td>
   <td style="text-align:left;"> Các file dạng text mà các giá trị cách nhau bởi ký tự bất kỳ </td>
  </tr>
</tbody>
</table>
Một sự khác biệt cơ bản khác của các hàm đọc dữ liệu trong thư viện $\textbf{readr}$ đó là dữ liệu được lưu vào một tibble thay vì một data.frame. Điều này giúp cho dữ liệu không bị thay đổi định dạng và giữ nguyên tên cột. Các lưu ý khác khi bạn đọc sử dụng các hàm số đọc dữ liệu của thư viện $\textbf{readr}$ là

- Các hàm số trong thư viện $\textbf{readr}$ luôn hiểu hàng đầu tiên của dữ liệu là tên của mỗi cột. Do đó, bạn đọc cần sử dụng tham số $col_names = FALSE$ nếu không muốn R tự động hiểu hàng đầu tiên là tên của mỗi cột dữ liệu. Ví dụ, hãy quan sát sự khác nhau giữa việc có và không sử dụng `col_names = FALSE`:

```r
library(readr)
# Kết quả sẽ là một Tibble 1 hàng và 3 cột
read_csv("1,2,3 
         4,5,6") # Tên các cột là "1", "2", và "3"
```

```
## # A tibble: 1 × 3
##     `1`   `2`   `3`
##   <dbl> <dbl> <dbl>
## 1     4     5     6
```


```r
# Kết quả sẽ là một Tibble 2 hàng và 3 cột
read_csv("1,2,3 
         4,5,6", col_names = FALSE)
```

```
## # A tibble: 2 × 3
##      X1    X2    X3
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     5     6
```

```r
# readr tự động đặt tên các cột X1, X2, X3
```
bạn đọc có thể thấy rằng khi không sử dụng `col_names = FALSE`, hàm `read_csv()` sẽ hiểu hàng đầu tiên, tương ứng với các số 1, 2, và 3, là tên các cột và hàng thứ hai là dữ liệu. Điều này giải thích tại sao tibble chỉ có 1 hàng. Khi chúng ta sử dụng `col_names = FALSE`, hàm `read_csv()` sẽ tự động đặt tên các cột là "X1", "X2", "X3" và dữ liệu sẽ có 2 hàng.

- Trong nhiều file dữ liệu, người gửi thường sử dụng các hàng đầu tiên để mô tả về dữ liệu. Do đó khi sử dụng các hàm trong thư viện $\textbf{readr}$, bạn đọc có thể sử dụng tham số `skip = k` để loại bỏ $k$ dòng đầu tiên của file dữ liệu. Ví dụ:

```r
# Kết quả sẽ là một Tibble 2 hàng và 3 cột
read_csv("Trường ĐHKTQD
        Khoa toán Kinh tế
         1,2,3 
         4,5,6", col_names = FALSE, skip = 2) # readr sẽ không đọc 2 dòng đầu
```

```
## Rows: 2 Columns: 3
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## dbl (3): X1, X2, X3
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```
## # A tibble: 2 × 3
##      X1    X2    X3
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     5     6
```
Bạn đọc cũng có thể sử dụng tham số $col_names$ để gán giá trị cho tên các cột ngay trong hàm `read_csv()`. Tuy nhiên để tránh sự phức tạp, chúng tôi khuyên bạn đọc hãy đặt tên cho các cột bằng hàm `names()` sau khi lưu dữ liệu vào tibble.

Cách sử dụng các hàm khác ngoài `read_csv()` bạn đọc có thể tham khảo trong hướng dẫn của thư viện $\textbf{readr}$. Sau khi đọc qua hướng dẫn, bạn đọc hãy thử kiểm tra xem các câu lệnh sau có vấn đề gì và nếu có thể, bạn đọc hãy thử lựa chọn hàm hoặc thêm tham số phù hợp để đọc dữ liệu.


```r
read_csv("x,y\n1,2,3\n4,5,6") # \n thay cho xuống dòng
read_csv("x,y,z\n1,2\n1,2,3,4") 
read_csv("x,y\n\",1,\n,a,b",col_names = FALSE) 
read_csv("x;y\n1;2\nx;y") # Thử hàm số khác
read_csv("x|y\n1|2") # Thử hàm số khác
```

## Tương tác giữa R với Microsoft Excel
Microsoft Excel là rất phổ biến trong môi trường làm việc công sở. Do đó, người phân tích dữ liệu thường xuyên nhận được dữ liệu trong các file có xls, xlsx, xlsb, hoặc xlsm. Tất nhiên, bạn đọc có thể sử dụng trực tiếp Microsoft Excel để thực hiện những phân tích và tính toán đơn giản. Nhưng để thực hiện các yêu cầu phức tạp hơn, chẳng hạn như làm việc với nhiều file Excel, hoặc thực hiện xây dựng các mô hình trên dữ liệu bạn đọc cần phải sử dụng R. Các thư viện cần cài đặt bổ sung mà chúng thôi thường sử dụng để kết nối giữa R với Microsoft Excel là thư viện $\textbf{readxl}$ và $\textbf{openxlsx}$. Nếu như thư viện $\textbf{readxl}$ chỉ đơn thuần là để đọc dữ liệu từ Excel thì thư viện $\textbf{openxlsx}$ còn cho phép chúng ta điều khiển, tính toán, và định dạng các file có định dạnh ở trên mà không cần mở Microsoft Excel. Cách sử dụng các hàm cơ bản trong hai thư viện này được trình bày trong các phần dưới đây.

### Đọc dữ liệu lưu dưới định dạng của Excel
Hàm `read_excel()` được sử dụng để đọc các file được lưu bằng Microsoft Excel. Hàm số sẽ hỗ trợ đọc các file có định dạng xlsx, xlsm, xls. Hai biến thể khác của `read_excel()` là `read_xlsx()` và `read_xls()` được sử dụng khi chúng ta biết chính xác định dạng của file cần đọc. Các tham số thường được sử dụng trong các hàm này được liệt kê như sau:

- `sheet` cho biết tên của sheet của excel workbook. Sử dụng tham số này có ý nghĩa khi workbook chúng ta cần lấy dữ liệu có nhiều sheet. Nếu không sử dụng tham số này, hàm `read_excel()` sẽ luôn luôn đọc dữ liệu trong sheet thứ nhất của excel workbook.

- `range` được sử dụng nếu bạn đọc chỉ muốn đọc dữ liệu từ một phần của của sheet. Chẳng hạn như `range = "A1:E100"` nghĩa là bạn đọc chỉ muốn lấy dữ liệu từ cell A1 đến cell E100 của sheet tương ứng.

- `col_names` nhận một trong hai giá trị là TRUE hoặc FALSE. Giá trị TRUE cho biết có sử dụng hàng đầu tiên làm tên các cột trong dữ liệu trong khi giá trị FALSE cho biết không lấy hàng đầu tiên làm tên cột.

- `skip` cho biết số lượng dòng sẽ bỏ qua trước khi bắt đầu đọc dữ liệu. Nếu có sử dụng tham số `range` thì hàm `read_excel()` sẽ bỏ qua tham số này.

Ngoài ra hàm `read_excel()` còn có các tham số khác có thể hữu ích trong nhiều trường hợp như `col_types` hay `n_max`. Bạn đọc hãy đọc mô tả hàm số để hiểu chính xác hơn về các tham số. Đoạn lệnh dưới đây được sử dụng để đọc dữ liệu nằm trong range được giới hạn từ cell A1 đến cell E100, trong sheet có tên ws1, và workbook có tên "wb1.xlsx"

```r
setwd(path) # Đặt đường dẫn đến folder chứa file
dat<-read_xlsx("wb1.xlsx", 
               sheet = "ws1",
               range = "A1:E100",
               col_names = TRUE)
```

### Tương tác với Microsoft Excel bằng thư viện $\textbf{openxlsx}$
Ngoài việc lấy dữ liệu từ các file được lưu dưới định dạnh của Excel, bạn đọc cũng có thể sử dụng R để thực hiện tính toán ngay trên các worksheet và lưu lại kết quả mà không cần phải mở file. Thư viện $openxlsx$ sẽ giúp bạn đọc làm được việc này. Các hàm quan trọng sử dụng để làm việc trên các worksheet là: `loadWorkbook()`, `addWorksheet()` hàm `writeData()`, và hàm `saveWorkbook()`.

Hàm `loadWorkbook()` đượpc sử dụng để mở một workbook và lưu thành một đối tượng kiểu workbook trên R. Đoạn lệnh dưới đây dùng để lấy thông tin từ file có tên là "mau bd.xlsx" trong đường dẫn tương ứng và sau đó lưu thông tin vào một đối tượng kiểu workbook trên R có tên $wb1$:

```r
wb1<-loadWorkbook("../KHDL_KTKD Final/Dataset/mau bd.xlsx")
```
Hàm `str()` có thể sử dụng để xem cấu trúc của đối tượng wb1. Tuy nhiên các workbook lớn có thể làm cho kết quả của hàm `str()` trở nên khó hiểu. Nhìn chung đối tượng kiểu workbook sẽ hoạt động tương đối giống như một list. Mỗi list con tương ứng với một sheet của workbook Bạn đọc có thể sử dụng hàm `names()` để biết wb1 có những sheet nào:

```r
class(wb1)
```

```
## [1] "Workbook"
## attr(,"package")
## [1] "openxlsx"
```

```r
names(wb1)
```

```
## [1] "Sheet"  "Sheet1"
```

Hàm `addWorksheet()` được sử dụng để thêm một worksheet vào trong một đối tượng workbook. Cấu trúc câu lệnh của hàm `addWworksheet()` khá đơn giản và các tham số được sử dụng chủ yếu là để thiết kế worksheet mới thêm vào nên chúng tôi không liệt kê ở đây. Đoạn câu lệnh sau được sử dụng để thêm vào workbook wb1 một worksheet có tên là "Sheet 2"

```r
addWorksheet(wb1, "Sheet 2")
```

Hàm `writeData()` được sử dụng để thay đổi và sửa thông tin trên đối tượng workbook. Các tham số quan trọng với hàm `writeData()` được liệt kê ở dưới đây:

- `startCol`: chỉ số của cột trên worksheet mà chúng ta bắt đầu ghi thông tin lên. Nếu không sử dụng tham số này, chỉ số cột đầu tiên sẽ luôn là 1, nghĩa là cột A của workssheet.

- `statRow`: chỉ số của hàng trên worksheet mà chúng ta bắt đầu ghi thông tin lên. Nếu không sử dụng tham số này, chỉ số hàng đầu tiên sẽ luôn là 1.

- `colNames`: nhận giá trị bằng TRUE hoặc FALSE. Giá trị TRUE cho biết có ghi nhận thông tin tên cột của dữ liệu (hoặc véc-tơ) vào hàng đầu tiên. Giá trị FALSE nghĩa là không ghi nhận tên cột của dữ liệu hay véc-tơ vào hàng đầu tiên.

- `rowNames`: : nhận giá trị bằng TRUE hoặc FALSE. Giá trị TRUE cho biết có ghi nhận thông tin tên hàng của dữ liệu (hoặc véc-tơ) vào cột đầu tiên của worksheet. Giá trị FALSE nghĩa là không ghi nhận tên hàng của dữ liệu hay véc-tơ vào hàng đầu tiên của worksheet.

Đoạn câu lệnh sau sẽ lưu thông tin của một data.frame có tên là $\textbf{women}$ bắt đầu từ hàng thứ nhất, cột thứ nhất (cell A1) vào sheet có tên là "Sheet 2" của workbook wb1:

```r
writeData(wb1, "Sheet 2", women, startCol = 1, startRow = 1, colNames = TRUE, rowNames = FALSE)
```

Hàm số `saveWorkbook()` được sử dụng để lưu một đối tượng workbook (của R) thành một excel workbook.


```r
saveWorkbook(wb1, "mau bd1.xlsx", overwrite = TRUE)
```

Bạn đọc có thể sử dụng Microsoft excel để mở workbook có tên "mau bd1.xlsx" và xem thông tin về dữ liệu $\textbf{women}$ ở trong worksheet có tên là "Sheet 2" của workbook này. Tham số `overwrite` nhận giá trị TRUE có nghĩa là nếu trong đường dẫn tương ứng đã có file có tên trùng với tên workbook mới thì sẽ lưu workbook mới thay thế cho workbook cũ có trùng tên.

## Kết nối R với cơ sở dữ liệu
Có thể sử dụng R như một công cụ để kết nối và thực hiện các câu lệnh truy vấn vào các cơ sở dữ liệu. Để làm được điều này, trước tiên, bạn đọc cần phải cài đặt một Open Database Connectivity (ODBC), được gọi là kết nối cơ sở dữ liệu mở. Kết nối này giúp cho hệ điều hành máy tính tương thích với hệ quản lý cơ sở dữ liệu mà bạn sử dụng. Nhóm tác giả sử dụng hệ điều hành Windows và hệ quản trị cơ sở dữ liệu MySQL nên chúng tôi sẽ lựa chọn ODBC phù hợp. Bạn đọc tham khảo tại địa chỉ https://dev.mysql.com/downloads/connector/odbc/. Tại thời điểm nhóm tác giả viết cuốn sách này ODBC cho hệ điều hành Windows đang là phiên bản 8.0

Sau khi cài đặt ODBC lên hệ điều hành, bạn đọc đã có thể sử dụng R để truy cập vào một cơ sở dữ liệu và thực hiện các câu lệnh truy vấn dữ liệu trên cơ sở dữ liệu đó trên R với sự trợ giúp của thư viện $DBI$. Sau khi cài đặt thư viện $DBI$, bạn đọc cần tạo một kết nối giữa R và cơ sở dữ liệu bằng hàm $dbConnect$.


```r
library(DBI)
con <- dbConnect(odbc::odbc(), .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
    Server = "ten_serve", Database = "db_name", UID = "ID", PWD = "password")
```
Trong đó "ten_serve" là địa chỉ local hoặc server lưu trữ cơ sở dữ liệu, "db_name" là tên của cơ sở dữ liệu, ID và password lần lượt là tên và password mà bạn đọc tự tạo hoặc được cấp để truy cập vào cơ sở dữ liệu. Sau khi đã tạo được kết nối, bạn đọc có thể thực hiện bất kỳ câu lệnh truy vấn dữ liệu nào từ R với hàm "DBI::dbGetQuery()". Chẳng hạn, bạn đọc muốn lấy ra thông tin của tất cả những người có ngày sinh là ngày 01 tháng 01 năm 2000 từ một bảng có tên là Life_Insured từ một cơ sở dữ liệu tên là $tktdb$, bạn đọc thực hiện như sau

```r
sql<-"select * from tktdb.Life_Insured 
      where DOB = '2000-01-01'" # Viết đúng câu lệnh truy vấn từ MySQL
df<-DBI::dbGetQuery(sql) # data.frame df sẽ lưu kết quả của câu lệnh truy vấn
```

Khi làm việc với dữ liệu được trích xuất từ một hệ cơ sở dữ liệu, bạn đọc hãy cố gắng thực hiện các phép biến đổi, sắp xếp dữ liệu bằng SQL thay vì thực hiện biến đổi trên R vì các hệ quản trị cơ sở dữ liệu thực hiện các chức năng này nhanh hơn.

## Thu thập dữ liệu từ các website


## Phụ lục


## Bài tập



# Tiền xử lý dữ liệu
Tiền xử lý dữ liệu là một công việc đòi hỏi sự tỉ mỉ cẩn thận và là một trong những bước quan trọng nhất trong một quy trình làm việc trên dữ liệu. Tiền xử lý dữ liệu là tập hợp tất cả các bước kỹ thuật nhằm đảm bảo cho dữ liệu bạn sử dụng phân tích hoặc xây dựng mô hình được đảm bảo về định dạng, giá trị, và ý nghĩa. Hiểu một cách đơn giản, tiền xử lý dữ liệu là quá trình biến dữ liệu thô thành dữ liệu có thể sử dụng được để phân tích và đưa ra kết quả.

Khi làm việc với dữ liệu, thực tế là đến hơn 50\% các trường hợp bạn đọc sẽ nhận được những dữ liệu ở dạng thô chưa qua tiền xử lý. Thông thường thì đối với những dữ liệu được nhập và xuất ra qua một hệ thống được phát triển đầy đủ, công việc tiền xử lý chỉ cần một vài bước cơ bản để đi đến kết quả. Tuy nhiên, trong trường hợp dữ liệu bạn nhận được là dữ liệu được nhập một cách thủ công, qua tay nhiều người nhập, thì đây thực sự sẽ là một vấn đề lớn. Tiền xử lý dữ liệu trong tình huống như vậy có thể chiếm từ 80\% đến 90\% thời gian công việc của bạn!  

## Tiền xử lý dữ liệu là gì?

Các vấn đề thường gặp phải khi làm việc với một dữ liệu thô thường xuất phát từ hai nguyên nhân:

- Thứ nhất là dữ liệu sai định dạng, nghĩa là trong cùng một cột dữ liệu có các biến kiểu khác nhau hoặc kiểu của biến không đúng như quy ước.

- Thứ hai là dữ liệu chứa giá trị không quan sát được hoặc chứa các giá trị ngoại lai. Các giá trị ngoại lai thường được gọi là các outliers.

Hãy quan sát một ví dụ như sau: bạn nhận được dữ liệu về 3 ứng cử viên từ bộ phận nhân sự và bạn muốn xem xét độ tuổi trung bình của những ứng cử viên và tỷ lệ Nam/Nữ trong danh sách ứng tuyển


<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-32)Dữ liệu thô từ nguồn bên ngoài</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Họ và tên </th>
   <th style="text-align:left;"> Ngày sinh </th>
   <th style="text-align:left;"> Giới tính </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Nguyễn Văn An </td>
   <td style="text-align:left;"> 01/02/98 </td>
   <td style="text-align:left;"> Nam </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Trần Văn Cường </td>
   <td style="text-align:left;"> 12/17/1999 </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lê Thị Loan </td>
   <td style="text-align:left;"> 1-1-1992 </td>
   <td style="text-align:left;"> NA </td>
  </tr>
</tbody>
</table>

Đây là một dữ liệu không thể sử dụng để phân tích bởi vì giá trị trong các cột ngày sinh là không đúng định dạng ngày tháng. Ngoài ra còn có các giá trị không quan sát được ở cột giới tính. Nếu sử dụng dữ liệu này để phân tích mà bỏ qua việc tiền xử lý dữ liệu thì kết quả sẽ sai lệch hoàn toàn so với bản chất của dữ liệu:

- Tính độ tuổi trung bình của các ứng cử viên là không thể thực hiện được với dữ liệu này bởi vì cột ngày sinh đang có dạng chuỗi ký tự và định dạng ngày tháng là không thống nhất.

- Nếu bỏ qua những giá trị không có quan sát, tỷ lệ giới tính Nam là 100\%. Liệu con số này có thực sự đúng ?

Tiền xử lý dữ liệu không chỉ bao gồm các công cụ kỹ thuật mà còn yêu cầu cả kiến thức phổ thông và kiến thức nghiệp vụ của người làm dữ liệu. Khi có vấn đề gây khó hiểu về dữ liệu nhận được, điều trước hết cần làm đó là liên hệ với người chủ dữ liệu để kiểm tra lại thông tin. Khi việc này là không thể thực hiện được, người xử lý dữ liệu sẽ phải đưa ra các phán đoán về dữ liệu đó dựa trên hiểu biết của mình.

Giả sử chúng ta không thể có thêm thông tin nào từ nơi cung cấp dữ liệu, chúng ta cần phải đưa ra phán đoán với dữ liệu kể trên. Trước hết, với cột ngày sinh của các nhân viên:

- Giá trị "01/02/98" có khả năng cao là ngày 01 tháng 02 năm 1998 do quy ước phổ biến ở Việt Nam là viết theo thứ tự ngày -> tháng -> năm. 

- Giá trị "12/17/1999" có khả năng cao là ngày 17 tháng 12 năm 1999. Khi gặp các trường hợp này nhiều khả năng người nhập dữ liệu sử dụng format ngày tháng của Microsoft Excel.

- Giá trị "1-1-1992" có khả năng cao là ngày 01 tháng 01 năm 1992.

Như vậy với mỗi giá trị trong cột ngày sinh, bạn đọc cần một phép biến đổi khác nhau

```r
DOB<-rep(as.Date("1900-01-01"),3)
DOB[1]<-as.Date("01/02/98", format = "%d/%m/%y")
DOB[2]<-as.Date("12/17/1999", format = "%m/%d/%Y")
DOB[3]<-as.Date("1-1-1992", format = "%d-%m-%Y")
```
Véc-tơ DOB được tính toán trong các câu lệnh ở trên chứa giá trị ngày sinh kiểu dạng ngày tháng đúng định dạng của các ứng cử viên và bạn đọc có thể sử dụng các hàm số có sẵn để tính tuổi của các ứng cử viên. 

Đối với cột giới tính của nhân viên:

- Giới tính của ứng cử viên Trần Văn Cường là không quan sát được tuy nhiên theo tên của ứng cử viên thì nhiều khả năng đây là Nam.

- Giới tính của ứng cử viên Lê Thị Loan là không quan sát được tuy nhiên theo tên của ứng cử viên thì nhiều khả năng đây là Nữ.

Sau những bước xử lý như trên, chúng ta đã có một dữ liệu được định dạng chính xác như ở dưới. Đây là một dữ liệu đã được làm sạch và sẵn sàng để trả lời cho các câu hỏi như độ tuổi trung bình hay tỷ lệ Nam/Nữ của các ứng cử viên.



<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-35)Dữ liệu sau tiền xử lý</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Họ và tên </th>
   <th style="text-align:left;"> Ngày sinh </th>
   <th style="text-align:left;"> Giới tính </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Nguyễn Văn An </td>
   <td style="text-align:left;"> 1998-02-01 </td>
   <td style="text-align:left;"> Nam </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Trần Văn Cường </td>
   <td style="text-align:left;"> 1999-12-17 </td>
   <td style="text-align:left;"> Nam </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lê Thị Loan </td>
   <td style="text-align:left;"> 1992-01-01 </td>
   <td style="text-align:left;"> Nữ </td>
  </tr>
</tbody>
</table>

Các bước ở trên mặc dù rất đơn giản nhưng lại là ví dụ điển hình của tiền xử lý dữ liệu. Dữ liệu bạn đọc nhận được sẽ ít khi được định dạng chuẩn và sẵn sàng để phân tích. Để xử lý những giá trị sai định dạng, và điền vào dữ liệu các giá trị không quan sát, loại bỏ các giá trị ngoại lai,..., người làm dữ liệu phải sử dụng kiến thức phổ thông và kiến thức nghiệp vụ để làm sạch và đưa ra những dự đoán tốt nhất có thể.

## Định dạng cột dữ liệu sử dụng thư viện $\textbf{readr}$

### Quy tắc định dạng tự động của $\textbf{readr}$
Mỗi thư viện có quy tắc khác nhau về định dạng kiểu dữ liệu của các biến khi đọc dữ liệu từ các nguồn khác nhau lên cửa sổ làm việc. Trong phần này, chúng ta sẽ tập trung vào thư viện $\textbf{readr}$ và các hàm đọc dữ liệu của thư viện này. Khi đọc một dữ liệu từ nguồn khác, các hàm đọc dữ liệu của thư viện $\textbf{readr}$ cố gắng dự đoán kiểu dữ liệu của từng biến bằng cách sử dụng 1000 hàng dữ đầu tiên dựa trên nguyên tắc chung như sau:
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbimport01)Nguyên tắc định tự động định dạng kiểu dữ liệu của readr</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Giá trị trong cột dữ liệu </th>
   <th style="text-align:left;"> $\textbf{readr}$ dự đoán </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Cột dữ liệu chỉ bao gồm TRUE, FALSE, True, False, true, false, F, T, t, f </td>
   <td style="text-align:left;"> Kiểu logic </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cột dữ liệu chỉ bao gồm số, số thập phân sử dụng dấu '.' , </td>
   <td style="text-align:left;"> Kiểu số </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chuỗi ký tự có kiểu yyyy-mm-dd hoặc yyyy/mm/dd </td>
   <td style="text-align:left;"> Kiểu ngày tháng </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Xuất hiện dưới định dạng khác </td>
   <td style="text-align:left;"> Kiểu chuỗi ký tự </td>
  </tr>
</tbody>
</table>

Lưu ý rằng các giá trị không quan sát được không ảnh hưởng đến việc $\textbf{readr}$ dự đoán kiểu dữ liệu của một cột, nghĩa là các hàm đọc dữ liệu sẽ bỏ qua các giá trị NA trong 1000 hàng đầu tiên.

Khi đọc dữ liệu kiểu số, sự khác nhau trong cách sử dụng dấu thập phân là `.` và `,` có thể làm cho giá trị của biến kiểu số thay đổi về bản chất. Chẳng hạn như nếu bạn đọc không sử dụng thêm tham số $\textbf{readr}$ luôn mặc định dấu thập phân là `.` khi bạn sử dụng hàm `read_csv()` và mặc định dấu thập phân là `,` khi bạn sử dụng `read_csv2()`. Hãy quan sát ví dụ dưới đây khi đọc dữ liệu bằng hàm `read_csv2()` với các giá trị kiểu số:

```r
file<-"C1;C2;C3;C4; C5
         1e-10;2.2;1.0;TRUE; 1.0.0.0
         Inf;3,2;1,000.0;1;10%" 
# Dữ liệu có 5 cột và 2 hàng
read_csv2(file)
```

```
## # A tibble: 2 × 5
##        C1    C2    C3 C4    C5     
##     <dbl> <dbl> <dbl> <chr> <chr>  
## 1   1e-10  22      10 TRUE  1.0.0.0
## 2 Inf       3.2     1 1     10%
```

Hàm `read_csv2()` là hàm dùng để đọc dữ liệu mà các cột được phân tách bằng dấu `;` và cho đầu ra là một tibble. Từ kết quả ở trên, có thể đưa ra nhận xét như sau:

- Cột thứ nhất (C1) có các số đặc biệt như `1e-10` hay `Inf` đều được hiểu là kiểu số như thông thường. 
- Cột thứ hai (C2) chứa các giá trị `2.2` và `3,2` khi được đọc bằng `read_csv2()` cho kết quả là véc-tơ kiểu số với hai phần tử là 22 và 3.2. Điều này có nghĩa là `read_csv2()` bỏ qua dấu `.` trong `2.2` và cho kết quả đầu ra là 22, trong khi giá trị `3,2` có dấu `,` được hiểu là số thập phân. 

- Tương tự, trong cột thứ ba (C3) giá trị `1.0` được hiểu là số 10, trong khi 1,000 được hiểu là số 1 vì `,` được hiểu là số thập phân. 

- Hàm `read_csv2()` không phân tích được kiểu dữ liệu trong cột thứ tư (C4) và cột thứ năm (C5) nên kiểu dữ liệu của hai cột này trong kết quả là kiểu chuỗi ký tự.

Chúng ta tiếp tục xem xét quy tắc tự động định dạng véc-tơ kiểu logic thông qua ví dụ dưới đây:

```r
file<-"C1,C2,C3,C4,C5,C6
        TRUE,t,True,false,F,true
        F,F,FALSE,T,f,True"
read_csv(file)
```

```
## # A tibble: 2 × 6
##   C1    C2    C3    C4    C5    C6   
##   <lgl> <lgl> <lgl> <lgl> <lgl> <lgl>
## 1 TRUE  TRUE  TRUE  FALSE FALSE TRUE 
## 2 FALSE FALSE FALSE TRUE  FALSE TRUE
```
Hàm `read_csv()` được sử dụng để đọc dữ liệu từ nguồn ngoài có các cột ngăn cách nhau bằng dấu `,`. Có thể thấy rằng các giá trị tương ứng với biến logic được liệt kê trong Bảng \@ref(tab:tbimport01) đều được hàm `read_csv()` hiểu đúng. 

Chúng ta chuyển sang kiểu biến tiếp theo là kiểu ngày tháng. Như trình bày trong Bảng \@ref(tab:tbimport01), $\textbf{readr}$ chỉ có thể tự động định dạng đúng véc-tơ kiểu thời gian nếu giá trị từ nguồn bên ngoài vào được viết theo định dạng "yyyy-mm-dd" hoặc "yyyy/mm/dd":

```r
file<-"C1,C2,C3,C4,C5
        2020/01/12,2020-01-12,2020/01/12,2020/1/1,2020|1|1
        2021-12-31,2021/12/31,2021/31/12,2021-12-31,2021-12-31"
read_csv(file)
```

```
## # A tibble: 2 × 5
##   C1         C2         C3         C4         C5        
##   <date>     <date>     <date>     <chr>      <chr>     
## 1 2020-01-12 2020-01-12 2020-01-12 2020/1/1   2020|1|1  
## 2 2021-12-31 2021-12-31 NA         2021-12-31 2021-12-31
```
Từ kết quả của hàm `read_csv()` có thể thấy cách thư viện $\textbf{readr}$ tự động định dạng dữ liệu kiểu ngày tháng như sau:

- Giá trị trong cột được viết theo một trong hai kiểu định dạng là "yyyy-mm-dd" hoặc "yyyy/mm/dd" đều được hiểu là kiểu ngày tháng. Cột thứ nhất (C1) và cột thứ hai (C2) được định nghĩa đúng kiểu ngày tháng trong đầu ra. 

- Cột thứ ba (C3) mặc dù giá trị hàng thứ hai bị viết ngược ngày - tháng nhưng $\textbf{readr}$ vẫn ghi nhận cột này là kiểu ngày tháng. 

- Côt thứ tư (C4) và cột thứ năm (C5) không được hiểu là kiểu ngày tháng do dữ liệu không được viết theo một trong hai định dạng trong Bảng \@ref(tab:tbimport01)

Để tìm hiểu chi tiết hơn cách thư viện $\textbf{readr}$ tự động định dạng kiểu giá trị của dữ liệu đọc từ nguồn bên ngoài, bạn đọc tham khảo hướng dẫn của hàm `guess_parse()`. Đây là hàm mặc định dùng để dự đoán kiểu giá trị của các biến.

Khi thư viện $\textbf{readr}$ không thể phân tích được định dạng của các biến, kiểu biến mặc định sẽ là kiểu chuỗi ký tự. Trong các phần tiếp theo, chúng ta sẽ thảo luận về các hàm được sử dụng để chuyển đổi véc-tơ kiểu chuỗi ký tự sang kiểu dữ liệu đúng của véc-tơ đó.

### Định dạng véc-tơ bằng các hàm `parse_*()`
Với các cột dữ liệu mà không thể xác định được kiểu biến, thư viện $\textbf{readr}$ sẽ lưu dưới dạng véc-tơ kiểu chuỗi ký tự. Để làm việc được trên dữ liệu, bạn đọc cần định dạng lại các cột cho đúng với mong muốn. Các hàm `parse_*()` trong thư viện $\textbf{readr}$ hỗ trợ bạn đọc thực hiện yêu cầu này. Nhóm hàm `parse_*()` có đầu vào là một véc-tơ kiểu chuỗi ký tự và đầu ra sẽ là kiểu dữ liệu mà bạn đọc mong muốn. Đối với mỗi kiểu dữ liệu, bao gồm dữ liệu kiểu số, kiểu logic, kiểu thời gian, và kiểu chuỗi ký tự, hàm `parse_*()` tương ứng sẽ có các tham số phù hợp.

#### Định dạng véc-tơ kiểu logic
Định dạng lại một véc-tơ kiểu chuỗi ký tự thành kiểu logic là đơn giản nhất bởi các giá trị có thể nhận của biến logic chỉ bao gồm TRUE hoặc FALSE. Hàm số sử dụng trong trường hợp này là `parse_logical()`. Bạn đọc hãy quan sát ví dụ sau:

```r
x<-c("TRUE","True","1","0","2",".","@",
     "FALSE","false","f","F","T","t","true","false")
parse_logical(x, na = c(".", "@"))
```

```
##  [1]  TRUE  TRUE  TRUE FALSE    NA    NA    NA FALSE FALSE FALSE FALSE  TRUE
## [13]  TRUE  TRUE FALSE
## attr(,"problems")
## # A tibble: 1 × 4
##     row   col expected           actual
##   <int> <int> <chr>              <chr> 
## 1     5    NA 1/0/T/F/TRUE/FALSE 2
```

Bạn đọc có thể thấy rằng tất cả các giá trị nằm trong véc-tơ $\textbf{x}$, ngoại trừ hai ký tự đặc biệt đã được khai báo trong hàm `parse_logical()` là `"."` và `"@"`, thì còn có giá trị `"2"` là không thể đổi sang biến kiểu logic. Có thể thấy rằng `parse_logical()` tự động đổi giá trị `"1"` thành TRUE và giá trị `"0"` thành FALSE. Trong trường hợp véc-tơ $\textbf{x}$ có kích thước lớn, các phần tử không thể đổi sang kiểu logic sẽ được lưu vào một tibble. Bạn đọc sử dụng hàm `problems()` để xem danh sách các các giá trị này:

```r
x1<-sample(x, 10^4, replace = TRUE)
y<-parse_logical(x1)
problems(y)
```

```
## # A tibble: 1,996 × 4
##      row   col expected           actual
##    <int> <int> <chr>              <chr> 
##  1    11    NA 1/0/T/F/TRUE/FALSE .     
##  2    16    NA 1/0/T/F/TRUE/FALSE .     
##  3    22    NA 1/0/T/F/TRUE/FALSE @     
##  4    27    NA 1/0/T/F/TRUE/FALSE @     
##  5    36    NA 1/0/T/F/TRUE/FALSE .     
##  6    45    NA 1/0/T/F/TRUE/FALSE .     
##  7    49    NA 1/0/T/F/TRUE/FALSE .     
##  8    50    NA 1/0/T/F/TRUE/FALSE @     
##  9    53    NA 1/0/T/F/TRUE/FALSE .     
## 10    56    NA 1/0/T/F/TRUE/FALSE @     
## # ℹ 1,986 more rows
```

Trong kết quả của hàm `problem()`, cột row cho biết vị trí của các phần tử trong véc-tơ `x1` không thể đổi sang biến kiểu logic. Giá trị thực của các phần tử này nằm trong cột actual. Bạn đọc có thể quan sát các giá trị trong cột actual để tìm hiểu nguyên nhân tại sao `parse_logical()` không thể hoạt động trên các giá trị này.

#### Định dạng véc-tơ kiểu số
Các nguyên nhân dẫn đến việc các hàm đọc dữ liệu trong thư viện $\textbf{readr}$ không thể tự động định dạng một véc-tơ có kiểu số là: 

- Cách đánh số thập phân của các số trong véc-tơ. Chẳng hạn như tại Việt Nam số thập phân được sử dụng là dấu phẩy (,) trong khi R hiểu số thập phân là dấu chấm (.). Một số quốc gia khác trên thế giới như Pháp cũng sử dụng dấu thập phân là dấu phẩy.

- Cách viết các số sử dụng cùng với các ký tự chấm hoặc phẩy để người đọc dễ dàng đọc số đó. Chẳng hạn như tại Việt Nam, chúng ta viết số 1 tỷ với dấu chấm phân tách các số không như sau: 1.000.000.000. Tại Thụy Sỹ cách phân tách số lại được viết theo cách khác; số 1 tỷ được viết thành 1'000'000'000. Khi gặp các trường hợp này, chúng ta cần cung cấp cho R định dạng đúng của các số đó.

- Khi các con số đi kèm theo đơn vị, chẳng hạn như đi kèm với ký hiệu tiền tệ: "100.000 đồng", "100.000 vnd", hoặc đi kèm với ký hiệu % như 50\%, các hàm đọc dữ liệu của thư viện $\textbf{readr}$ cũng sẽ không thể tự động chuyển đổi các giá trị này sang kiểu số nếu không có gợi ý thích hợp.

Bạn đọc có thể sử dụng `parse_double()` hoặc `parse_number()` khi gặp phải các vấn đề ở trên. Chẳng hạn như khi gặp vấn đề về dấu phẩy đối với dấu thập phân, nghĩa là dữ liệu từ nguồn bên ngoài viết số thập phân sử dụng dấu phẩy, bạn đọc sử dụng `parse_number()` với tham số `locale = locale(decimal_mark = ",")` để đổi định dạng véc-tơ kiểu chuỗi ký tự sang véc-tơ kiểu số:

```r
x<-c("0,5","1,5") # Dấu thập phân là dấu phẩy
parse_number(x, locale = locale(decimal_mark = ","))
```

```
## [1] 0.5 1.5
```

Khi gặp phải vấn đề về việc sử dụng các ký tự không đúng định dạng để phân tách các giá trị đơn vị hàng nghìn, hàng triệu,..., chúng ta sử tham số `grouping_mark` trong hàm `locate()`. Ví dụ dưới đây sử dụng đồng thời hai tham số `decimal_mark` và `grouping_mark` của hàm `locate()` để biến đổi cách viết số thập phân theo kiểu viết của Việt Nam sang kiểu số thông thường:

```r
x<-c("1.000,5","1.000.000,5") 
# véc-tơ chứa các số 1000,5 và 1000000,5; 
# dấu thập phân là dấu ","
# phân tách hàng nghìn, triệu là dấu .
parse_number(x, locale = locale(decimal_mark = ",",
                                grouping_mark = "."))
```

```
## [1]    1000.5 1000000.5
```

Khi gặp phải chuỗi ký tự chứa biến kiểu số đi kèm với đơn vị tiền tệ, hoặc đơn vị \%, hàm `parse_number()` vẫn cho phép chuyển đổi chuỗi ký tự sang kiểu số mà không cần sử dụng thêm tham số nào cả. Bạn đọc hãy quan sát ví dụ dưới đây:

```r
x<-c("1.000,5 đồng","1.000.000,5 vnd", "2.000,5%")
# số kiểu Việt Nam
# có đơn vị tiền phía sau
# có ký hiệu % phía sau
parse_number(x, locale = locale(decimal_mark = ",",
                                grouping_mark = "."))
```

```
## [1]    1000.5 1000000.5    2000.5
```
Bạn đọc cần thận trọng khi véc-tơ kiểu số có \% ở phía sau. Hàm `parse_number()` loại bỏ ký tự \% theo sau và giữa nguyên giá trị số đó. Áp dụng `parse_number()` trên giá trị 2000.5\% cho kết quả là 2000.5 chứ không phải là 20.005. Để có giá trị đúng kiểu số, chúng ta cần chia kết quả cho 100.

#### Định dạng véc-tơ kiểu thời gian
Hàm số `parse_datetime()` có thể sử dụng để chuyển đổi các véc-tơ kiểu chuỗi ký tự sang véc-tơ kiểu thời gian và véc-tơ kiểu ngày tháng. 

```r
x<-c("1/2/2023", "23/10/2023 ", "01/01/1900")
parse_datetime(x, format = "%d/%m/%Y",
               na = c("01/01/1900"))
```

```
## [1] "2023-02-01 UTC" "2023-10-23 UTC" NA
```

Hai tham số của hàm `parse_datetime()` mà bạn đọc cần lưu ý là `na` và `format`. Tham số `na` là một véc-tơ chứa các giá trị mà bạn đọc cho rằng đây là các giá trị không quan sát được. Trong véc-tơ `x` ở trên, giá trị `"01/01/1990"` được gán cho tham số `na` mặc dù giá trị này là ngày tháng có ý nghĩa. Điều này khiến cho giá trị thứ ba trong véc-tơ kết quả có giá trị là NA. Nếu không sử dụng tham số `na`, giá trị thứ ba của véc-tơ kết quả sẽ là ngày 01 tháng 01 năm 1990. Đối với một vài hệ thống lưu dữ liệu, có thể xảy ra trường hợp các giá trị không được ghi nhận nhưng vẫn được gán một giá trị mặc định nào đó. Các giá trị mặc định này nếu giữ nguyên giá trị sẽ làm sai lệch phân tích. Giả sử với véc-tơ ở trên, nếu chúng ta biết giá trị mặc định gán cho các giá trị không quan sát được của hệ thống là "01/01/1990", việc gán giá trị này cho tham số `na` là cần thiết.

Tham số `format` sử dụng trong hàm `parse_datetime()` là gợi ý cho R về định dạng của biến kiểu ngày tháng. Khi gán giá trị cho tham số `format`, bạn đọc cần lưu ý:

- Mỗi thành phần của biến thời gian (ngày, tháng, năm, giờ, phút, giây,...) được định nghĩa bắt đầu bằng `%` và theo sau 1 chữ cái, chẳng hạn như bạn đọc sử dụng `%Y` khi muốn gợi ý rằng biến kiểu thời gian nằm trong chuỗi ký tự được sử dụng 4 chữ số để chỉ định giá trị năm.

- Các ký tự không liên quan đến các thành phần của thời gian, ngoại trừ các khoảng trắng phía trước và sau biến thời gian, cần phải được khai báo chính xác. Hãy quan sát ví dụ dưới đây


```r
x<-c(" 1@2@2023-23#25#01  ", "  23@10@2023-01#06#59 ", "01@01@2023-00:00:00")
parse_datetime(x, format = "%d@%m@%Y-%H#%M#%S")
```

```
## [1] "2023-02-01 23:25:01 UTC" "2023-10-23 01:06:59 UTC"
## [3] NA
```

```r
# Gợi ý cho R là ngày, tháng, năm cách nhau bởi @
# và giờ phút, giây cách nhau bởi #
```

Từ ví dụ trên bạn đọc có thể thấy rằng 

- Cần khai báo chính xác các ký tự nằm giữa các biến thời gian. Ký tự `"@"` nằm giữa các giá trị ngày, tháng, năm; phân tách giữa ngày tháng với thời gian trong ngày là ký tự `"-"`; phân tách giữa các thành phần của thời gian trong ngày là ký tự `"#"`. Tất cả đều cần phải được khai báo chính xác trong tham số `format`. Điều này giải thích tại sao hai giá trị đầu được chuyển đổi sang dạng biến thời gian. Giá trị thứ ba trong véc-tơ `x` gặp vấn đề vì phân tách giữa các thành phần của thời gian trong ngày sử dụng dấu `":"`.

- Các khoảng trắng nằm trước và sau các chuỗi ký tự được bỏ qua và không ảnh hưởng đến kết quả. Các giá trị thứ nhất và thứ hai trong véc-tơ `x` có khoảng trắng phía trước và phía sau nhưng hàm `parse_datetime()` bỏ qua các khoảng trắng đo khi chuyển đổi ký tự sang ngày tháng.

Để biết một cách chính xác cách gán giá trị cho tham số `format`, bạn đọc nên tham khảo hướng dẫn sử dụng hàm `parse_datetime()`. Chúng tôi tóm tắt cách định dạng các thành phần của một biến thời gian trong bảng \@ref(tab:tbimport02)

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbimport02)Định nghĩa các thành phần của biến thời gian của $\textbf{readr}$</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Thành phần </th>
   <th style="text-align:left;"> Định dạng chi tiết </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Năm </td>
   <td style="text-align:left;"> %Y (4 chữ số) và %y (1 đến 2 chữ số) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tháng </td>
   <td style="text-align:left;"> %m (1-2 chữ số), %b (tên tháng viết tắt), %B (tên tháng đầy đủ) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ngày </td>
   <td style="text-align:left;"> %d (1-2 chữ số) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Giờ </td>
   <td style="text-align:left;"> %H (1-2 chữ số) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phút </td>
   <td style="text-align:left;"> %M (1-2 chữ số) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Giây </td>
   <td style="text-align:left;"> %S (1-2 chữ số) </td>
  </tr>
</tbody>
</table>

Lưu ý rằng khi bạn đọc sử dụng `%y` để định nghĩa cho giá trị năm, các ký tự từ "00" đến "69" sẽ được chuyển thành năm 2000 đến năm 2069. Trong khi đó, các ký tự từ "70" đến "99" sẽ được chuyển thành năm 1970 đến 1999. Ngoài ra, thành phần tháng của biến thời gian trong nhiều dữ liệu thường được viết dưới dạng chuỗi ký tự thay vì sử dụng số. Do đó bạn đọc cần các gợi ý `%b` hoặc `%B` để gợi ý cho R. Hãy quan sát ví dụ sau:


```r
x<-c("sep 21, 23 ", "  JAN 1, 69 ", "Dec 25, 70", "april 3, 99")
parse_datetime(x, format = "%b %d, %y")
```

```
## [1] "2023-09-21 UTC" "1969-01-01 UTC" "1970-12-25 UTC" NA
```

```r
parse_datetime(x, format = "%B %d, %y")
```

```
## [1] NA               NA               NA               "1999-04-03 UTC"
```

Khi ngày tháng được viết bằng chuỗi ký tự viết tắt, bằng chữ in hoa hoặc chữ thường, như `"sep"` hay `"JAN"`, gợi ý cần sử dụng là `%b`. Điều này giải thích tại sao kết quả của hàm `parse_datetime()` thứ nhất cho kết quả đúng định dạng ngày tháng đối với ba giá trị đầu của véc-tơ, và cho kết quả là NA với phân tử thứ tư khi tháng được viết đầy đủ là `"april"`. Ngược lại, hàm `parse_datetime()` thứ hai cho kết quả ba giá trị đầu của véc-tơ là NA và phần tử thứ tư là giá trị ngày tháng được định dạng đúng là do chúng ta sử dụng tham số `format` với gợi ý cho cách viết tháng là `%B`.

### Định dạng cột kiểu chuỗi ký tự
Khi bạn đọc dùng thư viện $\textbf{readr}$ để đọc dữ liệu từ nguồn bên ngoài, cột dữ liệu không rõ định dạng sẽ được lưu dưới dạng véc-tơ chuỗi ký tự. Vậy tại sao cần định dạng lại thành véc-tơ kiểu chuỗi ký tự ? Nghe có vẻ vô lý nhưng đây lại là vấn đề phức tạp nhất trong định dạng lại cột dữ liệu. Để hiểu vấn đề này bạn đọc cần tìm hiểu một chút về cách máy tính điện tử lưu và mở một chuỗi ký tự. Giả sử bạn đọc muốn gửi một dữ liệu chứa ký tự "a" đến một máy tính khác. Sau khi viết ký tự "a" lên một phần mềm soạn thảo văn bản nào, bạn đọc sẽ cần lưu ký tự "a" lên máy tính của bạn. Tất nhiên máy tính của bạn sẽ không thể ghi nhớ chữ "a" một cách tượng hình mà sẽ mã hóa (hay thuật ngữ chuyên ngành gọi là $encode$) chữ "a" thành một đoạn mã nhị phân bao gồm 0 và 1 mà máy tính có thể lưu được. Khi bạn gửi dữ liệu sang một máy tính khác, đoạn mã bao gồm 0 và 1 đó sẽ được gửi đi. Khi máy tính điện tử khác mở dữ liệu, đoạn mã nhị phân sẽ được giải mã (thuật ngữ chuyên ngành gọi là $decode$) để hiển thị. Sẽ không có vấn đề gì xảy ra nếu quy tắc mã hóa và giải mã được thống nhất và chữ "a" sẽ được hiển thị chính xác trên máy tính thứ hai.

Thực tế là trước khi có bộ mã hóa và quy tắc mã hóa chung được công nhận rộng rãi như Unicode và UTF-8, rất khó để có sự thống nhất quy tắc mã hóa ký tự. May mắn là đến thời điểm chúng tôi viết cuốn sách này đa số các hệ điều hành, hệ soạn thảo văn bản,... đều sử dụng bảng mã Unicode và bộ mã hóa UTF-8. Giải thích chi tiết về bộ mã hóa hay quy tắc mã hóa là rất phức tạp và vượt quá nội dung của cuốn sách này. Chúng tôi chỉ cần bạn đọc hiểu về Unicode và UTF-8 như sau:

- Unicode là một bảng mã chuẩn được công nhận rộng rãi cho biết quy tắc cho tương ứng hầu hết các ký tự từ đơn giản đến phức tạp, kể cả các ngôn ngữ sử dụng ký tự tượng hình phức tạp như chữ Hán của tiếng Trung Quốc, tiếng Nhật, chữ Nôm của tiếng Việt, với một số nằm giữa số 0 đến số $10FFFF$ khi viết theo hệ 16. Một số khi viết trong hệ 16 có thể sử dụng (0, 1, ..., 9, A, B, C, D, E, F) để biểu diễn, do đó số các ký tự mà bảng mã Unicode có thể đưa vào là $16^4 + 16^5 = 1.114.112$ ký tự, bao gồm $16^5$ số từ 0 đến FFFFF và $16^4$ số từ 100000 đến 10FFFF. Ví dụ, bạn đọc có thể dễ dàng tìm thấy được qua các công cụ tìm kiếm rằng ký tự "A" có mã Unicode là "0041" và "a" có mã Unicode là "0061". 

- UTF-8 là quy tắc lưu các số viết trong hệ 16 của bảng mã Unicode thành các chuỗi nhị phân 0 và 1 mà máy tính có thể phân biệt được. Số 8 ở đây có nghĩa là 8 bit hay một byte là 8 giá trị 0 và 1 đứng liền nhau. Một ký tự bất kỳ trong bảng mã Unicode đều có thể được mã hóa thành 1, 2, 3 hoặc nhiều byte theo quy tắc mã hóa UTF-8. Chữ "A" với mã Unicode "0041" sẽ được lưu trong máy tính điện tử dưới dạng một byte là "01000001", hay "a" có mã Unicode "0061" được máy tính điện tử lưu bằng 1 byte có giá trị "01100001".

Quay trở lại vấn đề định dạng lại dữ liệu kiểu chuỗi ký tự, sẽ không có vấn đề xảy ra nếu người nhập liệu sử dụng bộ mã hóa UTF-8 bởi $\textbf{readr}$ luôn sử dụng UTF-8 để giải mã. Trong thực tế thì vẫn còn một số hệ thống, hoặc hệ soạn thảo văn bản sử dụng cách mã hóa khác với UTF-8. Điều này làm cho dữ liệu khi được nhập vào R sẽ hiển thị không đúng như mong muốn. Ví dụ, khi đọc một dữ liệu từ nguồn ngoài vào bằng `read_csv()` và cho kết quả như sau

```r
x<-read_csv("../KHDL_KTKD Final/Dataset/Book1.csv")
x
```

```
## # A tibble: 5 × 2
##   A              B         
##   <chr>          <chr>     
## 1 "l\xea"        20.000 vnd
## 2 "t\xe1o"       35.000 vnd
## 3 "qu\xfdt"      30.000 vnd
## 4 "c\xe0 t\xedm" 5.500 vnd 
## 5 "m\xedt"       10.000 vnd
```

Cột $A$ của dữ liệu đã không được lưu bằng bộ mã hóa UTF-8 nên thư viện $\textbf{readr}$ không hiển thị được các chuỗi ký tự có ý nghĩa. Để định dạng lại cột dữ liệu, bạn đọc sử dụng hàm `parse_character()` với tham số `encoding`. Không dễ để biết được dữ liệu đã được mã hóa bằng bộ mã hóa nào. Thư viện $\textbf{readr}$ cung cấp hàm `guess_encoding()` hỗ trợ bạn đọc dự đoán một biến kiểu chuỗi ký tự đã được mã hóa bẳng bộ mã hóa nào. Tuy nhiên trải nghiệm của chúng tôi với hàm số này là không tốt! Lời khuyên của chúng tôi là bạn đọc khi có thể hãy tìm hiểu nguồn gốc của dữ liệu: dữ liệu được sinh ra từ đâu, hoặc từ hệ thống nào,..., để đưa ra phán đoán. Nếu không thể tìm kiếm nguồn gốc của dữ liệu, giải pháp duy nhất là thử giải mã đoạn văn bản bằng một số bộ mã hóa thường gặp cho đến khi gặp được kết quả mong muốn! Trong trường hợp dữ liệu ở trên do nguồn là tiếng Việt nên chúng ta có thể thử các bộ mã hóa như "Latin1" hay "Latin2". Cách sử dụng hàm  `parse_character()` như sau:


```r
parse_character(x$A, locale = locale(encoding = "Latin2"))
```

```
## [1] "lę"     "táo"    "quýt"   "cŕ tím" "mít"
```

Kết quả khi sử dụng bộ mã $Latin2$ đã cho một vài giá trị có ý nghĩa, chúng ta tiếp tục thử với $Latin1$:

```r
parse_character(x$A, locale = locale(encoding = "Latin1"))
```

```
## [1] "lê"     "táo"    "quýt"   "cà tím" "mít"
```

May mắn là cột dữ liệu đều đã có thể đọc được với người Việt Nam. Chúng ta có thể suy đoán đây là một dữ liệu về giá của các loại quả, do đó cột $B$ của dữ liệu cần được định dạng lại kiểu số. Bạn đọc có thể sử dụng `parse_numbder()` như đã trình bày ở trên. Dữ liệu sau khi được định dạng lại các cột đã dễ hiểu hơn rất nhiều:


```r
tibble(Name = parse_character(x$A, locale = locale(encoding = "Latin1")), 
      Price = parse_number(x$B, locale = locale(grouping_mark = ".")))
```

```
## # A tibble: 5 × 2
##   Name   Price
##   <chr>  <dbl>
## 1 lê     20000
## 2 táo    35000
## 3 quýt   30000
## 4 cà tím  5500
## 5 mít    10000
```

## Xử lý giá trị không quan sát được

Giá trị không quan sát được là các giá trị NA xuất hiện trong dữ liệu khi nhập vào R. Có nhiều lý do khác nhau dẫn đến việc dữ liệu không quan sát được. Chẳng hạn như thông tin do người làm dữ liệu cung cấp không đầy đủ, hoặc do người cung cấp dữ liệu từ chối chia sẻ thông tin, hoặc hệ thống quản lý dữ liệu bị lỗi, hoặc cũng có thể do người quản lý dữ liệu chủ động xóa dữ liệu vì lý do bảo mật. Giá trị không quan sát được ngoài các giá trị NA xuất hiện trong dữ liệu còn có thể là các giá trị không phù hợp với kiểu dữ liệu hoặc miền giá trị của cột dữ liệu. Đối với một vài hệ thống, khi dữ liệu được xuất ra giá trị không quan sát được vẫn được ghi nhận bằng một giá trị nào đó. Bạn đọc cần cẩn trọng khi làm việc với những dữ liệu như vậy.

### Xác định giá trị không quan sát được

Khi không được xử lý thích hợp, giá trị không quan sát được sẽ làm sai lệch kết quả của các phân tích về dữ liệu, có thể khiến người ra quyết định dựa trên dữ liệu mắc phải sai lầm. Ví dụ, một yêu cầu về phân tích độ tuổi và giới tính của sinh viên được gửi kèm với dữ liệu như sau:

```
## # A tibble: 4 × 6
##   MSV      Name            Age                Gender `Height (cm)` `Weight (kg)`
##   <chr>    <chr>           <chr>              <chr>          <dbl>         <dbl>
## 1 MSV00001 12345           30                 Nam             1.76            68
## 2 MSV43241 Nguyễn Văn An   Nhập sai ngày sinh N             169               72
## 3 MSV65432 Lê Thị Loan     -1                 Nữ            155               48
## 4 MSV34    Trần Mạnh Cường 15                 <NA>          175              150
```

Trong dữ liệu ở trên, mặc dù chỉ có 1 giá trị đang là NA ở cột giới tính, nhưng nếu quan sát kỹ bạn đọc sẽ nhận ra rằng:

- Trong cột Name: giá trị `"12345"` không thể là tên của một sinh viên, do đó đây cũng là một giá trị không quan sát được.

- Trong cột Age: thứ nhất, giá trị ở hàng thứ hai là kiểu chuỗi ký tự `Nhập sai ngày sinh`. Thứ hai, tuổi của một sinh viên không thể là số âm, nên giá trị `-1` ở hàng thứ ba không phù hợp với miền giá trị của cột này. Như vậy, cột Age có hai giá trị không quan sát được.

- Cột Gender: có giá trị là ký tự `N` không rõ là thể hiện cho giới tính Nam hay Nữ, giá trị này cũng là không quan sát được.

- Cột MSV: Giả sử bằng một cách nào đó, bạn đọc biết rằng mã sinh viên phải là một đoạn ký tự có độ dài là 8, bao gồm đoạn ký tự "MSV" và theo sau là 5 chữ số, thì giá trị `"MS34"` ở hàng thứ tư cũng là một giá trị không quan sát được ở cột mã sinh viên.

Để xác định dữ liệu có giá trị ngoại lai hay không cần sử dụng các kiến thức chuyên môn về dữ liệu và các kiến thức về xác suất - thống kê toán:

- Cột Height có giá trị chiều cao ở hàng thứ nhất là 1.76 cm. Giá trị này quá nhỏ để làm chiều cao của một người bình thường. Nhiều khả năng khi đo chiều cao của sinh viên, người nhập dữ liệu đã ghi lại theo đơn vị mét.

- Cột Weight có giá trị cân nặng của hàng thứ tư là 150 kg. Mặc dù dữ liệu có rất ít quan sát để đưa ra kết luận phân phối xác suất của cân nặng của sinh viên là gì, tuy nhiên với kiến thức thực tế chúng ta có thể kết luận rằng 150 kg là một cân nặng lớn bất thường với các giá trị cân nặng còn lại. Đây nhiều khả năng là một giá trị ngoại lai.

Để xác định các giá trị không quan sát được và giá trị ngoại lai tùy thuộc vào từng dữ liệu cụ thể và kiến thức tổng hợp và kiến thức chuyên môn của người xử lý dữ liệu và nằm ngoài phạm vi thảo luận của cuốn sách này. Dữ liệu ở trên chỉ là một dữ liệu nhỏ và đơn giản nên việc xác định các giá trị không quan sát được và giá trị ngoại lai là đơn giản.

Khi dữ liệu có giá trị NA, người phân tích dữ liệu luôn luôn là tìm cách dự đoán giá trị thay vì xóa đi quan sát có chứa NA. Trước hết, chúng ta biến đổi các giá trị không quan sát được thành giá trị NA:

```r
df$MSV[(nchar(df$MSV)!=8)]<-NA # mã sinh viên không có 8 ký tự là không quan sát được
df$Name[df$Name=="12345"]<-NA
df$Age<-parse_number(df$Age, na = c("-1")) # tuổi có giá trị (-1) là không quan sát được
df$Gender[df$Gender == "N"]<-NA
df$Gender<-as.factor(df$Gender)
```

Đối với các giá trị ngoại lai, chúng ta sẽ đổi giá trị bị ghi nhận sai đơn vị về đúng đơn vị. Với giá trị cân nặng 150 kg, do dữ liệu nhỏ, bạn đọc có thể giữ nguyên giá trị này hoặc thay thế giá trị này bằng giá trị lớn nhất của những người có cân nặng thông thường.


```r
df$`Height (cm)`[1]<-df$`Height (cm)`[1] * 100 # đổi đơn vị đo từ mét sang cm
```

Dữ liệu sau khi xử lý giá trị ngoại lai và định nghĩa lại các giá trị không quan sát được như sau:

```r
df
```

```
## # A tibble: 4 × 6
##   MSV      Name              Age Gender `Height (cm)` `Weight (kg)`
##   <chr>    <chr>           <dbl> <fct>          <dbl>         <dbl>
## 1 MSV00001 <NA>               30 Nam              176            68
## 2 MSV43241 Nguyễn Văn An      NA <NA>             169            72
## 3 MSV65432 Lê Thị Loan        NA Nữ               155            48
## 4 <NA>     Trần Mạnh Cường    15 <NA>             175           150
```

Với những dữ liệu nhỏ như trên thì hiển thị trực tiếp dữ liệu cũng cho phép người phân tích xác định vị trí của giá trị không quan sát được trong mỗi cột. Với dữ liệu lớn thì hiển thị dữ liệu không phải là cách xác định NA hiệu quả. Các hàm số cho phép bạn đọc hình dung tốt về giá trị không quan sát được trong dữ liệu bao gồm có `summary()`, `is.na()`.

- Hàm `summary()` sử dụng trên dữ liệu cho kết quả là các giá trị thống kê mô tả của các biến trong dữ liệu, bao gồm cả số lượng giá trị không quan sát được của các biến dạng số và dạng factor. Cách sử dụng hàm `summary()` như sau

```r
summary(df)
```

```
##      MSV                Name                Age         Gender   Height (cm)   
##  Length:4           Length:4           Min.   :15.00   Nam :1   Min.   :155.0  
##  Class :character   Class :character   1st Qu.:18.75   Nữ  :1   1st Qu.:165.5  
##  Mode  :character   Mode  :character   Median :22.50   NA's:2   Median :172.0  
##                                        Mean   :22.50            Mean   :168.8  
##                                        3rd Qu.:26.25            3rd Qu.:175.2  
##                                        Max.   :30.00            Max.   :176.0  
##                                        NA's   :2                               
##   Weight (kg)   
##  Min.   : 48.0  
##  1st Qu.: 63.0  
##  Median : 70.0  
##  Mean   : 84.5  
##  3rd Qu.: 91.5  
##  Max.   :150.0  
## 
```
Bạn đọc có thể thấy rằng hàm `summary()` cho chúng ta biết trong mỗi cột Age và Gender có hai giá trị không quan sát được, trong khi trong các cột Height và Weight không có giá trị không quan sát được. Hạn chế của hàm `summary()` là không cho chúng ta biết số lượng giá trị không quan sát được trong các biến kiểu chuỗi ký tự. 

- Hàm số thường được sử dụng để xác định vị trí của giá trị không quan sát được là hàm `is.na()`. Hàm `is.na()` áp dụng trên một véc-tơ, một ma trận, một dữ liệu, hay một mảng nhiều chiều sẽ trả lại kết quả tương ứng là một véc-tơ, một ma trận, hay một mảng nhiều chiều kiểu logic có kích thước bằng với kích thước của đầu vào, đồng thời tại vị trí tương ứng của giá trị không quan sát được sẽ có giá trị là TRUE, và giá trị FALSE tại các vị trí còn lại. Ví dụ, chúng ta áp dụng hàm `is.na()` trên dữ liệu `df` sẽ cho kết quả là một ma trận kiểu logic kích thước $4 \times 6$ tương ứng với 4 hàng và 6 cột của dữ liệu:

```r
is.na(df)
```

```
##        MSV  Name   Age Gender Height (cm) Weight (kg)
## [1,] FALSE  TRUE FALSE  FALSE       FALSE       FALSE
## [2,] FALSE FALSE  TRUE   TRUE       FALSE       FALSE
## [3,] FALSE FALSE  TRUE  FALSE       FALSE       FALSE
## [4,]  TRUE FALSE FALSE   TRUE       FALSE       FALSE
```
Bạn đọc có thể nhận thấy các vị trí nhận giá trị TRUE trong ma trận kết quả tương ứng với giá trị không quan sát được trong các cột MSV, Name, Age, và Gender của dữ liệu `df`.

Khi dữ liệu lớn thì việc hiển thị trực tiếp kết quả của hàm `is.na()` là không hiệu quả. Chúng ta cần kết hợp `is.na()` với các hàm số khác và các kỹ thuật trực quan hóa để đánh giá được tỷ lệ không quan sát được của các biến trong dữ liệu. Ví dụ, khi thực hiện phân tích trên dữ liệu có tên $\textbf{gapminder}$ có kích thước $10545 \text{ dòng } \times 9 \text{ cột }$ của thư viện $\textbf{dslabs}$, chúng ta có thể kết hợp `is.na()` với đồ thị dạng cột để mô tả tỷ lệ số giá trị không quan sát được trong mỗi cột như sau:

```r
# Tính tỷ lệ giá trị NA trong mỗi cột
y<-sapply(gapminder,
          function(x) sum(is.na(x))/length(x)) 

# Dùng đồ thị dạng cột để mô tả tỷ lệ NA
df<-data.frame(variable = names(y), NA_rate = y, row.names = NULL)
df%>%arrange(NA_rate)%>%
  ggplot(aes(y = variable, x = NA_rate))+
  geom_bar(stat = "identity",alpha = 0.7, color = "black", fill = "blue")+
  theme_minimal()+scale_x_continuous(labels = scales::percent)+
  ylab("")+
  xlab("Tỷ lệ NA")
```

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/tbprepro01-1.png" alt="Mô tả tỷ lệ giá trị không quan sát được của các biến trong dữ liệu gapminder bằng đồ thị dạng cột" width="672" />
<p class="caption">(\#fig:tbprepro01)Mô tả tỷ lệ giá trị không quan sát được của các biến trong dữ liệu gapminder bằng đồ thị dạng cột</p>
</div>

Có thể dễ dàng nhận thấy rằng biến $\textit{gdp}$ có tỷ lệ giá trị không quan sát được cao nhất lên đến khoảng 28\%, sau đó là biến $\textit{infant_mortality}$ với tỷ lệ giá trị không quan sát được khoảng 14\%. Các biến $\textit{population}$ và $\textit{fertility}$ có tỷ lệ giá trị không quan sát được là khoảng 2\%. Các biến còn lại gần như không có giá trị không quan sát được. 

Chúng ta có thể trực quan hóa tỷ lệ giá trị không quan sát được của các biến của dữ liệu một cách chi tiết hơn. Do các hàm số phục vụ cho trực quan hóa dữ liệu được giới thiệu trong phần sau của cuốn sách nên chúng tôi không giới thiệu chi tiết ở phần này. Chúng tôi sẽ mô tả cách xác định giá trị không quan sát được bằng một hàm số `Visual_Na()` mà chúng tôi tự phát triển. Hàm số có đầu vào là một dữ liệu và tên một biến rời rạc. Kết quả của hàm `Visual_Na()` sẽ cho bạn đọc thông tin về tỷ lệ giá trị không quan sát được của từng biến khi chia dữ liệu thành các nhóm nhỏ theo từng giá trị của biến rời rạc. Ví dụ, bạn đọc muốn tìm hiểu về tỷ lệ giá trị không quan sát được của các biến trong dữ liệu $\textbf{gapminder}$ theo từ năm, nghĩa là theo biến $\textit{year}$, bạn đọc chỉ cần khai báo hàm `Visual_Na()` sau đó thực thi hàm số này:


```r
Visual_Na<-function(df,variable){
  # Tìm chỉ số của biến variable
  ind<-names(df)==variable
  
  # Tính tỷ lệ NA của từng biến theo từng nhóm
  # Nhóm đươc xác định theo giá trị của variable
  df1<-df%>%group_by(df[,ind])%>%
    group_modify(~summarize(.x, across(everything(), function(x) sum(is.na(x))/length(x) ))) %>%
    as.data.frame()%>%gather(variables,na_rate,-1)
  
  # Đặt lại tên biến nhóm theo
  names(df1)[1]<-"variable"
  
  # Biểu diễn đồ thị
  p<-df1%>%ggplot(aes(x = variable, y = variables, fill = na_rate))+
    geom_tile(color = "grey", height = 1, width = 1)+
    scale_fill_gradient(low="white", high = "orange",
                        labels = scales::label_percent())+
    theme_minimal()+ylab("")+xlab("")
  return(p)
}
```


```r
Visual_Na(gapminder,"year")
```

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/tbprepro02-1.png" alt="Tỷ lệ giá trị không quan sát được của các biến trong dữ liệu gapminder theo năm bắt đầu từ 1960 đến 2016" width="672" />
<p class="caption">(\#fig:tbprepro02)Tỷ lệ giá trị không quan sát được của các biến trong dữ liệu gapminder theo năm bắt đầu từ 1960 đến 2016</p>
</div>

Hình \@ref(fig:tbprepro02) cho biết chi tiết hơn về tỷ lệ giá trị NA xuất hiện trong các biến so với hình \@ref(fig:tbprepro01). Có thể thấy rằng biến $\textit{gdp}$ có tỷ lệ NA cao nhất là do giai đoạn 2012 đến 2016 tỷ lệ NA là gần 100\%. Biến $\textit{infant_mortality}$ ngoài năm 2016 có tỷ lệ NA là 100\% còn có tỷ lệ giá trị không quan sát được khá cáo trong các năm trước năm 1980. Hai biến $\textit{population}$ và $\textit{fertility}$ có tỷ lệ giá trị NA là 100\% vào 2016, trong khi các năm khác tỷ lệ NA là bằng 0.

### Xử lý giá trị không quan sát được.
Khi dữ liệu có giá trị không quan sát được, cách xử lý đơn giản nhất là xóa các quan sát hoặc xóa các biến chứa các giá trị đó. Nếu bạn đọc gặp dữ liệu mà trong đó có một hoặc một số quan sát có đa số các giá trị trong đó là $NA$, trong khi tất cả các quan sát còn lại đều không có chứa $NA$, thì cách xử lý xóa quan sát có giá trị $NA$ là giải pháp hợp lý nhất. Ví dụ như chúng ta có dữ liệu về thông tin của sinh viên của một lớp như sau

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> MSV </th>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:right;"> Age </th>
   <th style="text-align:left;"> Gender </th>
   <th style="text-align:right;"> Height (cm) </th>
   <th style="text-align:right;"> Weight (kg) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> MSV00001 </td>
   <td style="text-align:left;"> Lý Văn Thắng </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 176 </td>
   <td style="text-align:right;"> 68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV43241 </td>
   <td style="text-align:left;"> Nguyễn Văn An </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 169 </td>
   <td style="text-align:right;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV65432 </td>
   <td style="text-align:left;"> Lê Thị Loan </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:left;"> Nữ </td>
   <td style="text-align:right;"> 155 </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV34001 </td>
   <td style="text-align:left;"> Trần Mạnh Cường </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 150 </td>
  </tr>
  <tr>
   <td style="text-align:left;background-color: #FFB300 !important;"> MSV33789 </td>
   <td style="text-align:left;background-color: #FFB300 !important;"> Nguyễn Thị Thu Thủy </td>
   <td style="text-align:right;background-color: #FFB300 !important;"> NA </td>
   <td style="text-align:left;background-color: #FFB300 !important;"> NA </td>
   <td style="text-align:right;background-color: #FFB300 !important;"> NA </td>
   <td style="text-align:right;background-color: #FFB300 !important;"> NA </td>
  </tr>
</tbody>
</table>

Quan sát tương ứng với mã sinh viên "MSV33789" ngoài thông tin về tên sinh viên, các thông tin khác đều không quan sát được. Ngoài sinh viên này, các sinh viên còn lại đều có đầy đủ thông tin. Trong trường hợp này phương pháp xử lý hiệu quả nhất là xóa sinh viên "MSV33789" khỏi dữ liệu trước khi phân tích. 

Khi các giá trị không quan sát được tập trung ở một số quan sát (hàng) hoặc tập trung ở một số biến (cột), chúng ta nói rằng các giá trị không quan sát được một cách không ngẫu nhiên (Missing value not at random hay MNAR). Dưới đây là một ví dụ khác mà các giá trị không quan sát được tập trung vào một biến:

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> MSV </th>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:right;"> Age </th>
   <th style="text-align:left;"> Gender </th>
   <th style="text-align:right;"> Height (cm) </th>
   <th style="text-align:right;"> Weight (kg) </th>
   <th style="text-align:right;"> GPA </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> MSV00001 </td>
   <td style="text-align:left;"> Lý Văn Thắng </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 176 </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;background-color: #FFB300 !important;"> 3.25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV43241 </td>
   <td style="text-align:left;"> Nguyễn Văn An </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 169 </td>
   <td style="text-align:right;"> 72 </td>
   <td style="text-align:right;background-color: #FFB300 !important;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV65432 </td>
   <td style="text-align:left;"> Lê Thị Loan </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:left;"> Nữ </td>
   <td style="text-align:right;"> 155 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;background-color: #FFB300 !important;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV34001 </td>
   <td style="text-align:left;"> Trần Mạnh Cường </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:right;background-color: #FFB300 !important;"> NA </td>
  </tr>
</tbody>
</table>

Đây cũng là một ví dụ về việc giá trị không quan sát được xuất hiện một cách không ngẫu nhiên. Có thể thấy rằng trong cột $\textit{GPA}$ đa số các giá trị là không quan sát được. Mọi phân tích liên quan đến giá trị của biến này sẽ không có ý nghĩa, do đó cách tốt nhất là xóa cột này ra khỏi dữ liệu. Để xóa các quan sát (hàng) có chứa giá trị không quan sát được ra khỏi dữ liệu, bạn đọc có thể sử dụng hàm `drop_na()` của thư viện $\textbf{tidyr}$. Để xóa một cột khỏi dữ liệu, bạn đọc có thể coi dữ liệu như là một `list` và gán giá trị của biến đó bằng giá trị `NULL`:

```r
# Dữ liệu có tên là dat
dat<-drop_na(dat) 
# Xóa các quan sát (hàng) có giá trị NA ra khỏi dữ liệu

dat$ten_cot<-NULL # 
Xóa cột có tên là ten_cot ra khoi du lieu
```

Nếu giá trị không quan sát được tập trung vào một số quan sát hoặc một số cột thì xóa quan sát hay xóa cột sẽ không làm ảnh hưởng đến kết quả phân tích. Tuy nhiên, dữ liệu chúng ta thường gặp sẽ có các giá trị không quan sát được nằm rải rác ở các cột không theo một quy tắc nào. Chúng tôi muốn nói đến trường hợp dữ liệu không quan sát được xuất hiện một cách hoàn toàn ngẫu nhiên (Missing completely at random, hay MCAR). Khi gặp trường hợp này nếu xóa đi các quan sát có  chứa giá trị NA, tỷ lệ dữ liệu bị xóa đi sẽ là rất đáng kể.

Để minh họa rõ hơn cho vấn đề này, và để đánh giá hiệu quả của các phương pháp xử lý giá trị NA trong các phần sau, chúng tôi sẽ sử dụng dữ liệu $\textbf{mpg}$ của thư viện $\textbf{ggplot2}$. Đây là dữ liệu có 234 quan sát và 11 biến. Dữ liệu mô tả mức độ tiêu hao nhiên liệu của các loại xe ô tô thương mại đang bán trên thị trường trong hai năm 1999 và 2008. Dữ liệu không có giá trị NA nhưng chúng ta sẽ thêm các giá trị không quan sát được vào dữ liệu một các ngẫu nhiên. Sau đó dữ liệu chính xác sẽ được sử dụng để đánh giá phương pháp xử lý giá trị không quan sát được.

Bạn đọc sử dụng đoạn câu lệnh dưới đây để thêm giá trị không quan sát được vào trong dữ liệu một cách ngẫu nhiên. Dữ liệu mới sau khi thêm NA vào sẽ được gọi tên là $\textbf{na.mpg}$ để phân biệt với dữ liệu ban đầu. 


```r
# Tạo dữ liệu mới giống như dữ liệu mpg
na.mpg<-mpg

# Định dạng các cột kiểu biến rời rạc thành kiểu factor
chiso<- !(names(na.mpg) %in% c("displ", "cty", "hwy"))
na.mpg[,chiso]<-lapply(na.mpg[,chiso], as.factor)%>%
  as.data.frame()

# Viết hàm số để thêm giá trị NA vào một véc-tơ
## Hàm số thêm vào véc-tơ x các giá trị NA một cách ngẫu nhiên
## Tỷ lệ giá trị NA được thêm vào là na.rate
rd.add<-function(x, na.rate){
  n<-length(x)
  k<-round(n*na.rate)
  ind<-sample(1:n,k,replace=FALSE)
  x[ind]<-NA
  return(x)
}

# Thêm giá trị NA vào các cột NGOẠI TRỪ ba cột
## Cột nhà sản xuất: manufacturer
## Cột loại xe: model
## Cột năm sản xuất
## tỷ lệ thêm NA một cách ngẫu nhiên vào các cột là 2%
chiso<- !(names(na.mpg) %in% c("manufacturer", "model", "year"))
set.seed(12)
na.mpg[,chiso]<-as.data.frame(lapply(na.mpg[,chiso], 
                                     rd.add, 
                                     na.rate = 0.02))

# Xem mỗi cột có bao nhiêu giá trị NA
sapply(na.mpg, f<-function(x) sum(is.na(x)))
```

```
## manufacturer        model        displ         year          cyl        trans 
##            0            0            5            0            5            5 
##          drv          cty          hwy           fl        class 
##            5            5            5            5            5
```

Chúng ta thấy rằng có 8 trên tổng số 11 cột có giá trị NA, mỗi cột có 5 giá trị NA xuất hiện một cách ngẫu nhiên trên tổng số 234 giá trị (tỷ lệ khoảng 2%). Tuy nhiên số quan sát có chứa NA lại lớn hơn 2% rất nhiều. Hàm `drop_na()` của thư viện $\textbf{tidyr}$ sẽ xóa các quan sát có giá trị không quan sát được ra khỏi dữ liệu. Chúng ta có thể tính được tỷ lệ dữ liệu còn giữ lại là bao nhiêu như sau:

```r
nrow(drop_na(na.mpg))/nrow(na.mpg)
```

```
## [1] 0.8461538
```

Có thể thấy nếu 2% dữ liệu không quan sát được xuất hiện ngẫn nhiên ở mỗi cột thì tỷ lệ dữ liệu còn lại là khoảng 85% nếu chúng ta xóa các quan sát có chứa NA, nghĩa là 15% dữ liệu đã bị xóa. Chúng ta có thể thử tăng tỷ lệ giá trị không quan sát được trên mỗi cột lên thành 3%, 5%, 10%, 20%, 30% và quan sát tỷ lệ dữ liệu còn lại sau khi xóa.

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl003)Tỷ lệ dữ liệu bị xóa nếu loại bỏ quán sát có NA</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Tỷ lệ NA </th>
   <th style="text-align:left;"> Tỷ lệ xóa </th>
   <th style="text-align:left;"> Tỷ lệ còn lại </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 15% </td>
   <td style="text-align:left;"> 85% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 21% </td>
   <td style="text-align:left;"> 79% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5% </td>
   <td style="text-align:left;"> 34% </td>
   <td style="text-align:left;"> 66% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10% </td>
   <td style="text-align:left;"> 57% </td>
   <td style="text-align:left;"> 43% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 20% </td>
   <td style="text-align:left;"> 84% </td>
   <td style="text-align:left;"> 16% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 30% </td>
   <td style="text-align:left;"> 94% </td>
   <td style="text-align:left;"> 6% </td>
  </tr>
</tbody>
</table>

Bảng \@ref(tab:tbptdl003) cho thấy nếu xử lý giá trị không quan sát được bằng cách xóa quan sát thì tỷ lệ dữ liệu còn lại giảm đi rất nhanh. Khi tỷ lệ NA xuất hiện một cách ngẫu nhiên trên mỗi cột từ 5% trở lên chúng ta phải xóa đi hơn 35% số quan sát. Tỷ lệ dữ liệu xóa như vậy sẽ ảnh hưởng lớn đến kết quả của phân tích dữ liệu.Rõ ràng đây không phải là một giải pháp hiệu quả khi giá trị NA xuất hiện trong hầu hết các cột.

Phương pháp xử lý giá trị không quan sát được thường được áp dụng hơn là thay thế giá trị không quan sát được bằng các giá trị thích hợp. Phương pháp đơn giản nhất đó là giả thiết các cột chứa giá trị không quan sát được độc lập với nhau và sử dụng các giá trị đặc trưng của cột dữ liệu đó để thay thế cho giá trị không quan sát được. Các phương pháp phức tạp hơn tính toán mối liên hệ giữa các cột dữ liệu và xây dựng các thuật toán để tìm giá trị thích hợp thay thế cho các giá trị không quan sát được nằm trong tất cả các cột. Mỗi phương pháp đều có ưu nhược điểm và chúng tôi thường thử cả hai hướng tiếp cận sau đó đánh giá hiệu quả của kết quả phân tích. Các phương pháp thay thế giá trị không quan sát được bằng một giá trị thích hợp được trình bày trong các phần tiếp theo.

#### Thay thế giá trị không quan sát được bằng các đại lượng đặc trưng của biến
Phương pháp thay thế này dựa trên giả thiết rằng cột chứa giá trị không quan sát được không có mối liên hệ đến các cột còn lại, chúng ta sẽ sử dụng một trong các giá trị đặc trưng của các giá trị quan sát được của cột đó như trung bình (mean), trung vị (median), hoặc mode để thay thế cho các giá trị không quan sát được.

- Giá trị trung bình thường được sử dụng để thay thế cho các giá trị không quan sát được cho véc-tơ kiểu số liên tục và phân phối của các giá trị không có đuôi dài và không có giá trị bất thường.

- Giá trị trung vị, là giá trị tại ngưỡng xác suất 50%, thường được sử dụng để thay thế cho các giá trị không quan sát được trong véc-tơ kiểu số liên tục và véc-tơ có đuôi dài. Giá trị trung vị có ưu điểm là ít bị ảnh hưởng bởi các giá trị ngoại lai và không bị thay đổi sau các bước biến đổi dữ liệu bằng các hàm đơn điệu.

- Giá trị mode, là giá trị mà hàm mật độ có xác suất cao nhất, có thể dùng cho cả véc-tơ kiểu số liên tục hoặc véc-tơ kiểu biến rời rạc. Trong trường hợp véc-tơ kiểu số liên tục, bạn đọc cần phải ước lượng hàm mật độ nên giá trị mode sẽ còn phụ thuộc vào phương pháp tiếp cận của người phân tích.

Để thay thế giá trị không quan sát được bằng một giá trị khác, bạn đọc có thể sử dụng hàm `na_if()` của thư viện $\textbf{dplyr}$, hàm `replace_na()` của thư viện $\textbf{tidyr}$, hoặc cũng có thể tự xây dựng hàm số của mình. Để đơn giản hóa, chúng ta giả sử rằng sẽ luôn luôn sử dụng giá trị thay thế là giá trị trung vị khi đối với véc-tơ kiểu số liên tục và giá trị mode đối với véc-tơ kiểu biến rời rạc.




```r
my_mode<-function(x){ # Tự định nghĩa hàm mode
  names(which.max(table(x)))
}
my_fillna_1<-function(x){ # Tự định nghĩa cách thay thế giá trị NA
  if(is.numeric(x)){
    # Nếu x là biến liên tục thì dùng median
    x[is.na(x)]<-median(x,na.rm=TRUE)
  } else {
    # Nếu x là biến rời rạc thì dùng mode
    x[is.na(x)]<-my_mode(x)
  }
  return(x)
}
mpg_1<-lapply(na.mpg, my_fillna_1)%>%as.data.frame()
```

Giá trị đúng của các biến kiểu số liên tục, bao gồm các biến có tên là $\textit{displ}$, $\textit{hwy}$, và $\textit{cty}$, và giá trị được dùng để thay thế được tổng kết lại trong bảng \@ref(tab:tbptdl004)
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl004)So sánh giá trị đúng và giá trị thay thế của các biến liên tục trong dữ liệu mpg</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> displ đúng </th>
   <th style="text-align:center;"> displ thay thế </th>
   <th style="text-align:center;"> hwy đúng </th>
   <th style="text-align:center;"> hwy thay thế </th>
   <th style="text-align:center;"> cty đúng </th>
   <th style="text-align:center;"> cty thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 3.3 </td>
   <td style="text-align:center;border-left:1px solid;"> 16 </td>
   <td style="text-align:center;border-left:1px solid;"> 25 </td>
   <td style="text-align:center;border-left:1px solid;"> 17 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 5.4 </td>
   <td style="text-align:center;border-left:1px solid;"> 3.3 </td>
   <td style="text-align:center;border-left:1px solid;"> 24 </td>
   <td style="text-align:center;border-left:1px solid;"> 25 </td>
   <td style="text-align:center;border-left:1px solid;"> 11 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 3.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 3.3 </td>
   <td style="text-align:center;border-left:1px solid;"> 12 </td>
   <td style="text-align:center;border-left:1px solid;"> 25 </td>
   <td style="text-align:center;border-left:1px solid;"> 15 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 2.7 </td>
   <td style="text-align:center;border-left:1px solid;"> 3.3 </td>
   <td style="text-align:center;border-left:1px solid;"> 27 </td>
   <td style="text-align:center;border-left:1px solid;"> 25 </td>
   <td style="text-align:center;border-left:1px solid;"> 18 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 1.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 3.3 </td>
   <td style="text-align:center;border-left:1px solid;"> 20 </td>
   <td style="text-align:center;border-left:1px solid;"> 25 </td>
   <td style="text-align:center;border-left:1px solid;"> 26 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 17 </td>
  </tr>
</tbody>
</table>

Giá trị đúng của các biến rời rạc và giá trị dùng để thay thế được tổng kết trong Bảng \@ref(tab:tbptdl005).

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl005)So sánh giá trị đúng và giá trị thay thế của các biến rời rạc trong dữ liệu mpg</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> cyl đúng </th>
   <th style="text-align:center;"> cyl thay thế </th>
   <th style="text-align:center;"> trans đúng </th>
   <th style="text-align:center;"> trans thay thế </th>
   <th style="text-align:center;"> drv đúng </th>
   <th style="text-align:center;"> drv thay thế </th>
   <th style="text-align:center;"> fl đúng </th>
   <th style="text-align:center;"> fl thay thế </th>
   <th style="text-align:center;"> class đúng </th>
   <th style="text-align:center;"> class thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> e </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> suv </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m5) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> pickup </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> p </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> suv </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> subcompact </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 6 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> p </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> pickup </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> suv </td>
  </tr>
</tbody>
</table>

Không dễ dàng để đưa ra kết luận là thay thế các giá trị không quan sát được của véc-tơ kiểu số liên tục bằng giá trị trung vị như trong Bảng \@ref(tab:tbptdl004) là hiệu quả hay không. Chúng ta chỉ có thể thấy rằng giá trị thay thế nằm giữa các giá trị thực và khoảng cách từ giá trị thay thế đến các giá trị đúng không quá lớn. Về lý thuyết, khi thay thế giá trị không quan sát được bằng giá trị trung vị, chúng ta đang cố gắng đưa ra các dự đoán cho giá trị không quan sát được sao cho giá trị trung bình của sai số tuyệt đối (Mean Absoluted Error hay MAE) là nhỏ nhất. Trong trường hợp chúng ta sử dụng giá trung bình để thay thế, chúng ta tối thiệu hóa trung bình bình phương của sai số của giá trị dự đoán (Mean Squared Error).  

Thay thế các giá trị không quan sát được trong các véc-tơ kiểu biến rời rạc bằng giá trị mode tương đương với nguyên tắc làm giảm thiểu tối đa xác suất dự đoán sai. Tuy nhiên, giá trị thay thế cho giá trị rời rạc trong bảng \@ref(tab:tbptdl005) chỉ cho 1-3 lần dự đoán đúng cho mỗi biến. Nguyên nhân là do giá trị mode trong các biến rời rạc không chiếm ưu thế so với các giá trị khác. Chẳng hạn như biến $\textit{drv}$ bị dự đoán sai 4/5 kết quả do biến này có 2 giá trị mode.

#### Thay thế giá trị không quan sát được bằng một mẫu ngẫu nhiên.
Vẫn với giả thiết rằng cột chứa giá trị không quan sát được không có mối liên hệ đến các cột còn lại, chúng ta sẽ sử dụng phép lấy mẫu ngẫu nhiên từ các giá trị quan sát được để thay thế cho các giá trị NA. Hàm `sample()` là hàm số có sẵn được sử dụng để sinh ngẫu nhiên. Để lấy ra $k$ số ngẫu nhiên từ một véc-tơ $\textbf{x}$ ban đầu, chúng ta sử dụng câu lệnh như sau:

```r
sample(x,size = k, replace = TRUE) 
```

Tham số `replace` nhận giá trị bằng TRUE có ý nghĩa là giá trị ngẫu nhiên được lấy ra từ véc-tơ $\textbf{x}$ có thể được lấy lặp lại. Chúng ta tự định nghĩa hàm `fill_na_2()` để thay thế giá trị ngẫu nhiên trong một véc-tơ $\textbf{x}$ bằng một mẫu ngẫu nhiên có lặp lại được lấy từ $x$ như sau

```r
my_fillna_2<-function(x){ # Hàm thay thế giá trị NA, phương pháp thứ 2
  ind<-is.na(x) # véc-tơ kiểu logic, nhận giá trị TRUE tại các vị trí NA
  k<-sum(ind)
  x[ind]<-sample(x[!ind],k,replace = TRUE)
  return(x)
}
set.seed(12)
mpg_1<-lapply(na.mpg, my_fillna_2)%>%as.data.frame()
```

Giá trị đúng của các biến kiểu số liên tục và giá trị dùng để thay thế được tổng kết lại trong Bảng \@ref(tab:tbptdl006)
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl006)Biến liên tục, thay thế NA bằng lấy mẫu ngẫu nhiên</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> displ đúng </th>
   <th style="text-align:center;"> displ thay thế </th>
   <th style="text-align:center;"> hwy đúng </th>
   <th style="text-align:center;"> hwy thay thế </th>
   <th style="text-align:center;"> cty đúng </th>
   <th style="text-align:center;"> cty thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 4.7 </td>
   <td style="text-align:center;border-left:1px solid;"> 16 </td>
   <td style="text-align:center;border-left:1px solid;"> 17 </td>
   <td style="text-align:center;border-left:1px solid;"> 17 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 5.4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 24 </td>
   <td style="text-align:center;border-left:1px solid;"> 14 </td>
   <td style="text-align:center;border-left:1px solid;"> 11 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 3.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 12 </td>
   <td style="text-align:center;border-left:1px solid;"> 19 </td>
   <td style="text-align:center;border-left:1px solid;"> 15 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 15 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 2.7 </td>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 27 </td>
   <td style="text-align:center;border-left:1px solid;"> 19 </td>
   <td style="text-align:center;border-left:1px solid;"> 18 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 18 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 1.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 20 </td>
   <td style="text-align:center;border-left:1px solid;"> 17 </td>
   <td style="text-align:center;border-left:1px solid;"> 26 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 13 </td>
  </tr>
</tbody>
</table>



Giá trị thật của các biến kiểu factor và giá trị dùng để thay thế được tổng kết trong Bảng \@ref(tab:tbptdl007)

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl007)Biến rời rạc, thay thế NA bằng lấy mẫu ngẫu nhiên</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> cyl đúng </th>
   <th style="text-align:center;"> cyl thay thế </th>
   <th style="text-align:center;"> trans đúng </th>
   <th style="text-align:center;"> trans thay thế </th>
   <th style="text-align:center;"> drv đúng </th>
   <th style="text-align:center;"> drv thay thế </th>
   <th style="text-align:center;"> fl đúng </th>
   <th style="text-align:center;"> fl thay thế </th>
   <th style="text-align:center;"> class đúng </th>
   <th style="text-align:center;"> class thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l6) </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m5) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> e </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> suv </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> compact </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m5) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> pickup </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> compact </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l5) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> p </td>
   <td style="text-align:center;border-left:1px solid;"> p </td>
   <td style="text-align:center;border-left:1px solid;"> suv </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> pickup </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 6 </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> subcompact </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> midsize </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 6 </td>
   <td style="text-align:center;border-left:1px solid;"> 6 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l5) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> p </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> pickup </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> midsize </td>
  </tr>
</tbody>
</table>

Hiệu quả của phương pháp lấy mẫu ngẫu nhiên so với phương pháp sử dụng các giá trị trung vị hoặc mode là không rõ ràng. Phương pháp thay thế giá trị không quan sát được bằng một mẫu ngẫu nhiên chỉ cho hiệu quả khi dữ liệu đủ lớn và phân phối xác suất của các biến quan sát được ổn định. Nhược điểm lớn nhất của phương pháp này đó là giá trị được sử dụng để thay thế được sinh ngẫu nhiên nên có khả năng sẽ làm cho dữ liệu bị sai lệch, đồng thời mỗi lần thực hiện phương pháp sẽ cho các kết quả khác nhau tùy theo hàm sinh ngẫu nhiên. 

#### Thay thế giá trị không quan sát được dựa trên các biến khác {#replaceNAbymodel}
Giả thiết cột chứa giá trị không quan sát được không có mối liên hệ đến các cột còn lại là một giả thiết không thực tế. Các cột dữ liệu luôn luôn có mối liên hệ với nhau dù ít hay nhiều. Nói theo khái niệm của xác suất - thống kê thì các cột dữ liệu thường không độc lập với nhau. Làm thế nào để biết hai cột dữ liệu bất kỳ là độc lập hay phụ thuộc ? Đây là một câu hỏi không dễ. Bạn đọc cần có kiến thức về xác suất và thống kê toán để có được câu trả lời triệt để. Có rất nhiều lý thuyết khác nhau nghiên cứu về sự phụ thuộc giữa các biến và đa số các lý thuyết đó vượt quá phạm vi của cuốn sách này. Chúng tôi chỉ trình bày các phương pháp được công nhận rộng rãi ở mức độ vừa đủ để bạn đọc không có nền tảng nâng cao về toán học - xác suất thống kê có thể hiểu được. Nhìn chung, để đưa ra kết luận hai cột dữ liệu có độc lập hay không, bạn đọc có thể sử dụng các kiểm định như sau:

1. Kiểm định Khi-bình phương khi cả hai biến đều là biến rời rạc. 

2. Kiểm định hệ số tương quan Person, hoặc hệ số tương quan Spearman, hoặc hệ số tương quan Kendall khi cả hai biến đều là biến liên tục. 

3. Sử dụng phân tích phương sai (hay còn gọi là anova test) trong trường hợp một biến là rời rạc và một biến là liên tục.

Chi tiết của các kiểm định này được trình bày ở phần Phụ lục \@ref(appenptdl01). Chúng ta sẽ sử dụng các phương pháp này để kiểm tra mối liên hệ giữa các cột trong dữ liệu $\textbf{na.mpg}$.

Để thực hiện kiểm định Khi-bình phương trong R, chúng ta sử dụng hàm `chisq.test()`. Ví dụ, để kiểm ra hai biến $\textit{year}$ và $\textit{drv}$ có mối liên hệ hay không, chúng ta thực hiện như sau:

```r
chisq.test(na.mpg$year,na.mpg$drv)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  na.mpg$year and na.mpg$drv
## X-squared = 1.689, df = 2, p-value = 0.4298
```

Giá trị $\textit{p-value}$ bằng `paste(round((chisq.test(na.mpg$year,na.mpg$drv))$p.value*100,2), "%")` nghĩa là xác suất bác bỏ giả thiết hai biến $year$ và $drv$ độc lập là `paste(round((100-chisq.test(na.mpg$year,na.mpg$drv))$p.value*100,2), "%")`. Thông thường, mức xác suất bác bỏ giả thiết độc lập thường được chọn ở mức 95% hoặc thậm chí 99%. Do xác suất bác bỏ giả thiết độc lập là thấp nên trong trường hợp này có thể đưa ra kết luận rằng hai biến $\textit{year}$ và $\textit{drv}$ là không có mối liên hệ. Tương tự, để kiểm ra hai biến $\textit{drv}$ và $\textit{cyl}$ có mối liên hệ hay không, chúng ta thực hiện như sau:

```r
chisq.test(na.mpg$drv, na.mpg$cyl)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  na.mpg$drv and na.mpg$cyl
## X-squared = 90.288, df = 6, p-value < 2.2e-16
```

Trong trường hợp này, xác suất bác bỏ giả thiết độc lập là xấp xỉ 100% nên chúng ta có thể đưa ra kết luận rằng hai biến $drv$ và $cyl$ là có mối liên hệ.

Để kiểm định hệ số tương quan giữa hai biến liên tục chúng ta sử dụng hàm `cor.test()`. Tham số `method` nhận giá trị `"pearson"`, `"kendall"`, hoặc `"spearman"` tương ứng với các hệ số tương quan Pearson, hệ số tương quan Kendall, hoặc hệ số tương quan Spearman. Chúng ta kiểm định sự độc lập giữa hai biến $\textit{displ}$ và $\textit{hwy}$ như sau


```r
cor.test(na.mpg$displ, na.mpg$hwy, method = "pearson")
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  na.mpg$displ and na.mpg$hwy
## t = -17.743, df = 223, p-value < 2.2e-16
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  -0.8143893 -0.7048317
## sample estimates:
##       cor 
## -0.765092
```

```r
cor.test(na.mpg$displ, na.mpg$hwy, method = "kendall")
```

```
## 
## 	Kendall's rank correlation tau
## 
## data:  na.mpg$displ and na.mpg$hwy
## z = -13.857, p-value < 2.2e-16
## alternative hypothesis: true tau is not equal to 0
## sample estimates:
##        tau 
## -0.6534741
```

```r
cor.test(na.mpg$displ, na.mpg$hwy, method = "spearman")
```

```
## 
## 	Spearman's rank correlation rho
## 
## data:  na.mpg$displ and na.mpg$hwy
## S = 3467012, p-value < 2.2e-16
## alternative hypothesis: true rho is not equal to 0
## sample estimates:
##        rho 
## -0.8262809
```

Kiểm định cả ba hệ số tương quan đều cho xác suất bác bỏ giả thiết độc lập là xấp xỉ 100%. Nói một cách khác có thể khẳng định rằng hai biến $\textit{displ}$ và $\textit{hwy}$ là có sự phụ thuộc.

Sau cùng, để kiểm định sự phụ thuộc giữa một biến rời rạc và một biến liên tục, chúng ta sử dụng phân tích phương sai. Hàm số để thực hiện phân tích phương sai trong R là hàm `aov()`. Chúng ta kiểm định sự phụ thuộc giữa biến liên tục $\textit{hwy}$ và biến rời rạc $\textit{cyl}$ như sau:

```r
summary(aov(hwy~cyl,data=na.mpg))
```

```
##              Df Sum Sq Mean Sq F value Pr(>F)    
## cyl           3   4479  1492.9   101.6 <2e-16 ***
## Residuals   220   3233    14.7                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 10 observations deleted due to missingness
```

Xác suất bác bỏ giả thiết giá trị trung bình của biến $\textit{hwy}$ bằng nhau theo các nhóm của biến $\textit{cyl}$ là xấp xỉ 100\% hay nói một cách khác $\textit{hwy}$ và $\textit{cyl}$ là có mối liên hệ.

Để xem xét một cách tổng thể mối liên hệ giữa các biến trong dữ liệu $\textbf{na.mpg}$, bạn đọc có thể sử dụng kiểm định phù hợp với từng cặp biến và lưu xác suất bác bỏ giả thiết độc lập vào một ma trận. Hàm số `ind_check()` được chúng tôi tự xây dựng với đầu vào là một dữ liệu, dưới dạng một tibble hoặc một data.frame, cho đầu ra là một ma trận cho biết xác suất bác bỏ giả thiết độc lập của từng cặp biến như thế nào.


```r
### Hàm số `ind_check()`
ind_check<-function(dat){
  dat<-as.data.frame(dat)
  dat.name<-names(dat)
  p<-dim(dat)[2]
  M<-matrix(0,p,p)
  for (i in 1:(p-1)){
    for (j in (i+1):p){
      x<-dat[,i]
      y<-dat[,j]
      if(is.character(x)|is.character(y)){
        return(NA)
      } else {
        if (is.numeric(x)){
          if (is.numeric(y)){
            test<-cor.test(x, y, method = "spearman")
            M[i,j]<-1 - test$p.value
          } else {
            test<-summary(aov(x ~ y))
            M[i,j]<-1 - test[[1]][[5]][1]
          }
        } else {
          if (is.numeric(y)){
            test<-summary(aov(y ~ x))
            M[i,j]<-1 - test[[1]][[5]][1]
          } else {
            test<-chisq.test(x,y)
            M[i,j]<-1 - test$p.value
          }
        }
      }
      M[j,i]<-M[i,j]
    }
  }
  colnames(M)<-dat.name
  rownames(M)<-dat.name
  diag(M)<-1
  return(round(M,2))
}
```

Ma trận thể hiện xác suất bác bỏ giả thiết độc lập giữa từng cặp biến trong dữ liệu $\textbf{na.mpg}$ ở trong Hình \@ref(fig:fgna01) 

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgna01-1.png" alt="Ma trận xác suất bác bỏ giả thuyết độc lập giữa các cặp biến trong dữ liệu na.mpg" width="672" />
<p class="caption">(\#fig:fgna01)Ma trận xác suất bác bỏ giả thuyết độc lập giữa các cặp biến trong dữ liệu na.mpg</p>
</div>

Có thể thấy rằng ngoại trừ biến $\textit{year}$ ít có mối liên hệ đến các biến khác, còn lại đa số các biến là có mối liên hệ với nhau. Điều này được thể hiện qua xác suất bác bỏ giả thiết độc lập giữa các biến trong ma trận của hình đều xấp xỉ 100%. Khi xây dựng mô hình trên dữ liệu, sự xuất hiện của các biến ít có mối liên hệ đến các biến khác sẽ khiến mô hình bị nhiễu và làm giảm chất lượng dự đoán. Do đó, chúng tôi sẽ loại bỏ biến $\textit{year}$ khi dự đoán giá trị không quan sát được của các biến khác.

Phương pháp để xây dựng mô hình dự đoán cho các giá trị không quan sát được là thuật toán "rừng ngẫu nhiên". Đây là một thuật toán nâng cao của mô hình dạng cây quyết định sẽ được trình bày trong chương \@ref(sec:randomforest). Còn quá sớm để nói về mô hình này, bạn đọc chỉ cần hiểu rằng chúng ta sẽ dựa vào các giá trị quan sát được để xây dựng mô hình, hay tổng quát hơn là một hàm số $f$, mà biến có chứa giá trị NA phụ thuộc vào các biến không có giá trị NA tại các vị trí tương ứng để đưa ra dự đoán. Thư viện $\textbf{missForest}$ hỗ trợ chúng ta làm việc này. Bạn đọc có thể cài thư viện sau đó sử dụng hàm `missForest()`. Quá trình thay thế giá trị NA của dữ liệu $\textbf{na.mpg}$ bằng thuật toán rừng ngẫu nhiên chỉ cần một dòng lệnh:


```r
library(missForest)
na.mpg<-as.data.frame(na.mpg)
### Thời gian chạy mất khoảng 1-2 phút
model<-missForest(select(na.mpg,-year), maxiter = 200, ntree = 100) 
mpg_1<-model$ximp # Dữ liệu mpg_1 là dữ liệu sau khi thay thế NA
```

Giá trị đúng của các biến kiểu số và các giá trị thay thế bằng phương pháp xây dựng mô hình dự đoán ở trong Bảng \@ref(tab:tbptdl008)

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl008)Biến liên tục, thay thế NA bằng giá trị dự đoán bằng random forest</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> displ đúng </th>
   <th style="text-align:center;"> displ thay thế </th>
   <th style="text-align:center;"> hwy đúng </th>
   <th style="text-align:center;"> hwy thay thế </th>
   <th style="text-align:center;"> cty đúng </th>
   <th style="text-align:center;"> cty thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 16 </td>
   <td style="text-align:center;border-left:1px solid;"> 15.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 17 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 16.5 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 5.4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4.7 </td>
   <td style="text-align:center;border-left:1px solid;"> 24 </td>
   <td style="text-align:center;border-left:1px solid;"> 24.3 </td>
   <td style="text-align:center;border-left:1px solid;"> 11 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 11.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 3.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 3.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 12 </td>
   <td style="text-align:center;border-left:1px solid;"> 14.1 </td>
   <td style="text-align:center;border-left:1px solid;"> 15 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 14.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 2.7 </td>
   <td style="text-align:center;border-left:1px solid;"> 3.1 </td>
   <td style="text-align:center;border-left:1px solid;"> 27 </td>
   <td style="text-align:center;border-left:1px solid;"> 26.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 18 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 18.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 1.8 </td>
   <td style="text-align:center;border-left:1px solid;"> 1.9 </td>
   <td style="text-align:center;border-left:1px solid;"> 20 </td>
   <td style="text-align:center;border-left:1px solid;"> 19.0 </td>
   <td style="text-align:center;border-left:1px solid;"> 26 </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> 26.4 </td>
  </tr>
</tbody>
</table>

Giá trị đúng của các biến kiểu factor và giá trị thay thế bằng phương pháp xây dựng mô hình dự đoán ở trong Bảng \@ref(tab:tbptdl009)

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl009)Biến rời rạc, thay thế NA bằng giá trị dự đoán bằng random forest</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> cyl đúng </th>
   <th style="text-align:center;"> cyl thay thế </th>
   <th style="text-align:center;"> trans đúng </th>
   <th style="text-align:center;"> trans thay thế </th>
   <th style="text-align:center;"> drv đúng </th>
   <th style="text-align:center;"> drv thay thế </th>
   <th style="text-align:center;"> fl đúng </th>
   <th style="text-align:center;"> fl thay thế </th>
   <th style="text-align:center;"> class đúng </th>
   <th style="text-align:center;"> class thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l5) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> e </td>
   <td style="text-align:center;border-left:1px solid;"> e </td>
   <td style="text-align:center;border-left:1px solid;"> suv </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m5) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> pickup </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> pickup </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> 8 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> p </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> suv </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(l5) </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> 4 </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> subcompact </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> subcompact </td>
  </tr>
  <tr>
   <td style="text-align:center;border-left:1px solid;"> 6 </td>
   <td style="text-align:center;border-left:1px solid;"> 6 </td>
   <td style="text-align:center;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:center;border-left:1px solid;"> auto(s6) </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> f </td>
   <td style="text-align:center;border-left:1px solid;"> p </td>
   <td style="text-align:center;border-left:1px solid;"> r </td>
   <td style="text-align:center;border-left:1px solid;"> pickup </td>
   <td style="text-align:center;border-left:1px solid;border-right:1px solid;"> pickup </td>
  </tr>
</tbody>
</table>

Bạn đọc có thể nhận thấy: 

- Với các biến kiểu số, giá trị dùng để thay thế cho NA không khác nhiều so với giá trị đúng. Sai số giữa giá trị dự đoán với giá trị đúng nhỏ hơn rất nhiều so với sai số của hai phương pháp trước. 

- Với các biến kiểu rời rạc, ngoại trừ biến $\textit{trans}$ và biến $\textit{fl}$, các biến còn lại đều được dự đoán chính xác 100% bằng thuật toán rừng ngẫu nhiên. 

Nhìn chung, xây dựng mô hình để dự đoán giá trị không quan sát được dựa trên các biến khác là phương pháp cho hiệu quả vượt trội, đặc biệt đối với dữ liệu có các cột có mối liên hệ mật thiết với nhau. Điểm bất lợi duy nhất của phương pháp này là sự phức tạp trong kỹ thuật xây dựng mô hình. Bạn đọc cần có các hiểu biết cơ bản về xây dựng mô hình, trong trường hợp này là mô hình cây quyết định, và các kỹ thuật thống kê hiện đại như kỹ thuật lấy mẫu lặp, để hiểu được nguyên tắc dự đoán giá trị không quan sát được. Tất nhiên, thực thi hàm `missForest()` của thư viện cùng tên không cần bạn phải có các kiến thức này. Để hiểu được chính xác cách xây dựng mô hình, bạn đọc tham khảo chương \@ref(sec:randomForest).

## Xử lý giá trị ngoại lai

### Ảnh hưởng của giá trị ngoại lai lên kết quả phân tích
Giá trị ngoại lai hay còn được gọi là giá trị bất thường là một (hoặc một số) điểm dữ liệu có giá trị sai khác đáng kể so với đa số các quan sát khác. Một giá trị ngoại lai xuất hiện trong dữ liệu có thể là do lỗi trong quản lý dữ liệu, do sai số trong đo lường hoặc cũng có thể do bản chất phân phối của dữ liệu. Tùy theo nguồn gốc của giá trị ngoại lai mà chúng ta có cách xử lý dữ liệu khác nhau. Khi không được xử lý thích hợp, các giá trị ngoại lai có thể làm sai lệch kết luận của tất cả các phân tích về dữ liệu.

Giá trị ngoại lai được hiểu là những điểm dữ liệu khác xa tập hợp các điểm còn lại. Không có một định nghĩa chính xác nào cho khái niệm "khác xa các giá trị còn lại". Do đó, tùy theo bản chất của dữ liệu, và tùy theo quan điểm của người phân tích dữ liệu, mà một (hay một số) giá trị có khả năng là giá trị ngoại lai hay không. Giá trị ngoại lai thường chỉ được nhắc đến với các dữ liệu có số quan sát đủ lớn để đưa ra kết luận có ý nghĩa thống kê.

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier01-1.png" alt="Giá trị ngoại lai xuất hiện trong dư liệu có ít và nhiều quan sát. Hình bên trái: Các điểm A và B nằm cách xa 8 điểm còn lại nhưng dữ liệu chưa đủ lớn để đưa ra kết luận. Hình bên phải: điểm A và B nằm cách xa 98 điểm còn lại, có thể kết luận A và B là các điểm ngoại lai." width="672" />
<p class="caption">(\#fig:fgoutlier01)Giá trị ngoại lai xuất hiện trong dư liệu có ít và nhiều quan sát. Hình bên trái: Các điểm A và B nằm cách xa 8 điểm còn lại nhưng dữ liệu chưa đủ lớn để đưa ra kết luận. Hình bên phải: điểm A và B nằm cách xa 98 điểm còn lại, có thể kết luận A và B là các điểm ngoại lai.</p>
</div>

Hình \@ref(fig:fgoutlier01) mô tả trực quan các điểm A và B có khả năng là giá trị ngoại lai trong hai trường hợp là có ít quan sát và có tương đối nhiều quan sát. Khi dữ liệu có 10 quan sát như hình bên trái, có 8 quan sát màu xanh nằm gần nhau, điểm B nằm xa hơn tập hợp các điểm màu xanh một chút, còn điểm A nằm  cách xa hơn. Khi gặp dữ liệu như vậy, chúng ta có thể kết luận điểm A là giá trị ngoại lai vì điểm này nằm cách rất xa các điểm còn lại. Tuy nhiên còn kết luận điểm B có phải ngoại lai hay không thì còn tùy thuộc vào cách tiếp cận của người phân tích dữ liệu. Hình bên phải với dữ liệu có 100 quan sát. Các điểm màu xanh định hình khá rõ miền giá trị của trung tâm của dữ liệu là nằm xung quanh điểm (3,3) . Chúng ta có thể kết luận một cách khá chắc chắn rằng điểm A là một giá trị ngoại lai. Điểm B mặc dù nằm khá xa trung tâm của dữ liệu, nhưng để kết luận rằng có phải giá trị ngoại lai hay không vẫn phụ thuộc vào ý tưởng của người phân tích.

Nguồn gốc của giá trị ngoại lai là có thể có nhiều nguyên nhân khác nhau, bao gồm cả nguyên nhân khách quan hoặc nguyên nhân chủ quan. Các nguyên nhân khách quan có thể do nguồn sinh dữ liệu, hay hệ thống quản lý dữ liệu gặp sự cố, do lỗi trong quá trình truyền hoặc sao chép dữ liệu. Nguyên nhân chủ quan bao gồm có các hành vi gian lận, lỗi nhập và sao chép dữ liệu của con người, hoặc các giá trị được cố tình đưa vào trong dữ liệu với mục đích lấy phản hồi từ người dùng dữ liệu.

Nếu không xử lý giá trị ngoại lai, kết quả phân tích sẽ bị sai lệch đáng kể. Và dữ liệu có kích thước càng nhỏ thì ảnh hưởng của giá trị ngoại lai lại càng lớn. Trong ví dụ ở Hình \@ref(fig:fgoutlier01), giả sử chúng ta cần phân tích sự tác động của biến $X$ lên biến $Y$ bằng một mối quan hệ tuyến tính. Chúng ta xây dựng mô hình tuyến tính trong ba trường hợp

1. Giữ nguyên 10 quan sát và xây dựng mô hình mô tả mối liên hệ tuyến tính.

2. Loại bỏ điểm A trước khi xây dựng mô hình.

3. Loại bỏ điểm A và điểm B trước khi xây dựng mô hình.

Các đường tuyến tính mô tả mối liên hệ giữa biến $X$ và $Y$ được mô tả trong Hình \@ref(fig:fgoutlier02)

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier02-1.png" alt="Xây dựng mô hình tuyến tính trên dữ liệu vẫn chứa giá trị ngoại lai. Hình bên trái: bao gồm cả hai điểm A và B trong xây dựng mô hình. Hình ở giữa: loại điểm A và giữ lại điểm B trong xây dựng mô hình. Hình bên phải: loại bỏ cả điểm A và điểm B trước khi xây dựng mô hình." width="672" />
<p class="caption">(\#fig:fgoutlier02)Xây dựng mô hình tuyến tính trên dữ liệu vẫn chứa giá trị ngoại lai. Hình bên trái: bao gồm cả hai điểm A và B trong xây dựng mô hình. Hình ở giữa: loại điểm A và giữ lại điểm B trong xây dựng mô hình. Hình bên phải: loại bỏ cả điểm A và điểm B trước khi xây dựng mô hình.</p>
</div>

- Khi giữ nguyên 10 điểm dữ liệu để xây dựng mối quan hệ tuyến tính, đường thẳng mô tả mối quan hệ giữa $Y$ và $X$ là nằm trong hình phía bên trái của Hình \@ref(fig:fgoutlier02). Đường thẳng này có hệ số góc dương, nghĩa là một đường dốc lên khi đi từ trái sang phải, điều này có nghĩa là biến $X$ có tác động cùng chiều lên biến $Y$. Khi $X$ tăng hoặc giảm thì nhiều khả năng $Y$ cũng sẽ tăng hoặc giảm. 

- Sau khi loại bỏ điểm A và tính toán lại, đường thẳng mô tả mối quan hệ tuyến tính giữa $Y$ và $X$ ở là đường thẳng trong hình ở giữa của Hình \@ref(fig:fgoutlier02). Đường thẳng gần như nằm ngang, cho thấy $X$ không có tác động lên biến $Y$. Nghĩa là $X$ có tăng hay giảm cũng không làm thay đổi $Y$.

- Sau cùng, trong hình phía bên phải của Hình \@ref(fig:fgoutlier02), sau khi loại bỏ các điểm A và điểm B, đường thẳng mô tả mối quan hệ tuyến tính giữa $X$ và $Y$ là đường dốc xuống, nghĩa là mối tác động của $X$ lên $Y$ là ngược chiều. 

Bạn đọc có thể thấy rằng kết luận đưa sau từ kết quả ước lượng mô hình thay đổi hoàn toàn khi chúng ta có các lựa chọn khác nhau về loại bỏ các giá trị được cho là ngoại lai ra khỏi dữ liệu. Sự tác động của $X$ lên $Y$ từ thuận chiều (hình bên trái) sang không có mối liên hệ (hình ở giữa) và sau cùng là sự tác động ngược chiều của $X$ lên $Y$ (hình bên phải). Điều này cho thấy việc xác định và xử lý giá trị ngoại lai là vô cùng quan trọng trước khi xây dựng mô hình.

Trong phần tiếp theo chúng ta sẽ thảo luận về các phương pháp dùng để xác định các giá trị ngoại lai trong dữ liệu.

### Phương pháp phát hiện giá trị ngoại lai
Không có một định nghĩa chính xác như thế nào là giá trị ngoại lai, chính vì thế không có phương pháp chung để phát hiện giá trị ngoại lai. Với mỗi dữ liệu, với mỗi cách nhìn nhận giá trị ngoại lại khác nhau, mà có phương pháp tiếp cận cụ thể để xác định các giá trị đó. Trong phần này, chúng tôi chỉ trình bày các phương pháp chung được chấp nhận rộng rãi. Đây là các phương pháp đơn giản, dễ hiểu và có thể thực hiện được mà không cần bổ sung thêm kiến thức. Các phương pháp phức tạp hơn, đòi hỏi kiến thức nâng cao về dữ liệu như phân nhóm, phân cụm,..., sẽ được thảo luận trong chương sách học máy không có giám sát.

#### Phát hiện giá trị ngoại lai trong một véc-tơ
Để xác định một giá trị là giá trị ngoại lai hay không thường bao gồm hai bước, bước thứ nhất là sử dụng các phương pháp xác suất thống kê để xác định các giá trị có khả năng cao là ngoại lai, sau đó bước thứ hai là sử dụng kiến thức chuyên môn hoặc hỏi ý kiến chuyên gia để khẳng định lại kết quả từ bước thứ nhất.

Nếu véc-tơ là một véc-tơ kiểu chuỗi ký tự (không phải kiểu factor) thì không có quy tắc rõ ràng nào để xác định giá trị ngoại lai. Trước hết, việc một biến kiểu chuỗi ký tự có phải là một giá trị ngoại lai hay không phụ thuộc vào bản chất của véc-tơ chuỗi ký tự. Việc này hoàn toàn phụ thuộc vào hiểu biết của người phân tích dữ liệu với véc-tơ đó. Ví dụ, véc-tơ chuỗi ký tự là tên của người bằng tiếng Việt, một giá trị ngoại lai có thể là một tên người với nhiều hơn 6 hay 7 từ, bởi vì theo hiểu biết chung, tên người bình thường bao gồm 2,3 hoặc 4 từ. Ngoài ra, một chuỗi ký tự có thể là ngoại lai nếu chuỗi ký tự có độ dài bất thường, có chứa nhiều ký tự bất thường, hay một chuỗi ký tự không có ý nghĩa trong một véc-tơ bao gồm các chuỗi ký tự có ý nghĩa. Nói một cách khác một giá trị có phải là ngoại lai hay không hoàn toàn phụ thuộc vào cách tiếp cận của người phân tích dữ liệu. Các phương pháp xử lý dữ liệu kiểu chuỗi ký tự hiện nay có khả năng biến đổi một chuỗi ký tự thành một véc-tơ kiểu số. Việc xác định chuỗi ký tự có phải là một giá trị bất thường hay không sẽ liên quan đến việc xác định một véc-tơ kiểu số có phải là một véc-tơ có giá trị bất thường trong một tập hợp các véc-tơ. Các kỹ thuật này vượt quá phạm vi của cuốn sách nên chúng tôi không đề cập ở đây.

Đối với véc-tơ kiểu factor và véc-tơ kiểu logic, giá trị có khả năng là ngoại lai là các giá trị xuất hiện với tần xuất rất nhỏ. Chẳng hạn như khi mô tả một véc-tơ chứa tên các loại đồ uống được bán trong một siêu thị trong tháng, chúng ta gặp trường hợp sau:
<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier03-1.png" alt="Tần suất xuất hiện của các loại đồ uống được bán tại một siêu thị. Loại đồ uống có tần suất xuất hiện thấp có khả năng là giá trị ngoại lai" width="672" />
<p class="caption">(\#fig:fgoutlier03)Tần suất xuất hiện của các loại đồ uống được bán tại một siêu thị. Loại đồ uống có tần suất xuất hiện thấp có khả năng là giá trị ngoại lai</p>
</div>

Khi gặp trường hợp như hình \@ref(fig:fgoutlier03), có khả năng đồ uống có tên Collagen là giá trị ngoại lai. Chúng ta chưa thể khẳng định bởi vì nếu siêu thị thực sự có bán loại đồ uống này và việc sản phẩm không được khách hàng ưa chuộng, thì sản phẩm xuất hiện với tần xuất thấp là bình thướng. Tuy nhiên cũng có thể tên sản phẩm xuất hiện trong danh sách bán hàng dù siêu thị bán cũng có thể là do lỗi gặp phải trong quản lý hệ thống bán hàng, hoặc do người bán hàng đã ghi nhận tên Collagen cho một đồ uống khác.

Đối với véc-tơ kiểu số, các giá trị có khả năng là ngoại lai thường là các giá trị nằm ở đuôi của phân phối xác suất. Các giá trị nằm ở đuôi là các giá trị nằm cách xa các giá trị trung bình về phía bên phải hoặc bên trái của giá trị trung bình. Để biết một véc-tơ kiểu số có giá trị ngoại lai hay không, bạn đọc nên sử dụng đồ thị boxplot. Các điểm nằm phía dưới điểm nhỏ nhất ($Q_0$) và nằm phía trên điểm lớn nhất ($Q_4$) của đồ thị boxplot có nhiều khả năng là các giá trị ngoại lai. Điểm nhỏ nhất và điểm lớn nhất của đồ thị boxplot được xác định dựa trên mức tứ phân vị thứ nhất ($Q_1$) và mức tứ phân vị thứ ba ($Q_3$):
\begin{align}
&\text{Inter Quartile Range (IQR)} = Q_3 - Q_1 \\
&\text{Điểm nhỏ nhất } (Q_0) = Q_1 - 1.5 \times IQR \\
&\text{Điểm lớn nhất } (Q_4) = Q_3 + 1.5 \times IQR
\end{align}

Các giá trị nằm ngoài khoảng $(Q_1 - 1,5 \times IQR, Q_3 + 1.5 \times IQR)$ có nhiều khả năng là giá trị ngoại lai. Giá trị càng thấp hơn $Q_0$ và càng cao hơn $Q_4$ thì khả năng là giá trị ngoại lai lại càng cao. Ví dụ dưới đây mô tả việc sử dụng đồ thị boxplot để phát hiện giá trị ngoại lai trong một dữ liệu thực tế. Hình \@ref(fig:fgoutlier04) mô tả phân phối xác suất của véc-tơ chứa khối lượng giao dịch, tính bằng triệu cổ phiếu/ngày, của cổ phiếu tập đoàn FLC. Cổ phiếu được niêm yết trên sàn giao dịch chứng khoán Thành phố Hồ Chí Minh từ ngày 6 tháng 10 năm 2011 đến ngày 8 tháng 9 năm 2022. Dữ liệu có 2719 quan sát.

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier04-1.png" alt="Sử dụng đồ thị boxplot để mô tả lịch sử khối lượng giao dịch cổ phiếu FLC. Các giá trị có khả năng là giá trị ngoại lai nằm trên điểm Q4 của phân phối xác suất." width="672" />
<p class="caption">(\#fig:fgoutlier04)Sử dụng đồ thị boxplot để mô tả lịch sử khối lượng giao dịch cổ phiếu FLC. Các giá trị có khả năng là giá trị ngoại lai nằm trên điểm Q4 của phân phối xác suất.</p>
</div>

Chúng ta có thể thấy trên đồ thị boxplot không có điểm nằm dưới $Q_0$. Có 8 quan sát có giá trị lớn hơn $Q_4$; các giá trị này có khả năng là các giá trị ngoại lai. Có 3 quan sát với giá trị lớn hơn 100 triệu, nghĩa là có ba ngày mà có hơn 100 triệu cổ phiếu FLC được giao dịch. Nếu có một chút kinh nghiệm về giao dịch thị trường chứng khoán Việt Nam, bạn đọc có thể kiểm chứng được đây là số lượng cổ phiếu giao dịch lớn bất thường.

Ba phiên giao dịch có khối lượng giao dịch lớn hơn 100 triệu cổ phiếu là các phiên giao dịch ngày 10 tháng 1 năm 2022, ngày 11 tháng 1 năm 2022 và phiên giao dịch ngày 1 tháng 4 năm 2022. Thực tế cho thấy đây là ba phiên giao dịch mà cổ phiếu FLC đã bị thao túng giá và dẫn đến việc cố phiếu FLC bị cấm giao dịch trên sàn giao dịch HOSE kể từ tháng 09 năm 2022.

- Từ khoảng tháng 10 năm 2021 giá cổ phiếu FCL bắt đầu tăng nhanh. Đến đầu tháng 01 năm 2022, giá cổ phiếu đã tăng lên gấp 2 lần. Ngày 10 và ngày 11 tháng 01 năm 2022, các cổ đông chính của FLC bán ra khối lượng rất lớn các cổ phiếu mà không đăng ký với Ủy ban chứng khoán theo quy định. Sau hai phiên giao dịch này giá cổ phiếu FLC giảm mạnh về đến mức trước đó vài tháng.

- Ngày 31 tháng 03 năm 2022 các thông tin giả mạo về nhu cầu mua cổ phiếu FLC với khối lượng lớn được đưa ra sau nhiều ngày giá cổ phiếu FLC giảm hết biên độ làm cho nhu cầu mua FLC trong ngày 01 tháng 04 năm 2022 cao đột biến.

Việc thao túng giá và đưa thông tin giả mạo khiến cho số lượng cố phiếu FLC tăng lên đột biến đã bị các cơ quan chức năng phát hiện và đưa ra lệnh cấm giao dịch với cổ phiếu này. Đây là ví dụ điển hình về dữ liệu có giá trị ngoại lai có nguyên nhân chủ quan từ con người. 

Ngoài đồ thị boxplot, bạn đọc có thể sử dụng các đồ thị mô tả phân phối của biến liên tục như đồ thị histogram hay đồ thị density để xác định giá trị ngoại lai trong véc-tơ kiểu số. Ví dụ, Hình \@ref(fig:fgoutlier05) mô tả phân phối của chiều cao của 245 nam giới là nhân viên của một công ty. Đơn vị đo chiều cao là cm.

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier05-1.png" alt="Kết hợp boxplot và histogram để xác định giá trị ngoại lai trong dữ liệu. Hình bên trái: đồ thị boxplot cho có điểm nằm phía dưới điểm Q0. Hình bên phải: đồ thị histogram cho thấy có giá trị bất thường nằm ở đuôi bên trái" width="672" />
<p class="caption">(\#fig:fgoutlier05)Kết hợp boxplot và histogram để xác định giá trị ngoại lai trong dữ liệu. Hình bên trái: đồ thị boxplot cho có điểm nằm phía dưới điểm Q0. Hình bên phải: đồ thị histogram cho thấy có giá trị bất thường nằm ở đuôi bên trái</p>
</div>

Cả hai đồ thị boxplot và histogram trong Hình \@ref(fig:fgoutlier05) đều cho thấy trong dữ liệu có các giá trị chiều cao của nam giới xấp xỉ giá trị 0 và nhiều khả năng đây là các giá trị ngoại lai. Đồ thị histogram còn cho thấy có nhiều hơn 1 giá trị có giá trị như vậy. Lọc các giá trị đó ra khỏi véc-tơ chúng ta sẽ thu được 5 giá trị là 1,52; 1,74; 1,70; 1,62; và 1,80. Đây không thể là chiều cao của nam giới đo bằng đơn vị cm. Có nhiều khả năng là khi ghi lại chiều cao của các nhân viên này, người nhập dữ liệu đã sử dụng đơn vị là mét thay vì cm. Chúng ta có thể sửa các giá trị ngoại lai này bằng cách đổi từ đơn vị mét sang cm. Phân phối của chiều cao sau khi sửa lại dữ liệu được mô tả như hình dưới đây:

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier06-1.png" alt="Kết hợp boxplot và histogram để xác định giá trị ngoại lai trong dữ liệu. Hình bên trái: đồ thị boxplot sau khi điều chỉnh lại chiều cao từ đơn vị mét sang cm. Hình bên phải: đồ thị histogram sau khi điều chỉnh lại chiều cao từ đơn vị mét sang cm" width="672" />
<p class="caption">(\#fig:fgoutlier06)Kết hợp boxplot và histogram để xác định giá trị ngoại lai trong dữ liệu. Hình bên trái: đồ thị boxplot sau khi điều chỉnh lại chiều cao từ đơn vị mét sang cm. Hình bên phải: đồ thị histogram sau khi điều chỉnh lại chiều cao từ đơn vị mét sang cm</p>
</div>

Véc-tơ kiểu số là đơn vị đo lường hay đơn vị tiền tệ rất thường xuyên gặp vấn đề như kể trên. Ngay khi gặp giá trị ngoại lai trong véc-tơ kiểu số như trên bạn đọc hãy nghĩ đến sai đơn vị đo lường là nguyên nhân đầu tiên.

Ngoài việc sử dụng các tứ phân vị để phát hiện giá trị ngoại lai, một phương pháp định lượng khác cũng thường được đề cập đến trong nhiều tài liệu là sử dụng $Z-Score$. $Z-Score$ được tính bằng khoảng cách từ 1 điểm đến giá trị trung bình của dữ liệu sau đó chia cho độ lệch chuẩn của dữ liệu
\begin{align}
Z-Score(x_i) = \cfrac{|x_i - \bar{x}|}{\sigma(x)}
\end{align}
với $x_i$ là giá trị thứ $i$ trong véc-tơ $\textbf{x}$, $\bar{x}$ là giá trị trung bình của véc-tơ $\textbf{x}$, và $\sigma(x)$ là độ lệch chuẩn của các số trong véc-tơ $\textbf{x}$. $Z-Score$ dựa trên giả thiết là dữ liệu có phân phối chuẩn, do đó các điểm dữ liệu có $Z-Score$ lớn, thường sử dụng ngưỡng bằng 3, được coi là các giá trị ngoại lai. Chẳng hạn như khi vẽ $Z-Score$ của tất cả các điểm dữ liệu trong dữ liệu về chiều cao của nhân viên trong ví dụ được mô tả trong Hình \@ref(fig:fgoutlier05), chúng ta sẽ có giá trị $Z-Score$ của chiều cao của tất cả các nhân viên như trong Hình \@ref(fig:fgoutlier07)

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier07-1.png" alt="Giá trị Z-Score chiều cao của tất cả các nhân viên. Các quan sát có Z-Score lớn hơn 3 có nhiều khả năng là giá trị ngoại lai" width="672" />
<p class="caption">(\#fig:fgoutlier07)Giá trị Z-Score chiều cao của tất cả các nhân viên. Các quan sát có Z-Score lớn hơn 3 có nhiều khả năng là giá trị ngoại lai</p>
</div>

Các điểm có $Z-score$ lớn hơn 3 trong Hình \@ref(fig:fgoutlier07) là các điểm bị ghi nhận sai đơn vị đo lường từ $cm$ sang $mét$ và có $Z-Score$ lên đến hơn 6. Trong trường hợp này $Z-Score$ cũng là phương pháp định lượng hiệu quả để xác định giá trị ngoại lai. Tuy nhiên, $Z-Score$ có điểm bất lợi là giá trị này được tính toán dựa trên giá trị trung bình và độ lệch tiêu chuẩn của dữ liệu trong khi chính các giá trị đó lại bị tác động rất mạnh bởi các giá trị ngoại lai. Một cách đề giảm thiểu tác động của giá trị ngoại lai lên $Z-Score(x_i)$ là không tính đến $x_i$ khi tính toán trung bình $\bar{x}$ và $\sigma(x)$.

Đa số các phương pháp xác định giá trị ngoại lai ở trên đều dựa trên giả thiết là véc-tơ dữ liệu có phân phối chuẩn. Tuy nhiên, không phải lúc nào phân phối chuẩn cũng phù hợp với véc-tơ kiểu số. Dữ liệu về bồi thường bảo hiểm là một điển hình của dữ liệu không có phân phối chuẩn. Hình \@ref(fig:fgoutlier08) mô tả số liệu về tiền bồi thường bảo hiểm sức khỏe của hơn 1.000 khách hàng tại một công ty bảo hiểm:

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier08-1.png" alt="Phân phối xác suất của tiền bồi thường bảo hiểm y tế tại của hơn 1.000 khách hàng tại một công ty bảo hiểm. Hình bên trái: đồ thị histogram cho thấy phân phối của số tiền bồi thường không phải là phân phối chuẩn. Hình bên phải: có rất nhiều điểm có Z-Score lớn hơn ngưỡng 3" width="672" />
<p class="caption">(\#fig:fgoutlier08)Phân phối xác suất của tiền bồi thường bảo hiểm y tế tại của hơn 1.000 khách hàng tại một công ty bảo hiểm. Hình bên trái: đồ thị histogram cho thấy phân phối của số tiền bồi thường không phải là phân phối chuẩn. Hình bên phải: có rất nhiều điểm có Z-Score lớn hơn ngưỡng 3</p>
</div>

Nhiều điểm dữ liệu được xác định là ngoại lai mặc dù thực tế thì đây vẫn là các giá trị thông thường. Nguyên nhân là do phân phối của số tiền bảo hiểm y tế không phải là phân phối chuẩn. Trong trường hợp bạn đọc gặp dữ liệu không có phân phối chuẩn, hãy biến đổi dữ liệu về phân phối chuẩn hoặc gần phân phối chuẩn nhất có thể trước khi thực hiện tính $Z-Score$. Phép biến đổi thường được sử dụng nhất là biến đổi Box-Cox được trình bày trong Phụ lục \@ref(appenptdl02).

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier09-1.png" alt="Dữ liệu bồi thường bảo hiểm sau khi đã được biến đổi về gần với phân phối chuẩn. Hình bên trái: đồ thị histogram cho thấy phân phối của các điểm dữ liệu đã gần với phân phối chuẩn hơn so với dữ liệu ban đầu. Hình bên phải: các điểm có nhiều khả năng là giá trị ngoại lai là các giá trị có Z-score trên ngưỡng 3" width="672" />
<p class="caption">(\#fig:fgoutlier09)Dữ liệu bồi thường bảo hiểm sau khi đã được biến đổi về gần với phân phối chuẩn. Hình bên trái: đồ thị histogram cho thấy phân phối của các điểm dữ liệu đã gần với phân phối chuẩn hơn so với dữ liệu ban đầu. Hình bên phải: các điểm có nhiều khả năng là giá trị ngoại lai là các giá trị có Z-score trên ngưỡng 3</p>
</div>

Hình \@ref(fig:fgoutlier09) mô tả dữ liệu bồi thường bảo hiểm sau khi đã được biến đổi về phân phối chuẩn. Có thể thấy rằng sau phép biến đổi, các giá trị có Z-Score lớn hơn ngưỡng 3 đã giảm đi rất nhiều. Các điểm này nhiều khả năng là những khoản tiền bồi thường lớn bất thường và cần được kiểm tra lại. Ngoài biến đổi Box-Cox, một phương pháp khác để biến đổi véc-tơ về phân phối chuẩn là sử dụng hàm ngược của hàm phân phối chuẩn. Phương pháp này được trình bày trong Phụ lục \@ref(appenptdl03).

Trong thực tế nếu chỉ quan sát trên các cột dữ liệu riêng lẻ thì không thể xác định được giá trị ngoại lai. Giống như điểm B trong hình bên phải của Hình \@ref(fig:fgoutlier01), nếu chúng ta chỉ quan sát vị trí của điểm này trên trục X hoặc trục Y một cách riêng biệt thì không thể xác định được đây là giá trị ngoại lai. Điều này có nghĩa là một quan sát có thể không phải là ngoại lai nếu như chỉ quan sát trên từng cột dữ liệu, nhưng lại là giá trị ngoại lai khi quan sát đồng thời các thành phần của quan sát đó. Các kỹ thuật xác định giá trị ngoại lai trong không gian nhiều chiều sẽ được thảo luận trong phần tiếp theo.

#### Giá trị ngoại lai trong không gian nhiều chiều
Xác định giá trị ngoại lai trong không gian nhiều chiều phức tạp hơn trong không gian một chiều. Trong không gian một chiều, chúng ta cần xác định những số nào là giá trị ngoại lai của một véc-tơ. Trong khi trong không gian nhiều chiều, chúng ta cần phải xác định các quan sát nào là giá trị ngoại lai trong một dữ liệu. Ngoài việc xem xét giá trị trong từng cột dữ liệu, chúng ta cần phải xem xét cả mối liên hệ giữa các véc-tơ (cột) đó. 

Các phương pháp để xác định giá giá trị ngoại lai trong không gian nhiều chiều vẫn dựa trên nguyên tắc cơ bản áp dụng trong không gian một chiều, đó là các quan sát càng xa điểm trung tâm của dữ liệu thì quan sát đó càng có khả năng cao là giá trị ngoại lai. Khái niệm xa hay gần trong một không gian nhiều chiều luôn gắn liền với một khái niệm về khoảng cách. Khoảng cách thường được sử dụng nhiều nhất trong không gian nhiều chiều là khoảng cách Euclid. Tuy nhiên khoảng cách Euclid có nhược điểm là không tính đến mối liên hệ giữa các cột dữ liệu. Khoảng cách thường được sử dụng để xác định giá trị ngoại lai là khoảng cách Mahalanobis.

Cho $\textbf{x}_i = x_{i1}, x_{i2}, \cdots, x_{ip}$ là quan sát thứ $i$ và $\boldsymbol{\mu} = \mu_{1}, \mu_{2}, \cdots, \mu_{p}$ là véc-tơ các giá trị trung bình của các véc-tơ cột. Khoảng cách Euclid và khoảng cách Mahalanobis từ điểm $\textbf{x}_i$ đến $\boldsymbol{\mu}$ được định nghĩa như sau:
\begin{align}
D^{Euclid}(\textbf{x}_i,\boldsymbol{\mu}) & = \sqrt{(\textbf{x}_i - \boldsymbol{\mu})^T (\textbf{x}_i - \boldsymbol{\mu}} \\
D^{Mahalanobis}(\textbf{x}_i,\boldsymbol{\mu})& = \sqrt{(\textbf{x}_i - \boldsymbol{\mu})^T \ \Sigma^{-1} \  (\textbf{x}_i - \boldsymbol{\mu})} \\
\end{align}
trong đó $D^{Euclid}(\textbf{x}_i,\boldsymbol{\mu})$ và $D^{Mahalanobis}(\textbf{x}_i,\boldsymbol{\mu})$ lần lượt là khoảng cách Euclid và khoảng cách Mahalanobis từ quan sát $\textbf{x}_i$ đến điểm trung bình $\boldsymbol{\mu}$. Trong công thức tính khoảng cách Mahalanobis, $\Sigma^{-1}$ là ma trận nghịch đảo của ma trận hiệp phương sai của các biến trong dữ liệu. Có thể thấy rằng khoảng cách Euclid là trường hợp riêng của khoảng cách Mahalanobis khi các cột dữ liệu có phương sai bằng 1 và đôi một độc lập với nhau.

Bạn đọc có thể tự lập trình hàm số tính khoảng cách Euclid và hàm số tính khoảng cách Mahalanobis giữa 2 véc-tơ bất kỳ. Các hàm có tên là `Dis.Euc()` và hàm `Dis.Mah()` được định nghĩa như sau

```r
Dis.Euc<-function(x,y) sum((x-y)^2)^0.5
Dis.Mah<-function(x,y,Sigma) (t(x-y)%*% solve(Sigma) %*%(x-y))^0.5 
```

Chúng ta quay trở lại ví dụ về dữ liệu bao gồm 10 quan sát với hai giá trị ngoại lai là điểm A và điểm B trong Hình \@ref(fig:fgoutlier01). Chúng ta tính toán khoảng cách Euclid của mỗi điểm đến trung tâm của dữ liệu và sắp xếp các điểm theo thứ tự khoảng cách Euclid đến điểm trung tâm giảm dần. Kết quả được cho trong Bảng \@ref(tag:tbptdl010)

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl010)Điểm dữ liệu sắp xếp theo khoảng cách Euclid đến trung tâm giảm dần trong trường hợp có 10 điểm dữ liệu</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Điểm dữ liệu </th>
   <th style="text-align:right;"> Tọa độ x </th>
   <th style="text-align:right;"> Tọa độ y </th>
   <th style="text-align:right;"> Khoảng cách Euclid </th>
   <th style="text-align:right;"> Khoảng cách Mahalanobis </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Điểm A </td>
   <td style="text-align:right;"> 7.500 </td>
   <td style="text-align:right;"> 12.000 </td>
   <td style="text-align:right;"> 7.925 </td>
   <td style="text-align:right;"> 2.593 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm B </td>
   <td style="text-align:right;"> 10.000 </td>
   <td style="text-align:right;"> 6.000 </td>
   <td style="text-align:right;"> 5.046 </td>
   <td style="text-align:right;"> 1.747 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 1.046 </td>
   <td style="text-align:right;"> 5.069 </td>
   <td style="text-align:right;"> 4.216 </td>
   <td style="text-align:right;"> 1.647 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 1.916 </td>
   <td style="text-align:right;"> 4.193 </td>
   <td style="text-align:right;"> 3.302 </td>
   <td style="text-align:right;"> 1.225 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 7.101 </td>
   <td style="text-align:right;"> 2.411 </td>
   <td style="text-align:right;"> 2.753 </td>
   <td style="text-align:right;"> 1.128 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 6.693 </td>
   <td style="text-align:right;"> 2.403 </td>
   <td style="text-align:right;"> 2.497 </td>
   <td style="text-align:right;"> 1.012 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 2.973 </td>
   <td style="text-align:right;"> 3.773 </td>
   <td style="text-align:right;"> 2.327 </td>
   <td style="text-align:right;"> 0.815 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 4.388 </td>
   <td style="text-align:right;"> 2.662 </td>
   <td style="text-align:right;"> 1.935 </td>
   <td style="text-align:right;"> 0.615 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 5.357 </td>
   <td style="text-align:right;"> 2.560 </td>
   <td style="text-align:right;"> 1.858 </td>
   <td style="text-align:right;"> 0.671 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác </td>
   <td style="text-align:right;"> 5.129 </td>
   <td style="text-align:right;"> 3.055 </td>
   <td style="text-align:right;"> 1.360 </td>
   <td style="text-align:right;"> 0.473 </td>
  </tr>
</tbody>
</table>

Có thế thấy rằng khi chỉ có 10 quan sát, khoảng cách Euclid có thể sử dụng để phát hiện được giá trị ngoại lai là điểm A và điểm B vì hai điểm này có khoảng cách đến trung tâm xa hơn so với các điểm còn lại. Khoảng cách Mahalanobis cũng cho kết quả tương tự. Tuy nhiên khoảng cách Euclid sẽ gặp vấn đề khi số lượng quan sát nhiều hơn và mối liên hệ giữa $X$ và $Y$ rõ ràng hơn. Thật vậy, chúng ta thực hiện tính toán khoảng cách từ các điểm A, B và các điểm còn lại đến điểm trung tâm của dữ liệu trong trường hợp có 100 quat sát, sau đó sắp xếp các điểm theo thứ tự khoảng cách Euclid giảm dần giống như khi có 10 quan sát. 10 điểm có khoảng cách Euclid đến trung tâm lớn nhất được liệt kê trong Bảng \@ref(tab:tbptdl011).

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:tbptdl011)10 điểm dữ liệu có khoảng cách Euclid xa nhất trong trường hợp có 100 điểm</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Điểm dữ liệu </th>
   <th style="text-align:right;"> Tọa độ x </th>
   <th style="text-align:right;"> Tọa độ y </th>
   <th style="text-align:right;"> Khoảng cách Euclid </th>
   <th style="text-align:right;"> Khoảng cách Mahalanobis </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Điểm A (đỏ) </td>
   <td style="text-align:right;"> 7.500 </td>
   <td style="text-align:right;"> 12.000 </td>
   <td style="text-align:right;"> 9.501 </td>
   <td style="text-align:right;"> 8.010 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> -1.993 </td>
   <td style="text-align:right;"> 6.897 </td>
   <td style="text-align:right;"> 7.100 </td>
   <td style="text-align:right;"> 2.441 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> -2.448 </td>
   <td style="text-align:right;"> 5.970 </td>
   <td style="text-align:right;"> 7.072 </td>
   <td style="text-align:right;"> 2.430 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 10.216 </td>
   <td style="text-align:right;"> -0.163 </td>
   <td style="text-align:right;"> 7.011 </td>
   <td style="text-align:right;"> 2.377 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 9.862 </td>
   <td style="text-align:right;"> -0.211 </td>
   <td style="text-align:right;"> 6.725 </td>
   <td style="text-align:right;"> 2.290 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 10.061 </td>
   <td style="text-align:right;"> 0.291 </td>
   <td style="text-align:right;"> 6.667 </td>
   <td style="text-align:right;"> 2.269 </td>
  </tr>
  <tr>
   <td style="text-align:left;background-color: #FF8080 !important;"> Điểm B (cam) </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> 10.000 </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> 6.000 </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> 6.606 </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> 4.675 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 10.022 </td>
   <td style="text-align:right;"> 0.591 </td>
   <td style="text-align:right;"> 6.508 </td>
   <td style="text-align:right;"> 2.240 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 8.732 </td>
   <td style="text-align:right;"> 0.131 </td>
   <td style="text-align:right;"> 5.581 </td>
   <td style="text-align:right;"> 1.932 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> -0.787 </td>
   <td style="text-align:right;"> 5.044 </td>
   <td style="text-align:right;"> 5.183 </td>
   <td style="text-align:right;"> 1.810 </td>
  </tr>
</tbody>
</table>

Bạn đọc có thể thấy khoảng cách Euclid không cho kết quả tốt như khoảng cách Malahanobis trong trường hợp dữ liệu có 100 quan sát. Khi đo bằng khoảng cách Euclid, điểm A vẫn là điểm xa trung tâm dữ liệu nhất. Tuy nhiên khoảng cách từ điểm B đến trung tâm dữ liệu là nhỏ hơn một số điểm khác, mặc dù các điểm đó không phải là các giá trị ngoại lai. Ngược lại, khi tính bằng khoảng cách Mahalanobis, chúng ta có thể thấy rằng điểm A là điểm có khoảng cách xa nhất, sau đó đến điểm B với khoảng cách Malahanobis là 4.675. Các điểm khác đều có khoảng cách Mahalanobis nhỏ hơn 2,5. 

Các kỹ thuật phát hiện giá trị ngoại lai phức tạp hơn dựa trên nguyên lý phân nhóm và phân cụm sẽ được trình bày trong chương học máy không có giám sát. Nguyên tắc xác định một quan sát ngoại lai là phân chia dữ liệu thành các cụm sao cho các quan sát trong cùng một cụm có tính chất tương tự nhau. Các quan sát không nằm trong cụm nào, hoặc trong các cụm có rất ít quan sát, là các điểm dữ liệu có nhiều khả năng là giá trị ngoại lai.

### Xử lý giá trị ngoại lai.

Có nhiều phương pháp để xử lý giá trị ngoại lai trong dữ liệu. Tùy thuộc vào tình huống và dữ liệu cụ thể, phương pháp nào cũng có thể đúng hoặc sai. Điều quan trọng là bạn đọc phải phân tích các tình huống có thể liên quan đến giá trị ngoại lai. Đôi khi việc phân tích các giá trị ngoại lai này còn giúp bạn có những hiểu biết hơn về dữ liệu và tối ưu công việc phân tích của bạn.

- Phương pháp đơn giản nhất và nhưng kém hiệu quả nhất là loại bỏ các quan sát, hoặc biến có chứa giá trị ngoại lai. Phương pháp này chỉ có ý nghĩa khi bạn có số lượng quan sát đủ lớn và các giá trị bị coi là ngoại lai không có có ý nghĩa trong xác định phân phối xác suất của từng biến.

- Phương pháp thứ hai là thay thế giá trị ngoại lai bằng một giá trị khác: bạn đọc có thể thay thế giá trị ngoại lai bằng giá trị có ý nghĩa hơn như giá trị $Q_0$ hoặc $Q_4$ của phân phối xác suất, hoặc cũng có thể thay thế giá trị ngoại lai bằng giá trị trung bình, trung vị, hoặc mode của phân phối. Đây là phương pháp đơn giản, dễ sử dụng và thường cho hiệu quả tốt hơn so với phương pháp xóa quan sát.

- Phương pháp sau cùng và cũng là phương pháp đòi hỏi kỹ thuật phức tạp nhất đó là coi giá trị ngoại lai như một giá trị không quan sát được, sau đó xây dựng mô hình để dự đoán cho giá trị ngoại lai. Các phương pháp thay thế giá trị ngoại lai bằng giá trị dự đoán dựa trên các mô hình tương tự như các phương pháp xử lý dữ liệu không quan sát được. Bạn đọc có thể tham khảo phần \@ref(replaceNAbymodel) của cuốn sách.

## Phụ lục

### Kiểm định sự độc lập của hai biến {#appenptdl01}

#### Pearson's Chi-squared tests

### Box-Cox transformation {#appenptdl02}
Biến đổi Box-Cox là một phương pháp biến đổi để đưa một véc-tơ có phân phối khác với phân phối chuẩn thành một véc-tơ có phân phối gần với phân phối chuẩn. Phép biến đổi Box-Cox chỉ có duy nhất một tham số $\lambda$.
\begin{align}
x(\lambda) = \begin{cases}
\cfrac{y^\lambda-1}{\lambda} \text{ nếu } \lambda \neq 0 \\
log(y) \text{ nếu } \lambda = 0
\end{cases}
\end{align}

giá trị $\lambda$ thường được lựa chọn trong khoảng (-5,5) sao cho khoảng cách giữa dữ liệu sau khi biến đổi đến phân phối chuẩn là nhỏ nhất. Khoảng cách giữa hai phân phối được đo bằng khoảng cách Kolmogorov-Smirnov. Hình 

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier11-1.png" alt="Lựa chọn tham số để thực hiện biến đổi Box-Cox. Giá trị tham số lambda tối thiểu hóa khoảng cách của phân phối của dữ liệu đến phân phối chuẩn được lựa chọn" width="672" />
<p class="caption">(\#fig:fgoutlier11)Lựa chọn tham số để thực hiện biến đổi Box-Cox. Giá trị tham số lambda tối thiểu hóa khoảng cách của phân phối của dữ liệu đến phân phối chuẩn được lựa chọn</p>
</div>

Tham số $\lambda$ tối thiểu hóa khoảng cách từ phân phối của dữ liệu đến phân phối chuẩn là 0.21, chúng ta có phân phối của dữ liệu sau khi biến đổi trong Hình \@ref(fig:fgoutlier12)

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier12-1.png" alt="Biến đổi số tiền bồi thường thành phân phối chuẩn bằng cách sử dụng biến đổi Box-Cox với tham số 0.21" width="672" />
<p class="caption">(\#fig:fgoutlier12)Biến đổi số tiền bồi thường thành phân phối chuẩn bằng cách sử dụng biến đổi Box-Cox với tham số 0.21</p>
</div>

### Phương pháp chuẩn hóa véc-tơ bằng hàm ngược
Phương pháp biến đổi này dựa trên hai kết quả cơ bản như sau:

1. Nếu $X$ là một biến ngẫu nhiên liên tục có hàm phân phối $F$ thì biến ngẫu nhiên $F(X)$ sẽ có phân phối $\textit{Uniform(0,1)}$

2. Nếu $U$ là một biến ngẫu nhiên phân phối $\textit{Uniform(0,1)}$ thì biến ngẫu nhiên $\Phi^{-1}(U)$ sẽ có phân phối chuẩn với trung bình bằng 0 và phương sai bằng 1, trong đó $\Phi^{-1}$ là hàm ngược của hàm phân phối của biến ngẫu nhiên phân phối chuẩn với trung bình bằng 0 và phương sai bằng 1.

Cả hai kết quả này đều có thể được chứng minh bằng kiến thức xác suất cơ bản. Thứ nhất, $F(X)$ có phân phối $\textit{Uniform(0,1)}$ vì $F(X)$ nhận giá trị trên $[0,1]$, đồng thời
\begin{align}
\mathbb{P}\left(F(X) < x\right) &= \mathbb{P}\left(X < F^{-1}(x)\right) \\
& = F(F^{-1}(x)) \\
& = x
\end{align}
là hàm phân phối xác suất của biến ngẫu nhiên $\textit{Uniform(0,1)}$

Thứ hai, biến ngẫu nhiên $\Phi^{-1}(U)$ có phân phối chuẩn với trung bình bằng 0 và phương sai bằng 1 vì
\begin{align}
\mathbb{P}\left(\Phi^{-1}(U) < x\right) & = \mathbb{P}\left(U < \Phi(x)\right) \\
& = \Phi(x)
\end{align}

Như vậy, biến ngẫu nhiên $X$ bất kỳ có thể được biến đổi thành biến ngẫu nhiên phân phối chuẩn với trung bình bằng 0 và phương sai bằng 1 bằng phép biến đổi $N = \Phi^{-1}(F(X))$ với $F$ là hàm phân phối của $X$.

Khó khăn lớn nhất trong phép biến đổi này là tìm ra phân phối $F$ của biến ngẫu nhiên $X$ vì chúng ta chỉ có một véc-tơ quan sát được của $X$. Việc này đòi hỏi các kiến thức liên quan đến thống kê toán. 

Quay trở lại với ví dụ về dữ liệu về số tiền bồi thường bảo hiểm trong hình \@ref(fig:fgoutlier08), chúng ta có thể sử dụng phân phối $Pareto(\alpha,\beta)$ cho số tiền bảo hiểm. Các tham số của phân phối $Pareto$ ước lượng cho dữ liệu là $\alpha = 2.17$, và $\beta = 3.34$. Chúng ta biến đổi số tiền bồi thường thành phân phối chuẩn như sau:
\begin{align}
& N = \Phi^{-1}(F(X))
\end{align}
với $F(x)$ được xác định bởi
\begin{align}
F(x) = 1 - \left(\cfrac{\beta}{x+\beta} \right)^\alpha
\end{align}

Hình \@ref(fig:fgoutlier10) mô tả dữ liệu trước và sau khi biến đổi

<div class="figure">
<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/fgoutlier10-1.png" alt="Biến đổi số tiền bồi thường có phân phối Pareto thành phân phối chuẩn bằng cách sử dụng hàm ngược" width="672" />
<p class="caption">(\#fig:fgoutlier10)Biến đổi số tiền bồi thường có phân phối Pareto thành phân phối chuẩn bằng cách sử dụng hàm ngược</p>
</div>

Có thể thấy dữ liệu sau khi biến đổi đã gần với phân phối chuẩn hơn so với dữ liệu gốc.

## Bài tập

# Biến đổi và sắp xếp dữ liệu 

## Biến đổi dữ liệu bằng thư viện $\textbf{dplyr}$
Dữ liệu trước khi đưa vào thực hiện các phân tích, thực hiện trực quan hóa, hoặc xây dựng mô hình, thường không có được định dạng đúng như chúng ta mong muốn. Thông thường, chúng ta sẽ cần tạo thêm một số biến, hoặc có thể chỉ muốn đổi tên các biến, hoặc sắp xếp lại các quan sát, hoặc tổng hợp và nhóm dữ liệu vào các nhóm để dễ dàng hơn cho các bước tiếp theo. Các bước biến đổi dữ liệu như vậy sẽ được trình bày chi tiết trong phần này. Đa số các hàm thực hiện các phép biến đổi dữ liệu được lấy từ thư viện $\textbf{dplyr}$. Dữ liệu để minh họa trực tiếp cho các phép biến đổi là tập dữ liệu $\textbf{gapminder}$ của thư viện $\textbf{dslabs}$, dữ liệu về sức khỏe và thu nhập của các quốc gia trên thế giới từ năm 1960 đến năm 2016. Chúng tôi lựa chọn dữ liệu này vì đây là dữ liệu dễ hiểu và có nhiều ý tưởng để phân tích.

Thư viện $\textbf{dplyr}$ là một thư viện nằm trong thư viện tổng hợp $\textbf{tidyverse}$, bạn đọc có thể gọi thư viện $\textbf{dplyr}$ hoặc trực tiếp thư viện $\textbf{dplyr}$ lên cửa sổ làm việc. Bạn đọc cũng cần lưu ý rằng trong thư viện $\textbf{dplyr}$ có một số hàm trùng tên với các hàm có sẵn trong R, chẳng hạn như hàm `filter()`, hàm `select()`, hoặc hàm `lag()`. Bạn đọc cần lưu ý thứ tự ưu tiên của các thư viện khi sử dụng các hàm kể trên, hoặc gọi tên thư viện đính kèm với tên hàm để tránh gặp lỗi khi thực thi các câu lệnh.

Dữ liệu $\textbf{gapminder}$ là đã được đề cập trong phần tiền xử lý dữ liệu. Bạn đọc nên tham khảo mô tả dữ liệu này trước khi đi đến các phần tiếp theo của cuốn sách. Trong các phần tiếp theo, chúng tôi sẽ lần lượt giới thiệu các hàm quan trọng để thực hiện các phép biến đổi dữ liệu từ thư viện $\textbf{dplyr}$ và các tham số quan trọng của hàm số đó. Chúng tôi cũng sẽ giới thiệu với bạn đọc về cách kết hợp các hàm với nhau thành một câu lệnh duy nhất viết câu lệnh bằng cách sử dụng toán tử pipe (`%>%`).

### Thêm biến bằng hàm `mutate()`
Khi bạn đọc muốn thêm các cột khác vào một dữ liệu được tính toán từ các cột hiện có, bạn có thể sử dụng hàm `mutate()`. Hàm `mutate()` luôn thêm cột vào sau cột cuối cùng trong dữ liệu hiện có. Khi bạn muốn thêm cột vào một vị trí cụ thể, bạn có thể sử dụng các tham số sau:

- Tham số `.after` sử dụng để gán giá trị cho tên biến (cột) phía trước cột mà bạn đọc muốn thêm vào.

- Tham số `.before` sử dụng để gán giá trị cho tên biến (cột) phía sau cột mà bạn đọc muốn thêm vào.

Cách sử dụng `mutate()` như sau: 

```r
mytib<-as.tibble(gapminder) # mytib là dữ liệu kiểu tibble
mutate(mytib, gdp_per_capita = gdp/population) # thêm cột có tên là gdp_per_capita
```

```
## # A tibble: 10,545 × 10
##    country   year infant_mortality life_expectancy fertility population      gdp
##    <fct>    <int>            <dbl>           <dbl>     <dbl>      <dbl>    <dbl>
##  1 Albania   1960            115.             62.9      6.19    1636054 NA      
##  2 Algeria   1960            148.             47.5      7.65   11124892  1.38e10
##  3 Angola    1960            208              36.0      7.32    5270844 NA      
##  4 Antigua…  1960             NA              63.0      4.43      54681 NA      
##  5 Argenti…  1960             59.9            65.4      3.11   20619075  1.08e11
##  6 Armenia   1960             NA              66.9      4.55    1867396 NA      
##  7 Aruba     1960             NA              65.7      4.82      54208 NA      
##  8 Austral…  1960             20.3            70.9      3.45   10292328  9.67e10
##  9 Austria   1960             37.3            68.8      2.7     7065525  5.24e10
## 10 Azerbai…  1960             NA              61.3      5.57    3897889 NA      
## # ℹ 10,535 more rows
## # ℹ 3 more variables: continent <fct>, region <fct>, gdp_per_capita <dbl>
```

Câu lệnh trên có ý nghĩa là thêm cột có tên là $gdp\_per\_capita$, được tính bằng tổng thu nhập quốc dân ($gdp$) chia cho dân số ($population$) của quốc gia trong năm tương ứng. Nếu bạn đọc muốn cột mới được thêm vào ngay sau cột $gdp$, hãy sử dụng thêm tham số `.after` như sau:

```r
mutate(mytib, gdp_per_capita = gdp/population, .after = gdp)
```

```
## # A tibble: 10,545 × 10
##    country   year infant_mortality life_expectancy fertility population      gdp
##    <fct>    <int>            <dbl>           <dbl>     <dbl>      <dbl>    <dbl>
##  1 Albania   1960            115.             62.9      6.19    1636054 NA      
##  2 Algeria   1960            148.             47.5      7.65   11124892  1.38e10
##  3 Angola    1960            208              36.0      7.32    5270844 NA      
##  4 Antigua…  1960             NA              63.0      4.43      54681 NA      
##  5 Argenti…  1960             59.9            65.4      3.11   20619075  1.08e11
##  6 Armenia   1960             NA              66.9      4.55    1867396 NA      
##  7 Aruba     1960             NA              65.7      4.82      54208 NA      
##  8 Austral…  1960             20.3            70.9      3.45   10292328  9.67e10
##  9 Austria   1960             37.3            68.8      2.7     7065525  5.24e10
## 10 Azerbai…  1960             NA              61.3      5.57    3897889 NA      
## # ℹ 10,535 more rows
## # ℹ 3 more variables: gdp_per_capita <dbl>, continent <fct>, region <fct>
```

và để thêm cột thu nhập bình quân đầu người vào phía trước cột $gdp$, chúng ta sử dụng tham số `.before`

```r
mutate(mytib, gdp_per_capita = gdp/population, .before = gdp)
```

```
## # A tibble: 10,545 × 10
##    country            year infant_mortality life_expectancy fertility population
##    <fct>             <int>            <dbl>           <dbl>     <dbl>      <dbl>
##  1 Albania            1960            115.             62.9      6.19    1636054
##  2 Algeria            1960            148.             47.5      7.65   11124892
##  3 Angola             1960            208              36.0      7.32    5270844
##  4 Antigua and Barb…  1960             NA              63.0      4.43      54681
##  5 Argentina          1960             59.9            65.4      3.11   20619075
##  6 Armenia            1960             NA              66.9      4.55    1867396
##  7 Aruba              1960             NA              65.7      4.82      54208
##  8 Australia          1960             20.3            70.9      3.45   10292328
##  9 Austria            1960             37.3            68.8      2.7     7065525
## 10 Azerbaijan         1960             NA              61.3      5.57    3897889
## # ℹ 10,535 more rows
## # ℹ 4 more variables: gdp_per_capita <dbl>, gdp <dbl>, continent <fct>,
## #   region <fct>
```

Hàm số được sử dụng tương tự như hàm `mutate()` là hàm $transmute()$. Hàm $transmute()$ khác $mutate()$ ở chỗ là trong dữ liệu mới được tạo thành chỉ có các cột mới được tạo thành. Ví dụ,

```r
transmute(mytib, gdp_per_capita = gdp/population)
```

```
## # A tibble: 10,545 × 1
##    gdp_per_capita
##             <dbl>
##  1            NA 
##  2          1243.
##  3            NA 
##  4            NA 
##  5          5254.
##  6            NA 
##  7            NA 
##  8          9393.
##  9          7415.
## 10            NA 
## # ℹ 10,535 more rows
```

Chúng ta có thể thấy rằng trong dữ liệu mới được tạo thành, chỉ có một cột duy nhất là cột thu nhập bình quân đầu người ($gdp\_per\_capita$).

### Lựa chọn biến bằng hàm `select()`
Khi dữ liệu có quá nhiều cột và chúng ta chỉ muốn sử dụng một số cột nhất định để phân tích, bạn đọc có thể sử dụng hàm `select()` để lựa chọn các cột mà chúng ta sẽ sử dụng trong các bước tiếp theo. Điều quan trọng khi sử dụng hàm `select()` là bạn đọc cần gọi tên đúng các biến mà chúng ta muốn lựa chọn. Hàm `select()` được sử dụng như sau:

```r
select(mytib, year, gdp, population) # lựa chọn các cột year, gdp, population
```

```
## # A tibble: 10,545 × 3
##     year          gdp population
##    <int>        <dbl>      <dbl>
##  1  1960           NA    1636054
##  2  1960  13828152297   11124892
##  3  1960           NA    5270844
##  4  1960           NA      54681
##  5  1960 108322326649   20619075
##  6  1960           NA    1867396
##  7  1960           NA      54208
##  8  1960  96677859364   10292328
##  9  1960  52392699681    7065525
## 10  1960           NA    3897889
## # ℹ 10,535 more rows
```

Hàm `select()` cũng có thể được sử dụng để lựa chọn cột và thay đổi tên cột. Ví dụ, khi bạn đọc muốn tên các biến mới tương ứng với các biến $year$, $gdp$, và $population$ thành $Year$, $Gdp$ và $Population$, chúng ta viết câu lệnh với hàm `select()` như sau:

```r
select(mytib, Year = year, Gdp =  gdp,  Population = population)
```

```
## # A tibble: 10,545 × 3
##     Year          Gdp Population
##    <int>        <dbl>      <dbl>
##  1  1960           NA    1636054
##  2  1960  13828152297   11124892
##  3  1960           NA    5270844
##  4  1960           NA      54681
##  5  1960 108322326649   20619075
##  6  1960           NA    1867396
##  7  1960           NA      54208
##  8  1960  96677859364   10292328
##  9  1960  52392699681    7065525
## 10  1960           NA    3897889
## # ℹ 10,535 more rows
```

Khi dữ liệu có quá nhiều cột và việc gọi tên chính xác tất cả các cột làm cho câu lệnh `select()` quá phức tạp, bạn đọc có thể sử dụng `select()` để lựa chọn ra các cột đứng liền nhau bằng cách sử dụng dấu `:`,

```r
select(mytib, year, gdp:population)
```

```
## # A tibble: 10,545 × 3
##     year          gdp population
##    <int>        <dbl>      <dbl>
##  1  1960           NA    1636054
##  2  1960  13828152297   11124892
##  3  1960           NA    5270844
##  4  1960           NA      54681
##  5  1960 108322326649   20619075
##  6  1960           NA    1867396
##  7  1960           NA      54208
##  8  1960  96677859364   10292328
##  9  1960  52392699681    7065525
## 10  1960           NA    3897889
## # ℹ 10,535 more rows
```
Câu lệnh trên có ý nghĩa là lấy ra biến $year$ và tất cả các biến nằm giữa biến $gdp$ và biến $population$.

Hàm `select()` còn cho phép bạn đọc lấy ra các cột mà chúng ta không nhớ chính xác tên bằng cách sử dụng các tham số dưới đây:

- Tham số `starts_with()` được sử dụng để lựa chọn các cột có tên bắt đầu bằng một chuỗi ký tự nào đó. Ví dụ như khi chúng ta không nhớ chính xác tên của biến mô tả tỷ lệ tử vong của trẻ sơ sinh trong dữ liệu $\textbf{gapminder}$, chúng ta chỉ chắc chắn rằng tên cột bắt đầu bằng `"infant"`, chúng ta lựa chọn biến này như sau:

```r
select(mytib, starts_with("infant"))
```

```
## # A tibble: 10,545 × 1
##    infant_mortality
##               <dbl>
##  1            115. 
##  2            148. 
##  3            208  
##  4             NA  
##  5             59.9
##  6             NA  
##  7             NA  
##  8             20.3
##  9             37.3
## 10             NA  
## # ℹ 10,535 more rows
```

- Tương tự như `starts_with()`, các tham số `ends_with()` và `contains()` được sử dụng để lựa chọn các cột kết thúc bởi một chuỗi ký tự và chứa một chuỗi ký tự nào đó. 

- Tham số  `matches()` có thể được sử dụng trong trường hợp tổng quát hơn `contains()` các cột được lựa chọn có tên được biểu diễn qua các biểu thức chính quy.


```r
mytib1<-mutate(mytib, gdp_per_capita = gdp/population)
select(mytib1, contains("gdp")) # Lấy các cột có tên chứa "gdp"
```

```
## # A tibble: 10,545 × 2
##             gdp gdp_per_capita
##           <dbl>          <dbl>
##  1           NA            NA 
##  2  13828152297          1243.
##  3           NA            NA 
##  4           NA            NA 
##  5 108322326649          5254.
##  6           NA            NA 
##  7           NA            NA 
##  8  96677859364          9393.
##  9  52392699681          7415.
## 10           NA            NA 
## # ℹ 10,535 more rows
```

Khi số lượng cột được lựa chọn nhiều hơn số cột không được lựa chọn, hoặc khi bạn đọc muốn loại một số cột không sử dụng ra khỏi dữ liệu, hàm `select()` cũng cho phép chúng ta thực thi yêu cầu bằng cách thêm dấu `-` vào tên các cột mà chúng ta muốn loại ra khỏi dữ liệu. Hãy quan sát ví dụ dưới đây:

```r
select(mytib1, - starts_with("gdp"))
```

```
## # A tibble: 10,545 × 8
##    country  year infant_mortality life_expectancy fertility population continent
##    <fct>   <int>            <dbl>           <dbl>     <dbl>      <dbl> <fct>    
##  1 Albania  1960            115.             62.9      6.19    1636054 Europe   
##  2 Algeria  1960            148.             47.5      7.65   11124892 Africa   
##  3 Angola   1960            208              36.0      7.32    5270844 Africa   
##  4 Antigu…  1960             NA              63.0      4.43      54681 Americas 
##  5 Argent…  1960             59.9            65.4      3.11   20619075 Americas 
##  6 Armenia  1960             NA              66.9      4.55    1867396 Asia     
##  7 Aruba    1960             NA              65.7      4.82      54208 Americas 
##  8 Austra…  1960             20.3            70.9      3.45   10292328 Oceania  
##  9 Austria  1960             37.3            68.8      2.7     7065525 Europe   
## 10 Azerba…  1960             NA              61.3      5.57    3897889 Asia     
## # ℹ 10,535 more rows
## # ℹ 1 more variable: region <fct>
```
Hàm `select()` ỏ trên có ý nghĩa là loại đi ra khỏi dữ liệu tất cả các biến có tên bắt đầu bằng "gdp"

##$ Lọc dữ liệu bằng hàm `filter()`

Hàm `filter()` cho phép chúng ta lọc các quan sát dựa trên giá trị của các cột. Do có một số thư viện trong R sử dụng hàm `filter()` với mục đích khác nhau và chúng ta có thể không chắc chắn về thứ tự ưu tiên của các thư viện đang sẵn sàng trên môi trường làm việc hiện tại nên tốt nhất là chúng ta định nghĩa lại tên hàm `filter()` cho hàm có tên tương ứng của thư viện $\textbf{dplyr}$

```r
filter<-function(...) dplyr::filter(...)
```

Cách hoạt động của hàm $filter()$ như sau: ví dụ chúng ta muốn lấy ra dữ liệu của riêng năm 2010 trong dữ liệu $\textbf{gapminder}$, hàm `filter()` được viết như sau như sau

```r
filter(mytib, year == 2010) # chỉ lấy các quan sát có year là 2010
```

```
## # A tibble: 185 × 9
##    country   year infant_mortality life_expectancy fertility population      gdp
##    <fct>    <int>            <dbl>           <dbl>     <dbl>      <dbl>    <dbl>
##  1 Albania   2010             14.8            77.2      1.74    2901883  6.14e 9
##  2 Algeria   2010             23.5            76        2.82   36036159  7.92e10
##  3 Angola    2010            110.             57.6      6.22   21219954  2.61e10
##  4 Antigua…  2010              7.7            75.8      2.13      87233  8.37e 8
##  5 Argenti…  2010             13              75.8      2.22   41222875  4.34e11
##  6 Armenia   2010             16.1            73        1.55    2963496  4.10e 9
##  7 Aruba     2010             NA              75.1      1.7      101597 NA      
##  8 Austral…  2010              4.1            82        1.89   22162863  5.63e11
##  9 Austria   2010              3.6            80.5      1.44    8391986  2.24e11
## 10 Azerbai…  2010             33.9            70.1      1.97    9099893  2.12e10
## # ℹ 175 more rows
## # ℹ 2 more variables: continent <fct>, region <fct>
```

Sau khi thực thi câu lệnh ở trên, một tibble mới được tạo thành chỉ bao gồm các quan sát có giá trị cột $year$ là `2010`. Lưu ý rằng nếu chúng ta muốn lưu lại giá trị sau mỗi lần thực hiện biến đổi dữ liệu, hãy gán giá trị kết quả của các hàm trong thư viện $\textbf{dplyr}$ vào một đối tượng. Hàm `filter()` có thể thực hiện việc lọc dữ liệu trên nhiều cột cùng một lúc. Ví dụ như chúng ta muốn lọc ra các quan sát của năm 2010 của các quốc gia thuộc lục địa Châu Âu, chúng ta sử dụng hai phép so sánh trong hàm `filter()`

```r
filter(mytib, year == 2010, continent == "Europe") 
```

```
## # A tibble: 39 × 9
##    country    year infant_mortality life_expectancy fertility population     gdp
##    <fct>     <int>            <dbl>           <dbl>     <dbl>      <dbl>   <dbl>
##  1 Albania    2010             14.8            77.2      1.74    2901883 6.14e 9
##  2 Austria    2010              3.6            80.5      1.44    8391986 2.24e11
##  3 Belarus    2010              4.7            70.2      1.46    9492122 2.60e10
##  4 Belgium    2010              3.6            80.1      1.84   10929978 2.67e11
##  5 Bosnia a…  2010              6.4            77.9      1.24    3835258 8.21e 9
##  6 Bulgaria   2010             11.2            73.7      1.49    7407297 1.92e10
##  7 Croatia    2010              4.6            76.7      1.47    4316425 2.80e10
##  8 Czech Re…  2010              3.4            77.5      1.5    10506617 8.21e10
##  9 Denmark    2010              3.3            79.4      1.88    5550959 1.69e11
## 10 Estonia    2010              3.6            76.4      1.63    1332089 8.01e 9
## # ℹ 29 more rows
## # ℹ 2 more variables: continent <fct>, region <fct>
```

### Sắp xếp dữ liệu bằng hàm `arrange()`
Hàm `arrange()` sắp xếp các quan sát của dữ liệu theo thứ tự tăng dần. Nguyên tắc sắp xếp cũng tương tự như quy tắc sắp xếp của hàm `sort()` khi làm trên véc-tơ, nghĩa là hàm bạn đọc có thể sắp xếp dữ liệu dựa theo kiểu số, kiểu logic, kiểu thời gian, hay kiểu chuỗi ký tự. Lưu ý rằng khi véc-tơ kiểu chuỗi ký tự được định nghĩa dưới dạng factor thì thứ tự tăng dần sẽ được hiểu theo cách đánh số thứ tự của factor bắt đầu từ 1. 

Chúng ta sắp xếp dữ liệu $\textbf{gapmider}$ theo thứ tự tăng dần cuả biến $year$ như sau

```r
arrange(mytib, year) 
```

```
## # A tibble: 10,545 × 9
##    country   year infant_mortality life_expectancy fertility population      gdp
##    <fct>    <int>            <dbl>           <dbl>     <dbl>      <dbl>    <dbl>
##  1 Albania   1960            115.             62.9      6.19    1636054 NA      
##  2 Algeria   1960            148.             47.5      7.65   11124892  1.38e10
##  3 Angola    1960            208              36.0      7.32    5270844 NA      
##  4 Antigua…  1960             NA              63.0      4.43      54681 NA      
##  5 Argenti…  1960             59.9            65.4      3.11   20619075  1.08e11
##  6 Armenia   1960             NA              66.9      4.55    1867396 NA      
##  7 Aruba     1960             NA              65.7      4.82      54208 NA      
##  8 Austral…  1960             20.3            70.9      3.45   10292328  9.67e10
##  9 Austria   1960             37.3            68.8      2.7     7065525  5.24e10
## 10 Azerbai…  1960             NA              61.3      5.57    3897889 NA      
## # ℹ 10,535 more rows
## # ℹ 2 more variables: continent <fct>, region <fct>
```

Để sắp xếp dữ liệu theo thứ tự giảm dần của một biến, nếu biến dữ liệu dùng để sắp xếp là kiểu số, bạn đọc chỉ cần thêm dấu `-` trước tên biến đó trong hàm `arrange()`. Trong trường hợp tổng quát, khi dữ liệu có thể có kiểu chuỗi ký tự, ngày tháng, ..., chúng ta sử dụng hàm `desc()` để sắp xếp dữ liệu theo thứ tự giảm dần:

```r
arrange(mytib, desc(year)) 
```

```
## # A tibble: 10,545 × 9
##    country      year infant_mortality life_expectancy fertility population   gdp
##    <fct>       <int>            <dbl>           <dbl>     <dbl>      <dbl> <dbl>
##  1 Albania      2016               NA            78.1        NA         NA    NA
##  2 Algeria      2016               NA            76.5        NA         NA    NA
##  3 Angola       2016               NA            60          NA         NA    NA
##  4 Antigua an…  2016               NA            76.5        NA         NA    NA
##  5 Argentina    2016               NA            76.7        NA         NA    NA
##  6 Armenia      2016               NA            74.9        NA         NA    NA
##  7 Aruba        2016               NA            75.8        NA         NA    NA
##  8 Australia    2016               NA            82.3        NA         NA    NA
##  9 Austria      2016               NA            81.4        NA         NA    NA
## 10 Azerbaijan   2016               NA            73.3        NA         NA    NA
## # ℹ 10,535 more rows
## # ℹ 2 more variables: continent <fct>, region <fct>
```

Việc sắp xếp dữ liệu có thể thực hiện dựa trên nhiều cột dữ liệu. Ví dụ, để sắp xếp dữ liệu $\textbf{gapminder}$ theo thứ tự tăng dần theo năm ($year$), tiếp theo là theo Châu lục ($continent$), và sau cùng là theo vùng ($region$), bạn đọc viết câu lệnh như sau:

```r
arrange(mytib, year, continent, region) 
```

```
## # A tibble: 10,545 × 9
##    country    year infant_mortality life_expectancy fertility population     gdp
##    <fct>     <int>            <dbl>           <dbl>     <dbl>      <dbl>   <dbl>
##  1 Burundi    1960            145.             40.6      6.95    2786740  3.41e8
##  2 Comoros    1960            200              44.0      6.79     188732 NA     
##  3 Djibouti   1960             NA              45.8      6.46      83636 NA     
##  4 Eritrea    1960             NA              39.0      6.9     1407631 NA     
##  5 Ethiopia   1960            162              37.7      6.88   22151218 NA     
##  6 Kenya      1960            119.             47.4      7.95    8105440  2.12e9
##  7 Madagasc…  1960            112              42.0      7.3     5099371  2.09e9
##  8 Malawi     1960            218.             38.5      6.91    3618604  3.48e8
##  9 Mauritius  1960             67.8            58.7      6.17     660023 NA     
## 10 Mozambiq…  1960            183              38.2      6.6     7493278 NA     
## # ℹ 10,535 more rows
## # ℹ 2 more variables: continent <fct>, region <fct>
```

Lưu ý rằng thứ tự sắp xếp cũng có thể là tăng theo một biến và giảm theo các biến khác:

```r
arrange(mytib, year, desc(continent), desc(region), -gdp) # tăng dần theo năm, giảm dần theo continent, region, gdp
```

```
## # A tibble: 10,545 × 9
##    country    year infant_mortality life_expectancy fertility population     gdp
##    <fct>     <int>            <dbl>           <dbl>     <dbl>      <dbl>   <dbl>
##  1 French P…  1960              NA             56.3      5.66      78083 NA     
##  2 Samoa      1960              92             51.4      7.65     108645 NA     
##  3 Tonga      1960              NA             61.2      7.36      61600 NA     
##  4 Kiribati   1960              NA             45.8      6.95      41234 NA     
##  5 Micrones…  1960              NA             56.8      6.93      44539 NA     
##  6 Papua Ne…  1960             135.            38.6      6.28    1966957  8.37e8
##  7 Fiji       1960              54             55.7      6.46     393383  4.37e8
##  8 New Cale…  1960              NA             56.4      5.22      78058 NA     
##  9 Solomon …  1960             132.            50.6      6.39     117869 NA     
## 10 Vanuatu    1960             107.            46.0      7.2       63701 NA     
## # ℹ 10,535 more rows
## # ℹ 2 more variables: continent <fct>, region <fct>
```

Khi trong cột dữ liệu sử dụng để sắp xếp có chứa giá trị không quan sát được (NA) thì các giá trị này luôn được sắp xếp xuống phía dưới của dữ liệu bất kể chúng ta sắp xếp dữ liệu theo thứ tự tăng dần hay giảm dần. Ví dụ, cột $gdp$ của dữ liệu $\textbf{gapminder$ có tỷ lệ biến nhận giá trị NA khá cao. Khi quan sát phần đuôi của dữ liệu được sắp xếp theo $gdp$, chúng ta sẽ luôn thấy các giá trị NA được đẩy xuống phía dưới:

```r
tail(arrange(mytib, gdp))
```

```
## # A tibble: 6 × 9
##   country       year infant_mortality life_expectancy fertility population   gdp
##   <fct>        <int>            <dbl>           <dbl>     <dbl>      <dbl> <dbl>
## 1 Venezuela     2016               NA            74.8        NA         NA    NA
## 2 West Bank a…  2016               NA            74.7        NA         NA    NA
## 3 Vietnam       2016               NA            75.6        NA         NA    NA
## 4 Yemen         2016               NA            64.9        NA         NA    NA
## 5 Zambia        2016               NA            57.1        NA         NA    NA
## 6 Zimbabwe      2016               NA            61.7        NA         NA    NA
## # ℹ 2 more variables: continent <fct>, region <fct>
```

```r
tail(arrange(mytib, desc(gdp)))
```

```
## # A tibble: 6 × 9
##   country       year infant_mortality life_expectancy fertility population   gdp
##   <fct>        <int>            <dbl>           <dbl>     <dbl>      <dbl> <dbl>
## 1 Venezuela     2016               NA            74.8        NA         NA    NA
## 2 West Bank a…  2016               NA            74.7        NA         NA    NA
## 3 Vietnam       2016               NA            75.6        NA         NA    NA
## 4 Yemen         2016               NA            64.9        NA         NA    NA
## 5 Zambia        2016               NA            57.1        NA         NA    NA
## 6 Zimbabwe      2016               NA            61.7        NA         NA    NA
## # ℹ 2 more variables: continent <fct>, region <fct>
```
Bạn đọc có thể quan sát thấy rằng phần đuôi của kết quả không thay đổi dù chúng ta có thực hiện sắp xếp theo thứ tự $gdp$ tăng dần hay $gdp$ giảm dần.

### Kết hợp các phép biến đổi bằng toán tử pipe (`%>%`)  
Trước khi giới thiệu các hàm số khác sử dụng để biến đổi dữ liệu của thư viện $\textbf{dplyr}$, chúng tôi giới thiệu đến bạn đọc toán tử pipe (`%>%`). Đây là một công cụ rất hiệu quả khi chúng ta thực hiện một chuỗi các phép biến đổi dữ liệu. Thuật ngữ "toán tử pipe" được mượn từ toán học khi nói đến việc sử dụng các hàm số nối tiếp nhau. Pipe trong thư viện $\textbf{dplyr}$ cũng có ý nghĩa tương tự khi bạn đọc sẽ sử dụng một chuỗi các hàm của thư viện nhằm biến đổi dữ liệu. Toán tử pipe giúp cho việc viết các câu lệnh biến đổi dữ liệu phức tạp trở nên đơn giản và tránh bị nhầm lẫn. Ví dụ, khi chúng ta muốn thực hiện một phân tích trên dữ liệu $textbf{gapminder}$, đó là tìm ra ba quốc gia có thu nhập bình quân đầu người cao nhất của năm 2000. Để thực hiện được việc này, bạn đọc sẽ cần thực hiện các phép biến đổi sau theo thứ tự như sau:

- Thứ nhất: tính toán thêm cột thu nhập bình quân đầu người, sử dụng hàm `mutate()`.

- Thứ hai: lọc dữ liệu theo năm, chỉ lấy dữ liệu của năm 2000, sử dụng hàm `filter()`.

- Thứ ba: lựa chọn cột tên quốc gia ($country$) và cột thu nhập bình quân đầu người vừa tính toán, sử dụng hàm `select()`.

- Thứ tư: sắp xếp dữ liệu theo cột thu nhập bình quân đầu người, thứ tự sắp xếp là giảm dần, sử dụng hàm `arrange()`.

- Thứ năm: lấy ra ba hàng đầu tiên của dữ liệu sau khi sắp xếp, sử dụng hàm `head()`.

Nếu viết các câu lệnh một cách thông thường, sau mỗi bước ở trên bạn đọc sẽ phải lưu kết quả và gọi lại kết quả vào bước kế tiếp:

```r
mytib1<-mutate(mytib,gdp_per_capita = gdp/population) # bước thứ nhất
mytib1<-filter(mytib1, year == 2010) # bước thứ hai
mytib1<-select(mytib1, country, gdp_per_capita) # bước thứ ba
mytib1<-arrange(mytib1, desc(gdp_per_capita)) # bước thứ tư
head(mytib1,3) # bước thứ năm
```

```
## # A tibble: 3 × 2
##   country    gdp_per_capita
##   <fct>               <dbl>
## 1 Luxembourg         52210.
## 2 Japan              40013.
## 3 Norway             39954.
```

Cách viết các câu lệnh như trên sẽ gặp khó khăn và dễ bị nhầm lần do chúng ta phải liên tục lưu kết quả của từng câu lệnh và gọi lại kết quả đó trong bước tiếp theo. Để tránh gặp phải vấn đề này, toán tử pipe `%>%` giúp chúng ta kết nối các câu lệnh lại với nhau trong một câu lệnh duy nhất. Cùng một yêu cầu như ở trên, cách viết các câu lệnh biến đổi dữ liệu sử dụng toán tử pipe như sau:


```r
mytib%>%mutate(gdp_per_capita = gdp/population)%>%
  filter(year == 2010)%>%
  select(country, gdp_per_capita)%>%
  arrange(desc(gdp_per_capita)) %>%
  head(3)
```

```
## # A tibble: 3 × 2
##   country    gdp_per_capita
##   <fct>               <dbl>
## 1 Luxembourg         52210.
## 2 Japan              40013.
## 3 Norway             39954.
```

Bạn đọc có thể thấy rằng kết quả thu được hoàn toàn giống như phía trên. Ngoài ra, cách viết câu lệnh sử dụng toán tử pipe có ưu điểm là rất rõ ràng, ngắn gọn, và không gây nhầm lẫn. Để bạn đọc làm quen với cách viết câu lệnh sử dụng pipe, từ phần này của cuốn sách, mọi phép biến đổi trên dữ liệu đều được ưu tiên sử dụng cách viết này.

Chúng ta sẽ tiếp tục làm quen với các hàm số sử dụng để biến đổi dữ liệu của thư viện $\textbf{dplyr}$ trong các phần tiếp theo.


### Tổng hợp dữ liệu bằng `group_by` và `summarise()` 
Hàm `group_by()` là một công cụ mạnh mẽ sử dụng để tổng hợp dữ liệu và tính toán theo nhóm. Ví dụ, tổng thu nhập quốc nội của Việt Nam năm 2000 là hơn 31 tỷ USD. Chúng ta muốn biết nền kinh tế của Việt Nam so với mức trung bình của Châu Á vào năm 2000 là như thế nào. Để thực hiện được việc đó, chúng ta cần tính tổng thu nhập quốc dân trung bình của các quốc gia Châu Á. Một cách tự nhiên, bạn đọc có thể sử dụng hàm `filter()` để lọc dữ liệu của Châu Á vào năm 2000 sau đó tính trung bình biến tổng thu nhập quốc dân. Tuy nhiên, nếu bạn muốn thực hiện phép so sánh tổng thu nhập quốc dân của tất cả các quốc gia so với thu nhập trung bình của Châu lục tương ứng trong năm 2000, sử dụng hàm `filter()` như trên sẽ không hiệu quả vì chỉ cho phép thực hiện so sánh với từng quốc gia cụ thể trong một năm cụ thể.

Hàm `group_by()` sẽ giúp chúng ta thực hiện các tính toán theo các nhóm trên toàn bộ dữ liệu. Để so sánh $gdp$ của một nước với $gdp$ trung bình của Châu lục trong từng năm, chúng ta sẽ cần thực hiện các bước như sau:

- Bước 1: Nhóm dữ liệu lại theo châu lục và theo năm.

- Bước 2: Tính giá trị trung bình thu nhập quốc dân của châu lục trong mỗi năm. Khi tính giá trị trung bình sẽ bỏ qua các quốc gia không có quan sát về $gdp$.

- Bước 3: So sánh gdp của quốc gia với gdp trung bình của châu lục trong năm

Những bước như trên có thể được thực hiện một cách đơn giản thông qua hàm `group_by()` như sau


```r
mytib%>%group_by(continent, year) %>% # nhóm dữ liệu theo continent và year
  mutate(gdp_year_continent = mean(gdp,na.rm=TRUE))%>% # thêm cột gdp bình quân theo nhóm
  ungroup()%>% # để dữ liệu trở lại trạng thái ban đầu
  mutate(gdp_level = ifelse(gdp > gdp_year_continent, "High", "Low"))%>%
  select(country,continent,year,contains("gdp"))
```

```
## # A tibble: 10,545 × 6
##    country             continent  year          gdp gdp_year_continent gdp_level
##    <fct>               <fct>     <int>        <dbl>              <dbl> <chr>    
##  1 Albania             Europe     1960           NA      110891884444. <NA>     
##  2 Algeria             Africa     1960  13828152297        3652247577. High     
##  3 Angola              Africa     1960           NA        3652247577. <NA>     
##  4 Antigua and Barbuda Americas   1960           NA      114730852582  <NA>     
##  5 Argentina           Americas   1960 108322326649      114730852582  Low      
##  6 Armenia             Asia       1960           NA       61181554907. <NA>     
##  7 Aruba               Americas   1960           NA      114730852582  <NA>     
##  8 Australia           Oceania    1960  96677859364       32650664881. High     
##  9 Austria             Europe     1960  52392699681      110891884444. Low      
## 10 Azerbaijan          Asia       1960           NA       61181554907. <NA>     
## # ℹ 10,535 more rows
```

Các tính toán được sử dụng sau hàm `group_by()` và trước hàm `ungroup()` đều được thực hiện theo các nhóm được định nghĩa bởi hàm `group_by()`. Trong câu lệnh ở trên, sau khi sử dụng hàm `group_by()`, các quan sát có cùng giá trị của cột $continents$ và cột $year$ sẽ được hiểu là một nhóm. Các tính toán sau đó cần phải được thực hiện bằng các hàm hoạt động trên véc-tơ. Thật vậy, hàm `mean(,na.rm = TRUE)` tính giá trị trung bình của cột $gdp$ cho từng châu lục theo từng năm. Chúng ta có thể kiểm tra giá trị ở các hàng đầu tiên của cột $gdp\_year\_continent$ từ kết quả ở trên hoàn toàn giống với cách tính sử dụng hàm `filter()` cho một châu lục cụ thể vào một năm cụ thể:

```r
mytib%>%filter(year == 1960, continent == "Europe")%>%
  select(gdp)%>%sapply(function(x) mean(x,na.rm=TRUE))
```

```
##          gdp 
## 110891884444
```

Cả hai cách tính đều cho biết tổng thu nhập quốc dân trung bình của các nước Châu Âu trong năm 1960 là 110 tỷ USD. 

Hàm `summarise()` được sử dụng tiếp sau hàm `group_by()` thay cho `ungroup()` khi chúng ta muốn tạo thành một dữ liệu mới mà mỗi quan sát tương ứng với một nhóm được quy định bởi `group_by()`. Ví dụ, nếu chúng ta muốn tạo ra một dữ liệu mới mà mỗi quan sát tương ứng với một châu lục trong một năm, và cột $gdp\_year\_continent$ cho biết tổng thu nhập quốc dân trung bình của châu lục trong năm đó, câu lệnh được viết như sau:

```r
mytib%>%group_by(continent, year) %>%
  summarise(gdp_year_continent = mean(gdp,na.rm=TRUE)) %>%
  arrange(year, continent)
```

```
## # A tibble: 285 × 3
## # Groups:   continent [5]
##    continent  year gdp_year_continent
##    <fct>     <int>              <dbl>
##  1 Africa     1960        3652247577.
##  2 Americas   1960      114730852582 
##  3 Asia       1960       61181554907.
##  4 Europe     1960      110891884444.
##  5 Oceania    1960       32650664881.
##  6 Africa     1961        3642863976.
##  7 Americas   1961      118059881733.
##  8 Asia       1961       62764504767.
##  9 Europe     1961      123997131430.
## 10 Oceania    1961       33430553232.
## # ℹ 275 more rows
```

Bạn đọc có thể thấy rằng dữ liệu mới được tạo thành dưới dạng một tibble mà mỗi quan sát là một châu lục trong một năm. Dữ liệu có ba biến, trong đó hai biến đầu tiên là $continent$ và $year$ được quy định bởi hàm `group_by()`, còn biến thứ ba là $gdp\_year\_continent$ mới được tạo thành từ hàm `summarise()`. 

## Sắp xếp dữ liệu bằng thư viện $\textbf{tidyr}$
Một dữ liệu trước khi được đưa vào trực quan hóa hay xây dựng mô hình cần phải được sắp xếp và trình bày một cách nhất quán. Các dữ liệu có sẵn trong R hoặc trong thư viện của R nhìn chung đều đã được sắp xếp hoàn chỉnh nên chúng ta không gặp phải vấn đề này trong các ví dụ ở trên. Tuy nhiên, dữ liệu lấy từ các nguồn khác nhau thường gặp phải các vấn đề về sự nhất quán. Hãy quan sát các ví dụ sau, các dữ liệu cùng thể hiện thông tin về tổng thu nhập quốc dân và dân số của các quốc gia trên thế giới từ năm 2000 đến 2010 nhưng lại được trình bày khác nhau:



```r
mytib1
```

```
## # A tibble: 2,035 × 4
##    country              year           gdp population
##    <fct>               <int>         <dbl>      <dbl>
##  1 Albania              2000   3686649387     3121965
##  2 Algeria              2000  54790058957    31183658
##  3 Angola               2000   9129180361    15058638
##  4 Antigua and Barbuda  2000    802526701.      77648
##  5 Argentina            2000 284203745280    37057453
##  6 Armenia              2000   1911563665     3076098
##  7 Aruba                2000   1858659293       90858
##  8 Australia            2000 416887521196    19107251
##  9 Austria              2000 192070749954     8050884
## 10 Azerbaijan           2000   5272617196     8117742
## # ℹ 2,025 more rows
```

```r
mytib2
```

```
## # A tibble: 2,035 × 3
##    country              year gdp_per_capita       
##    <fct>               <int> <chr>                
##  1 Albania              2000 3686649387/3121965   
##  2 Algeria              2000 54790058957/31183658 
##  3 Angola               2000 9129180361/15058638  
##  4 Antigua and Barbuda  2000 802526700.6/77648    
##  5 Argentina            2000 284203745280/37057453
##  6 Armenia              2000 1911563665/3076098   
##  7 Aruba                2000 1858659293/90858     
##  8 Australia            2000 416887521196/19107251
##  9 Austria              2000 192070749954/8050884 
## 10 Azerbaijan           2000 5272617196/8117742   
## # ℹ 2,025 more rows
```

```r
mytib3
```

```
## # A tibble: 4,070 × 4
##    country              year type               value
##    <fct>               <int> <chr>              <dbl>
##  1 Albania              2000 gdp          3686649387 
##  2 Albania              2000 population      3121965 
##  3 Algeria              2000 gdp         54790058957 
##  4 Algeria              2000 population     31183658 
##  5 Angola               2000 gdp          9129180361 
##  6 Angola               2000 population     15058638 
##  7 Antigua and Barbuda  2000 gdp           802526701.
##  8 Antigua and Barbuda  2000 population        77648 
##  9 Argentina            2000 gdp        284203745280 
## 10 Argentina            2000 population     37057453 
## # ℹ 4,060 more rows
```

```r
mytib4
```

```
## # A tibble: 370 × 13
##    country type   `2000`  `2001`  `2002`  `2003`  `2004`  `2005`  `2006`  `2007`
##    <fct>   <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 Albania gdp   3.69e 9 3.94e 9 4.06e 9 4.29e 9 4.54e 9 4.79e 9 5.03e 9 5.33e 9
##  2 Albania popu… 3.12e 6 3.12e 6 3.12e 6 3.12e 6 3.10e 6 3.08e 6 3.05e 6 3.01e 6
##  3 Algeria gdp   5.48e10 5.62e10 5.89e10 6.29e10 6.62e10 6.96e10 7.10e10 7.31e10
##  4 Algeria popu… 3.12e 7 3.16e 7 3.20e 7 3.24e 7 3.28e 7 3.33e 7 3.37e 7 3.43e 7
##  5 Angola  gdp   9.13e 9 9.42e 9 1.08e10 1.11e10 1.24e10 1.46e10 1.77e10 2.17e10
##  6 Angola  popu… 1.51e 7 1.56e 7 1.61e 7 1.67e 7 1.73e 7 1.79e 7 1.85e 7 1.92e 7
##  7 Antigu… gdp   8.03e 8 8.20e 8 8.41e 8 8.84e 8 9.46e 8 9.85e 8 1.12e 9 1.01e 9
##  8 Antigu… popu… 7.76e 4 7.90e 4 8.00e 4 8.09e 4 8.17e 4 8.26e 4 8.35e 4 8.44e 4
##  9 Argent… gdp   2.84e11 2.72e11 2.42e11 2.63e11 2.87e11 3.14e11 3.40e11 3.70e11
## 10 Argent… popu… 3.71e 7 3.75e 7 3.79e 7 3.83e 7 3.87e 7 3.91e 7 3.96e 7 4.00e 7
## # ℹ 360 more rows
## # ℹ 3 more variables: `2008` <dbl>, `2009` <dbl>, `2010` <dbl>
```

Tất cả dữ liệu kể trên đều trình bày chung một nguồn thông tin nhưng chỉ có `mytib1` là được sắp xếp một cách nhất quán. Trong khi các dữ liệu khác chưa sẵn sàng để thực hiện các bước tiếp theo. Thật vậy:

- Dữ liệu lưu trong `mytib2` có biến $gdp\_per\_capita$ trình bày dưới dạng chuỗi ký tự, với số tổng thu nhập quốc dân và dân số được lưu trong cùng một cột và cách nhau bởi dấu `/`. Không thể thực hiện các phân tích hay tính toán với cột dữ liệu như vậy.

- Dữ liệu lưu trong `mytib3` có cột $type$ cho biết số tương ứng trong cột $value$ là giá trị của tổng thu nhập quốc dân hay dân số của nước đó. Giá trị trong cột $value$ không nhất quán vì vừa có thể là số tiền, vừa là số người.

- Dữ liệu lưu trong `mytyb4` cũng là một điển hình cho dữ liệu chưa được sắp xếp một cách nhất quán. Giá trị của biến $year$ không được lưu dưới dạng véc-tơ cột mà được lưu dưới dạng tên các cột nên rất khó khăn trong thực hiện tính toán. 

Một dữ liệu được sắp xếp nhất quán cần phải đảm bảo hai yêu cầu:

- Thứ nhất: mỗi quan sát là một dòng dữ liệu.

- Thứ hai: mỗi biến nằm ở một cột. Một biến mô tả một thuộc tính, một tính chất của quan sát tương ứng.  Giá trị trong cột phải đồng nhất và đúng định dạng.

Lý do chính khiến dữ liệu không được sắp xếp nhất quán là do dữ liệu thường được tổ chức để thuận lợi cho một số mục tiêu khác với mục tiêu phân tích, chẳng hạn như mục tiêu nhập dữ liệu hoặc mục tiêu để hiển thị trực quan hơn với người quan sát dữ liệu.

Quá trình sắp xếp dữ liệu là quá trình biến đổi, chuyển hóa dữ liệu từ các định dạng như `mytib2`, `mytib3`, hoặc `mytib4` về định dạng như `mytib1`. Nhìn chung, sắp xếp dữ liệu là công việc tương đối đơn giản so với các quy trình khác. Trong phần này, bạn đọc chỉ cần nắm vững nguyên tắc của hai phép biến đổi là kéo dài dữ liệu bằng hàm `gather()` (hoặc `pivot_longer()` trong các phiên bản mới của $\textbf{tidyr}$) và mở rộng dữ liệu bằng hàm `spread()` (hoặc `pivot_wider()` trong các phiên bản mới của $\textbf{tidyr}$).

### Kéo dài dữ liệu bằng `gather()`
Dữ liệu được lưu dưới dạng của `mytib4` có thông tin về năm quan sát được lưu dưới dạng cột. Đây là trường hợp rất hay gặp phải khi lấy dữ liệu từ các nguồn bên ngoài vào. Các dữ liệu này được lưu dưới dạng các ma trận với ít dòng và nhiều cột để thuận lợi cho người sử dụng dữ liệu có quan sát trực quan. Để đưa dữ liệu như `mytib4` về định dạng có thể phân tích được, mà mỗi dòng là một quốc gia, được quan sát trong 1 năm, chúng ta cần thêm vào dữ liệu một cột có tên $year$. Giá trị của biến $year$ là tên tất cả các cột, từ cột `2000` đến cột `2010`. Thêm cột $year$ và kéo dài dữ liệu `mytib4`, chúng ta sử dụng hàm `gather()` như sau:

```r
mytib4%>%gather(key = "year", value = "gdp_population", -country, -type)
```

```
## # A tibble: 4,070 × 4
##    country             type       year  gdp_population
##    <fct>               <chr>      <chr>          <dbl>
##  1 Albania             gdp        2000     3686649387 
##  2 Albania             population 2000        3121965 
##  3 Algeria             gdp        2000    54790058957 
##  4 Algeria             population 2000       31183658 
##  5 Angola              gdp        2000     9129180361 
##  6 Angola              population 2000       15058638 
##  7 Antigua and Barbuda gdp        2000      802526701.
##  8 Antigua and Barbuda population 2000          77648 
##  9 Argentina           gdp        2000   284203745280 
## 10 Argentina           population 2000       37057453 
## # ℹ 4,060 more rows
```
Bạn đọc có thể thấy rằng kết quả thu được đã có thêm cột $year$ cho biết thông tin mỗi quốc gia được quan sát trong năm bao nhiêu va cột $`gdp/population`$ cho biết giá trị của tổng thu nhập quốc dân hoặc dân số của quốc gia đó. Qua cách sử dụng hàm `gather()`, có thể thấy rằng

- Tham số `key` trong hàm `gather()` cho biết tên của cột trong dữ liệu mới được tạo thành chứa giá trị là tên các cột được tập hợp lại. Tham số `value` cho biết tên cột trong dữ liệu mới được tạo thành chứa tất cả các giá trị trong các cột được tập hợp. 

- Sau khi khai báo hai tham số `key` và `value`, bạn đọc cần khai báo chính xác thông tin các biến không bị tác động bởi hàm `gather()`. Trong ví dụ ở trên, tất các các giá trị chúng ta muốn tập hợp lại là các cột bắt đầu từ cột có tên `2000` (tương ứng với các quan sát trong năm 2000) đến cột có tên `2010` (tương ứng với các quan sát của năm 2010). Khai báo `-country` và `-type` trong hàm `gather()` có ý nghĩa là các cột được tập hợp thông tin lại thành một cột duy nhất là tất cả các cột, ngoại trừ hai cột $country$ và $type$.

Trong các phiên bản mới của thư viện $\textbf{tidyr}$, hàm `pivot_long()` thường được sử dụng thay thế cho `gather()`. Ưu điểm của `pivot_longer()` là câu lệnh dễ hiểu hơn và cho phép chúng ta quản lý tên cột bằng các hàm sử dụng cùng với các biểu thức chính quy. Ví dụ, chúng ta có thể sử dụng `pivot_longer()` để tập hợp thông tin của tất cả các cột có tên cột bắt đầu bằng ký tự `"2"` như sau

```r
mytib4%>%pivot_longer(cols = starts_with("2"), 
                      names_to = "year",
                      values_to = "gdp_population")
```

```
## # A tibble: 4,070 × 4
##    country type  year  gdp_population
##    <fct>   <chr> <chr>          <dbl>
##  1 Albania gdp   2000      3686649387
##  2 Albania gdp   2001      3944714844
##  3 Albania gdp   2002      4059111575
##  4 Albania gdp   2003      4290480934
##  5 Albania gdp   2004      4543619309
##  6 Albania gdp   2005      4793518372
##  7 Albania gdp   2006      5033194290
##  8 Albania gdp   2007      5330152753
##  9 Albania gdp   2008      5740574515
## 10 Albania gdp   2009      5930013474
## # ℹ 4,060 more rows
```

Hàm `pivot_longer()` cho phép kéo dài các bảng mà giá trị của nhiều biến được tích hợp trong tên của các cột. Ví dụ, dữ liệu trong `mytib5` dưới đây lưu điểm của hai sinh viên theo hai kỳ học của các năm 2023 và năm 2024:


```r
mytib5
```

```
## # A tibble: 2 × 5
##   Name  `2023 S1` `2023 S2` `2024 S1` `2024 S2`
##   <chr>     <dbl>     <dbl>     <dbl>     <dbl>
## 1 SV1         8.5       6.9       8.1       8.5
## 2 SV2         8         8.2       8.8       8
```
Bạn đọc có thể thấy rằng tên các cột có bao gồm hai thông tin là năm học (2023 hoặc 2024) và thông tin về kỳ học (S1 hoặc S2). Chúng ta có thể sử dụng `pivot_longer()` để tạo thành dữ liệu mới, với hai biến mới tương ứng với hai thông tin: $year$ tương ứng với năm học và $semester$ tương ứng với kỳ học của hai sinh viên:

```r
mytib5%>%pivot_longer(cols = !Name, # Không tập hợp cột Names
                      names_to = c("year", "semester"),
                      names_sep = " ",
                      values_to = "GPA")
```

```
## # A tibble: 8 × 4
##   Name  year  semester   GPA
##   <chr> <chr> <chr>    <dbl>
## 1 SV1   2023  S1         8.5
## 2 SV1   2023  S2         6.9
## 3 SV1   2024  S1         8.1
## 4 SV1   2024  S2         8.5
## 5 SV2   2023  S1         8  
## 6 SV2   2023  S2         8.2
## 7 SV2   2024  S1         8.8
## 8 SV2   2024  S2         8
```

Trong các trường hợp phức tạp hơn, trong tên biến của dữ liệu ban đầu vừa chứa tên biến trong dữ liệu mới vừa chứa giá trị của biến trong dữ liệu mới như dữ liệu trong `mytib6` dưới đây:


```r
mytib6
```

```
## # A tibble: 4 × 5
##   Lop   Ten_LopTruong Ten_BiThu Diem_LopTruong Diem_BiThu
##   <chr> <chr>         <chr>              <int>      <int>
## 1 Act61 LT1           BT1                    6          7
## 2 Act62 LT2           BT2                    7          8
## 3 Act63 LT3           BT3                    8          9
## 4 Act64 LT4           BT4                    9         10
```
Bạn đọc có thể thấy rằng dữ liệu chứa thông tin về 8 người, giữ các chức chức vụ lớp trưởng và bí thư tại 4 lớp với thông tin tương ứng với từng người là tên và điểm. Các cột dữ liệu `'Ten_LopTruong'` và `'Ten_BiThu'` vừa chứa tên của một biến là tên của người, vừa chứa giá trị của biến chức vụ của người đó. Tương tự, các cột dữ liệu `'Diem_LopTruong'` và `'Diem_BiThu'` vừa chứa tên của biến là điểm của bạn sinh viên tương ứng, vừa chứa giá trị của biến là chức vụ của người đó. Dữ liệu có thể được sắp xếp lại bằng `pivot_longer()` như sau:

```r
mytib6%>%pivot_longer(cols = !Lop,
                      names_to = c(".value", "Chuc_vu"),
                      names_sep = "_")
```

```
## # A tibble: 8 × 4
##   Lop   Chuc_vu   Ten    Diem
##   <chr> <chr>     <chr> <int>
## 1 Act61 LopTruong LT1       6
## 2 Act61 BiThu     BT1       7
## 3 Act62 LopTruong LT2       7
## 4 Act62 BiThu     BT2       8
## 5 Act63 LopTruong LT3       8
## 6 Act63 BiThu     BT3       9
## 7 Act64 LopTruong LT4       9
## 8 Act64 BiThu     BT4      10
```
Trong câu lệnh ở trên, chúng tôi sử dụng tham số `names_to` với phần tử đầu tiên là `".value"` thay vì sử dụng tham số `values_to` như trên. Mục đích là để khai báo rằng thành phần thứ nhất trong tên của các cột là tên biến, bao gồm các biến $Ten$ và biến $Diem$. Phần tử thứ hai của tham số `names_to` là `"Chuc_vu"` tương ứng với biến $Chuc\_vu$ trong dữ liệu mới.

### Mở rộng dữ liệu với `speard()`
Ngược lại với `gather()`, chúng ta sử dụng `speard()` để mở rộng dữ liệu, nghĩa là biến đổi tên biến thành tên các cột. Dữ liệu cần được mở rộng khi giá trị trong các cột dữ liệu không được đồng nhất, giống như thông tin về tổng thu nhập quốc dân và dân số của các quốc gia trên thế giới trong dữ liệu được lưu trong `mytib3`

```r
mytib3
```

```
## # A tibble: 4,070 × 4
##    country              year type               value
##    <fct>               <int> <chr>              <dbl>
##  1 Albania              2000 gdp          3686649387 
##  2 Albania              2000 population      3121965 
##  3 Algeria              2000 gdp         54790058957 
##  4 Algeria              2000 population     31183658 
##  5 Angola               2000 gdp          9129180361 
##  6 Angola               2000 population     15058638 
##  7 Antigua and Barbuda  2000 gdp           802526701.
##  8 Antigua and Barbuda  2000 population        77648 
##  9 Argentina            2000 gdp        284203745280 
## 10 Argentina            2000 population     37057453 
## # ℹ 4,060 more rows
```

Bạn đọc có thể thấy rằng trong cột $gdp\_population$ vừa có cả thông tin về tổng thu nhập quốc dân ($gdp$) và thông tin về dân số ($population$) của quốc gia đó và cột $type$ cho biết giá trị đó là $gdp$ hay $population$. Dữ liệu như trên có thể được sắp xếp lại bằng cách sử dụng hàm `speard()` như sau:

```r
mytib3%>%spread(key = type, value = value)
```

```
## # A tibble: 2,035 × 4
##    country  year        gdp population
##    <fct>   <int>      <dbl>      <dbl>
##  1 Albania  2000 3686649387    3121965
##  2 Albania  2001 3944714844    3124093
##  3 Albania  2002 4059111575    3123112
##  4 Albania  2003 4290480934    3117045
##  5 Albania  2004 4543619309    3103758
##  6 Albania  2005 4793518372    3082172
##  7 Albania  2006 5033194290    3050741
##  8 Albania  2007 5330152753    3010849
##  9 Albania  2008 5740574515    2968026
## 10 Albania  2009 5930013474    2929886
## # ℹ 2,025 more rows
```

Có thể thấy rằng dữ liệu mới đã được sắp xếp nhất quán và đã có thể được sử dụng trong phân tích và xây dựng mô hình. Trong hàm `spread()` ở trên, tham số `key` cho biết cột nào trong dữ liệu ban đầu là cột chứa giá trị là tên các biến mới. Do cột $type$ của dữ liệu `mytib3` chỉ có chứa hai giá trị là `gdp` và `population` nên trong dữ liệu mới có hai cột mới được hình thành tương ứng với hai giá trị trong cột $type$. Tham số `value` được sử dụng để cho biết giá trị của biến nào trong dữ liệu ban đầu sẽ được lấy vào các cột mới được hình thành. Trong câu lệnh ở trên, cột $value$ của `mytib3` chứa giá trị tương ứng với tổng thu nhập quốc dân và dân số của mỗi nước được sử dụng để gán cho tham số `value` trong hàm `spread()`.

Trong các phiên bản mới của thư viện $\textbf{tidyr}$, hàm `pivot_wider()` được sử dụng để thay thế cho hàm `spread()` do có nhiều ưu điểm hơn. Do cách sử dụng `pivot_wider()` tương tự như `pivot_longer()` nên chúng tôi không đi vào thảo luận chi tiết về hàm số này. Bạn đọc tự tham khảo cách sử dụng hàm `pivot_wider()` và thực hành trong phần bài tập của chương.

## Phụ lục



```r
# A simple formula to success
while (result != success){
  try <- try * 2 }
```

## Bài tập


<!-- # Trực quan hóa dữ liệu -->
<!-- ```{r code visualization 1.0, warning = FALSE, message = FALSE,fig.width=8, fig.height=7, out.width=504, out.height=504} -->
<!-- p<-gapminder%>%filter(year<=2010)%>% -->
<!-- # AESTHETIC MAPPING -->
<!-- ggplot(aes(x=fertility,y=life_expectancy,size = population, fill= continent))+ -->
<!-- # TAO DO THI SCATTERPLOT -->
<!-- geom_point(shape=21,alpha=0.6)+ -->
<!-- # THAY DOI TITLE CUA DO THI, TRUC X, TRUC Y -->
<!-- labs(title = 'Năm: {as.integer(frame_time)}', -->
<!-- y = "Tuổi thọ trung bình", -->
<!-- x = "Tỷ lệ sinh trên mỗi phụ nữ")+ -->
<!-- #GIOI HAN LAI GIA TRI TREN X,Y -->
<!-- xlim(0,10)+ylim(20,90)+ -->
<!-- # SCALE LAI SIZE (POPULATION) -->
<!-- scale_size(range = c(1*2, 20*2)) + -->
<!-- # SCALE LAI MAU SAC THE0 DAI MAU "SET1" CUA BREWER -->
<!-- scale_color_brewer(palette = "Set1")+ -->
<!-- # LAM TITLE THAY DOI THEO NAM -->
<!-- transition_time(year)+ -->
<!-- #SIZE & FONT CHU -->
<!-- theme(, -->
<!-- plot.title = element_text(size = 20*2), -->
<!-- axis.title.x = element_text(size = 20*2), -->
<!-- axis.title.y = element_text(size = 20*2), -->
<!-- legend.text = element_text(size = 20*2,margin = margin(r = 30*2, unit = "pt")), -->
<!-- legend.title = element_text(size = 20*2), -->
<!-- #    legend.text=element_text(size=20*2), -->
<!-- ) -->
<!-- #legend.key.size = element_rect(size = rel(1.5)), -->

<!-- # TAO DO THI DANG DONG -->
<!-- animate(p, renderer = gifski_renderer(), -->
<!-- width = 1600, #pixel chieu rong -->
<!-- height = 1600) # pixel chieu cao -->
<!-- ``` -->




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