#' Shiny App
#'
#' @return app
#' @export launchshinyApp
#' @importFrom shiny shinyApp
#' @example \dontrun {launchshinyApp()}
#' @import shiny
launchshinyApp <- function(){
  shiny:: shinyApp(ui = shinnyappUI, server = shinnyappServer)
}

