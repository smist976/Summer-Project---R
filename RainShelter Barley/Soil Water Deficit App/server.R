setwd("C:/GitHubRepos/Summer Project - R/RainShelter Barley/Soil Water Deficit App")

library(shiny)
source('datafunctions.R')
library(dplyr)
library(ggplot2)
library(scales)


shinyServer(function(input, output) {
  
  
  subset_data <- reactive({
    start_date = input$dateRange[1]
    end_date = input$dateRange[2]
    sensor_type ="VolumetricWaterContent"
    df <- mergeData(start_date, end_date, sensor_type)
    return(df)
  })
  
  
  summary_data <- reactive({
    
    df <- subset_data()%>%
      calculateSoilWaterDeficit()%>%
      group_by(Group, Time) %>%
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
      geom_ribbon(aes(x=Time, ymin=Min, ymax=Max, fill=Group), alpha=0.2) +
      geom_line(aes(x=Time, y=Mean, colour=Group, group=Group))+
      ylim (min_value(), max_value()) +
      scale_x_datetime(breaks = "2 days", labels=date_format("%b %d")) +
      xlab("Date") + ylab("Soil Water Deficit (mm)")    
  }, height=600, width=1600)
})