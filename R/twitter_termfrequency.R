userTimeline<-userTimeline(me, 3200)
df <- do.call("rbind", lapply(userTimeline, as.data.frame))
tw.df=do.call("rbind",lapply(userTimeline, as.data.frame))

a <- Corpus(VectorSource(tw.df$text)) # create corpus object
a <- tm_map(a, tolower) # convert all text to lower case
a <- tm_map(a, removePunctuation) 
a <- tm_map(a, removeNumbers)
a <- tm_map(a, removeWords, stopwords("english")) # this list needs to be edited and this function repeated a few times to remove high frequency context specific words with no semantic value 

mydata.dtm <- TermDocumentMatrix(a)
mydata.dtm2 <- removeSparseTerms(mydata.dtm, sparse=0.9)
mydata.df <- as.data.frame(inspect(mydata.dtm2))
mydata.df.scale <- scale(mydata.df)
d <- dist(mydata.df.scale, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")
plot(fit) # display dendogram?

mostusedterms <- rownames(mydata.df)

print("your most used terms:")
mostusedterms

n <- readline("Would you like to see where people tweeting about these terms are in relation to you? (Notworking)")