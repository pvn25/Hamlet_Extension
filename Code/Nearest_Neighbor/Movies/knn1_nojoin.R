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

fact =read.csv('ratings.csv');
dim1=read.csv('moviesnew.csv')
all = merge(fact,dim1,,by="movieid")


dim2=read.csv('users.csv')
all1 = merge(all,dim2,by="userid")
write.csv(all1,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

temp2 = all1[,c("rating","userid","movieid","namepar","year","action","adventure","animation","children.s","comedy","crime","documentary","drama","fantasy","film.noir","horror","musical","mystery","romance","sci.fi","thriller","war","western","gender","occupation","zipcode","namewords","age")]
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
MLtraintest <- temp1[block!=k,]
set.seed(15)
trainIndex = sample(1:n, size = round(0.67*n), replace=FALSE)
MLtrain = MLtraintest[trainIndex ,]
MLtest = MLtraintest[-trainIndex ,]
MLhold <- temp1[block==k,]


MLfull = rbind(MLtrain, MLtest, MLhold);
MLtrain$movieid = factor(MLtrain$movieid, levels=levels(MLfull$movieid));
MLtrain$userid = factor(MLtrain$userid, levels=levels(MLfull$userid));
MLtrain$zipcode = factor(MLtrain$zipcode, levels=levels(MLfull$zipcode));

MLtest$movieid = factor(MLtest$movieid, levels=levels(MLfull$movieid));
MLtest$userid = factor(MLtest$userid, levels=levels(MLfull$userid));
MLtest$zipcode = factor(MLtest$zipcode, levels=levels(MLfull$zipcode));

MLhold$movieid = factor(MLhold$movieid, levels=levels(MLfull$movieid));
MLhold$userid = factor(MLhold$userid, levels=levels(MLfull$userid));
MLhold$zipcode = factor(MLhold$zipcode, levels=levels(MLfull$zipcode));

MLtrain=MLtrain[,c("movieid","userid","rating")]
MLtest=MLtest[,c("movieid", "userid","rating")]
MLhold=MLhold[,c("movieid", "userid","rating")]

fit <- IBk(rating ~ ., data = MLtrain, control = Weka_control(K = 1, X = TRUE))
print(fit)
predictions <- predict(fit, MLhold,class = "class")
print(predictions)
outsettab <- table(pred = predictions, true = MLhold[,1])
acc = geterr(outsettab, '01', nrow(MLhold))
print(acc)
}