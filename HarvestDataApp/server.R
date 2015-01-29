#!/bin/env Rscript
library(shiny)
library(data.table)
library(dplyr)
library(knitr)
library(ggplot2)
library(tidyr)
source('function.R')

shinyServer(function(input, output) {
  
  ##Reactive functions
  AllData <- reactive({
    Read_Table()
  })
  
  Summary_dt <- reactive({
    dt <- AllData() %>%
      group_by_(input$group) %>%
      summarise(meanHvSSC=mean(HvSSC,na.rm = TRUE),
                meanPercentDM=mean(X.DM,na.rm=TRUE),
                meanFruitWt=mean(FruitWt.g.,na.rm=TRUE))  
    return(dt)
  })
  
  FilterbySpecies_dt <- reactive({
    dt <- AllData() %>%
      select(1:26,-Feb.RedSpread,-FebRedIntInner,-Feb.RedIntOuter) %>%
      filter(Species==input$SpeInput)
    return(dt)
  })

  ##Outputs  
  output$Havest_2014 <- renderDataTable({
    AllData() %>%
      select(1:26)
  }, options = list(lengthMenu = c(5,15,30,50),pageLength = 5))
  
      ###ggvisplot1
      datePlot<- reactive({
        AllData() %>%
        ggvis(x = ~HvDate) %>% 
          layer_histograms(fill.hover := "red") %>% 
          scale_datetime("x", nice = "month") %>%
          add_axis("y", title = "density")
      })  
      
      datePlot %>% bind_shiny("datePlot", "datePlot_ui")
      ###

  ##Output cont.
  output$filterbySpecies <- renderDataTable({
    FilterbySpecies_dt()
  }, options = list(lengthMenu = c(5,15,30,50),pageLength = 15))
  
  output$groupby <- renderDataTable({
    Summary_dt() 
  }, options = list(lengthMenu = c(5,15,30,50),pageLength = 5))

      ###ggvis plot2
      groupbyPlot<- reactive({
          library(ggvis)
          tooltip1 <- function(x) {
            if(is.null(x)) return(NULL)
            return(paste0("<b>","ID: ", x[3], "</b><br>","meanHvSSC: ", x[2], "<br>","meanPercentDM: ", x[1]))}
          
          Summary_dt() %>% 
            ggvis(x = ~meanHvSSC, y = ~meanPercentDM, key := ~ID) %>%
            layer_points(size := 50, size.hover := 200,
                         fillOpacity := 0.3, fillOpacity.hover := 0.5) %>%
            add_tooltip(tooltip1,"hover") 
        })  
      
      groupbyPlot %>% bind_shiny("groupbyPlot", "groupbyPlot_ui")
      ###

  ##Output cont.
  output$wk8_table <- renderDataTable({    
    FF_Data('8',input$MeanFF)
  })

  output$wk12_table <- renderDataTable({    
    FF_Data('12',input$MeanFF)
  })

  output$wk16_table <- renderDataTable({    
    FF_Data('16',input$MeanFF)
  })

  output$wk24_table <- renderDataTable({    
    FF_Data('24',input$MeanFF)
  })
  
        ###ggvis plot FF
        FFplot_ggvis<- reactive({
          dt <- FF_Data(input$week,"FALSE")
          
          dt %>%
            ggvis(~HvDate,~val) %>%
            layer_points(size := 50, size.hover := 200,
          fillOpacity := 0.3, fillOpacity.hover := 0.5) 
        })
        FFplot_ggvis %>% bind_shiny("FFplot_ggvis", "FFplot_ggvis_ui")
  
        ###ggvis plot3
        SSC_DM_Plot<- reactive({
          tooltip2 <- function(x) {
            if(is.null(x)) return(NULL)
            row <- AllData() %>% filter(UID == x$UID)
            return(paste0("<b>","UID: ", row$UID, "</b><br>","HvDate: ", row$HvDate, "<br>","HvSSC: ", row$HvSSC))
           }
  
          AllData() %>% 
              ggvis(~HvDate,~HvSSC,fill = ~Breeder, key := ~UID,
                    opacity := input_slider(0, 1, value = 0.7, label = "Opacity")) %>%
              layer_points() %>%
              add_tooltip(tooltip2,"hover") %>%
              scale_datetime("x", nice = "month")
        })
        SSC_DM_Plot %>% bind_shiny("SSC_DM_Plot", "SSC_DM_Plot_ui")  
         ###

  ##Output cont.
  ###NOTE: Download button only works in browser
  output$download_Filterby_dt <- downloadHandler( 
    filename = function() {paste('Filter_dt-by_', input$SpeInput, '.csv', sep='')},
    content = function(file) { 
      write.csv(FilterbySpecies_dt(), file)
    } 
  )
  
  output$download_Summary_dt <- downloadHandler( 
    filename = function() {paste('Summary_dt-by_', input$group, '.csv', sep='')},
    content = function(file) { 
      write.csv(Summary_dt(), file)
    } 
  )
  
})