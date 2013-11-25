library("shiny")
library("stringr")


shinyServer(function(input, output) {
  
  # Hit counter
  output$counter <- 
    renderText({
      if (!file.exists("counter.Rdata")) counter <- 0
      if (file.exists("counter.Rdata")) load(file="counter.Rdata")
      counter <- counter <<- counter + 1
      
      save(counter, file="counter.Rdata")     
      paste0("Hits: ", counter)
    })
  
  items <- reactive({
    textOut <- ""
    
    mainlist <- strsplit(input$Stem, ";")[[1]]
    answerlist <- strsplit(input$answer, ";")[[1]]
    nanswer <- length(answerlist)
    
    for (t in 1:8) assign(paste0("t",t), 
                          strsplit(input[[(paste0("t",t))]],";")[[1]])
    
    items <- list()
    for (i in 1:input$nitems) {
      items[i] <- paste(c(
        paste0(i,":",sample(mainlist,1)), 
        paste(letters[1:nanswer],". ", 
              sample(answerlist,nanswer), 
              collapse="\n", sep=""),"\n"
      ), collapse="\n")
      
      for (l in 1:input$nlayer) for (t in 1:8) 
        items[i] <- gsub(paste0("#",t),sample(get(paste0("t",t)),1),items[i])
    }
    items
  })
    
  
  output$newitems <- renderText({
    textOut <- paste(items(), collapse="\n")
    
    txt <- c('<pre><span style="font-family: monospace">',textOut, 
             '</span></pre>')
    paste(txt, collapse="\n")
    
  })
  
  output$CSI <- renderText({
    
   igenerate <- items()
        
   CSIlist <- NULL
  
   for (i in 1:(length(igenerate)-1)) {
   
     igenerate1 <- igenerate[[i]]
     igenerate2 <- igenerate[[i+1]]
     
     for (i in c("\n","a\\.", "b\\.", "c\\.", "d\\.", "e\\.", ":")) {
        igenerate1 <- gsub(i, " ", igenerate1)
        igenerate2 <- gsub(i, " ", igenerate2)
     }
     
     igenerate1 <- strsplit(igenerate1, " ")[[1]]
     igenerate2 <- strsplit(igenerate2, " ")[[1]]
          
     igenerate1 <- igenerate1[igenerate1!=""]
     igenerate2 <- igenerate2[igenerate2!=""]
     
     t.vect <- unlist(igenerate1,igenerate2)
      
     t.vect <- t.vect[!t.vect==""] 
    
     wtcount1 <- wtcount2 <- rep(0,length(t.vect))
     
     for (ii in 1:length(t.vect)) wtcount1[ii] <- sum(str_count(igenerate1, t.vect[ii]))
     for (ii in 1:length(t.vect)) wtcount2[ii] <- sum(str_count(igenerate2, t.vect[ii]))
     
     denominator <- (sum(wtcount1^2))^.5 * (sum(wtcount2^2))^.5
     numerator <- sum(wtcount1*wtcount2)
     CSIlist <- c(CSIlist, numerator/denominator)
   }
    
  c("CSI", CSIlist)
  })
})
