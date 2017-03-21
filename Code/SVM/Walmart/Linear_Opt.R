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
