#aquire libraries
library(rjson)
library(foreach)
library(RMySQL)

#set up database connection
mydb = dbConnect(MySQL(), user='KingKongRoot', password='CarBoot', dbname='personalcorpus', host='localhost')


#although I am currently setting this to cheese, this is taken from a sql query
topic<-"cheese"


#We get the URL
paste("http://api.duckduckgo.com/?q=", topic, sep = "")
data <- getURL( paste("http://api.duckduckgo.com/?q=", topic, "&format=json",sep = "") )
jsonlist<-fromJSON( data, method='C') 

#just some debuging stuff
names(jsonlist)
length(jsonlist[6][[1]])

#now we are trying to get the text and store it in a database
foreach (i=jsonlist[6][[1]]) %do% {
  print (i$Text)
  related<-i$Text
  #put it into database
 # paste("INSERT INTO RelatedTopics (topic, releated) Values ('",topic, "','",i$Text,"')")
  query<-paste("INSERT INTO RelatedTopics (topic, related) Values ('",topic, "','",i$Text,"')")
  data.frame = dbGetQuery(mydb,query)
}

#close connection
dbDisconnect(mydb)