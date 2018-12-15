#' Shiny App
#'
#' @return app
#' @export launchshinyApp
#' @importFrom shiny shinyApp
#' @import shiny
launchshinyApp <- function(){
  shiny:: shinyApp(ui = shinnyappUI, server = shinnyappServer)
}

