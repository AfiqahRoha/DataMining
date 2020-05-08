library(plyr)  
library(dplyr)
library(tidytext)
library(stringr)
library(readr)
library(tm)
library(lubridate)
library(stringi)
library(textcat)
library(textclean)

getwd()
#import data
tweets <- read.csv("twitter.csv", stringsAsFactors = FALSE)
glimpse(tweets)
#remove warnings
options(warn = -1)

##step 1
##Data Collection and Insight
user_tweets <- tweets %>%
  lapply(iconv, to = 'ASCII//TRANSLIT', 'latin1')
user_tweets <- as.data.frame(do.call(cbind, user_tweets))
names(user_tweets) <- toupper(names(user_tweets))
glimpse(user_tweets)

##step 2
##Data Cleaning
##2.1 Sanitization using Corpus
user_tweets_text <- Corpus(VectorSource(user_tweets$TEXT))

#convert to lower case
user_tweets_text <- tm_map(user_tweets_text, content_transformer(tolower))

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
removePunct <- function(x) gsub("[[:punct:]]", " ", x, perl = TRUE)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(removePunct))

#remove profane words
linkbadwords <-"https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en"
if (!file.exists("en_bws.txt")){download.file(linkbadwords, destfile="en_bw.txt")}
linkbadwords <-"https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt"
if (!file.exists("list.txt")){download.file(linkbadwords, destfile="list_bw.txt")}
bwdat <- read.table("en_bw.txt", header = FALSE, sep = "\n", strip.white = TRUE)
bwdat_2 <- read.table("list_bw.txt", header = FALSE, sep = "\n", strip.white = TRUE)
names(bwdat) <- "Bad Words"
names(bwdat_2) <- "Bad Words"
user_tweets_text <- tm_map(user_tweets_text, removeWords, bwdat[,1])
user_tweets_text <- tm_map(user_tweets_text, removeWords, bwdat_2[,1])

#remove word elongations
user_tweets_text <- tm_map(user_tweets_text, replace_word_elongation)

#remove short words
shortWordRemover <- function(x) gsub("\\b\\w{1}\\b", "", x, perl = TRUE)  #remove a, t; every words of length 1
user_tweets_text <- tm_map(user_tweets_text, content_transformer(shortWordRemover))

#remove extra whitespace
user_tweets_text <- tm_map(user_tweets_text, stripWhitespace)
whitespaceStartRemover <- function(x) gsub("^ ", "", x, perl = TRUE)
user_tweets_text <- tm_map(user_tweets_text, content_transformer(whitespaceStartRemover))

##Create data frame for Corpus file
user_tweets_text_corpus <- data.frame(TEXT=unlist(sapply(user_tweets_text,'[')), stringsAsFactors=FALSE)

##2.2 Replace the text column in user_tweets dataframe
glimpse(user_tweets)
clean_user_tweets <- user_tweets %>%
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

##replace all empty cell with NA in NEW_TEXT column
clean_user_tweets$NEW_TEXT[clean_user_tweets$NEW_TEXT == ""] <- NA
sum(is.na(clean_user_tweets$NEW_TEXT))
##remove all the rows with NA values
clean_user_tweets <- na.omit(clean_user_tweets)
glimpse(clean_user_tweets)

#Step 3:
##save the clean data as csv file
write.csv(clean_user_tweets, "clean_twitter.csv", row.names = FALSE)
