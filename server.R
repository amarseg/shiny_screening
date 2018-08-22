library(shiny)

options(shiny.maxRequestSize=60*1024^2) 
server <- function(input, output){
  source('helper_functions.R')
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    plate_data <- load_data(inFile$datapath)
  })
  
}