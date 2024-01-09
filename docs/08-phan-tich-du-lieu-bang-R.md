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



# Phân tích dữ liệu bằng R
Trong phần này của cuốn sách, bạn sẽ tìm hiểu về các kỹ thuật phân tích dữ liệu, bao gồm có tiền xử lý dữ liệu, sắp xếp dữ liệu và trực quan hóa dữ liệu.

- Tiền xử lý dữ liệu bao gồm tất cả các kỹ thuật đưa dữ liệu từ các nguồn khác nhau vào R và biến đổi thành định dạng để có thể làm việc được.

- Sắp xếp dữ liệu bao gồm các bước biến đổi, chuyển hóa dữ liệu thành định dạnh để có thể trực quan hóa, phân tích, và xây dựng mô hình.

- Trực quan hóa dữ liệu là một nghệ thuật biến đổi dữ liệu dưới dạng các con số, chuỗi ký tự,..., thành các biểu đồ, đồ thị hay hình ảnh sử dụng các hình dạng, màu sắc, khoảng cách để con người dễ dàng nhận thức và hiểu về dữ liệu. Trực quan hóa dữ liệu còn có thể giúp người phân tích tìm ra những giá trị ẩn chứa trong dữ liệu.

# Nhập dữ liệu từ các nguồn khác nhau vào R

## Đối tượng dùng để lưu dữ liệu trong R
Hai kiểu đối tượng thường được dùng để lưu dữ liệu trong R là $data.frame$ và $tibble$. Chúng ta sẽ thảo luận về $data.frame$ trước vì đây là kiểu lưu dữ liệu phổ biến. Kiểu $tibble$ với một vài ưu điểm hơn $data.frame$ sẽ được thảo luận trong phần tiếp theo.

### $data.frame$ là gì? 

$data.frame$ là đối tượng phổ biến nhất để lưu trữ dữ liệu trên cửa sổ làm việc của R. Hiểu một cách đơn giản, một $data.frame$ là một bảng excel mà mỗi cột tương ứng với một véc-tơ và mỗi dòng tương ứng với một quan sát. Ngay khi cài đặt R, đã có nhiều đối tượng là dữ liệu kiểu $data.frame$ đã được lưu trữ trong R và sẵn sàng sử dụng mà không cần gọi thư viện bổ sung. Để biết trên cửa sổ Rstudio đang sử dụng có những dữ liệu nào, bạn đọc sử dụng câu lệnh `data()` 

```r
data()
```

Bạn đọc có thể thấy trên cửa sổ R Script xuất hiện một cửa sổ mới với danh sách tất cả các dữ liệu sẵn có trong R và dữ liệu sẵn có trong các thư viện được cài đặt thêm mà bạn đọc đang gọi ra trên cửa sổ làm việc. Để biết trong một thư viện đang được gọi ra trên cửa sổ Rstudio có những dữ liệu nào, bạn đọc có thể sử dụng lệnh `data()` kèm với tùy chọn $package$

```r
library(dslabs) # gọi thư viện dslabs lên trên màn hình 
data(package = "dslabs") # cho biết có những data nào trong thư viện dslabs
```

Trong danh sách dữ liệu của thư viện $dslabs$, bạn đọc có thể thấy một đối tượng có tên $murders$. Đây là một $data.frame$. Bạn đọc có thể kiểm tra kiểu của đối tượng này bằng hàm `class()` 

```r
class(murders) # trên màn hình console sẽ cho biết đây là một data frame
```

```
## [1] "data.frame"
```

Thông thường để có hiểu biết ban đầu về một đối tượng kiểu $data.frame$, bạn đọc nên bắt đầu bằng đọc mô tả về dữ liệu (nếu có) bằng cách sử dụng `?`

```r
? murders # trên cửa sổ help sẽ hiển thị mô tả về murders
```

Nhóm các câu lệnh dưới đây giúp bạn đọc hiểu được cấu trúc của dữ liệu trong $data.frame$ đó

```r
View(murders) # Hiển thị data.frame dưới dạng bảng 
head(murders,k = 5) # Hiển thị k dòng đầu tiên của data.frame
```

```
##        state abb region population total
## 1    Alabama  AL  South    4779736   135
## 2     Alaska  AK   West     710231    19
## 3    Arizona  AZ   West    6392017   232
## 4   Arkansas  AR  South    2915918    93
## 5 California  CA   West   37253956  1257
## 6   Colorado  CO   West    5029196    65
```

```r
str(murders) # Hiển thị cấu trúc của data.frame.
```

```
## 'data.frame':	51 obs. of  5 variables:
##  $ state     : chr  "Alabama" "Alaska" "Arizona" "Arkansas" ...
##  $ abb       : chr  "AL" "AK" "AZ" "AR" ...
##  $ region    : Factor w/ 4 levels "Northeast","South",..: 2 4 4 2 4 4 1 2 2 2 ...
##  $ population: num  4779736 710231 6392017 2915918 37253956 ...
##  $ total     : num  135 19 232 93 1257 ...
```

- Hàm `head()` hiển thị nhanh các dòng đầu tiên của dữ liệu cho bạn đọc cái nhìn ban đầu, tuy nhiên hàm `head()` không hiệu quả khi dữ liệu có nhiều cột. 

- Hàm `View()` cho hiển thị về dữ liệu dễ nhìn nhất. Hàm `View()` có hạn chế khi dữ liệu có quá nhiều dòng hoặc nhiều cột và thời gian hiển thị lâu hơn so với `head()`. 

- Hàm `str()` là cách hiển thị dữ liệu một cách tổng quát và hiệu quả hơn so với `head()` hoặc `View()`. Kết quả từ hàm `str()` với dữ liệu $murders$ cho thấy đây là một dữ liệu dạng bảng với 5 cột (5 variables) và 51 dòng (51 observations). Ngoài ra, sử dụng hàm `str()` bạn đọc có thể thấy được kiểu dữ liệu của từng cột; chẳng hạn như cột $state$ là cột chứa dữ liệu kiểu $character$; cột $region$ có kiểu dữ liệu là $factor$,... 

Một hàm số hiệu quả khác thường được sử dụng để bạn đọc có cái nhìn tổng quan về dữ liệu là hàm `summary()`. Chúng ta có thể quan sát kết quả khi sử dụng hàm ``summary()` với dữ liệu $murders$ như sau

```r
summary(murders) # in ra màn hình cột population của data.frame murders
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

- Cột $state$ và cột $abb$ là cột mà giá trị trong đó là kiểu $character$

- Cột $region$ là kiểu factor, có thể nhận một trong bốn giá trị là $Northeast$, $South$, $North$ $Central$, hoặc $West$ và cho biết mỗi giá trị xuất hiện bao nhiêu lần trong cột dữ liệu.

- Các cột $population$ và $total$ là các cột kiểu số. Chúng ta có thể thấy các giá trị lớn nhất, nhỏ nhất, giá trị trung bình và các giá trị tứ phân vị. Bạn đọc có thể hình dung ra phân phối của các giá trị trong cột giá trị kiểu số.

- Trong trường hợp cột có giá trị không quan sát được, hàm `summary()` cũng sẽ cho biết có bao nhiêu giá trị này trong mỗi cột.

Để lấy ra một cột dữ liệu của một $data.frame$ chúng ta sử dụng $\$$. Chẳng hạn như để lấy giá trị cột $population$ của dữ liệu $murders$:


```r
murders$population # in ra màn hình cột population của data.frame murders
```

Như đã nói ở trên, kiểu dữ liệu của cột $region$ là kiểu $factor$. Về bản chất, véc-tơ kiểu $factor$ là một véc-tơ kiểu chuỗi ký tự nhưng được lưu theo một cách hiệu quả hơn, tiết kiệm bộ nhớ, và thuận lợi cho người sử dụng khi phân tích dữ liệu.

- Dữ liệu kiểu factor sẽ lưu véc-tơ chuỗi ký tự dưới dạng vec-tơ số tự nhiên và mỗi chuỗi ký tự sẽ được cho tương ứng với một số tự nhiên. Các lưu này hiệu quả hơn về bộ nhớ khi làm việc với các véc-tơ kiểu chuỗi ký tự nếu có nhiều chuỗi ký tự bị lặp lại trong véc-tơ. Để biết một vec-tơ dạng factor có bao nhiêu giá trị riêng biệt, mỗi giá trị riêng biệt được cho tương ứng với số tự nhiên nào, và mỗi giá trị riêng biệt được lặp lại bao nhiêu lần trong véc-tơ, bạn đọc sử dụng hàm `summary()` hoặc hàm `table()`

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

- Khi lưu dữ liệu kiểu factor thay vì chuỗi ký tự nghĩa là bạn đọc đang định nghĩa dữ liệu là kiểu biến rời rạc (categorial variable). Biến có thể trực tiếp đưa vào các mô hình và không cần thực hiện thêm biến đổi nào khác.

Trong hầu hết các trường hợp bạn đọc sẽ dùng R để xử lý dữ liệu từ nguồn ngoài vào. Chúng ta sẽ sử dụng các hàm có sẵn trong R đọc dữ liệu và kết quả đầu ra của hàm này sẽ là các $data.frame$. Trong một vài trường hợp, bạn đọc sẽ phải tự tạo $data.frame$. Câu lệnh để tạo một $data.frame$ (tên $df$) với các cột có tên lần lượt là $id$, $names$, $grades$, và $result$ được viết như sau

```r
df<-data.frame( # hàm data.frame() dùng để tạo data.frame tên df
      id = paste("SV",1:5), # cột có tên là ID nhận giá trị "SV1",...,"SV5"
      names = c("You", "Me", "Him", "Her", "John"), # Cột names
      grades = c(5.5, 1.5, 10.0, 9.0, 7.6), # Cột grades
      result = c(TRUE, FALSE,TRUE, TRUE, TRUE)) # Cột result
```

Đối tượng kiểu $data.frame$ có một vài nhược điểm khi sử dụng để lưu dữ liệu từ các nguồn khác nhau vào R. Do đó kiểu đối tượng mới được phát triển để khắc phục các nhược điểm này, đó là $tibble$. Phần tiếp theo chúng ta sẽ thảo luận về đối tượng này.

### $tibble$ là một cải tiến của $data.frame$?
Về cơ bản một $tibble$ là cũng có thể hiểu là một $data.frame$ với một vài điều chỉnh để giúp việc lấy dữ liệu từ nguồn bên ngoài vào phân tích trở nên dễ dàng hơn. Ở mức độ phân tích dữ liệu thông thường, sự khác khác nhau giữa $tibble$ và $data.frame$ là không đáng kể. Nếu cần liệt kê ra sự khác nhau cơ bản giữu hai đối tượng này thì có thể kể đến:

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

### Nhập dữ liệu bằng hàm sẵn có.
Danh sách các hàm sẵn có trong R và kiểu dữ liệu tương ứng có thể nhập được liệt kê trong các bảng sau:


<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-14)Danh sách hàm có sẵn để lấy dữ liệu từ nguồn bên ngoài</caption>
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
   <td style="text-align:left;"> readRDS </td>
   <td style="text-align:left;"> Dữ liệu được lưu dưới dạng .rds </td>
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


### Nhập dữ liệu bằng thư viện $readr$.

Các câu lệnh để đọc dữ liệu của thư viện $readr$ tương tự như các câu lệnh sẵn có, nhưng đặc biệt hiệu quả hơn về thời gian đọc dữ liệu. Hàm số dùng để đọc các file định dạng $csv$ trong thư viện $readr$ là hàm `read_csv()`. Để so sánh thời gian đọc dữ liệu vào R của hàm `read_csv()` và hàm `read.csv()` chúng ta sẽ tạo hai file dữ liệu bao gồm test1.csv và test2.csv


```r
x<-matrix(rnorm(10^6),10^2,10^4) # tạo thành 1 ma trận 100 hàng, 10^4 cột
write.csv(x,"test1.csv") # lưu ma tran thanh file .csv
x<-matrix(rnorm(10^7),10^2,10^5) # tạo thành 1 ma trận 100 hàng, 10^5 cột
write.csv(x,"test2.csv") # lưu ma tran thanh file .csv
```

Bạn đọc có thể kiểm tra kích thước của các file test1.csv và test2.csv lần lượt là khoảng 18 Mega byte và 180 Mega byte. Chúng ta sẽ kiểm tra thời gian mà các hàm `read.csv()` và `read_csv()` nhập dữ liệu đối với dữ liệu test1.csv trước: 

```r
start<-proc.time() # lưu lại thời điểm trước khi chạy read.csv
dat<-read.csv("test1.csv") # dùng hàm read.csv để load dữ liệu 
proc.time() - start # tính thời gian hàm read.csv chạy

start<-proc.time() # lưu lại thời điểm trước khi chạy read_csv
dat<-read_csv("test1.csv") # dùng hàm read_csv để load dữ liệu 
proc.time() - start # tính thời gian hàm read_csv chạy
```

Đối với dữ liệu $test1.csv$ thì thời gian nhập dữ liệu của `read_csv()` có nhanh hơn nhưng không có sự khác biệt đáng kể. Tuy nhiên sự khác biệt sẽ rõ ràng khi nhập dữ liệu $test2.csv$. Bạn đọc cân nhắc khi dùng hàm `read.csv()` đọc dữ liệu thời gian nhập dữ liệu có thể lên đến hơn 20 phút.


```r
start<-proc.time() # lưu lại thời điểm trước khi chạy read.csv
dat<-read.csv("test2.csv") # !!! THỜI GIAN CHẠY CÓ THỂ LÊN ĐẾN 20-25 phút
proc.time() - start # tính thời gian hàm read.csv chạy

start<-proc.time() # lưu lại thời điểm trước khi chạy read_csv
dat<-read_csv("test2.csv") # dùng hàm read_csv để load dữ liệu 
proc.time() - start # tính thời gian hàm read_csv chạy
```

Hàm `read_csv()` sẽ mất khoảng 2 phút để đọc dữ liệu $test2.csv$, nghĩa là thời gian tiết kiêm lên đến hơn 10 lần! Danh sách các hàm để đọc dữ liệu trong gói lệnh $readr$ như sau



<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-19)Danh sách hàm đọc dữ liệu của readr</caption>
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
Một sự khác biệt cơ bản khác của các hàm đọc dữ liệu trong readr đó là dữ liệu được lưu vào một Tibble thay vì một Data frame. Điều này giúp cho dữ liệu không bị thay đổi định dạng và giữ nguyên tên cột. Các lưu ý khác khi bạn đọc sử dụng các hàm số đọc dữ liệu của readr

- Các hàm số trong readr luôn hiểu hàng đầu tiên của dữ liệu là tên của mỗi cột. Do đó, bạn đọc cần sử dụng tham số $col_names = FALSE$ nếu không muốn readr hiểu hàng đầu tiên là tên của mỗi cột dữ liệu.

```r
library(readr)
# Kết quả sẽ là một Tibble 1 hàng và 3 cột
read_csv("1,2,3 
         4,5,6") # tên các cột là "1", "2", và "3"
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
         4,5,6", col_names = FALSE) # readr tự động đặt tên các cột X1, X2, X3
```

```
## # A tibble: 2 × 3
##      X1    X2    X3
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     5     6
```

- Trong nhiều file dữ liệu các hàng đầu tiên là các mô tả về dữ liệu nên khi sử dụng readr, bạn đọc có thể sử dụng tùy biến $skip = k$ để loại bỏ $k$ dòng đầu tiên trong file dữ liệu.

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
Bạn đọc cũng có thể sử dụng tham số $col_names$ để gán giá trị cho tên các cột, tuy nhiên lời khuyên của chúng tôi là bạn đọc hãy đặt tên cho các cột bằng hàm $names()$ sau khi lưu dữ liệu vào tibble để tránh sự phức tạp không đáng có.

