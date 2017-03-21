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

WTtrain=read.csv("WTtrain_new.csv");
WTtest=read.csv("WTtest_new.csv");
WThold=read.csv("WThold_new.csv");
WTfull = rbind(WTtrain, WTtest, WThold);
WTtrain = WTtrain[,-1]
WTtest=WTtest[,-1]
WThold = WThold[,-1]
WTfull=rbind(WTtrain,WTtest,WThold);#combining data frames by rows

WTfull$dept = factor(WTfull$dept)
WTfull$store = factor(WTfull$store)
WTfull$purchaseid = factor(WTfull$purchaseid)
WTfull$type = factor(WTfull$type)
WTfull$size = factor(WTfull$size)
WTfull$temperature_avg = factor(WTfull$temperature_avg)
WTfull$temperature_stdev = factor(WTfull$temperature_stdev)
WTfull$fuel_price_avg = factor(WTfull$fuel_price_avg)
WTfull$fuel_price_stdev = factor(WTfull$fuel_price_stdev)
WTfull$cpi_avg = factor(WTfull$cpi_avg)
WTfull$cpi_stdev = factor(WTfull$cpi_stdev)
WTfull$unemployment_avg = factor(WTfull$unemployment_avg)
WTfull$unemployment_stdev = factor(WTfull$unemployment_stdev)
WTfull$holidayfreq = factor(WTfull$holidayfreq)

WTtrain$dept = factor(WTtrain$dept, levels=levels(WTfull$dept));
WTtrain$purchaseid = factor(WTtrain$purchaseid, levels=levels(WTfull$purchaseid));
WTtrain$store = factor(WTtrain$store, levels=levels(WTfull$store));
WTtrain$type = factor(WTtrain$type,levels=levels(WTfull$type))
WTtrain$size = factor(WTtrain$size,levels=levels(WTfull$size))
WTtrain$temperature_avg = factor(WTtrain$temperature_avg,levels=levels(WTfull$temperature_avg))
WTtrain$temperature_stdev = factor(WTtrain$temperature_stdev,levels=levels(WTfull$temperature_stdev))
WTtrain$fuel_price_avg = factor(WTtrain$fuel_price_avg,levels=levels(WTfull$fuel_price_avg))
WTtrain$fuel_price_stdev = factor(WTtrain$fuel_price_stdev,levels=levels(WTfull$fuel_price_stdev))
WTtrain$cpi_avg = factor(WTtrain$cpi_avg,levels=levels(WTfull$cpi_avg))
WTtrain$cpi_stdev = factor(WTtrain$cpi_stdev,levels=levels(WTfull$cpi_stdev))
WTtrain$unemployment_avg = factor(WTtrain$unemployment_avg,levels=levels(WTfull$unemployment_avg))
WTtrain$unemployment_stdev = factor(WTtrain$unemployment_stdev,levels=levels(WTfull$unemployment_stdev))
WTtrain$holidayfreq = factor(WTtrain$holidayfreq,levels=levels(WTfull$holidayfreq))

WTtest$dept = factor(WTtest$dept, levels=levels(WTfull$dept));
WTtest$purchaseid = factor(WTtest$purchaseid, levels=levels(WTfull$purchaseid));
WTtest$store = factor(WTtest$store, levels=levels(WTfull$store));
WTtest$type = factor(WTtest$type,levels=levels(WTfull$type))
WTtest$size = factor(WTtest$size,levels=levels(WTfull$size))
WTtest$temperature_avg = factor(WTtest$temperature_avg,levels=levels(WTfull$temperature_avg))
WTtest$temperature_stdev = factor(WTtest$temperature_stdev,levels=levels(WTfull$temperature_stdev))
WTtest$fuel_price_avg = factor(WTtest$fuel_price_avg,levels=levels(WTfull$fuel_price_avg))
WTtest$fuel_price_stdev = factor(WTtest$fuel_price_stdev,levels=levels(WTfull$fuel_price_stdev))
WTtest$cpi_avg = factor(WTtest$cpi_avg,levels=levels(WTfull$cpi_avg))
WTtest$cpi_stdev = factor(WTtest$cpi_stdev,levels=levels(WTfull$cpi_stdev))
WTtest$unemployment_avg = factor(WTtest$unemployment_avg,levels=levels(WTfull$unemployment_avg))
WTtest$unemployment_stdev = factor(WTtest$unemployment_stdev,levels=levels(WTfull$unemployment_stdev))
WTtest$holidayfreq = factor(WTtest$holidayfreq,levels=levels(WTfull$holidayfreq))


