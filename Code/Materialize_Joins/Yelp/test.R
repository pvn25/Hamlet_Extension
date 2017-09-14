fact =read.csv('reviewfinal.csv');
dim1=read.csv('usergend.csv')
all = merge(fact,dim1,,by="userid")


dim2=read.csv('businesscheckin.csv')
all1 = merge(all,dim2,by="businessid")
write.csv(all1,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

all2 = all1[,c("stars","businessid","userid","gender","cat109","cat363","cat361","cat366","cat344","cat33","city","cat501","cat444","cat404","cat259","cat246","cat79","open","cat221","cat314","cat104","state","ureviewcnt","ustars","vuseful","vfunny","vcool","latitude","longitude","bstars","breviewcnt","wday1","wday2","wday3","wday4","wday5","wend1","wend2","wend3","wend4","wend5")]
write.csv(all2,'all2.csv')
