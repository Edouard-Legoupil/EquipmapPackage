#Depends 3.5.1 changed to 3.5

usethis::use_vignette("comment-utiliser-mon-package")
file.create("R/map_density.R")

remotes::install_github("ThinkR-open/attachment")
attachment::att_to_description()

getwd()
devtools::install_github("equimapackage")

file.create("R/zzz.R")

#library tidyverse for the server

usethis::use_package("rgdal")
usethis::use_pipe()
devtools::document()

install.packages(c("dplyr", "leaflet", "rgdal", "utils", "magrittr", "stats", "devtools","roxygen2", "usethis","testthat","knitr"))
