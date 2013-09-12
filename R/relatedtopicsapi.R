n <- readline("Find topics from [a] DuckDuckGo Topic [b] Twitter [c] Google Search: ")

switch(n, 
       a={
         answer<-sapply(mostusedterms,  findrelated)
       },
       b={
         # case 'bar' here...
         print('not implemented yet')    
       }, 
       c={
         # case 'bar' here...
         print('not implemented yet')    
       },
{
  print("invalid option")
}
)
