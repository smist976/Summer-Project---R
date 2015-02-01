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
      selectInput('sensorType', "Select a Sensor Type", choices=sensorList()),
      
      #)
      
      mainPanel(
        plotOutput("soilwaterdeficitPlot")  
      )
      
    )
  )
)