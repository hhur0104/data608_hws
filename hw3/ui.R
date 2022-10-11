library(ggplot2)
library(shiny)
library(plotly)
library(htmlwidgets)


data <- read.csv(file="cleaned-cdc-mortality-1999-2010-2.csv")
data1 <- data[data$Year==2010,] 
data2 <- data

fixedPage(
  column(12, 
         fluidRow(headerPanel('Question 1: Crude.Mortality per Cause (2010)'),
                  mainPanel(
                    selectInput('cause', 'Cause of Death', unique(data1$ICD.Chapter), selected='Neoplasms', width = 650),
                    plotOutput(outputId = "q1", width = "100%")
                  )
         ),
         fluidRow(headerPanel('Question 2: Crude.Mortality Curve by Year (w/ National Avg.)'),
                  mainPanel( plotlyOutput(outputId="q2", width = "140%"))
         )
  )
)