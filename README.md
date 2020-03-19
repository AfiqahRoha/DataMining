## Project title: Text mining on customer feedbacks of different laptop brands.

My friend and I aim to do an analysis of customer feedbacks of different laptop brands such as Apple, Dell, Asus, Acer and Lenovo by using data from social media. In this Github you will be able to see our progress to achieve that objective. There are a total of five milestones for this project.

#### Milestone 1 - Web scraping the data

We crawl data from social media such as Reddit to get an insight on laptop users' opinions about popular laptop brands. The following information is for those who are unfamiliar with Reddit:
> Reddit is a social news aggregation, web content rating, and discussion website. Registered members submit content to the site such as links, text posts, and images, which are then voted up or down by other members. Posts are organized by subject into user-created boards called "subreddits", which cover a variety of topics. Submissions with more up-votes appear towards the top of their subreddit and, if they receive enough up-votes, ultimately on the site's front page. (source: Wikipedia)

The Subreddits that we scraped are
- r/SuggestALaptop
- r/mac
- r/Dell
- r/ASUS
- r/thinkpad
- r/AcerOfficial

There are two datasets from Reddit that we have scraped. The first one is on Subreddits posts from the hot tag. Another one is from the comments under those posts. The first dataset has 8 attributes which are *title*, *score*, *id*, *subreddit*, *url*, *num_comments*, *body*, *created*.
