library(shiny)
source('datafunctions.R')
library(dplyr)
library(ggplot2)
library(scales)


shinyServer(function(input, output) {
  
  
  subset_data <- reactive({
    start_date = input$dateRange[1]
    end_date = input$dateRange[2]
    sensor_type =input$sensorType
    df <- mergeData(start_date, end_date, sensor_type)
    return(df)
  })
  
  
  summary_data <- reactive({
    subset_data()%>%
      group_by(Group, Time, depth) %>%
        summarise(Mean=mean(value, na.rm=TRUE),
                Max=max(value, na.rm=TRUE),
                Min=min(value, na.rm=TRUE))
  })
    
  min_value <- reactive ({
    df<-summary_data()
    min_value <- quantile(df$Min, 0.15)
    
    return (min_value)
    
  })
  
  max_value <- reactive ({
    df<-summary_data()
    max_value <- quantile(df$Max, 0.85)
    max_value <- quantile(df$Max, .85)
    return(max_value)
  })
  
  output$soilwaterdeficitPlot <- renderPlot({
    

    ggplot(summary_data()) + 
      geom_line(aes(x=Time, y=Mean, colour=Group, group=Group))+
      facet_wrap(~ depth, ncol=2, scales= "free_y") + 

      scale_x_datetime(breaks = "2 days", labels=date_format("%b %d")) +
      xlab("Date") + ylab(input$sensorType)    
 },  height=750, width=1650)

})