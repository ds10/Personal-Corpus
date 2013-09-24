mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='paddytherabbit', host='localhost')
query<-paste('SELECT post_content as store from wp_posts WHERE post_status = "publish"')
data.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)