Cách sử dụng các hàm khác ngoài `read_csv()` bạn đọc có thể tham khảo trong hướng dẫn của gói lệnh $readr$. Sau khi đọc qua hướng dẫn, bạn đọc hãy thử kiểm tra xem các câu lệnh sau có vấn đề gì và nếu có thể, bạn đọc hãy thử lựa chọn hàm hoặc thêm tham số phù hợp để đọc dữ liệu


```r
read_csv("x,y\n1,2,3\n4,5,6") # \n thay cho xuống dòng
read_csv("x,y,z\n1,2\n1,2,3,4") 
read_csv("x,y\n\",1,\n,a,b",col_names = FALSE) 
read_csv("x;y\n1;2\nx;y") # Thử hàm số khác
read_csv("x|y\n1|2") # Thử hàm số khác
```

### Tương tác giữa R và Microsoft Excel

#### Đọc dữ liệu lưu dưới định dạng của Excel
Microsoft Excel là rất phổ biến trong môi trường làm việc công sở. Do đó, dữ liệu nhận sẽ có thể là các file định dạng (.xls, .xlsx, .xlsb, .xlsm ... ). Các gói lệnh $openxlsx$ và $readxl$ thường được sử dụng để đọc dữ liệu từ các file có định dạng như vậy.

#### Tương tác với Microsoft Excel bằng gói lệnh $openxlsx$
Ngoài việc lấy dữ liệu từ các file được lưu dưới định dạnh của Excel, bạn đọc cũng có thể sử dụng gói lệnh $openxlsx$ để làm việc với các excel workbook thay vì làm việc trực tiếp trên workbook. 


### Lấy dữ liệu từ một hệ cơ sở dữ liệu
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
TIP: Khi làm việc với dữ liệu được trích xuất từ một hệ cơ sở dữ liệu, bạn đọc hãy cố gắng thực hiện các phép biến đổi, sắp xếp dữ liệu bằng SQL thay vì thực hiện biến đổi trên R vì các hệ quản trị cơ sở dữ liệu thực hiện các chức năng này nhanh hơn R rất nhiều.

## Bài tập


## Phụ lục








# Tiền xử lý dữ liệu
Tiền xử lý dữ liệu là một công việc đòi hỏi sự tỉ mỉ, cẩn thận và cũng là một trong những bước quan trọng nhất trong một quy trình làm việc với dữ liệu. Tiền xử lý dữ liệu là tập hợp tất cả các bước kỹ thuật nhằm đảm bảo cho dữ liệu bạn sử dụng để phân tích được đảm bảo về định dạng, giá trị và ý nghĩa. Hiểu một cách đơn giản, tiền xử lý dữ liệu là biến dữ liệu thô thành dữ liệu có thể sử dụng được để phân tích và đưa ra kết quả.

Khi làm việc với dữ liệu, thực tế là đến hơn 50\% các trường hợp bạn đọc sẽ nhận được những dự liệu dạng thô chưa qua xử lý. Nếu những dữ liệu này được nhập và xuất ra qua một hệ thống được phát triển đầy đủ, tiền xử lý dữ liệu chỉ cần qua một vài bước cơ bản để đi đến kết quả. Trong trường hợp dữ liệu bạn nhận được là dữ liệu được nhập một cách thủ công, thông qua nhiều người nhập thì đây thực sự sẽ là một vấn đề lớn. Tiền xử lý dữ liệu trong hoàn cảnh như vậy có thể chiếm 80\% - 90\% thời gian công việc của bạn!.  

## Tiền xử lý dữ liệu là gì?

Các vấn đề thường gặp phải khi làm việc với một dữ liệu từ các nguồn khác nhau thường xuất phát từ hai vấn đề

- Dữ liệu sai định dạng: trong cùng một cột dữ liệu có các biến kiểu khác nhau hoặc kiểu của biến không đúng như quy ước.

- Dữ liệu chứa giá trị không quan sát được hoặc chứa các giá trị ngoại lai (outliers).

Ví dụ như bạn đọc nhận được dữ liệu về 3 ứng cử viên từ bộ phận nhân sự như sau với yêu cầu về cho biết độ tuổi trung bình của những ứng cử viên và tỷ lệ Nam/Nữ ứng tuyển


<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-27)Dữ liệu thô từ nguồn bên ngoài</caption>
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

Đây là một dữ liệu không thể sử dụng để phân tích được bởi vì giá trị trong các cột ngày sinh là không đúng định dạng ngày tháng đồng thời có các giá trị không quan sát được ở cột giới tính. Nếu sử dụng dữ liệu này để phân tích mà bỏ qua việc tiền xử lý dữ liệu thì kết quả sẽ sai lệch hoàn toàn so với bản chất của dữ liệu:

- Tính độ tuổi trung bình của các ứng cử viên là không thể thực hiện được với dữ liệu này bởi vì cột ngày sinh đang là dạng chuỗi ký tự và định dạng ngày tháng là rất lộn xộn  

- Nếu bỏ qua những giá trị không có quan sát, tỷ lệ giới tính Nam là 100\%. Liệu con số này có thực sự đúng?

Tiền xử lý dữ liệu không chỉ bao gồm các công cụ kỹ thuật mà còn yêu cầu cả kiến thức phổ thông và kiến thức nghiệp vụ của người làm dữ liệu. Khi có vấn đề gây khó hiểu về dữ liệu nhận được, điều hết cần làm đó là liên hệ với người chủ dữ liệu để kiểm tra lại thông tin. Khi việc này là không thể thực hiện được, người xử lý dữ liệu sẽ phải đưa ra các phán đoán về dữ liệu đó dựa trên hiểu biết của mình.

Với cột ngày sinh của các nhân viên:

- Giá trị "01/02/98" có khả năng cao là ngày 01 tháng 02 năm 1998 do quy ước phổ biến ở Việt Nam là viết theo thứ tự ngày -> tháng -> năm. 

- Giá trị "12/17/1999" có khả năng cao là ngày 17 tháng 12 năm 1999. Khi gặp các trường hợp này nhiều khả năng người nhập dữ liệu sử dụng format ngày tháng của Microsoft Excel.

- Giá trị "1-1-1992" có khả năng cao là ngày 01 tháng 01 năm 1992.

Như vậy với mỗi giá trị trong cột ngày sinh, bạn đọc cần một phép biến đổi khác nhau

```r
DOB<-rep(as.Date("1900-01-01"),3) # tạo vector dạng date độ dài 3
DOB[1]<-as.Date("01/02/98", format = "%d/%m/%y")
DOB[2]<-as.Date("12/17/1999", format = "%m/%d/%Y")
DOB[3]<-as.Date("1-1-1992", format = "%d-%m-%Y")
```
Vec-tơ $DOB$ chứa giá trị ngày sinh dạng ngày tháng của các ứng cử viên và bạn đọc đã có thể sử dụng các hàm số có sẵn để tính tuổi của các ứng cử viên. 

Với cột giới tính của nhân viên:

- Giới tính của ứng cử viên Trần Văn Cường là không quan sát được tuy nhiên theo tên của ứng cử viên thì nhiều khả năng đây là Nam.

- Giới tính của ứng cử viên Lê Thị Loan là không quan sát được tuy nhiên theo tên của ứng cử viên thì nhiều khả năng đây là Nữ.

Sau những bước xử lý như trên, chúng ta đã có một dữ liệu được định dạng chính xác và đã có thể đưa ra các phân tích về dữ liệu



<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-30)Dữ liệu sau tiền xử lý</caption>
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

Đây là một ví dụ điển hình của tiền xử lý dữ liệu. Dữ liệu bạn đọc nhận được sẽ hiếm khi được định dạng chuẩn và sẵn sàng để phân tích giống như những dữ liệu sẵn có trên R. Để xử lý những giá trị sai định dạng, và điền vào dữ liệu các giá trị không quan sát, loại bỏ các giá trị ngoại lai, ..., người làm dữ liệu phải sử dụng kiến thức phổ thông và kiến thức nghiệp vụ để dưa ra dự đoán tốt nhất có thể.

## Định dạng lại các cột dữ liệu sử dụng thư viện $readr$

### Quy tắc định đạng cột của $readr$
Mỗi thư viện đọc dữ liệu sẽ có các quy tắc khác nhau khi đọc và định dạng lại dữ liệu khi lưu trên R. Chúng ta sẽ tập trung vào cách thư viện "readr" đọc dữ liệu. Khi đọc một file vào R, các hàm đọc dữ liệu của thư viện $readr$ cố gắng dự đoán kiểu dữ liệu của từng cột bằng cách sử dụng 1000 hàng dữ liệu đầu tiên dựa trên nguyên tắc như sau:


<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Giá trị trong cột dữ liệu </th>
   <th style="text-align:left;"> $readr$ dự đoán </th>
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
   <td style="text-align:left;"> Lê Thị Loan </td>
   <td style="text-align:left;"> 1-1-1992 </td>
  </tr>
</tbody>
</table>

Lưu ý rằng các giá trị không quan sát được không ảnh hưởng đến việc $readr$ dự đoán kiểu dữ liệu của một cột. Khi đọc dữ liệu kiểu số, việc sử dụng dấu thập phân là '.' (dữ liệu từ các nước sử dụng ngôn ngữ tiếng Anh) hay ',' (dữ liệu từ Việt Nam, Pháp) có thể làm cho giá trị của biến kiểu số thay đổi về bản chất. Bạn đọc không sử dụng tham số nào khác khi sử dụng $readr$, số thập phân luôn được hiểu là '.' khi bạn đọc sử dụng read_csv() và số thập phân sẽ là ',' nếu bạn đọc dùng read_csv2().

```r
file<-"C1;C2;C3;C4; C5
         1e-10;2.2;1.0;TRUE; 1.0.0.0
         Inf;3,2;1,000.0;1;10%" 
read_csv2(file)
```

```
## # A tibble: 2 × 5
##        C1    C2    C3 C4    C5     
##     <dbl> <dbl> <dbl> <chr> <chr>  
## 1   1e-10  22      10 TRUE  1.0.0.0
## 2 Inf       3.2     1 1     10%
```

Từ kết quả trên có thể thấy rằng $readr$ sẽ bỏ qua dấu ',' trong các số khi bạn đọc dùng read_csv() và bỏ qua '.' với biến kiểu số khi bạn đọc dùng read_csv2(). Đối với biến kiểu logic, bạn đọc có thể kiểm tra kiểu dữ liệu của các cột dưới đây đều là kiểu logic sau khi dữ liệu được đọc bằng read_csv()

```r
file<-"X1,X2,X3,X4,X5,X6
        TRUE,t,True,false,F,
        F,F,FALSE,T,f,True"
read_csv(file)
```

```
## # A tibble: 2 × 6
##   X1    X2    X3    X4    X5    X6   
##   <lgl> <lgl> <lgl> <lgl> <lgl> <lgl>
## 1 TRUE  TRUE  TRUE  FALSE FALSE NA   
## 2 FALSE FALSE FALSE TRUE  FALSE TRUE
```
Để hiểu kỹ hơn cách $readr$ dự đoán kiểu giá trị trong cột, bạn đọc có thể đọc hướng dẫn của hàm `guess_parse()`.

### Định dạng cột bằng các hàm `parse_*()`
Với các cột mà không thể xác định được kiểu dữ liệu, thư viện $readr$ sẽ lưu dưới dạng vec-tơ kiểu chuỗi ký tự. Để làm việc được trên dữ liệu, bạn đọc cần định dạng lại các cột cho đúng với mong muốn. Các hàm thuộc nhóm `parse_*()` trong thư viện $readr$ hỗ trợ bạn đọc làm việc này. Nhóm hàm `parse_*()` có đầu vào là một véc-tơ kiểu chuỗi ký tự và đầu ra sẽ là kiểu dữ liệu mà bạn đọc mong muốn. Đối với mỗi kiểu dữ liệu, hàm `parse_*()` tương ứng sẽ có các tùy biến phù hợp. Trong phần tiếp theo của cuốn sách chúng tôi sẽ lần lượt giới thiệu các nhóm hàm `parse_*()` tương ứng với biến kiểu logic, biến kiểu số, biến kiểu thời gian và biến kiểu chuỗi ký tự. 

#### Định dạng véc-tơ kiểu logic.
Định dạng lại một véc-tơ kiểu chuỗi ký tự thành kiểu logic là đơn giản nhất. Hàm số sử dụng trong trường hợp này là `parse_logical()`. Bạn đọc hãy quan sát ví dụ sau:

```r
x<-c("TRUE","True","1","0","2",".","@","FALSE","false","f","F","T","t","true","false")
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

Bạn đọc có thể thấy rằng tất cả các giá trị nằm trong véc-tơ $x$ ở trên, ngoại trừ hai ký tự đặc biệt đã được khai báo trong hàm `parse_logical()` là $"."$ và $"@"$, thì chỉ có số 2 là không thể đổi sang biến kiểu logic. `parse_logical()` tự động đổi ký tự $"1"$ thành $TRUE$ và ký tự $"0"$ thành $FALSE$. Trong trường hợp véc-tơ $x$ có kích thước lớn, các phần tử không thể đổi sang kiểu logic sẽ được lưu vào một $tibble$. Bạn đọc sử dụng hàm `problems()` để lấy các các giá trị này.

```r
x1<-sample(x, 10^4, replace = TRUE)
y<-parse_logical(x1)
problems(y)
```

```
## # A tibble: 1,955 × 4
##      row   col expected           actual
##    <int> <int> <chr>              <chr> 
##  1     2    NA 1/0/T/F/TRUE/FALSE 2     
##  2     5    NA 1/0/T/F/TRUE/FALSE .     
##  3     7    NA 1/0/T/F/TRUE/FALSE 2     
##  4     8    NA 1/0/T/F/TRUE/FALSE .     
##  5    11    NA 1/0/T/F/TRUE/FALSE @     
##  6    15    NA 1/0/T/F/TRUE/FALSE .     
##  7    19    NA 1/0/T/F/TRUE/FALSE .     
##  8    23    NA 1/0/T/F/TRUE/FALSE @     
##  9    24    NA 1/0/T/F/TRUE/FALSE 2     
## 10    25    NA 1/0/T/F/TRUE/FALSE 2     
## # ℹ 1,945 more rows
```

Cột $row$ cho biết vị trí của các phần tử trong véc-tơ $x1$ không thể đổi sang kiểu logic. Giá trị của các phần tử này nằm trong cột $actual$. Bạn đọc có thể quan sát các giá trị trong cột $actual$ để tìm hiểu nguyên nhân tại sao `parse_logical()` không thể hoạt động trên các giá trị này.

#### Định dạng véc-tơ kiểu số.
Khi $readr$ không thể tự định dạng một véc-tơ có kiểu số, các vấn đề thường gặp phải là:

- Cách đánh số thập phân của các số trong véc-tơ. Tại Việt Nam số thập phân được sử dụng là dấu "," trong khi R hiểu số thập phân là dấu ".". Nhiều quốc gia khác trên thế giới cũng sử dụng dấu thập phân là dấu ",".

- Cách viết các số sử dụng cùng với các ký tự "." hoặc "," để người đọc dễ dàng đọc số đó. Chẳng hạn như tại Việt Nam, chúng ta viết số 1 tỷ như sau: 1.000.000.000; tại Thụy Sỹ số 1 tỷ được viết thành 1'000'000'000; chúng ta cần định dạng lại cho các giá trị kiểu như vậy để R hiểu được đây là các con số.

- Khi các con số đi kèm theo đơn vị, chẳng hạn như đi kèm với ký hiệu tiền tệ: "100.000 đồng", "100.000 vnd", hoặc đi kèm với ký hiệu % như "50%", chúng ta $readr$ cũng sẽ không thể tự động chuyển đổi sang kiểu số.

Bạn đọc có thể sử dụng `parse_double()` hoặc `parse_number()` khi gặp phải các vấn đề ở trên. Chẳng hạn như khi gặp vấn đề về dấu "," đối với dấu thập phân (với các số thập phân viết theo kiểu Việt Nam), bạn đọc sử dụng `parse_number()` với tùy biến `locale = locale(decimal_mark = ",")` để định dạng cho véc-tơ kiểu ký tự:

```r
x<-c("0,5","1,5") # véc-tơ chứa các số 0,5 và 1,5; dấu thập phân là dấu ","
parse_number(x, locale = locale(decimal_mark = ","))
```

```
## [1] 0.5 1.5
```

Khi gặp phải vấn đề về thứ hai, chúng ta sử dụng tùy biến $grouping\_mark$ trong hàm $locate()$. Trong ví dụ dưới đây sử dụng đồng thời hai tùy biến $decimal\_mark$ và $grouping\_mark$ của hàm `locate()`

```r
x<-c("1.000,5","1.000.000,5") # véc-tơ chứa các số 1000,5 và 1000000,5; dấu thập phân là dấu ","
parse_number(x, locale = locale(decimal_mark = ",",
                                grouping_mark = "."))
