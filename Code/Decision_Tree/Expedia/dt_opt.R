library(rpart)
source("myfilter.R")

EHtrain = read.csv("EHtrain10re.csv");
EHtest = read.csv("EHtest10re.csv");
EHhold = read.csv("EHhold10re.csv");
EHtrain = EHtrain[,-1]; #get rid of srch_id
EHtest = EHtest[,-1];
EHhold = EHhold[,-1];

EHall = rbind(EHtrain,EHtest,EHhold);
EHtrain$prop_id = factor(EHtrain$prop_id, levels=levels(EHall$prop_id));
EHtrain$prop_country_id = factor(EHtrain$prop_country_id, levels=levels(EHall$prop_country_id));
EHtrain$site_id = factor(EHtrain$site_id, levels=levels(EHall$site_id));
EHtrain$visitor_location_country_id = factor(EHtrain$visitor_location_country_id, levels=levels(EHall$visitor_location_country_id));
EHtrain$srch_destination_id = factor(EHtrain$srch_destination_id, levels=levels(EHall$srch_destination_id));

EHtest$prop_id = factor(EHtest$prop_id, levels=levels(EHall$prop_id));
EHtest$prop_country_id = factor(EHtest$prop_country_id, levels=levels(EHall$prop_country_id));
EHtest$site_id = factor(EHtest$site_id, levels=levels(EHall$site_id));
EHtest$visitor_location_country_id = factor(EHtest$visitor_location_country_id, levels=levels(EHall$visitor_location_country_id));
EHtest$srch_destination_id = factor(EHtest$srch_destination_id, levels=levels(EHall$srch_destination_id));

EHhold$prop_id = factor(EHhold$prop_id, levels=levels(EHall$prop_id));
EHhold$prop_country_id = factor(EHhold$prop_country_id, levels=levels(EHall$prop_country_id));
EHhold$site_id = factor(EHhold$site_id, levels=levels(EHall$site_id));
EHhold$visitor_location_country_id = factor(EHhold$visitor_location_country_id, levels=levels(EHall$visitor_location_country_id));
EHhold$srch_destination_id = factor(EHhold$srch_destination_id, levels=levels(EHall$srch_destination_id));

allfeats = names(EHhold);
hfeats = c("prop_country_id","prop_starrating","prop_review_score","prop_brand_bool","count_clicks","avg_bookings_usd","stdev_bookings_usd","count_bookings");
allfeatsjcnohotels = setdiff(allfeats, hfeats);
EHtrain = EHtrain[,allfeatsjcnohotels]
EHtest = EHtest[,allfeatsjcnohotels]
EHhold = EHhold[,allfeatsjcnohotels]
#print(names(EHtrain))
if(TRUE){
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
fit <- rpart(position~., data=EHtrain, method = "class",control=rpart.control(minsplit=ms[i], cp=cpv[j]),parms = list(split = 'information'))
predictions <- predict(fit, EHtest, type="class")
outsettab <- table(pred = predictions, true = EHtest[,2])
acc = geterr(outsettab, '01', nrow(EHtest), nrow(outsettab))
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
# summarize the fit
print(tm)
# make predictions
pt = proc.time();
fit <- rpart(position~., data=EHtrain, method = "class",control=rpart.control(minsplit=best_ms, cp=best_cpv),parms = list(split = 'information'))
summary(fit)
predictions <- predict(fit, EHhold, type="class")
outsettab <- table(pred = predictions, true = EHhold[,2])
acc = geterr(outsettab, '01', nrow(EHhold), nrow(outsettab))
print(acc)
print(proc.time() - pt)