#' Shinny app UI
#'
#' @return shinyapp UI
#' @export
#' @import shiny
#' @importFrom leaflet leafletOutput
#' @importFrom utils read.csv

eq_per_category <- read.csv("inst/extdata/eq_per_category.csv")
data_dpt <- read.csv("./inst/extdata/equipment_final.csv")
departments_shp <- rgdal::readOGR("./inst/extdata/departements-20140306-100m.shp")

shinnyappUI <-fluidPage(navbarPage("Menu",
                                   tabPanel("Homepage",mainPanel( width = 12,
                                           h3(strong("Welcome to Equipmap"), align = "center"),
                                           h4("We have 3 tabs. They are"),
                                           h4(" 1/ Visualise"),
                                           h4(" 2/ Explore"),
                                           h4(" 3/ Advise"),
                                           h4(""),
                                           h4("This package aims to visualise and analyse INSEE data about equipment levels, demographics, and economic indexes
                                              in France to propose action plans for public spending orientation. The objective is to shed light on potential
                                              interactions between complicated economic indexes and equipment levels, which could help orientate public
                                              spending towards certain equipment spending and in certain departments. "),
                                           h4(strong("First, the equipment level tab:")),
                                           h4("This tab displays the level of equipment per capita per department with a color scale. The reder the region
                                              the more critical the level of equipment relatively to the concentration of population in this region. The user
                                              can filter by category of equipment among five categories: Education, Health, Transport, Justice and Sports.
                                              Inside these categories, the user need to choose an equipment he is interested in."),
                                           h4(""),
                                           h4(strong("Second, the prediction tab:")),
                                           h4("The goal of this tab is to get an idea of which specific equipments influence indexes such as poverty level,
                                              quality of life or crime rate. The user chooses one of these three indexes and then ticks some equipments.
                                              The map displays an error of prediction of the index chosen. The redder the region the least accurate the
                                              prediction, meaning that the equipments ticked are not good predictors and do not have such an influence on the index.The user can select an indicator among poverty, quality of life and crime rate to get the best linear model
                                              to predict the index considered. This way the user can see which equipments influence the most these indexes.
                                              The map displays the level of the index given by the INSEE for each department."),
                                           h4(""),
                                           h4(strong("Third, the advise tab:")),
                                           h4("The user can select an indicator among poverty, quality of life and crime rate to get the best linear model
                                              to predict the index considered. This way the user can see which equipments influence the most these indexes.
                                              The map displays the level of the index given by the INSEE for each department.")
                                           )
                                   ),

                                   tabPanel("Visualise",
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
                                   tabPanel("Explore",
                                            width = 12,
                                            fluidRow(
                                              selectInput("prediction",label = "prediction :" ,choices = c("pauvrete", "Niveau_de_vie","crime_rate"),selected = NULL)
                                            ),
                                            fluidRow(
                                              column(
                                                width = 4,
                                                checkboxGroupInput( "predictors1",label = "Justice :" ,choices = eq_per_category %>% filter(cat=="Justice") %>% pull(eq),selected = NULL),
                                                checkboxGroupInput( "predictors2",label = "Transport :" ,choices = eq_per_category %>% filter(cat=="Transport") %>% pull(eq),selected = "Taxi"),
                                                checkboxGroupInput( "predictors7",label = "Global :" ,choices = eq_per_category %>% filter(cat=="Global") %>% pull(eq),selected = NULL)
                                              ),
                                              column(
                                                width = 4,
                                                checkboxGroupInput( "predictors3",label = "Healthcare :" ,choices = eq_per_category %>% filter(cat=="Healthcare") %>% pull(eq),selected = NULL),
                                                checkboxGroupInput( "predictors4",label = "Education :" ,choices = eq_per_category %>% filter(cat=="Education") %>% pull(eq),selected = NULL)
                                              ),
                                              column(
                                                width = 4,
                                                checkboxGroupInput( "predictors5",label = "Sport :" ,choices = eq_per_category %>% filter(cat=="Sport") %>% pull(eq),selected = NULL),
                                                checkboxGroupInput( "predictors6",label = "Divers :" ,choices = eq_per_category %>% filter(cat=="Divers") %>% pull(eq),selected = NULL)
                                              )
                                            ),
                                            fluidRow(
                                              column(width = 4, offset =5 ,actionButton("Print2", "Go"))
                                            ),
                                            fluidRow(
                                              leafletOutput("mypred")
                                            ),
                                            fluidRow()
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
                                                leafletOutput("map_indic"),
                                                dataTableOutput("myadvise")
                                              )
                                            )
                                   )

)
)
