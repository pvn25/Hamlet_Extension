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

YRtrain=read.csv("YRtrain_new.csv");
YRtest=read.csv("YRtest_new.csv");
YRhold=read.csv("YRhold_new.csv");
YRtrain=YRtrain[,-1] #get rid of reviewid
YRtest=YRtest[,-1]
YRhold=YRhold[,-1]
YRfull=rbind(YRtrain,YRtest,YRhold);

YRfull$userid = factor(YRfull$userid)
YRfull$businessid = factor(YRfull$businessid)
YRfull$stars = factor(YRfull$stars)
YRfull$city = factor(YRfull$city)
YRfull$state = factor(YRfull$state)
YRfull$ustars = factor(YRfull$ustars)
YRfull$ureviewcnt = factor(YRfull$ureviewcnt)
YRfull$vuseful = factor(YRfull$vuseful)
YRfull$vfunny = factor(YRfull$vfunny)
YRfull$vcool = factor(YRfull$vcool)
YRfull$latitude = factor(YRfull$latitude)
YRfull$longitude = factor(YRfull$longitude)
YRfull$bstars = factor(YRfull$bstars)
YRfull$breviewcnt = factor(YRfull$breviewcnt)
YRfull$wday1 = factor(YRfull$wday1)
YRfull$wday2 = factor(YRfull$wday2)
YRfull$wday3 = factor(YRfull$wday3)
YRfull$wday4 = factor(YRfull$wday4)
YRfull$wday5 = factor(YRfull$wday5)
YRfull$wend1 = factor(YRfull$wend1)
YRfull$wend2 = factor(YRfull$wend2)
YRfull$wend3 = factor(YRfull$wend3)
YRfull$wend4 = factor(YRfull$wend4)
YRfull$wend5 = factor(YRfull$wend5)

YRtrain$userid = factor(YRtrain$userid, levels=levels(YRfull$userid));
YRtrain$businessid = factor(YRtrain$businessid, levels=levels(YRfull$businessid));
YRtrain$stars = factor(YRtrain$stars, levels=levels(YRfull$stars));
YRtrain$city = factor(YRtrain$city, levels=levels(YRfull$city));
YRtrain$state = factor(YRtrain$state, levels=levels(YRfull$state));
YRtrain$ustars = factor(YRtrain$ustars, levels=levels(YRfull$ustars));
YRtrain$ureviewcnt = factor(YRtrain$ureviewcnt, levels=levels(YRfull$ureviewcnt));
YRtrain$vuseful = factor(YRtrain$vuseful, levels=levels(YRfull$vuseful));
YRtrain$vfunny = factor(YRtrain$vfunny, levels=levels(YRfull$vfunny));
YRtrain$vcool = factor(YRtrain$vcool, levels=levels(YRfull$vcool));
YRtrain$latitude = factor(YRtrain$latitude, levels=levels(YRfull$latitude));
YRtrain$longitude = factor(YRtrain$longitude, levels=levels(YRfull$longitude));
YRtrain$bstars = factor(YRtrain$bstars, levels=levels(YRfull$bstars));
YRtrain$breviewcnt = factor(YRtrain$breviewcnt, levels=levels(YRfull$breviewcnt));
YRtrain$wday1 = factor(YRtrain$wday1, levels=levels(YRfull$wday1));
YRtrain$wday2 = factor(YRtrain$wday2, levels=levels(YRfull$wday2));
YRtrain$wday3 = factor(YRtrain$wday3, levels=levels(YRfull$wday3));
YRtrain$wday4 = factor(YRtrain$wday4, levels=levels(YRfull$wday4));
YRtrain$wday5 = factor(YRtrain$wday5, levels=levels(YRfull$wday5));
YRtrain$wend1 = factor(YRtrain$wend1, levels=levels(YRfull$wend1));
YRtrain$wend2 = factor(YRtrain$wend2, levels=levels(YRfull$wend2));
YRtrain$wend3 = factor(YRtrain$wend3, levels=levels(YRfull$wend3));
YRtrain$wend4 = factor(YRtrain$wend4, levels=levels(YRfull$wend4));
YRtrain$wend5 = factor(YRtrain$wend5, levels=levels(YRfull$wend5));

