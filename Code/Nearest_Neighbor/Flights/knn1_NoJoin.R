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

library(RWeka)
source("myfilter.R")

fact =read.csv('routesnew.csv');
dim1=read.csv('airlinesnew.csv')
all = merge(fact,dim1,,by="airlineid")


dim2=read.csv('sairportsnew.csv')
all1 = merge(all,dim2,by="sairportid")

dim3=read.csv('dairportsnew.csv')
all11 = merge(all1,dim3,by="dairportid")

write.csv(all11,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

temp2 = all11[,c("codeshare","airlineid","sairportid","dairportid","eq1","eq2","eq3","eq4","eq5","eq8","eq12","eq14","eq15","eq17","eq19","eq20","eq22","eq25","eq28","eq30","eq31","eq45","eq46","eq71","name2","name4","acountry","active","scity","scountry","sdst","dcity","dcountry","ddst","name1","slatitude","slongitude","stimezone","dlatitude","dlongitude","dtimezone")]
# write.csv(all2,'all2.csv')
set.seed(5)
temp1 <- temp2[sample(nrow(temp2)),]
n <- nrow(temp1)
K <- 10
size <- n %/% K

rdm <- runif(n)
ranked <- rank(rdm)
block <- (ranked-1) %/% size+1
block <- as.factor(block)

for (k in 1:K) {
OFtraintest <- temp1[block!=k,]
set.seed(15)
trainIndex = sample(1:n, size = round(0.67*n), replace=FALSE)
OFtrain = OFtraintest[trainIndex ,]
OFtest = OFtraintest[-trainIndex ,]
OFhold <- temp1[block==k,]
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


OFtrain=OFtrain[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5","scity", "scountry", "sdst", "stimezone", "slongitude", "slatitude","dcity", "dcountry", "ddst", "dtimezone", "dlongitude", "dlatitude")]
OFtest=OFtest[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5","scity", "scountry", "sdst", "stimezone", "slongitude", "slatitude","dcity", "dcountry", "ddst", "dtimezone", "dlongitude", "dlatitude")]
OFhold=OFhold[,c("codeshare","airlineid","sairportid","dairportid","eq8","eq17","eq22","eq2","eq1","eq19","eq20","eq28","eq46","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","eq15","eq31","eq5","scity", "scountry", "sdst", "stimezone", "slongitude", "slatitude","dcity", "dcountry", "ddst", "dtimezone", "dlongitude", "dlatitude")]

fit <- IBk(codeshare ~ ., data = OFtrain, control = Weka_control(K = 1, X = TRUE))
print(fit)
predictions <- predict(fit, OFhold,class = "class")
print(predictions)
outsettab <- table(pred = predictions, true = OFhold[,1])
acc = geterr(outsettab, '01', nrow(OFhold))
print(acc)
}