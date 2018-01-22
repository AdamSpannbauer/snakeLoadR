# 🐍 Snake Loading Screen 🐍

A single function R package to add the snake game to a shiny app while long running output is recalculating.  I did not write the snake game itself; the game code came from [Gamkedo
](https://www.youtube.com/watch?v=xGmXxpIj6vs).

### Install

    devtools::install_github("AdamSpannbauer/snakeLoadR")

### Example Output

<p align="center">
  <kbd>
    <img src="readme/snake_load.gif">
  </kbd>
</p>

### Usage

See [this repo](https://github.com/AdamSpannbauer/shiny_snake_loader) for code used to make app in gif.

#### Minimal Shiny App Using `snakeLoadR`

    library(shiny)
    library(snakeLoadR)
    
    shinyApp(
      shinyUI(
        fluidPage(
          fluidRow(
            column(width=10, offset=1, algin="left",
                   actionButton("my_button", "Start Fake 30 Second Job"),
                   uiOutput("my_output")
            )
          ),
          snakeLoadR::snake_loader(outputId = "my_output",
                                   header = "Play Snake while you wait!",
                                   controls = TRUE)
        )
      ),
      shinyServer(function(input, output) {
        output$my_output <- renderUI({
          if(input$my_button != 0) Sys.sleep(30)
          HTML(paste0("<h3>Fake job completed <code>", input$my_button,"</code> times!</h3>"))
        })
      })
    )
