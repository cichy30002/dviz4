#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# 

library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
data = read.csv("AB_NYC_2019.csv")

# Define UI for application that draws a histogram
dashboardPage(
  #  dashboardHeader(title = div(span("NYC Airbnb"), img(src="logo.png", class="airbnb-logo"))),
  dashboardHeader(title = tags$a(href='', class="airbnb-logo-container",
                                 tags$img(src="white-logo.png", height = '35', width = '35'),
                                 'NYC Airbnb', target="_blank", class="airbnb-logo")),
  dashboardSidebar(
    sidebarMenu(
      menuItem(span("Dashboard"), tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Maps", tabName = "maps", icon = icon("map")),
      menuItem("About", tabName = "about", icon = icon("info"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    tabItems(
      tabItem(tabName = "dashboard",
              h2("Dashboard", id="tab-title"),
              box(
                title = "Price distribution for the whole dataset", status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                plotOutput("distPlot"),
              ),
              box(
                title = "Inputs", status = "warning", solidHeader = TRUE,
                "Box content here", br(), "More box content",
                sliderInput("bins",
                            "Number of bins:",
                            min = 1,
                            max = 50,
                            value = 30),
                sliderInput("priceRangeHist",
                            "Price range:",
                            min = 0,
                            max = max(data$price),
                            value = c(0,max(data$price))),
              ),
              box(
                title = "Datatable",
                status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                DT::dataTableOutput("nycDatatable"),
                width = 12
              )
              
      ),
      
      tabItem(tabName = "maps",
              h2("Maps", id="tab-title"),
              box(
                title = "Histogram", status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                leafletOutput("mapPlotPrice"),
              ),
              
              box(
                title = "Inputs", status = "warning", solidHeader = TRUE,
                "Box content here", br(), "More box content",
                sliderInput("priceRangeMap",
                            "Price range for map:",
                            min = 0,
                            max = max(data$price),
                            value = c(300,max(data$price))),
              ),
              
              box(
                title = "Inputs", status = "warning", solidHeader = TRUE,
                "Box content here", br(), "More box content",
                checkboxGroupInput("roomTypeNeighbourhoodGroupMap", "Neighbourhood group",
                                   unique(data$neighbourhood_group), selected = unique(data$neighbourhood_group))
              ),
              
              box(
                title = "Map of places", status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                leafletOutput("mapPlotType"),
              ),
              
              box(
                title = "Histogram", status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                leafletOutput("mapPlotNeighbourhood")
              ),
              
              box(
                title = "Histogram of reviews per month for the current region of the map", status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                plotOutput("reviewsPlot"),
                sliderInput("binsReviews",
                            "Number of bins:",
                            min = 1,
                            max = 50,
                            value = 30)
              )
      ),
      
      tabItem(tabName = "about",
              h2("About", id="tab-title"),
              div(
                p(
                  "Around the turn of the year 2019/20 there was a coronavirus outbreak, which shocked the world.
                  Nearly everyone on the planet was somehow affected by it and for travel industry it was no exception.
                  The number of booking plummeted due to the governments restrictions on movement and people's panic of getting infected.
                  However, now the situation seems to be stabilazing thanks to the vaccines.
                  "
                ),
                p(
                  "The number of hotel bookings is constantly growing, but still is below 2019 values.
                  That's why we decided to create an application for visualizing accomodation listing in given area.
                  We decided to choose New York City, because it is one of the most important cities in the world and we also
                  found many evidences for increased booking demand there.
                  We also discovered excellent dataset with nearly 50 thousand listings from one of the most popular platform for booking called Airbnb.
                  This data is from pre-pandemic year of 2019 when there were many options available."
                ),
                p(
                  "We believe that our app can help with getting insigts about the market there for example, which neighbourhoods were the most popular ones."
                ),
                p (
                  "Links: ",
                  br(),
                  a("Dataset", href="https://www.kaggle.com/datasets/dgomonov/new-york-city-airbnb-open-data",
                    target="_blank"),
                  br(),
                  a("Example tourism forecast", href="https://www.cityguideny.com/article/forecast-nyc-2022-tourism#:~:text=NYC%20%26%20Co.%20is%20anticipating%2056.4,70%25%20increase%20from%20last%20year.",
                    target="_blank")
                ),
                class="about-text")
      )
    )
  )
)

