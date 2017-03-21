source("helper_radial.R")
library(e1071)
options(width=190)

JoinOpt_radial <- function(WTtrain,WTtest,WThold){
  co = 1
  ga = 0.01 

if(TRUE){
ms = c(0.1,1,10,100,1000)
cpv = c(10,1,0.1,0.01,0.001,0.0001)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
best_cpv = 0
while(x!=30)
{
pt = proc.time(); 
tunn <- svm(codeshare ~., data = WTtrain,  cost = ms[i], gamma = cpv[j],kernel= "radial", cachesize = 60000)  
  svm.pred_hold <- predict(tunn, WTtest)
  outsettab <- table(pred = svm.pred_hold, true = WTtest[,1])
  acc = geterr(outsettab, '01', nrow(WTtest))
if(best<acc){
  best = acc;best_ms = ms[i];best_cpv = cpv[j]
}
print(acc)
print(proc.time() - pt)
x <- x + 1
j <- j + 1
if(j==7){
i <- (i + 1)
j <- 1
}
}
}

  print("Hold out validation")
  pt = proc.time(); 
  tunn <- svm(codeshare ~., data = WTtrain, cost = best_ms, gamma = best_cpv,kernel= "radial", cachesize = 60000)
  svm.pred_hold <- predict(tunn, WThold)
  outsettab <- table(pred = svm.pred_hold, true = WThold[,1])
  acc = geterr(outsettab, '01', nrow(WThold), nrow(outsettab))
  print(acc)
  print(proc.time() - pt)
}