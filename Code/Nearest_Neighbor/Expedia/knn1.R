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

fact =read.csv('listingsnew.csv');
dim1=read.csv('searchesnew.csv')
all = merge(fact,dim1,,by="srch_id")


dim2=read.csv('hotelsnew.csv')
all1 = merge(all,dim2,by="prop_id")
write.csv(all1,'all1.csv')


# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

temp2 = all1[,c("position","prop_id","year","month","weekofyear","time","site_id","visitor_location_country_id","srch_destination_id","prop_country_id","prop_review_score","prop_location_score1","prop_location_score2","prop_log_historical_price","price_usd","promotion_flag","orig_destination_distance","srch_length_of_stay","srch_booking_window","srch_adults_count","srch_children_count","srch_room_count","srch_saturday_night_bool","random_bool","prop_starrating","prop_brand_bool","count_clicks","avg_bookings_usd","stdev_bookings_usd","count_bookings")]
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
EHtraintest <- temp1[block!=k,]
set.seed(15)
trainIndex = sample(1:n, size = round(0.67*n), replace=FALSE)
EHtrain = EHtraintest[trainIndex ,]
EHtest = EHtraintest[-trainIndex ,]
EHhold <- temp1[block==k,]


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
#print(names(EHtrain))


fit <- IBk(position ~ ., data = EHtrain, control = Weka_control(K = 1, X = TRUE))

predictions <- predict(fit, EHtrain,class = "class")
outsettab <- table(pred = predictions, true = EHtrain[,2])
acc = geterr(outsettab, '01', nrow(EHtrain))
print(acc)

predictions <- predict(fit, EHhold,class = "class")
outsettab <- table(pred = predictions, true = EHhold[,2])
acc = geterr(outsettab, '01', nrow(EHhold))
print(acc)
}