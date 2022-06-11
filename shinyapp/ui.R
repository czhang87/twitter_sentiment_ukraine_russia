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
        # menuItem(
        #   "Emotion",
        #   tabName = "emotion",
        #   icon = icon('comment-dots')
        # ),
        menuItem(
          "Topics",
          tabName = "topic",
          icon = icon('comment-dots')
        ),
        menuItem(
          "Word Cloud",
          tabName = "word_cloud",
          icon = icon('cloud')
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
            selected = 'compound_ukraine_after_war'
          )
        ),
        
        conditionalPanel(
          condition =  "input.tabs == 'time_series'",
          selectInput(
            inputId = "keyword",
            label = "Select One or Multiple Keywords",
            choices = choices_keyword,
            selected = c('ukraine', 'russia'),
            multiple = T
          )
        ),
        
        conditionalPanel(
          condition =  "input.tabs == 'topic' | input.tabs == 'word_cloud'",
          selectInput(
            inputId = "topic",
            label = "Select One Keyword",
            choices = choices_keyword,
            selected = c('ukraine')
          )
        )
        
        
        
      )
    ),
    
    dashboardBody(
      # shinyDashboardThemes(
      #   theme = "poor_mans_flatly"
      # ),
      
      add_busy_spinner(spin = "fading-circle"),
      
      h3('Twitter Sendiment Analysis During Russia-Ukraine War (April and May, 2022)'),
      tabItems(
        
        # Map tab
        tabItem(
          tabName = "map",
          tags$style(type = "text/css", "#map {height: calc(100vh - 120px) !important;}"),# increase the height of the map
          leafletOutput("map")
        ),
        
        # Time Series tab
        tabItem(
          tabName = 'time_series',
          plotlyOutput('time_series')
        ),
        
        # # Topic tab
        tabItem(
          tabName = 'topic',
          tags$style(type = "text/css", "#topic {height: calc(100vh - 10px) !important;}"),
          htmlOutput('topic')
          
        ),
        
        # Word cloud tab
        tabItem(
          tabName = 'word_cloud',
            fluidRow(
              column(3),
              column(9,
                     htmlOutput('word_cloud_pos'),
                     htmlOutput('word_cloud_neg')
                     )
              )
          
        )
      )
      
    )
  )
)
