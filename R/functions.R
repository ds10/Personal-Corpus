findrelated<-function(x){
  
  #set up database connection
  mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='personalcorpus', host='localhost')
  print(paste("working with topic:", x))
  topic<-x
  
  #We get the URL
  paste("http://api.duckduckgo.com/?q=", topic, sep = "")
  data <- getURL( paste("http://api.duckduckgo.com/?q=", topic, "&format=json",sep = "") )
  jsonlist<-fromJSON( data, method='C') 
  
  #just some debuging stuff
  names(jsonlist)
  length(jsonlist[6][[1]])
  
  #now we are trying to get the text and store it in a database
  foreach (i=jsonlist[6][[1]]) %do% {
    #print (i$Text)
    safequery<-as.vector(i$Text)
    #This needs an if statement otherwise dbescaoe thiungs that you are passing it NULL. NATCH.
    if(length(safequery) != 0) {
      innerquery<<-dbEscapeStrings(mydb, safequery)
      related<-dbEscapeStrings(mydb,i$Text)
      #put it into database
      query<-paste("INSERT INTO RelatedTopics (topic, related) Values ('",topic, "','",related,"')")
      data.frame = dbGetQuery(mydb,query)
    }
  }
  #close connection
  dbDisconnect(mydb)
}

findrelatedtwitter<-function(x){
  #7886963
  #so we do this each time the function is called? Sort this out idiot.
  reqURL <- "https://api.twitter.com/oauth/request_token"
  accessURL <- "http://api.twitter.com/oauth/access_token"
  authURL <- "http://api.twitter.com/oauth/authorize"
  consumerKey <- "70B0eTduZnUsGbHsCXRiw"
  consumerSecret <- "xZnJBfycBqy5cVTQUL8AGpsxXJqybkaVJKS7duoY"
  twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                               consumerSecret=consumerSecret,
                               requestURL=reqURL,
                               accessURL=accessURL,
                               authURL=authURL)
  twitCred$handshake()
  registerTwitterOAuth(twitCred)
  
  searchTwitter(searchString, n=25, lang=NULL, since=NULL, until=NULL,
                locale=NULL, geocode=NULL, sinceID=NULL,
                retryOnRateLimit=120, ...)
  Rtweets(n=25, lang=NULL, since=NULL, ...)
  
}

