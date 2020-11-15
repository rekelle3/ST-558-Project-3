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
                          
                            selectInput("sumType", "Type of Summary Desired:",
                                        c(" " = " ",
                                          "Numeric" = "num",
                                          "Graphical" = "graph")),
                            
                            conditionalPanel(condition = "input.sumType == `num`",
                                             selectInput("numType", "Type of Numeric Summary Desired:",
                                                         c(" " = " ",
                                                           "One Way Contingency Table" = "oneway",
                                                           "Two Way Contingency Table" = "twoway",
                                                           "Five Number Summary" = "fivenum",
                                                           "Correlation" = "cor",
                                                           "Covariance" = "cov"))),
                            
                            conditionalPanel(condition = "input.sumType == `graph`",
                                             selectInput("graphType", "Type of Graphical Summary Desired:",
                                                         c(" " = " ",
                                                           "Barplot for One Variable" = "onebar",
                                                           "Barplot for Two Variables" = "twobar",
                                                           "Histogram for One Variable" = "onehist",
                                                           "Histogram for Two Variables" = "twohist"))),
                            
                            conditionalPanel(condition = "input.numType == `twoway` || input.graphType == `twobar`",
                                             selectInput("varOneA", "First Variable:",
                                                         c("Star Type" = "Star type",
                                                           "Star Color" = "Star color",
                                                           "Spectral Class" = "Spectral Class")),
                                             selectInput("varTwoA", "Second Variable:",
                                                         c("Star Type" = "Star type",
                                                           "Star Color" = "Star color",
                                                           "Spectral Class" = "Spectral Class"))),
                            
                            conditionalPanel(condition = "input.numType == `oneway` || input.graphType == `onebar`",
                                             selectInput("varOneB", "First Variable:",
                                                         c("Star Type" = "Star type",
                                                           "Star Color" = "Star color",
                                                           "Spectral Class" = "Spectral Class"))),
                            
                            conditionalPanel(condition = "input.numType == `fivenum` || input.graphType == `onehist`",
                                             selectInput("varOneC", "First Variable:",
                                                         c("Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "Absolute magnitude"))),
                            
                            conditionalPanel(condition = "input.numType == `cor` || input.numType == `cov`",
                                             selectInput("varOneD", "First Variable:",
                                                         c("Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "Absolute magnitude")),
                                             selectInput("varTwoD", "Second Variable:",
                                                         c("Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "Absolute magnitude"))),
                            
                            conditionalPanel(condition = "input.graphType == `twohist`",
                                             selectInput("varOneE", "First Variable:",
                                                         c("Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "Absolute magnitude")),
                                             selectInput("varTwoE", "Second Variable:",
                                                         c("Star Type" = "Star type",
                                                           "Star Color" = "Star color",
                                                           "Spectral Class" = "Spectral Class")))
                            
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
                                                         "Absolute Magnitude" = "Absolute magnitude")),
                                           
                                           selectInput("varTwoF", "Second Variable:",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "Absolute magnitude"))),
                          
                          conditionalPanel(condition = "input.clusteringMethod == `hierarchical`")
                          
                          ),
                        
                        mainPanel(verbatimTextOutput("clusterout")
                          
                        )
                        
                        ),
               tabPanel("Modeling", 
                        
                        sidebarPanel(
                          
                          selectInput("modelType", "Supervised Learning Model Desired:",
                                      c("Multiple Linear Regression" = "multlinreg",
                                        "Random Forest" = "randfor")),
                          
                          checkboxInput("uservalues", "Check box to select model settings"),
                          
                          conditionalPanel(condition = "input.uservalues == 1 && input.modelType == `multlinreg`",
                                           
                                           checkboxGroupInput("variables", "Variables to Include in Model",
                                                       c("Temperature" = "Temperature",
                                                         "Luminosity" = "Luminosity",
                                                         "Radius" = "Radius",
                                                         "Absolute Magnitude" = "Absolute magnitude",
                                                         "Star Color" = "Star color",
                                                         "Spectral Class" = "Spectral Class"))
                                           
                                           ),
                          
                          conditionalPanel(condition = "input.uservalues == 1 && input.modelType == `randfor`",
                                           
                                           checkboxGroupInput("variables", "Variables to Include in Model",
                                                              c("Temperature" = "Temperature",
                                                                "Luminosity" = "Luminosity",
                                                                "Radius" = "Radius",
                                                                "Absolute Magnitude" = "Absolute magnitude",
                                                                "Stary Color" = "Star color",
                                                                "Spectral Class" = "Spectral Class"))
                                           
                          )
        
                        )
                        
                        ),
               tabPanel("Save Data",
                        
                        sidebarPanel(
                          
                          selectInput("subset", "Subset Data:",
                                      c("No" = "no",
                                        "Yes" = "yes")),
                          
                          conditionalPanel(condition = "input.subset == `yes`",
                                           selectInput("subsetVar", "Select Variable to Subset By:",
                                                       c("Star Type" = "Star type",
                                                         "Star Color" = "Star color",
                                                         "Spectral Class" = "Spectral Class"))
                                          ),
                          
                          conditionalPanel(condition = "input.subset == `yes` && input.subsetVar == `Star type`",
                                           selectInput("starTypeOpt", "Values Desired:",
                                                              c("Brown Dwarf" = 0,
                                                                "Red Dwarf" = 1,
                                                                "White Dwarf" = 2,
                                                                "Main Sequence" = 3,
                                                                "Supergiant" = 4,
                                                                "Hypergiant" = 5))),
                          
                          conditionalPanel(condition = "input.subset == `yes` && input.subsetVar == `Star color`",
                                           selectInput("starColorOpt", "Values Desired:",
                                                              c("Blue" = "Blue",
                                                                "Blue-white" = "Blue-white",
                                                                "Orange" = "Orange",
                                                                "Red" = "Red",
                                                                "White" = "White",
                                                                "Yellow" = "Yellow",
                                                                "Yellow-white" = "Yellow-white"))),
                          
                          conditionalPanel(condition = "input.subset == `yes` && input.subsetVar == `Spectral Class`",
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
