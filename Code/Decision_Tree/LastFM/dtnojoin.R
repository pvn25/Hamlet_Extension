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
fit <- rpart(plays~., data=LFtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'gini'))
predictions <- predict(fit, LFtest, type="class")
outsettab <- table(pred = predictions, true = LFtest[,3])
acc = geterr(outsettab, '01', nrow(LFtest), nrow(outsettab))
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
fit <- rpart(plays~., data=LFtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'gini'))
#fit <- prune(fitt, cp = 0.01)
#summary(fit)
# make predictions
predictions <- predict(fit, LFhold, type="class")
outsettab <- table(pred = predictions, true = LFhold[,3])

acc = geterr(outsettab, '01', nrow(LFhold), nrow(outsettab))
print(acc)
#sink()
print(proc.time() - pt)
