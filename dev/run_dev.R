# Sass code compilation
sass::sass(input = sass::sass_file("inst/app/www/team_colors.scss"), output = "inst/app/www/team_colors.css", cache = NULL)

# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# Run the application
run_app()
