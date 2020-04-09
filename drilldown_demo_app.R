library(shiny)
library(leaflet)

ui <- fluidPage(
  fluidRow(
    actionButton("btn_up", "Drill-Up"),
    actionButton("btn_down", "Drill-Down")
  ),
  fluidRow(
    leafletOutput("mymap", height = 800, width = 800)
  )
)

server <- function(input, output, session) {
  spdf0 <- readRDS("spdf_level1.Rds")
  spdf1 <- readRDS("spdf_level2.Rds")

  cur_level <- reactiveVal("0")

  observeEvent(input$btn_down, {
    cur_level("1")
  })

  observeEvent(input$btn_up, {
    cur_level("0")
  })

  output$mymap <- renderLeaflet({
    spdf <- switch(cur_level(),
      "0" = spdf0,
      "1" = spdf1
    )
    map <- leaflet() %>%
      addPolygons(
        data = spdf, smoothFactor = 0.5, color = "#444444", weight = 1,
        opacity = 1.0, fillOpacity = 1,
        fillColor = ~ colorNumeric("Blues", variable)(variable),
        highlightOptions = highlightOptions(
          color = "white", weight = 2, bringToFront = TRUE
        )
      )
  })
}

shinyApp(ui, server)
