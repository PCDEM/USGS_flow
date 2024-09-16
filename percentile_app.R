# Load packages:
library(shiny)
library(shinycssloaders)
library(lubridate)
library(readxl)
library(dplyr)
library(plotly)
library(tidyr)


# Load the datasets:
hdi <- read_excel('Data/MASTER_Flow_HDI_2006-2024.xlsx')
tran <- read_excel('Data/MASTER_Flow_Transect_2003-2024.xlsx')
usgs <- read_excel('Data/USGS_PC_Flow_2003_2024.xlsx')

# Combine the datasets:
dat <- bind_rows(hdi, tran, usgs)

# Calculate the 5/95 percentiles for each site:
ptiles <- dat |>
  group_by(Site) |>
  summarise(
    p5 = quantile(Q, 0.05, na.rm = TRUE),
    p95 = quantile(Q, 0.95, na.rm = TRUE)
  ) 


options(warn = -1)



ui <- fluidPage(
  titlePanel("Flow Outliers for USGS/HDI/PCDEM Data"),
  sidebarLayout(
    sidebarPanel(width=2,
                 # Set error message color:
                 tags$head(
                   tags$style(HTML('.shiny-output-error-validation {
                    color: red;
                    font-weight: bold;
                    font-size: 20px}'))),
                 selectInput('site', label = 'Site', choices = sort(unique(dat$Site)), selected = '01-09')
    ),
    mainPanel(tabsetPanel(id = "tabs"),
              # tags$head(tags$style("#message{color: red;
              #                      font-size: 20px;
              #                      }")),
              # plotlyOutput('ts') %>% withSpinner(color = "blue")
    )
  )
)

server <- function(input, output, session) {
  
  getData <- reactive({
    datSite <- dat |>
      filter(Site == input$site) 
  })
    

  output$ts <- renderPlotly({
    df <- getData()
    
    #df$rolling_mean <- rollmean(as.numeric(df$val), input$window, align = 'right', fill = NA)
    
    # Calculate percentiles
    q95 <- quantile(as.numeric(df$Q),0.95)
    q05 <- quantile(as.numeric(df$Q),0.05)
    
    # Create lines for 5th and 95th percentile:
    hline <- function(y = 0, color = "darkgreen") {
      list(
        type = "line",
        x0 = 0,
        x1 = 1,
        xref = "paper",
        y0 = y,
        y1 = y,
        line = list(color = color, dash='dash'))
    }
    
    # Plot the data using plotly:
    plot_ly(height = 900, width = 1500, 
            df, x = ~Date, y = ~Q, type = 'scatter', mode = 'markers') |>
      layout(
        title = paste0('Flow at Site ', input$site)
        )
      
    
  })
  
  # # Generate table of outliers:
  # output$list <- renderTable({
  #   df <- filter(getData(), getData()$outs == 'outlier')
  #   df2 <- data.frame(Date = as.character(df$Date), Value = df$val)
  # })
  
}

shinyApp(ui, server)
