#' score_input_shinipsum UI Function
#'
#' @description The Shinipsum implementation of score inputs.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import shinipsum
mod_score_input_shinipsum_ui <- function(id, scoring_team_color, defense_team_color){
  # For now, this has some fun stuff around allowing for a progressive selection of elements using some JS. 
  # This will have to be reasoned on in a more comprehensive way when we get to defining server logic, but 
  # I'm thinking that the selection of each radio element can be passed through the function argument so that
  # we can allow for a "edit scores" style modal
  
  ##TODO: See about the ability to add arbitrary color arguments for the purposes of styling
  ##TODO: Fix alignment on pretty much all elements. 
  ##TODO: Add minimum height and width conditions in css, since xl is not nearly large enough from what I can tell
  ##TODO: Get the assists tab scaffolded out as well
  ##TODO: Add arbitrary buttons for interaction on the "submit score" piece
    # Thinking there is that we could have one of two buttons display depending on whether 
    # or not the modal was called for the purpose of score editing or score entry
  
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
            div(
              h2('Who Scored?'),
              tagAppendAttributes(
                shinyWidgets::radioGroupButtons(
                  status = paste('scorer', id),
                  inputId = ns('scorer'),
                  label = NULL,
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
              # Adds the JS function to handle showing points in the event that a selection is made here
              onclick = "$('#score-input-points').css('display', 'block')"
             )
            ),
            # Then, how much did they score?
            tagAppendAttributes(
              div(id = 'score-input-points',
                h2('How many points?'),
                shinyWidgets::radioGroupButtons(
                  status = paste('points', id),
                  inputId = ns('score'),
                  selected = character(0),
                  label = NULL,
                  choices = c(1, 2, 3, 4, 5, 6, 7),
                  size = 'lg'
                ),
              style = 'display:none'
              ),
            onclick = "$('#score-input-modifiers').css('display', 'block')"
            ),
            div(id = 'score-input-modifiers',
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
              ),
              style = 'display:none'
            )
          )
          ) %>% tagAppendAttributes(class = 'score-entry-tab'),
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
    observeEvent(!is.null(input$score), {
      shinyjs::show('points')
    }) 
  })
}
    
## To be copied in the UI
# mod_score_input_shinipsum_ui("score_input_shinipsum_1")
    
## To be copied in the server
# mod_score_input_shinipsum_server("score_input_shinipsum_1")
