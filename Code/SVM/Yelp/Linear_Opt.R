library(e1071)
options(width=190)
source("myfilter.R")

YRtrain=read.csv("YRtrain_new.csv");
YRtest=read.csv("YRtest_new.csv");
YRhold=read.csv("YRhold_new.csv");
YRtrain=YRtrain[,-1] #get rid of reviewid
YRtest=YRtest[,-1]
YRhold=YRhold[,-1]

feats = c("stars","userid", "businessid");
YRtrain_new=YRtrain[,feats] #get rid of reviewid
YRtest_new=YRtest[,feats]
YRhold_new=YRhold[,feats]
YRfull_new=rbind(YRtrain_new,YRtest_new,YRhold_new);

YRfull_new$userid = factor(YRfull_new$userid)
YRfull_new$businessid = factor(YRfull_new$businessid)
YRfull_new$stars = factor(YRfull_new$stars)
# YRfull_new$city = factor(YRfull_new$city)
# YRfull_new$state = factor(YRfull_new$state)
# # YRfull_new$ustars = factor(YRfull_new$ustars)
# # YRfull_new$ureviewcnt = factor(YRfull_new$ureviewcnt)
# # YRfull_new$vuseful = factor(YRfull_new$vuseful)
# # YRfull_new$vfunny = factor(YRfull_new$vfunny)
# # YRfull_new$vcool = factor(YRfull_new$vcool)
# YRfull_new$latitude = factor(YRfull_new$latitude)
# YRfull_new$longitude = factor(YRfull_new$longitude)
# YRfull_new$bstars = factor(YRfull_new$bstars)
# YRfull_new$breviewcnt = factor(YRfull_new$breviewcnt)
# YRfull_new$wday1 = factor(YRfull_new$wday1)
# YRfull_new$wday2 = factor(YRfull_new$wday2)
# YRfull_new$wday3 = factor(YRfull_new$wday3)
# YRfull_new$wday4 = factor(YRfull_new$wday4)
# YRfull_new$wday5 = factor(YRfull_new$wday5)
# YRfull_new$wend1 = factor(YRfull_new$wend1)
# YRfull_new$wend2 = factor(YRfull_new$wend2)
# YRfull_new$wend3 = factor(YRfull_new$wend3)
# YRfull_new$wend4 = factor(YRfull_new$wend4)
# YRfull_new$wend5 = factor(YRfull_new$wend5)

YRtrain_new$userid = factor(YRtrain_new$userid, levels=levels(YRfull_new$userid));
YRtrain_new$businessid = factor(YRtrain_new$businessid, levels=levels(YRfull_new$businessid));
YRtrain_new$stars = factor(YRtrain_new$stars, levels=levels(YRfull_new$stars));
# YRtrain_new$city = factor(YRtrain_new$city, levels=levels(YRfull_new$city));
# YRtrain_new$state = factor(YRtrain_new$state, levels=levels(YRfull_new$state));
# # YRtrain_new$ustars = factor(YRtrain_new$ustars, levels=levels(YRfull_new$ustars));
# # YRtrain_new$ureviewcnt = factor(YRtrain_new$ureviewcnt, levels=levels(YRfull_new$ureviewcnt));
# # YRtrain_new$vuseful = factor(YRtrain_new$vuseful, levels=levels(YRfull_new$vuseful));
# # YRtrain_new$vfunny = factor(YRtrain_new$vfunny, levels=levels(YRfull_new$vfunny));
# # YRtrain_new$vcool = factor(YRtrain_new$vcool, levels=levels(YRfull_new$vcool));
# YRtrain_new$latitude = factor(YRtrain_new$latitude, levels=levels(YRfull_new$latitude));
# YRtrain_new$longitude = factor(YRtrain_new$longitude, levels=levels(YRfull_new$longitude));
# YRtrain_new$bstars = factor(YRtrain_new$bstars, levels=levels(YRfull_new$bstars));
# YRtrain_new$breviewcnt = factor(YRtrain_new$breviewcnt, levels=levels(YRfull_new$breviewcnt));
# YRtrain_new$wday1 = factor(YRtrain_new$wday1, levels=levels(YRfull_new$wday1));
# YRtrain_new$wday2 = factor(YRtrain_new$wday2, levels=levels(YRfull_new$wday2));
# YRtrain_new$wday3 = factor(YRtrain_new$wday3, levels=levels(YRfull_new$wday3));
# YRtrain_new$wday4 = factor(YRtrain_new$wday4, levels=levels(YRfull_new$wday4));
# YRtrain_new$wday5 = factor(YRtrain_new$wday5, levels=levels(YRfull_new$wday5));
# YRtrain_new$wend1 = factor(YRtrain_new$wend1, levels=levels(YRfull_new$wend1));
# YRtrain_new$wend2 = factor(YRtrain_new$wend2, levels=levels(YRfull_new$wend2));
# YRtrain_new$wend3 = factor(YRtrain_new$wend3, levels=levels(YRfull_new$wend3));
# YRtrain_new$wend4 = factor(YRtrain_new$wend4, levels=levels(YRfull_new$wend4));
# YRtrain_new$wend5 = factor(YRtrain_new$wend5, levels=levels(YRfull_new$wend5));

