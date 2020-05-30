library(plyr)  
library(dplyr)
library(tidytext)
library(stringr)
library(readr)
library(tm)
library(lubridate)

getwd()
##Step 1
##import data
##Reddit hot tag
reddit_hottag <- read.csv("reddit_encoded.csv", stringsAsFactors=FALSE, na.strings=c(""," ","NA","NaN"), encoding="UTF-8")
reddit_hottag <- as.data.frame(do.call(cbind, reddit_hottag))
colnames(reddit_hottag)[1] <- "TITLE"
glimpse(reddit_hottag)
##Reddit comments hot tag
reddit_comments_hottag <- read.csv("comments_encoded.csv", stringsAsFactors=FALSE, na.strings=c(""," ","NA","NaN"), encoding="UTF-8")
reddit_comments_hottag <- as.data.frame(do.call(cbind, reddit_comments_hottag))
colnames(reddit_comments_hottag)[1] <- "ID"
glimpse(reddit_comments_hottag)
##remove warnings
options(warn = -1)

##Step 2
##Data Cleaning
##2.1 Sanitization using Corpus
reddit_hottag_title <- Corpus(VectorSource(reddit_hottag$TITLE))
reddit_hottag_body <- Corpus(VectorSource(reddit_hottag$BODY))
reddit_comments_hottag_corpus <- Corpus(VectorSource(reddit_comments_hottag$COMMENTS))

#remove URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x, perl = TRUE)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(removeURL))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(removeURL))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(removeURL))

#remove reddit tag
removeTag <- function(x) gsub("/R/|/r/|r/|/u/|u/", "", x, perl = TRUE)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(removeTag))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(removeTag))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(removeTag))

#remove &amp symbol
symbolRemover <- function(x) gsub("&amp;", "", x)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(symbolRemover))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(symbolRemover))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(symbolRemover))

#remove punctuations
removePunct <- function(x) gsub("(?![-?!.%/'])[[:punct:]]", " ", x, perl = TRUE)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(removePunct))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(removePunct))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(removePunct))

#remove unnecessary words
reddit_hottag_title <- tm_map(reddit_hottag_title, removeWords, c("you", "if", "want", "with", "to", "and"))
reddit_hottag_body <- tm_map(reddit_hottag_body, removeWords, c("you", "if", "want", "with", "to", "and"))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, removeWords, 
                c("you", "if", "If", "want", "with", "can", "will", "even", "make", "need", "It", "to", "the", "The"))

#remove extra whitespace
reddit_hottag_title <- tm_map(reddit_hottag_title, stripWhitespace)
reddit_hottag_body <- tm_map(reddit_hottag_body, stripWhitespace)
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, stripWhitespace)
whitespaceStartRemover <- function(x) gsub("^ ", "", x, perl = TRUE)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(whitespaceStartRemover))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(whitespaceStartRemover))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(whitespaceStartRemover))

##Create data frame for Corpus file
df_reddit_hottag_title <- data.frame(TITLE=unlist(sapply(reddit_hottag_title,'[')), stringsAsFactors=FALSE)
df_reddit_hottag_body <- data.frame(BODY=unlist(sapply(reddit_hottag_body,'[')), stringsAsFactors=FALSE)
df_reddit_comments_hottag_corpus <- data.frame(COMMENTS=unlist(sapply(reddit_comments_hottag_corpus,'[')), stringsAsFactors=FALSE)

##2.2 Replace the columns in original dataframe
##for reddit hot tag dataframe
glimpse(reddit_hottag)
new_reddit_hottag <- reddit_hottag %>%
  mutate(NEW_TITLE = df_reddit_hottag_title$TITLE) %>%
  mutate(NEW_BODY = df_reddit_hottag_body$BODY)
new_reddit_hottag <- new_reddit_hottag[-c(1,7)]
##for reddit comments hot tag dataframe
glimpse(reddit_comments_hottag)
new_reddit_comments_hottag <- reddit_comments_hottag %>%
  mutate(NEW_COMMENTS = df_reddit_comments_hottag_corpus$COMMENTS)
new_reddit_comments_hottag <- new_reddit_comments_hottag[-c(2)]
##glimpse all dataframe
glimpse(new_reddit_hottag)
glimpse(new_reddit_comments_hottag)

##2.3 Cleaning the time column
#change the format of timestamp to date and time
new_reddit_hottag$TIMESTAMP <- as.character(new_reddit_hottag$TIMESTAMP)
new_reddit_hottag$TIMESTAMP <- as.POSIXct(strptime(new_reddit_hottag$TIMESTAMP, "%Y-%m-%d %H:%M:%S"))
glimpse(new_reddit_hottag)
#lets do the time as morning/afternoon/evening/night
breaks <- hour(hms("00:00:00", "6:00:00", "12:00:00", "18:00:00", "23:59:00")) #create breaks
labels_breaks <- c("Night", "Morning", "Afternoon", "Evening") #labels for the breaks
new_reddit_hottag$TIMESTAMP <- ymd_hms(new_reddit_hottag$TIMESTAMP)
new_reddit_hottag$TIME_OF_DAY <- cut(x=hour(new_reddit_hottag$TIMESTAMP), breaks = breaks, labels = labels_breaks, 
                                     include.lowest = TRUE)
glimpse(new_reddit_hottag)

#check for missing values
new_reddit_hottag$NEW_TITLE[new_reddit_hottag$NEW_TITLE == ""] <- NA
new_reddit_hottag$NEW_BODY[new_reddit_hottag$NEW_BODY == ""] <- NA
new_reddit_comments_hottag$NEW_COMMENTS[new_reddit_comments_hottag$NEW_COMMENTS == ""] <- NA
colSums(is.na(new_reddit_hottag))
colSums(is.na(new_reddit_comments_hottag))

#remove rows with missing value in Comments dataset
new_reddit_comments_hottag <- na.omit(new_reddit_comments_hottag)
colSums(is.na(new_reddit_comments_hottag))
glimpse(new_reddit_hottag)
glimpse(new_reddit_comments_hottag)

#change NA as empty cell
new_reddit_hottag[is.na(new_reddit_hottag)] <- ""
colSums(is.na(new_reddit_hottag))

#merge title and body columns in reddit dataset
new_reddit_hottag$TEXT <- paste(new_reddit_hottag$NEW_TITLE, new_reddit_hottag$NEW_BODY)
glimpse(new_reddit_hottag)

#remove unnecessary columns
new_reddit_hottag <- select(new_reddit_hottag, -c(URL, CREATED, NEW_TITLE, NEW_BODY))
glimpse(new_reddit_hottag)
glimpse(new_reddit_comments_hottag)

#Step 3:
##save the clean data as csv file
write_excel_csv(new_reddit_hottag, "new_reddit.csv")
write_excel_csv(new_reddit_comments_hottag, "new_comments.csv")

