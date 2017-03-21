source("helper_linear.R")
library(e1071)
options(width=190)

JoinAll_linear <- function(WTtrain,WTtest,WThold){
co = 1
pt = proc.time(); 

if(TRUE){

ms = c(0.1,1,10,100,1000)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
best_cpv = 0
while(x!=5)
{
pt = proc.time(); 
tunn <- svm(weekly_sales ~., data = WTtrain,  cost = ms[i], kernel= "linear", cachesize = 60000)
svm.pred_hold <- predict(tunn, WTtest)
outsettab <- table(pred = svm.pred_hold, true = WTtest[,1])
acc = geterr(outsettab, '01', nrow(WTtest))
if(best < acc){
	best = acc;best_ms = ms[i];
}
print(acc)
print(proc.time() - pt)
x <- x + 1
j <- j + 1

}

tunn <- svm(weekly_sales ~., data = WTtrain,  cost = best_ms, kernel= "linear", cachesize = 60000)
svm.pred_hold <- predict(tunn, WThold)
outsettab <- table(pred = svm.pred_hold, true = WThold[,1])
acc = geterr(outsettab, '01', nrow(WThold), nrow(outsettab))
print(proc.time() - pt)
print(acc)
}
