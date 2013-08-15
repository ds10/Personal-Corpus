cons<-dbListConnections(MySQL())
for(con in cons)
  dbDisconnect(con)