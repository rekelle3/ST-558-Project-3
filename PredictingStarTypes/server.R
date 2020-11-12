library(shiny)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    starData <- read_csv("stars.csv")
    starData$`Star type` <- as.factor(starData$`Star type`)
    
    getData <- reactive({
        if(input$subset == "yes"){
            if(input$subsetVar == "Star type"){
                newStarData <- starData %>% filter(`Star type` == input$starTypeOpt)
            } else if (input$subsetVar == "Star color"){
                newStarData <- starData %>% filter(`Star color` == input$starColorOpt)
            } else {
                newStarData <- starData %>% filter(`Spectral Class` == input$starClassOpt)
            }
        } else {
            newStarData <- starData
        }
    })
    
    output$starDataset <- DT::renderDataTable({
        getData()
    })
    
    output$downloadData <- downloadHandler(
        filename = "starPrediction.csv",
        content = function(file) {
            write.csv(getData(), file, row.names = FALSE)
        }
    )

})
