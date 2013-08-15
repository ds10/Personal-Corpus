
#This script it reading from MySQL. It finds how many times the most used words in 
#doucments and how many times they were used
source("mineondatabase.R")

mostusedterms <- rownames(mydata.df)

#This script it taking your topic and generating related topics.
source("relatedtopicsapi.R")

#this is to mine the related
source("minerelated.R")


#need to try again but this time using bag of words?