```

```
## [1]    1000.5 1000000.5
```

Khi gặp phải chuỗi ký tự chứa biến kiểu số đi kèm với đơn vị tiền tệ, hoặc dấu "%", hàm $parse_number()$ vẫn rất hiệu quả trong việc đổi chuỗi ký tự về kiểu số

```r
x<-c("1.000,5 đồng","1.000.000,5 vnd")
parse_number(x, locale = locale(decimal_mark = ",",
                                grouping_mark = "."))
```

```
## [1]    1000.5 1000000.5
```

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

Hai tùy biến của hàm `parse_datetime()` mà bạn đọc cần lưu ý là $na$ và $format$. Tùy biến $na$ như đã sử dụng ở phần trước là một véc-tơ chứa các giá trị mà bạn đọc cho rằng đây là các giá trị không quan sát được. Trong véc-tơ $x$ ở trên, giá trị "01#01#1990" nếu không có trong tùy biến $na$ sẽ có kết quả là một ngày tháng có ý nghĩa trong véc-tơ kết quả. Tuy nhiên, bằng một cách nào đó, nếu bạn đọc biết rằng giá trị này do người nhập liệu đưa vào do không quan sát được biến đó, việc chuyển đổi biến thành giá trị ngày tháng sẽ làm sai lệch phân tích. Do đó bạn đọc cần khai báo giá trị này vào trong véc-tơ $na$.

Tùy biến $format$ trong hàm `parse_datetime()` là để bạn đọc gợi ý cho R định dạng của biến kiểu ngày tháng. Khi gán giá trị cho $format$ bạn đọc cần lưu ý

- Mỗi thành phần của biến thời gian (ngày, tháng, năm, giờ, phút, giây,...) được định nghĩa bắt đầu bằng $"%"$ và theo sau 1 chữ cái, chẳng hạn như bạn đọc sử dụng "%Y" khi muốn nói với R rằng biến kiểu thời gian nằm trong chuỗi ký tự được sử dụng 4 chữ số để chỉ định.

- Các ký tự không liên quan đến các thành phần của thời gian, ngoại trừ các khoảng trắng phía trước và sau biến thời gian, cần phải được khai báo chính xác.


```r
x<-c(" 1@2@2023-23#25#01  ", "  23@10@2023-01#06#59 ", "01@01@2023-00:00:00")
parse_datetime(x, format = "%d@%m@%Y-%H#%M#%S")
```

```
## [1] "2023-02-01 23:25:01 UTC" "2023-10-23 01:06:59 UTC"
## [3] NA
```

Từ ví dụ trên bạn đọc có thể thấy rằng 

- Cần khai báo chính xác các ký tự nằm giữa các biến thời gian. Ký tự $"@"$ nằm giữa các giá trị ngày, tháng, năm; phân tách giữa ngày tháng với thời gian trong ngày là ký tự $"-"$; phân tách giữa các thành phần của thời gian trong ngày là ký tự $"#"$. Tất cả đều cần phải được khai báo chính xác với tùy biến $format$. Giá trị thứ ba trong véc-tơ $x$ gặp vấn đề vì phân tách giữa các thành phần của thời gian trong ngày sử dụng dấu ":"

- Các khoảng trắng nằm trước và sau các chuỗi ký tự được bỏ qua và không ảnh hưởng đến kết quả.

Để biết chính xác cách gán giá trị cho tùy biến $format$, bạn đọc nên tham khảo hướng dẫn sử dụng hàm `parse_datetime()`. Chúng tôi tóm tắt cách định dạng các thành phần của một biến thời gian trong bảng dưới đây:



<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
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

Lưu ý rằng khi bạn đọc sử dụng %y, các ký tự "00" đến "69" sẽ được chuyển thành năm 2000 đến năm 2069 trong khi các ký tự từ "70" đến 99 sẽ được chuyển thành năm 1970 đến 1999. Ngoài ra, thành phần tháng của biến thời gian trong nhiều dữ liệu thường được viết dưới dạng chuỗi ký tự thay vì sử dụng số. Do đó bạn đọc cần các gợi ý %b hoặc %B để R có thể hiểu được:


```r
x<-c("sep 21, 23 ", "  JAN 1, 69 ", "Dec 25, 70")
parse_datetime(x, format = "%b %d, %y")
```

```
## [1] "2023-09-21 UTC" "1969-01-01 UTC" "1970-12-25 UTC"
```

### Định dạng cột kiểu chuỗi ký tự
Khi bạn đọc dùng $readr$ để đọc dữ liệu từ nguồn ngoài vào R, cột dữ liệu không rõ định dạng sẽ được lưu dưới dạng véc-tơ chuỗi ký tự. Vậy tại sao cần định dạng lại thành véc-tơ kiểu chuỗi ký tự? Nghe có vẻ vô lý nhưng đây lại là vấn đề phức tạp nhất trong định dạng lại cột dữ liệu. Để hiểu vấn đề này bạn đọc cần tìm hiểu một chút về cách máy tính điện tử lưu và mở một chuỗi ký tự. Giả sử bạn đọc muốn gửi một dữ liệu chứa ký tự "a" đến một máy tính khác. Sau khi viết ký tự "a" lên một phần mềm soạn thảo văn bản nào, bạn đọc sẽ cần lưu ký tự "a" lên máy tính của bạn. Tất nhiên máy tính của bạn sẽ không thể ghi nhớ chữ "a" một cách tượng hình mà sẽ mã hóa (hay thuật ngữ chuyên ngành gọi là $encode$) chữ "a" thành một đoạn mã nhị phân bao gồm 0 và 1 mà máy tính có thể lưu được. Khi bạn gửi dữ liệu sang một máy tính khác, đoạn mã bao gồm 0 và 1 đó sẽ được gửi đi. Khi máy tính điện tử khác mở dữ liệu, đoạn mã nhị phân sẽ được giải mã (thuật ngữ chuyên ngành gọi là $decode$) để hiển thị. Sẽ không có vấn đề gì xảy ra nếu quy tắc mã hóa và giải mã được thống nhất và chữ "a" sẽ được hiển thị chính xác trên máy tính thứ hai.

Thực tế là trước khi có bộ mã hóa và quy tắc mã hóa chung được công nhận rộng rãi như Unicode và UTF-8, rất khó để có sự thống nhất quy tắc mã hóa ký tự. May mắn là đến thời điểm chúng tôi viết cuốn sách này đa số các hệ điều hành, hệ soạn thảo văn bản,... đều sử dụng bảng mã Unicode và bộ mã hóa UTF-8. Giải thích chi tiết về bộ mã hóa hay quy tắc mã hóa là rất phức tạp và vượt quá nội dung của cuốn sách này. Chúng tôi chỉ cần bạn đọc hiểu về Unicode và UTF-8 như sau:

- Unicode là một bảng mã chuẩn được công nhận rộng rãi cho biết quy tắc cho tương ứng hầu hết các ký tự từ đơn giản đến phức tạp, kể cả các ngôn ngữ sử dụng ký tự tượng hình phức tạp như chữ Hán của tiếng Trung Quốc, tiếng Nhật, chữ Nôm của tiếng Việt, với một số nằm giữa số 0 đến số $10FFFF$ khi viết theo hệ 16. Một số khi viết trong hệ 16 có thể sử dụng (0, 1, ..., 9, A, B, C, D, E, F) để biểu diễn, do đó số các ký tự mà bảng mã Unicode có thể đưa vào là $16^4 + 16^5 = 1.114.112$ ký tự, bao gồm $16^5$ số từ 0 đến FFFFF và $16^4$ số từ 100000 đến 10FFFF. 

- UTF-8 là quy tắc lưu các số viết trong hệ 16 của bảng mã Unicode thành các chuỗi nhị phân 0 và 1 mà máy tính có thể phân biệt được. Số 8 ở đây có nghĩa là 8 bit hay một byte là 8 giá trị 0 và 1 đứng liền nhau. Một ký tự bất kỳ trong bảng mã Unicode đều có thể được mã hóa thành 1, 2, 3 hoặc nhiều byte theo quy tắc mã hóa UTF-8.

Quay trở lại vấn đề định dạng lại dữ liệu kiểu chuỗi ký tự, sẽ không có vấn đề xảy ra nếu người nhập liệu sử dụng bộ mã hóa UTF-8 bởi $readr$ luôn sử dụng UTF-8 để giải mã. Trong thực tế thì vẫn còn một số hệ thống, hoặc hệ soạn thảo văn bản sử dụng cách mã hóa không tương thích với UTF-8. Giả sử khi đọc một dữ liệu từ nguồn ngoài vào bằng `read_csv()` và cho kết quả như sau

```r
x<-read_csv("../KHDL_KTKD/Dataset/Book1.csv")
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

Cột $A$ của dữ liệu đã không được lưu bằng mã hóa UTF-8 nên thư viện $readr$ không hiển thị được các giá trị có ý nghĩa. Để định dạng lại cột dữ liệu, bạn đọc sử dụng hàm `parse_character()` với tùy biến $encoding$. Không dễ để biết được dữ liệu đã được mã hóa bằng bộ mã hóa nào. Thư viện $readr$ cung cấp hàm `guess_encoding()` hỗ trợ bạn đọc dự đoán một biến kiểu chuỗi ký tự đã được mã hóa bẳng bộ mã hóa nào. Tuy nhiên trải nghiệm của chúng tôi với hàm số này là không tốt. Lời khuyên của chúng tôi là bạn đọc nếu có thể hãy tìm hiểu nguồn gốc của dữ liệu: dữ liệu được sính ra từ đâu, hệ thống nào,... Trong trường hợp việc này là không thê, bạn đọc hãy thử giải mã đoạn văn bản bằng một số bộ mã hóa thường gặp cho đến khi gặp được kết quả mong muốn! Trong trường hợp dữ liệu ở trên do nguồn là tiếng Việt nên chúng ta có thể thử các

```r
parse_character(x$A, locale = locale(encoding = "Latin2"))
```

```
## [1] "lę"     "táo"    "quýt"   "cŕ tím" "mít"
```

Kết quả khi sử dụng bộ mã $Latin2$ đã cho một vài giá trị có ý nghĩa, chúng ta tiếp tục thử với $Latin1$

```r
parse_character(x$A, locale = locale(encoding = "Latin1"))
```

```
## [1] "lê"     "táo"    "quýt"   "cà tím" "mít"
```

May mắn là cột dữ liệu đều đã có thể đọc được với chúng ta. Đối với cột $B$ của dữ liệu bạn đọc có thể sử dụng `parse_numbder()` như đã trình bày ở trên. Dữ liệu sau khi được định dạng lại đã dễ hiểu hơn rất nhiều

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



## Giá trị ngoại lai và giá trị không quan sát được.

Giá trị không quan sát được là các giá trị xuất hiện dưới dạng $NA$ trong dữ liệu sau khi nhập vào R. Có nhiều lý do khác nhau dẫn đến việc dữ liệu không quan sát được, chẳng hạn như thông tin do người làm dữ liệu cung cấp không đầy đủ, những người cung cấp dữ liệu từ chối chia sẻ thông tin, hệ thống quản lý dữ liệu bị lỗi, hoặc cũng có thể do người quản lý xóa dữ liệu vì lý do bảo mật. Giá trị không quan sát được ngoài các giá trị $NA$ xuất hiện trong dữ liệu, mà còn là các giá trị không phù hợp với kiểu dữ liệu hoặc miền giá trị của cột dữ liệu. Đối với một vài hệ thống khi dữ liệu được xuất ra giá trị không quan sát được vẫn được ghi nhận bằng một giá trị nào đó. Bạn đọc cần cẩn trọng khi làm việc với những dữ liệu kiểu như vậy.

Giá trị ngoại lai hay còn được gọi là giá trị bất thường là một điểm dữ liệu hoặc một quan sát sai khác đáng kể so với đa số các quan sát khác. Một giá trị ngoại lai xuất hiện trong dữ liệu có thể là do lỗi trong quản lý dữ liệu, do sai số trong đo lường hoặc cũng có thể do bản chất phân phối của dữ liệu. Tùy theo nguồn gôc của giá trị ngoại lai mà chúng ta có cách xử lý dữ liệu khác nhau.

Khi không được xử lý thích hợp, giá trị không quan sát được và các giá trị ngoại lai có thể làm sai lệch kết luận của tất cả các phân tích về dữ liệu, khiến người quản lý đưa ra quyết định sai lầm. Bạn đọc quan sát ví dụ sau:


```
## # A tibble: 4 × 6
##   MSV      Name            Age                Gender `Height (cm)` `Weight (kg)`
##   <chr>    <chr>           <chr>              <chr>          <dbl>         <dbl>
## 1 MSV00001 12345           30                 Nam             1.76            68
## 2 MSV43241 Nguyễn Văn An   Nhập sai ngày sinh N             169               72
## 3 MSV65432 Lê Thị Loan     -1                 Nữ            155               48
## 4 MSV34    Trần Mạnh Cường 15                 <NA>          175              150
```

Trong dữ liệu ở trên, mặc dù chỉ có 1 giá trị đang là $NA$ ở cột giới tính nhưng nếu quan sát kỹ bạn đọc sẽ nhận ra rằng:

- Cột $name$: giá trị "12345" không thể là tên của một sinh viên, do đó đây cũng là một giá trị không quan sát được.

- Cột $Age$: thứ nhất, giá trị ở hàng thứ hai của cột $Age$ là kiểu chuỗi ký tự. Thứ hai, tuổi của một sinh viên không thể là số âm, nên giá trị $-1$ không phù hợp với miền giá trị của cột này. Cột $Age$ có hai giá trị không quan sát được.

- Cột $Gender$: có giá trị là ký tự $N$ không rõ là thể hiện cho giới tính Nam hay Nữ, giá trị này cũng là không quan sát được.

- Cột $MSV$: Giả sử bằng một cách nào đó, bạn đọc biết rằng mã sinh viên phải là một đoạn ký tự có độ dài là 8, bao gồm đoạn ký tự "MSV" và theo sau là 5 chữ số, thì giá trị "MS34" cũng là một giá trị không quan sát được ở cột mã sinh viên. 

Để xác định dữ liệu có giá trị ngoại lai hay không cần sử dụng các kiến thức về thống kê toán:

- Cột $Height$ có giá trị chiều cao ở hàng thứ nhất là 1,76 cm. Giá trị này quá nhỏ để làm chiều cao của một người bình thường. Nhiều khả năng khi đo chiều cao của sinh viên, người nhập dữ liệu đã ghi lại theo đơn vị mét.

- Cột $Weight$ có giá trị cân nặng của hàng thứ 4 là 150 kg. Mặc dù dữ liệu có rất ít quan sát để đưa ra kết luận phân phối xác suất của cân nặng của sinh viên là gì, tuy nhiên với kiến thức thực tế chúng ta có thể kết luận rằng 150 kg là một cân nặng lớn bất thường với các giá trị cân nặng còn lại. Đây nhiều khả năng là một giá trị ngoại lai.

Để xác định các giá trị không quan sát được và giá trị ngoại lai tùy thuộc vào từng dữ liệu cụ thể và kiến thức tổng hợp và kiến thức chuyên môn của người xử lý dữ liệu và nằm ngoài phạm vi thảo luận của cuốn sách này. Dữ liệu ở trên chỉ là một dữ liệu nhỏ và đơn giản nên việc xác định các giá trị không quan sát được và giá trị ngoại lai là không khó. Chúng ta biến đổi các giá trị không quan sát được thành $NA$ như sau


