source("svm_JoinAll_linear.R")

library(e1071)
options(width=190)

WTtrain=read.csv("WTtrain_new.csv");
WTtest=read.csv("WTtest_new.csv");
WThold=read.csv("WThold_new.csv");
WTtrain=WTtrain[,-1] #get rid of sid
WTtest=WTtest[,-1]
WThold=WThold[,-1]

print("For JoinAll Linear:")
print("---------------------------------")
JoinAll_linear(WTtrain,WTtest,WThold)
