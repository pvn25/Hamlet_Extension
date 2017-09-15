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

library(RWeka)
source("myfilter.R")

fact =read.csv('playsnew.csv');
dim1=read.csv('artistsnew.csv')
all = merge(fact,dim1,,by="artistid")


dim2=read.csv('usersnew.csv')
all1 = merge(all,dim2,by="userid")
write.csv(all1,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

temp2 = all1[,c("plays","artistid","userid","rock","electronic","indie","pop","hiphop","gender","country","year","numscrobbles","numlistens","age")]
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
LFtraintest <- temp1[block!=k,]
set.seed(15)
trainIndex = sample(1:n, size = round(0.67*n), replace=FALSE)
LFtrain = LFtraintest[trainIndex ,]
LFtest = LFtraintest[-trainIndex ,]
LFhold <- temp1[block==k,]

LFtrain = LFtrain[,-1]
LFtest=LFtest[,-1]
LFhold = LFhold[,-1]
LFfull=rbind(LFtrain,LFtest,LFhold)

feats= c("userid","artistid","plays")
LFtrain = LFtrain[,feats]
LFtest = LFtest[,feats]
LFhold = LFhold[,feats]

LFtrain$artistid = factor(LFtrain$artistid, levels=levels(LFfull$artistid));
LFtrain$userid = factor(LFtrain$userid, levels=levels(LFfull$userid));
# LFtrain$country = factor(LFtrain$country, levels=levels(LFfull$country));

LFtest$artistid = factor(LFtest$artistid, levels=levels(LFfull$artistid));
LFtest$userid = factor(LFtest$userid, levels=levels(LFfull$userid));
#LFtest$country = factor(LFtest$country, levels=levels(LFfull$country));

LFhold$artistid = factor(LFhold$artistid, levels=levels(LFfull$artistid));
LFhold$userid = factor(LFhold$userid, levels=levels(LFfull$userid));
#LFhold$country = factor(LFhold$country, levels=levels(LFfull$country));

fit <- IBk(plays ~ ., data = LFtrain, control = Weka_control(K = 1, X = TRUE))
print(fit)
predictions <- predict(fit, LFhold,class = "class")
print(predictions)
outsettab <- table(pred = predictions, true = LFhold[,3])
acc = geterr(outsettab, 'RMSE', nrow(LFhold))
print(acc)
}