generatereddittopics<-function(subreds , time = c('day', 'week', 'month', 'year'), plotCloud = TRUE, saveText = TRUE, myDirectory = "/Users/David/Desktop/RStudio/Personal Corpus/R"){
  
  #This function is  shameless rip-off of Tagg Grant.
  
  #######################################################
  # 0. Load the required packages.  And check a few items
  
  require(XML)
  require(RCurl)
  require(RColorBrewer) 
  require(wordcloud)
  require(foreach)
  require(RMySQL)
  
  if (length(time) > 1) { 
    cat("Choose a single timeframe (e.g., day, week, month, or year) \n")
    return(NA)
  }
  
  #######################################################
  # 1. Make the url, get the page. 

foreach (subred=subreds) %do% {
  time <- "year"
  url <- paste("http://www.reddit.com/r/", subred, "/top/?sort=top&t=", time, sep = "")
  doc <- htmlParse(url)
  
  #######################################################
  # 2. Get the links that go to comment sections of the posts
  
  links <- xpathSApply(doc, "//a/@href")
  comments <- grep("comments", links)
  comLinks <- links[comments]
  comments <- grep('reddit.com', comLinks)
  comLinks <- comLinks[comments]
  
  
  #######################################################
  #  3. Scrape the pages
  #  This will scrape a page and put it in to 
  #  an R list object 
  
  textList <- as.list(rep(as.character(""), length(comLinks))) 
  docs <- getURL(comLinks)
  for (i in 1:length(docs)) {
    textList[[i]] <- htmlParse(docs[i], asText = TRUE)
    textList[[i]] <- xpathSApply(textList[[i]], "//p", xmlValue)
  }
  
  #######################################################
  #  4. Clean up the text.
  
  # Remove the submitted lines and lines at the end of each page
  for (i in 1:length(textList)) {
    submitLine <- grep("submitted [0-9]", textList[[i]]) 
    textList[[i]] <- textList[[i]][{(submitLine[1] + 1):(length(textList[[i]])-10)}]
  }
  
  # Removing lines capturing user and points, etc.
  # Yes, there could be fewer grep calls, but this made it 
  # easier to keep track of what was going on.
  for (i in 1:length(textList)) { 
    grep('points 1 minute ago', textList[[i]]) -> nameLines1
    grep('points [0-9] minutes ago', textList[[i]]) -> nameLines2
    grep('points [0-9][0-9] minutes ago', textList[[i]]) -> nameLines3
    grep("points 1 hour ago", textList[[i]]) -> nameLines4
    grep("points [0-9] hours ago", textList[[i]]) -> nameLines5
    grep("points [0-9][0-9] hours ago", textList[[i]]) -> nameLines6
    grep('points 1 day ago', textList[[i]]) -> nameLines7
    grep('points [0-9] days ago', textList[[i]]) -> nameLines8
    grep('points [0-9][0-9] days ago', textList[[i]]) -> nameLines9
    grep('points 1 month ago', textList[[i]]) -> nameLines10
    grep('points [0-9] months ago', textList[[i]]) -> nameLines11
    grep('points [0-9][0-9] months ago', textList[[i]]) -> nameLines12
    allLines <- c(nameLines1, nameLines2, nameLines3, nameLines4, 
                  nameLines5, nameLines6, nameLines7, nameLines8, nameLines9, 
                  nameLines10, nameLines11, nameLines12)
    textList[[i]] <- textList[[i]][-allLines]
    textList[[i]] <- textList[[i]][textList[[i]]!=""]
    textList[[i]] <- tolower(textList[[i]])
  }
  
  
  # Let's simplify our list. Could have been done earlier, but so it goes. 
  allText <- unlist(textList)
  
  # Remove the punctuation, links, etc.
  allText <- gsub("https?://[[:alnum:][:punct:]]+", "", allText)
  allText <- gsub("[,.!?\"]", "", allText)
  #allText <- strsplit(allText, "\\W+", perl=TRUE)
  
  documents <- data.frame( text = allText, stringsAsFactors=FALSE)
  documents$id <- Sys.time() + 30 * (seq_len(nrow(documents))-1) 
  
  require(mallet)
  mallet.instances <- mallet.import( documents$text ,  documents$text , "stoplists/en.txt", token.regexp = "\\p{L}[\\p{L}\\p{P}]+\\p{L}")
  
  ## Create a topic trainer object.
  n.topics <- 30
  topic.model <- MalletLDA(n.topics)
  
  #loading the documents
  topic.model$loadDocuments(mallet.instances)
  
  ## Get the vocabulary, and some statistics about word frequencies.
  ##  These may be useful in further curating the stopword list.
  vocabulary <- topic.model$getVocabulary()
  word.freqs <- mallet.word.freqs(topic.model)
  
  ## Optimize hyperparameters every 20 iterations, 
  ##  after 50 burn-in iterations.
  topic.model$setAlphaOptimization(20, 50)
  
  ## Now train a model. Note that hyperparameter optimization is on, by default.
  ##  We can specify the number of iterations. Here we'll use a large-ish round number.
  topic.model$train(200)
  
  ## NEW: run through a few iterations where we pick the best topic for each token, 
  ##  rather than sampling from the posterior distribution.
  topic.model$maximize(10)
  
  ## Get the probability of topics in documents and the probability of words in topics.
  ## By default, these functions return raw word counts. Here we want probabilities, 
  ##  so we normalize, and add "smoothing" so that nothing has exactly 0 probability.
  doc.topics <- mallet.doc.topics(topic.model, smoothed=T, normalized=T)
  topic.words <- mallet.topic.words(topic.model, smoothed=T, normalized=T)
  
  # from http://www.cs.princeton.edu/~mimno/R/clustertrees.R
  ## transpose and normalize the doc topics
  topic.docs <- t(doc.topics)
  topic.docs <- topic.docs / rowSums(topic.docs)
  
  ## Get a vector containing short names for the topics
  topics.labels <- rep("", n.topics)
  for (topic in 1:n.topics) topics.labels[topic] <- paste(mallet.top.words(topic.model, topic.words[topic,], num.top.words=5)$words, collapse=" ")
  # have a look at keywords for each topic
  topicsforsubreddit<-topics.labels
  
  # create data.frame with columns as authors and rows as topics
  topic_docs <- data.frame(topic.docs)
  names(topic_docs) <- documents$id
  
  
  foreach(topicforsubreddit=topicsforsubreddit) %do% {
    mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='personalcorpus', host='localhost')
    query <- paste('INSERT INTO reddittopics (subreddit,topics) VALUES ("', subred,'" , "', topicforsubreddit ,'  "  )' , sep="")
    queryresult = dbGetQuery(mydb,query)
    dbDisconnect(mydb)
  }
 }
}


youtubecomments<-function(urls){
  apikey<-'AIzaSyBLoKfmOALdgzS-Irqwj79v5NyamSWfAhw'
  urls<-c("http://www.youtube.com/watch?v=1VuMdLm0ccU",
          "http://www.youtube.com/watch?v=NU91V2dlvz4"
  )
  
  require(foreach) 
  
  foreach(url=urls) %do% {
     doc <- htmlParse(url)
     
     #get the comments and do stuff with them see reddit function
     
     
  }
  
} 



generatetwittertopics<-function(username , plotCloud = TRUE, saveText = TRUE, myDirectory = "/Users/David/Desktop/RStudio/Personal Corpus/R"){
  
  
}  