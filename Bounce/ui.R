library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Bounce! A simulation"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    
    sliderInput("I", "Initial Height (meters):", 
                min=0, max=500, value=100),
    
    sliderInput("B", "Bounce Efficiency (% of force):", 
                min=0, max=100, value=80),
    
    sliderInput("A", "Air resistance (% loss of vertical velocity/second):", 
                min=0, max=100, value=1, step=.5),
    
    sliderInput("G", "Gravitation constant (m/second):", 
                min=1, max=50, value=10, step=1),

    sliderInput("T", "Time Observed (seconds):", 
                min=10, max=600, value=60, step=10),
    
    sliderInput("S", "Smoothing Value (seconds/x):", 
                min=1, max=20, value=5),
    
    sliderInput("P", "Current Position (%):", 
                min=0, max=100, value=0, step=.5, animate=T),
  
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
  mainPanel(plotOutput("scatter"))
))
