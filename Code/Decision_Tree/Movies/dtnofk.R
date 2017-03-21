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

MLtrain=read.csv("MLtrain_new.csv");
MLtest=read.csv("MLtest_new.csv");
MLhold=read.csv("MLhold_new.csv");

MLfull = rbind(MLtrain, MLtest, MLhold);
MLtrain$movieid = factor(MLtrain$movieid, levels=levels(MLfull$movieid));
MLtrain$userid = factor(MLtrain$userid, levels=levels(MLfull$userid));
MLtrain$zipcode = factor(MLtrain$zipcode, levels=levels(MLfull$zipcode));

MLtest$movieid = factor(MLtest$movieid, levels=levels(MLfull$movieid));
MLtest$userid = factor(MLtest$userid, levels=levels(MLfull$userid));
MLtest$zipcode = factor(MLtest$zipcode, levels=levels(MLfull$zipcode));

MLhold$movieid = factor(MLhold$movieid, levels=levels(MLfull$movieid));
MLhold$userid = factor(MLhold$userid, levels=levels(MLfull$userid));
MLhold$zipcode = factor(MLhold$zipcode, levels=levels(MLfull$zipcode));

MLtrain = MLtrain[,c(-1,-2)]
#print(names(MLtrain))
MLtest = MLtest[,c(-1,-2)]
MLhold = MLhold[,c(-1,-2)]

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
fit <- rpart(rating~., data=MLtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'information'))
predictions <- predict(fit, MLtest, type="class")
outsettab <- table(pred = predictions, true = MLtest[,1])
acc = geterr(outsettab, '01', nrow(MLtest), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];best_cpv = cpv[j];
}
#print(acc)
tm = tm + proc.time() - pt
#print(proc.time() - pt)
x <- x + 1
j <- (j + 1)
if(j==6){
i <- (i + 1)
j <- 1
}
}
}
print(tm)
pt = proc.time(); 
fit <- rpart(rating~., data=MLtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'information'))
summary(fit)
predictions <- predict(fit, MLhold, type="class")
outsettab <- table(pred = predictions, true = MLhold[,1])
acc = geterr(outsettab, '01', nrow(MLhold), nrow(outsettab))
print(acc)
print(proc.time() - pt)
