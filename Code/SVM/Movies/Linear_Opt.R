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

MLtrain=read.csv("MLtrain_new.csv");
MLtest=read.csv("MLtest_new.csv");
MLhold=read.csv("MLhold_new.csv");

MLtrain=MLtrain[,c("movieid","userid","rating")]
MLtest=MLtest[,c("movieid","userid", "rating")]
MLhold=MLhold[,c("movieid", "userid","rating")]
MLfull = rbind(MLtrain,MLtest,MLhold)

MLtrain$movieid = factor(MLtrain$movieid, levels=levels(MLfull$movieid));
MLtrain$userid = factor(MLtrain$userid, levels=levels(MLfull$userid));

MLtest$movieid = factor(MLtest$movieid, levels=levels(MLfull$movieid));
MLtest$userid = factor(MLtest$userid, levels=levels(MLfull$userid));

MLhold$movieid = factor(MLhold$movieid, levels=levels(MLfull$movieid));
MLhold$userid = factor(MLhold$userid, levels=levels(MLfull$userid));	

print("For JoinOpt Linear:")
print("---------------------------------")

JoinOpt_linear(MLtrain,MLtest,MLhold)
