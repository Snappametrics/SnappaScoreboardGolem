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
      h2(paste0('Team ', team, ' Scored'), class = paste0('score-modal-header ', team)),
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
                  choices = scoring_team_names,
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
            onclick = "$('#score-input-modifiers').css('display', 'flex'); $('.score-submission-button').css('display', 'flex');"
            ),
            fluidRow(
              div(id = 'score-input-modifiers',
                column(6, class = paste('score-details', team),
                  h2('Anything Cool Happen?'),
                  shinyWidgets::checkboxGroupButtons(
                    label = NULL, 
                    status = paste("score-addon", team),
                    inputId = ns('score_addons'),
                    choiceNames = list(tags$i(" Paddle", class="fas fa-hand-paper"),
                                       tags$i(" Clink", class="fas fa-assistive-listening-systems"),
                                       tags$i(" Foot", class="fas fa-shoe-prints"),
                                       tags$i(" Header", class="fas fa-podcast")),
                    size = 'lg',
                    choiceValues = c("paddle", 'clink', "foot", "head"),
                    direction = "horizontal",
                    individual = T
                  )
                ),
                column(6, class = paste('previous-score', team),
                  h2('Same Throw as Previous Point?'),
                  tagAppendAttributes(
                    shinyWidgets::switchInput(
                      inputId = ns('related_point'),
                      onLabel = 'Yes',
                      offLabel = 'No',
                      size = 'large'
                    ),
                    class = paste('related-score-input', team)
                  )
                  ),
              style = 'display:none'
              )
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
          tagAppendAttributes(class = paste("score-tabs", team))
      # Closes outermost taglist for modalBody
      ),  
    footer = tagList(
     div(
        shinyWidgets::actionBttn(
          inputId = ns('score_submit'),
          label = ' Submit Score',
          icon = icon('check'),
          style = 'material-flat',
          color = 'success',
          size = 'md'
        ),
        style = 'display:none;',
        class = paste0('score-submission-button ', team)
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
