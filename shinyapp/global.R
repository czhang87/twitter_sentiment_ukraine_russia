# Twitter Sentiment Analysis During Russia-Ukraine War in 2022

library(shiny)
library(shinydashboard)
library(tidyverse)
library(httr)
library(jsonlite)
library(sf)
library(leaflet)
library(htmltools)
library(rmapshaper)
library(stringr)
library(plotly)
library(ggExtra)
library(ggpmisc)
library(DT)
library(shinyWidgets)
library(dashboardthemes)
library(scales)
library(shinycssloaders)
library(ggcorrplot)
library(repr)
library(rlang)
library(xlsx)
library(shinybusy)
library(rmarkdown)
library(dashboardthemes)
library(lubridate)

setwd("~/Documents/Data Science/bootcamp/NSS/DS5/nss_projects/twitter_sentiment_ukraine_russia/shinyapp")
# # #####################################################################################################
# # # load data
countries_shape <- read_sf("data/World_Countries/World_Countries__Generalized_.shp")
sent_per_country = read_csv('data/sentiment_per_country.csv')
countries_shape <- left_join(countries_shape, sent_per_country, by = c('AFF_ISO' = 'iso2_final'))
sent_per_date <- read_csv('data/sentiment_per_date.csv')

# capitalize keyword
list_temp <- c()
for (x in sent_per_date$keyword){
  if(x =='putin' ){
    list_temp = c(list_temp, 'Vladimir Putin')
  }
  else if(x =='zelenskyy' ){
    list_temp = c(list_temp, 'Volodymyr Zelenskyy')
  }
  else if(x =='biden' ){
    list_temp = c(list_temp, 'Joe Biden')
  }
  else if(x =='johnson' ){
    list_temp = c(list_temp, 'Boris Johnson')
  }
  else if(x =='macron' ){
    list_temp = c(list_temp, 'Emmanuel Macron')
  }
  else if(x =='scholz' ){
    list_temp = c(list_temp, 'Olaf Scholz')
  }
  else if (x == 'eu' | x == 'nato'){
    list_temp = c(list_temp, str_to_upper(x))
  }
  else {
    list_temp = c(list_temp, str_to_title(x))
  }
}
sent_per_date <- sent_per_date %>% 
  mutate(keyword_cap = list_temp)

# labels for legends and titles
choices_data_type <- c('Sentiment towards Russia' = "compound_russia_after_war",
                       'Sentiment towards Ukraine' = "compound_ukraine_after_war",
                       'Sentiment towards Vladimir Putin' = "compound_putin_after_war",
                       'Sentiment towards Volodymyr Zelenskyy' = "compound_zelenskyy_after_war", 
                       'Sentiment towards Joe Biden' = "compound_biden_after_war",
                       'Sentiment towards Borris Johnson' = "compound_johnson_after_war",
                       'Sentiment towards Emmanuel Macron' = "compound_macron_after_war", 
                       'Sentiment towards Olaf Scholz' = "compound_scholz_after_war",
                       'Sentiment towards EU' = "compound_eu_after_war",
                       'Sentiment towards NATO' = "compound_nato_after_war"
                       )
choices_keyword <- c('Russia',
                         'Ukraine',
                         'Vladimir Putin',
                         'Volodymyr Zelenskyy',
                         'Joe Biden',
                         'Boris Johnson',
                         'Emmanuel Macron',
                         'Olaf Scholz',
                         'EU',
                         'NATO')
  
choices_topic_word_cloud<- c('Russia' = 'russia',
                     'Ukraine' = 'ukraine',
                     'Vladimir Putin' = 'putin',
                     'Volodymyr Zelenskyy' = 'zelenskyy',
                     'Joe Biden' = 'biden',
                     'Boris Johnson' = 'johnson',
                     'Emmanuel Macron' = 'macron',
                     'Olaf Scholz' = 'scholz',
                     'EU' = 'eu',
                     'NATO' = 'nato'
                     )

# Initial view
initial_lat = 39.8283
initial_lng = 0
initial_zoom = 2

# element_text()
black.bold.plain.11.text<- element_text(color = "black", face = "bold", size=11)
black.bold.plain.14.text<- element_text(color = "black", face = "bold", size=14)
black.bold.plain.18.text<- element_text(color = "black", face = "bold", size=18 )
white.bold.plain.14.text<- element_text(color = "white", face = "bold", size=14)
