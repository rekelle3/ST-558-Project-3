library(shiny)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    starData <- read_csv("stars.csv")
    starData$`Star type` <- as.factor(starData$`Star type`)
    
    output$summarynumeric <- renderPrint({

        if(input$numType == "oneway"){
            table(starData[[input$varOneB]])
        } else if (input$numType == "twoway"){
            table(starData[[input$varOneA]], starData[[input$varTwoA]])
        } else if (input$numType == "fivenum"){
            summary(starData[[input$varOneC]])
        } else if (input$numType == "cor"){
           cor(starData[[input$varOneD]], starData[[input$varTwoD]]) 
        } else {
           cov(starData[[input$varOneD]], starData[[input$varTwoD]]) 
        }
    })
    
    output$summarygraphic <- renderPlot({
        
        if(input$graphType == "onebar"){
            g <- ggplot(starData, aes(x = starData[[input$varOneB]]))
            g + geom_bar()
        } else if(input$graphType == "twobar"){
            g <- ggplot(starData, aes(x = starData[[input$varOneA]], fill = starData[[input$varTwoA]]))
            g + geom_bar()
        } else if(input$graphType == "onehist"){
            g <- ggplot(starData, aes(x = starData[[input$varOneC]]))
            g + geom_histogram()
        } else {
            g <- ggplot(starData, aes(x = starData[[input$varOneE]], fill = starData[[input$varTwoE]]))
            g + geom_histogram()
        }
        
    })
    
    output$clusterout <- renderPrint({
        
        set.seed(1)
        starCluster <- kmeans(starData[, c(input$varOneF, input$varTwoF)], 6, nstart = 40)
        starCluster
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
