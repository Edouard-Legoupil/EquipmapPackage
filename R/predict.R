#' Predict
#'
#' @param variable indicator you want to predict
#' @param pred your predictor equipment
#'
#' @return returns prediction of a certain index
#' @export
#' @importFrom dplyr pull
#' @importFrom leaflet leaflet colorBin addTiles setView addPolygons highlightOptions addLegend
#' @importFrom magrittr %>%
#' @importFrom stats as.formula fitted lm
#'
#' @examples

indicateurs <- read.csv("./inst/extdata/indicateur3.csv")

predict <- function(variable,pred){
  df = cbind(data_dpt,indicateurs[-1])
  pred <- fitted(lm(as.formula(paste(variable," ~ ",paste(pred,collapse="+"))),df[,-c(1,2)]),x=TRUE,y=TRUE)
  pred <- as.data.frame(pred) %>% pull(pred)
  dif <- abs(pred-df %>% pull(variable))/mean(df %>% pull(variable))

  bins <-c(0,0.0125,0.025,0.0375,0.05,0.066,0.15,0.5,1)
  #bins <- as.vector(c(0:5,10000)*500)
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
      highlight = highlightOptions(color = "red", bringToFront = TRUE),
      label =  ~ code_insee)%>%
    addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
              position = "bottomright")
  return(res)
  #cv.lm(new[,-c(1,2)], form.lm = formula(niveau ~.), m=10, dots = FALSE, seed=29, plotit="Residual", printit=TRUE)cross validation -> better
}
