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

fact =read.csv('ratingsnew.csv');
dim1=read.csv('booksnew.csv')
all = merge(fact,dim1,,by="bookid")


dim2=read.csv('usersnew.csv')
all1 = merge(all,dim2,by="userid")
write.csv(all1,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
temp2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]
# write.csv(all2,'all2.csv')
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
BCtraintest <- temp1[block!=k,]
set.seed(15)
trainIndex = sample(1:n, size = round(0.67*n), replace=FALSE)
BCtrain = BCtraintest[trainIndex ,]
BCtest = BCtraintest[-trainIndex ,]
BChold <- temp1[block==k,]
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
fit <- rpart(rating~., data=BCtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'gini'))
predictions <- predict(fit, BCtest, type="class")
outsettab <- table(pred = predictions, true = BCtest[,3])
acc = geterr(outsettab, '01', nrow(BCtest), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];best_cpv = cpv[j];
}
print(acc)
tm = tm + proc.time() - pt
print(proc.time() - pt)
x <- x + 1
j <- j + 1
if(j==6){
i <- (i + 1)
j <- 1
}
}
}

print(tm)
#sink("dt_jall10.txt")
pt = proc.time();
print(best_ms)
print(best_cpv)
fit <- rpart(rating~., data=BCtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'gini'))
#fit <- prune(fitt, cp = 0.01)
#summary(fit)
# make predictions
predictions <- predict(fit, BChold, type="class")
outsettab <- table(pred = predictions, true = BChold[,3])

acc = geterr(outsettab, '01', nrow(BChold), nrow(outsettab))
print(acc)
#sink()
print(proc.time() - pt)
}