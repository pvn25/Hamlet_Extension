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

source("svm_JoinOpt_linear.R")

library(e1071)
options(width=190)

WTtrain=read.csv("WTtrain_new.csv");
WTtest=read.csv("WTtest_new.csv");
WThold=read.csv("WThold_new.csv");
WTtrain=WTtrain[,-1] #get rid of sid
#WTtrain=WTtrain[,-1]
WTtest=WTtest[,-1]
WThold=WThold[,-1]

WTtrain=WTtrain[,c("weekly_sales","dept","store","purchaseid")]
WTtest=WTtest[,c("weekly_sales","dept","store","purchaseid")]
WThold=WThold[,c("weekly_sales","dept","store","purchaseid")]
print("For JoinOpt Linear:")
print("---------------------------------")

JoinOpt_linear(WTtrain,WTtest,WThold)
