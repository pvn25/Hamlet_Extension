fact =read.csv('listingsnew.csv');
dim1=read.csv('searchesnew.csv')
all = merge(fact,dim1,,by="srch_id")


dim2=read.csv('hotelsnew.csv')
all1 = merge(all,dim2,by="prop_id")
write.csv(all1,'all1.csv')


# all2 = all1[,c("weekly_sales","dept","store","purchaseid","type","size","temperature_avg","temperature_stdev","fuel_price_avg","fuel_price_stdev","cpi_avg","cpi_stdev","unemployment_avg","unemployment_stdev","holidayfreq")]
# all2 = all1[,c("rating","userid","bookid","year","publisher","country","titlewords","authorwords","age")]

all2 = all1[,c("position","prop_id","year","month","weekofyear","time","site_id","visitor_location_country_id","srch_destination_id","prop_country_id","prop_review_score","prop_location_score1","prop_location_score2","prop_log_historical_price","price_usd","promotion_flag","orig_destination_distance","srch_length_of_stay","srch_booking_window","srch_adults_count","srch_children_count","srch_room_count","srch_saturday_night_bool","random_bool","prop_starrating","prop_brand_bool","count_clicks","avg_bookings_usd","stdev_bookings_usd","count_bookings")]
write.csv(all2,'all2.csv')
