---
output:
  pdf_document: default
  html_document: default
header-includes:
- \usepackage{tikz}
- \usepackage{pgfplots}
- \usetikzlibrary{arrows,automata,positioning}
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



# Giới thiệu chung

## Giới thiệu về Khoa học dữ liệu và các ứng dụng
Khoa học dữ liệu kết hợp giữa toán học với khoa học máy tính và một kiến thức chuyên ngành để khám phá những thông tin hữu ích và có giá trị trong dữ liệu để hỗ trợ việc ra quyết định và lập kế hoạch hành động. Một quá trình ứng dụng KHDL vào giải quyết một vấn đề cụ thể thường bao gồm các bước được mô tả như Hình \@ref().

<div class="figure" style="text-align: center">
<img src="01-intro_files/figure-html/fgintro01-1.png" alt="Quy trình áp dụng Khoa học dữ liệu để giải quyết một vấn đề thực tế" width="672" />
<p class="caption">(\#fig:fgintro01)Quy trình áp dụng Khoa học dữ liệu để giải quyết một vấn đề thực tế</p>
</div>

- $\textbf{Nhập liệu}$ là quá trình tìm kiếm và thu thập dữ liệu từ các nguồn khác nhau để phục vụ cho mục đích ra quyết định. Có những dự án làm việc trực tiếp trên dữ liệu có sẵn và đã được thiết kế sẵn sàng cho mục tiêu phân tích nhưng cũng có những dự án mà quá trình nhập liệu lại chiếm phần lớn thời gian và quyết định sự thành công hay thất bại của dự án. 

- $\textbf{Sắp xếp}$ dữ liệu hay còn được gọi là tiền xử lý dữ liệu là các bước biến dữ liệu từ dạng thô thành dữ liệu theo đúng như định dạng mong muốn.

- $\textbf{Biến đổi}$ dữ liệu là quá trình tính toán trên các biến hoặc các quan sát của dữ liệu để dữ liệu có thể đưa vào các công cụ trực quan hoặc đưa vào trong các mô hình phân tích.

- $\textbf{Xây dựng mô hình}$ là quá trình tính toán và đánh giá mối liên hệ giữa các biến trong dữ liệu đến các biến mục tiêu là đầu ra của toàn bộ quá trình. Mô hình thường được xây dựng với một trong hai mục đích là xem xét sự tác động của một biến đến các biến mục tiêu, hoặc nhằm mục đích dự đoán giá trị của các biến mục tiêu.

Mô hình trên dữ liệu được xây dựng dựa trên những nguyên lý của toán học và xác suất thống kê. Dữ liệu được sử dụng để xây dựng mô hình có thể là các dữ liệu nhỏ với một vài cột và vài chục quan sát, nhưng cũng có thể là các dữ liệu lớn với hàng nghìn cột dữ liệu và hàng triệu quan sát. Dữ liệu thậm chí không có dạng bảng biểu như chúng ta gặp hàng ngày mà có thể là các hình ảnh, các văn bản, giọng nói, dạng đồ thị, ... Để xử lý các bộ dữ liệu khổng lồ, hay các dữ liệu không có cấu trúc bảng thông thường, người xử lý dữ liệu và cần có các kiến thức về khoa học máy tính và lập trình để thực hiện các tính toán trên máy tính điện tử. Những ứng dụng của KHDL có thể thuộc về bất kỳ lĩnh vực nào như kinh doanh, y học, vật lý, thiên văn, quản lý nhà nước, chính sách công, ... nên đòi hỏi người xây dựng mô hình cũng cần có kiến thức chuyên môn trong lĩnh vực tương ứng để không bị sai định hướng trong quá trình làm việc với dữ liệu.

Để minh họa ứng dụng của KHDL trong lĩnh vực Kinh tế và Kinh doanh, chúng tôi thảo luận ngắn gọn về ba dữ liệu được thu nhập trong thế giới thực được xem xét trong cuốn sách này.

### Dữ liệu chi phí quảng cáo


### Dữ liệu bảo hiểm xe ô tô


### Dữ liệu về giá nhà

## Sơ lược quá trình phát triển của xây dựng mô hình dữ liệu
Mặc dù thuật ngữ xây dựng mô hình trên dữ liệu, hay được gọi một cách kỹ thuật hơn là học máy, còn khá mới mẻ nhưng những khái niệm nền tảng cho lĩnh vực này đã được phát triển từ lâu. Vào đầu thế kỷ 19, phương pháp bình phương nhỏ nhất đã được phát triển và áp dụng để ước lượng các mô hình hồi quy tuyến tính. Mô hình này lần đầu tiên được áp dụng và cho kết quả thành công trong các vấn đề liên quan đến thiên văn học. Vào đầu thế kỷ thứ 20, mô hình hồi quy tuyến tính được sử dụng để dự đoán các giá trị định lượng, chẳng hạn như mức lương của một cá nhân hoặc để dự đoán các giá trị định tính, chẳng hạn như bệnh nhân sống hay chết, hay thị trường chứng khoán tăng hay giảm. Vào những năm 1940, nhiều tác giả đã đưa ra một cách tiếp cận khác, đó là hồi quy logistic. Vào đầu những năm 1970, thuật ngữ mô hình tuyến tính tổng quát đã được phát triển để mô tả toàn bộ lớp phương pháp học thống kê bao gồm cả hồi quy tuyến tính và hồi quy logistic như các trường hợp đặc biệt. Vào cuối những năm 1970, nhiều kỹ thuật xây dựng mô hình trên dữ liệu đã xuất hiện. Tuy nhiên, các mô hình này chỉ xoay quanh là các phương pháp tuyến tính vì việc tạo ra các mối quan hệ phi tuyến tính rất khó khăn về mặt tính toán. 

Đến những năm 1980, sự phát triển của máy tính điện tử đã hỗ trợ tích cực về mặt tính toán cho các các phương pháp phi tuyến tính. Các mô hình phi tuyến được giới thiệu vào đầu những năm của thập niên 80 bao gồm có mô hình cây quyết định và mô hình cộng tính tổng quát. Những năm cuối thập niên 80 và đầu thập niên 90, mô hình mạng nơ-ron được giới thiệu đến cộng đồng nghiên cứu nhưng chưa có được nhiều sự quan tâm vì dữ liệu chưa đủ phong phú và sự phổ biến của các mô hình học máy khác.

Giai đoạn cuối thế kỷ XX và đầu thế kỷ XXI là giai đoạn chiếm ưu thế hoàn toàn của các mô hình học máy rừng ngẫu nhiên và thuật toán học tăng cường. Thuật toán học tăng cường với các biến thể như XGBoost hay LightGBM chiến thắng trong hầu hết các cuộc thi về Khoa học dữ liệu. 

Từ năm 2010, với sự bùng nổ của các thiết bị thông minh và kết nối internet, dữ liệu trở nên phong phú và đa dạng hơn cũng là thời điểm quay trở lại của mô hình mạng nơ-ron, hay còn được gọi với tên gọi khác là mô hình mạng học sâu (deep learning). Mô hình mạng học sâu vượt trội hoàn toàn các mô hình học máy thông thường khi làm việc với dữ liệu kiểu hình ảnh, video, ngôn ngữ tự nhiên bao gồm cả văn bản và giọng nói. Sự kiện đánh dấu sự phát triển vượt bậc của các mô hình mạng học sâu là sự ra đời của ChatGPT vào cuối những năm 2022 là một mô hình ngôn ngữ lớn cho phép người dùng tương tác, hỏi đáp và trò chuyện một cách hoàn toàn tự nhiên theo định hướng của người sử dụng như phong cách, mức độ chi tiết, hình thức ngôn ngữ. ChatGPT nhanh chóng đạt đến 100 triệu người sau hơn hai tháng phát hành và giúp cho công ty phát hành OpenAI được định giá khoảng 30 tỷ USD. Cho đến thời điểm cuối năm 2023 khi nhóm tác giả bắt đầu viết cuốn sách này, ChatGPT đã được cập nhật đến phiên bản 3.5.

## Tại sao lại sử dụng phần mềm R
Trong thế giới ngày nay, hầu hết các cơ quan, tổ chức, tập đoàn, doanh nghiệp từ lớn đến nhỏ đều sử dụng một số lượng dữ liệu nhất định để phân tích các sự kiện trong quá khứ và cố gắng dự đoán xu hướng trong tương lai để đưa ra các quyết định có lợi cho mình. Tuy nhiên khi dữ liệu ngày càng tăng lên cả về số lượng và sự phức tạp, thì các cơ quan tổ chức cần một công cụ giúp họ thực hiện được các phân tích trên dữ liệu một cách nhanh hơn và chính xác hơn. Một trong các công cụ hiệu quả nhất tại thời điểm hiện tại là phần mềm R.

### Phần mềm R là gì?
Trước tiên, R là ngôn ngữ lập trình được xây dựng để phục vụ cho toán học và thống kê, đồng thời R cũng là một môi trường phần mềm mã nguồn mở miễn phí cho người sử dụng. R được giới thiệu lần đầu tiên vào năm 1992 bởi các giáo sư Ross Ihaka và Robert Gentleman như một ngôn ngữ lập trình để dạy thống kê tại Đại học Auckland. Tên của ngôn ngữ, R, xuất phát từ chữ cái đầu tiên của các tác giả là Ross và Robert.

Trước khi trở thành ngôn ngữ lập trình cho Khoa học dữ liệu, R thường được coi là ngôn ngữ lập trình cho các nhà toán học và thống kê. Sau nhiều năm phát triển, R luôn được coi vẫn là một trong những ngôn ngữ lập trình phổ biến nhất trong giới học thuật vì độ tin cậy. Mỗi thư viện của R đều được phát triển một cách hoàn chỉnh và trải qua quá trình kiểm soát chặt chẽ. Tạp chí R (R Journal) là tạp chí học thuật về các phương pháp tính toán trong toán học và thống kê sử dụng phầm mềm R luôn trong danh sách các tạp chí khoa học uy tín (Science Citation Index Expanded hay SCIE) của Web of Science. Chính vì sự uy tín trong học thuật nên đa số các trường đại học và viện nghiên cứu hàng đầu trên thế giới sử dụng như là một ngôn ngữ chính trong đào tạo về tính toán, toán học và thống kê.  

### Tại sao R lại được sử dụng trong KHDL
Trong khoảng hơn 10 năm trở lại đây, R không còn chỉ là ngôn ngữ lập trình thông thường như trước đây nữa. Mặc dù vẫn là một công cụ mạnh mẽ trong tính toán toán học và thống kê, nhưng còn có rất nhiều công cụ tuyệt vời khác mà bạn đọc có thể làm với R, đặc biệt là những ứng dụng trong KHDL. Nguyên nhân chính giúp cho phần mềm R nhanh chóng trở thành ngôn ngữ phổ biến trong KHDL là do nền tảng quan trọng nhất của KHDL chính là toán học và thống kê. Đồng thời, ngôn ngữ lập trình R cũng đủ linh hoạt để người sử dụng viết các chương trình yêu cầu tính toán phức tạp trong Khoa học máy tính. Một cách tự nhiên, những nhà toán học, thống kê học và các tổ chức sử đang dụng R như là một ngôn ngữ chính sẽ tìm cách phát triển R để đáp ứng được với yêu cầu xử lý dữ liệu của chính họ. Một nguyên nhân khác khiến cho R phổ biến trong KHDL là do đặc thù mã nguồn mở của phần mềm này. Những người làm việc trong lĩnh vực KHDL sử dụng R có thể chia sẻ kiến thức và kinh nghiệm một cách nhanh chóng và rộng rãi.  

### R có thể làm những gì?
Danh sách những việc bạn có thể làm trong R là không thể liệt hết bởi vì phần mềm này vẫn đang được phát triển không ngừng. Dưới đây là một số ứng dụng phổ biến mà R vượt trội hơn so với các ngôn ngữ khác:

- Lập trình trong toán học, tính toán tối ưu, giải tối ưu bằng phương pháp số

- Tính toán liên quan đến lý thuyết xác suất.

- Thực hiện các kiểm định thống kê.

- Phát triển phần mềm thống kê.

- Xây dựng mô hình kinh tế lượng.

- Mô phỏng ngẫu nhiên.

Các tính năng của R dành cho Khoa học dữ liệu được liệt kê dưới đây:

- Thu thập tập dữ liệu, bao gồm cả dữ liệu lớn và không có cấu trúc,

- Khai phá dữ liệu,

- Xử lý, sắp xếp, biến đổi dữ liệu,

- Phân tích dữ liệu,

- Trực quan hóa dữ liệu,

- Xây dựng các mô hình học máy từ đơn giản đến phức tạp

### Tại sao cuốn sách này lại sử dụng R
Mặc dù có một số phần mềm khác có thể được sử dụng thay thế cho R trong phân tích dữ liệu, nhưng chúng tôi lựa chọn ngôn ngữ R vì

- R là một phần mềm uy tín và đáng tin cậy được sử dụng bởi các trường đại học và các viện nghiên cứu hàng đầu trên thế giới. R cũng được sử dụng rộng rãi trong các công ty công nghệ hàng đầu như Microsoft, Facebook, Google, IBM.

- R là ngôn ngữ lập trình rất dễ hiểu cho người mới bắt đầu kể cả với những người không có kinh nghiệm lập trình. Còn nếu bạn đã có kinh nghiệm về một ngôn ngữ lập trình, sẽ chỉ cần một khoảng thời gian ngắn để bạn có thể viết các chương trình với R.

- Phần mềm R là một phần mềm mã nguồn mở, nghĩa là bạn đọc có thể sử dụng R và hơn 12000 thư viện mở rộng mà không cần phải bỏ ra bất kỳ một chi phí nào. Điều này giúp cho R trở nên rất dễ tiếp cận đối với những sinh viên và người học không sẵn sàng chi trả một khoản chi phí để học về KHDL. Đồng thời, giảng viên cũng có thể tận dụng tối đa môi trường phần mềm này khi giảng dạy cho sinh viên.

- Cuối cùng và cũng không kém phần quan trọng, đó là sự hỗ trợ từ công đồng. Với số lượng người dùng lên đến hàng triệu người, nhiều người trong đó là những nhà toán học, thống kê học, giáo sư tại các trường đại học, bạn sẽ luôn tìm thấy sự hỗ trợ mỗi khi gặp bất kỳ vấn đề khi làm việc với R.

### Các lựa chọn thay thế và bổ sung cho R trong KHDL
Như chúng ta đã thấy, R là một trong những ngôn ngữ lập trình tốt nhất cho người mới bắt đầu bước chân vào lĩnh vực KHDL. Tuy nhiên, bạn đọc cũng có thể tìm thấy các phần mềm/ngôn ngữ có thể sử dụng để thay thế cho R trong quá trình học tập và làm việc:

- Python - vào thời điểm chúng tôi đang hoàn thành cuốn sách này, Python là một ngôn ngữ lập trình được sử dụng nhiều nhất trong KHDL. Python được giới thiệu lần đầu tiên vào năm 1991 và đã không ngừng tiến hóa và phát triển. Cũng như R, cũng có mã nguồn mở và hoàn toàn miễn phí cho người sử dụng. Câu lệnh của Python cũng rất dễ học và đặc biệt mạnh mẽ trong lập trình hướng đối tượng.

- Julia - xuất hiện lần đầu tiên vào năm 2012, Julia là một trong những ngôn ngữ lập trình được phát hành gần đây nhất và là lựa chọn tối ưu cho các nhà khoa học dữ liệu. Ngôn ngữ lập trình cấp cao và hiệu suất cao này rất năng động và phù hợp để viết bất kỳ loại ứng dụng nào. Mặc dù Python và R vẫn được ưu tiên cho KHDL và học máy nhưng dự báo là Julia sẽ vượt qua cả hai trong tương lai gần. Thật vậy, mặc dù đây là ngôn ngữ lập trình tổng quát hơn nhưng nó có tất cả các đặc điểm cần thiết để xử lý phân tích, thống kê và dữ liệu lớn.

- MATLAB - được phát triển bởi MathWorks, ngôn ngữ lập trình này là một môi trường điện toán được phát triển đặc biệt để phân tích số và thống kê. Nhờ có số lượng lớn các thư viện có sẵn cho người dùng, MATLAB cho phép các lập trình viên truy cập dữ liệu, xử lý dữ liệu và tạo các mô hình học máy từ đơn giản đến phức tạp. Mặc dù MATLAB là một hệ thống hiệu suất cao nhưng lại không phải là nguồn mở hoặc miễn phí. Thay vào đó, nó được xây dựng bởi các nhà phát triển chuyên nghiệp và 

- Java là một trong những ngôn ngữ lập trình phổ biến nhất và cũng là một lựa chọn cho những người khi mới bước vào lĩnh vực KHDL. Mặc dù vẫn có thể tải xuống miễn phí nhưng một số ứng dụng chỉ có sẵn trong phiên bản trả phí. Cú pháp của Java cũng tương đối dễ học đối với người mới bắt đầu. Nhìn chung Java vẫn là ngôn ngữ có mục đích chung và nó vẫn được các nhà khoa học dữ liệu coi là một lựa chọn bổ sung cho R hoặc Python.

Ngoài việc thành thạo R hoặc một phần mềm chuyên dùng trong KHDL, bạn nên bổ sung cho mình các ngôn ngữ lập trình khác để đạt hiệu suất công việc tốt nhất:

- SQL hay ngôn ngữ truy vấn dữ liệu có cấu trúc. SQL xuất hiện từ năm 1974 đã không ngừng được cải tiến và sửa đổi để giúp cho ngôn ngữ này luôn nằm trong nhóm những ngôn ngữ lập trình được lựa chọn hàng đầu trong KHDL. SQL có cả các phiên bản miễn phí và các phiên bản thương mại mà người sử dụng phải trả chi phí.
- C và C++ là các ngôn ngữ lập trình hiệu suất cao có thể giúp bạn tăng hiệu quả của các chương trình. Hầu như tất cả các ứng dụng trên hệ điều hành máy tính và điện thoại di động hiện nay đều sử dụng C và C++. Viết các chương trình dưới ngôn ngữ C hoặc C++ sẽ hiệu quả về mặt thời gian hơn nhiều so với các ngôn ngữ khác. 

### Cài đặt R và RStudio

Bạn đọc sẽ bắt đầu bằng cài đặt phần mềm R và sau đó là cài đặt RStudio - một môi trường phát triển phổ biến dành cho R. Phần mềm R dành cho các hệ điều hành MAC OS, Windows, và Linux đều có sẵn để tải xuống từ trang web chính thức:

https://cran.r-project.org/

Tại thời điểm chúng tôi viết cuốn sách này, R đang là phiên bản 4.1.0. Sau khi tải xuống, chúng ta chỉ cần cài đặt R giống như tất cả các phần mềm khác với tất cả các tùy chọn mặc định. 

Sau khi cài đặt phần mềm R, bạn đọc cài đặt Rstudio. Chúng ta hoàn toàn có thể sử dụng R mà không cần có Rstudio. Tuy nhiên, Rstudio sẽ hỗ trợ bạn rất nhiều trong quá trình sử dụng R, do đó, lời khuyên của chúng tôi là hãy sử dụng Rstudio cùng với R. Để tải xuống Rstudio, bạn truy cập vào trang web chính thức:
 
https://posit.co/download/rstudio-desktop/

RStudio là một công cụ linh hoạt giúp bạn tạo các phân tích dễ đọc và giữ mã, hình ảnh, nhận xét và sơ đồ của bạn ở cùng một nơi. Sử dụng RStudio để lập trình và phân tích dữ liệu trong R mang lại nhiều lợi ích. Dưới đây là một vài ví dụ về những gì RStudio cung cấp:

- Giao diện trực quan cho phép chúng ta theo dõi các đối tượng, tập lệnh và số liệu đã lưu,

- Trình soạn thảo văn bản có các tính năng như tự động gợi ý câu lệnh, hiển thị màu giúp cho việc viết các câu lệnh rõ ràng,

- Hiển thị mô tả hàm số, dữ liệu bằng thao tác đơn giản,

- Thanh công cụ có đầy đủ các tính năng trực quan để bạn đọc sử dụng thay vì phải viết câu lệnh,

Mỗi khi bạn đọc mở RStudio, R cũng được khởi chạy tự động. Giao diện RStudio rất trực quan và dễ sử dụng. Các cửa sổ quan trọng bao gồm:

- Cửa số Console là nơi chúng ta có thể chạy các câu lệnh R.

- Cửa sổ Environment là chúng ta theo dõi các đối tượng, tập lệnh và số liệu đã lưu.

- Cửa sổ File là nơi hiển thị địa chỉ thư mục đang làm việc, hiển thị đồ thị trực quan, hoặc hiển thị mô tả dữ liệu, hàm số, thư viện.

Bạn đọc sẽ làm quen dần với giao diện và các cửa sổ làm việc khác nhau của RStudio trong quá trình thực hành trên các câu lệnh và dữ liệu cụ thể. Chúng tôi sẽ không đi quá sâu vào chi tiết tại đây.

## Về cuốn sách và tác giả
Cuốn sách được viết với mục tiêu là để thành sách tham khảo chính cho các môn học $\textbf{Phân tích và dự báo}$ và $\textbf{Khoa học dữ liệu cơ bản}$ cho sinh viên và học viên cao học ngành Toán Kinh tế tại Đại học Kinh tế Quốc dân. Chúng tôi tin rằng những kiến thức và công cụ được giới thiệu trong cuốn sách này sẽ là những hành trang quan trọng cho những nhà kinh tế và kinh doanh tương lai trước khi bước chân vào thế giới việc làm đầy tính cạnh tranh như hiện nay.

### Đôi lời từ tác giả
Tôi không phải là một nhà kinh tế, cũng không phải là một chuyên gia dữ liệu, và cũng không được đào tạo bài bản về máy tính hay lập trình, tôi là một Actuary. Cuốn sách được viết dựa trên kinh nghiệm làm việc và giảng dạy của tôi trong những lĩnh vực khoa học tính toán (actuarial science). Tôi bắt đầu sử dụng R như một phần mềm thống kê khi còn là một sinh viên đại học. Ấn tượng đầu tiên của tôi về R là khi sử dụng phần mềm này để mô phỏng các chuyển động Brown hình học vô cùng bắt mắt. Và R vẫn tiếp tục đồng hành với tôi cho đến nay trong cả môi trường doanh nghiệp và học thuật:

- Trong thời gian nghiên cứu sinh từ 2011 đến 2014, tôi sử dụng R là công cụ chính để thực hiện các tính toán cho luận án của mình. Với nội dung nghiên cứu tập trung vào tính toán và mô phỏng xác suất của các sự kiện cực hiếm, R là lựa chọn tối ưu vào thời điểm đó. Trong một vài tính toán mà chưa có thư viện hỗ trợ, chẳng hạn như tính toán với độ chính xác siêu nhỏ (dưới $10^{-100}$), tôi đã tìm đến Python là một giải pháp bổ sung. 

- Công việc đầu tiên trong môi trường doanh nghiệp của tôi liên quan đến dữ liệu là xây dựng các thuật toán để đầu tư trên thị trường tài chính tại một quỹ đầu tư. Tôi được làm quen với một kho dữ liệu khổng lồ bao gồm dữ liệu hỗ trợ phân tích kỹ thuật, dữ liệu hỗ trợ phân tích cơ bản, và dữ liệu kiểu tin tức của tất cả các công cụ tài chính có thể sử dụng để giao dịch, bao gồm cổ phiếu, trái phiếu, hợp đồng tương lai, quyền chọn. Các mô hình trên dữ liệu được chúng tôi - những người nghiên cứu thị trường - xây dựng bằng nhiều phương pháp để tìm ra các chiến lược mang lại lợi nhuận cho quỹ đầu tư. Mặc dù không có cơ hội sử dụng R để phân tích dữ liệu do các yêu cầu liên quan đến bảo mật, nhưng tôi lại được học những kỹ năng lập trình C++ mà tôi nhận ra là vô cùng quan trọng cho công việc của mình sau này.

- Khi bắt đầu công việc như một chuyên gia tính toán, tôi làm việc thường xuyên với dữ liệu trong bảo hiểm. Với những dữ liệu nhỏ, tôi nhận thấy rằng Microsoft Excel kết hợp với lập trình VBA là vừa đủ để xử lý. Khi dữ liệu trở nên ngày càng lớn và phức tạp, Excel và VBA không còn đáp ứng được nhu cầu, đó là lúc tôi quay lại sử dụng R trong công việc của mình. Ngoài sử dụng R như là một công cụ chính để định phí, đánh giá hợp đồng bảo hiểm, tôi còn sử dụng R để thực hiện các công việc liên quan đến dữ liệu như

  - Thu thập dữ liệu nhận được từ các phòng ban như tài chính, kế toán, nghiệp vụ, IT, kiểm tra, làm sạch và cập nhập dữ liệu lên cơ sở dữ liệu để phục vụ tính toán. R cho phép xử lý và tính toán những dữ liệu hàng chục triệu dòng với hiệu quả thực sự đáng kinh ngạc.

  - Trích xuất dữ liệu từ cơ sở dữ liệu, biến đổi và tính toán để thực hiện các nghiệp vụ như tái bảo hiểm, quản lý tài sản nợ/có, tính toán báo cáo kinh nghiệm.

  - Xây dựng các dashboard để cập nhật tình hình bồi thường bảo hiểm y tế với thời gian thực.

  - Xây dựng mô hình để phân loại rủi ro, dự báo những chủ hợp đồng, người được bảo hiểm có khả năng cao là trục lợi trong bảo hiểm y tế.

- Khi tôi quay trở lại với công việc học thuật vào đầu năm 2018, cũng là lúc mà làn sóng về khoa học dữ liệu bắt đầu ảnh hưởng đến đa số các lĩnh vực khác, bao gồm cả ngành khoa học tính toán. Các chứng chỉ về khoa học dữ liệu là điều kiện bắt buộc đối với những người muốn trở thành thành viên của các Hiệp hội chuyên gia tính toán. Tôi cùng với các đồng nghiệp của mình đưa môn học $\textbf{Phân tích và dự báo}$ vào trong chương trình đào tạo Định phí bảo hiểm và quản trị rủi ro để cung cấp cho sinh viên các kiến thức và kỹ năng cần thiết khi làm việc với dữ liệu và có thể lấy được chứng chỉ nghề nghiệp của Hiệp hội. Môn học $\textbf{Phân tích và dự báo}$ sau đó chính thức được giảng dạy cho sinh viên ngành Toán Kinh tế vào năm 2021 với tên gọi $\textbf{Khoa học dữ liệu trong Kinh tế và Kinh doanh}$. Nội dung của cuốn sách xoay quanh các kiến thức mà tôi đã đang và sẽ giảng dạy cho sinh viên và học viên của mình. 



### Ai nên đọc cuốn sách này

### Cấu trúc của cuốn sách

### Các ký hiệu thông dụng

### Các dữ liệu sử dụng trong cuốn sách


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
