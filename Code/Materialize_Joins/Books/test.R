fact =read.csv('ratingsnew.csv');
dim1=read.csv('booksnew.csv')
all = merge(fact,dim1,,by="bookid")


dim2=read.csv('usersnew.csv')
all1 = merge(all,dim2,by="userid")
write.csv(all1,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]
write.csv(all2,'all2.csv')