```r
df$MSV[(nchar(df$MSV)!=8)]<-NA # mã sinh viên không có 8 ký tự là không quan sát được
df$Name[df$Name=="12345"]<-NA
df$Age<-parse_number(df$Age, na = c("-1")) # tuổi có giá trị (-1) là không quan sát được
df$Gender[df$Gender == "N"]<-NA
```

Đối với các giá trị ngoại lai, chúng ta sẽ đổi giá trị bị ghi nhận sai đơn vị về đúng đơn vị. Với giá trị cân nặng 150 kg, do dữ liệu nhỏ, bạn đọc có thể giữ nguyên giá trị này hoặc thay thế giá trị này bằng giá trị lớn nhất của những người có cân nặng thông thường.


```r
df$Height[1]<-df$Height[1] * 100 # đổi đơn vị đo từ mét sang cm
```

Dữ liệu sau khi xử lý giá trị ngoại lai và định nghĩa lại các giá trị không quan sát được như sau:

```r
df
```

```
## # A tibble: 4 × 6
##   MSV      Name              Age Gender `Height (cm)` `Weight (kg)`
##   <chr>    <chr>           <dbl> <chr>          <dbl>         <dbl>
## 1 MSV00001 <NA>               30 Nam             1.76            68
## 2 MSV43241 Nguyễn Văn An      NA <NA>          169               72
## 3 MSV65432 Lê Thị Loan        NA Nữ            155               48
## 4 <NA>     Trần Mạnh Cường    15 <NA>          175              150
```

Hàm số `is.na(df)` trả lại giá trị là $TRUE$ nếu dữ liệu là quan sát là $NA$ và trả lại giá trị $FALSE$ nếu không phải $NA$. Bạn đọc có thể dùng hàm `is.na()` kết hợp với hàm `sum()` để tính toán mỗi cột có bao nhiêu giá trị không quan sát được và tỷ lệ số giá trị không quan sát được trên mỗi cột là bao nhiêu:

```r
sapply(df,function(x) sum(is.na(x))) # cho biết mỗi cột dữ liệu có bao nhiêu giá trị NA
```

```
##         MSV        Name         Age      Gender Height (cm) Weight (kg) 
##           1           1           2           2           0           0
```

```r
sapply(df,function(x) sum(is.na(x))/length(x)) # cho biết tỷ lệ giá trị NA trong mỗi cột
```

```
##         MSV        Name         Age      Gender Height (cm) Weight (kg) 
##        0.25        0.25        0.50        0.50        0.00        0.00
```

Với những dữ liệu nhỏ thì hiển thị trực tiếp số lượng giá trị $NA$ trong mỗi cột là hiệu quả nhất. Khi dữ liệu có nhiều quan sát và nhiều biến, bạn đọc nên sử dụng đồ thị để mô tả số lượng hoặc tỷ lệ giá trị không quan sát được của mỗi cột. Ví dụ như với dữ liệu $gapminder$ của thư viện $dslabs$, sử dụng đồ thị $barplot$ để mô tả giá trị không quan sát được sẽ hiệu quả hơn:

```r
y<-sapply(gapminder,function(x) sum(is.na(x))/length(x)*100) # cho biết tỷ lệ giá trị NA trong mỗi cột
barplot(sort(y), main = "Tỷ lệ giá trị không quan sát được",
        ylab = "Đơn vị %",
        xlab = "",
        col = "lightskyblue")
```

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-54-1.png" width="672" style="display: block; margin: auto;" />

Xử lý giá trị không quan sát được dựa trên kinh nghiệm và hiểu biết về dữ liệu của bạn đọc luôn là ưu tiên trước tiên. Nếu chúng ta không có kinh nghiệm và hiểu biết về dữ liệu, các kỹ thuật xử lý dựa trên các nguyên tắc của xác suất thống kê sẽ được sử dụng.

### Giá trị ngoại lai.
Giá trị ngoại lai, hay còn gọi là giá trị bất thường, là những giá trị mà khác xa tập hợp các giá trị còn lại. Không có một định nghĩa định lượng chính xác nào cho khái niệm như thế nào là khác xa các giá trị còn lại. Do đó, tùy theo bản chất của dữ liệu và tùy theo quan điểm của người phân tích dữ liệu mà một hay một số giá trị có khả năng là giá trị ngoại lai hay không. Giá trị ngoại lai thường chỉ được nhắc đến với các dữ liệu có số quan sát đủ lớn để đưa ra kết luận có ý nghĩa thống kê.

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-55-1.png" width="960" />

Khi dữ liệu có 10 quan sát như hình bên trái, có 8 quan sát màu xanh da trời nằm gần nhau hơn, điểm màu cam hơi xa hơn tập hợp các điểm màu xanh da trời một chút, còn điểm màu đỏ nằm xa hơn. Khi gặp dữ liệu như vậy, chúng ta có thể kết luận điểm màu đỏ là giá trị ngoại lai, còn kết luận điểm màu cam có phải ngoại lai hay không thì còn tùy thuộc vào ý tưởng của người phân tích dữ liệu. Chuyển sang hình bên phải với dữ liệu có 100 quan sát. Các điểm màu xanh da trời định hình khá rõ miền giá trị của trung tâm của dữ liệu là nằm xung quanh điểm (3,3). Chúng ta có thể kết luận một cách khá chắc chắn rằng điểm màu đỏ là một giá trị ngoại lai. Điểm màu cam, mặc dù nằm khá xa trung tâm của dữ liệu, nhưng để kết luận rằng có phải giá trị ngoại lai hay không vẫn phụ thuộc vào ý tưởng của người phân tích.

Nguồn gốc của giá trị ngoại lai là có thể có nhiều nguyên nhân khác nhau, bao gồm cả nguyên nhân khách quan hoặc nguyên nhân chủ quan. Các nguyên nhân khách quan có thể do nguồn sinh dữ liệu, hay hệ thống quản lý dữ liệu gặp sự cố, do lỗi trong quá trình truyền hoặc sao chép dữ liệu. Nguyên nhân chủ quan bao gồm có các hành vi gian lận, lỗi nhập và sao chép dữ liệu của con người, hoặc các giá trị được cố tình đưa vào trong dữ liệu với mục đích lấy phản hồi từ người dùng dữ liệu. 

Nếu không xử lý giá trị ngoại lai kết quả tính toán sẽ bị sai lệch đáng kể. Dữ liệu có kích thước càng nhỏ thì ảnh hưởng của giá trị ngoại lai lại càng lớn. Trong ví dụ ở trên, giả sử bạn đọc cần phân tích sự tác động của biến $X$ (trục nằm ngang) lên biến $Y$ (giá trị trên trục dọc) bằng một mối quan hệ tuyến tính. Hãy quan sát kết quả của phân tích khi chúng ta

1. Giữ nguyên 10 quan sát và phân tích mối liên hệ tuyến tính.

2. Loại bỏ điểm A (màu đỏ) ra và phân tích mối liên hệ tuyến tính.

3. Loại bỏ điểm A (màu đỏ) và điểm B (màu cam) ra để phân tích mối liên hệ tuyến tính.

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-56-1.png" width="1440" />

Khi giữ nguyên 10 điểm dữ liệu để xây dựng mối quan hệ tuyến tính, đường thẳng mô tả mối quan hệ giữa $Y$ và $X$ là nằm trong hình phía bên trái. Đường thẳng này có hệ số góc dương (một đường dốc lên khi đi từ trái sang phải), điều này có nghĩa là biến $X$ có tác động cùng chiều lên biến $Y$. Sau khi loại bỏ điểm A (màu đỏ) và tính toán lại, đường thẳng mô tả mối quan hệ tuyến tính giữa $Y$ và $X$ ở là đường thẳng trong hình ở giữa. Đường thẳng gần như nằm ngang, cho thấy $X$ ít có tác động lên biến $Y$. Sau cùng, trong hình phía bên phải, sau khi loại bỏ các điểm A (màu đỏ) và điểm B (màu cam), đường thẳng mô tả mối quan hệ tuyển tính giữa $Y$ và $X$ là đường dốc xuống, nghĩa là mối tác động của $X$ lên $Y$ là ngược chiều. Bạn đọc có thể thấy rằng kết luận đưa ra sau khi phân tích thay đổi hoàn toàn khi chúng ta có các lựa chọn khác nhau về loại bỏ các giá trị được cho là ngoại lai ra khỏi dữ liệu. Sự tác động của $X$ lên $Y$ từ thuận chiều (hình bên trái) chuyển sang không có mối liên hệ (hình ở giữa) và sau cùng là sự tác động ngược chiều của $X$ lên $Y$ (hình bên phải).

Trong phần tiếp theo chúng thôi sẽ thảo luận về các phương pháp dùng để xác định các giá trị ngoại lai trong dữ liệu.

### Cách phát hiện giá trị ngoại lai
Không có một định nghĩa chính xác như thế nào là giá trị ngoại lai, chính vì thế không có phương pháp tổng thể và thống nhất nào để phát hiện giá trị ngoại lai trong dữ liệu. Với mỗi cách nhìn nhận giá trị ngoại lại khác nhau mà có phương pháp tiếp cận cụ thể để xác định các giá trị đó. Chúng tôi chỉ trình bày các phương pháp chung được chấp nhận rộng rãi bởi những người phân tích dữ liệu. Các phương pháp đơn giản sẽ được trình bày cụ thể ngay trong phần này. Các phương pháp phức tạp hơn đòi hỏi kiến thức của các chương sau của cuốn sách sẽ được trình bày dưới dạng ý tưởng và hàm có sẵn trong thư viện bổ sung.

#### Phát hiện giá trị ngoại lai trong một véc-tơ.
Để xác định một giá trị là giá trị ngoại lai hay không luôn bao gồm hai bước, bước thứ nhất là sử dụng các phương pháp xác suất thống kê để xác định các giá trị có nhiều khả năng là ngoại lai, và bước thứ hai là sử dụng kiến thức chuyên môn hoặc hỏi ý kiến chuyên gia (nếu có thể) để khẳng định lại kết quả từ bước thứ nhất.

Nếu véc-tơ là một véc-tơ kiểu chuỗi ký tự (không phải kiểu factor) thì không có quy tắc rõ ràng nào để xác định giá trị ngoại lai. Một chuỗi ký tự có thể là ngoại lai nếu chuỗi ký tự có độ dài bất thường, có chứa nhiều ký tự bất thường, một chuỗi ký tự không có ý nghĩa, hoặc cũng có thể là một chuỗi ký tự trống,... việc này hoàn toàn phụ thuộc vào cách tiếp cận của người phân tích dữ liệu. Các phương pháp xử lý dữ liệu kiểu chuỗi ký tự hiện đại có khả năng biến đổi một chuỗi ký tự thành một véc-tơ kiểu số. Việc xác định chuỗi ký tự có phải là một giá trị bất thường hay không sẽ liên quan đến việc xác định một véc-tơ kiểu số có phải là một véc-tơ có giá trị bất thường trong một tập hợp các véc-tơ. Các kỹ thuật này vượt quá phạm vi của cuốn sách

Đối với véc-tơ kiểu factor hay véc-tơ kiểu logic, giá trị có khả năng là ngoại lai là các giá trị xuất hiện với tần xuất rất nhỏ. Chẳng hạn như khi mô tả một véc-tơ chứa tên các loại đồ uống được bán trong một siêu thị trong tháng vừa rồi, bạn gặp trường hợp sau:

```r
x<-sample(c("Coca","Pepsi","Red bull","Mirinda","Collagen"),10000,prob = c(4000,3000,2000,2000,5),replace = TRUE)
barplot(sort(table(x)/length(x)),col = "lightskyblue")
```

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-57-1.png" width="672" />

Khi gặp đồ thị như trên, có khả năng đồ uống có tên "Collagen" là giá trị ngoại lai. Nếu siêu thị có bán loại đồ uống này và việc sản phẩm không được khách hàng ưa chuộng, việc xuất hiện với tần xuất thấp là bình thướng và đây không phải là giá trị ngoại lai. Tuy nhiên việc tên sản phẩm xuất hiện trong danh sách bán hàng tháng này dù siêu thị không bán cũng có thể là do lỗi gặp phải trong quản lý hệ thống bán hàng khi đã ghi nhận tên "Collagen" cho một đồ uống khác.

Đối với véc-tơ kiểu số, các giá trị có khả năng là ngoại lai thường là các giá trị nằm ở đuôi của phân phối xác suất. Để biết một véc-tơ kiểu số có giá trị ngoại lai hay không, bạn đọc nên sử dụng đồ thị boxplot. Các điểm nằm phía dưới điểm nhỏ nhất (Q0) và nằm phía trên điểm lớn nhất (Q4) của đồ thị boxplot có nhiều khả năng là các giá trị ngoại lai. Điểm nhỏ nhất và điểm lớn nhất của đồ thị boxplot được xác định dựa trên mức từ phân vị thứ nhất (Q1) và mức tứ phân vị thứ 3 (Q3):
\begin{align}
&&\text{Inter Quartile Range (IQR)} = Q3 - Q1 \\
&&\text{Điểm nhỏ nhất (Q0)} = Q1 - 1.5 \times IQR \\
&&\text{Điểm lớn nhất (Q4)} = Q3 + 1.5 \times IQR
\end{align}

Các giá trị nằm ngoài khoảng $(Q1 - 1,5 \times IQR, Q3 + 1.5 \times IQR)$ có nhiều khả năng là giá trị ngoại lai. Giá trị càng thấp hơn Q0 và càng cao hơn Q4 thì khả năng là giá trị ngoại lai lại càng cao. 

Đồ thị boxplot dưới đây mô tả phân phối của véc-tơ chứa khối lượng giao dịch, tính bằng triệu cổ phiếu/ngày, của cổ phiếu của tập đoàn FLC. Cổ phiếu được niêm yết trên sàn giao dich chứng khoán Thành phố Hồ Chí Minh từ ngày 6 tháng 10 năm 2011 đến ngày 8 tháng 9 năm 2022. Dữ liệu có hơn quan sát.


```r
dat1<-read_csv("../KHDL_KTKD/Dataset/FLC.csv")
dat1%>%filter(year(Date)>=2021)%>%ggplot(aes(y=Volume/10^6))+
  geom_boxplot(fill = "lightskyblue",alpha=0.5)+
  theme_minimal()+
  labs(title = "Khối lượng giao dịch cổ phiếu FLC",
              subtitle = "Đơn vị: Triệu cổ phiếu/ngày",
              caption = "Nguồn dữ liệu: Sở giao dịch chứng khoán TP HCM")+
  theme(legend.position="none")+theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12,face="bold"))+
  ylab("")+xlab("")+
  theme(plot.title = element_text(size = 14, face = "bold"))
```

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-58-1.png" width="672" style="display: block; margin: auto;" />

Chúng ta có thể thấy trên đồ thị boxplot không có điểm nằm dưới Q0. Có 8 quan sát có giá trị lớn hơn Q4; các giá trị này có khả năng là các giá trị ngoại lai. Có 3 quan sát với giá trị lớn hơn 100, nghĩa là có ba ngày mà có hơn 100 triệu cổ phiếu FLC được giao dịch. Nếu có một chút kinh nghiệm về thị trường chứng khoán Việt Nam, bạn đọc có thể kiểm chứng được đây là số lượng cổ phiếu giao dịch lớn bất thường.

Thực tế thì ba phiên giao dịch có khối lượng giao dịch lớn hơn 100 triệu cổ phiếu là các phiên giao dịch ngày 10 tháng 1 năm 2022, ngày 11 tháng 1 năm 2022 và phiên giao dịch ngày 1 tháng 4 năm 2022. Thực tế cho thấy đây là ba phiên giao dịch mà cổ phiếu FLC đã bị thao túng giá và dẫn đến việc cố phiếu FLC bị cấm giao dịch trên sàn giao dịch TP HCM kể từ tháng 09 năm 2022.

