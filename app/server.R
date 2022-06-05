#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(leaflet)
library(DT)

data = read.csv("AB_NYC_2019.csv")
unique(data$neighbourhood_group)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- dplyr::filter(data,data$price %in% (input$priceRangeHist[1]:input$priceRangeHist[2]))$price
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  output$mapPlotPrice <- renderLeaflet({
    x <- dplyr::filter(data,data$price %in% (input$priceRangeMap[1]:input$priceRangeMap[2]))
    
    leaflet(data = x) %>% addTiles() %>%  addMarkers(~longitude, ~latitude, label = paste("Name:", x$name),clusterOptions = markerClusterOptions())
    
  })
  output$mapPlotType <- renderLeaflet({
    pal <- colorFactor(c("blue", "red", "green"), domain = unique(data$room_type))
    x <- dplyr::filter(data,data$neighbourhood_group %in% input$roomTypeNeighbourhoodGroupMap)
    
    leaflet(data = x) %>% addTiles() %>% addCircleMarkers(~longitude, ~latitude, radius = 1, opacity = 0.3, fillOpacity = 0.1,
                                                          color = ~pal(room_type), label = paste("Name:", x$name)) %>%
      addLegend(pal=pal, values = ~room_type, title = "Room types", opacity=0.8)
  })
  output$mapPlotNeighbourhood <- renderLeaflet({
    pal <- colorFactor(topo.colors(length(unique(data$neighbourhood))), domain = unique(data$neighbourhood))
    
    map = leaflet(data = data) %>% addTiles() %>% addCircleMarkers(~longitude, ~latitude, radius = 1, opacity = 0.3, fillOpacity = 0.1,
                                                                   color = ~pal(neighbourhood), label = paste("neighbourhood:", data$neighbourhood))
    
  })
  output$reviewsPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    bounds = input$mapPlotNeighbourhood_bounds
    x    <- dplyr::filter(data, between(data$longitude, bounds$west, bounds$east) & between(data$latitude, bounds$south, bounds$north))$reviews_per_month
    x[is.na(x)] <- 0
    if(length(x) == 0){return()}else{
      bins <- seq(min(x), max(x), length.out = input$binsReviews + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
      
    }})
  
  output$nycDatatable = DT::renderDataTable({
    data
  }, options = list(
    scrollX = TRUE
  ))
  
})
