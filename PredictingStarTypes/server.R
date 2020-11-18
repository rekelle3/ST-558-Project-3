library(shiny)
library(tidyverse)
library(caret)
library(mathjaxr)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    starData <- read_csv("stars.csv")
    starData$`StarType` <- as.factor(starData$`StarType`)
    
    
observeEvent(input$displaySum, {
    
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
    
    output$summarygraphic <- renderPlotly({
        
        if(input$graphType == "onebar"){
            g <- ggplot(starData, aes(x = starData[[input$varOneB]]))
            graph <- g + geom_bar() + labs(x = input$varOneB, title = paste0("Barplot of ", input$varOneB))
            ggplotly(graph)
        } else if(input$graphType == "twobar"){
            g <- ggplot(starData, aes(x = starData[[input$varOneA]], fill = starData[[input$varTwoA]]))
            graph <- g + geom_bar(position = "dodge") + labs(x = input$varOneA, fill = input$varTwoA, title = paste0("Barplot of ", input$varOneA, " and ", input$varTwoA))
            ggplotly(graph)
        } else if(input$graphType == "onehist"){
            g <- ggplot(starData, aes(x = starData[[input$varOneC]]))
            graph <- g + geom_histogram() + labs(x = input$varOneC, title = paste0("Histogram of ", input$varOneC))
            ggplotly(graph)
        } else {
            g <- ggplot(starData, aes(x = starData[[input$varOneE]], fill = starData[[input$varTwoE]]))
            graph <- g + geom_histogram() + labs(x = input$varOneE, fill = input$varTwoE, title = paste0("Histogram of ", input$varOneE, " and ", input$varTwoE))
            ggplotly(graph)
        }
        
    })
    
})

observeEvent(input$resetSum, {
    
    updateSelectInput(session, "sumType", selected = " ")
    updateSelectInput(session, "numType", selected = " ")
    updateSelectInput(session, "graphType", selected = " ")
    updateSelectInput(session, "varOneA", selected = " ")
    updateSelectInput(session, "varTwoA", selected = " ")
    updateSelectInput(session, "varOneB", selected = " ")
    updateSelectInput(session, "varOneC", selected = " ")
    updateSelectInput(session, "varOneD", selected = " ")
    updateSelectInput(session, "varTwoD", selected = " ")
    updateSelectInput(session, "varOneE", selected = " ")
    updateSelectInput(session, "varTwoE", selected = " ")
    
})


getCluster <- reactive({
    if(input$clusteringMethod == "kmeans"){
        set.seed(1)
        starCluster <- kmeans(starData[, c(input$varOneF, input$varTwoF)], 6, nstart = 40)
        starCluster 
    } else {
        set.seed(1)
        starCluster <- hclust(dist(starData[, c(input$varOneG, input$varTwoG)]))
        starCluster
    }
})
    
    
    output$clusterout <- renderPrint({
        getCluster()
    })
    
    
    output$clusterden <- renderPlot({
        if(input$clusteringMethod == "hierarchical"){
            plot(getCluster())
        } 
    })
    
    output$downloadPlot <- downloadHandler(
        filename = "dendogram.png",
        content = function(file) {
            png(file)
            plot(getCluster())
            dev.off()
        }
    )
    
    set.seed(1)
    train <- sample(1:nrow(starData), size = nrow(starData)*0.8)
    test <- dplyr::setdiff(1:nrow(starData), train)
    starDataTrain <- starData[train, ]
    starDataTest <- starData[test, ]
    
    getFormula <- eventReactive(
        input$variables,
        {
        as.formula(paste0("StarType ~ ",paste0(input$variables, collapse="+")))
    })
    
    getModel <- reactive({
        if(input$uservalues == 1){
            if(input$modelType == "knn"){
                knnFit <- train(getFormula(), data = starDataTrain,
                                method = "knn",
                                trControl = trainControl(method = "repeatedcv", repeats = 3),
                                preProcess = c("center", "scale"))
            } else {
                rfFit <- train(getFormula(), data = starDataTrain,
                               method = "rf",
                               trControl = trainControl(method = "repeatedcv", repeats = 3),
                               preProcess = c("center", "scale"))
            }
        } else {
            if(input$modelType == "knn"){
                knnFit <- train(StarType ~ ., data = starDataTrain,
                                method = "knn",
                                trControl = trainControl(method = "repeatedcv", repeats = 3),
                                preProcess = c("center", "scale"))
            } else {
                rfFit <- train(StarType ~ ., data = starDataTrain,
                               method = "rf",
                               trControl = trainControl(method = "repeatedcv", repeats = 3),
                               preProcess = c("center", "scale"))
            }
        } 
    })
    
    output$formulaOut <- renderUI({
        if(input$uservalues == 1){
            withMathJax(paste0("StarType ~ ",paste0(input$variables, collapse="+")))
        } else {
            "StarType ~ ."
        }
        
    })
    
    output$modelout <- renderPrint({
        
        if(input$uservalues == 1){
            
            if(input$modelType == "knn"){
                pred <- predict(getModel(), newdata = starDataTest)
                confusionMatrix(pred, starDataTest$`StarType`)
                
            } else {
                pred <- predict(getModel(), newdata = starDataTest)
                confusionMatrix(pred, starDataTest$`StarType`)
            }
        } else{
            if(input$modelType == "knn"){
                
                pred <- predict(getModel(), newdata = starDataTest)
                confusionMatrix(pred, starDataTest$`StarType`)
                
            } else {
                pred <- predict(getModel(), newdata = starDataTest)
                confusionMatrix(pred, starDataTest$`StarType`)
            }
        }
        
    })
    
    output$predOut <- renderPrint({
        predict(getModel(), data.frame(Temperature = input$tempInput, Luminosity = input$lumInput, Radius = input$radInput, AbsoluteMagnitude = input$absmagInput, StarColor = input$colorInput, SpectralClass = input$classInput))
    })
    
    observeEvent(input$resetPred, {
        
        updateNumericInput(session, "tempInput", value = 0)
        updateNumericInput(session, "lumInput", value = 0)
        updateNumericInput(session, "radInput", value = 0)
        updateNumericInput(session, "absmagInput", value = 0)
        updateSelectInput(session, "colorInput", selected = " ")
        updateSelectInput(session, "classInput", selected = " ")
        
    })
    
    getData <- reactive({
        if(input$subset == "yes"){
            if(input$subsetVar == "StarType"){
                newStarData <- starData %>% filter(`StarType` == input$starTypeOpt)
            } else if (input$subsetVar == "Star color"){
                newStarData <- starData %>% filter(`StarColor` == input$starColorOpt)
            } else {
                newStarData <- starData %>% filter(`SpectralClass` == input$starClassOpt)
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
