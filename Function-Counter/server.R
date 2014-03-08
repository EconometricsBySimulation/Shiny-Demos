library(shiny)

load("freqTable.Rdata")

# Load the CRAN library
library(rmongodb)

load("mongodb-login.RData")

db <- "econometricsbysimulation"

shinyServer(function(input, output) {
  
  # Hit counter using mongo database service.
  # For more information:
  # http://www.econometricsbysimulation.com/2014/02/using-mongohq-to-build-shiny-hit-counter.html
  output$counter <-  renderText({

  mongo <- mongo.create(host=host , db=db, username=username, password=password)
  
  # Load the collection.  In this case the collection is.
  collection <- "Fcounter"
  namespace <- paste(db, collection, sep=".")
  
  # Insert a simple entry into the collection at the time of log in
  # listing the date that the collection was accessed.
  b <- mongo.bson.from.list(list(platform="MongoHQ",
                                 app="counter", date=toString(Sys.Date())))
  ok <- mongo.insert(mongo, namespace, b)
  
  # Now we query the database for the number of hits
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "app", "counter")
  query <- mongo.bson.from.buffer(buf)
  counter <- mongo.count(mongo, namespace, query)
  
  # I am not really sure if this is a good way of doing this
  # at all.
  
  # I send the number of hits to the shiny counter as a renderText
  # reactive function
  paste0("Hits: ", counter)
  })
  
  # Show function list in plot
  output$frequencydisplay <- renderPlot({
    tsearch <- input$tsearch
    # freqTable displays
    FS = input$FS[1]
    FSmax <- input$FS[2]
    ndisplay <- input$ndisplay
        
    nrange <- FS:FSmax
    if ((length(nrange)>ndisplay)&(!ndisplay==0)) 
      nrange <- seq(FS, FSmax, length.out=ndisplay)
    
    par(mar=c(2,2,4,1))
    
    ylist <- freqTable[nrange,2]
    
    if (input$logY) ylist <- log(freqTable[nrange,2])
    
    plot(nrange, type="n",
         ylist, 
         ylim=c(0,max(ylist)*1.2),
         main="Function Count")
    
    for (i in 1:length(nrange)) text(nrange[i], ylist[i], 
                             freqTable[nrange[i],1],
                             srt=90, adj = c(0,.35))  

  })
  
  # Show function list
  output$nchardisplay <- renderPlot({
    tsearch <- input$tsearch
    FS = input$FS[1]
    FSmax <- input$FS[2]
    ndisplay <- input$ndisplay
        
    nrange <- FS:FSmax
    
    par(mar=c(2,2,4,1))
    
    ylist <- freqTable[nrange,4]
    
    plot(nrange,
         ylist, 
         main="Function Character Length")
    
  })
  
  # Provide 
  output$Rangewarning <- renderText({
    FS = input$FS[1]
    FSmax <- input$FS[2]
    ndisplay <- input$ndisplay
    
    returner <- "Display the entire range selected."
    
    if (FSmax-FS>ndisplay) 
      returner <- "Because the display range is greater than number of 
            functions set to display only a sampling of display range 
            of length equal the number to display will be shown."
    if (ndisplay==0) 
      returner <- "Display entire range if display range is set to 0."
        
    returner
  })
  
  # Create a table to display the information for searched function.
  output$tresult <- renderTable({
    tsearch <- input$tsearch
    returner <- freqTable[freqTable[,1]==tsearch,]
    rownames(returner) <- NULL
    if (length(returner)==0) returner <- NULL
    returner
  })
  
})
