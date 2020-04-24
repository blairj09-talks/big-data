library(shiny)
library(shinydashboard)
library(DT)
library(pool)
library(config)
library(tidyverse)
library(plotly)

pool <- dbPool(
    drv = RPostgres::Postgres(),
    host =  get("host"),
    user = get("user"),
    password = get("pwd"),
    port = get("port"),
    dbname = "retail",
    bigint = "integer"
)

onStop(function() {
    poolClose(pool)
})

header <- dashboardHeader(title = "Retail Dashboard")

sidebar <- dashboardSidebar(
    sidebarMenu(
        dateRangeInput("dates", "Date Range", 
                       start = "2016-01-01", 
                       end = "2016-12-31", 
                       min = "2016-01-01",
                       max = "2018-03-24"),
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Data", tabName = "data", icon = icon("table"))
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "dashboard",
                fluidRow(
                    infoBoxOutput("total_sales"),
                    infoBoxOutput("total_orders"),
                    infoBoxOutput("total_per_order")
                ),
                fluidRow(
                    box(
                        plotlyOutput("order_totals"),
                        title = "Order Totals",
                        width = 12
                    )
                ),
                fluidRow(
                    box(
                        plotlyOutput("order_volume"),
                        title = "Order Volume",
                        width = 12
                    )
                )
        ),
        tabItem(tabName = "data",
                fluidRow(
                 DTOutput("raw_data")   
                ))
    )
)

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {
    transactions <- reactive({
        start_date <- input$dates[1]
        end_date <- input$dates[2]
        tbl(pool, "transactions") %>% 
            filter(date >= !!start_date,
                   date <= !!end_date)
    })
    
    total_sales <- reactive(
        transactions() %>% 
            summarise(total_sales = sum(price, na.rm = TRUE)) %>% 
            collect() %>% 
            pull(total_sales)
    )
    
    total_orders <- reactive(
        transactions() %>% 
            summarise(total_orders = n_distinct(order_id)) %>% 
            collect() %>% 
            pull(total_orders)
    )
    
    output$total_sales <- renderInfoBox({
        infoBox(title = "Total Sales", 
                value = scales::dollar(round(total_sales(), 2)),
                icon = icon("credit-card"))
    })
    
    output$total_orders <- renderInfoBox({
        infoBox(title = "Total Orders",
                value = scales::comma(total_orders()),
                icon = icon("list"))
    })
    
    output$total_per_order <- renderInfoBox({
        infoBox(title = "Avg. per Order",
                value = scales::dollar(total_sales() / total_orders()))
    })
    
    output$order_totals <- renderPlotly({
        data <- transactions() %>% 
            group_by(date) %>% 
            summarise(order_totals = sum(price, na.rm = TRUE)) %>% 
            collect()
        
        p <- ggplot(data, aes(x = date, y = order_totals)) +
            geom_col() +
            scale_y_continuous(labels = scales::dollar) +
            theme_bw() +
            labs(x = "Date",
                 y = "Order Totals")
        
        ggplotly(p)
    })
    
    output$order_volume <- renderPlotly({
        data <- transactions() %>% 
            group_by(date) %>% 
            summarise(orders = n_distinct(order_id)) %>% 
            collect()
        
        p <- ggplot(data, aes(x = date, y = orders)) +
            geom_col() +
            scale_y_continuous(labels = scales::comma) +
            theme_bw() +
            labs(x = "Date",
                 y = "Orders")
        
        ggplotly(p)
    })
    
    
    
    output$raw_data <- renderDT({
        transactions() %>% 
            collect()
        })
}

shinyApp(ui = ui, server = server)
