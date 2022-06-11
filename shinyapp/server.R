# COVID in the U.S.

# Define server logic
shinyServer(function(session, input, output) {
  
  
  # Reset Input Button
  observeEvent(input$reset_input, {

    updateSelectInput(session, "data_type", choices = choices_data_type, selected = 'compound_russia_after_war')

  })
  
  # MAP TAB-------------------------------------------------------------------------------
  
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

  #leafletProxy map
  observe({
    # reactive input data
    sentiment_scores <- countries_shape %>% pluck(input$data_type)
    tweet_count <- countries_shape %>% pluck(paste0(input$data_type, '_count'))
    
    # labels
    labels_map <- paste(
      "<strong>",countries_shape$COUNTRYAFF, "</strong><br/>",
      "Sentiment Score: ", round(sentiment_scores, digits=3),"<br/>",
      "Number of Tweets: ", format(tweet_count, big.mark = ',')
    ) %>% lapply(htmltools::HTML)
    
    
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
        # title = titles_vaccination,
        opacity = 1
      )
    
    # Time Series tab ###########################################################
    
    output$time_series <- renderPlotly({
      ggplotly(
        sent_per_date %>% 
          filter( keyword %in% input$keyword & date > '2022-02-24' ) %>% 
          ggplot(aes(x=date, y=compound, color = keyword))+
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
          labs(title = 'Twitter Sentiment',
               x='Date in 2022',
               y='Sentiment Score',
               color = 'Keyword'
          )+
          scale_y_continuous(labels = comma)
      )
    })
    
    ## Topic tab ####
    output$topic <- renderUI({
      includeHTML("data/html/biden.html")
      # HTML(readLines(file_to_show))
    })

    # getPage<-function() {
    #   return(includeHTML("data/html/biden.html"))
    # }
    # output$topic<-renderUI({getPage()})

    ## Word cloud

    output$word_cloud <- renderImage({
      filename <- normalizePath(file.path('./image',
                                          paste('word_cloud_biden', '.png', sep='')))

      # Return a list containing the filename
      list(src = filename, alt = "Alternate text")
    }, deleteFile = FALSE)


  })
  
})
