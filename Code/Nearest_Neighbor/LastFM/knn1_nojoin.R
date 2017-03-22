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

LFtrain=read.csv("LFsub2train_new.csv");
LFtest=read.csv("LFsub2test_new.csv");
LFhold=read.csv("LFsub2hold_new.csv");
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
acc = geterr(outsettab, '01', nrow(LFhold))
print(acc)