- Sau một vài tháng giá cổ phiếu FCL tăng lên gấp 2 lần, đến ngày 10 và ngày 11 tháng 01 năm 2022, các cổ đông chính của FLC bán ra khối lượng rất lớn các cổ phiếu mà không đăng ký với Ủy ban chứng khoán theo quy định. Sau hai phiên giao dịch này giá cổ phiếu FLC giảm mạnh về đến mức trước đó vài tháng.

- Ngày 31 tháng 03 năm 2022 các thông tin giả mạo về nhu cầu mua cổ phiếu FLC với khối lượng lớn được đưa ra (sau nhiều ngày giá cổ phiếu FLC giảm hết biên độ) làm cho nhu cầu mua FLC trong ngày 01 tháng 04 năm 2022 cao đột biến.

Đây là ví dụ điển hình về dữ liệu có giá trị ngoại lai có nguyên nhân chủ quan từ con người. Bạn đọc có thể sử dụng kết hợp đồ thị boxplot và các đồ thị mô tả phân phối của biến liên tục như đồ thị $histogram$ hay đồ thị $density$. Hình vẽ dưới đây mô tả phân phối của chiều cao của 245 nam giới là nhân viên của một công ty. Đơn vị đo chiều cao là $cm$.

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-59-1.png" width="960" style="display: block; margin: auto;" />

Đồ thị boxplot và histogram đều cho thấy trong dữ liệu có các giá trị chiều cao của nam giới xấp xỉ giá trị 0 và nhiều khả năng đây là các giá trị ngoại lai. Đồ thị histogram còn cho thấy có nhiều hơn 1 giá trị có giá trị như vậy. Lọc các giá trị đó ra khỏi véc-tơ chúng ta sẽ thu được 5 giá trị là 1,52; 1,74; 1,70; 1,62; và 1,80. Đây không thể là chiều cao của nam giới đo bằng đơn vị $cm$. Có nhiều khả năng là khi ghi lại chiều cao của các nhân viên này, người nhập dữ liệu đã sử dụng đơn vị là $mét$ thay vì $cm$. Chúng ta có thể sửa các giá trị ngoại lai này bằng cách đổi từ đơn vị $mét$ sang $cm$. Phân phối của chiều cao sau khi sửa lại dữ liệu được mô tả như hình dưới đây:

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-60-1.png" width="960" style="display: block; margin: auto;" />

Véc-tơ kiểu số có mô tả giá trị đo lường, tiền tệ rất thường xuyên gặp vấn đề như kể trên. Ngay khi gặp giá trị ngoại lai trong véc-tơ kiểu số như trên bạn đọc hãy nghĩ đến sai đơn vị đo lường là nguyên nhân đầu tiên.

Ngoài việc sử dụng các tứ phân vị để phát hiện giá trị ngoại lai, một phương pháp định lượng khác cũng thường được đề cập đến trong nhiều tài liệu là sử dụng $Z-Score$. $Z-Score$ được tính bằng khoảng cách từ 1 điểm đến giá trị trung bình của dữ liệu sau đó chia cho độ lệch chuẩn của dữ liệu
\begin{align}
Z-Score(x_i) = \cfrac{|x_i - \bar{x}|}{\sigma(x)}
\end{align}

$Z-Score$ dựa trên giả thiết là dữ liệu có phân phối chuẩn, do đó các điểm dữ liệu có $Z-Score$ lớn, thường sử dũng ngưỡng lớn hơn 3, được coi là các giá trị ngoại lai. Chẳng hạn như khi vẽ $Z-Score$ của tất cả các điểm dữ liệu trong dữ liệu về chiều cao cùa nhân viên, chúng ta sẽ có đồ thị như sau

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-61-1.png" width="672" style="display: block; margin: auto;" />

Các điểm màu đỏ là các điểm bị ghi nhận sai đơn vị đo lường từ $cm$ sang $mét$ và có $Z-Score$ lên đến hơn 6. Trong trường hợp này $Z-Score$ cũng là phương pháp định lượng hiệu quả để xác định giá trị ngoại lai. Tuy nhiên, $Z-Score$ có điểm bất lợi là giá trị này được tính toán dựa trên giá trị trung bình và độ lệch tiêu chuẩn của dữ liệu trong khi chính các giá trị đó lại phụ thuộc rất lớn vào các giá trị ngoại lai. Một cách đề giảm thiểu tác động của giá trị ngoại lai lên tính $Z-Score$ là không tính đến $x_i$ khi tính toán trung bình $\bar{x}$ và $\sigma(x)$. 

Đa số các phương pháp xác định giá trị ngoại lai ở trên đều dựa trên giả thiết là véc-tơ dữ liệu có phân phối chuẩn. Dữ liệu về bồi thường bảo hiểm là một điển hình của dữ liệu không có phân phối chuẩn. Đồ thì dưới đây mô tả số liệu về tiền bồi thường bảo hiểm sức khỏe của hơn 1.000 khách hàng của một công ty bảo hiểm nhân thọ

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-62-1.png" width="960" style="display: block; margin: auto;" />

Nhiều điểm dữ liệu bị xác định là ngoại lai trong trường hợp này mặc dù đây là dữ liệu chính xác. Trong thực tế, nếu bạn đọc gặp dữ liệu không có phân phối chuẩn, hãy biến đổi dữ liệu về gần với phân phối chuẩn nhất có thể trước khi thực hiện các bước phân tích. Phép biến đổi thường được sử dụng nhất là biến đổi Box-Cox.

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/unnamed-chunk-63-1.png" width="960" style="display: block; margin: auto;" />

Kỹ thuật biến đổi Box-Cox được trình bày trong phụ lục của chương này.

#### Giá trị ngoại lai trong không gian nhiều chiều
Xác định giá trị ngoại lai trong không gian nhiều chiều phức tạp hơn trong không gian một chiều rất nhiều. Trong không gian một chiều, chúng ta cần xác định những số nào là
giá trị ngoại lai của một véc-tơ. Trong khi trong không gian nhiều chiều, chúng ta cần phải xác định các quan sát nào là giá trị ngoại lai trong một dữ liệu. Ngoài việc xem xét giá trị trong từng cột dữ liệu, chúng ta cần phải xem xét cả mối liên hệ giữa các véc-tơ (cột) đó. 

Các phương pháp để xác định giá giá trị ngoại lai trong không gian nhiều chiều vẫn dựa trên nguyên tắc cơ bản áp dụng trong không gian một chiều, đó là các quan sát càng xa điểm trung tâm của dữ liệu thì quan sát đó càng có khả năng cao là giá trị ngoại lai. Khái niệm xa hay gần trong một không gian nhiều chiều luôn gắn liền với một khái niệm về khoảng cách. Khoảng cách thường sử dung nhiều nhất trong không gian nhiều chiều là khoảng cách Euclid. Tuy nhiên khoảng cách Euclid có nhược điểm là không tính đến mối liên hệ giữa các cột dữ liệu. Khoảng cách thường được dùng trong xác định giá trị ngoại lai là khoảng cách Mahalanobis.

Cho $x_i = x_{i1}, x_{i2}, \cdots, x_{ip}$ là quan sát thứ $i$ và $\mu = \mu_{1}, \mu_{2}, \cdots, \mu_{p}$ là véc-tơ các giá trị trung bình của các véc-tơ cột. Khoảng cách Euclid và khoảng cách Mahalanobis được định nghĩa như sau
\begin{align}
D^{Euclid}(x_i,\mu) = \sqrt{(x_i - \mu)^T (x_i - \mu)} \\
D^{Mahalanobis}(x_i,\mu) = \sqrt{(x_i - \mu)^T \ \Sigma^{-1} \  (x_i - \mu)} \\
\end{align}
trong đó $D^{Euclid}(x_i,\mu)$ và $D^{Mahalanobis}(x_i,\mu)$ lần lượt là khoảng cách Euclid và khoảng cách Mahalanobis từ quan sát $x_i$ đến điểm trung bình $\mu$. Trong công thức tính khoảng cách Mahalanobis, $\Sigma^{-1}$ là ma trận nghịch đảo của ma trận hiệp phương sai của dữ liệu. Ki Có thể thấy rằng khoảng cách Euclid là trường hợp riêng của khoảng cách Mahalanobis khi các cột dữ liệu có phương sai bằng 1 và đôi một độc lập với nhau.

Bạn đọc có thể tự lập trình hàm số tính khoảng cách Euclid và hàm số tính khoảng cách Mahalanobis giữa 2 véc-tơ như sau

```r
Dis.Euc<-function(x,y) sum((x-y)^2)^0.5
Dis.Mah<-function(x,y,Sigma) (t(x-y)%*% solve(Sigma) %*%(x-y))^0.5 
```

Chúng ta quay trở lại ví dụ về dữ liệu bao gồm 10 quan sát với hai giá trị ngoại lai là điểm A (màu đỏ) và điểm B (màu cam). Chúng ta tính toán khoảng cách Euclid của mỗi điểm đến trung tâm của dữ liệu và sắp xếp các điểm theo thứ tự khoảng cách Euclid giảm dần



<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-66)Điểm dữ liệu sắp xếp theo khoảng cách Euclid giảm dần</caption>
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
   <td style="text-align:right;"> 7.925 </td>
   <td style="text-align:right;"> 2.593 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm B (cam) </td>
   <td style="text-align:right;"> 10.000 </td>
   <td style="text-align:right;"> 6.000 </td>
   <td style="text-align:right;"> 5.046 </td>
   <td style="text-align:right;"> 1.747 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 1.046 </td>
   <td style="text-align:right;"> 5.069 </td>
   <td style="text-align:right;"> 4.216 </td>
   <td style="text-align:right;"> 1.647 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 1.916 </td>
   <td style="text-align:right;"> 4.193 </td>
   <td style="text-align:right;"> 3.302 </td>
   <td style="text-align:right;"> 1.225 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 7.101 </td>
   <td style="text-align:right;"> 2.411 </td>
   <td style="text-align:right;"> 2.753 </td>
   <td style="text-align:right;"> 1.128 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 6.693 </td>
   <td style="text-align:right;"> 2.403 </td>
   <td style="text-align:right;"> 2.497 </td>
   <td style="text-align:right;"> 1.012 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 2.973 </td>
   <td style="text-align:right;"> 3.773 </td>
   <td style="text-align:right;"> 2.327 </td>
   <td style="text-align:right;"> 0.815 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 4.388 </td>
   <td style="text-align:right;"> 2.662 </td>
   <td style="text-align:right;"> 1.935 </td>
   <td style="text-align:right;"> 0.615 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 5.357 </td>
   <td style="text-align:right;"> 2.560 </td>
   <td style="text-align:right;"> 1.858 </td>
   <td style="text-align:right;"> 0.671 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Điểm khác (xanh) </td>
   <td style="text-align:right;"> 5.129 </td>
   <td style="text-align:right;"> 3.055 </td>
   <td style="text-align:right;"> 1.360 </td>
   <td style="text-align:right;"> 0.473 </td>
  </tr>
</tbody>
</table>

Có thế thấy rằng khi chỉ có 10 quan sát, khoảng cách Euclid có thể sử dụng để phát hiện được giá trị ngoại lai là điểm A và điểm B vì hai điểm này có khoảng cách đến trung tâm xa hơn so với các điểm còn lại. Khoảng cách Mahalanobis cũng cho kết quả tương tự. Tuy nhiên khoảng cách Euclid sẽ gặp vấn đề khi số lượng quan sát nhiều hơn và mối liên hệ giữa $x$ và $y$ rõ ràng hơn. Bạn đọc có thể thấy khoảng cách Euclid không cho kết quả tốt như khoảng cách Malahanobis trong trường hợp dữ liệu có 100 quan sát



<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-68)Điểm dữ liệu sắp xếp theo khoảng cách Euclid giảm dần</caption>
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

Khi đo bằng khoảng cách Euclid, điểm $A$ vẫn là điểm xa trung tâm dữ liệu nhất. Tuy nhiên khoảng cách từ điểm $B$ đến trung tâm dữ liệu là nhỏ hơn một số điểm màu xanh khác. Quan sát khoảng cách Mahalanobis chúng ta có thể thấy rằng điểm $A$ là điểm có khoảng cách xa nhất, sau đó đến điểm $B$ (Malahanobis distance = 4.675), các điểm màu xanh khác đều có khoảng cách Mahalanobis nhỏ hơn 2,5.

Các kỹ thuật phát hiện giá trị ngoại lai phức tạp hơn dựa trên nguyên lý phân cụm sẽ được trình bày trong chương "học máy không có giám sát". Nguyên tắc xác định một quan sát ngoại lai là phân chia dữ liệu thành các cụm sao cho các quan sát trong cùng một cụm có tính chất tương tự nhau. Các quan sát không nằm trong cụm nào, hoặc trong các cụm có rất ít quan sát, có nhiều khả năng là giá trị ngoại lai.

### Xử lý giá trị ngoại lai.

Có nhiều phương pháp để xử lý giá trị ngoại lai trong dữ liệu. Tùy thuộc vào tình huống và dữ liệu cụ thể, phương pháp nào cũng có thể đúng hoặc sai. Điều quan trọng là bạn đọc phải phân tích các tình huống có thể liên quan đến giá trị ngoại lai. Đôi khi việc phân tích các giá trị ngoại lai này còn giúp bạn có những hiểu biết hơn về dữ liệu và tối ưu công việc phân tích của bạn.

- 1. Phương pháp đơn giản nhất và cũng thường cho hiệu quả thấp nhất đó là loại bỏ các quan sát, hoặc biến có chứa giá trị ngoại lai. Phương pháp này chỉ có ý nghĩa khi bạn có số lượng quan sát đủ lớn và các giá trị bị coi là ngoại lai không có có ý nghĩa trong xác định phân phối xác suất của từng biến.

- 2. Thay thế giá trị ngoại lai bằng một giá trị khác: bạn đọc có thể thay thế giá trị ngoại lai bằng giá trị có ý nghĩa hơn như giá trị Q0 hoặc Q4 của phân phối xác suất, hoặc cũng có thể thay thế giá trị ngoại lai bằng giá trị trung bình, trung vị, hoặc mode của phân phối. Đây là phương pháp đơn giản, dễ sử dụng và thường cho hiệu quả tốt hơn so với phương pháp xóa quan sát.

- 3. Phương pháp sau cùng và cũng là phương pháp đòi hỏi kỹ thuật phức tạp nhất đó là coi giá trị ngoại lai như một giá trị không quan sát được, sau đó xây dựng mô hình để dự đoán cho giá trị ngoại lai.

Các phương pháp thay thế giá trị ngoại lai và hoặc dự đoán giá trị ngoại lai dựa trên mô hình do tương tự như các phương pháp xử lý dữ liệu không quan sát được nên sẽ được trình bày ở phần sau của chương sách.


### Xử lý giá trị không quan sát được.
Khi dữ liệu có giá trị không quan sát được, cách xử lý đơn giản nhất là xóa các quan sát hoặc xóa các biến chứa các giá trị đó. Nếu bạn đọc gặp dữ liệu mà trong đó có một hoặc một số quan sát mà đa số các giá trị trong đó là $NA$, trong khi tất cả các quan sát còn lại đều không có chứa $NA$, thì cách xử lý xóa đi quan sát có giá trị $NA$ là giải pháp hợp lý nhất. Ví dụ như chúng ta có dữ liệu về thông tin của sinh viên của một lớp như sau

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
   <td style="text-align:left;background-color: #FF8080 !important;"> MSV33789 </td>
   <td style="text-align:left;background-color: #FF8080 !important;"> Nguyễn Thị Thu Thủy </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> NA </td>
   <td style="text-align:left;background-color: #FF8080 !important;"> NA </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> NA </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> NA </td>
  </tr>
</tbody>
</table>

