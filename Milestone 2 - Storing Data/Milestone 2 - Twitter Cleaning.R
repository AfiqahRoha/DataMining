library(plyr)  
library(dplyr)
library(tidytext)
library(stringr)
library(readr)
library(tm)
library(lubridate)
library(textclean)

getwd()
##Step 1
##import data
tweets <- read.csv("twitter_encoded.csv", stringsAsFactors = FALSE, na.strings=c(""," ","NA","NaN"), encoding="UTF-8")
tweets <- as.data.frame(do.call(cbind, tweets))
colnames(tweets)[1] <- "TIMESTAMP"
glimpse(tweets)
##remove warnings
options(warn = -1)

##Step 2
##Data Cleaning
##2.1 Sanitization using Corpus
user_tweets_text <- Corpus(VectorSource(tweets$TEXT))

#remove URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x, perl = TRUE)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(removeURL))

#remove hashtag symbol, username and &amp symbol
hashtagRemover <- function(x) gsub("#", "", x, perl = TRUE)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(hashtagRemover))
usernameRemover <- function(x) gsub("@\\S+", "", x, perl = TRUE)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(usernameRemover))
symbolRemover <- function(x) gsub("&amp;", "", x)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(symbolRemover))

#remove punctuations
removePunct <- function(x) gsub("(?![-?!.%/'])[[:punct:]]", " ", x, perl = TRUE)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(removePunct))

#remove word elongations
user_tweets_text <- tm_map(user_tweets_text, replace_word_elongation)

#remove extra whitespace
user_tweets_text <- tm_map(user_tweets_text, stripWhitespace)
whitespaceStartRemover <- function(x) gsub("^ ", "", x, perl = TRUE)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(whitespaceStartRemover))

##Create data frame for Corpus file
user_tweets_text_corpus <- data.frame(TEXT=unlist(sapply(user_tweets_text,'[')), stringsAsFactors=FALSE)

##2.2 Replace the text column in tweets dataframe
glimpse(tweets)
clean_user_tweets <- tweets %>%
  mutate(NEW_TEXT = user_tweets_text_corpus$TEXT)
clean_user_tweets <- clean_user_tweets[-c(2)]
glimpse(clean_user_tweets)

##2.3 Cleaning the time column
#change the format of timestamp to date and time
clean_user_tweets$TIMESTAMP <- as.character(clean_user_tweets$TIMESTAMP)
clean_user_tweets$TIMESTAMP <- as.POSIXct(strptime(clean_user_tweets$TIMESTAMP, "%Y-%m-%d %H:%M:%S"))
glimpse(clean_user_tweets)
#lets do the time as morning/afternoon/evening/night
breaks <- hour(hms("00:00:00", "6:00:00", "12:00:00", "18:00:00", "23:59:00")) #create breaks
labels_breaks <- c("Night", "Morning", "Afternoon", "Evening") #labels for the breaks
clean_user_tweets$TIMESTAMP <- ymd_hms(clean_user_tweets$TIMESTAMP)
clean_user_tweets$TIME_OF_DAY <- cut(x=hour(clean_user_tweets$TIMESTAMP), breaks = breaks, labels = labels_breaks, 
                                   include.lowest = TRUE)
glimpse(clean_user_tweets)

##check for missing values
clean_user_tweets$NEW_TEXT[clean_user_tweets$NEW_TEXT == ""] <- NA
colSums(is.na(clean_user_tweets))

##remove all the rows with NA values
clean_user_tweets <- na.omit(clean_user_tweets)
colSums(is.na(clean_user_tweets))
glimpse(clean_user_tweets)

#Step 3:
##save the clean data as csv file
write_excel_csv(clean_user_tweets, "new_twitter.csv")
