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

source("allentropyinfogain.R")
source("svm_JoinOpt_linear.R")

library(e1071)
options(width=190)

OFtrain = read.csv("OFtrain.csv");
OFtest = read.csv("OFtest.csv");
OFhold = read.csv("OFhold.csv");
OFfull = rbind(OFtrain, OFtest, OFhold);
OFfull$airlineid = factor(OFfull$airlineid);
OFfull$sairportid = factor(OFfull$sairportid);
OFfull$dairportid = factor(OFfull$dairportid);
OFfull$stimezone = factor(OFfull$stimezone);
OFfull$dtimezone = factor(OFfull$dtimezone);
OFfull$slatitude = factor(OFfull$slatitude);
OFfull$dlatitude = factor(OFfull$dlatitude);
OFfull$slongitude = factor(OFfull$slongitude);
OFfull$dlongitude = factor(OFfull$dlongitude);
OFfull$name1 = factor(OFfull$name1);
OFfull$scity = factor(OFfull$scity);
OFfull$dcity = factor(OFfull$dcity);
OFfull$scountry = factor(OFfull$scountry);
OFfull$dcountry = factor(OFfull$dcountry);
OFfull$sdst = factor(OFfull$sdst);
OFfull$ddst = factor(OFfull$ddst);
OFfull$acountry = factor(OFfull$acountry);

OFtrain$airlineid = factor(OFtrain$airlineid, levels=levels(OFfull$airlineid));
OFtrain$sairportid = factor(OFtrain$sairportid, levels=levels(OFfull$sairportid));
OFtrain$dairportid = factor(OFtrain$dairportid, levels=levels(OFfull$dairportid));
OFtrain$stimezone = factor(OFtrain$stimezone, levels=levels(OFfull$stimezone));
OFtrain$dtimezone = factor(OFtrain$dtimezone, levels=levels(OFfull$dtimezone));
OFtrain$slatitude = factor(OFtrain$slatitude, levels=levels(OFfull$slatitude));
OFtrain$dlatitude = factor(OFtrain$dlatitude, levels=levels(OFfull$dlatitude));
OFtrain$slongitude = factor(OFtrain$slongitude, levels=levels(OFfull$slongitude));
OFtrain$dlongitude = factor(OFtrain$dlongitude, levels=levels(OFfull$dlongitude));
OFtrain$name1 = factor(OFtrain$name1, levels=levels(OFfull$name1));
OFtrain$scity = factor(OFtrain$scity, levels=levels(OFfull$scity));
OFtrain$dcity = factor(OFtrain$dcity, levels=levels(OFfull$dcity));
OFtrain$scountry = factor(OFtrain$scountry, levels=levels(OFfull$scountry));
OFtrain$dcountry = factor(OFtrain$dcountry, levels=levels(OFfull$dcountry));
OFtrain$sdst = factor(OFtrain$sdst, levels=levels(OFfull$sdst));
OFtrain$ddst = factor(OFtrain$ddst, levels=levels(OFfull$ddst));
OFtrain$acountry = factor(OFtrain$acountry, levels=levels(OFfull$acountry));

OFtest$airlineid = factor(OFtest$airlineid, levels=levels(OFfull$airlineid));
OFtest$sairportid = factor(OFtest$sairportid, levels=levels(OFfull$sairportid));
OFtest$dairportid = factor(OFtest$dairportid, levels=levels(OFfull$dairportid));
OFtest$stimezone = factor(OFtest$stimezone, levels=levels(OFfull$stimezone));
OFtest$dtimezone = factor(OFtest$dtimezone, levels=levels(OFfull$dtimezone));
OFtest$slatitude = factor(OFtest$slatitude, levels=levels(OFfull$slatitude));
OFtest$dlatitude = factor(OFtest$dlatitude, levels=levels(OFfull$dlatitude));
OFtest$slongitude = factor(OFtest$slongitude, levels=levels(OFfull$slongitude));
OFtest$dlongitude = factor(OFtest$dlongitude, levels=levels(OFfull$dlongitude));
OFtest$name1 = factor(OFtest$name1, levels=levels(OFfull$name1));
OFtest$scity = factor(OFtest$scity, levels=levels(OFfull$scity));
OFtest$dcity = factor(OFtest$dcity, levels=levels(OFfull$dcity));
OFtest$scountry = factor(OFtest$scountry, levels=levels(OFfull$scountry));
OFtest$dcountry = factor(OFtest$dcountry, levels=levels(OFfull$dcountry));
OFtest$sdst = factor(OFtest$sdst, levels=levels(OFfull$sdst));
OFtest$ddst = factor(OFtest$ddst, levels=levels(OFfull$ddst));
OFtest$acountry = factor(OFtest$acountry, levels=levels(OFfull$acountry));

OFhold$airlineid = factor(OFhold$airlineid, levels=levels(OFfull$airlineid));
OFhold$sairportid = factor(OFhold$sairportid, levels=levels(OFfull$sairportid));
OFhold$dairportid = factor(OFhold$dairportid, levels=levels(OFfull$dairportid));
OFhold$stimezone = factor(OFhold$stimezone, levels=levels(OFfull$stimezone));
OFhold$dtimezone = factor(OFhold$dtimezone, levels=levels(OFfull$dtimezone));
OFhold$slatitude = factor(OFhold$slatitude, levels=levels(OFfull$slatitude));
OFhold$dlatitude = factor(OFhold$dlatitude, levels=levels(OFfull$dlatitude));
OFhold$slongitude = factor(OFhold$slongitude, levels=levels(OFfull$slongitude));
OFhold$dlongitude = factor(OFhold$dlongitude, levels=levels(OFfull$dlongitude));
OFhold$name1 = factor(OFhold$name1, levels=levels(OFfull$name1));
OFhold$scity = factor(OFhold$scity, levels=levels(OFfull$scity));
OFhold$dcity = factor(OFhold$dcity, levels=levels(OFfull$dcity));
OFhold$scountry = factor(OFhold$scountry, levels=levels(OFfull$scountry));
OFhold$dcountry = factor(OFhold$dcountry, levels=levels(OFfull$dcountry));
OFhold$sdst = factor(OFhold$sdst, levels=levels(OFfull$sdst));
OFhold$ddst = factor(OFhold$ddst, levels=levels(OFfull$ddst));
OFhold$acountry = factor(OFhold$acountry, levels=levels(OFfull$acountry));

# OFtrain=OFtrain[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5","scity", "scountry", "sdst", "stimezone", "slongitude", "slatitude","dcity", "dcountry", "ddst", "dtimezone", "dlongitude", "dlatitude")]
# OFtest=OFtest[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5","scity", "scountry", "sdst", "stimezone", "slongitude", "slatitude","dcity", "dcountry", "ddst", "dtimezone", "dlongitude", "dlatitude")]
# OFhold=OFhold[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5","scity", "scountry", "sdst", "stimezone", "slongitude", "slatitude","dcity", "dcountry", "ddst", "dtimezone", "dlongitude", "dlatitude")]

# OFtrain=OFtrain[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5")]
# OFtest=OFtest[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5")]
# OFhold=OFhold[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5")]

OFtrain=OFtrain[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5")]
OFtest=OFtest[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5")]
OFhold=OFhold[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5")]

print("For JoinOpt Linear:")
print("---------------------------------")

JoinOpt_linear(OFtrain,OFtest,OFhold)
