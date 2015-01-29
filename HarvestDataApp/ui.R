#!/bin/env Rscript
library(shiny)
library(ggvis)
source('function.R')

speciesList <- SearchSpecies()

shinyUI(fluidPage(
  titlePanel("Harvest data"),
  
  fluidRow(
    tabsetPanel( 
      tabPanel(title='Table',id='Table',
        tabsetPanel(
          tabPanel('All',
                   dataTableOutput(outputId="Havest_2014"),
                   ggvisOutput("datePlot"),
                   uiOutput("datePlot_ui")
          ),
          tabPanel('Filterby Species',
                      selectInput("SpeInput", 
                                  label="Choose a species", 
                                  choices = speciesList), 
                   downloadButton('download_Filterby_dt', 'Export Data Table'),
                      dataTableOutput(outputId="filterbySpecies")
          ),
          tabPanel('Summary',
                   sidebarLayout(
                     sidebarPanel(
                       radioButtons("group",
                                    label = "Group by",
                                    choices= list("ID"="ID",
                                                  "Breeder"="Breeder",
                                                  "Funding"="Funding",
                                                  "Species"="Species",
                                                  "Product Concept"="Product.Concept")),
                       downloadButton('download_Summary_dt', 'Export Data Table'),
                       width=2
                       ),
                     mainPanel(
                       dataTableOutput(outputId="groupby"),
                       ggvisOutput("groupbyPlot"),
                       uiOutput("groupbyPlot_ui")
                     )
                    )
           )
          )),
      tabPanel(title='Data FF',id='FF',
               fluidRow( 
                  column(10, 
                        checkboxInput('MeanFF', 'MeanFF by UID', FALSE),
                        tabsetPanel(
                          tabPanel('8 week',dataTableOutput(outputId='wk8_table')),
                          tabPanel('12 week',dataTableOutput(outputId='wk12_table')),
                          tabPanel('16 week',dataTableOutput(outputId='wk16_table')),
                          tabPanel('24 week',dataTableOutput(outputId='wk24_table')),
                          tabPanel('ggvisPlot',
                                   sliderInput("week","Select week",8,24,8,4),
                                   uiOutput("FFplot_ggvis_ui"),
                                   ggvisOutput("FFplot_ggvis"))
                                   
                        )
                  )
               )
      ),
      tabPanel(title='Plot',id='Plot',
               ggvisOutput("SSC_DM_Plot"),
               uiOutput("SSC_DM_Plot_ui")
      )
    )
  )
))