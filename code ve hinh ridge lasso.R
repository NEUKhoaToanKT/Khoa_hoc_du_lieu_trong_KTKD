# Thu vien
library(ggplot2)
library(dplyr)


## Mô phỏng dữ liệu
n<-500
rho<-0.6
sigma<-0.4
set.seed(1)
x1<-rnorm(n,0,1)
x2<-x1*rho+rnorm(n,0,1)*sqrt(1-rho^2)
y<-2*x1-1*x2+rnorm(n,0,sigma)

# Ước lượng mô hình tuyến tính
lm1<-lm(y~x1+x2)


# Giá trị nhỏ nhất của tổng bình phương sai số RSS
minRSS<-sum(lm1$residuals^2)

# Các hệ số tối ưu
beta<-as.numeric(lm1$coefficients[2:3])
b0<-lm1$coefficients[1]

# Hàm giải phương trình bậc 2
sol_equa_2<-function(a,b,c){ # nghiem cua ax^2+bx+c
  del<- b^2 - 4*a*c
  if (del>0){
    return( c( (-sqrt(del)-b)/(2*a),(sqrt(del)-b)/(2*a) ) )
  }
}

# Hàm để vẽ elip
dat_ellipse<-function(A1,A2,A12,B1,B2,C,n){
  y0<-sol_equa_2((A12^2-A1*A2), 2*(A12*B1-A1*B2), (B1^2-A1*C))
  y0<-sort(y0)
  ep0<-10^(-8)
  yy<-seq(y0[1]+ep0,y0[2]-ep0,length=n)
  dat<-data.frame()
  for (i in 1:n){
    xx<-sol_equa_2(1, 2*(A12 * yy[i] + B1)/A1, (A2*yy[i]^2 + 2*B2*yy[i]+C)/A1)
    if (i == 1){
      dat<-data.frame(x = xx, y = rep(yy[i],2), z = c(1,2*n))
    } else {
      newdat<-data.frame(x = xx, y = rep(yy[i],2), z = c(i,2*n-i))
      dat<-rbind(dat,newdat)
    }
  }
  dat<-arrange(dat,z)
  return(dat)
}

# Hàm vẽ hình tròn
vehinhtron <- function(center=c(0,0), diameter=1, npoints=100, start=0, end=2, filled=TRUE){
  tt <- seq(start*pi, end*pi, length.out=npoints)
  df <- data.frame(
    x = center[1] + diameter / 2 * cos(tt),
    y = center[2] + diameter / 2 * sin(tt)
  )
  if(filled==TRUE) {
    df <- rbind(df, center)
  }
  return(df)
}


# Vẽ hình ridge

# Tính toán các tham số của elip
A1<-sum(x1^2)
A2<-sum(x2^2)
A12<-sum(x1*x2)
B1<- -sum(x1*(y-b0))
B2<- -sum(x2*(y-b0))
C<- sum((y -b0)^2) - minRSS

# Tạo dữ liệu để vẽ hình tròn và các elip
hinhtron <- vehinhtron(center=c(0,0), diameter=2, npoints= 100 , start = 0, end=2, filled=FALSE)

# Ellip nhỏ nhất
ep<-20
dat1<-dat_ellipse(A1,A2,A12,B1,B2,C-ep,n = 200)

# Ellip nhỏ thứ 2
ep<-150
dat2<-dat_ellipse(A1,A2,A12,B1,B2,C-ep,n = 200)

# Ellip lớn nhất
ep<-400
dat3<-dat_ellipse(A1,A2,A12,B1,B2,C-ep,n = 200)

