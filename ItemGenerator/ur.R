# setwd("C:/Dropbox/Shiny_R/IGen")
library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Item Generation Tool v.01"),
  
  sidebarPanel(
      textInput("Stem", "Stem","Question Stem 1#1;Question Stem 2#1 and #2"),
      textInput("t1", "#1","Element 1a; Element 1b"),
      textInput("t2", "#2","Element 2a; Element 2b"),
      textInput("t3", "#3"," "),
      textInput("t4", "#4"," "),
      textInput("t5", "#5"," "),
      textInput("t6", "#6"," "),
      textInput("t7", "#7"," "),
      textInput("t8", "#8"," "),
      textInput("answer", "Answer","Choice1*;Choice2;Choice3"),
      
      # This is intentionally an empty object.
      h6(textOutput("save.results")),
      h5("Created by:"),
            tags$a("Econometrics by Simulation", 
                   href="http://www.econometricsbysimulation.com"),
            h5("For details on how data is generated:"),
            tags$a("Blog Post", 
                   href=paste0("http://www.econometricsbysimulation.com/",
                               "2013/19/Shiny-Survey-Tool.html")),
            h5("Github Repository:"),
            tags$a("Survey-Tool", 
                   href=paste0("https://github.com/EconometricsBySimulation/",
                   "Shiny-Demos/tree/master/ItemGenerator")),
            # Display the page counter text.
            h5(textOutput("counter"))
      ),

  
  # Show a table summarizing the values entered
  mainPanel(
    sliderInput("nlayer", "Number of Item Layers", 
                min=1, max=10, value=2),
    sliderInput("nitems", "Number of Items to Generate", 
                min=5, max=100, value=5),
    submitButton("Generate Items"),
    textOutput("CSI"),
    h5(htmlOutput("newitems"))
    )
))
