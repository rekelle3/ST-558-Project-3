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
                                        c("Numeric" = "num",
                                          "Graphical" = "graph")),
                            
                            conditionalPanel(condition = "input.sumType == `num`",
                                             selectInput("numType", "Type of Numeric Summary Desired:",
                                                         c("One Way Contingency Table" = "oneway",
                                                           "Two Way Contingency Table" = "twoway",
                                                           "Five Number Summary" = "fivenum",
                                                           "Correlation" = "cor",
                                                           "Covariance" = "cov"))),
                            
                            conditionalPanel(condition = "input.sumType == `graph`",
                                             selectInput("graphType", "Type of Graphical Summary Desired:",
                                                         c("Barplot for One Variable" = "onebar",
                                                           "Barplot for Two Variables" = "twobar",
                                                           "Histogram for One Variable" = "onehist",
                                                           "Histogram for Two Variables" = "twohist"))),
                            
                            conditionalPanel(condition = "input.numType == `twoway` || input.numType == `cor` || input.numType == `cov` || input.graphType == `twobar` || input.graphType ==`twohist`",
                                             selectInput("varOne", "First Variable:",
                                                         c("Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "Absolute magnitude",
                                                           "Star Type" = "Star type",
                                                           "Star Color" = "Star color",
                                                           "Spectral Class" = "Spectral Class"))),
                            
                            conditionalPanel(condition = "input.numType == `twoway` || input.numType == `cor` || input.numType == `cov` || input.graphType == `twobar` || input.graphType ==`twohist`",
                                             selectInput("varTwo", "Second Variable:",
                                                         c("Temperature" = "Temperature",
                                                           "Luminosity" = "Luminosity",
                                                           "Radius" = "Radius",
                                                           "Absolute Magnitude" = "Absolute magnitude",
                                                           "Star Type" = "Star type",
                                                           "Star Color" = "Star color",
                                                           "Spectral Class" = "Spectral Class")))
                            
                        )),
               tabPanel("Clustering"),
               tabPanel("Modeling"),
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
                                           checkboxGroupInput("starTypeOpt", "Values Desired:",
                                                              c("Brown Dwarf" = 0,
                                                                "Red Dwarf" = 1,
                                                                "White Dwarf" = 2,
                                                                "Main Sequence" = 3,
                                                                "Supergiant" = 4,
                                                                "Hypergiant" = 5)))
                        ))
)
)
