#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinydashboard)
#install.packages("shinythemes")
library(shinythemes)

#Esta parte es el análogo al ui.R
ui <- 
    
    fluidPage(
        
        dashboardPage(skin = "purple",
            
            dashboardHeader(title = "PostWork8"),
            
            dashboardSidebar(
                
                sidebarMenu(
                    menuItem("Grafica de Barras", tabName = "Barras", icon = icon("bar-chart-o")),
                    menuItem("Graficas de Postwork3", tabName = "PW3", icon = icon("area-chart")),
                    menuItem("Match Data - DataTable", tabName = "data_table", icon = icon("table")),
                    menuItem("Factores de Ganancia", tabName = "Fact", icon = icon("line-chart"))
                )
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                    # Histograma
                    tabItem(tabName = "Barras",
                            fluidRow(
                                box(width = NULL, height = NULL,
                                titlePanel("Grafica de Barras de Goles en contra y a favor"), 
                                selectInput("variable", "Seleccione el valor de X",
                                            choices = c("home.score","away.score")),
                                plotOutput("output_plot")
                                )
                            )
                    ),
                    
                    # Dispersión
                    tabItem(tabName = "PW3", 
                            fluidRow(
                                box(width = NULL, height = NULL,
                                titlePanel(h3("Gráficos obtenidos en Postwork3")),
                                img(src = "Barras.png", height = 450, width = 650),
                                img(src =  "ProbConjunta.png", height = 450, width = 650)
                                )
                            )
                    ),
                    
                    
                    
                    tabItem(tabName = "data_table",
                            fluidRow(
                                box(width = NULL, height = NULL,
                                titlePanel(h3("Match Data")),
                                dataTableOutput ("dataTable")
                                )
                            )
                    ), 
                    
                    tabItem(tabName = "Fact",
                            fluidRow(
                                box(width = NULL, height = NULL,
                                titlePanel(h3("Factores de Ganancia")),
                                h4("Factor de Ganancia Maximos:"),
                                img(src = "Escenario_MomiosMax.png", height = 450, width = 750),
                                h4("Factor de Ganancia Promedios:"),
                                img(src = "Momios_Promedio.png", height = 450, width = 750)
                                )
                            )
                    )
                    
                )
            )
        )
    )

#De aquí en adelante es la parte que corresponde al server

server <- function(input, output) {
    library(ggplot2)
    setwd("C:/DataScienceBEDU/Sesion08/Postwork08")
    data <- read.csv("data/match.data.csv")
    
    
    output$output_plot <- renderPlot({
        ggplot(data, aes_string(x = input$variable)) +
            geom_bar() +
            facet_wrap(as.factor(data$away.team))+
            ggtitle("Goles a favor y en contra")}, width = "auto" 
    )
    
    output$dataTable <- renderDataTable({data},options = list(aLengthMenu = c(10,20,50), iDisplayLength = 20))
    
}


shinyApp(ui, server)