Quan sát tương ứng với mã sinh viên "MSV33789" ngoài thông tin về tên sinh viên, các thông tin khác đều không quan sát được. Ngoài sinh viên này, các sinh viên còn lại đều có đầy đủ thông tin. Trong trường hợp này phương pháp xử lý hiệu quả nhất là xóa sinh viên "MSV33789" khỏi dữ liệu trước khi phân tích. 

Khi các giá trị không quan sát được tập trung ở một số quan sát (hàng) hoặc tập trung ở một số biến (cột), chúng ta nói rằng các giá trị không quan sát được một cách không ngẫu nhiên (Missing value not at random hay MNAR). 

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
   <td style="text-align:right;background-color: #FF8080 !important;"> 3.25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV43241 </td>
   <td style="text-align:left;"> Nguyễn Văn An </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 169 </td>
   <td style="text-align:right;"> 72 </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV65432 </td>
   <td style="text-align:left;"> Lê Thị Loan </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:left;"> Nữ </td>
   <td style="text-align:right;"> 155 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MSV34001 </td>
   <td style="text-align:left;"> Trần Mạnh Cường </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> Nam </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:right;background-color: #FF8080 !important;"> NA </td>
  </tr>
</tbody>
</table>

Dữ liệu ở trên là ví dụ khác về việc giá trị không quan sát được xuất hiện một cách không ngẫu nhiên. Có thể thấy rằng trong cột $GPA$ đa số các giá trị là không quan sát được. Mọi phân tích liên quan đến giá trị của biến này sẽ không có ý nghĩa, do đó cách tốt nhất là xóa cột này ra khỏi dữ liệu. Để xóa các quan sát có chứa giá trị không quan sát được ra khỏi dữ liệu, bạn đọc có thể sử dụng hàm `drop_na()` của thư viện `tidyr`. Để xóa một cột khỏi dữ liệu, bạn đọc có thể coi dữ liệu (một $data.frame$ hoặc $tibble$) như là một $list$ và gán giá trị của biến đó bằng $NULL$


```r
# Du lieu là một tibble hoặc một data.frame có tên là dat
dat<-drop_na(dat) # Xóa các quan sát (hàng) có giá trị NA ra khỏi dữ liệu
dat$ten_cot<-NULL # xóa cột có tên là ten_cot ra khoi du lieu
```

Nếu giá trị không quan sát được tập trung vào một số quan sát thì xóa quan sát sẽ không làm ảnh hưởng đến kết quả phân tích. Dữ liệu chúng ta thường gặp sẽ có các giá trị không quán sát được nằm rải rác ở các cột không theo một quy tắc nào. Chúng tôi muốn nói đến trường hợp dữ liệu không quan sát được xuất hiện một cách hoàn toàn ngẫu nhiên (Missing completely at random hay MCAR). Khi gặp trường hợp này nếu xóa đi các quan sát có $NA$, tỷ lệ quan sát bị xóa đi sẽ là đáng kể.

Để minh họa rõ hơn cho vấn đề này, và để đánh giá hiệu quả của các phương pháp xử lý giá trị $NA$ trong các phần sau, chúng tôi sẽ sử dụng dữ liệu $mpg$ của thư viện $ggplot2$. Đây là dữ liệu có 234 quan sát và 11 biến. Dữ liệu mô tả mức độ tiêu hao nhiên liệu của các loại xe oto thương mại đang bán trên thị trường trong hai năm 1999 và 2008. Dữ liệu không có giá trị $NA$ nhưng chúng ta sẽ thêm các giá trị không quan sát được vào dữ liệu một các ngẫu nhiên. Sau đó dữ liệu chính xác sẽ được sử dụng để đánh giá phương pháp xử lý giá trị không quan sát được. Bạn đọc cần đọc mô tả về dữ liệu $mpg$, ý nghĩa của các biến sau đó sử dụng đoạn câu lệnh dưới đây để thêm giá trị $NA$ vào trong dữ liệu một cách ngẫu nhiên. Chúng ta sẽ gọi tên dữ liệu mới là $na.mpg$ để phân biệt với dữ liệu ban đầu. 


```r
# Tạo dữ liệu mới giống như dữ liệu ban mpg
na.mpg<-mpg

# Định dạng lại format các cột kiểu biến rời rạc thành kiểu factor
chiso<- !(names(na.mpg) %in% c("displ", "cty", "hwy"))
na.mpg[,chiso]<-lapply(na.mpg[,chiso], as.factor)%>%as.data.frame()

# Viết hàm số để thêm giá trị NA vào một véc-tơ
## hàm số có ý nghĩa là thêm vào véc-tơ x các giá trị NA một cách ngẫu nhiên
## tỷ lệ giá trị NA được thêm vào bằng tùy biến na.rate
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
na.mpg[,chiso]<-as.data.frame(lapply(na.mpg[,chiso], rd.add, na.rate = 0.02))

# Xem mỗi cột có bao nhiêu giá trị NA
sapply(na.mpg, f<-function(x) sum(is.na(x)))
```

```
## manufacturer        model        displ         year          cyl        trans 
##            0            0            5            0            5            5 
##          drv          cty          hwy           fl        class 
##            5            5            5            5            5
```

Chúng ta thấy rằng có 8/11 cột có giá trị $NA$, cột có 5 giá trị $NA$ xuất hiện một cách ngẫu nhiên trên tổng số 234 giá trị (tỷ lệ khoảng 2%). Tuy nhiên số quan sát có chứa $NA$ lại lớn hơn 2% rất nhiều. Hàm `drop_na()` trong thư viện $tidyr$ sẽ xóa các quan sát có giá trị $NA$ ra khỏi dữ liệu. Chúng ta có thể tính được sau khi xóa tỷ lệ dữ liệu còn giữ lại là bao nhiêu:

```r
nrow(drop_na(na.mpg))/nrow(na.mpg)
```

```
## [1] 0.8461538
```

Có thể thấy nếu 2% dữ liệu không quan sát được ở mỗi cột nếu chúng ta xóa các quan sát có giá trị $NA$, tỷ lệ dữ liệu còn lại là khoảng 85%. Chúng ta có thể thử tăng tỷ lệ giá trị không quan sát được trên mỗi cột lên thành 3%, 5%, 10%, 20%, 30% và quan sát tỷ lệ dữ liệu còn lại sau khi xóa:



<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-75)Tỷ lệ dữ liệu bị xóa nếu loại bỏ quán sát có NA</caption>
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

Chúng ta có thể thấy rằng xóa quan sát có giá trị $NA$ không phải là một giải pháp hiệu quả khi giá trị $NA$ xuất hiện trong hầu hết các cột. Từ kết quả trên có thể thấy rằng khi tỷ lệ $NA$ là 5% trở lên ở mỗi cột trong số 8/11 cột của dữ liệu, chúng ta phải xóa đi khoảng 35% số quan sát để dữ liệu không còn $NA$. Tỷ lệ dữ liệu xóa đi lớn như vậy sẽ ảnh hưởng lớn đến kết quả của phân tích. 

Các phương pháp xử lý giá trị không quan sát được trong trường hợp này là thay thế giá trị $NA$ bằng các giá trị thích hợp. Phương pháp đơn giản nhất đó là giả thiết các cột chứa giá trị không quan sát được độc lập với nhau và sử dụng các giá trị đặc trưng của cột dữ liệu tương ứng để thay thế cho giá trị $NA$. Các phương pháp phức tạp hơn cân nhắc mối liên hệ giữa các cột dữ liệu và xây dựng các thuật toán để tìm giá trị tối ưu thay thế cho các giá trị không quan sát được nằm trong tất cả các cột. Mỗi phương pháp đều có ưu nhược điểm và chúng tôi thường thử cả hai hướng tiếp cận sau đó đánh giá hiệu quả dựa trên kết quả phân tích.

#### Thay thế giá trị không quan sát được bằng trung bình, trung vị hoặc mode.
Với giả thiết rằng cột chứa giá trị không quan sát được không có mối liên hệ đến các cột còn lại, chúng ta sẽ sử dụng một trong các giá trị như trung bình (mean), trung vị (median), hoặc mode của các giá trị quan sát được để thay thế cho các giá trị không quan sát được.

- Giá trị trung bình thường được sử dụng để thay thế cho các giá trị không quan sát được cho véc-tơ kiểu số liên tục và phân phối của các giá trị không có đuôi dài.

- Giá trị trung vị, là giá trị tại ngưỡng xác suất 50%, thường được sử dụng để thay thế cho các giá trị không quan sát được cho véc-tơ kiểu số liên tục và véc-tơ có đuôi dài. Giá trị trung vị có ưu điểm là ít bị ảnh hưởng bởi các giá trị ngoại lai và không bị thay đổi sau các bước biến đổi dữ liệu bằng các hàm đơn điệu.

- Giá trị mode, là giá trị mà hàm mật độ có xác suất cao nhất, có thể dùng cho cả véc-tơ kiểu số liên tục hoặc véc-tơ kiểu biến rời rạc. Trong trường hợp véc-tơ kiểu số liên tục, bạn đọc cần phải ước lượng hàm mật độ nên giá trị mode sẽ còn phụ thuộc vào phương pháp tiếp cận của người phân tích.

Để thay thế giá trị không quan sát được bằng một giá trị khác, bạn đọc có thể sử dụng hàm `na_if()` của thư viện `dplyr`, hàm `replace_na` của thư viện `tidyr`, hoặc cũng có thể tự xây dựng hàm số của mình. Để đơn giản hóa, chúng ta giả sử rằng sẽ luôn luôn thay thế giá trị trung vị khi gặp véc-tơ kiểu số liên tục và giá trị mode khi gặp véc-tơ kiểu biến rời rạc.




```r
my_mode<-function(x){ # tự định nghĩa hàm mode cho véc-tơ x
  names(which.max(table(x)))
}
my_fillna_1<-function(x){ # tự định nghĩa cách thay thế giá trị NA phương pháp thứ nhất
  if(is.numeric(x)){
    x[is.na(x)]<-median(x,na.rm=TRUE)
  } else {
    x[is.na(x)]<-my_mode(x)
  }
  return(x)
}
mpg_1<-lapply(na.mpg, my_fillna_1)%>%as.data.frame()
```

Giá trị thật của các biến kiểu số liên tục (nằm trong các cột $displ$, $hwy$, và $cty$) và giá trị dùng để thay thế được tổng kết lại trong bảng dưới đây:
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-78)Biến liên tục, thay thế NA bằng trung vị</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> displ đúng </th>
   <th style="text-align:right;"> displ thay thế </th>
   <th style="text-align:right;"> hwy đúng </th>
   <th style="text-align:right;"> hwy thay thế </th>
   <th style="text-align:right;"> cty đúng </th>
   <th style="text-align:right;"> cty thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;border-left:1px solid;"> 16 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;border-left:1px solid;"> 17 </td>
   <td style="text-align:right;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 5.4 </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;border-left:1px solid;"> 24 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;border-left:1px solid;"> 11 </td>
   <td style="text-align:right;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 3.8 </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;border-left:1px solid;"> 12 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;border-left:1px solid;"> 15 </td>
   <td style="text-align:right;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 2.7 </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;border-left:1px solid;"> 27 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;border-left:1px solid;"> 18 </td>
   <td style="text-align:right;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 1.8 </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;border-left:1px solid;"> 20 </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;border-left:1px solid;"> 26 </td>
   <td style="text-align:right;border-right:1px solid;"> 17 </td>
  </tr>
</tbody>
</table>

Giá trị thật của các biến kiểu factor và giá trị dùng để thay thế được tổng kết trong bảng phía dưới

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-79)Biến rời rạc, thay thế NA bằng mode</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> cyl đúng </th>
   <th style="text-align:left;"> cyl thay thế </th>
   <th style="text-align:left;"> trans đúng </th>
   <th style="text-align:left;"> trans thay thế </th>
   <th style="text-align:left;"> drv đúng </th>
   <th style="text-align:left;"> drv thay thế </th>
   <th style="text-align:left;"> fl đúng </th>
   <th style="text-align:left;"> fl thay thế </th>
   <th style="text-align:left;"> class đúng </th>
   <th style="text-align:left;"> class thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> auto(l6) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> e </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> suv </td>
   <td style="text-align:left;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 8 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m5) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> r </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> pickup </td>
   <td style="text-align:left;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 8 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> p </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> suv </td>
   <td style="text-align:left;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> r </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> subcompact </td>
   <td style="text-align:left;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 6 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> p </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> pickup </td>
   <td style="text-align:left;border-right:1px solid;"> suv </td>
  </tr>
</tbody>
</table>

Chúng ta có thể thấy rằng việc thay thế giá trị $NA$ trong các véc_tơ kiểu biến liên tục bằng giá trị median là khá hiệu quả. Về tổng thể, giá trị median không cách quá xa so với giá trị thật. 

Thay thế các giá trị không quan sát được trong các véc-tơ kiểu biến rời rạc bằng giá trị mode không cho kết quả tốt trong trường hợp này. Nguyên nhân là do giá trị mode trong các biến rời rạc không chiếm ưu thế so với các giá trị khác. Chẳng hạn như biến $drv$ bị dự đoán sai 4/5 kết quả do biến này có 2 giá trị mode. 

#### Thay thế giá trị không quan sát được bằng một mẫu ngẫu nhiên.
Vẫn với giả thiết rằng cột chứa giá trị không quan sát được không có mối liên hệ đến các cột còn lại, chúng ta sẽ sử dụng phép lấy mẫu ngẫu nhiên từ các giá trị quan sát được để thay thế cho các giá trị $NA$. Hàm `sample()` là hàm số có sẵn trong R được sử dụng để sinh ngẫu nhiên. Để lấy ra $k$ số ngẫu nhiên từ một véc-tơ $x$ ban đầu, chúng ta viết câu lệnh như sau

```r
sample(x,size = k, replace = TRUE) 
```
Tùy biến $replace$ nhận giá trị bằng $TRUE$ có ý nghĩa là giá trị ngẫu nhiên được lấy ra từ véc-tơ $x$ có thể được lấy lặp lại. Chúng ta tự định nghĩa hàm `fill_na_2()` để thay thế giá trị ngẫu nhiên trong một véc-tơ $x$ bằng các giá trị ngẫu nhiên được lấy từ $x$ như sau

```r
my_fillna_2<-function(x){ # tự định nghĩa cách thay thế giá trị NA, phương pháp thứ 2
  ind<-is.na(x) # véc-tơ kiểu logic, nhận giá trị TRUE tại các vị trí NA
  k<-sum(ind)
  x[ind]<-sample(x[!ind],k,replace = TRUE)
  return(x)
}
set.seed(12)
mpg_1<-lapply(na.mpg, my_fillna_2)%>%as.data.frame()
```

Giá trị thật của các biến kiểu số liên tục (nằm trong các cột $displ$, $hwy$, và $cty$) và giá trị dùng để thay thế được tổng kết lại trong bảng dưới đây:
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-82)Biến liên tục, thay thế NA bằng lấy mẫu ngẫu nhiên</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> displ đúng </th>
   <th style="text-align:right;"> displ thay thế </th>
   <th style="text-align:right;"> hwy đúng </th>
   <th style="text-align:right;"> hwy thay thế </th>
   <th style="text-align:right;"> cty đúng </th>
   <th style="text-align:right;"> cty thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:right;"> 4.7 </td>
   <td style="text-align:right;border-left:1px solid;"> 16 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;border-left:1px solid;"> 17 </td>
   <td style="text-align:right;border-right:1px solid;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 5.4 </td>
   <td style="text-align:right;"> 4.0 </td>
   <td style="text-align:right;border-left:1px solid;"> 24 </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;border-left:1px solid;"> 11 </td>
   <td style="text-align:right;border-right:1px solid;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 3.8 </td>
   <td style="text-align:right;"> 4.0 </td>
   <td style="text-align:right;border-left:1px solid;"> 12 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;border-left:1px solid;"> 15 </td>
   <td style="text-align:right;border-right:1px solid;"> 15 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 2.7 </td>
   <td style="text-align:right;"> 4.0 </td>
   <td style="text-align:right;border-left:1px solid;"> 27 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;border-left:1px solid;"> 18 </td>
   <td style="text-align:right;border-right:1px solid;"> 18 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 1.8 </td>
   <td style="text-align:right;"> 4.0 </td>
   <td style="text-align:right;border-left:1px solid;"> 20 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;border-left:1px solid;"> 26 </td>
   <td style="text-align:right;border-right:1px solid;"> 13 </td>
  </tr>
