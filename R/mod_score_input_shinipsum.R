#' score_input_shinipsum UI Function
#'
#' @description The Shinipsum implementation of score inputs
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import shinipsum
mod_score_input_shinipsum_ui <- function(id){
  ns <- NS(id)
  shiny::modalDialog(
    easyClose = T, size = 'xl',
    # Content!
    tagList(
      h2('Team Scored'),
      tabsetPanel(
        tabPanel(
          icon = shiny::icon('dice'),
          title = 'Scores',
          fluidRow(
            # First, who scored?
            shinyWidgets::radioGroupButtons(
              status = paste('scorer', id),
              inputId = ns('scorer'),
              label = 'who scored?',
              # This is initialized in an unselected state to potentially allow for some custom JS hiding the points
              # until this is selected. 
              selected = character(0),
              choices = c('Dewey', 'Mark', 'Matthew', 'Shaunt'),
              direction = 'horizontal',
              individual = T,
              size = 'lg',
              checkIcon = list(
                yes = tags$i(class = "fa fa-dice")
              )
            ),
            # Then, how much did they score?
            shinyWidgets::radioGroupButtons(
              status = paste('points', id),
              inputId = ns('score'),
              label = 'Points',
              choices = c(1, 2, 3, 4, 5, 6, 7),
              size = 'lg'
            )
          ),
          fluidRow(
            h2('Anything Cool Happen?')
          ),
          wellPanel(class = "score-switches",
                    # Was it a paddle?
                    shinyWidgets::materialSwitch(
                      inputId = ns("paddle"), inline = T,
                      label = tags$i(" Paddle", class="fas fa-hand-paper")
                    ),
                    # Was it a clink?
                    shinyWidgets::materialSwitch(
                      inputId = ns("clink"), inline = T,
                      label = tags$i(" Clink", class="fas fa-assistive-listening-systems")
                    ),
                    # feet?
                    shinyWidgets::materialSwitch(
                      inputId = ns("foot"), inline = T,
                      label = tags$i(" Foot", class="fas fa-shoe-prints")
                    ),
                    # head?
                    shinyWidgets::materialSwitch(
                      inputId = ns("head"), inline = T,
                      label = tags$i(" Header", class="fas fa-podcast")
                    )
          )
        ),
        tabPanel(
          icon = shiny::icon('hand-paper'),
          title = 'Assists',
          fluidRow(
            
          )  
          )
      )
    ),
    footer = tagList())
}
    
#' score_input_shinipsum Server Functions
#' This is going to be pretty feature light because I just want to show off the modal dialog for now
#' @noRd 
mod_score_input_shinipsum_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_score_input_shinipsum_ui("score_input_shinipsum_1")
    
## To be copied in the server
# mod_score_input_shinipsum_server("score_input_shinipsum_1")
