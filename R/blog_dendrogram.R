mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='paddytherabbit', host='localhost')
query<-paste('SELECT post_content as store from wp_posts WHERE post_status = "publish"')
data.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)

myCorpus <- Corpus(VectorSource(data.frame$store))
corpus.p <-tm_map(myCorpus, removeWords, stopwords("english")) #removes stopwords
corpus.p <-tm_map(myCorpus, removeWords, "nbsp,height,width") #removes stopwords
corpus.p <-tm_map(corpus.p, stripWhitespace) #removes stopwords
corpus.p <-tm_map(corpus.p, tolower)
corpus.p <-tm_map(corpus.p, removeNumbers)
corpus.p <-tm_map(corpus.p, removePunctuation)

dtm <-DocumentTermMatrix(corpus.p)

mydata.dtm <- TermDocumentMatrix(corpus.p)
mydata.dtm2 <- removeSparseTerms(mydata.dtm, sparse=0.7)
mydata.df <- as.data.frame(inspect(mydata.dtm2))
mydata.df.scale <- scale(mydata.df)
d <- dist(mydata.df.scale, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")
plot(fit) # display dendogram?