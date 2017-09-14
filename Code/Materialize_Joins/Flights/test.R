fact =read.csv('routesnew.csv');
dim1=read.csv('airlinesnew.csv')
all = merge(fact,dim1,,by="airlineid")


dim2=read.csv('sairportsnew.csv')
all1 = merge(all,dim2,by="sairportid")

dim3=read.csv('dairportsnew.csv')
all11 = merge(all1,dim3,by="dairportid")

write.csv(all11,'all1.csv')

# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

all2 = all11[,c("codeshare","airlineid","sairportid","dairportid","eq1","eq2","eq3","eq4","eq5","eq8","eq12","eq14","eq15","eq17","eq19","eq20","eq22","eq25","eq28","eq30","eq31","eq45","eq46","eq71","name2","name4","acountry","active","scity","scountry","sdst","dcity","dcountry","ddst","name1","slatitude","slongitude","stimezone","dlatitude","dlongitude","dtimezone")]
write.csv(all2,'all2.csv')
