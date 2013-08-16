library(RMySQL)
library(tm)
#will need ln -s /Applications/MAMP/tmp/mysql.sock /tmp/mysql.sock
mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='personalcorpus', host='localhost')
query<-paste('SELECT related FROM RelatedTopics')
data.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)

myCorpus <- Corpus(VectorSource(data.frame$related))
corpus.p <-tm_map(myCorpus, removeWords, stopwords("english")) #removes stopwords
corpus.p <-tm_map(corpus.p, stripWhitespace) #removes stopwords
corpus.p <-tm_map(corpus.p, tolower)
corpus.p <-tm_map(corpus.p, removeNumbers)
corpus.p <-tm_map(corpus.p, removePunctuation)

dtm <-DocumentTermMatrix(corpus.p)


mydata.dtm <- TermDocumentMatrix(corpus.p)
#mydata.dtm2 <- removeSparseTerms(mydata.dtm, sparse=0.1)
#mydata.df <- as.data.frame(inspect(mydata.dtm2))
#mydata.df.scale <- scale(mydata.df)
#d <- dist(mydata.df.scale, method = "euclidean") # distance matrix
#fit <- hclust(d, method="ward")
#plot(fit) # display dendogram?

freqterms <- findFreqTerms(mydata.dtm, lowfreq=10)
print("Recuring Themes are:")
print(freqterms)

#this needs putting in its own script and making recursive:

n <- readline("Want to go deeper? ")
n <- readline("[1] DuckDuckGo Topic [2] Twitter [3] Google Search: ")

mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='personalcorpus', host='localhost')
query<-paste('TRUNCATE TABLE RelatedTopics')
data.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)

answer<-sapply(freqterms,  findrelated)

mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='personalcorpus', host='localhost')
query<-paste('SELECT related FROM RelatedTopics')
data.frame = dbGetQuery(mydb,query)
dbDisconnect(mydb)

myCorpus <- Corpus(VectorSource(data.frame$related))
corpus.p <-tm_map(myCorpus, removeWords, stopwords("english")) #removes stopwords
corpus.p <-tm_map(corpus.p, stripWhitespace) #removes stopwords
corpus.p <-tm_map(corpus.p, tolower)
corpus.p <-tm_map(corpus.p, removeNumbers)
corpus.p <-tm_map(corpus.p, removePunctuation)

dtm <-DocumentTermMatrix(corpus.p)

mydata.dtm <- TermDocumentMatrix(corpus.p)
#mydata.dtm2 <- removeSparseTerms(mydata.dtm, sparse=0.1)
#mydata.df <- as.data.frame(inspect(mydata.dtm2))
#mydata.df.scale <- scale(mydata.df)
#d <- dist(mydata.df.scale, method = "euclidean") # distance matrix
#fit <- hclust(d, method="ward")
#plot(fit) # display dendogram?

freqterms <- findFreqTerms(mydata.dtm, lowfreq=10)
print("Recuring Themes are:")
freqterms
