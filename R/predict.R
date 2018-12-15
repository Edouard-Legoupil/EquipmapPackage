indicateurs <- read.csv("./inst/extdata/indicateur3.csv")

#' @title Visualize the quality of a linear regression model based on chosen predictors
#' @description This function implements a linear regression to predict the chosen economic indicator with a wide range of equipment as predictors. On the returned map, red departments are those with high residuals in the chosen model. An overall red map mean the predictors are not explanatory enough.
#' @param variable economic or social indicator you want to predict
#' @param pred type of equipment used as predictor
#'
#' @return returns prediction of a certain index
#' @export
#' @importFrom dplyr pull
#' @importFrom leaflet leaflet colorBin addTiles setView addPolygons highlightOptions addLegend
#' @importFrom magrittr %>%
#' @importFrom stats as.formula fitted lm

predict <- function(variable,pred){
  df = cbind(data_dpt,indicateurs[-1])
  pred <- fitted(lm(as.formula(paste(variable," ~ ",paste(pred,collapse="+"))),df[,-c(1,2)]),x=TRUE,y=TRUE)
  pred <- as.data.frame(pred) %>% pull(pred)
  dif <- abs(pred-df %>% pull(variable))/mean(df %>% pull(variable))

  bins <-c(0,0.0125,0.025,0.0375,0.05,0.066,0.15,0.5,1)
  bins <- bins[!duplicated(bins)]
  pal <- colorBin("YlOrRd", domain = dif, bins = bins)
  res <- leaflet(data = departments_shp) %>%
    addTiles() %>%
    setView(lat = 48.5,
            lng = 2.5,
            zoom = 5) %>%
    addPolygons(
      data = departments_shp,
      fillColor = ~ pal(dif),
      weight = 1,
      opacity = 0.5,
      color = "white",
      dashArray = "3",
      fillOpacity = 0.7,
      highlightOptions = leaflet::highlightOptions(color = "red", bringToFront = TRUE,stroke = NULL,weight = NULL,
                                                   opacity = NULL, fill = NULL, fillColor = NULL,
                                                   fillOpacity = NULL, dashArray = NULL,
                                                   sendToBack = NULL),
      label =  ~ code_insee)
  return(res)
}
