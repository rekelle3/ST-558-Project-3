library(shiny)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    starData <- read_csv("stars.csv")
    starData$`Star type` <- as.factor(starData$`Star type`)
    
    
    output$summarygraphic <- renderPlot({
            g <- ggplot(starData, aes(x = Temperature))
            g + geom_histogram()
    })
    
    output$summarynumeric <- renderPrint({

        if(input$numType == "oneway"){
            ""
        } else if (input$numType == "twoway"){
            table(starData[[input$varOne]], starData[[input$varTwo]])
        } else if (input$numType == "fivenum"){
            ""
        } else if (input$numType == "cor"){
           cor(starData[[input$varOne]], starData[[input$varTwo]]) 
        } else {
           cov(starData[[input$varOne]], starData[[input$varTwo]]) 
        }
    })
    
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
