#This script analayses two wordpress blogs that are stored in a mysqldatabase. It's taken script one from settings and script two is set here:
#Borrowed from http://bodongchen.com/blog/?p=301

library(tm)
library(ggplot2)
library(lsa)

mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='personalcorpus', host='localhost')
query<-paste('SELECT store,site,date FROM store')
external1.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)
external.frame <-data.frame(post= external1.frame$store, poster = "mark")

mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='paddytherabbit', host='localhost')
query<-paste('SELECT post_content as store from wp_posts WHERE post_status = "publish"')
data.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)
mydata.frame <-data.frame(post= data.frame$store, poster = "david")

mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='cetis_blogs_new', host='localhost')
query<-paste('SELECT post_content as store FROM cetiswp_5_posts where post_status = "publish" LIMIT 50')
sheila1.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)
sheila.frame <-data.frame(post= sheila1.frame$store, poster = "sheila")


merge.frame <- rbind(external.frame, mydata.frame, sheila.frame)

doc <- Corpus(VectorSource(merge.frame$post))
summary(doc)

externaldoc.corpus <-tm_map(doc, removeWords, stopwords("english")) #removes stopwords
externaldoc.corpus <-tm_map(externaldoc.corpus, stripWhitespace) #removes stopwords
externaldoc.corpus <-tm_map(externaldoc.corpus, tolower)
externaldoc.corpus <-tm_map(externaldoc.corpus, removeNumbers)
externaldoc.corpus <-tm_map(externaldoc.corpus, removePunctuation)




# 2. MDS with raw term-document matrix compute distance matrix
td.mat <- as.matrix(TermDocumentMatrix(externaldoc.corpus ))
dist.mat <- dist(t(as.matrix(td.mat)))
dist.mat  # check distance matrix

fit <- cmdscale(dist.mat, eig = TRUE, k = 2)
points <- data.frame(x = fit$points[, 1], y = fit$points[, 2])
ggplot(points, aes(x = x, y = y)) + geom_point(data = points, aes(x = x, y = y, 
                                                                  color = merge.frame$poster)) + geom_text(data = points, aes(x = x, y = y - 0.2, label = row.names(merge.frame)))


# 3. MDS with LSA
td.mat.lsa <- lw_bintf(td.mat) * gw_idf(td.mat)  # weighting
lsaSpace <- lsa(td.mat.lsa)  # create LSA space
dist.mat.lsa <- dist(t(as.textmatrix(lsaSpace)))  # compute distance matrix
dist.mat.lsa  # check distance mantrix


fit <- cmdscale(dist.mat.lsa, eig = TRUE, k = 2)
points <- data.frame(x = fit$points[, 1], y = fit$points[, 2])
ggplot(points, aes(x = x, y = y)) + geom_point(data = points, aes(x = x, y = y, 
                                                                  color = merge.frame$poster)) + geom_text(data = points, aes(x = x, y = y - 0.2, label = row.names(merge.frame)))


fit <- cmdscale(dist.mat.lsa, eig = TRUE, k = 2)
points <- data.frame(x = fit$points[, 1], y = fit$points[, 2])
ggplot(points, aes(x = x, y = y)) + geom_point(data = points, aes(x = x, y = y, 
                                                                  color = merge.frame$poster) )


library(scatterplot3d)
fit <- cmdscale(dist.mat.lsa, eig = TRUE, k = 2)
colors <- rep(c("red", "green"),)
scatterplot3d(fit$points[, 1], fit$points[, 2], color = colors, 
              pch = 16, main = "Semantic Space Scaled to 3D", xlab = "x", ylab = "y", 
              zlab = "z", type = "h")