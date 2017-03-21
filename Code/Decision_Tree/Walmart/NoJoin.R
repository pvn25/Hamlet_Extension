library(rpart)
source("myfilter.R")

WTtrain=read.csv("WTtrain_new.csv");
WTtest=read.csv("WTtest_new.csv");
WThold=read.csv("WThold_new.csv");
WTtrain = WTtrain[,-1]
WTtest=WTtest[,-1]
WThold = WThold[,-1]

WTfull=rbind(WTtrain,WTtest,WThold);#combining data frames by rows

WTfull$dept = factor(WTfull$dept)
WTfull$store = factor(WTfull$store)
WTfull$purchaseid = factor(WTfull$purchaseid)

WTtrain$dept = factor(WTtrain$dept, levels=levels(WTfull$dept));
WTtrain$purchaseid = factor(WTtrain$purchaseid, levels=levels(WTfull$purchaseid));
WTtrain$store = factor(WTtrain$store, levels=levels(WTfull$store));

WTtest$dept = factor(WTtest$dept, levels=levels(WTfull$dept));
WTtest$purchaseid = factor(WTtest$purchaseid, levels=levels(WTfull$purchaseid));
WTtest$store = factor(WTtest$store, levels=levels(WTfull$store));

WThold$dept = factor(WThold$dept, levels=levels(WTfull$dept));
WThold$purchaseid = factor(WThold$purchaseid, levels=levels(WTfull$purchaseid));
WThold$store = factor(WThold$store, levels=levels(WTfull$store));

WTtrain=WTtrain[,c("weekly_sales","dept","store","purchaseid")]
WTtest=WTtest[,c("weekly_sales","dept","store","purchaseid")]
WThold=WThold[,c("weekly_sales","dept","store","purchaseid")]

sink("joptinfo_variablesplit.txt")
if(FALSE){
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
fit <- rpart(weekly_sales~., data=WTtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'information'))
predictions <- predict(fit, WTtest, type="class")
outsettab <- table(pred = predictions, true = WTtest[,1])
acc = geterr(outsettab, '01', nrow(WTtest), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];best_cpv = cpv[j];
}
#print(acc)
tm = tm + proc.time() - pt
#print(proc.time() - pt)
x <- x + 1
j <- j + 1
if(j==6){
i <- (i + 1)
j <- 1
}
}
}
#print(tm)
pt = proc.time(); 
fit <- rpart(weekly_sales~., data=WTtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'information'))
summary(fit)
# make predictions
predictions <- predict(fit, WThold, type="class")
outsettab <- table(pred = predictions, true = WThold[,1])
acc = geterr(outsettab, '01', nrow(WThold), nrow(outsettab))
print(acc)
#print(proc.time() - pt)
sink()