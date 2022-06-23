# Twitter Sentiment Analysis During Russia-Ukraine War in 2022

# Define UI for application 
shinyUI(

  dashboardPage(
    
    dashboardHeader(
      title="Twitter Sentiment Analysis During Russia-Ukraine War",
      titleWidth = 480
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
          ),
          
          numericInput(
            inputId = "tweet_count",
            label = "Show Countries with Tweets' Number More Than",
            value = 0,
            step = 100)
        ),
        
        conditionalPanel(
          condition =  "input.tabs == 'time_series'",
          selectInput(
            inputId = "keyword",
            label = "Select One or Multiple Keywords",
            choices = choices_keyword,
            selected = c('Ukraine', 'Russia'),
            multiple = T
          )
        ),
        
        conditionalPanel(
          condition =  "input.tabs == 'topic' | input.tabs == 'word_cloud'",
          selectInput(
            inputId = "topic",
            label = "Select One Keyword",
            choices = choices_topic_word_cloud,
            selected = c('ukraine')
          )
        )
      )
    ),
    
    dashboardBody(
      
      # busy spinner
      add_busy_spinner(spin = "fading-circle"),
      
      tabItems(
        
        # Map tab
        tabItem(
          tabName = "map",
          tags$style(type = "text/css", "#map {height: calc(100vh - 135px) !important;}"),# increase the height of the map
          uiOutput("map_title"),
          uiOutput('sent_score_note'),
          leafletOutput("map")
        ),
        
        # Time Series tab
        tabItem(
          tabName = 'time_series',
          h3('Twitter Sentiment Analysis During Russia-Ukraine War (April and May, 2022)'),
          plotlyOutput('time_series')
        ),
        
        # Topic tab
        tabItem(
          tabName = 'topic',
          # tags$style(type = "text/css", "#topic {height: calc(100vh - 10px) !important;}")
          uiOutput("topic_title"),
          htmlOutput('topic')
          
        ),
        
        # Word cloud tab
        tabItem(
          tabName = 'word_cloud',
          uiOutput("word_cloud_title"),
            fluidRow(
              column(3),
              column(9,
                     htmlOutput('word_cloud_pos'),
                     br(),
                     htmlOutput('word_cloud_neg')
                     )
              )
        ),
        
        # About tab
        tabItem(
          tabName = "about",
          h1("About"),
          includeHTML(rmarkdown::render("data/about.Rmd"))
        )
      )
    )
  )
)
