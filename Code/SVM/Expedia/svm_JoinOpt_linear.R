source("helper_linear.R")
source("allentropyinfogain.R")
library(e1071)
options(width=190)

JoinOpt_linear <- function(WTtrain,WTtest,WThold){
co = 100

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
fit <- svm(position ~., data = WTtrain,  cost = ms[i], kernel= "linear", cachesize = 60000)
svm.pred_hold <- predict(tunn, WTtest)
outsettab <- table(pred = svm.pred_hold, true = WTtest[,2])
acc = geterr(outsettab, '01', nrow(WTtest))
if(best<acc){
	best = acc;best_ms = ms[i];
}
print(acc)
print(proc.time() - pt)
x <- x + 1
j <- j + 1

}
}

pt = proc.time(); 

tunn <- svm(position ~., data = WTtrain, cost = best_ms, kernel= "linear", cachesize = 60000)
svm.pred_hold <- predict(tunn, WThold)
outsettab <- table(pred = svm.pred_hold, true = WThold[,2])
print(proc.time() - pt)
acc = geterr(outsettab, '01', nrow(WThold))
print(acc)
}