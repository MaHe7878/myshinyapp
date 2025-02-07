library(shiny)
library(dplyr)
library(ggplot2)
library(glue)
library(DT)
library(bslib)
library(thematic)

thematic_shiny(font = "auto")


ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "quartz"
    ),
  titlePanel("My First Shiny"),
  h1("Star Wars Characters"),
  selectInput(
    inputId = "choix_genre",
    choices = c("masculine", "feminine", NA),
    label = "Choose the good gender for the character",
    selected = NULL,
    multiple = FALSE,
    selectize = TRUE,
    width = NULL,
    size = NULL
  ),
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
  ),
  textOutput(outputId = "Nombre_personnes"),
  DTOutput(outputId = "StarwarsTable")
)

server <- function(input, output) {
  output$StarWarsPlot <- renderPlot({
    starwars |>
      filter(height > input$taille) |>
      filter(gender %in% input$choix_genre) |>
      ggplot(aes(x = height)) +
      geom_histogram(
        binwidth = 10,
        fill = "white",
        color = "darkblue"
      ) + 
      labs(
        title = glue("Vous avez selectionné le genre : {input$choix_genre}")
      )
  })
  
  output$Nombre_personnes <- renderText({
    glue("Nombre de personnages selectionnés : {
    nrow(
      starwars |>
        filter(height > input$taille) |>
        filter(gender %in% input$choix_genre))}")
  })
  
  output$StarwarsTable <- renderDT({
      starwars |>
        filter(height > input$taille) |>
        filter(gender %in% input$choix_genre)
  })
}


shinyApp(ui = ui, server = server)
