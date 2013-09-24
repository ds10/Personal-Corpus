addlocation<-function(x){
  print(x)
  tmp = getUser(x)
  location(tmp)
  newrow = c("2","1")
  existingDF = rbind(df,newrow)
}

answer<-sapply(tweets.df$screenName,  addlocation)

tweets <- searchTwitter("reddit",5)
tweets.df <- do.call("rbind", lapply(tweets, as.data.frame))

df <- data.frame(
                 )

foreach(i=1:nrow(tweets.df)) %do% {
  
  x<-tweets.df[i,][11]
  tmp = toString(getUser(x))
  location = toString(location(tmp))
  df<-rbind(df,data.frame(username = tmp, location = location))
            
}


answer<-sapply(tweets.df$screenName,  addlocation,df = df)



#Get location of twitters tweeting about something and map them:



answer<-sapply(addlocation,  tweets.df)
lapply(addlocation,tweets.df)
followersLocation = sapply(tweets.userName,function(x){location(x)})
   location(tmp)
   

   
followers=data.frame(screenName = tweets.df$screenName)
followersLocation = sapply(followers,function(x){location(x)})
   
   
   
# Get location data
cat("Getting data from Twitter, this may take a moment.\n")
tmp = getUser(userName)
if(is.null(userLocation)){
  userLocation = location(tmp)
  userLocation = trim(userLocation)
  if(nchar(userLocation) < 2){stop("We can not find your location from Twitter")}
}

followers=tmp$getFollowers(n=nMax)
followersLocation = sapply(followers,function(x){location(x)})
following = tmp$getFriends(n=nMax)
followingLocation = sapply(following,function(x){location(x)})