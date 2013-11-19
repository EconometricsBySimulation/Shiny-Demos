library(shiny)

Qlist <- read.csv("Qlist.csv")
# Qlist <- Qlist[1,]

shinyServer(function(input, output) {
  
  results <<- rep("", nrow(Qlist))
  names(results)  <<- Qlist[,2]
  
  # Hit counter
  output$counter <- 
    renderText({
      if (!file.exists("counter.Rdata")) counter <- 0
      if (file.exists("counter.Rdata")) load(file="counter.Rdata")
      counter <<- counter + 1
      
      save(counter, file="counter.Rdata")     
      paste0("Hits: ", counter)
    })
    
  output$MainAction <- renderUI( {
    dynamicUi()
  })
  
  
  output$save.results <- renderText({
    if (input$Click.Counter>0&input$Click.Counter>!nrow(Qlist)) results[input$Click.Counter] <<- 
      input$survey
    
    if (input$Click.Counter==nrow(Qlist)+1) {
      if (file.exists("survey.results.Rdata")) 
        load(file="survey.results.Rdata")
      if (!file.exists("survey.results.Rdata")) 
        presults<-NULL
      presults <- presults <<- rbind(presults, results)
      rownames(presults) <- rownames(presults) <<- 
        paste("User", 1:nrow(presults))
      save(presults, file="survey.results.Rdata")
    }
    
    invisible()
    
  })
  
  dynamicUi <- reactive({
    if (input$Click.Counter==0) 
      return(
        list(
          h5("Welcome to Shiny - Survey Tool"),
          h6("by Francis Smart")
        )
      )
    
    if (input$Click.Counter>0 & input$Click.Counter<=nrow(Qlist))  
      return(
        list(
          h5(textOutput("question")),
          radioButtons("survey", "Please Select:", 
            c("Prefer not to answer", option.list()))
          )
        )
    
    if (input$Click.Counter>nrow(Qlist))
      return(
        list(
          h4("View aggrogate results"),
          tableOutput("surveyresults"),
          h4("Thanks for taking the survey!"),
          downloadButton('downloadData', 'Download Individual Results'),
          br(),
          h6("Haven't figured out how to get rid of 'next' button yet")
          )
        )    
  })
  
  output$surveyresults <- renderTable({
    t(summary(presults))
  })
  
  output$dosurvey <- reactive({
    input$Click.Counter<=nrow(Qlist)
  })
  
  output$downloadData <- downloadHandler(
    filename = "IndividualData.csv",
    content = function(file) {
      write.csv(presults, file)
    }
  )
  
  option.list <- reactive({
    qlist <- Qlist[input$Click.Counter,3:ncol(Qlist)]
    as.matrix(qlist[qlist!=""])
    })
  
  output$question <- renderText({
    paste0(
      "Q", input$Click.Counter,":", 
      Qlist[input$Click.Counter,2]
    )
  })
  
})
