#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  observeEvent(input$score_button_a, {
    shiny::showModal(
      mod_score_input_shinipsum_ui(id = 'A', 
                                   scoring_team_names = c('Dewey', 'Mark', 'Matthew', NULL),
                                   defense_team_names = c('Paul', 'Ryan', 'Gabe', 'Sugmadic')
      )
      )
    mod_score_input_shinipsum_server('A')               
  })
  
  observeEvent(input$score_button_b, {
    shiny::showModal(
      mod_score_input_shinipsum_ui(id = 'B', 
                                   scoring_team_names = c('Paul', 'Ryan', 'Gabe', 'Sugmadic'),
                                   defense_team_names = c('Dewey', 'Mark', 'Matthew', NULL)
      )
    )
    mod_score_input_shinipsum_server('B')               
  })
  
  team_colors = reactive({
    list(
      color_a = input$main_color_a,
      color_b = input$main_color_b
    )
  })
  
  sass_input = reactive({
    list(
      team_colors(),
      sass::sass_file('inst/app/www/team_colors.scss')
    )
  })
  
  compiled_css = reactive({
    value = sass::sass(sass_input())
  })
  
  output$team_colors = renderUI({
    tags$head(tags$style(compiled_css()))
  })
  
}
