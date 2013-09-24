library(twitteR)
library(ROAuth)
library(RCurl)

requestURL <-  "https://api.twitter.com/oauth/request_token"
accessURL =    "https://api.twitter.com/oauth/access_token"
authURL =      "https://api.twitter.com/oauth/authorize"
consumerKey =   "xxx"
consumerSecret = "xxx"

twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=requestURL,
                             accessURL=accessURL,
                             authURL=authURL)

#download.file(url="http://curl.haxx.se/ca/cacert.pem",
#              destfile="cacert.pem")

# Do once
# twitCred$handshake()
# save it for a future sessions...
#save(list="twitCred", file="twitteR_credentials")
# works, in future I can just


load("twitteR_credentials")
registerTwitterOAuth(twitCred)
me <- getUser("paddytherabbit")