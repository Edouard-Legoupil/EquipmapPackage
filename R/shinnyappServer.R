#' @title Shinny App Server
#' @description running our Shiny application
#' @param input gives the input
#' @param output gives the output
#' @param session gives the session
#'
#' @return shiny app Server
#' @export
#' @importFrom leaflet renderLeaflet leafletProxy clearPopups setView addPopups
#' @importFrom magrittr %>%
#' @importFrom glue glue

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


  map <- shiny::reactive({
    input$Print
    isolate({
      get_map(eq = input$Equipement_name)
    })
  })

  map_pred <- reactive({
    input$Print2
    isolate({
      predi <- c(input$predictors1,input$predictors2,input$predictors3,input$predictors4,input$predictors5,input$predictors6,input$predictors7)
      predict(input$prediction,predi)
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


  observe({
    click <- input$mymap_shape_click
    if(is.null(click))
      return()
    isolate({
      leafletProxy("mymap") %>%
        clearPopups() %>%
        setView(lng = click$lng, lat = click$lat, zoom = 8) %>%
        addPopups(glue::glue('The {click$id} department has {signif(get_info(eq = input$Equipement_name, code_insee = click$id)[1], 3)} {input$Equipement_name} per inhabitant, the national median being {signif(get_info(eq = input$Equipement_name, code_insee = click$id)[2], 3)}'), lng = click$lng, lat = click$lat)
    })

    click2 <- input$map_indic_shape_click
    if(is.null(click2))
      return()
    isolate({
      leafletProxy("map_indic") %>%
        clearPopups() %>%
        setView(lng=click2$lng, lat = click2$lat, zoom = 8) %>%
        addPopups(glue::glue('The {click2$id} department has {input$prediction_advise} of {signif(get_info(eq = input$prediction_advise, code_insee = click2$id, data = indicateurs)[1], 3)}, the national median being {signif(get_info(eq = input$prediction_advise, code_insee = click2$id, data = indicateurs)[2], 3)}'), lng = click2$lng, lat = click2$lat)
    })
  })
}
