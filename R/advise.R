data_dpt <- read.csv("./inst/extdata/equipment_final.csv")
indicateurs <- read.csv("./inst/extdata/indicateur3.csv")

#' @title Choose the best linear model to predict a chosen economic or social indicator
#' @description Choose amongst models with different types of equipments as predictors the model which minimizes the BIC creterion.
#' @param index economic or social indicator you are looking to study
#'
#' @return best equipment predictor(s) for this indicator
#' @export
#' @import dplyr
#' @import stats
#' @importFrom utils capture.output


equipment_stepwise <- function(index){
  new_data <- data_dpt %>% mutate(indi=indicateurs %>% pull("pauvrete"))
  pred_index <- lm(indi~., data = new_data[,-c(1,2)])
  invisible(utils::capture.output(pred_index_step <- stats::step(pred_index, direction="both")))
  pred_index_opt <- stats::lm(formula(pred_index_step), data = new_data)
  eq_significant <- pred_index_opt$coefficients
  eq_significant <- eq_significant[-1]
  A <- as.data.frame(eq_significant)
  res <- cbind(as.data.frame(row.names(A)),A)
  res <- res %>% dplyr::rename(equipment="row.names(A)",coef = "eq_significant")
  return(res)
}
