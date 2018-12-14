#' Shinny app UI
#'
#' @return shinyapp UI
#' @export
#' @import shiny

#' @importFrom leaflet leafletOutput
#' @importFrom utils read.csv
#' @examples

eq_per_category <- read.csv("inst/extdata/eq_per_category.csv")
data_dpt <- read.csv("./inst/extdata/equipment_final.csv")
departments_shp <- rgdal::readOGR("./inst/extdata/departements-20140306-100m.shp")

shinnyappUI <-fluidPage(navbarPage("Menu",
                                   tabPanel("Affichage",
                                            sidebarLayout(
                                              sidebarPanel(
                                                selectInput("category",label = "category :" ,choices = eq_per_category$cat,selected = NULL),
                                                selectInput( "Equipement_name",label = "Equipement :" ,choices = names(data_dpt)[-c(1, 2)],selected = NULL),
                                                actionButton("Print", "Go")

                                              ),
                                              mainPanel(
                                                leafletOutput("mymap")
                                              )
                                            )
                                   ),
                                   tabPanel("Advise",
                                            sidebarLayout(
                                              sidebarPanel(
                                                #radioButtons("Year",label = "Year", choices = c("2012", "2017")),
                                                #par d??faut, liste de tous les ??quipements de toutes les cat??gories
                                                selectInput("prediction_advise",label = "prediction :" ,choices = c("pauvrete", "Niveau_de_vie","crime_rate"),selected = NULL),
                                                #checkboxGroupInput( "predictors",label = "predictors :" ,choices = names(tot)[-c(1, 2)],selected = names(tot)[-c(1, 2)]),
                                                actionButton("Print3", "Go")
                                              ),
                                              mainPanel(
                                                dataTableOutput("myadvise"),
                                                leafletOutput("map_indic")
                                              )
                                            )
                                   ),
                                   tabPanel("Prediction",
                                            sidebarLayout(
                                              sidebarPanel(
                                                width = 12,
                                                #radioButtons("Year",label = "Year", choices = c("2012", "2017")),
                                                #par d??faut, liste de tous les ??quipements de toutes les cat??gories
                                                selectInput("prediction",label = "prediction :" ,choices = c("pauvrete", "Niveau_de_vie","crime_rate"),selected = NULL),
                                                fluidRow(
                                                  column(
                                                    width = 4,
                                                    checkboxGroupInput( "predictors1",label = "Justice :" ,choices = eq_per_category %>% filter(cat=="Justice") %>% pull(eq),selected = eq_per_category$eq),
                                                    checkboxGroupInput( "predictors2",label = "Transport :" ,choices = eq_per_category %>% filter(cat=="Transport") %>% pull(eq),selected = eq_per_category$eq),
                                                    checkboxGroupInput( "predictors7",label = "Global :" ,choices = eq_per_category %>% filter(cat=="Global") %>% pull(eq),selected = eq_per_category$eq),
                                                  ),
                                                  column(
                                                    width = 4,
                                                    checkboxGroupInput( "predictors3",label = "Healthcare :" ,choices = eq_per_category %>% filter(cat=="Healthcare") %>% pull(eq),selected = eq_per_category$eq),
                                                    checkboxGroupInput( "predictors4",label = "Education :" ,choices = eq_per_category %>% filter(cat=="Education") %>% pull(eq),selected = eq_per_category$eq),
                                                    actionButton("Print2", "Go"))
                                                  ),
                                                  column(
                                                    width = 4,
                                                    checkboxGroupInput( "predictors5",label = "Sport :" ,choices = eq_per_category %>% filter(cat=="Sport") %>% pull(eq),selected = eq_per_category$eq),
                                                    checkboxGroupInput( "predictors6",label = "Divers :" ,choices = eq_per_category %>% filter(cat=="Divers") %>% pull(eq),selected = eq_per_category$eq)
                                                  ),
                                              ),
                                              mainPanel(
                                                leafletOutput("mypred")
                                              )
                                            )
                                   ),
                                   navbarMenu("More",
                                              tabPanel("Table"),
                                              tabPanel("About")
                                   )
)
)
