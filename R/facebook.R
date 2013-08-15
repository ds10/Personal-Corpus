require(RCurl)
require(rjson)

accesstoken <- "CAACEdEose0cBAMphKqUVMcky4fSBKE6YNjEiUfxAY5i3B3HyDBCgGe6zzwzMBjIZCN3yPFvCgyVYjkamzVIgxvDz0sbZAcSZCh6NK97Ck2h4nOA4PGU5XyX5WD6byE4JTdRmYMk1nIkegTFZB9XIo55NNjPLSTkZD"

facebook <-  function( path = "https://www.facebook.com/david.sherlock.98", access_token = token, options){
  if( !missing(options) ){
    options <- sprintf( "?%s", paste( names(options), "=", unlist(options), collapse = "&", sep = "" ) )
  } else {
    options <- ""
  }
  
  data <- getURL( sprintf( "https://graph.facebook.com/%s%s&access_token=%s", path, options, accesstoken ) )
  fromJSON( data )
}

dir.create( "photos" )
photos <- facebook( "https://www.facebook.com/david.sherlock.98/photos" )
sapply( photos$data, function(x){
  url <- x$source
  download.file( url, file.path( "photos", basename(url) ) )
})