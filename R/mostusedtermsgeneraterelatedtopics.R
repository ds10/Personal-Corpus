#aquire libraries
library(rjson)
library(foreach)
library(RMySQL)



n <- readline("Find topics from [1] DuckDuckGo Topic [2] Twitter [3] Google Search: ")
answer<-sapply(mostusedterms,  findrelated)
