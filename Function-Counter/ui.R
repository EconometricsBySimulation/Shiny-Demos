library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Function Counter for R"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    
    sliderInput("FS", "Display Range", 
                min=1, max=53478, value=c(1,50)),
    
    sliderInput("ndisplay", "# of Functions to Display", 
                min=0, max=200, value=50),
    
    checkboxInput("logY", "Display log of wordcount", value = FALSE),
        
    textInput("tsearch", "Search for function", "list"),
          
    h5("Created by:"),
    tags$a("Econometrics by Simulation", 
           href="http://www.econometricsbysimulation.com"),
    h5("For details on how data is generated:"),
    tags$a("Blog Post", 
           href="http://www.econometricsbysimulation.com/2013/11/alpha-testing-shinyappsio-first.html"),
    h5("Github Repository:"),
    tags$a("Function Counter", 
           href="https://github.com/EconometricsBySimulation/Shiny-Demos/tree/master/Bounce"),
    h5(textOutput("counter"))
    ),
  
  # Show a table summarizing the values entered
  mainPanel(plotOutput("frequencydisplay"),
            textOutput("Rangewarning"),
            tableOutput("tresult"),
            textOutput("near"))
))
