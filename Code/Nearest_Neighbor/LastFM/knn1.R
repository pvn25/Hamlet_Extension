library(RWeka)
source("myfilter.R")

LFtrain=read.csv("LFsub2train_new.csv");
LFtest=read.csv("LFsub2test_new.csv");
LFhold=read.csv("LFsub2hold_new.csv");
LFfull=rbind(LFtrain,LFtest,LFhold) 

LFtrain$artistid = factor(LFtrain$artistid, levels=levels(LFfull$artistid));
LFtrain$userid = factor(LFtrain$userid, levels=levels(LFfull$userid));
LFtrain$country = factor(LFtrain$country, levels=levels(LFfull$country));

LFtest$artistid = factor(LFtest$artistid, levels=levels(LFfull$artistid));
LFtest$userid = factor(LFtest$userid, levels=levels(LFfull$userid));
LFtest$country = factor(LFtest$country, levels=levels(LFfull$country));

LFhold$artistid = factor(LFhold$artistid, levels=levels(LFfull$artistid));
LFhold$userid = factor(LFhold$userid, levels=levels(LFfull$userid));
LFhold$country = factor(LFhold$country, levels=levels(LFfull$country));



fit <- IBk(plays ~ ., data = LFtrain, control = Weka_control(K = 1, X = TRUE))
print(fit)
predictions <- predict(fit, LFhold,class = "class")
print(predictions)
outsettab <- table(pred = predictions, true = LFhold[,3])
acc = geterr(outsettab, '01', nrow(LFhold))
print(acc)