YRtest_new$userid = factor(YRtest_new$userid, levels=levels(YRfull_new$userid));
YRtest_new$businessid = factor(YRtest_new$businessid, levels=levels(YRfull_new$businessid));
YRtest_new$stars = factor(YRtest_new$stars, levels=levels(YRfull_new$stars));
# YRtest_new$city = factor(YRtest_new$city, levels=levels(YRfull_new$city));
# YRtest_new$state = factor(YRtest_new$state, levels=levels(YRfull_new$state));
# # YRtest_new$ustars = factor(YRtest_new$ustars, levels=levels(YRfull_new$ustars));
# # YRtest_new$ureviewcnt = factor(YRtest_new$ureviewcnt, levels=levels(YRfull_new$ureviewcnt));
# # YRtest_new$vuseful = factor(YRtest_new$vuseful, levels=levels(YRfull_new$vuseful));
# # YRtest_new$vfunny = factor(YRtest_new$vfunny, levels=levels(YRfull_new$vfunny));
# # YRtest_new$vcool = factor(YRtest_new$vcool, levels=levels(YRfull_new$vcool));
# YRtest_new$latitude = factor(YRtest_new$latitude, levels=levels(YRfull_new$latitude));
# YRtest_new$longitude = factor(YRtest_new$longitude, levels=levels(YRfull_new$longitude));
# YRtest_new$bstars = factor(YRtest_new$bstars, levels=levels(YRfull_new$bstars));
# YRtest_new$breviewcnt = factor(YRtest_new$breviewcnt, levels=levels(YRfull_new$breviewcnt));
# YRtest_new$wday1 = factor(YRtest_new$wday1, levels=levels(YRfull_new$wday1));
# YRtest_new$wday2 = factor(YRtest_new$wday2, levels=levels(YRfull_new$wday2));
# YRtest_new$wday3 = factor(YRtest_new$wday3, levels=levels(YRfull_new$wday3));
# YRtest_new$wday4 = factor(YRtest_new$wday4, levels=levels(YRfull_new$wday4));
# YRtest_new$wday5 = factor(YRtest_new$wday5, levels=levels(YRfull_new$wday5));
# YRtest_new$wend1 = factor(YRtest_new$wend1, levels=levels(YRfull_new$wend1));
# YRtest_new$wend2 = factor(YRtest_new$wend2, levels=levels(YRfull_new$wend2));
# YRtest_new$wend3 = factor(YRtest_new$wend3, levels=levels(YRfull_new$wend3));
# YRtest_new$wend4 = factor(YRtest_new$wend4, levels=levels(YRfull_new$wend4));
# YRtest_new$wend5 = factor(YRtest_new$wend5, levels=levels(YRfull_new$wend5));

YRhold_new$userid = factor(YRhold_new$userid, levels=levels(YRfull_new$userid));
YRhold_new$businessid = factor(YRhold_new$businessid, levels=levels(YRfull_new$businessid));
YRhold_new$stars = factor(YRhold_new$stars, levels=levels(YRfull_new$stars));


co = 0.1
pt = proc.time();
if(TRUE){

ms = c(0.1,1,10,100,1000)
x <- 0
i <- 1
j <- 1
best = 0
best_ms = 0
while(x!=5)
{
pt = proc.time(); 
tunn <- svm(stars ~., data = YRtrain_new,  cost = ms[i], kernel= "linear", cachesize = 60000)
svm.pred_hold <- predict(tunn, YRtest_new)
outsettab <- table(pred = svm.pred_hold, true = YRtest_new[,1])
acc = geterr(outsettab, '01', nrow(YRtest_new), nrow(outsettab))
if(best<acc){
	best = acc;best_ms = ms[i];
}
print(acc)
print(proc.time() - pt)
x <- x + 1
j <- j + 1
}
} 
tunn <- svm(stars ~., data = YRtrain_new,  cost = best_ms, kernel= "linear", cachesize = 60000)
print(proc.time() - pt)
pt = proc.time(); 
svm.pred_hold <- predict(tunn, YRhold_new)
outsettab <- table(pred = svm.pred_hold, true = YRhold_new[,1])
acc = geterr(outsettab, '01', nrow(YRhold_new), nrow(outsettab))
print(acc)
