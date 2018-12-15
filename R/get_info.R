#' @title  Name of equipement or Indicator
#' @description Number of the department
#' @param eq name of equipment or indicator
#' @param code_insee number of department
#' @param data dataframe, it contains the equipment by default
#'
#' @return dataframe, it contains the equipment by default
#' @export
#'
#' @importFrom rlang enquo
#' @importFrom dplyr select mutate filter pull
#' @importFrom stats median
#' @importFrom magrittr %>%
#'
#' @examples


get_info = function(eq, code_insee, data = data_dpt){
  eq <- enquo(eq)
  res <- data %>%
    select(dep, equip = !!eq) %>%
    mutate(equip = as.numeric(equip))
  med <- median(res%>% pull(equip))
  result <- res %>%
    filter(dep == code_insee) %>%
    pull(equip)
  return(c(result, med))
}

?get_info
