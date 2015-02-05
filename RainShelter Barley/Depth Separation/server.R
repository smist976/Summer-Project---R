library(shiny)
source('datafunctions.R')
library(dplyr)
library(ggplot2)
library(scales)


shinyServer(function(input, output) {
  
  
  subset_data <- reactive({
    start_date = input$dateRange[1]
    end_date = input$dateRange[2]
    sensor_type ='VolumetricWaterContent'
    df <- mergeData(start_date, end_date, sensor_type)
    return(df)
  })
  
  
  summary_data <- reactive({
    

    layer_water<-subset_data()%>%
      calculateLayerWater()%>% 
          summarise(avg=mean(layerwater, na.rm=TRUE))
    return(layer_water)
})



  
  min_value <- reactive ({
    df<-summary_data()
    min_value <- quantile(df$Min, 0.15)
    
    return (min_value)
    
  })
  
  max_value <- reactive ({
    df<-summary_data()
    #min_value <- max(df$Max, na.rm=TRUE)
    max_value <- quantile(df$Max, .85)

    return(max_value)
  })
  
  output$soilwaterdeficitPlot <- renderPlot({
    

    ggplot(summary_data())+
      geom_line(aes(x=Time, y=avg, colour=Group, group=Group), size=0.6)+
      facet_wrap(~ depth, ncol=2, scales="free_y")+
      ylab("Layer Water (mm)") 
      #theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
  }, height=825, width=1650)




})