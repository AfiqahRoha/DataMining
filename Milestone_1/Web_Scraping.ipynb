{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Acquisition of Data from Reddit\n",
    "### Using web crawling method"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Import Libraries\n",
    "# PRAW is a Python wrapper for the Reddit API\n",
    "# Pandas is for creating dataframe\n",
    "\n",
    "import praw          \n",
    "import pandas as pd"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Authentication process from Reddit\n",
    "# Required Client_id, Client_secret and user_agent\n",
    "\n",
    "reddit = praw.Reddit(client_id=\"Eo_DjUw2l7iIog\", \n",
    "                     client_secret=\"7rQQlaoThKY982iPhMAtCfwzg8Y\", \n",
    "                     user_agent=\"DataMining\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Selected trendy subreddits for laptop brands\n",
    "\n",
    "# 1) r/SuggestALaptop\n",
    "# 2) r/mac\n",
    "# 3) r/Dell\n",
    "# 4) r/ASUS\n",
    "# 5) r/thinkpad\n",
    "# 6) r/AcerOfficial"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Scraping from subreddits"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "metadata": {},
   "outputs": [],
   "source": [
    "posts1 = []\n",
    "ml_subreddit = reddit.subreddit('SuggestALaptop')\n",
    "for post in ml_subreddit.hot(limit=2000):\n",
    "    posts1.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])\n",
    "posts1 = pd.DataFrame(posts1,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "metadata": {},
   "outputs": [],
   "source": [
    "posts2 = []\n",
    "ml_subreddit = reddit.subreddit('mac')\n",
    "for post in ml_subreddit.hot(limit=2000):\n",
    "    posts2.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])\n",
    "posts2 = pd.DataFrame(posts2,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "metadata": {},
   "outputs": [],
   "source": [
    "posts3 = []\n",
    "ml_subreddit = reddit.subreddit('Dell')\n",
    "for post in ml_subreddit.hot(limit=2000):\n",
    "    posts3.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])\n",
    "posts3 = pd.DataFrame(posts3,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "metadata": {},
   "outputs": [],
   "source": [
    "posts4 = []\n",
    "ml_subreddit = reddit.subreddit('ASUS')\n",
    "for post in ml_subreddit.hot(limit=2000):\n",
    "    posts4.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])\n",
    "posts4 = pd.DataFrame(posts4,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "metadata": {},
   "outputs": [],
   "source": [
    "posts5 = []\n",
    "ml_subreddit = reddit.subreddit('thinkpad')\n",
    "for post in ml_subreddit.hot(limit=2000):\n",
    "    posts5.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])\n",
    "posts5 = pd.DataFrame(posts5,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "metadata": {},
   "outputs": [],
   "source": [
    "posts6 = []\n",
    "ml_subreddit = reddit.subreddit('AcerOfficial')\n",
    "for post in ml_subreddit.hot(limit=1000):\n",
    "    posts6.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])\n",
    "posts6 = pd.DataFrame(posts6,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "(5978, 8)"
      ]
     },
     "execution_count": 10,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "# Merging several dataframes\n",
    "\n",
    "df_merged = pd.concat([posts1, posts2, posts3, posts4, posts5, posts6])\n",
    "df_merged.shape"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Saving the dataframe to csv format\n",
    "\n",
    "df_merged.to_csv(r'C:\\Users\\Asus\\Desktop\\Milestone 1 - Web Scraping\\reddit.csv', index = False, header=True)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "       id  num_comments                                              title  \\\n",
      "1  ekkvox             2  /R/SuggestALaptop Stress Test Project! Submit ...   \n",
      "2  fhh9ug            14  Is an i7-9750H and GTX 1660TI Max-Q good for w...   \n",
      "3  fhgyih             2            LF Gaming Laptop in Canada (~$1500 CAD)   \n",
      "4  fhgt98             3  Searching for a laptop is overwhelming when yo...   \n",
      "5  fhl0d4             1             I need a new laptop- Please be patient   \n",
      "\n",
      "        subreddit  \n",
      "1  SuggestALaptop  \n",
      "2  SuggestALaptop  \n",
      "3  SuggestALaptop  \n",
      "4  SuggestALaptop  \n",
      "5  SuggestALaptop  \n"
     ]
    }
   ],
   "source": [
    "# Filtering the subreddits with comments\n",
    "\n",
    "df2 = df_merged[['id','num_comments', 'title','subreddit']]\n",
    "df2 = df2.loc[(df2 != 0).all(axis=1), :]\n",
    "print(df2.head())"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "(4995, 4)"
      ]
     },
     "execution_count": 13,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "df2.shape"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "(243, 4)"
      ]
     },
     "execution_count": 14,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "df2.drop(df2[df2.num_comments < 4].index, inplace=True)\n",
    "df2.shape"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Scraping threads under the subreddit topics"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Scraping the threads of comments\n",
    "\n",
    "L = []\n",
    "for i in df2['id']:\n",
    "    submission = reddit.submission(id=i)\n",
    "\n",
    "    submission.comments.replace_more(limit=0)\n",
    "    for top_level_comment in submission.comments:\n",
    "        L.append([i, top_level_comment.body])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "(1095, 2)"
      ]
     },
     "execution_count": 16,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "# Creating dataframe with attributes id and comments\n",
    "\n",
    "L = pd.DataFrame(L,columns=['id', 'comments'])\n",
    "L.shape"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Saving it to csv format\n",
    "\n",
    "L.to_csv(r'C:\\Users\\Asus\\Desktop\\Milestone 1 - Web Scraping\\reddit_comments.csv', index = False, header=True)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.4"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
