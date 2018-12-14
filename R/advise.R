#' advise
#'
#' @param index the index considered
#' @param eq  database with equipment per capita
#' @param ind database with indexes
#'
#' @return the best model to predict the indicator considered and the map that gies with itt
#' @export
#' @importFrom rlang enquo
#' @importFrom dplyr select enquo
#' @importFrom utils capture.output
#' @importFrom base invisible
#' @import base
#' @importFrom stats lm step
#' @import dplyr
#' @examples

data_dpt <- read.csv("./inst/extdata/equipment_final.csv")
indicateurs <- read.csv("./inst/extdata/indicateur3.csv")

equipment_stepwise <- function(index, eq = data_dpt, ind = indicateurs){
  index <- dplyr::enquo(index)
  data_index <-  eq %>%
    dplyr::select(-c(1,2))
  col <- ind %>% dplyr::select(column_name = !!index)
  data_index <- data_index %>% dplyr::mutate(indicator = col$column_name)
  pred_index <- stats::lm(indicator~., data = data_index)
  invisible(capture.output(pred_index_step <- stats::step(pred_index, direction="both")))
  pred_index_opt <- stats::lm(formula(pred_index_step), data = data_index)
  eq_significant <- pred_index_opt$coefficients
  eq_significant <- eq_significant[-1]
  A <- as.data.frame(eq_significant)
  res <- cbind(as.data.frame(row.names(A)),A)
  res <- res %>% dplyr::rename(equipment="row.names(A)",coef = "eq_significant")
  return(res)
}


equipment_stepwise("pauvrete")
