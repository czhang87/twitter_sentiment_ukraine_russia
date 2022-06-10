# COVID in the U.S.

# Define UI for application 
shinyUI(

  dashboardPage(
    
    dashboardHeader(
      title="Twitter Sentiment Analysis"
    ),
    
    dashboardSidebar(
      
      sidebarMenu(
        id ="tabs",
        
        menuItem(
          "Map",
          tabName = "map",
          icon = icon("map-marked-alt")
        ),
        menuItem(
          "Time Series",
          tabName = "time_series",
          icon = icon('chart-area')
        ),
        menuItem(
          "Emotion",
          tabName = "emation",
          icon = icon('table')
        ),
        menuItem(
          "Topics",
          tabName = "topics",
          icon = icon('table')
        ),
        menuItem(
          "Word Cloud",
          tabName = "word_cloud",
          icon = icon('table')
        ),
        menuItem(
          "About",
          tabName = "about",
          icon = icon('info')
        ),
        
        # Reset input button
        conditionalPanel(
          condition = "input.tabs!='about'",
          actionBttn(
            inputId = "reset_input",
            label = "Reset Input",
            style = "material-flat")
        ),
        
        # conditional panel of map tab
        conditionalPanel(
          condition =  "input.tabs == 'map'",
          selectInput(
            inputId = "data_type",
            label = "Select the Data",
            choices = choices_data_type,
            selected = 'compound_russia_after_war'
          )
        )
      )
    ),
    
    dashboardBody(
      
      # shinyDashboardThemes(
      #   theme = "poor_mans_flatly"
      # ),
      add_busy_spinner(spin = "fading-circle"),
      
      h3('Twitter Sendiment Analysis of Russia and Ukraine in War (April and May, 2022)'),
      tabItems(
        
        # Map tab
        tabItem(
          tabName = "map",
          tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),# increase the height of the map
          leafletOutput("map")
        )
        
      )
      
    )
  )
)
