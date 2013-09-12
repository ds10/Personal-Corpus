#1)Install mysql and set up tables, set username options
#2)Windows users may have to compile rmysql from source
#3)If you use a self contained MAMP style thing you will need something along the lines of ln -s /Applications/MAMP/tmp/mysql/mysql.sock /tmp/mysql.sock
#4)You will need to stick your twitter API key in the tweet search in functions.R

#set the following true or false, if true then set options too:

reddit <- TRUE

if (reddit == TRUE){
  
  #really we should just ask for usernames and then get the subreddits via reddit API
   subreds<-c("ukpolitics","funny")
}


#Prereqs:
library(rjson)
library(foreach)
library(RMySQL)
library(tm)
library(RCurl)
library(twitteR)
require(topicmodels)
require(mallet)

require(rJava) # needed for stemming function 
library(Snowball) # also needed for stemming function 
require(pvclust)


#you need do the  the following before starting:

#


#natch
source("functions.R")

generatereddittopics(subreds,"year")

#This script it reading from MySQL. It finds how many times the most used words in 
#doucments and how many times they were used. 
source("mineondatabase.R")
source("mineontwitter.R")

mostusedterms <- rownames(mydata.df)

#This script it taking your topic and generating related topics.
source("relatedtopicsapi.R")

#this is to mine the related topics
source("minerelated.R")