</tbody>
</table>

Có thể thấy rằng biến $year$ là biến gần như không có mối liên hệ đến các biến khác. Khi chúng ta xây dựng mô hình trên dữ liệu, việc xóa bỏ các biến không cần thiết ra khỏi mô hình là rất quan trọng vì các biến này có thể gây ra nhiễu cho mô hình và giảm khả năng dự đoán. 

Còn quá sớm để nói đến xây dựng mô hình trên dữ liệu $mpg$ như thế nào. Bạn đọc nên hiểu 


Giá trị thật của các biến kiểu factor và giá trị dùng để thay thế được tổng kết trong bảng phía dưới

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-83)Biến rời rạc, thay thế NA bằng lấy mẫu ngẫu nhiên</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> cyl đúng </th>
   <th style="text-align:left;"> cyl thay thế </th>
   <th style="text-align:left;"> trans đúng </th>
   <th style="text-align:left;"> trans thay thế </th>
   <th style="text-align:left;"> drv đúng </th>
   <th style="text-align:left;"> drv thay thế </th>
   <th style="text-align:left;"> fl đúng </th>
   <th style="text-align:left;"> fl thay thế </th>
   <th style="text-align:left;"> class đúng </th>
   <th style="text-align:left;"> class thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> auto(l6) </td>
   <td style="text-align:left;"> manual(m5) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> e </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> suv </td>
   <td style="text-align:left;border-right:1px solid;"> compact </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 8 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m5) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> r </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> pickup </td>
   <td style="text-align:left;border-right:1px solid;"> compact </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 8 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:left;"> auto(l5) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> p </td>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;border-left:1px solid;"> suv </td>
   <td style="text-align:left;border-right:1px solid;"> pickup </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> r </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> subcompact </td>
   <td style="text-align:left;border-right:1px solid;"> midsize </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 6 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:left;"> auto(l5) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> p </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> pickup </td>
   <td style="text-align:left;border-right:1px solid;"> midsize </td>
  </tr>
</tbody>
</table>

Hiệu quả của phương pháp lấy mẫu ngẫu nhiên so với phương pháp sử dụng các giá trị trung vị hoặc mode là không rõ ràng. Tuy nhiên phương pháp này có nhược điểm lớn nhất đó là giá trị được sử dụng để thay thế là ngẫu nhiên nên có khả năng sẽ làm cho dữ liệu bị sai lệch.

#### Thay thế giá trị không quan sát được bằng cách xây dựng mô hình.
Giả thiết cột chứa giá trị không quan sát được không có mối liên hệ đến các cột còn lại là một giả thiết không thực tế. Các cột dữ liệu luôn luôn ít nhiều có mối liên hệ với nhau, hay nói theo khái niệm của xác suất - thống kê thì giá trị trong các cột dữ liệu thường không độc lập với nhau (Not independent hoặc dependent). Làm thế nào để biết hai cột dữ liệu bất kỳ là độc lập hay phụ thuộc là một câu hỏi không dễ có câu trả lời. Do đây là một vấn đề khó và vượt quá phạm vi của cuốn sách nên chúng tôi chỉ trình bày các phương pháp được công nhận rộng rãi. Để kiểm tra hai cột dữ liệu có độc lập hay không, bạn đọc hãy sử dụng các kiểm định như sau:

1. Kiểm định Khi-bình phương khi cả hai biến đều là biến rời rạc. 

2. Kiểm định hệ số tương quan Person, hệ số tương quan Spearman, và hệ số tương quan Kendall khi cả hai biến đều là biến liên tục. 

3. Sử dụng phân tích phương sai (hay còn gọi là anova test) trong trường hợp một biến là rời rạc và một biến là liên tục.

Chi tiết của các kiểm định này được trình bày ở phần phụ lục của chương. 

Để thực hiện kiểm định Khi-bình phương trong R, chúng ta sử dụng hàm `chisq.test()`. Để kiểm ra hai biến $year$ và $drv$ có mối liên hệ hay không, chúng ta thực hiện như sau

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

Giá trị $p-value$ bằng 42% nghĩa là xác suất bác bỏ giả thiết hai biến $year$ và $drv$ độc lập là $100\% - 42\% = 58\%$. Thông thường, mức xác suất bác bỏ giả thiết độc lập thường được chọn ở mức $95\%$ hoặc thậm chí $99\%$. Do xác suất bác bỏ giả thiết độc lập là thấp nên trong trường hợp này có thể đưa ra kết luận rằng hai biến $year$ và $drv$ là không liên quan đến nhau. Tương tự, để kiểm ra hai biến $drv$ và $cyl$ có mối liên hệ hay không, chúng ta thực hiện như sau

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

Do xác suất bác bỏ giả thiết độc lập ($1-10^{-16}$) là xấp xỉ $100\%$ nên trong trường hợp này có thể đưa ra kết luận rằng hai biến $drv$ và $cyl$ là không độc lập.

Để kiểm định hệ số tương quan giữa hai biến liên tục chúng ta sử dụng hàm `cor.test()`. Tùy biến $method$ nhận giá trị "pearson", "kendall", hoặc "spearman" tương ứng với các hệ số tương quan Pearson, hệ số tương quan Kendall hoặc hệ số tương quan Spearman. Chúng ta kiểm định sự độc lập giữa hai biến $displ$ và $hwy$ như sau


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

Kiểm định cả ba hệ số tương quan đều cho xác suất bác bỏ giả thiết hai biến độc lập là xấp xỉ 100\%. Nói một cách khác có thể khẳng định hai biến $displ$ và $hwy$ là có sự phụ thuộc.

Sau cùng, để kiểm định sự phụ thuộc giữa một biến rời rạc và một biến liên tục, chúng ta sử dụng phân tích phương sai. Hàm số để thực hiện phân tích phương sai trong R là hàm `aov()`. Chúng ta kiểm định sự phụ thuộc giữa $hwy$ và $cyl$ như sau

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

Xác suất bác bỏ giả thiết giá trị trung bình của biến $hwy$ bằng nhau theo các nhóm của biến $cyl$ là xấp xỉ $100\%$ hay nói một cách khác $hwy$ và $cyl$ là có mối liên hệ.

Để xem xét một cách tổng thể mối liên hệ giữa các biến trong dữ liệu $na.mpg$, bạn đọc có thể sử dụng kiểm định phù hợp với từng cặp biến và lưu xác suất bác bỏ giả thiết độc lập vào một ma trận. Hàm số `ind_check()` được tự xây dựng có đầu vào là một dữ liệu (một tibble hoặc một data.frame) và đầu ra là một ma trận cho biết xác suất bác bỏ giả thiết độc lập của từng cặp biến như thế nào. Bạn đọc có thể xem câu lệnh của hàm số này ở phần phụ lục của chương.


Ma trận thể hiện xác suất bác bỏ giả thiết độc lập giữa từng cặp biến trong dữ liệu $na.mpg$ như sau

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-88)Biến rời rạc, thay thế NA bằng lấy mẫu ngẫu nhiên</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> manufacturer </th>
   <th style="text-align:right;"> model </th>
   <th style="text-align:right;"> displ </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> trans </th>
   <th style="text-align:right;"> drv </th>
   <th style="text-align:right;"> cty </th>
   <th style="text-align:right;"> hwy </th>
   <th style="text-align:right;"> fl </th>
   <th style="text-align:right;"> class </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> manufacturer </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.13 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> model </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> displ </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.96 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.92 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> year </td>
   <td style="text-align:right;"> 0.13 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.96 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.99 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.57 </td>
   <td style="text-align:right;"> 0.41 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cyl </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.99 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.84 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> trans </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> drv </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.57 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.32 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cty </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.41 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hwy </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fl </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.92 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.84 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.32 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> class </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.00 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
</tbody>
</table>

Có thể thấy biến $year$ gần như không có mối liên hệ đến các biến khác. Khi xây dựng mô hình trên dữ liệu, sự xuất hiện của các biến không cần thiết sẽ thêm nhiễu và làm giảm chất lượng của mô hình. Trong trường hợp này, chúng ta sẽ loại bỏ biến $year$ trước khi thực hiện dự đoán cho các giá trị không quan sát được. 

Phương pháp để xây dựng mô hình dự đoán cho các giá trị không biết là sử dụng thuật toán "rừng ngẫu nhiên". Đây là một thuật toán nâng cao của mô hình dạng cây quyết định. Còn quá sớm để nói về mô hình này, bạn đọc chỉ cần hiểu rằng chúng ta sẽ dựa vào các giá trị quan sát được để xây dựng mô hình (một hàm số $f$) mà biến có giá trị $NA$ phụ thuộc vào biến không có giá trị $NA$ để đưa ra dự đoán. Thư viện "missForest" hỗ trợ chúng ta làm việc này. Bạn đọc có thể cài thư viện sau đó sử dụng hàm `missForest()`. Quy trình điền giá trị $NA$ vào dữ liệu $na.mpg$ chỉ cần 1 dòng lệnh!


```r
library(missForest)
### Thời gian chạy mất khoảng 1-2 phút
model<-missForest(select(na.mpg,-year), maxiter = 200, ntree = 100) 
mpg_1<-model$ximp # Dữ liệu mpg_1 là dữ liệu sau khi thay thế NA
```

Giá trị thật của các biến kiểu số và các giá trị thay thế trong bảng dưới đây

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-90)Biến liên tục, thay thế NA bằng giá trị dự đoán bằng random forest</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> displ đúng </th>
   <th style="text-align:right;"> displ thay thế </th>
   <th style="text-align:right;"> hwy đúng </th>
   <th style="text-align:right;"> hwy thay thế </th>
   <th style="text-align:right;"> cty đúng </th>
   <th style="text-align:right;"> cty thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4.0 </td>
   <td style="text-align:right;"> 4.002192 </td>
   <td style="text-align:right;border-left:1px solid;"> 16 </td>
   <td style="text-align:right;"> 15.78726 </td>
   <td style="text-align:right;border-left:1px solid;"> 17 </td>
   <td style="text-align:right;border-right:1px solid;"> 16.53488 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 5.4 </td>
   <td style="text-align:right;"> 4.663533 </td>
   <td style="text-align:right;border-left:1px solid;"> 24 </td>
   <td style="text-align:right;"> 24.31500 </td>
   <td style="text-align:right;border-left:1px solid;"> 11 </td>
   <td style="text-align:right;border-right:1px solid;"> 11.27833 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 3.8 </td>
   <td style="text-align:right;"> 3.806883 </td>
   <td style="text-align:right;border-left:1px solid;"> 12 </td>
   <td style="text-align:right;"> 14.12071 </td>
   <td style="text-align:right;border-left:1px solid;"> 15 </td>
   <td style="text-align:right;border-right:1px solid;"> 14.19350 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 2.7 </td>
   <td style="text-align:right;"> 3.051833 </td>
   <td style="text-align:right;border-left:1px solid;"> 27 </td>
   <td style="text-align:right;"> 26.01500 </td>
   <td style="text-align:right;border-left:1px solid;"> 18 </td>
   <td style="text-align:right;border-right:1px solid;"> 18.09544 </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 1.8 </td>
   <td style="text-align:right;"> 1.933100 </td>
   <td style="text-align:right;border-left:1px solid;"> 20 </td>
   <td style="text-align:right;"> 18.97731 </td>
   <td style="text-align:right;border-left:1px solid;"> 26 </td>
   <td style="text-align:right;border-right:1px solid;"> 26.37494 </td>
  </tr>
</tbody>
</table>

Giá trị thật của các biến kiểu factor và giá trị dùng để thay thế được tổng kết trong bảng phía dưới

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-91)Biến rời rạc, thay thế NA bằng giá trị dự đoán bằng random forest</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> cyl đúng </th>
   <th style="text-align:left;"> cyl thay thế </th>
   <th style="text-align:left;"> trans đúng </th>
   <th style="text-align:left;"> trans thay thế </th>
   <th style="text-align:left;"> drv đúng </th>
   <th style="text-align:left;"> drv thay thế </th>
   <th style="text-align:left;"> fl đúng </th>
   <th style="text-align:left;"> fl thay thế </th>
   <th style="text-align:left;"> class đúng </th>
   <th style="text-align:left;"> class thay thế </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> auto(l6) </td>
   <td style="text-align:left;"> auto(l5) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> e </td>
   <td style="text-align:left;"> e </td>
   <td style="text-align:left;border-left:1px solid;"> suv </td>
   <td style="text-align:left;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 8 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m5) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> r </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> pickup </td>
   <td style="text-align:left;border-right:1px solid;"> pickup </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 8 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:left;"> auto(l4) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> p </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> suv </td>
   <td style="text-align:left;border-right:1px solid;"> suv </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> auto(l4) </td>
   <td style="text-align:left;"> auto(l5) </td>
   <td style="text-align:left;border-left:1px solid;"> 4 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;border-left:1px solid;"> r </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> subcompact </td>
   <td style="text-align:left;border-right:1px solid;"> subcompact </td>
  </tr>
  <tr>
   <td style="text-align:right;border-left:1px solid;"> 6 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;border-left:1px solid;"> manual(m6) </td>
   <td style="text-align:left;"> auto(s6) </td>
   <td style="text-align:left;border-left:1px solid;"> f </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:left;border-left:1px solid;"> p </td>
   <td style="text-align:left;"> r </td>
   <td style="text-align:left;border-left:1px solid;"> pickup </td>
   <td style="text-align:left;border-right:1px solid;"> pickup </td>
  </tr>
</tbody>
</table>

Bạn đọc có thể thấy rằng ngoài biến $trans$, đa số các biến còn lại đều được dự đoán khá chính xác bằng thuật toán rừng ngẫu nhiên. Chúng ta sẽ thảo luận về mô hình này trong chương thảo luận về mô hình cây quyết định.


## Phụ lục

### Box-Cox transformation
Biến đổi Box-Cox là một phương pháp biến đổi để đưa một véc-tơ có phân phối khác với phân phối chuẩn thành một véc-tơ có phân phối gần với phân phối chuẩn. Phép biến đổi Box-Cox chỉ có duy nhất một tham số $\lambda$.

\begin{align}

\end{align}

### Kolmogorov-Smirnov tests

### Pearson's Chi-squared tests



## Bài tập

# Biến đổi dữ liệu bằng thư viện $dplyr$
Dữ liệu trước khi đưa vào trực quan hóa hoặc xây dựng mô hình hiếm khi có được định dạng chính xác mà bạn đọc mong muốn. Thông thường, bạn đọc sẽ cần tạo thêm một số biến, hoặc có thể bạn đọc chỉ muốn đổi tên các biến, hoặc sắp xếp lại các quan sát, hoặc tổng hợp dữ liệu để làm cho dữ liệu dễ dàng xử lý tiếp. Bạn đọc sẽ học cách thực hiện tất cả những phép biến đổi đó trong phần này. Nội dung chủ yếu của phần này sẽ hướng dẫn bạn đọc cách chuyển đổi dữ liệu của mình bằng cách sử dụng thư viện $dplyr$ và tập dữ liệu $gapminder$ - dữ liệu về sức khỏe và thu nhập của các quốc gia trên thế giới từ năm 1960 đến năm 2016.

Thư viện $dplyr$ là một thư viện nằm trong thư viện tổng hợp $tidyverse$, bạn đọc có thể gọi thư viện $tidyverse$ hoặc trực tiếp thư viện $dplyr$ lên cửa sổ đang làm việc. Bạn đọc cũng nên lưu ý rằng trong thư viện $dplyr$ có một số hàm trùng tên với các hàm có sẵn trong R, chẳng hạn như hàm $filter()$ hoặc hàm $lag()$. Tuy nhiên R ưu tiên $dplyr$ trước các thư viện có sẵn nên bạn đọc sẽ nhận được thông báo khi gọi thư viện này.

