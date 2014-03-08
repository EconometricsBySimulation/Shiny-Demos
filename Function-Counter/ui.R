library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Function Counter for R"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    
    sliderInput("FS", "Display Range", 
                min=1, max=5000, value=c(1,50)),
    
    sliderInput("ndisplay", "# of Functions to Display", 
                min=0, max=200, value=50),
    
    checkboxInput("logY", "Display log of wordcount", value = FALSE),
        
    textInput("tsearch", "Search for function", "list"),
    tableOutput("tresult"),
          
    h6('Thank you to John Myles White for compiling a list of word frequencies (in 2009) from source files for all CRAN Packages.'),
    tags$a("John Myles White", 
           href="http://www.johnmyleswhite.com/notebook/2009/12/07/r-function-usage-frequencies/"),
    h5("Created by:"),
    tags$a("Econometrics by Simulation", 
           href="http://www.econometricsbysimulation.com"),
    h5("For details on how applications was generated:"),
    tags$a("Blog Post", 
           href="http://www.econometricsbysimulation.com/2014/3/fcount.html"),
    h5("Github Repository:"),
    tags$a("Function Counter", 
           href="https://github.com/EconometricsBySimulation/Shiny-Demos/blob/master/Function-Counter/"),
    h5(textOutput("counter")),
    HTML('<iframe src="//www.facebook.com/plugins/like.php?href=https%3A%2F%2Feconometricsbysimulation.shinyapps.io%2FFCount%2F&amp;width&amp;layout=standard&amp;action=like&amp;show_faces=true&amp;share=true&amp;height=80" scrolling="no" frameborder="0" style="border:none; overflow:hidden; height:80px;" allowTransparency="true"></iframe>')
    ),
  
  # Show a table summarizing the values entered
  mainPanel(plotOutput("frequencydisplay"),
            textOutput("Rangewarning"),
            plotOutput("nchardisplay")
            )
))
