source("svm_JoinOpt_radial.R")

library(e1071)
options(width=190)

MLtrain=read.csv("MLtrain_new.csv");
MLtest=read.csv("MLtest_new.csv");
MLhold=read.csv("MLhold_new.csv");

MLfull = rbind(MLtrain,MLtest,MLhold)

MLtrain$movieid = factor(MLtrain$movieid, levels=levels(MLfull$movieid));
MLtrain$userid = factor(MLtrain$userid, levels=levels(MLfull$userid));

MLtest$movieid = factor(MLtest$movieid, levels=levels(MLfull$movieid));
MLtest$userid = factor(MLtest$userid, levels=levels(MLfull$userid));

MLhold$movieid = factor(MLhold$movieid, levels=levels(MLfull$movieid));
MLhold$userid = factor(MLhold$userid, levels=levels(MLfull$userid));

MLtrain=MLtrain[,c("movieid","userid", "rating")]
MLtest=MLtest[,c("movieid","userid", "rating")]
MLhold=MLhold[,c("movieid","userid", "rating")]

print("For JoinOpt Radial:")
print("---------------------------------")

JoinOpt_radial(MLtrain,MLtest,MLhold)