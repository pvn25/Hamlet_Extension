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

YRtrain=read.csv("YRtrain_new.csv");
YRtest=read.csv("YRtest_new.csv");
YRhold=read.csv("YRhold_new.csv");
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
acc = geterr(outsettab, '01', nrow(YRhold))
print(acc)
