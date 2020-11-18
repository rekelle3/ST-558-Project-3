# Rachel Keller
# ST 558
# November 18, 2020
# Purpose: To create shiny app for star predictions

# Load in packages
library(shiny)
library(tidyverse)
library(caret)
library(mathjaxr)
library(plotly)

# Define server logic required for Star Type Prediction app
shinyServer(function(input, output, session) {

    # Read in data from csv file
    starData <- read_csv("stars.csv")
    starData$`StarType` <- as.factor(starData$`StarType`)
    
# Output for numeric summaries    
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
    
    # Output for graphical summaries and include plotly functionality
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

# Reset user values in data exploration tab
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

# Create reactive object that delivers the desired cluster
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
    
    # Print output from clustering to cluster tab
    output$clusterout <- renderPrint({
        getCluster()
    })
    
    # Print dendogram output from hierarchical clustering to clustering tab
    output$clusterden <- renderPlot({
        if(input$clusteringMethod == "hierarchical"){
            plot(getCluster())
        } 
    })
    
    # Output dendogram as png if user clicks action button
    output$downloadPlot <- downloadHandler(
        filename = "dendogram.png",
        content = function(file) {
            png(file)
            plot(getCluster())
            dev.off()
        }
    )
    
    # In preparation for supervised learning, create our training and test split
    set.seed(1)
    train <- sample(1:nrow(starData), size = nrow(starData)*0.8)
    test <- dplyr::setdiff(1:nrow(starData), train)
    starDataTrain <- starData[train, ]
    starDataTest <- starData[test, ]
    
    # Reactive object to return the current model formula using the user inputs
    getFormula <- eventReactive(
        input$variables,
        {
        as.formula(paste0("StarType ~ ",paste0(input$variables, collapse="+")))
    })
    
    # Reactive object to return model object if user specifices variables, or doesn't (and also which learning method they select)
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
    
    # Output model formula as mathjax output
    output$formulaOut <- renderUI({
        if(input$uservalues == 1){
            withMathJax(paste0("StarType ~ ",paste0(input$variables, collapse="+")))
        } else {
            "StarType ~ ."
        }
    })
    
    # Print confusion matrix for current model specifications
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
    
    # Create prediction value based on user input values
    output$predOut <- renderPrint({
        predict(getModel(), data.frame(Temperature = input$tempInput, Luminosity = input$lumInput, Radius = input$radInput, AbsoluteMagnitude = input$absmagInput, StarColor = input$colorInput, SpectralClass = input$classInput))
    })
    
    # Reset prediction values when action button pressed by user
    observeEvent(input$resetPred, {
        updateNumericInput(session, "tempInput", value = 0)
        updateNumericInput(session, "lumInput", value = 0)
        updateNumericInput(session, "radInput", value = 0)
        updateNumericInput(session, "absmagInput", value = 0)
        updateSelectInput(session, "colorInput", selected = " ")
        updateSelectInput(session, "classInput", selected = " ")
    })
    
    # Subset data based on user input
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
    
    # Output data as data table
    output$starDataset <- DT::renderDataTable({
        getData()
    })
    
    # Output data to csv file
    output$downloadData <- downloadHandler(
        filename = "starPrediction.csv",
        content = function(file) {
            write.csv(getData(), file, row.names = FALSE)
        }
    )
})
