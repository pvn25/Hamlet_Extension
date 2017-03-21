library(rpart)
source("myfilter.R")

MLtrain=read.csv("MLtrain_new.csv");
MLtest=read.csv("MLtest_new.csv");
MLhold=read.csv("MLhold_new.csv");
MLfull = rbind(MLtrain, MLtest, MLhold);

MLtrain$movieid = factor(MLtrain$movieid, levels=levels(MLfull$movieid));
MLtrain$userid = factor(MLtrain$userid, levels=levels(MLfull$userid));

MLtest$movieid = factor(MLtest$movieid, levels=levels(MLfull$movieid));
MLtest$userid = factor(MLtest$userid, levels=levels(MLfull$userid));

MLhold$movieid = factor(MLhold$movieid, levels=levels(MLfull$movieid));
MLhold$userid = factor(MLhold$userid, levels=levels(MLfull$userid));

MLtrain=MLtrain[,c("movieid","userid","rating")]
MLtest=MLtest[,c("movieid", "userid","rating")]
MLhold=MLhold[,c("movieid", "userid","rating")]

if(TRUE){
ms = c(1,10,100,1000)
cpv = c(0,0.1,0.01,0.001,0.0001)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
best_cpv = 0
tm = 0
while(x!=20)
{
pt = proc.time(); 
fit <- rpart(rating~., data=MLtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'information'))
predictions <- predict(fit, MLtest, type="class")
outsettab <- table(pred = predictions, true = MLtest[,3])
acc = geterr(outsettab, '01', nrow(MLtest), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];best_cpv = cpv[j];
}
#print(acc)
tm = tm + proc.time() - pt
#print(proc.time() - pt)
x <- x + 1
j <- (j + 1)
if(j==6){
i <- (i + 1)
j <- 1
}
}
}

print(tm)
pt = proc.time(); 
fit <- rpart(rating~., data=MLtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'information'))
# summarize the fit
summary(fit)
# make predictions
predictions <- predict(fit, MLhold, type="class")
outsettab <- table(pred = predictions, true = MLhold[,3])
acc = geterr(outsettab, '01', nrow(MLhold), nrow(outsettab))
print(acc)
print(proc.time() - pt)