# Vẽ hình
data.frame(x=0,y=0)%>%ggplot(aes(x,y))+
  geom_polygon(data=hinhtron, aes(x,y), color="black", fill="orange", alpha = 0.2)+
  geom_point(aes(x=beta[1],y=beta[2]),fill="red",shape=21)+
  # geom_segment(aes(x=beta[1],y=beta[2], xend = 0,yend = beta[2]), col = "lightblue",linetype=2)+
  # geom_segment(aes(x=beta[1],y=beta[2], xend = beta[1],yend = 0), col = "lightblue",linetype=2)+
  geom_path(data = dat1, aes(x,y),linetype = 3, col = "blue")+
  geom_path(data = dat2, aes(x,y),linetype = 3 , col = "blue")+
  geom_path(data = dat3, aes(x,y),linetype = 3 , col = "blue")+
  expand_limits(x = 0, y = 0)+
  xlim(c(-1,3.2)) + ylim(c(-2.2,1))+
  theme_classic()+
  geom_hline(yintercept = 0, col = "grey")+geom_vline(xintercept = 0, col = "grey")+
  geom_point(aes(x=0.95,y=-0.29),fill="orange",shape=21)+
  geom_segment(aes(x=beta[1]-0.02,y=beta[2]+0.02, xend = 0.98,yend = -0.32), col = "orange",linetype=2,arrow = arrow(length = unit(0.3, "cm")))+
  geom_label(aes(x=beta[1],y=beta[2]),label = "Điểm tối ưu OLS", vjust = 1.3)+
  geom_label(aes(x=0.95,y=-0.29),label = "Điểm tối ưu hồi quy Ridge", vjust= -0.3)+
  geom_label(aes(x=0,y=0.6),label = "Miền ràng buộc hệ số")+
  geom_label(aes(x=2.4,y=-1.65),label = "RSS = 230", size = 3)+
  geom_label(aes(x=2.8,y=-2.05),label = "RSS = 480", size = 3)+
  ggtitle("Hồi quy Ridge")


# Vẽ hình lasso
# Tạo dữ liệu để vẽ hình tròn và các elip
hinhtron <- vehinhtron(center=c(0,0), diameter=2, npoints = 5 , start = 0, end=2, filled=FALSE)

# Ellip nhỏ nhất
ep<-20
dat1<-dat_ellipse(A1,A2,A12,B1,B2,C-ep,n = 200)

# Ellip nhỏ thứ 2
ep<-160
dat2<-dat_ellipse(A1,A2,A12,B1,B2,C-ep,n = 200)

# Ellip lớn nhất
ep<-470
dat3<-dat_ellipse(A1,A2,A12,B1,B2,C-ep,n = 200)


data.frame(x=0,y=0)%>%ggplot(aes(x,y))+
  geom_polygon(data=hinhtron, aes(x,y), color="black", fill="orange", alpha = 0.2)+
  geom_point(aes(x=beta[1],y=beta[2]),fill="red",shape=21)+
  # geom_segment(aes(x=beta[1],y=beta[2], xend = 0,yend = beta[2]), col = "lightblue",linetype=2)+
  # geom_segment(aes(x=beta[1],y=beta[2], xend = beta[1],yend = 0), col = "lightblue",linetype=2)+
  geom_path(data = dat1, aes(x,y),linetype = 3, col = "blue")+
  geom_path(data = dat2, aes(x,y),linetype = 3 , col = "blue")+
  geom_path(data = dat3, aes(x,y),linetype = 3 , col = "blue")+
  expand_limits(x = 0, y = 0)+
  xlim(c(-1,3.2)) + ylim(c(-2.2,1))+
  theme_classic()+
  geom_hline(yintercept = 0, col = "grey")+geom_vline(xintercept = 0, col = "grey")+
  geom_point(aes(x=0.95,y=-0.06),fill="orange",shape=21)+
  geom_segment(aes(x=beta[1]-0.02,y=beta[2]+0.02, xend = 0.98,yend = -0.1), col = "orange",linetype=2,arrow = arrow(length = unit(0.3, "cm")))+
  geom_label(aes(x=beta[1],y=beta[2]),label = "Điểm tối ưu OLS", vjust = 1.3)+
  geom_label(aes(x=0.95,y=-0.06),label = "Điểm tối ưu Lasso", vjust= -0.3)+
  geom_label(aes(x=0,y=0.4),label = "Miền ràng buộc hệ số")+
  geom_label(aes(x=2.4,y=-1.65),label = "RSS = 240", size = 3)+
  geom_label(aes(x=2.8,y=-2.15),label = "RSS = 550", size = 3)+
  ggtitle("Phương pháp Lasso")
