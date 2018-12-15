data_dpt <- read.csv("./inst/extdata/equipment_final.csv")
departments_shp <- rgdal::readOGR("./inst/extdata/departements-20140306-100m.shp")

#' @title Creates a map of France with level of equipment
#' @description choose the type of equipment you are interested in
#' @param eq a type of equipment
#' @param data the data set we are treating
#'
#' @return A map of France in which you can decide on the type of equipment you want to plot and which plots the quantity of equipment per capita and per department. The color scale tells you whether there is a high concentration of this equipment per capita (red), or low (yellow).
#' @export
#' @importFrom dplyr filter pull
#' @importFrom leaflet leaflet colorBin addTiles setView addPolygons highlightOptions
#' @importFrom stats quantile
#' @importFrom utils read.csv
#' @importFrom rgdal readOGR
#' @importFrom magrittr %>%


get_map <- function(eq, data = data_dpt) {
  dist <- data %>% dplyr::pull(eq)
  bins <- quantile(dist, probs = c(0:6) / 6)
  bins <- bins[!duplicated(bins)]
  pal <- leaflet::colorBin("YlOrRd", domain = dist, bins = bins)

  res <- leaflet::leaflet(data = departments_shp) %>%
    leaflet::addTiles() %>%
    leaflet::setView(lat = 47.5,
            lng = 2.5,
            zoom = 5) %>%
    leaflet::addPolygons(
      data = departments_shp,
      fillColor = ~ pal(dist),
      weight = 1,
      opacity = 0.5,
      color = "white",
      dashArray = "3",
      fillOpacity = 0.7,
      highlightOptions = leaflet::highlightOptions(color = "red", bringToFront = TRUE,stroke = NULL,weight = NULL,
                                            opacity = NULL, fill = NULL, fillColor = NULL,
                                            fillOpacity = NULL, dashArray = NULL,
                                            sendToBack = NULL),
      label =  ~ nom,
      layerId = ~ code_insee
    )
  return(res)
}
?get_map
