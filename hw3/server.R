library(ggplot2)
library(shiny)
library(plotly)
library(htmlwidgets)

data <- read.csv(file="cleaned-cdc-mortality-1999-2010-2.csv")
data1 <- data[data$Year==2010,] 
data2 <- data

function(input, output, session) {
  
  output$q1 <- renderPlot({
    df <- data1 %>%
      filter(ICD.Chapter == input$cause)
    
    df$State <- factor(df$State, levels = df[order(-df$Crude.Rate),"State"])
    df <- df[order(df$State),]
    fill_col <- c("gray50")
    df$lcol <- "black"
    
    
    if (!is.null(input$trace) & !is.null(input$visible) ) { 
      if (input$visible == "legendonly") {
        df[as.character(df$State)==input$trace,"lcol"] <- "red" 
        fill_col <- c("gray50","orange")
      } 
    }
    
    ggplot(data=df, aes(y=Crude.Rate, x=State, fill=lcol)) + 
      geom_bar(stat='identity', position=position_dodge(.5)) +
      scale_fill_manual(values=fill_col, name="lcol") + 
      guides(fill="none") +
      theme(axis.title = element_text(size = 15),
            axis.text.y = element_text(size= 14),
            axis.text.x = element_text(size = 13, angle = 40, colour=df$lcol))
    
  }, width = 1050)
  
  output$q2 <- renderPlotly({
    dat2Sliced <- data2 %>%
      filter(ICD.Chapter == input$cause)
    
    natAvg <- dat2Sliced[1,]
    for (i in unique(dat2Sliced$Year)) {
      natAvg<-rbind(natAvg,
                    data.frame("ICD.Chapter"=input$cause,
                               "State"="National",
                               "Year"=i,
                               "Deaths"=sum(dat2Sliced[dat2Sliced$Year == i, "Deaths"]),
                               "Population"=sum(dat2Sliced[dat2Sliced$Year == i, "Population"]),
                               "Crude.Rate"=sum(dat2Sliced[dat2Sliced$Year == i, "Deaths"]) / sum(dat2Sliced[dat2Sliced$Year == i, "Population"]) * 100000
                    )
      )
    }
    
    pltData <- rbind(dat2Sliced, natAvg[-1, ])
    
    legendItems <- vector("list", length(unique(pltData$State)))
    names(legendItems) <- unique(pltData$State)
    for (i in unique(pltData$State)) {
      if (i == "National") {legendItems[i] <- TRUE}
      else {legendItems[i] <- "legendonly"}
      
    }
    
    js <- c(
      "function(el, x){",
      "  el.on('plotly_legendclick', function(evtData) {",
      "    console.log(evtData);",
      "    Shiny.setInputValue('trace', evtData.data[evtData.curveNumber].name);",
      "    Shiny.setInputValue('visible', evtData.data[evtData.curveNumber].visible);",
      "  });",
      "}")
    
    p <- plot_ly( width = 1050) %>% layout(hovermode='x') %>% onRender(js)
    p <- add_trace(p, data = pltData[!pltData$State %in% c("National"),], 
                   x = ~Year, 
                   y = ~Crude.Rate, 
                   color = ~State, 
                   type = 'scatter',
                   mode = 'lines' )
    p <- add_trace(p, data = pltData[pltData$State %in% c("National"),], 
                   x = ~Year, 
                   y = ~Crude.Rate, 
                   type = 'scatter', 
                   name = "National Avg.", 
                   mode = 'lines+markers', 
                   line = list(dash = "dot", color = "red", width = 4 ))
    p <- plotly_build(p)  
    
    for(i in seq_along(p$x$data)){
      p$x$data[[i]]$visible <- legendItems[[p$x$data[[i]]$name]]
    }
    
    p
    
  })
  
  
}