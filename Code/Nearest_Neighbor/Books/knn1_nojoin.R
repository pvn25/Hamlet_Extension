library(RWeka)
source("myfilter.R")
BCtrain=read.csv("BCtrain_new.csv");
BCtest=read.csv("BCtest_new.csv");
BChold=read.csv("BChold_new.csv");
BCfull=rbind(BCtrain,BCtest,BChold) 

feats = c("userid","bookid","rating");
BCtrain = BCtrain[,feats]
BCtest = BCtest[,feats]
BChold = BChold[,feats]

#userid,bookid,rating,titlewords,authorwords,year,publisher,country,age

BCtrain$bookid = factor(BCtrain$bookid, levels=levels(BCfull$bookid));
BCtrain$userid = factor(BCtrain$userid, levels=levels(BCfull$userid));
#BCtrain$country = factor(BCtrain$country, levels=levels(BCfull$country));
# BCtrain$publisher = factor(BCtrain$publisher, levels=levels(BCfull$publisher));
# BCtrain$year = factor(BCtrain$year, levels=levels(BCfull$year));

BCtest$bookid = factor(BCtest$bookid, levels=levels(BCfull$bookid));
BCtest$userid = factor(BCtest$userid, levels=levels(BCfull$userid));
#BCtest$country = factor(BCtest$country, levels=levels(BCfull$country));
# BCtest$publisher = factor(BCtest$publisher, levels=levels(BCfull$publisher));
# BCtest$year = factor(BCtest$year, levels=levels(BCfull$year));

BChold$bookid = factor(BChold$bookid, levels=levels(BCfull$bookid));
BChold$userid = factor(BChold$userid, levels=levels(BCfull$userid));
#BChold$country = factor(BChold$country, levels=levels(BCfull$country));
# BChold$publisher = factor(BChold$publisher, levels=levels(BCfull$publisher));
# BChold$year = factor(BChold$year, levels=levels(BCfull$year));

fit <- IBk(rating ~ ., data = BCtrain, control = Weka_control(K = 1, X = TRUE))
print(fit)
predictions <- predict(fit, BChold,class = "class")
print(predictions)
outsettab <- table(pred = predictions, true = BChold[,3])
acc = geterr(outsettab, '01', nrow(BChold))
print(acc)
