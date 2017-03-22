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

library(rpart)
source("myfilter.R")
ds = 4
dr = 4
row_to_target = 1
filenames <- list.files("train", pattern="*.csv", full.names=TRUE)
filenames_test <- list.files("test", full.names=TRUE)

# All things workings 
###################################################################################################
# var <- read.csv(filenames[1],header = FALSE, quote = "")
# print(var)
# fit <- rpart(V8~.,data = var ,method = "class",control=rpart.control(minsplit=1, cp=0),parms = list(split = 'gini'))
# summary(fit)
# predictions <- predict(fit, var, type="class")
# print(predictions)
# outsettab <- table(pred = predictions, true = var[,8])
# print(outsettab)
# acc = geterr(outsettab, '01', nrow(var), nrow(outsettab))
# print(acc)
###################################################################################################

# var <- read.csv(filenames[1],header = FALSE, quote = "")
# print(var)
# print(var[,2:(2+ds)])

l <- c()
l_test <- c()

l_CA <- c()
l_test_CA <- c()

l_JP <- c()
l_test_JP <- c()

for (i in 1:length(filenames)) {
	var <- read.csv(filenames[i],header = FALSE, quote = "")
	var_test <- read.csv(filenames_test,header = FALSE, quote = "")
		
	if(TRUE){
	ms = c(1)
	cpv = c(0,0.1,0.01,0.001)	
	x <- 0
	i <- 1
	j <- 1
	best = 1000000
	best_ca = 1000000
	best_jp = 1000000

	best_ms = 0
	best_ms_ca = 0
	best_ms_jp = 0
	
	best_cpv = 0
	best_cpv_ca = 0
	best_cpv_jp = 0

	while(x != 4)
	{
	fit <- rpart(V1~. ,data = var ,method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'gini'))
	fit_CA <- rpart(V1~.,data = var[,1:(2+ds)] ,method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'gini'))
	fit_JP <- rpart(V1~.,data = var[,-(2+ds)] ,method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'gini'))

	predictions_test <- predict(fit, var_test, type="class")
	predictions_test_CA <- predict(fit_CA, var_test[,1:(2+ds)], type="class")
	predictions_test_JP <- predict(fit_JP, var_test[,-(2+ds)], type="class")
	
	outsettab_test <- table(pred = predictions_test, true = var_test[,row_to_target])
	outsettab_test_CA <- table(pred = predictions_test_CA, true = var_test[,row_to_target])
	outsettab_test_JP <- table(pred = predictions_test_JP, true = var_test[,row_to_target])

	#print(outsettab_test)
	acc_test = geterr(outsettab_test, '01', nrow(var_test), nrow(outsettab_test))
	acc_test_CA = geterr(outsettab_test_CA, '01', nrow(var_test), nrow(outsettab_test_CA))
	acc_test_JP = geterr(outsettab_test_JP, '01', nrow(var_test), nrow(outsettab_test_JP))
	#print(best)
	if(best > acc_test){
	best = acc_test;best_ms = ms[i];best_cpv = cpv[j];
	}
	if(best_ca > acc_test_CA){
	best_ca = acc_test_CA;best_ms_ca = ms[i];best_cpv_ca = cpv[j];
	}
	if(best_jp > acc_test_JP){
	best_jp = acc_test_JP;best_ms_jp = ms[i];best_cpv_jp = cpv[j];
	}
	x <- x + 1
	j <- j + 1
	if(j==5){
	i <- (i + 1)
	j <- 1
		}
	}
}
	#print(best_ms_ca)
	#print(best_cpv_ca)
	fit <- rpart(V1~. ,data = var ,method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'gini'))
	#summary(fit)
	#print(var[,-(2+ds)])
	fit_CA <- rpart(V1~.,data = var[,1:(2+ds)] ,method = "class",control=rpart.control(minsplit=best_ms_ca, cp=best_cpv_ca),parms = list(split = 'gini'))
	fit_JP <- rpart(V1~.,data = var[,-(2+ds)] ,method = "class",control=rpart.control(minsplit=best_ms_jp, cp=best_cpv_jp),parms = list(split = 'gini'))
	# summary(fit)
	# summary(fit_CA)
	# summary(fit_JP)
	predictions <- predict(fit, var, type="class")
	predictions_CA <- predict(fit_CA, var[,1:(2+ds)], type="class")
	predictions_JP <- predict(fit_JP, var[,-(2+ds)], type="class")

	predictions_test <- predict(fit, var_test, type="class")
	predictions_test_CA <- predict(fit_CA, var_test[,1:(2+ds)], type="class")
	predictions_test_JP <- predict(fit_JP, var_test[,-(2+ds)], type="class")

	#print(predictions_test)	
	lapply(predictions_test, write, "predictions.txt", append=TRUE)
	lapply(predictions_test_CA, write, "predictions_CA.txt", append=TRUE)
	lapply(predictions_test_JP, write, "predictions_JP.txt", append=TRUE)
	
	outsettab <- table(pred = predictions, true = var[,row_to_target])
	outsettab_test <- table(pred = predictions_test, true = var_test[,row_to_target])

	outsettab_CA <- table(pred = predictions_CA, true = var[,row_to_target])
	outsettab_test_CA <- table(pred = predictions_test_CA, true = var_test[,row_to_target])

	outsettab_JP <- table(pred = predictions_JP, true = var[,row_to_target])
	outsettab_test_JP <- table(pred = predictions_test_JP, true = var_test[,row_to_target])

	#print(outsettab_test)
	acc = geterr(outsettab, '01', nrow(var), nrow(outsettab))	
	acc_test = geterr(outsettab_test, '01', nrow(var_test), nrow(outsettab_test))

	acc_CA = geterr(outsettab_CA, '01', nrow(var), nrow(outsettab_CA))	
	acc_test_CA = geterr(outsettab_test_CA, '01', nrow(var_test), nrow(outsettab_test_CA))

	acc_JP = geterr(outsettab_JP, '01', nrow(var), nrow(outsettab_JP))	
	acc_test_JP = geterr(outsettab_test_JP, '01', nrow(var_test), nrow(outsettab_test_JP))
	
	l <- c(l,acc)
	l_test <- c(l_test,acc_test)

	l_CA <- c(l_CA,acc_CA)
	l_test_CA <- c(l_test_CA,acc_test_CA)

	l_JP <- c(l_JP,acc_JP)
	l_test_JP <- c(l_test_JP,acc_test_JP)

}

lapply(l, write, "trainALL.txt", append=TRUE)
lapply(l_test, write, "testALL.txt", append=TRUE)

lapply(l_CA, write, "trainALL_CA.txt", append=TRUE)
lapply(l_test_CA, write, "testALL_CA.txt", append=TRUE)

lapply(l_JP, write, "trainALL_JP.txt", append=TRUE)
lapply(l_test_JP, write, "testALL_JP.txt", append=TRUE)
