source("allentropyinfogain.R")
source("svm_JoinOpt_linear.R")
source("svm_JoinAll_linear.R")
source("svm_JoinOpt_radial.R")
source("svm_JoinAll_radial.R")

library(e1071)
options(width=190)

LFtrain=read.csv("LFsub2train_new.csv");
LFtest=read.csv("LFsub2test_new.csv");
LFhold=read.csv("LFsub2hold_new.csv");
LFfull=rbind(LFtrain,LFtest,LFhold)

LFtrain$artistid = factor(LFtrain$artistid, levels=levels(LFfull$artistid));
LFtrain$userid = factor(LFtrain$userid, levels=levels(LFfull$userid));
LFtrain$country = factor(LFtrain$country, levels=levels(LFfull$country));

LFtest$artistid = factor(LFtest$artistid, levels=levels(LFfull$artistid));
LFtest$userid = factor(LFtest$userid, levels=levels(LFfull$userid));
LFtest$country = factor(LFtest$country, levels=levels(LFfull$country));

LFhold$artistid = factor(LFhold$artistid, levels=levels(LFfull$artistid));
LFhold$userid = factor(LFhold$userid, levels=levels(LFfull$userid));
LFhold$country = factor(LFhold$country, levels=levels(LFfull$country));

# LFtrain=LFtrain[,c("userid", "artistid","plays","gender","age","country","year")]
# LFtest=LFtest[,c("userid", "artistid","plays","gender","age","country","year")]
# LFhold=LFhold[,c("userid", "artistid","plays","gender","age","country","year")]

LFtrain=LFtrain[,c("userid", "artistid","plays")]
LFtest=LFtest[,c("userid", "artistid","plays")]
LFhold=LFhold[,c("userid", "artistid","plays")]
print("For JoinOpt Radial:")
print("---------------------------------")

JoinOpt_radial(LFtrain,LFtest,LFhold)