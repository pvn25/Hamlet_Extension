library(e1071)
options(width=190)
source("myfilter.R")

BCtrain=read.csv("BCtrain_new.csv");
BCtest=read.csv("BCtest_new.csv");
BChold=read.csv("BChold_new.csv");
BCfull=rbind(BCtrain,BCtest,BChold) 

feats = c("userid","bookid","rating");
BCtrain = BCtrain[,feats]
BCtest = BCtest[,feats]
BChold = BChold[,feats]

#userid,bookid,rating,titlewords,authorwords,year,publisher,country,age

BCtrain$bookid = factor(BCtrain$bookid, levels=levels(BCfull$bookid));
BCtrain$userid = factor(BCtrain$userid, levels=levels(BCfull$userid));
#BCtrain$country = factor(BCtrain$country, levels=levels(BCfull$country));
# BCtrain$publisher = factor(BCtrain$publisher, levels=levels(BCfull$publisher));
# BCtrain$year = factor(BCtrain$year, levels=levels(BCfull$year));

BCtest$bookid = factor(BCtest$bookid, levels=levels(BCfull$bookid));
BCtest$userid = factor(BCtest$userid, levels=levels(BCfull$userid));
#BCtest$country = factor(BCtest$country, levels=levels(BCfull$country));
# BCtest$publisher = factor(BCtest$publisher, levels=levels(BCfull$publisher));
# BCtest$year = factor(BCtest$year, levels=levels(BCfull$year));

BChold$bookid = factor(BChold$bookid, levels=levels(BCfull$bookid));
BChold$userid = factor(BChold$userid, levels=levels(BCfull$userid));
#BChold$country = factor(BChold$country, levels=levels(BCfull$country));
# BChold$publisher = factor(BChold$publisher, levels=levels(BCfull$publisher));
# BChold$year = factor(BChold$year, levels=levels(BCfull$year));

if(TRUE){

ms = c(0.1,1,10,100,1000)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
while(x!=5)
{
pt = proc.time(); 
fit <- svm(rating ~., data = BCtrain,  cost = ms[i], kernel= "linear", cachesize = 60000)
predictions <- predict(fit, BCtest)
outsettab <- table(pred = predictions, true = BCtest[,3])
acc = geterr(outsettab, '01', nrow(BCtest), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];
}
print(acc)
print(proc.time() - pt)
x <- x + 1
j <- j + 1

}
}


co = 10
pt = proc.time(); 
tunn <- svm(rating ~., data = BCtrain,  cost = best_ms, kernel= "linear", cachesize = 60000)
# print(proc.time() - pt)
# pt = proc.time(); 
svm.pred_hold <- predict(tunn, BChold)
outsettab <- table(pred = svm.pred_hold, true = BChold[,3])
acc = geterr(outsettab, '01', nrow(BChold), nrow(outsettab))
print(proc.time() - pt)
print(acc)
