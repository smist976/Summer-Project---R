library(shiny)
source('datafunctions.R')



# Define the overall UI
library(shiny)


# Define the overall UI
shinyUI(
  
  
  fluidPage(    
    
    
    titlePanel("Rain Shelter Barley 2014/2015"),
    
    
    verticalLayout(      
      
      #sidebarPanel(
      dateRangeInput('dateRange',
                     label = 'Date range input',
                     start = Sys.Date()- 30, end = Sys.Date()),
<<<<<<< HEAD
=======
      selectInput('sensorType', "Select a Sensor Type", choices=sensorList()),
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
      
      #)
      
      mainPanel(
        plotOutput("soilwaterdeficitPlot")  
      )
      
    )
  )
)