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

YRtrain = YRtrain[,-1]
YRtest=YRtest[,-1]
YRhold = YRhold[,-1]

feats = c("stars","userid", "businessid");
YRtrain_new=YRtrain[,feats] #get rid of reviewid
YRtest_new=YRtest[,feats]
YRhold_new=YRhold[,feats]
YRfull_new=rbind(YRtrain_new,YRtest_new,YRhold_new);
YRfull_new$userid = factor(YRfull_new$userid)
YRfull_new$businessid = factor(YRfull_new$businessid)
YRfull_new$stars = factor(YRfull_new$stars)

YRtrain_new$userid = factor(YRtrain_new$userid, levels=levels(YRfull_new$userid));
YRtrain_new$businessid = factor(YRtrain_new$businessid, levels=levels(YRfull_new$businessid));
YRtrain_new$stars = factor(YRtrain_new$stars, levels=levels(YRfull_new$stars));

YRtest_new$userid = factor(YRtest_new$userid, levels=levels(YRfull_new$userid));
YRtest_new$businessid = factor(YRtest_new$businessid, levels=levels(YRfull_new$businessid));
YRtest_new$stars = factor(YRtest_new$stars, levels=levels(YRfull_new$stars));

YRhold_new$userid = factor(YRhold_new$userid, levels=levels(YRfull_new$userid));
YRhold_new$businessid = factor(YRhold_new$businessid, levels=levels(YRfull_new$businessid));
YRhold_new$stars = factor(YRhold_new$stars, levels=levels(YRfull_new$stars));

 co = 1
  ga = 0.1 

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
 tunn <- svm(stars ~., data = YRtrain_new, cost = ms[i], gamma = cpv[j],kernel= "radial", cachesize = 60000)
  svm.pred_hold <- predict(tunn, YRtest_new)
  outsettab <- table(pred = svm.pred_hold, true = YRtest_new[,1])
  acc = geterr(outsettab, 'RMSE', nrow(YRtest_new), nrow(outsettab))
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
  tunn <- svm(stars ~., data = YRtrain_new, cost = best_ms, gamma = best_cpv,kernel= "radial", cachesize = 60000)
  svm.pred_hold <- predict(tunn, YRhold_new)
  outsettab <- table(pred = svm.pred_hold, true = YRhold_new[,1])
  acc = geterr(outsettab, 'RMSE', nrow(YRhold_new), nrow(outsettab))
  print(acc)
  
}