WThold$dept = factor(WThold$dept, levels=levels(WTfull$dept));
WThold$purchaseid = factor(WThold$purchaseid, levels=levels(WTfull$purchaseid));
WThold$store = factor(WThold$store, levels=levels(WTfull$store));
WThold$type = factor(WThold$type,levels=levels(WTfull$type))
WThold$size = factor(WThold$size,levels=levels(WTfull$size))
WThold$temperature_avg = factor(WThold$temperature_avg,levels=levels(WTfull$temperature_avg))
WThold$temperature_stdev = factor(WThold$temperature_stdev,levels=levels(WTfull$temperature_stdev))
WThold$fuel_price_avg = factor(WThold$fuel_price_avg,levels=levels(WTfull$fuel_price_avg))
WThold$fuel_price_stdev = factor(WThold$fuel_price_stdev,levels=levels(WTfull$fuel_price_stdev))
WThold$cpi_avg = factor(WThold$cpi_avg,levels=levels(WTfull$cpi_avg))
WThold$cpi_stdev = factor(WThold$cpi_stdev,levels=levels(WTfull$cpi_stdev))
WThold$unemployment_avg = factor(WThold$unemployment_avg,levels=levels(WTfull$unemployment_avg))
WThold$unemployment_stdev = factor(WThold$unemployment_stdev,levels=levels(WTfull$unemployment_stdev))
WThold$holidayfreq = factor(WThold$holidayfreq,levels=levels(WTfull$holidayfreq))

#sink("jallinfo_variablesplit.txt")
if(FALSE){
# ms = c(1,10,100,1000)
# cpv = c(0,0.025,0.05,0.075,0.1,0.01,0.001,0.0001)
# ms = c(1,10,100,1000)
# cpv = c(0.00001,0.00002,0.00005,0.00009,0.0002,0.00015,0.00045,0.00075)
# ms = c(1,10,100,1000)
# cpv = c(0.00000009,0.0000008,0.0000000007,0.0000000000006,0.000000005,0.000004,0.000003,0.000002)
ms = c(1,10,100,1000)
cpv = c(0,0.1,0.01,0.001,0.0001)

x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
best_cpv = 0
tm = 0
while(x!=20)
{
pt = proc.time(); 
# print(ms[i])
# print(cpv[j])
fit <- rpart(weekly_sales~., data=WTtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'information'))
predictions <- predict(fit, WTtest, type="class")
outsettab <- table(pred = predictions, true = WTtest[,1])
acc = geterr(outsettab, '01', nrow(WTtest), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];best_cpv = cpv[j];
}
#print(acc)
tm = tm + proc.time() - pt
#print(proc.time() - pt)
x <- x + 1
j <- j + 1
if(j==6){
i <- (i + 1)
j <- 1
}
}
}

#print(tm)
#sink("dt_jall10.txt")
pt = proc.time();
fit <- rpart(weekly_sales~., data=WTtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'information'))
#fit <- prune(fitt, cp = 0.01)
summary(fit)
# make predictions
predictions <- predict(fit, WThold, type="class")
outsettab <- table(pred = predictions, true = WThold[,1])
acc = geterr(outsettab, '01', nrow(WThold), nrow(outsettab))
print(acc)
#print(proc.time() - pt)
#sink()
