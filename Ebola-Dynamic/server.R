library("shiny")
library("ggplot2")
library("scales")
library("rmongodb"); load("mongodb-login.RData")

# Simulation and Shiny Application of Flue Season Dynamics
shinyServer(function(input, output) {
    
  mydata <- reactive({
    # Model Parameters:
    
    IC <- input$IC  # Infected
    N  <- input$N   # Total Population
    np <- input$np  # Time periods
    
  # Infection Parameters:
    # Mortality rate Days
    Mr <- input$M  
    
    # Days till resolution
    Days <- input$Days
  
    # Resolution rate per day
    Dr <- 1/Days 
    
    # Transmition rate per day (for those contageous)
    P <- input$P
        
    # Social adaption to disease rt=r0d/(1+S)^t
    
    M   <- input$M
    DET <- input$DET
    K  <- input$K
                    
    # Gain in bumber of beds available
    bedsv <- input$bed0
    for (i in 1:9) bedsv[i+1] <- input[[paste0('bed',i)]]+bedsv[i]
    
    # Model - Dynamic Change
    # Change in Susceptible
    DS  <- function(t) -P*Sr*S[t]*C[t]/(S[t]+C[t]+1)
    
    # Change in Contageous
    DC  <- function(t) P*Sr*S[t]*C[t]/(S[t]+C[t]+1) - 
              min(C[t]*DET, max(beds-Q[t]*(1-Dr),0)) - C[t]*Dr
    
    # Change in quarantined
    DQ <- function(t) 
      min(C[t]*DET, max(beds-Q[t]*(1-Dr),0)) -Q[t]*Dr 
                    
    # Change in deceased          
    DD <- function(t) (Q[t]+C[t])*Mr*Dr
    
    # Change in recovered
    DR <- function(t) (Q[t]+C[t])*(1-Mr)*Dr
    
    # Change in detection over time
    Et <- function(t) detI+(1-(1-detG)^t)*(detM-detI)
    
    S <- C <- Q <- D <- R <- E <- B <- r0 <- rep(NA, np+1)
      
    # Initial populations:
    S[1]  <- N-IC # Sesceptible population
    C[1]  <- IC   # Contageous
    Q[1]  <- 0    # Quarentined
    R[1]  <- 0    # Recovered
    D[1]  <- 0    # Deceased
    B[1]  <- input$bed0
    r0[1] <- P*Days
    
    # Loop through periods
    for (t in 1:np) {
      # Detection rate of unifected per day 
      B[t+1] <- beds <- bedsv[ceiling(t/30)]
      Sr <- (1+K)^(-t)
      r0[t+1] <- P*Sr*Days*(S[t])/(S[t]+C[t])
      
      # Calculate the change values
      dS  <- DS(t) 
      dC  <- DC(t) 
      dQ  <- DQ(t)
      dR  <- DR(t)
      dD  <- DD(t)
      
      # Change the total populations
      S[t+1] <- S[t] + dS
      C[t+1] <- C[t] + dC
      Q[t+1] <- Q[t] + dQ
      R[t+1] <- R[t] + dR
      D[t+1] <- D[t] + dD
      
    }
    
    # Turn the results into a table
    long <- data.frame(
      Period=rep((0:np),6), 
      Population = c(S, C, Q, R, D, B), 
      Indicator=rep(c("Susceptible", 
                      "Contageous", 
                      "Quarentined",
                      "Recovered",
                      "Deceased",
                      "Beds"), 
                    each=np+1))
    wide <- cbind(S, C, Q, R, D, B, r0)
    
    list(long=long, wide=wide)
    
    })
  
  output$r0 <- 
    renderText(paste('Initial r0:', input$P*input$Days))
  output$LDET <- 
    renderText(paste('Likelihood of detection:', round(1-(1-input$DET)^input$Days,2)))
  
  output$datatable <- 
    renderTable({
      Tdata <- mydata()[["wide"]]
      Tdata <- cbind(day=1:nrow(Tdata), Tdata)
      Tdata[seq(1, nrow(Tdata), length.out=30),]
    })
    
  output$graph1 <- renderPlot({
    long <- mydata()[["long"]]
    p <- ggplot(long[long$Indicator %in% input$Indicators,], 
         aes(x=Period, y=Population, group=Indicator))    
    p <- p + 
      geom_line(aes(colour = Indicator), size=1, alpha=.75) + 
      ggtitle("Population Totals")+
      scale_x_continuous(name="Days")+ 
      scale_y_continuous(labels = comma, name="")
    print(p)
  })
  
  output$graph2 <- renderPlot({
    
    data2 <- mydata()[["wide"]]
        
    change <- data2[-1,]-data2[-nrow(data2),]
    
    long <- data.frame(
      Period=rep((1:nrow(change)),7), 
      Population = c(change), 
      Indicator=rep(c("Susceptible", 
                      "Contageous", 
                      "Quarentined",
                      "Recovered",
                      "Deceased",
                      "Beds",
                      "r0"), 
                    each=nrow(change)))
    
    p <- ggplot(long[long$Indicator %in% input$Indicators,], 
                aes(x=Period, y=Population, group=Indicator))    
    p <- p + geom_line(aes(colour = Indicator), size=1,alpha=.75) + 
      ggtitle("Change in Population")+
      scale_x_continuous(name="Days")+
      scale_y_continuous(labels = comma, name="")
    print(p)
  })
  
  output$counter <- 
    renderText({

      db <- "econometricsbysimulation"
      
      mongo <- 
        mongo.create(host     = host , 
                     db       = db, 
                     username = username, 
                     password = password)
      # Please note, as is this code will not work for you.
      # I have saved my host, db, username, and password in
      # RData file load("mongodb-login.RData") in the same
      # directory as my shiny app.
      
      collection <- "ebola_hit"
      
      namespace <- paste(db, collection, sep=".") 
      
      # insert entry
      b <- mongo.bson.from.list(list(platform="MongoHQ", 
                app="counter", date=toString(Sys.Date())))
      ok <- mongo.insert(mongo, namespace, b)
      
      # query database for hit count
      buf <- mongo.bson.buffer.create()
      mongo.bson.buffer.append(buf, "app", "counter")
      query <- mongo.bson.from.buffer(buf)
      
      counter <- mongo.count(mongo, namespace, query)
      
      paste0("Hits: ", counter)
    })
  
})
