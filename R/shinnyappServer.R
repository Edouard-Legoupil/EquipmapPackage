#' Shinny App Server
#'
#' @param input gives the input
#' @param output gives the output
#' @param session gives the session
#'
#' @return shiny app Server
#' @export
#' @importFrom leaflet renderLeaflet
#' @importFrom magrittr %>%
#' @examples

shinnyappServer <- function(input, output, session) {

  #mise à jour des propositions d'équipements à afficher suivant l'onglet dans lequel on se trouve
  shiny::observeEvent(input$category, {
    shiny::updateSelectInput(
      session = session,
      inputId = "Equipement_name",
      choices = eq_per_category %>% dplyr::filter(cat == as.character(input$category)) %>% dplyr::select(eq),
      selected = NULL
    )
  })


  #chargement de la map que si on appuie sur le bouton
  map <- shiny::reactive({
    input$Print
    isolate({
      get_map(eq = input$Equipement_name)
    })
  })

  map_pred <- reactive({
    input$Print2
    isolate({
      predict(input$prediction,input$predictors)
    })
  })

  predictor_relevant <- reactive({
    input$Print3
    isolate({
      equipment_stepwise(input$prediction_advise)
    })
  })

  map_indic <- reactive({
    input$Print3
    isolate({
      #equipment_stepwise(input$prediction_advise)
      get_map(eq=input$prediction_advise, data=indicateurs)
    })
  })

  #les output correspondant aux 3 maps reéactives
  output$mymap <- renderLeaflet({
    map()
  })
  output$mypred <- renderLeaflet({
    map_pred()
  })
  output$myadvise <- renderDataTable({
    predictor_relevant()
  })
  output$map_indic <- renderLeaflet({
    map_indic()
  })
}
