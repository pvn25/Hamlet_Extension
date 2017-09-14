fact =read.csv('ratings.csv');
dim1=read.csv('moviesnew.csv')
all = merge(fact,dim1,,by="movieid")


dim2=read.csv('users.csv')
all1 = merge(all,dim2,by="userid")
write.csv(all1,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

all2 = all1[,c("rating","userid","movieid","namepar","year","action","adventure","animation","children.s","comedy","crime","documentary","drama","fantasy","film.noir","horror","musical","mystery","romance","sci.fi","thriller","war","western","gender","occupation","zipcode","namewords","age")]
write.csv(all2,'all2.csv')
