library(shiny)

shinyUI(
    
    navbarPage("Predicting Star Types",
               
               tabPanel("Information",
                        
                        titlePanel("Predicting Star Types App"),
                        
                        mainPanel("Description of Data",
                                  br(),
                                  "Purpose of App",
                                  br(),
                                  "How to Navigate")),
               
               tabPanel("Data Exploration",
                        
                        sidebarPanel(
                          
                            selectInput("sumType", "Select Type of Summary Desired:",
                                        c(" " = " ",
                                          "Numeric" = "num",
                                          "Graphical" = "graph")),
                            
                            conditionalPanel(condition = "input.sumType == `num`",
                                             selectInput("numType", "Select Numeric Summary:",
                                                         c(" " = " ",
                                                           "One Way Contingency Table" = "oneway",
                                                           "Two Way Contingency Table" = "twoway",
                                                           "Five Number Summary" = "fivenum",
                                                           "Correlation" = "cor",
                                                           "Covariance" = "cov"))),
                            
                            conditionalPanel(condition = "input.sumType == `graph`",
                                             selectInput("graphType", "Select Graphical Summary:",
                                                         c(" " = " ",
                                                           "Barplot for One Variable" = "onebar",
                                                           "Barplot for Two Variables" = "twobar",
                                                           "Histogram for One Variable" = "onehist",
                                                           "Histogram for Two Variables" = "twohist"))),
                            
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
                            
                            conditionalPanel(condition = "input.numType == `oneway` || input.graphType == `onebar`",
                                             selectInput("varOneB", "Variable:",
                                                         c(" " = " ",
                                                           "Star Type" = "StarType",
                                                           "Star Color" = "StarColor",
                                                           "Spectral Class" = "SpectralClass"))),
                            
                            conditionalPanel(condition = "input.numType == `fivenum` || input.graphType == `onehist`",
                                             selectInput("varOneC", "Variable:",
                                                         c(" " = " ",
                                                           "Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "AbsoluteMagnitude"))),
                            
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
                            
                            actionButton("displaySum", "Click to Display Summary"),
                            actionButton("resetSum", "Click to Create a New Summary")
                            
                        ),
                      
                        mainPanel(
                          
                          conditionalPanel(condition = "input.sumType == `graph`",
                                           plotOutput("summarygraphic")),
                          
                          conditionalPanel(condition = "input.sumType == `num`",
                                           verbatimTextOutput("summarynumeric"))
                          
                                  )
                        
                        ),
               tabPanel("Clustering",
                        
                        sidebarPanel(
                          
                          selectInput("clusteringMethod", "Clustering Method Desired:",
                                      c("K-Means Clustering" = "kmeans",
                                        "Hierarchical Clustering" = "hierarchical")),
                          
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
                                                         "Absolute Magnitude" = "AbsoluteMagnitude")))
                          
                          ),
                        
                        mainPanel(verbatimTextOutput("clusterout"),
                                  plotOutput("clusterden"))
                        
                        ),
               tabPanel("Modeling", 
                        
                        sidebarPanel(
                          
                          selectInput("modelType", "Supervised Learning Model Desired:",
                                      c("K Nearest Neighbors" = "knn",
                                        "Random Forest" = "randfor")),
                          
                          checkboxInput("uservalues", "Check box to select model settings"),
            
                          
                          conditionalPanel(condition = "input.uservalues == 1 && input.modelType == `knn`",
                                           
                                           checkboxGroupInput("variables", "Variables to Include in Model",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "AbsoluteMagnitude",
                                                         "Star Color" = "StarColor",
                                                         "Spectral Class" = "SpectralClass"))
                                           
                                           ),
                          
                          conditionalPanel(condition = "input.uservalues == 1 && input.modelType == `randfor`",
                                           
                                           checkboxGroupInput("variables", "Variables to Include in Model",
                                                              c("Temperature" = "Temperature",
                                                                "Luminosity" = "Luminosity",
                                                                "Radius" = "Radius",
                                                                "Absolute Magnitude" = "AbsoluteMagnitude",
                                                                "Star Color" = "StarColor",
                                                                "Spectral Class" = "SpectralClass"))
                                           
                          ),
                          
                          conditionalPanel(condition = "input.uservalues == 1",
                                           checkboxInput("predictValues", "Check box to make prediction based on above model")),
                          
                          conditionalPanel(condition = "input.predictValues == 1",
                                           numericInput("tempInput", "Temperature:", 0),
                                           numericInput("lumInput", "Luminosity:", 0),
                                           numericInput("radInput", "Radius:", 0),
                                           numericInput("absmagInput", "Absolute Magnitude:", 0),
                                           selectInput("colorInput", "Star Color:",
                                                       c("Blue" = "Blue",
                                                         "Blue-white" = "Blue-white",
                                                         "Orange" = "Orange",
                                                         "Red" = "Red",
                                                         "White" = "White",
                                                         "Yellow" = "Yellow",
                                                         "Yellow-white" = "Yellow-white")),
                                           selectInput("classInput", "Spectral Class:",
                                                       c("A" = "A",
                                                         "B" = "B",
                                                         "F" = "F",
                                                         "K" = "K",
                                                         "M" = "M",
                                                         "O" = "O")),
                                           actionButton("pred", "Display Prediction"))
        
                        ),
                        
                        mainPanel(verbatimTextOutput("modelout"))
                        
                        ),
               tabPanel("Save Data",
                        
                        sidebarPanel(
                          
                          selectInput("subset", "Subset Data:",
                                      c("No" = "no",
                                        "Yes" = "yes")),
                          
                          conditionalPanel(condition = "input.subset == `yes`",
                                           selectInput("subsetVar", "Select Variable to Subset By:",
                                                       c("Star Type" = "StarType",
                                                         "Star Color" = "StarColor",
                                                         "Spectral Class" = "SpectralClass"))
                                          ),
                          
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
                          
                          downloadButton("downloadData", "Download")
                        ),
                        
                        mainPanel(DT::dataTableOutput("starDataset"))
                        
                        )
)
)
