source("svm_JoinOpt_radial.R")
library(e1071)
options(width=190)

WTtrain=read.csv("WTtrain_new.csv");
WTtest=read.csv("WTtest_new.csv");
WThold=read.csv("WThold_new.csv");
# WTtrain=WTtrain[sample(1:nrow(WTtrain),10000),-1] #get rid of sid
# #WTtrain=WTtrain[,-1]
# WTtest=WTtest[sample(1:nrow(WTtest),10000),-1]
# WThold=WThold[sample(1:nrow(WThold),10000),-1]

WTtrain = WTtrain[,-1]
WTtest = WTtest[,-1]
WThold = WThold[,-1]

WTtrain=WTtrain[,c("weekly_sales","dept","store","purchaseid")]
WTtest=WTtest[,c("weekly_sales","dept","store","purchaseid")]
WThold=WThold[,c("weekly_sales","dept","store","purchaseid")]
print("For JoinOpt Radial:")
print("---------------------------------")

JoinOpt_radial(WTtrain,WTtest,WThold)