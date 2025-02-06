library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  titlePanel("My First Shiny"),
  h1("Star Wars Characters"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "taille",
        label = "Heads of characters:",
        min = 0,
        max = 250,
        value = 30
      )
    ),
    mainPanel(
      plotOutput("StarWarsPlot")
    )
  )
)

server <- function(input, output) {
  output$StarWarsPlot <- renderPlot(
    starwars |>
      filter(height > input$taille) |>
      ggplot(aes(x = height)) +
      geom_histogram(
        binwidth = 10,
        fill = "darkgrey",
        color = "white"
      )
  )
}

shinyApp(ui = ui, server = server)