Dữ liệu $gapminder$ là dữ liệu đã được sử dụng trong phần tiền xử lý dữ liệu. Bạn đọc lưu ý thực hiện các bước tiền xử lý dữ liệu trước khi chạy các câu lệnh biến đổi dữ liệu. Mỗi phần tiếp theo sẽ giới thiệu một hàm quan trọng của thư viện $dplyr$ và các tham số của hàm đó. Sau cùng chúng tôi sẽ giới thiệu về cách sử dụng pipe ($%\>\%$) để kết nối các hàm với nhau trong một câu lệnh duy nhất.

## Thêm biến bằng hàm $mutate()$
Khi bạn đọc muốn thêm các cột khác vào một dữ liệu được tính toán từ các cột hiện có, bạn đọc có thể sử dụng hàm $mutate()$. Hàm $mutate()$ luôn thêm cột vào sau cột cuối cùng trong dữ liệu hiện có. Khi bạn muốn thêm cột vào một vị trí cụ thể, bạn có thể sử dụng tùy biến 

- $.after = ten\_cot$ trong đó $ten\_cot$ là tên cột phía trước cột mà bạn đọc muốn thêm vào.
- $.before = ten\_cot$ trong đó $ten\_cot$ là tên cột phía sau cột mà bạn đọc muốn thêm vào.

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

Câu lệnh trên thêm cột có tên là $gdp\_per\_capita$ được tính bằng tổng thu nhập quốc nội ($gdp$) chia cho dân số của quốc gia đó. Nếu bạn đọc muốn cột mới được thêm vào ngay sau cột $gdp$, hãy sử dụng thêm tùy biến $.after$


```r
mutate(mytib, gdp_per_capita = gdp/population,.after = gdp) # thêm cột có tên là gdp_per_capita
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

Một biến thể khác của hàm $mutate()$ là $transmute()$. Hàm $transmute()$ khác $mutate()$ ở chỗ là chỉ giữ lại các cột mới được tạo thành

```r
transmute(mytib, gdp_per_capita = gdp/population) # data mới chỉ có cột gdp_per_capita
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


## Lựa chọn cột bằng hàm $select()$
Khi dữ liệu có quá nhiều cột và bạn đọc chỉ muốn sử dụng một số cột nhất định để phân tích, bạn đọc hãy sửa dụng hàm $select()$. Điều quan trọng nhất khi sử dụng hàm $select()$ là bạn đọc cần phải gọi tên đúng các cột (biến) mà mình muốn lựa chọn. 


```r
select(mytib, year, gdp, population) # lấy ra các cột year, gdp, population
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
Hàm $select$ cũng có thể được sử dụng để thay đổi tên cột. Chẳng hạn bạn đọc muốn tên các cột mới tương ứng là $"Year"$, $"GDP"$ và $"Population"$

```r
select(mytib, Year = year, Gdp =  gdp,  Population = population) # lấy ra và đổi tên các cột year, gdp, population
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

Khi dữ liệu có quá nhiều cột và việc gọi tên chính xác các cột làm cho câu lệnh $select()$ quá dài, bạn đọc có thể lựa chọn các cột đứng liền nhau bằng cách sau

```r
select(mytib, year, gdp:population) # 
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
Câu lệnh trên có ý nghĩa là lấy ra cột $year$ và tất cả các cột nằm giữa cột $gdp$ và cột $population$.

Bạn đọc không nhớ chính xác tên cột muốn lấy ra thì có thể sử dụng các tùy chọn sau:

- $starts\_with()$: lấy ra các cột có tên bắt đầu bằng một chuỗi ký tự nào đó.

- $ends\_with()$: lấy ra các cột có tên kết thúc bằng một chuỗi ký tự nào đó.

- $contains()$: lấy ra các cột có tên chứa một chuỗi ký tự nào đó.

- $matches()$: lấy ra các cột có tên khớp với một xxxxxxxxxxxxxxxxxxx nào đó


```r
mytib1<-mutate(mytib, gdp_per_capita = gdp/population) # mytib1 là tibble có thêm cột tên là gdp_per_capita
select(mytib1, contains("gdp")) # lấy ra tất cả các cột có tên chứa "gdp"
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

Hàm $select()$ ngoài ý nghĩa là lựa chọn cột còn có ý nghĩa là loại bỏ một số cột nào đó khỏi dữ liệu hiện thời. Để loại bỏ cột, bạn đọc chỉ cần thêm dấu "-" vào trước tên cột.

```r
select(mytib1, - starts_with("gdp")) # bỏ đi tất cả các cột có tên chứa "gdp"
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

## Lọc quan sát bằng hàm `filter()`

Hàm `filter()` cho phép bạn đọc lọc các quan sát dựa trên giá trị của các cột. Do có một số thư viện trong R sử dụng hàm $filter()$ với mục đích khác nhau và chúng tôi không chắc chắn cửa sổ R bạn đọc đang sử dụng đang có sẵn các thư viện nào nên chúng tôi đổi tên cho hàm $filter()$ của thư viện $dplyr$ thành $dfilter()$ phương pháp mượn tham số:

```r
dfilter<-function(...) dplyr::filter(...)
```

Cách hoạt động của hàm $filter()$ như sau: bạn đọc muốn lấy dữ liệu của năm 2010 từ dữ liệu $gapminder$, chúng ta sử dụng hàm $filter()$ như sau

```r
dfilter(mytib, year == 2010) # chỉ lấy các quan sát có year là 2010
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
Sau khi chạy câu lệnh trên, R sẽ tạo thành một $tibble()$ mới chỉ bao gồm các quan sát có giá trị cột $year$ là 2010. Lưu ý rằng nếu bạn đọc muốn lưu lại giá trị sau mỗi lần thực hiện tính toán hãy gán giá trị trả lại vào một đối tượng mới. $filter()$ có thể được thực hiện khi sử dụng nhiều cột, chẳng hạn như bạn đọc muốn lọc các quan sát của năm 2010 của các quốc gia Châu Âu

```r
dfilter(mytib, year == 2010, continent == "Europe") 
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

## Sắp xếp dữ liệu bằng hàm `arrange()`
Hàm `arrange()` sắp xếp các hàng của dữ liệu theo thứ tự tăng dần. Nguyên tắc sắp xếp cũng tương tự như hàm `sort()` khi làm trên véc-tơ, nghĩa là hàm bạn đọc có thể sắp xếp dữ liệu dựa theo bất kỳ kiểu dữ liệu nào. Chẳng hạn như để sắp xếp dữ liệu $gapminder$ theo thứ tự tăng dần theo năm, theo Châu lục, và sau cùng là theo vùng, bạn đọc sử dụng câu lệnh như sau


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

Nếu muốn sắp xếp dữ liệu theo thứ tự giảm dần, nếu cột dữ liệu là kiểu số, bạn đọc chỉ cần thêm dấu "-" trước tên biến. Trong trường hợp cột dữ liệu kiểu bất kỳ, bạn đọc sử dụng hàm $desc()$ 

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

Lưu ý rằng nếu trong cột dữ liệu sử dụng để sắp xếp có giá trị $NA$ thì các giá trị này luôn được sắp xếp xuống phía dưới của dữ liệu.


## Kết hợp các hàm bằng toán tử pipe (`\%>\%`)  
Trước khi giới thiệu các hàm khác dùng để biến đổi dữ liệu của thư viện $dplyr$, chúng tôi muốn giới thiệu đến bạn đọc toán tử pipe ($\%>\%$). Đây là một công cụ vô cùng hữu hiệu khi bạn đọc thực hiện một chuỗi các phép biến đổi dữ liệu. Toán tử pipe được mượn từ toán học khi nói đến việc sử dụng các hàm số nối tiếp nhau. Pipe trong thư viện $dplyr$ cũng có ý nghĩa tương tự khi bạn đọc sử dụng một chuỗi các hàm của thư viện này nhằm biến đổi dữ liệu. Ví dụ như khi bạn đọc muốn lấy ra từ dữ liệu $gapminder$ ba quốc gia có thu nhập bình quân đầu người cao nhất trong năm 2000, bạn sẽ cần các phép biến đổi sau:
- Thứ nhất: thêm cột thu nhập bình quân đầu người (sử dụng hàm $mutate()$)
- Thứ hai: lọc dữ liệu theo năm, chỉ lấy dữ liệu của năm 2000. (sử dụng hàm $filter()$)
- Thứ ba: lựa chọn cột tên quốc gia và cột thu nhập bình quân đầu người (sử dụng hàm $select()$)
- Thứ tư: sắp xếp dữ liệu theo cột thu nhập bình quân đầu người, thứ tự sắp xếp là giảm dần (sử dụng hàm $arrange()$)
- Thứ năm: lấy ra ba hàng đầu tiên của dữ liệu (sử dụng hàm $head()$)

Nếu không sử dụng toán tử $pipe$, sau mỗi bước ở trên bạn đọc sẽ phải lưu kết quả và gọi lại kết quả vào bước kế tiếp:

```r
mytib1<-mutate(mytib,gdp_per_capita = gdp/population) # bước thứ nhất
mytib1<-dfilter(mytib1, year == 2010) # bước thứ hai
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

Thay vì phải lưu lại dữ liệu sau mỗi lần sử dụng biến đổi dữ liệu và gọi lại kết quả để sử dụng cho bước tiếp theo, bạn đọc có thể sử dụng toán tử $pipe$ như sau

```r
mytib%>%mutate(gdp_per_capita = gdp/population)%>%
  dfilter(year == 2010)%>%
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
Kết quả thu được hoàn toàn tương tự như trên tuy nhiên câu lệnh đã rõ ràng hơn rất nhiều. Từ phần này của cuốn sách, mọi phép biến đổi trên dữ liệu chúng tôi sẽ luôn luôn ưu tiên sử dụng toán tử $pipe$ vì sự đơn giản và rõ ràng của các câu lệnh.


## Tổng hợp dữ liệu bằng $group\_by()$ và $summarise()$ 
Hàm $group\_by()$ là một công cụ hữu hiệu trong tổng hợp dữ liệu và tính toán theo nhóm. Chẳng hạn như từ dữ liệu $gapminder$ bạn đọc muốn biết tổng thu nhập quốc dân ($gdp$) của một quốc gia là cao hay thấp so với tổng thu nhập quốc dân trung bình của châu lục ($continent$) trong năm tương ứng ($year$), bạn đọc cần phải thực hiện các thao tác sau:
- Bước 1: Nhóm dữ liệu lại theo châu lục và theo năm
- Bước 2: Tính tổng thu nhập quốc dân của châu lục trong năm đó, bỏ qua các nước không có quan sát
- Bước 3: Đếm xem có bao nhiêu giá trị có quan sát
- Bước 4: Lấy kết quả ở bước 2 chia cho kết quả của bước 3.
- Bước 5: So sánh gdp của quốc gia với gdp trung bình của châu lục trong năm đó

Những bước như trên có thể được thực hiện một cách đơn giản thông qua hàm $group\_by$ như sau

```r
mytib%>%group_by(continent, year) %>%
  mutate(gdp_year_continent = mean(gdp,na.rm=TRUE))%>% # thêm cột gdp bình quân của châu lục theo năm
  ungroup()%>% # để dữ liệu trở lại trạng thái ban đầu (trước khi group)
  mutate(gdp_level = ifelse(gdp > gdp_year_continent, "High", "Low"))
```

```
## # A tibble: 10,545 × 11
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
## # ℹ 4 more variables: continent <fct>, region <fct>, gdp_year_continent <dbl>,
## #   gdp_level <chr>
```
Nếu đoạn câu lệnh trên không sử dụng câu lệnh $group\_by$, hàm $mean()$ trong câu lệnh $mutate()$ sẽ thực hiên tính toán cho toàn bộ véc-tơ $gdp$ của dữ liệu $gapminder$. Nghĩa là cột mới được hình thành sẽ có giá trị giống nhau với tất cả các quan sát. Sau khi sử dụng hàm $group\_by()$, mỗi khi chúng ta sử dụng một hàm tính toán trên một cột dữ liệu khác, cột dữ liệu đó sẽ được tính toán cho từng nhóm được định nghĩa bởi hàm $group\_by$. Trong đoạn lệnh ở trên, hàm $mean()$ sẽ tính giá trị trung bình của véc-tơ $gdp$ cho từng châu lục theo từng năm. Thật vậy, chúng ta có thể kiểm tra giá trị ở hàng đầu tiên của cột $gdp\_year\_continent$ (tương ứng với Albania - năm 1960 - châu Âu) sẽ là giá trị trung bình của véc-tơ $gdp$ của các nước châu Âu trong năm 1960:

```r
mytib%>%dfilter(year == 1960, continent == "Europe")%>%
  select(gdp)%>%mean()
```

```
## [1] NA
```

Hàm $group\_by()$ kết hợp với $summarise()$ sẽ tạo thành một dữ liệu mới mà mỗi hàng sẽ tương đương với một nhóm được quy định bởi hàm $group\_by()$. 

```r
mytib%>%group_by(continent, year) %>%
  summarise(gdp_year_continent = mean(gdp,na.rm=TRUE))
```

```
## # A tibble: 285 × 3
## # Groups:   continent [5]
##    continent  year gdp_year_continent
##    <fct>     <int>              <dbl>
##  1 Africa     1960        3652247577.
##  2 Africa     1961        3642863976.
##  3 Africa     1962        3781167783.
##  4 Africa     1963        4107185952.
##  5 Africa     1964        4342684293.
##  6 Africa     1965        4618242478.
##  7 Africa     1966        4562215808.
##  8 Africa     1967        4592913225.
##  9 Africa     1968        4814235499.
## 10 Africa     1969        5157970620.
## # ℹ 275 more rows
```

Bạn đọc có thể thấy rằng dữ liệu mới (dưới dạng một $tibble$) được tạo thành, mỗi hàng là một châu lục trong một năm, với ba cột bao gồm hai cột được quy định bởi hàm $group\_by()$ là $continent$, $year$ và cột $gdp\_year\_continent$ mới được tạo thành từ hàm $summarise()$.


# Trực quan hóa dữ liệu

```r
p<-gapminder%>%filter(year<=2010)%>%
# AESTHETIC MAPPING
ggplot(aes(x=fertility,y=life_expectancy,size = population, fill= continent))+
# TAO DO THI SCATTERPLOT
geom_point(shape=21,alpha=0.6)+
# THAY DOI TITLE CUA DO THI, TRUC X, TRUC Y
labs(title = 'Năm: {as.integer(frame_time)}',
y = "Tuổi thọ trung bình",
x = "Tỷ lệ sinh trên mỗi phụ nữ")+
#GIOI HAN LAI GIA TRI TREN X,Y
xlim(0,10)+ylim(20,90)+
# SCALE LAI SIZE (POPULATION)
scale_size(range = c(1*2, 20*2)) +
# SCALE LAI MAU SAC THE0 DAI MAU "SET1" CUA BREWER
scale_color_brewer(palette = "Set1")+
# LAM TITLE THAY DOI THEO NAM
transition_time(year)+
#SIZE & FONT CHU
theme(,
plot.title = element_text(size = 20*2),
axis.title.x = element_text(size = 20*2),
axis.title.y = element_text(size = 20*2),
legend.text = element_text(size = 20*2,margin = margin(r = 30*2, unit = "pt")),
legend.title = element_text(size = 20*2),
#    legend.text=element_text(size=20*2),
)
#legend.key.size = element_rect(size = rel(1.5)),

# TAO DO THI DANG DONG
animate(p, renderer = gifski_renderer(),
width = 1600, #pixel chieu rong
height = 1600) # pixel chieu cao
```

<img src="08-phan-tich-du-lieu-bang-R_files/figure-html/code visualization 1.0-1.gif" width="504" height="504" />




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
