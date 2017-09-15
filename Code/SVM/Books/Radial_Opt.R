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

library(e1071)
options(width=190)
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
feats = c("userid","bookid","rating");
BCtrain = BCtrain[,feats]
BCtest = BCtest[,feats]
BChold = BChold[,feats]
BCfull=rbind(BCtrain,BCtest,BChold) 

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
cpv = c(10,1,0.1,0.01,0.001,0.0001)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
while(x!=30)
{
pt = proc.time(); 
fit <- svm(rating ~., data = BCtrain,  cost = ms[i], gamma = cpv[j], kernel= "radial", cachesize = 60000)
predictions <- predict(fit, BCtest)
outsettab <- table(pred = predictions, true = BCtest[,3])
acc = geterr(outsettab, 'RMSE', nrow(BCtest), nrow(outsettab))
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

# co = 10
#   ga = 0.01 
  print("Hold out validation")
  pt = proc.time(); 
  tunn <- svm(rating ~., data = BCtrain, cost = best_ms, gamma = best_cpv,kernel= "radial", cachesize = 60000)
  svm.pred_hold <- predict(tunn, BChold)
  outsettab <- table(pred = svm.pred_hold, true = BChold[,3])
  
  acc = geterr(outsettab, 'RMSE', nrow(YRhold), nrow(outsettab))
  print(acc)
  print(proc.time() - pt)
}