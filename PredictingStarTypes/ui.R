# Rachel Keller
# ST 558
# November 18, 2020
# Purpose: To create shiny app for star predictions

# Load in shiny package
library(shiny)
library(plotly)

# Create UI for Star Type Prediction App
shinyUI(
    
    navbarPage("Predicting Star Types",
               
               # Information tab
               tabPanel("Information",
                        
                        titlePanel("Predicting Star Types App"),
                        
                        mainPanel(h3("ST 558 - Rachel Keller"),
                                  
                                  # Description of data set
                                  h3("Description of Data"),
                                  br(),
                                  "The response variable contained in this data set is ",
                                  code("StarType"),
                                  ". The predictors that will be used for our classification models are ",
                                  code("Temperature"),
                                  ", ",
                                  code("Luminosity"),
                                  ", ",
                                  code("Radius"),
                                  ", ",
                                  code("AbsoluteMagnitude"),
                                  ", ",
                                  code("StarColor"),
                                  ", and ",
                                  code("StarClass"),
                                  ". Below is a description of these variables and the units of each variable: ",
                                  tags$ul(tags$li("Absolute Temperature: surface temperature of star (in K)"),
                                     tags$li("Relative Luminosity: luminosity of star with respect to the Sun (in L/Lo)"),
                                     tags$li("Relative Radius: radius of star with respect to the Sun (in R/Ro)"),
                                     tags$li("Absolute Magnitude: absolute visual magnitude of star (in Mv)"),
                                     tags$li("Star Color: color of star using spectral analysis (Blue, Blue-white, White, Yellow-white, Yellow, Orange, Red)"),
                                     tags$li("Spectral Class: spectral class of star (A, B, F, K, M, O)"),
                                     tags$li("Star Type: type of star (Brown Dwarf  = 0, Red Dwarf = 1, White Dwarf = 2, Main Sequence = 3, Supergiant = 4, Hypergiant = 5)")),
                                  "The .csv file used as the data set for this applet can be
                                  obtained from the following link: ",
                                  a("Data", href="https://www.kaggle.com/deepu1109/star-dataset"),
                                  br(),
                                  
                                  # Purpose of the applet
                                  h3("Purpose of App"),
                                  br(),
                                  "This applet is intended to aid the user in classifying stars into one of six types using the values of 
                                  six predictor variables described above. The applet will accomplish this by first focusing on some common
                                  data exploration techniques, in order to get a general sense of some trends or patters in the data. Next,
                                  the user can look at both unsupervised and supervised learning methods. Finally, the user can subset and
                                  export the data if they would like to perform further analysis of their own.",
                                  br(),
                                  
                                  # How to naviagate the applet
                                  h3("How to Navigate"), 
                                  br(),
                                  "This applet contains five pages, which can be navigated to using the tabs towards the very top of the applet. 
                                  Below is a brief description of what the user can find on these tabs.",
                                  tags$ul(tags$li("Information: Current tab containing information on the data used and this applet"),
                                          tags$li("Data Exploration: Obtain common numerical and graphical summaries"),
                                          tags$li("Unsupervised Learning: Examine the clustering method for this data"),
                                          tags$li("Supervised Learning: Examine K-Nearest Neighbors and Classification Tree methods"),
                                          tags$li("Save Data: Subset the data and save the result as a .csv file")),
                                  "Each page contains a side panel where the user can specifiy inputs. Some pages contain action buttons 
                                  that should be clicked on to display outputs, reset input values, or output plots/data.")),
               
               # Data exploration tab
               tabPanel("Data Exploration",
                        
                        sidebarPanel(
                          
                          # Have user select the summary they want  
                          selectInput("sumType", "Select Type of Summary Desired:",
                                        c(" " = " ",
                                          "Numeric" = "num",
                                          "Graphical" = "graph")),
                           
                          # Options for common numeric summaries 
                          conditionalPanel(condition = "input.sumType == `num`",
                                             selectInput("numType", "Select Numeric Summary:",
                                                         c(" " = " ",
                                                           "One Way Contingency Table" = "oneway",
                                                           "Two Way Contingency Table" = "twoway",
                                                           "Five Number Summary" = "fivenum",
                                                           "Correlation" = "cor",
                                                           "Covariance" = "cov"))),
                          
                          # Options for common graphical summaries
                          conditionalPanel(condition = "input.sumType == `graph`",
                                             selectInput("graphType", "Select Graphical Summary:",
                                                         c(" " = " ",
                                                           "Barplot for One Variable" = "onebar",
                                                           "Barplot for Two Variables" = "twobar",
                                                           "Histogram for One Variable" = "onehist",
                                                           "Histogram for Two Variables" = "twohist"))),
                            
                          # Variable options for two way contingency table of categorical variables or bar plot of two categorical variable
                          conditionalPanel(condition = "input.numType == `twoway` || input.graphType == `twobar`",
                                             selectInput("varOneA", "First Variable:",
                                                         c(" " = " ",
                                                           "Star Type" = "StarType",
                                                           "Star Color" = "StarColor",
                                                           "Spectral Class" = "SpectralClass")),
                                             selectInput("varTwoA", "Second Variable:",
                                                         c(" " = " ",
                                                           "Star Type" = "StarType",
                                                           "Star Color" = "StarColor",
                                                           "Spectral Class" = "SpectralClass"))),
                          
                          # Variable options for one way contingency table of one categorical variable or bar plot of one categorical variable   
                          conditionalPanel(condition = "input.numType == `oneway` || input.graphType == `onebar`",
                                             selectInput("varOneB", "Variable:",
                                                         c(" " = " ",
                                                           "Star Type" = "StarType",
                                                           "Star Color" = "StarColor",
                                                           "Spectral Class" = "SpectralClass"))),
                          
                          # Variable options for five number summary for one quantitative variable or histogram for one quantitative variable  
                          conditionalPanel(condition = "input.numType == `fivenum` || input.graphType == `onehist`",
                                             selectInput("varOneC", "Variable:",
                                                         c(" " = " ",
                                                           "Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "AbsoluteMagnitude"))),
                          
                          # Variable options for correlation and covariance of two quantitative variables  
                          conditionalPanel(condition = "input.numType == `cor` || input.numType == `cov`",
                                             selectInput("varOneD", "First Variable:",
                                                         c(" " = " ",
                                                           "Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "AbsoluteMagnitude")),
                                             selectInput("varTwoD", "Second Variable:",
                                                         c(" " = " ",
                                                           "Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "AbsoluteMagnitude"))),
                          
                          # Variable options for histogram of quantitative variable by one categorical variable  
                          conditionalPanel(condition = "input.graphType == `twohist`",
                                             selectInput("varOneE", "First Variable:",
                                                         c(" " = " ",
                                                           "Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "AbsoluteMagnitude")),
                                             selectInput("varTwoE", "Second Variable:",
                                                         c(" " = " ",
                                                           "Star Type" = "StarType",
                                                           "Star Color" = "StarColor",
                                                           "Spectral Class" = "SpectralClass"))),
                            
                            # Buttons for displaying summary and resetting user values
                            actionButton("displaySum", "Click to Display Summary"),
                            actionButton("resetSum", "Click to Create a New Summary")
                            
                        ),
                      
                        mainPanel(
                          
                          h3("Summary Ouput"),
                          
                          # Display numeric or graphical summary depending on user selection
                          conditionalPanel(condition = "input.sumType == `graph`",
                                           plotlyOutput("summarygraphic")),
                          conditionalPanel(condition = "input.sumType == `num`",
                                           verbatimTextOutput("summarynumeric"))
                          
                                  )
                        
                        ),
               
               # Unsupervised learning tab
               tabPanel("Unsupervised Learning",
                        
                        sidebarPanel(
                          
                          # Options for clustering method
                          selectInput("clusteringMethod", "Clustering Method Desired:",
                                      c("K-Means Clustering" = "kmeans",
                                        "Hierarchical Clustering" = "hierarchical")),
                          
                          # Quantiative variable options for kmeans clustering
                          conditionalPanel(condition = "input.clusteringMethod == `kmeans`",
                                           selectInput("varOneF", "First Variable:",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "AbsoluteMagnitude")),
                                           selectInput("varTwoF", "Second Variable:",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "AbsoluteMagnitude"))),
                          
                          #Quantitative variable options for hierarchical clustering
                          conditionalPanel(condition = "input.clusteringMethod == `hierarchical`",
                                           selectInput("varOneG", "First Variable:",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "AbsoluteMagnitude")),
                                           selectInput("varTwoG", "Second Variable:",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "AbsoluteMagnitude")),
                                           
                                           # Option to download dendogram from hierarchical clustering method
                                           downloadButton("downloadPlot", "Download Dendogram"))
                          
                          ),
                        
                        mainPanel(
                          h3("Clustering Output"),
                          
                          # Text output from clustering method and dendogram for hierarchical method
                          verbatimTextOutput("clusterout"),
                                  plotOutput("clusterden"))
                        
                        ),
               
               # Supervised learning tab
               tabPanel("Supervised Learning", 
                        
                        sidebarPanel(
                          
                          # Have user select Knn or Random Forest methods of classification
                          selectInput("modelType", "Supervised Learning Model Desired:",
                                      c("K Nearest Neighbors" = "knn",
                                        "Random Forest" = "randfor")),
                          
                          # Have user select if they would like to select certain variables rather than using all variables in the model
                          checkboxInput("uservalues", "Check box to select model settings, otherwise all variables used as default"),
            
                          # Variable options for Knn
                          conditionalPanel(condition = "input.uservalues == 1 && input.modelType == `knn`",
                                           checkboxGroupInput("variables", "Variables to Include in Model",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "AbsoluteMagnitude",
                                                         "Star Color" = "StarColor",
                                                         "Spectral Class" = "SpectralClass"))
                                           ),
                          
                          # Variable options for random forest
                          conditionalPanel(condition = "input.uservalues == 1 && input.modelType == `randfor`",
                                           
                                           checkboxGroupInput("variables", "Variables to Include in Model",
                                                              c("Temperature" = "Temperature",
                                                                "Luminosity" = "Luminosity",
                                                                "Radius" = "Radius",
                                                                "Absolute Magnitude" = "AbsoluteMagnitude",
                                                                "Star Color" = "StarColor",
                                                                "Spectral Class" = "SpectralClass"))
                                           
                          ),
                          
                          # Have user select if they would like to make a prediction based on the model selected
                          conditionalPanel(condition = "input.uservalues == 1",
                                           checkboxInput("predictValues", "Check box to make prediction based on above model")),
                          
                          # Create inputs for user prediction
                          conditionalPanel(condition = "input.predictValues == 1",
                                           numericInput("tempInput", "Temperature:", 0),
                                           numericInput("lumInput", "Luminosity:", 0),
                                           numericInput("radInput", "Radius:", 0),
                                           numericInput("absmagInput", "Absolute Magnitude:", 0),
                                           selectInput("colorInput", "Star Color:",
                                                       c(" " = " ",
                                                         "Blue" = "Blue",
                                                         "Blue-white" = "Blue-white",
                                                         "Orange" = "Orange",
                                                         "Red" = "Red",
                                                         "White" = "White",
                                                         "Yellow" = "Yellow",
                                                         "Yellow-white" = "Yellow-white")),
                                           selectInput("classInput", "Spectral Class:",
                                                       c(" " = " ",
                                                         "A" = "A",
                                                         "B" = "B",
                                                         "F" = "F",
                                                         "K" = "K",
                                                         "M" = "M",
                                                         "O" = "O")),
                                           actionButton("pred", "Display Prediction"),
                                           actionButton("resetPred", "Click to Create a Prediction")),
                          
                          # Output result of prediction if desired
                          conditionalPanel("input.pred == 1",
                                           verbatimTextOutput("predOut"))
        
                        ),
                        
                        mainPanel(
                          h3("Current Model Specifications"),
                          
                          # Output the formula of the model and the confusion matrix
                          uiOutput("formulaOut"),
                          h3("Confusion Matrix and Accuracy of Model"),
                                  verbatimTextOutput("modelout"))
                        
                        ),
               
               # Save data tab
               tabPanel("Save Data",
                        
                        sidebarPanel(
                          
                          # Have user select if they want to subset data before saving to file
                          selectInput("subset", "Subset Data:",
                                      c("No" = "no",
                                        "Yes" = "yes")),
                          
                          # Variable options for subsetting
                          conditionalPanel(condition = "input.subset == `yes`",
                                           selectInput("subsetVar", "Select Variable to Subset By:",
                                                       c("Star Type" = "StarType",
                                                         "Star Color" = "StarColor",
                                                         "Spectral Class" = "SpectralClass"))
                                          ),
                          
                          # Subsetting options for each variable
                          conditionalPanel(condition = "input.subset == `yes` && input.subsetVar == `StarType`",
                                           selectInput("starTypeOpt", "Values Desired:",
                                                              c("Brown Dwarf" = 0,
                                                                "Red Dwarf" = 1,
                                                                "White Dwarf" = 2,
                                                                "Main Sequence" = 3,
                                                                "Supergiant" = 4,
                                                                "Hypergiant" = 5))),
                          conditionalPanel(condition = "input.subset == `yes` && input.subsetVar == `StarColor`",
                                           selectInput("starColorOpt", "Values Desired:",
                                                              c("Blue" = "Blue",
                                                                "Blue-white" = "Blue-white",
                                                                "Orange" = "Orange",
                                                                "Red" = "Red",
                                                                "White" = "White",
                                                                "Yellow" = "Yellow",
                                                                "Yellow-white" = "Yellow-white"))),
                          conditionalPanel(condition = "input.subset == `yes` && input.subsetVar == `SpectralClass`",
                                           selectInput("starClassOpt", "Values Desired:",
                                                              c("A" = "A",
                                                                "B" = "B",
                                                                "F" = "F",
                                                                "K" = "K",
                                                                "M" = "M",
                                                                "O" = "O"))),
                          
                          # Download data to csv file
                          downloadButton("downloadData", "Download")
                        ),
                        
                        mainPanel(
                          h3("Table of Data"),
                          
                          # Display table of current selections
                          DT::dataTableOutput("starDataset"))
                        
                        )
)
)
