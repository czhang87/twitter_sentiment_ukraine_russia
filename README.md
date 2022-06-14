# Twitter Sentiment Analysis During Russia-Ukraine War (April and May 2022)

### Motivation

On February 24, 2022, Russian President Vladimir Putin announced a “special military operation” to denazify and demilitarize Ukraine, after which Russia invaded Ukraine. This war was the largest war in Europe since World War II. The Ukraine war resulted in massive loss of military and civilian life in Ukraine and Russia, a humanitarian crisis for millions of Ukrainian people, and the enormous destruction of Ukrainian cities and infrastructure. Russia has been condemned for its aggression, violation of human rights, and a war crime, expelled from the Council of Europe and United Nations Human Right Council, and sanctioned by the U.S., U.K., E.U., and countries around the world. The responses from world leaders, such as Joe Biden and Boris Johnson, to the Russian invasion of Ukraine have also impacted their domestic approval ratings. The Ukraine war will profoundly change the geopolitics in Europe and the world. This project analyzed the public sentiment and topics on Twitter towards Ukraine, Russia, Ukrainian President Zelenskyy, Russian President Putin, and other world organizations and leaders at this critical moment of history. 

### R Shiny App

https://czhang87.shinyapps.io/twitter_sentiment_ukraine_russia/

### Data Sources

The English, French, Spanish, and Portuguese tweets were collected at Twitter API from April 10 to May 24, 2022. The total number of tweets is 2,397,057 and the percentage of English tweets is 99.13%.  Moreover, 58.75% of the tweets have location information provided by Twitter users and the iso2 country code was extracted from 37.49% of the tweets.

* [Twitter API](https://developer.twitter.com/en)
* [World Countries Shape File ](https://hub.arcgis.com/datasets/2b93b06dc0dc4e809d3c8db5cb96ba69_0/explore)
* [World Cities](https://simplemaps.com/data/world-cities)

### Data Science Tools

* Python: pandas, numpy
* R: tidyverse
* Twitter API: tweepy
* Translation: transformers, [French to English](https://huggingface.co/Helsinki-NLP/opus-mt-fr-en), [Spanish to English](https://huggingface.co/Helsinki-NLP/opus-mt-es-en), [Portuguese to English](https://huggingface.co/unicamp-dl/translation-en-pt-t5)
* Sentiment: [vaderSentiment](https://github.com/cjhutto/vaderSentiment#:~:text=by%20Katie%20Roehrick-,About,on%20texts%20from%20other%20domains.)
* NLP: nltk, re, gensim, wordcloud 
* Visulization: matplotlib, ggplot2, plotly, pyLDAvis, leaflet
* App: shiny, shinydashboard

### Limitations

* Tweets are limited between April 10 and May 24, 2022.
* 99.13% of tweets are in English and most tweets are from English-speaking countries.
* Only 58.75% of tweets have location information and the 37.49% of tweets have standard iso2 country codes due to inconsistency of location input by Twitter users. The location information provided by Twitter users may be inaccurate and have inconsistent spelling.
* Despite the effort to reduce the possibility of fake Twitter accounts, they cannot be eliminated.
* Accuracy of the translation and vaderSentiment analysis may impact the results.

### Directions for Improvement

* Acquire more tweets for a longer period before and after the war. 
* Acquire more tweets that are not English and from non-English-speaking countries.
* Analyze the emotions of tweets using [twitter-roberta-base-emotion](https://huggingface.co/cardiffnlp/twitter-roberta-base-emotion)

### Author

Alex Zhang, Apprentice of Data Science Cohort 5 at [Nashville Software School](https://nashvillesoftwareschool.com/)

### Acknowledgement

* Michael Holloway (Lead Instructor)
* Mahesh Rao (Instructor)
* Veronica Ikeshoji-Orlati (Teaching Assistant)
* Alvin Wendt (Teaching Assistant)
* Data Science 5 Cohort, Nashville Software School


<a href="https://nashvillesoftwareschool.com/">
<div class="col2">
<img class="foto" src="img/NSS-logo-horizontal-small.jpeg" style="width:500px;"/>
</div>
</a>
