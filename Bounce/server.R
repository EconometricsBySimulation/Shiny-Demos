library(shiny)
input <- list(rseed=1)

shinyServer(function(input, output) {
  
  # Hit counter
  output$counter <- 
    renderText({
      if (!file.exists("counter.Rdata")) counter <- 0
      if (file.exists("counter.Rdata")) load(file="counter.Rdata")
      counter <- counter + 1
      
      save(counter, file="counter.Rdata")     
      paste0("Hits: ", counter)
    })

  mydata <- reactive({
    iI <- input$I     # Initial Height (meters)
    iB <- input$B     # Bounce Efficiency (% of force)
    iA <- input$A     # Air resistance (% loss of vertical velocity/second)
    iG <- input$G     # Gravitation constant (m/second)
    iT <- input$T     # Time Observed (seconds)
    iS <- input$S     # Smoothing value
  
    # iB=.9;iT=100;iS=50;iA=0;iI=100;iG=10;iH=1
    
    y <- iI           # Initial position of y
    vy <- 0           # Initial velocity of y

    x <- seq(0,iT,1/iS) # Calculate horizontal position
    
    for (i in seq(1/iS,iT,1/iS)) {
      y <- c(max(y[1]+vy[1]/iS,0),y)
      
      if (y[1]>0) vy.new <- vy[1]-(iG+vy[1]*iA/100)/iS
      if (y[1]==0) {
        vy.new <- vy[1]
        vy.new <- vy.new*-1*iB/100
      }
      vy <- c(vy.new,vy)
    }
    
    y <- y[length(y):1]
    
    data.frame(second=seq(0,iT,1/iS), x=x, y=y)
  })
  
  # Show bounce plot
  output$bounceplot <- renderPlot({
    data1 <- mydata()
    
    x <- data1$x
    y <- data1$y
    
    par(mar = rep(0, 4))
    plot(x,y, type="l")
    
    px <- c(-10,-10,x,max(x)+10, max(x)+10)  
    py <- c(-10,y[1],y,tail(y, n = 1), -10)
    
    polygon(px,py, col=grey(.8))
    
    iP <- input$P     # Current Position (%)
    point <- round(length(x)*(iP+1)/101)
    point.lag <- pmax(round(length(x)*(iP+(-3):0)/101),0)
    
    lines(x[point.lag],y[point.lag], type="p",
          cex=1.5, bg=grey(.6))
    lines(x[point],y[point], type="p",cex=3
          , bg=grey(.3))
  })
  
})
