#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  observeEvent(input$`score-button`, {
    shiny::showModal(
      mod_score_input_shinipsum_ui(id = 'A', 
                                   scoring_team_names = c('Dewey', 'Mark', 'Matthew', NULL),
                                   defense_team_names = c('Paul', 'Ryan', 'Gabe', 'Sugmadic')
      )
      )
    mod_score_input_shinipsum_server('A')               
  })
  
}
