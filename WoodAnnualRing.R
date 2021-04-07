library(mgcv)
opar=
par(mai=c(0,0,0,0))
par(mfcol=c(5,6))
for( i in 1:30){
n <- 2e2 ; 
x <- runif (n) ; 
y <- runif (n) ; 
v <- sample (0:1,n,T)
g <- gam ( v ~ s(x,y,m=4.2))#, family=poisson )
vis.gam(g,plot.type="contour", type="response", contour.col=cm.colors(20),n.grid=180,xaxt="n",yaxt="n",main="", nlevels=100,lwd=30)
#points(x,y,pch=19+v+v, xlim=0:1, ylim=0:1, pty="m",cex=0.2,lwd=0.1)
}
warnings () 
summary(g)
?vis.gam
?gam
? contour

?rainbow


library(mgcv);par(mai=c(0,0,0,0));par(mfcol=c(5,6));for( i in 1:30){n <- 2e2 ; x <- runif (n) ; y <- runif (n) ; v <- sample (0:1,n,T);g <- gam ( v ~ s(x,y,m=4.2)); vis.gam(g,plot.type="contour", type="response", contour.col=cm.colors(20),n.grid=180,xaxt="n",yaxt="n",main="", nlevels=100,lwd=30)}
