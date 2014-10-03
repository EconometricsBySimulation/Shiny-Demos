library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Ebola Model"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    
    tags$h3("Data Generation"),
            
    sliderInput("N", "Population:", 
                min=10^4, max=10^7, value=10^6, step=10^4),
    
    sliderInput("IC", "Initial Infected Detected:", 
                min=0, max=10^3, value=100, step=1),
     
    sliderInput("np", "Number of days:", 
                min=30, max=360, value=270, step=10),
      
    textOutput("r0"), 

    sliderInput("P", "Transmition rate:", 
                min=.01, max=.25, value=.081, step=.001),
    
    sliderInput("Days", "Contageous Period (Days):", 
                min=0, max=40, value=18, step=1), 

    sliderInput("M", "Moralitity Rate:", 
                min=0, max=1, value=.6, step=.05), 

    sliderInput("K", "Social 'adaption' to reduce infection:", 
                min=-.0012, max=.0012, value=.0003, step=.0003), 
    
    sliderInput("DET", "Daily Detection Rate:", 
                min=0, max=1, value=.07, step=.01), 
    textOutput("LDET"), 
    
    sliderInput("bed0", "# of Quarantine Beds Available Initially:", 
                min=0, max=10^3, value=0, step=10), 

    sliderInput("bed1", "# of New Quarantine Beds Available at 1 months:", 
                min=0, max=10^3, value=10, step=10), 

    sliderInput("bed2", "# of New Quarantine Beds Available at 2 months:", 
                min=0, max=10^3, value=50, step=10), 
    
    sliderInput("bed3", "# of New Quarantine Beds Available at 3 months:", 
                min=0, max=10^3, value=50, step=10), 

    sliderInput("bed4", "# of New Quarantine Beds Available at 4 months:", 
                min=0, max=10^3, value=50, step=10), 

    sliderInput("bed5", "# of New Quarantine Beds Available at 5 months:", 
                min=0, max=10^3, value=50, step=10), 
    
    sliderInput("bed6", "# of New Quarantine Beds Available at 6 months:", 
                min=0, max=10^3, value=50, step=10), 
    
    sliderInput("bed7", "# of New Quarantine Beds Available at 7 months:", 
                min=0, max=10^3, value=50, step=10), 
    
    sliderInput("bed8", "# of New Quarantine Beds Available at 8 months:", 
                min=0, max=10^3, value=100, step=10), 
    
    sliderInput("bed9", "# of New Quarantine Beds Available at 9 months:", 
                min=0, max=10^3, value=100, step=10), 
    
    br(),

    h5("Created by:"),
    tags$a("Econometrics by Simulation", 
           href="http://www.econometricsbysimulation.com"),
    h5("For details on how data is generated"),
    tags$a("Blog Post", 
           href=""),
    h5(textOutput("counter"))
    
    ),
  
  # Show a table summarizing the values entered
  mainPanel(
    checkboxGroupInput("Indicators", "",
                       c("Susceptible", 
                         "Contageous", 
                         "Recovered",
                         "Deceased",
                         "Quarentined",
                         "Beds"),
                       selected=c(
                         "Contageous", 
                         "Quarentined",
                         "Recovered",
                         "Deceased",
                         "Beds"),
                       inline=TRUE),
    plotOutput("graph1"),
    plotOutput("graph2"),
    tableOutput("datatable")
  )
))
