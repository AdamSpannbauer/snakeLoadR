#' Add the Snake Game to a Shiny App!

#' @description Use the snake game to pass time during long running shiny operations.
#' @param outputId The output id of the element that triggers the snake game loader;
#'                 probably some output that takes a long time to load (or else there won't be time to play!)
#' @param header The title to display over the game screen.
#' @param controls Should text showing telling user to use the arrow keys appear below the game screen?
#' @return A conditional panel that will load the snake game when the provided \code{outputId} is \code{recalculating}.

#' @examples
#' \dontrun{
#' library(shiny)
#' library(snakeLoadR)
#'
#' shinyApp(
#'   shinyUI(
#'     fluidPage(
#'       fluidRow(
#'         column(width=10, offset=1, algin="left",
#'                actionButton("my_button", "Start Fake 30 Second Job"),
#'                uiOutput("my_output"),
#'         )
#'       ),
#'       snakeLoadR::snake_loader(outputId = "my_output",
#'                                header = "Play Snake while you wait!",
#'                                controls = TRUE)
#'     )
#'   ),
#'   shinyServer(function(input, output) {
#'     output$my_output <- renderUI({
#'       if(input$my_button != 0) Sys.sleep(30)
#'       HTML(paste0("<h3>Fake job completed <code>", input$my_button,"</code> times!</h3>"))
#'     })
#'   })
#' )
#' }

#' @export
snake_loader = function(outputId, header="Play Snake while you wait!", controls=TRUE) {
  if (controls) {
    control_html = '<p style="color:white;">use <kbd>&#x2190;</kbd>&nbsp;<kbd>&#x2195;</kbd>&nbsp;<kbd>&#x2192;</kbd> to play</p>'
  } else {
    control_html = ""
  }

  snake_game_html =
          '
          <h1 style="color:white;">%s</h1>
          <canvas id="gc" width="400" height="400"></canvas>
          %s
          <script>
          window.onload=function() {
              canv=document.getElementById("gc");
              ctx=canv.getContext("2d");
              document.addEventListener("keydown",keyPush);
              setInterval(game,1000/15);
          }
          px=py=10;
          gs=tc=20;
          ax=ay=15;
          xv=yv=0;
          trail=[];
          tail = 5;
          function game() {
              px+=xv;
              py+=yv;
              if(px<0) {
                  px= tc-1;
              }
              if(px>tc-1) {
                  px= 0;
              }
              if(py<0) {
                  py= tc-1;
              }
              if(py>tc-1) {
                  py= 0;
              }
              ctx.fillStyle="black";
              ctx.fillRect(0,0,canv.width,canv.height);

              ctx.fillStyle="lime";
              for(var i=0;i<trail.length;i++) {
                ctx.fillRect(trail[i].x*gs,trail[i].y*gs,gs-2,gs-2);
                if(trail[i].x==px && trail[i].y==py) {
                    tail = 5;
                }
              }
              trail.push({x:px,y:py});
              while(trail.length>tail) {
              trail.shift();
              }

              if(ax==px && ay==py) {
                  tail++;
                  ax=Math.floor(Math.random()*tc);
                  ay=Math.floor(Math.random()*tc);
              }
              ctx.fillStyle="red";
              ctx.fillRect(ax*gs,ay*gs,gs-2,gs-2);
          }
          function keyPush(evt) {
              switch(evt.keyCode) {
                  case 37:
                      xv=-1;yv=0;
                      break;
                  case 38:
                      xv=0;yv=-1;
                      break;
                  case 39:
                      xv=1;yv=0;
                      break;
                  case 40:
                      xv=0;yv=1;
                      break;
              }
          }
          </script>
          '

  snake_game_html = sprintf(snake_game_html, header, control_html)

  shiny::div(
      shiny::conditionalPanel(condition=sprintf("$('#%s').hasClass('recalculating')", outputId),
                       shiny::fluidRow(
                         shiny::column(width=12,align="center",
                                shiny::div(id="snakegame",
                                    #js snake game
                                    shiny::HTML(snake_game_html)
                                    )#div
                                )#column

                         )#fRow
                       ),#condPanel
      #format snakegame position in ui
      shiny::tags$head(
        shiny::tags$style(type="text/css",
                 "#snakegame {
                   position: fixed;
                   left: 0;
                   top: 0;
                   width: 100%;
                   height: 100%;
                   z-index: 100;
                   background-color: rgba(0, 0, 0, 0.75);
                  }")#style
        )#head
      )#div
}
