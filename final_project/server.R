library(ggplot2)
library(shiny)
library(plotly)
library(htmlwidgets)

data <- read.csv(file="prison_final.csv")
trend <- read.csv(file="prison_trend.csv")
us_trend <- read.csv(file="prison_trend_us.csv")
offence <- read.csv(file="prison_us_offence.csv")

function(input, output, session) {
  
  ##DO::add tooltip info
  output$p1 <- renderPlotly({
    
    js <- c(
      "function(el, x){",
      "  Shiny.setInputValue('selected', null);",
      "  el.on('plotly_click', function(evtData) {",
      "    console.log(evtData);",
      "    Shiny.setInputValue('selected', evtData.points[0].y);",
      "  });",
      "}")
    
    # filter data by input:sort_by
    if(input$sort_by == "Total Prisoner") {
      df <- data[order(-data$totalPrisoner)[c(2:13)],c("country","totalPrisoner","NationalPopulation")]
      df$country <- factor(df$country, levels=unique(df$country))
      p1 <- plot_ly(df, x = ~totalPrisoner, y=~reorder(country, totalPrisoner), type='bar', orientation = 'h') %>% onRender(js)
      p1 <- p1 %>% layout(yaxis = list(title = FALSE))
      
    } else if (input$sort_by == "Per 100K Rate") {
      df <- data[order(-data$per100k)[c(1:12)],c("country","per100k","totalPrisoner","NationalPopulation")]
      df$country <- factor(df$country, levels=unique(df$country))
      p1 <- plot_ly(df, x = ~per100k, y=~reorder(country, per100k), type='bar', orientation = 'h') %>% onRender(js)
      p1 <- p1 %>% layout(yaxis = list(title = FALSE))
      
    } else if (input$sort_by == "Biggest GDPs") {
      df <- data[order(-data$GDP.2021)[c(2:13)],c("country","totalPrisoner","GDP.2021")]
      df$country <- factor(df$country, levels=unique(df$country))
      p1 <- plot_ly(df, x = ~totalPrisoner, y=~reorder(country, GDP.2021), type='bar', orientation = 'h') %>% onRender(js)
      p1 <- p1 %>% layout(yaxis = list(title = FALSE))
      
    }
    
    p1  
    
  })
  
  # Add ToolTip with a Country Name
  output$p2 <- renderPlotly({
    
    js <- c(
      "function(el, x){",
      "  el.on('plotly_click', function(evtData) {",
      "    console.log(evtData);",
      "    Shiny.setInputValue('selected', evtData.points[0].text);",
      "  });",
      "}")
    
    if(input$sort_by == "Total Prisoner") {
      df <- data[order(-data$totalPrisoner)[c(2:13)],c("country","totalPrisoner","GDP.2021","NationalPopulation","OccupancyLevel","NumInstitute")]
      df$country <- factor(df$country, levels=unique(df$country))
      p1 <- plot_ly(df, x = ~OccupancyLevel) %>% onRender(js)
      p1 <- p1 %>% add_trace(y = ~NumInstitute, mode = 'markers', showlegend=FALSE, 
                             text= ~country,
                             hovertemplate = ~paste(
                              "<b>%{text}</b><br>",
                              "Num.Institute: %{y}<br>",
                              "Occupancy: %{x:00.%}%<br>",
                              "National Population: ",NationalPopulation," Million.",
                              "<extra></extra>"))
      p1 <- p1 %>% layout(yaxis = list(title = "Number of Prisons"))
      p1 <- p1 %>% layout(xaxis = list(title = "Occupancy Level (%)", side ="top"))
      
      if (!is.null(input$selected)) {
        m <- df[df$country==input$selected, ]  
        a <- list(
          x = m$OccupancyLevel,
          y = m$NumInstitute,
          text = m$country,
          xref = "x",
          yref = "y",
          showarrow = TRUE,
          arrowhead = 7,
          ax = 20,
          ay = -40
        )
        
        if(input$selected == "China") {
          p1 <- p1 %>% add_annotations(
            xref = 'paper', yref = 'paper',
            x = -0.1, y = -0.12,
            text = paste("*Occupancy Level is not available for China. Data point is a guess."),
            font = list(family = 'Arial', size = 10, color = 'rgb(150,150,150)'),
            showarrow=FALSE)
        }
        p1 <- p1 %>% layout(annotations=a)
      }
      
    } else if (input$sort_by == "Per 100K Rate") {
      df <- data[order(-data$per100k)[c(1:12)],c("country","per100k","GDP.2021","totalPrisoner","NationalPopulation","OccupancyLevel","NumInstitute")]
      df$country <- factor(df$country, levels=unique(df$country))
      p1 <- plot_ly(df, x = ~OccupancyLevel) %>% onRender(js)
      p1 <- p1 %>% add_trace(y = ~NumInstitute, mode = 'markers', showlegend=FALSE, 
                             text= ~country,
                             hovertemplate = ~paste(
                               "<b>%{text}</b><br>",
                               "Num.Institute: %{y}<br>",
                               "Occupancy: %{x:00.%}%<br>",
                               "National Population: ",NationalPopulation," Million.",
                               "<extra></extra>"))
      p1 <- p1 %>% layout(yaxis = list(title = "Number of Prisons"))
      p1 <- p1 %>% layout(xaxis = list(title = "Occupancy Level (%)", side ="top"))
      
      if (!is.null(input$selected)) {
        m <- df[df$country==input$selected, ]  
        a <- list(
          x = m$OccupancyLevel,
          y = m$NumInstitute,
          text = m$country,
          xref = "x",
          yref = "y",
          showarrow = TRUE,
          arrowhead = 7,
          ax = 20,
          ay = -40
        )
        p1 <- p1 %>% layout(annotations=a)
      }
      
    } else if (input$sort_by == "Biggest GDPs") {
      df <- data[order(-data$GDP.2021)[c(2:13)],c("country","totalPrisoner","NationalPopulation","GDP.2021","OccupancyLevel","NumInstitute")]
      df$country <- factor(df$country, levels=unique(df$country))
      
      p1 <- plot_ly(df, x = ~OccupancyLevel) %>% onRender(js)
      p1 <- p1 %>% add_trace(y = ~NumInstitute, mode = 'markers', showlegend=FALSE, 
                             text= ~country,
                             hovertemplate = ~paste(
                               "<b>%{text}</b><br>",
                               "Num.Institute: %{y}<br>",
                               "Occupancy: %{x:00.%}%<br>",
                               "National Population: ",NationalPopulation," Million.",
                               "<extra></extra>"))
      p1 <- p1 %>% layout(yaxis = list(title = "Number of Prisons"))
      p1 <- p1 %>% layout(xaxis = list(title = "Occupancy Level (%)", side ="top"))
      
      if (!is.null(input$selected)) {
        m <- df[df$country==input$selected, ]  
        a <- list(
          x = m$OccupancyLevel,
          y = m$NumInstitute,
          text = m$country,
          xref = "x",
          yref = "y",
          showarrow = TRUE,
          arrowhead = 7,
          ax = 20,
          ay = -40
        )
        p1 <- p1 %>% layout(annotations=a)
      }
    }
    
    p1  
    
  })
  
  # Add Title
  output$p3 <- renderPlotly({
    ax <- list(
      title = "",
      zeroline = FALSE,
      showline = FALSE,
      showticklabels = FALSE,
      showgrid = FALSE
    )
    
    if(is.null(input$selected)) {
      df <- trend[trend$Country == "United States",]
      p1 <- plot_ly(df, x = ~Year, y = ~Total, text=~Total)
      p1 <- p1 %>% add_trace(mode = 'lines+markers',showlegend=FALSE)
      p1 <- p1 %>% layout(title = paste("Total # of prisoners in United States."), yaxis=ax)
      p1 <- p1 %>% add_text(textfont = list(family = "sans serif",size = 12,color = toRGB("grey50")), 
                            textposition = "top")
    } else {
      if (input$selected %in% unique(trend$Country)) {
        df <- trend[trend$Country == input$selected,]
        p1 <- plot_ly(df, x = ~Year, y = ~Total, text=~Total)
        p1 <- p1 %>% add_trace(mode = 'lines+markers',showlegend=FALSE)
        p1 <- p1 %>% layout(title = paste("Total # of prisoners in ",input$selected), yaxis=ax)
        p1 <- p1 %>% add_text(textfont = list(family = "sans serif",size = 12,color = toRGB("grey50")), 
                              textposition = "top")  
      } else {
        df <- trend[trend$Country == "United States",]
        p1 <- plot_ly(df, x = ~Year, y = ~Total, text=~Total)
        p1 <- p1 %>% add_trace(mode = 'lines+markers',showlegend=FALSE)
        p1 <- p1 %>% layout(title = paste("Total # of prisoners in United States."), yaxis=ax)
        p1 <- p1 %>% add_text(textfont = list(family = "sans serif",size = 12,color = toRGB("grey50")), 
                              textposition = "top")
      }
    }
    
    p1
    
  })
  
  output$p4 <- renderPlotly({
    df <- us_trend[us_trend$Year %in% c(1950:2020),]
    p1 <- plot_ly(df, x = ~Year, y = ~Total, text=~Total)
    p1 <- p1 %>% add_trace(mode = 'lines+markers',showlegend=FALSE)
    
    p1
  })
  
  output$p5 <- renderPlotly({
    
    ft <- list(family = 'Arial', size = 14, color = 'rgba(67,67,67,1)')
    
    p1 <- offence[offence$Type=="State",] %>%
          plot_ly(x=~Year, color= ~variable, legendgroup=~variable)%>%
          add_trace(y= ~value, mode='lines+markers')
    
    
    p2 <- offence[offence$Type=="Fed",] %>%
          plot_ly(x=~Year, color= ~variable, legendgroup=~variable)%>%
          add_trace(y= ~value, mode='lines+markers', showlegend=FALSE)
    
    plot <- subplot(p1,p2) %>% 
      layout(annotations = list( 
              list(x = 0.01 , y = 1, text = "State Prisoners by Offence", showarrow = F, xref='paper', yref='paper'), 
              list(x = 0.65 , y = 1, text = "Federal Prisoners by Offence", showarrow = F, xref='paper', yref='paper')) 
      ) 
    
    plot
    
  })
  
  
}