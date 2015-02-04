library(shiny)
source('datafunctions.R')
library(dplyr)
library(ggplot2)
library(scales)


shinyServer(function(input, output) {
  
  
  subset_data <- reactive({
    start_date = input$dateRange[1]
    end_date = input$dateRange[2]
<<<<<<< HEAD
    sensor_type ="VolumetricWaterContent"
=======
    sensor_type =input$sensorType
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
    df <- mergeData(start_date, end_date, sensor_type)
    return(df)
  })
  
  
  summary_data <- reactive({
    
<<<<<<< HEAD
    layer_water<-subset_data()%>%
      calculateLayerWater()%>% 
          summarise(avg=mean(layerwater, na.rm=TRUE))
    return(layer_water)
=======
    df <- subset_data()%>%
      group_by(Group, Time) %>%
        calculateProfileWater%>%
          summarise(Mean=mean(profilewater, na.rm=TRUE), 
                  Max=max(profilewater, na.rm=TRUE), 
                  Min=min(profilewater, na.rm=TRUE))
    print(profile_water)
    return(df)
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
  })
  
  min_value <- reactive ({
    df<-summary_data()
    min_value <- quantile(df$Min, 0.15)
    
    return (min_value)
    
  })
  
  max_value <- reactive ({
    df<-summary_data()
    #min_value <- max(df$Max, na.rm=TRUE)
<<<<<<< HEAD
    max_value <- quantile(df$Max, 0.85)
=======
    max_value <- quantile(df$Max, .85)
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
    return(max_value)
  })
  
  output$soilwaterdeficitPlot <- renderPlot({
    
<<<<<<< HEAD
    ggplot(summary_data())+
      geom_line(aes(x=Time, y=avg, colour=Group, group=Group), size=0.6)+
      facet_wrap(~ depth, ncol=2, scales="free_y")+
      ylab("Layer Water (mm)") 
      #theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
  }, height=825, width=1650)
=======
    ggplot(summary_data()) + 
      geom_line(aes(x=Time, y=Mean, colour=Group, group=Group))+
      facet_grid(depth~.) + 
      ylim (min_value(), max_value()) +
      scale_x_datetime(breaks = "2 days", labels=date_format("%b %d")) +
      xlab("Date") + ylab(input$sensorType)    
  }, height=600, width=1600)
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
})