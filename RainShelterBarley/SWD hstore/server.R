library(shiny)
source('functions.R')
library(ggplot2)
library(dplyr)
library(scales)

shinyServer(function(input, output) {
  
  
  subset_data <- reactive({
    start_date = paste("'", input$dateRange[1], "'", sep="")
    end_date = paste("'", input$dateRange[2], "'", sep="")
    sensor_type ="'VolumetricWaterContent'"
    df <- getData(start_date, end_date, sensor_type)
    return(df)
  })

  
  summary_data <- reactive({
    df <- subset_data()%>%
      calculateSoilWaterDeficit()%>%
      group_by(group, time) %>%
      summarise(Mean=mean(soilwaterdeficit, na.rm=TRUE), 
                Max=max(soilwaterdeficit, na.rm=TRUE), 
                Min=min(soilwaterdeficit, na.rm=TRUE))
    return(df)
  })
  
  min_value <- reactive ({
    df<-summary_data()
    min_value <- min(df$Min, na.rm=TRUE)
    #min_value <- quantile(df$Min, 0.15)
    
    return (min_value)
    
  })
  
  max_value <- reactive ({
    df<-summary_data()
    max_value <- max(df$Max, na.rm=TRUE)
    #max_value <- quantile(df$Max, .85)
    return(max_value)
  })
  
  
  
  output$soilwaterdeficitPlot <- renderPlot({
    
    ggplot(summary_data()) + 
      geom_ribbon(aes(x=time, ymin=Min, ymax=Max, fill=group), alpha=0.2) +
      geom_line(aes(x=time, y=Mean, colour=group, group=group))+
      ylim (min_value(), max_value()) +
      scale_x_datetime(breaks = "2 days", labels=date_format("%b %d")) +
      xlab("Date") + ylab("Soil Water Deficit (mm)")    
  }, height=600, width=1600)
})