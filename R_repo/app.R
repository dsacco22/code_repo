# Loading libraries
library("shiny")
library("dplyr")
library("dbplyr")
library("pool")
library("ggplot2")
library("odbc")
library("RPostgreSQL")
library("DT")
library("plotly")
library("shinyWidgets")

##### Creating the connection ######

## Creating a variable for the password
pw <- {
  "ubaEYyxl3UimQCGa4S1e8yvlZmkGRK"
}

## Creating a variable for the driver
drv <- dbDriver("PostgreSQL")


## Creating the connection variable
conn <- dbConnect(drv, dbname="capstonedba",
                  host="capstone-db.c9mqkx12zppw.us-east-1.rds.amazonaws.com",
                  port=5432, user="capstonedba",
                  password = pw)

## Removing the password variable
rm(pw)

## Querying the database ##
df_postgres <- dbGetQuery(conn, "SELECT * FROM LOANS2012Q1")
data <- data.frame(df_postgres)

## Creating a variable for the unique values in PropType
seller <- sort(unique(data$seller))
propertytype <- sort(unique(data$property_type))
channel <- sort(unique(data$channel))
occupancy <- sort(unique(data$occupancy))
purpose <- sort(unique(data$purpose))
product <- sort(unique(data$product_type))

## Creating the UI of the App

ui <- fluidPage(
  titlePanel("Mortgage Banking App"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "select4", h4("Seller"),
        choices = c(seller)
      ),
      
      sliderInput(
        "sliderCS", h4("Credit Score"),
        min = min(data$credit_score), max = max(data$credit_score),
        value = c(0,832)
      ),
      
      sliderInput(
        "sliderDTI", h4("DTI"),
        min = min(data$dti), max = max(data$dti),
        value = c(0,100)
      ),
      
      sliderInput(
        "sliderLTV", h4("LTV"),
        min = min(data$ltv), max = max(data$ltv),
        value = c(0,100)
      ),
      
      numericInput(
        "choiceLM", "Loan Multiplier: Please enter your Loan Multipler",
        min = min(data$loan_multipler), max = max(data$loan_multipler),
        value = c(5,97)
      ),

      img(src = 'rstudio.png', height = "100%", width = "100%")
    ),
    
    mainPanel(
      
      dataTableOutput("tablePlot", width = "80%"),
      
      downloadButton("download_filtered", "Download Filtered Data"),
      
      actionButton("refresh", "REFRESH"),
    
      fluidRow(
        splitLayout(cellWidths = c("50%","50%"), plotOutput("scatterplot"), plotOutput("scatterplot2")
      )),
      
      pickerInput(
        "selectPT", "Property Type",
        choices = c(propertytype),
        options = list('actions-box' = TRUE),
        multiple = F
      )
      
      )
    )
)

## Defining the server logic
server <- function(input, output, session) {
  
  rdata <- reactive(data)
  
  output$tablePlot <- renderDataTable({
    data %>%
      filter(seller == input$select4 & credit_score >= input$sliderCS[1] & credit_score <= input$sliderCS[2] & dti >= input$sliderDTI[1] & dti <= input$sliderDTI[2] & ltv >= input$sliderLTV[1] & ltv <= input$sliderLTV[2] & loan_multipler <= input$choiceLM)
    },
      rownames = FALSE)
  
  output$download_filtered <- downloadHandler(
    filename = function() {
      paste('Filtered_Data-', Sys.Date(), '.csv', sep = ',')
    },
    content = function(file){
      write.csv(rdata()[input[["tablePlot_rows_all"]], ], file)
    }
  )
  
  output$scatterplot <- renderPlot({
   data %>%
      filter(seller == input$select4 & credit_score >= input$sliderCS[1] & credit_score <= input$sliderCS[2] & dti >= input$sliderDTI[1] & dti <= input$sliderDTI[2] & ltv >= input$sliderLTV[1] & ltv <= input$sliderLTV[2] & loan_multipler <= input$choiceLM) %>%
      ggplot(aes(x = credit_score, y = loan_multipler, color = property_type)) +
      geom_point() +
      xlab("Credit Score") +
      ylab("Expected Bad Rate") +
      ggtitle("Overall View")
  })
  
  output$scatterplot2 <- renderPlot({
    data %>%
      filter(property_type == input$selectPT & seller == input$select4 & credit_score >= input$sliderCS[1] & credit_score <= input$sliderCS[2] & dti >= input$sliderDTI[1] & dti <= input$sliderDTI[2] & ltv >= input$sliderLTV[1] & ltv <= input$sliderLTV[2] & loan_multipler <= input$choiceLM) %>%
      ggplot(aes(x = credit_score, y = loan_multipler)) +
      geom_point() +
      xlab("Credit Score") +
      ylab("Expected Bad Rate") +
      ggtitle(input$selectPT)
  })
  
}

##Closing the database connection
onStop(function() {
  dbDisconnect(conn)
})
## Run the app

shinyApp(ui = ui, server = server)