YRtest$userid = factor(YRtest$userid, levels=levels(YRfull$userid));
YRtest$businessid = factor(YRtest$businessid, levels=levels(YRfull$businessid));
YRtest$stars = factor(YRtest$stars, levels=levels(YRfull$stars));
YRtest$city = factor(YRtest$city, levels=levels(YRfull$city));
YRtest$state = factor(YRtest$state, levels=levels(YRfull$state));
YRtest$ustars = factor(YRtest$ustars, levels=levels(YRfull$ustars));
YRtest$ureviewcnt = factor(YRtest$ureviewcnt, levels=levels(YRfull$ureviewcnt));
YRtest$vuseful = factor(YRtest$vuseful, levels=levels(YRfull$vuseful));
YRtest$vfunny = factor(YRtest$vfunny, levels=levels(YRfull$vfunny));
YRtest$vcool = factor(YRtest$vcool, levels=levels(YRfull$vcool));
YRtest$latitude = factor(YRtest$latitude, levels=levels(YRfull$latitude));
YRtest$longitude = factor(YRtest$longitude, levels=levels(YRfull$longitude));
YRtest$bstars = factor(YRtest$bstars, levels=levels(YRfull$bstars));
YRtest$breviewcnt = factor(YRtest$breviewcnt, levels=levels(YRfull$breviewcnt));
YRtest$wday1 = factor(YRtest$wday1, levels=levels(YRfull$wday1));
YRtest$wday2 = factor(YRtest$wday2, levels=levels(YRfull$wday2));
YRtest$wday3 = factor(YRtest$wday3, levels=levels(YRfull$wday3));
YRtest$wday4 = factor(YRtest$wday4, levels=levels(YRfull$wday4));
YRtest$wday5 = factor(YRtest$wday5, levels=levels(YRfull$wday5));
YRtest$wend1 = factor(YRtest$wend1, levels=levels(YRfull$wend1));
YRtest$wend2 = factor(YRtest$wend2, levels=levels(YRfull$wend2));
YRtest$wend3 = factor(YRtest$wend3, levels=levels(YRfull$wend3));
YRtest$wend4 = factor(YRtest$wend4, levels=levels(YRfull$wend4));
YRtest$wend5 = factor(YRtest$wend5, levels=levels(YRfull$wend5));

YRhold$userid = factor(YRhold$userid, levels=levels(YRfull$userid));
YRhold$businessid = factor(YRhold$businessid, levels=levels(YRfull$businessid));
YRhold$stars = factor(YRhold$stars, levels=levels(YRfull$stars));
YRhold$city = factor(YRhold$city, levels=levels(YRfull$city));
YRhold$state = factor(YRhold$state, levels=levels(YRfull$state));
YRhold$ustars = factor(YRhold$ustars, levels=levels(YRfull$ustars));
YRhold$ureviewcnt = factor(YRhold$ureviewcnt, levels=levels(YRfull$ureviewcnt));
YRhold$vuseful = factor(YRhold$vuseful, levels=levels(YRfull$vuseful));
YRhold$vfunny = factor(YRhold$vfunny, levels=levels(YRfull$vfunny));
YRhold$vcool = factor(YRhold$vcool, levels=levels(YRfull$vcool));
YRhold$latitude = factor(YRhold$latitude, levels=levels(YRfull$latitude));
YRhold$longitude = factor(YRhold$longitude, levels=levels(YRfull$longitude));
YRhold$bstars = factor(YRhold$bstars, levels=levels(YRfull$bstars));
YRhold$breviewcnt = factor(YRhold$breviewcnt, levels=levels(YRfull$breviewcnt));
YRhold$wday1 = factor(YRhold$wday1, levels=levels(YRfull$wday1));
YRhold$wday2 = factor(YRhold$wday2, levels=levels(YRfull$wday2));
YRhold$wday3 = factor(YRhold$wday3, levels=levels(YRfull$wday3));
YRhold$wday4 = factor(YRhold$wday4, levels=levels(YRfull$wday4));
YRhold$wday5 = factor(YRhold$wday5, levels=levels(YRfull$wday5));
YRhold$wend1 = factor(YRhold$wend1, levels=levels(YRfull$wend1));
YRhold$wend2 = factor(YRhold$wend2, levels=levels(YRfull$wend2));
YRhold$wend3 = factor(YRhold$wend3, levels=levels(YRfull$wend3));
YRhold$wend4 = factor(YRhold$wend4, levels=levels(YRfull$wend4));
YRhold$wend5 = factor(YRhold$wend5, levels=levels(YRfull$wend5));


allfeats = names(YRhold);
allfeatsfk = c("userid", "businessid");
allfeatsnofk = setdiff(allfeats, allfeatsfk);

YRtrain = YRtrain[,allfeatsnofk]
YRtest = YRtest[,allfeatsnofk]
YRhold = YRhold[,allfeatsnofk]
#print(names(YRhold))

if(FALSE){
ms = c(1,10,100,1000)
# cpv = c(0,0.025,0.05,0.075,0.1,0.01,0.001,0.0001)
cpv = c(0,0.1,0.01,0.001,0.0001)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
best_cpv = 0
while(x!=20)
{
pt = proc.time(); 
fit <- rpart(stars~., data=YRtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'gini'))
predictions <- predict(fit, YRtest, type="class")
outsettab <- table(pred = predictions, true = YRtest[,1])
acc = geterr(outsettab, '01', nrow(YRtest), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];best_cpv = cpv[j];
}
print(acc)
print(proc.time() - pt)
x <- x + 1
j <- j + 1
if(j==6){
i <- (i + 1)
j <- 1
}
}
}


#sink("dt_jall10.txt")
pt = proc.time();
fit <- rpart(stars~., data=YRtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'gini'))
#fit <- prune(fitt, cp = 0.01)
summary(fit)
# make predictions
predictions <- predict(fit, YRhold, type="class")
outsettab <- table(pred = predictions, true = YRhold[,1])

acc = geterr(outsettab, '01', nrow(YRhold), nrow(outsettab))
print(acc)
#sink()
print(proc.time() - pt)
