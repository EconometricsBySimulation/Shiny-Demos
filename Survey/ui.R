library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Shiny-Survey Tool v.01"),
  
  sidebarPanel(
      h6(textOutput("save.results")),
      h5("Created by:"),
            tags$a("Econometrics by Simulation", 
                   href="http://www.econometricsbysimulation.com"),
            h5("For details on how data is generated:"),
            tags$a("Blog Post", 
                   href="http://www.econometricsbysimulation.com/2013/11/a-shiny-app-for-playing-with-ols.html"),
            h5("Github Repository:"),
            tags$a("OLS-Demo-App", 
                   href="https://github.com/EconometricsBySimulation/OLS-demo-App/"),
            h5(textOutput("counter"))
      ),

  
  # Show a table summarizing the values entered
  mainPanel(
    uiOutput("MainAction"),
    actionButton("Click.Counter", "Next")    
    )
))
