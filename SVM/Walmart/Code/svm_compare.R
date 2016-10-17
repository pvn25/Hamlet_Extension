source("allentropyinfogain.R")
source("svm_JoinOpt_linear.R")
source("svm_JoinAll_linear.R")
source("svm_JoinOpt_radial.R")
source("svm_JoinAll_radial.R")

library(e1071)
options(width=190)

WTtrain=read.csv("WTtrain.csv");
WTtest=read.csv("WTtest.csv");
WThold=read.csv("WThold.csv");
WTtrain=WTtrain[sample(nrow(WTtrain), 1000),-1] #get rid of sid
#WTtrain=WTtrain[,-1]
WTtest=WTtest[,-1]
WThold=WThold[,-1]

print("For JoinOpt Linear:")
print("---------------------------------")

JoinOpt_linear(WTtrain,WTtest,WThold)

print("For JoinAll Linear:")
print("---------------------------------")
JoinAll_linear(WTtrain,WTtest,WThold)

print("For JoinOpt Radial:")
print("---------------------------------")

JoinOpt_radial(WTtrain,WTtest,WThold)

print("For JoinAll Radial:")
print("---------------------------------")
JoinAll_radial(WTtrain,WTtest,WThold)
