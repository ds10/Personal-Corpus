#aquire libraries
library(rjson)
library(foreach)
library(RMySQL)

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


n <- readline("Find topics from [1] DuckDuckGo Topic [2] Twitter [3] Google Search: ")
answer<-sapply(mostusedterms,  findrelated)
