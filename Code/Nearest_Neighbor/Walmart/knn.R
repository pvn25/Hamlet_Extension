library(RWeka)
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

fit <- IBk(weekly_sales ~ ., data = WTtrain, control = Weka_control(K = 1, X = TRUE))
print(fit)
predictions <- predict(fit, WThold,class = "class")
print(predictions)
outsettab <- table(pred = predictions, true = WThold[,1])
acc = geterr(outsettab, '01', nrow(WThold))
print(acc)
