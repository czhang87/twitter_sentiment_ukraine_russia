# Twitter Sentiment Analysis During Russia-Ukraine War in 2022

# Define server logic
shinyServer(function(session, input, output) {
  
  
  # Reset Input Button
  observeEvent(input$reset_input, {

    updateSelectInput(session, "data_type", choices = choices_data_type, selected = 'compound_ukraine_after_war')
    updateNumericInput(session, "tweet_count", value = 0)
    updateSelectInput(session, "keyword", choices = choices_keyword, selected = c('Ukraine', 'Russia'))
    updateSelectInput(session, "topic", choices = choices_topic_word_cloud, selected = c('ukraine'))
  })
  
  # MAP TAB ############################################################################
  
  # Initial Leaflet map
  initial_map <- leaflet() %>%
    addProviderTiles("OpenStreetMap.Mapnik")%>%
    setView(lat = initial_lat, lng = initial_lng, zoom = initial_zoom)
  
  output$map <- renderLeaflet({
    initial_map
  })

  # Reset button in the map
  observe({
    input$reset_map
    leafletProxy("map") %>% setView(lat = initial_lat, lng = initial_lng, zoom = initial_zoom)
  })
  
  # palette
  bins <- c(-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1)
  mypal <- colorBin("YlGn", bins = bins)

  # Interactive elements
  observe({
    
    # reactive input data
    if (input$data_type=="compound_russia_after_war"){
      countries_shape <- countries_shape %>% filter(compound_russia_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_ukraine_after_war"){
      countries_shape <- countries_shape %>% filter(compound_ukraine_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_putin_after_war"){
      countries_shape <- countries_shape %>% filter(compound_putin_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_zelenskyy_after_war"){
      countries_shape <- countries_shape %>% filter(compound_zelenskyy_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_biden_after_war"){
      countries_shape <- countries_shape %>% filter(compound_biden_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_johnson_after_war"){
      countries_shape <- countries_shape %>% filter(compound_johnson_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_macron_after_war"){
      countries_shape <- countries_shape %>% filter(compound_macron_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_scholz_after_war"){
      countries_shape <- countries_shape %>% filter(compound_scholz_after_war_count >= input$tweet_count)
    }
    else if (input$data_type=="compound_eu_after_war"){
      countries_shape <- countries_shape %>% filter(compound_eu_after_war_count >= input$tweet_count)
    }
    else {
      countries_shape <- countries_shape %>% filter(compound_nato_after_war_count >= input$tweet_count)
    }
    
    sentiment_scores <- countries_shape %>% pull(!!input$data_type)
    tweet_count <- countries_shape %>% pluck(paste0(input$data_type, '_count'))
    
    # labels
    labels_map <- paste(
      "<strong>",countries_shape$COUNTRYAFF, "</strong><br/>",
      "Sentiment Score: ", round(sentiment_scores, digits=3),"<br/>",
      "Number of Tweets: ", format(tweet_count, big.mark = ',')
    ) %>% lapply(htmltools::HTML)
    
    # map title
    if(input$data_type == 'compound_russia_after_war'){
      map_title_keyword = 'Russia'
    }
    else if(input$data_type == 'compound_ukraine_after_war'){
      map_title_keyword = 'Ukraine'
    }
    else if(input$data_type == 'compound_putin_after_war'){
      map_title_keyword = 'Vladimir Putin'
    } 
    else if(input$data_type == 'compound_zelenskyy_after_war'){
      map_title_keyword = 'Volodymyr Zelenskyy'
    } 
    else if(input$data_type == 'compound_biden_after_war'){
      map_title_keyword = 'Joe Biden'
    } 
    else if(input$data_type == 'compound_johnson_after_war'){
      map_title_keyword = 'Borris Johnson'
    } 
    else if(input$data_type == 'compound_macron_after_war'){
      map_title_keyword = 'Emmanuel Macron'
    } 
    else if(input$data_type == 'compound_scholz_after_war'){
      map_title_keyword = 'Olaf Scholz'
    } 
    else if(input$data_type == 'compound_eu_after_war'){
      map_title_keyword = 'European Union'
    }
    else{
    map_title_keyword = 'NATO'
    }
    
    output$map_title <- renderPrint(
      h3(HTML(
        'Twitter Sentiment Towards ', 
        "<strong>", paste0(map_title_keyword),"</strong>",
        'During Russia-Ukraine War (April and May 2022)'
        
      )) 
    )
    
    #leafletProxy map
    leafletProxy("map", data = countries_shape )%>%
      clearControls() %>% # clear the map legend
      clearShapes() %>% # clear polygons fill color
      addControl(
        actionBttn("reset_map", "", icon = icon("globe-americas")),
        position="topleft") %>% # add Reset View button in the map
      addPolygons(
        data = countries_shape,
        fillColor = ~mypal(sentiment_scores),
        color ="black",
        stroke = T,
        smoothFactor = 0.2,
        fillOpacity = 0.75,
        weight = 1,
        highlightOptions = highlightOptions(fillColor = "grey",
                                            bringToFront = TRUE),
        label = labels_map
      ) %>%
      addLegend(
        position = "bottomleft",
        pal= mypal,
        values = sentiment_scores,
        title = 'Sentiment Scores',
        opacity = 1
      )
    
    # Time Series tab ###########################################################
    output$time_series <- renderPlotly({
      req(input$keyword) # require a input$keyword to renderPlotly, otherwise the renderPlotly will silently stop.
      ggplotly(
        sent_per_date %>% 
          filter( keyword_cap %in% input$keyword & date > '2022-02-24' ) %>% 
          ggplot(aes(x=date, y=compound, color = keyword_cap))+
          geom_line()+
          geom_hline(yintercept=0, linetype="dashed")+
          theme_bw()+
          theme(panel.grid.major = element_blank(), 
                panel.grid.minor = element_blank(),
                plot.title = black.bold.plain.14.text,
                axis.text = black.bold.plain.11.text,
                axis.title = black.bold.plain.14.text,
                legend.position="bottom",
                legend.box = "vertical",
                legend.title=black.bold.plain.11.text,
                legend.text = black.bold.plain.11.text,
                strip.text = white.bold.plain.14.text,
                strip.background = element_rect(fill = "#2596be"))+
          labs(x='Date in 2022',
               y='Sentiment Score',
               color = 'Keyword'
          )+
          scale_y_continuous(labels = comma)
      )
    })
    
    ## Topic tab ##########################################
    
    # Topic title
    if(input$topic == 'russia'){
      topic_word_cloud_title_keyword = 'Russia'
    }
    else if(input$topic == 'ukraine'){
      topic_word_cloud_title_keyword = 'Ukraine'
    }
    else if(input$topic == 'putin'){
      topic_word_cloud_title_keyword = 'Vladimir Putin'
    } 
    else if(input$topic == 'zelenskyy'){
      topic_word_cloud_title_keyword = 'Volodymyr Zelenskyy'
    } 
    else if(input$topic == 'biden'){
      topic_word_cloud_title_keyword = 'Joe Biden'
    } 
    else if(input$topic == 'johnson'){
      topic_word_cloud_title_keyword = 'Borris Johnson'
    } 
    else if(input$topic == 'macron'){
      topic_word_cloud_title_keyword = 'Emmanuel Macron'
    } 
    else if(input$topic == 'scholz'){
      topic_word_cloud_title_keyword = 'Olaf Scholz'
    } 
    else if(input$topic == 'eu'){
      topic_word_cloud_title_keyword = 'European Union'
    }
    else{
      topic_word_cloud_title_keyword = 'NATO'
    }
    
    output$topic_title <- renderPrint(
      h3(HTML(
        'Topic Modelling Using Latent Dirichlet Allocation for Tweets About', 
        "<strong>", paste0(topic_word_cloud_title_keyword),"</strong>"
      )) 
    )
    
    output$topic <- renderUI({
      # includeHTML(paste0("data/html/", input$topic, ".html"))
      tags$iframe(
        src = paste0(input$topic, ".html"),
        frameborder = 0,
        width = '100%',
        height = 900
      )
    })

    ## Word cloud ##################################################
    output$word_cloud_title <- renderPrint(
      h3(HTML(
        'Twitter Sentiment Towards', 
        "<strong>", paste0(topic_word_cloud_title_keyword),"</strong>",
        'During Russia-Ukraine War (April and May 2022)'
        
      )) 
    )
    
    output$word_cloud_pos <- renderUI({
      return({
        div(
          h3("Positive Word Cloud"),
          img(src = paste0(input$topic, "_positive.png"))
        )
      })
    })
    
    output$word_cloud_neg <- renderUI({
      return({
        div(
          h3("Negative Word Cloud"),
          img(src = paste0(input$topic, "_negative.png"))
        )
      })
    })
    
    


  })
  
})
