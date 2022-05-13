#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      h1("SnappaScoreboardGolem"),
      column(6, 
        shiny::actionButton(inputId = 'score_button_a', label = 'We Scored'),
        colourpicker::colourInput('main_color_a', 'Team A Main Color', value = '#e26a6a')
      ),
      column(6, 
        shiny::actionButton(inputId = 'score_button_b', label = 'We Scored'),
        colourpicker::colourInput('main_color_b', 'Team B Main Color', value = '#2574a9') 
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'SnappaScoreboardGolem'
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
    
    # This is maybe a bit unconventional, but I don't think it's a stretch to consider sass to be an 
    # external resource that we can use here. The reason why it's going to look weird is because I'm 
    # going to call a UI output which calls the sass, which is a reactive since users can change it
    uiOutput('team_colors')
  )
}

