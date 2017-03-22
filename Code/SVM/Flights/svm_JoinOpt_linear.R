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

source("helper_linear.R")
source("allentropyinfogain.R")
library(e1071)
options(width=190)

JoinOpt_linear <- function(WTtrain,WTtest,WThold){
co = 100

pt = proc.time(); 

if(TRUE){

ms = c(0.1,1,10,100,1000)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
best_cpv = 0
while(x!=5)
{
pt = proc.time(); 
fit <- svm(codeshare ~., data = WTtrain,  cost = ms[i], kernel= "linear", cachesize = 60000)
svm.pred_hold <- predict(tunn, WTtest)
outsettab <- table(pred = svm.pred_hold, true = WTtest[,1])
acc = geterr(outsettab, '01', nrow(WTtest))
if(best<acc){
  best = acc;best_ms = ms[i];
}
print(acc)
print(proc.time() - pt)
x <- x + 1
j <- j + 1

}
}

tunn <- svm(codeshare ~., data = WTtrain, cost = best_ms, kernel= "linear", cachesize = 60000)
svm.pred_hold <- predict(tunn, WThold)
outsettab <- table(pred = svm.pred_hold, true = WThold[,1])
print(proc.time() - pt)
acc = geterr(outsettab, '01', nrow(WThold))
print(acc)
