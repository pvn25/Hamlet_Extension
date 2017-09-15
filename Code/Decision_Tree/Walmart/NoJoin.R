#Copyright 2017 Vraj Shah, Arun Kumar
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

library(rpart)
source("myfilter.R")
fact =read.csv('salesnew.csv');
dim1=read.csv('storesnew.csv')
all = merge(fact,dim1,,by="store")

dim2=read.csv('purchasenew.csv')
all1 = merge(all,dim2,by="purchaseid")
write.csv(all1,'all1.csv')

temp2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# write.csv(all2,'all2.csv')
# temp2 = read.csv("all2.csv");
set.seed(5)
temp1 <- temp2[sample(nrow(temp2)),]
n <- nrow(temp1)
K <- 10
size <- n %/% K

rdm <- runif(n)
ranked <- rank(rdm)
block <- (ranked-1) %/% size+1
block <- as.factor(block)

for (k in 1:K) {
WTtraintest <- temp1[block!=k,]
set.seed(15)
trainIndex = sample(1:n, size = round(0.67*n), replace=FALSE)
WTtrain = WTtraintest[trainIndex ,]
WTtest = WTtraintest[-trainIndex ,]
WThold <- temp1[block==k,]

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
acc = geterr(outsettab, 'RMSE', nrow(WTtest), nrow(outsettab))
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
acc = geterr(outsettab, 'RMSE', nrow(WThold), nrow(outsettab))
print(acc)
#print(proc.time() - pt)
sink()
}