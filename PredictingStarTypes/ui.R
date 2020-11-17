library(shiny)

shinyUI(
    
    navbarPage("Predicting Star Types",
               
               tabPanel("Information",
                        
                        titlePanel("Predicting Star Types App"),
                        
                        mainPanel(h3("ST 558 - Rachel Keller"),
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
                                  "The .csv file read in as the data set for this applet can be
                                  obtained from the following link: ",
                                  a("Data", href="https://www.kaggle.com/deepu1109/star-dataset"),
                                  br(),
                                  h3("Purpose of App"),
                                  br(),
                                  "This applet is intended to aid the user in classifying stars into one of six types using the values of 
                                  six predictor variables described above. The applet will accomplish this by first focusing on some common
                                  data exploration techniques, in order to get a general sense of some trends or patters in the data. Next,
                                  the user can look at both unsupervised and supervised learning methods. Finally, the user can subset and
                                  export the data if they would like to perform further analysis of their own.",
                                  br(),
                                  h3("How to Navigate"), 
                                  br(),
                                  "This applet contains five pages, which can be navigated to using the tabs towards the very top of the applet. 
                                  Below is a brief description of what the user can find on these tabs.",
                                  tags$ul(tags$li("Information: Current tab containing information on the data used and this applet"),
                                          tags$li("Data Exploration: Obtain common numerical and graphical summaries"),
                                          tags$li("Unsupervised Learning: Examine the clustering method for this data"),
                                          tags$li("Supervised Learning: Examine K-Nearest Neighbors and Classification Tree methods"),
                                          tags$li("Save Data: Subset the data and save the result as a .csv file")))),
               
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
               tabPanel("Unsupervised Learning",
                        
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
               tabPanel("Supervised Learning", 
                        
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
                                           actionButton("pred", "Display Prediction")),
                          
                          conditionalPanel("input.pred == 1",
                                           verbatimTextOutput("predOut"))
        
                        ),
                        
                        mainPanel(uiOutput("formulaOut"),
                                  verbatimTextOutput("modelout"))
                        
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
