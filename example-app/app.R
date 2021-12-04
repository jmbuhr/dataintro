#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(palmerpenguins)
library(tidyverse)
library(glue)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Penguins!"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("species",
                        "Species",
                        unique(penguins$species)),
            downloadButton("downloadButton"),
            textOutput("debug")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("mainPlot"),
            DT::dataTableOutput("mainTable")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$debug <- renderText({
        input$species
    })
    
    filtered_penguins <- reactive({
        penguins %>% 
            filter(species == input$species)
    })

    output$mainPlot <- renderPlot({
        filtered_penguins() %>% 
            ggplot(aes(bill_length_mm, flipper_length_mm)) +
            geom_point() +
            labs(title = glue("Data shown for species: {input$species}"))
    })
    
    output$mainTable <- DT::renderDataTable({
        filtered_penguins()
    })
    
    output$downloadButton <- downloadHandler(
        filename = function() {
            paste("data-", Sys.Date(), ".csv", sep = "")
        },
        content = function(file) {
            write.csv(filtered_penguins(), file)
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
