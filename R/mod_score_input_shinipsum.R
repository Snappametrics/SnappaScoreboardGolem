#' score_input_shinipsum UI Function
#'
#' @description The Shinipsum implementation of score inputs.
#'
#' @param id,input,output,session Internal parameters for {shiny}. id should be a team designator, "A" or "B".
#' @param scoring_team_color,defense_team_color Hex color arguments to dynamically style the window
#' @param scoring_team_names,defense_team_names Vectors of length 4 (NULLs if there are fewer than 4 players) containing names of players
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import shinipsum
mod_score_input_shinipsum_ui <- function(id, scoring_team_color, defense_team_color,
                                         scoring_team_names, defense_team_names){
  # For now, this has some fun stuff around allowing for a progressive selection of elements using some JS. 
  # This will have to be reasoned on in a more comprehensive way when we get to defining server logic, but 
  # I'm thinking that the selection of each radio element can be passed through the function argument so that
  # we can allow for a "edit scores" style modal
  
  ##TODO: See about the ability to add arbitrary color arguments for the purposes of styling. Maybe through sass?
  ##TODO: See if there isn't some way to map over the number of players that are provided here, or maybe just provide a fixed number of elements which are hidden depending on the number of players. In short, 
  ## move away from reactive UI output in cases where users are not responsible for changing the UI elements. 
  ns <- NS(id)
  # This "aliasing" feels like kind of a silly thing to do, but so does binding all the html classes with "id".
  # Thus, this is for clarity
  team = id 
  if (team == 'A') opponent = 'B' else if (team == 'B') opponent = 'A'
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
            onclick = "$('#score-input-modifiers').css('display', 'flex'); $('#score-submission-button>button').css('display', 'flex');"
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
            column(6,
                   h3("Assists", class=paste("scoring-header", team)),
                   assist_input_checkbox_button(scoring_team_names[1], paste0(team, '1'), namespace = ns),
                   assist_input_checkbox_button(scoring_team_names[2], paste0(team, '2'), namespace = ns),
                   assist_input_checkbox_button(scoring_team_names[3], paste0(team, '3'), namespace = ns),
                   assist_input_checkbox_button(scoring_team_names[4], paste0(team, '4'), namespace = ns)
            ),
            column(6,
                   h3("Returns", class=paste("scoring-header", opponent)),
                   assist_input_checkbox_button(defense_team_names[1], paste0(opponent, '1'), namespace = ns),
                   assist_input_checkbox_button(defense_team_names[2], paste0(opponent, '2'), namespace = ns),
                   assist_input_checkbox_button(defense_team_names[3], paste0(opponent, '3'), namespace = ns),
                   assist_input_checkbox_button(defense_team_names[4], paste0(opponent, '4'), namespace = ns)
            )
          )
        ) %>% 
            tagAppendAttributes(class = paste(team, "assists"))
        ) %>% 
          tagAppendAttributes(class = "score-tabs")
      # Closes outermost taglist for modalBody
      ),  
    footer = tagList(
      div(id = 'score-submission-button',
          tagAppendAttributes(
            shinyWidgets::actionBttn(
              inputId = ns('score_submit'),
              label = 'Submit Score',
              icon = icon('check'),
              style = 'material-flat',
              color = 'success',
              size = 'md'
            ),
            style = 'display:none'
          )
      )
    )
  )
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
