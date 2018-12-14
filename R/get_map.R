#' get_map
#'
#' @param eq type of equipment
#' @param data the data set we are treating
#'
#' @return a map of France with level of equipment
#' @export
#' @importFrom dplyr filter pull
#' @importFrom leaflet leaflet colorBin addTiles setView addPolygons highlightOptions
#' @importFrom stats quantile
#' @importFrom utils read.csv
#' @importFrom rgdal readOGR
#' @importFrom magrittr %>%
#' @examples

data_dpt <- read.csv("./inst/extdata/equipment_final.csv")
departments_shp <- rgdal::readOGR("./inst/extdata/departements-20140306-100m.shp")

get_map <- function(eq, data = data_dpt) {
  dist <- data %>% dplyr::pull(eq)
  bins <- quantile(dist, probs = c(0:6) / 6)
  bins <- bins[!duplicated(bins)]
  pal <- leaflet::colorBin("YlOrRd", domain = dist, bins = bins)

  res <- leaflet::leaflet(data = departments_shp) %>%
    leaflet::addTiles() %>%
    leaflet::setView(lat = 48.5,
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
      highlight = leaflet::highlightOptions(color = "red", bringToFront = TRUE),
      label =  ~ code_insee
    )
  return(res)
}

