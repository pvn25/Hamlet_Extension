source("svm_JoinAll_radial.R")

library(e1071)
options(width=190)

WTtrain=read.csv("WTtrain_new.csv");
WTtest=read.csv("WTtest_new.csv");
WThold=read.csv("WThold_new.csv");
WTtrain=WTtrain[,-1] #get rid of sid
#WTtrain=WTtrain[,-1]
WTtest=WTtest[,-1]
WThold=WThold[,-1]

print("For JoinAll Radial:")
print("---------------------------------")
JoinAll_radial(WTtrain,WTtest,WThold)