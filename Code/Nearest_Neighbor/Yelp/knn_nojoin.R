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

fact =read.csv('reviewfinal.csv');
dim1=read.csv('usergend.csv')
all = merge(fact,dim1,,by="userid")

dim2=read.csv('businesscheckin.csv')
all1 = merge(all,dim2,by="businessid")
write.csv(all1,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

temp2 = all1[,c("stars","businessid","userid","gender","cat109","cat363","cat361","cat366","cat344","cat33","city","cat501","cat444","cat404","cat259","cat246","cat79","open","cat221","cat314","cat104","state","ureviewcnt","ustars","vuseful","vfunny","vcool","latitude","longitude","bstars","breviewcnt","wday1","wday2","wday3","wday4","wday5","wend1","wend2","wend3","wend4","wend5")]
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
YRtraintest <- temp1[block!=k,]
set.seed(15)
trainIndex = sample(1:n, size = round(0.67*n), replace=FALSE)
YRtrain = YRtraintest[trainIndex ,]
YRtest = YRtraintest[-trainIndex ,]
YRhold <- temp1[block==k,]
YRtrain=YRtrain[,-1] #get rid of reviewid
YRtest=YRtest[,-1]
YRhold=YRhold[,-1]
YRfull=rbind(YRtrain,YRtest,YRhold);

feats = c("stars","userid", "businessid");
YRtrain=YRtrain[,feats] #get rid of reviewid
YRtest=YRtest[,feats]
YRhold=YRhold[,feats]
YRfull$userid = factor(YRfull$userid)
YRfull$businessid = factor(YRfull$businessid)
YRfull$stars = factor(YRfull$stars)

YRtrain$userid = factor(YRtrain$userid, levels=levels(YRfull$userid));
YRtrain$businessid = factor(YRtrain$businessid, levels=levels(YRfull$businessid));
YRtrain$stars = factor(YRtrain$stars, levels=levels(YRfull$stars));

YRtest$userid = factor(YRtest$userid, levels=levels(YRfull$userid));
YRtest$businessid = factor(YRtest$businessid, levels=levels(YRfull$businessid));
YRtest$stars = factor(YRtest$stars, levels=levels(YRfull$stars));

YRhold$userid = factor(YRhold$userid, levels=levels(YRfull$userid));
YRhold$businessid = factor(YRhold$businessid, levels=levels(YRfull$businessid));
YRhold$stars = factor(YRhold$stars, levels=levels(YRfull$stars));

fit <- IBk(stars ~ ., data = YRtrain, control = Weka_control(K = 1))
print(fit)
predictions <- predict(fit, YRhold,class = "class")
print(predictions)
outsettab <- table(pred = predictions, true = YRhold[,1])
acc = geterr(outsettab, 'RMSE', nrow(YRhold))
print(acc)
}