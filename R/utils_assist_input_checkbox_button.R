#' assist_input_checkbox_button 
#'
#' @description A function to produce the UI elements used in the assists tab of the score input modal
#' @param player_name The name of the player (used in the header of the checkbox buttons)
#' @param namespace_slug The position of the input, in the form 'A1'. Possible values are 'A1 - B4'. This may have to be 
#' changed to the player id though for the purposes of awarding assists in the future. 
#' @param namespace The namespace of the outer calling module, as the function call (e.g. "ns" rather than "ns()")
#' @return A static UI element with the player name as the header, possibly hidden if the player does not exist
#' 
#' @noRd
assist_input_checkbox_button = function(player_name, namespace_slug, namespace) {
  team = substring(namespace_slug, 1, 1)
  tagAppendAttributes(
    shinyWidgets::checkboxGroupButtons(
      label = player_name, 
      status = paste("assists", team),
      inputId = namespace(paste0("assist_", namespace_slug)),
      
      choiceNames = list(tags$i(" Paddle", class="fas fa-hand-paper"), 
                         tags$i(" Clink", class="fas fa-assistive-listening-systems"),
                         tags$i(" Foot", class="fas fa-shoe-prints"),
                         tags$i(" Header", class="fas fa-podcast")),
      size = 'lg',
      choiceValues = c("paddle", "clink", "foot", "head"),
      direction = "horizontal",
      individual = T
      # Very odd, but if you pass a NULL as player name, it actually shows up here as NA, not NULL. So the check is 'is.na'
    ), style = dplyr::if_else(is.na(player_name), 'display: none;', 'display:flex'),
    class = 'assist-button-well'
  )
}