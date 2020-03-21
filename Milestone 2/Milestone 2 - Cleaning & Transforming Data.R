library(plyr)  
library(dplyr)
library(tidytext)
library(stringr)
library(readr)
library(tm)

getwd()
#import data
reddit_hottag <- read.csv("reddit_hottag.csv", stringsAsFactors=FALSE)
glimpse(reddit_hottag)
reddit_comments_hottag <- read.csv("reddit_comments_hottag.csv", stringsAsFactors=FALSE)
glimpse(reddit_comments_hottag)
#remove warnings
options(warn = -1)

##step 1
##Data Collection and Insight
##Reddit hot tag
reddit_hottag <- reddit_hottag %>%
  lapply(iconv, to = 'ASCII//TRANSLIT')
reddit_hottag <- as.data.frame(do.call(cbind, reddit_hottag))
##Reddit comments hot tag
reddit_comments_hottag <- reddit_comments_hottag %>%
  lapply(iconv, to = 'ASCII//TRANSLIT')
reddit_comments_hottag <- as.data.frame(do.call(cbind, reddit_comments_hottag))
##glimpse all dataframe
glimpse(reddit_hottag)
glimpse(reddit_comments_hottag)

##step 2
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

#remove hashtag symbol
hashtagRemover <- function(x) gsub("#", "", x, perl = TRUE)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(hashtagRemover))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(hashtagRemover))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(hashtagRemover))

#remove username 
usernameRemover <- function(x) gsub("@\\S+", "", x, perl = TRUE)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(usernameRemover))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(usernameRemover))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(usernameRemover))

#remove &amp symbol
symbolRemover <- function(x) gsub("&amp;", "", x)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(symbolRemover))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(symbolRemover))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(symbolRemover))

#remove punctuations
removePunct <- function(x) gsub("[[:punct:]]", " ", x, perl = TRUE)
reddit_hottag_title <- tm_map(reddit_hottag_title, content_transformer(removePunct))
reddit_hottag_body <- tm_map(reddit_hottag_body, content_transformer(removePunct))
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, content_transformer(removePunct))

#remove profane words
linkbadwords <-"https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en"
if (!file.exists("en_bws.txt")){download.file(linkbadwords, destfile="en_bw.txt")}
linkbadwords <-"https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt"
if (!file.exists("list.txt")){download.file(linkbadwords, destfile="list_bw.txt")}
bwdat <- read.table("en_bw.txt", header = FALSE, sep = "\n", strip.white = TRUE)
bwdat_2 <- read.table("list_bw.txt", header = FALSE, sep = "\n", strip.white = TRUE)
names(bwdat) <- "Bad Words"
names(bwdat_2) <- "Bad Words"
reddit_hottag_title <- tm_map(reddit_hottag_title, removeWords, bwdat[,1])
reddit_hottag_title <- tm_map(reddit_hottag_title, removeWords, bwdat_2[,1])
reddit_hottag_body <- tm_map(reddit_hottag_body, removeWords, bwdat[,1])
reddit_hottag_body <- tm_map(reddit_hottag_body, removeWords, bwdat_2[,1])
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, removeWords, bwdat[,1])
reddit_comments_hottag_corpus <- tm_map(reddit_comments_hottag_corpus, removeWords, bwdat_2[,1])

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

##remove the pound symbol in reddit comments dataframe
##for reddit hot tag dataframe
new_reddit_hottag[,8] <- as.character(gsub("???T", "", as.matrix(new_reddit_hottag[,8])))
new_reddit_hottag[,8] <- as.character(gsub("???", "", as.matrix(new_reddit_hottag[,8])))
new_reddit_hottag[,9] <- as.character(gsub("???T", "", as.matrix(new_reddit_hottag[,9])))
new_reddit_hottag[,9] <- as.character(gsub("???", "", as.matrix(new_reddit_hottag[,9])))
##for reddit comments hot tag dataframe
new_reddit_comments_hottag[,2] <- as.character(gsub("???T", "", as.matrix(new_reddit_comments_hottag[,2])))
new_reddit_comments_hottag[,2] <- as.character(gsub("???", "", as.matrix(new_reddit_comments_hottag[,2])))

#Step 3:
##save the clean data as csv file
write.csv(new_reddit_hottag, "clean_reddit_hottag.csv")
write.csv(new_reddit_comments_hottag, "clean_reddit_comments_hottag.csv")

