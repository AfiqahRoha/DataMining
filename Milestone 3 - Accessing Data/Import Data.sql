CREATE DATABASE reddit_db;

USE reddit_db;

CREATE TABLE reddit (
	score INT NOT NULL,
    id VARCHAR(255) NOT NULL,
    subreddit VARCHAR(255) NOT NULL,
    num_comments INT NOT NULL,
    time_date TIMESTAMP NOT NULL,
    time_of_day VARCHAR(255) NOT NULL,
    text_value TEXT NOT NULL,
    PRIMARY KEY(id)
);

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/new_reddit.csv'
INTO TABLE reddit
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM reddit;

CREATE DATABASE comments_db;

USE comments_db;

CREATE TABLE comments (
    id VARCHAR(255) NOT NULL,
    subreddit VARCHAR(255) NOT NULL,
    new_comments TEXT NOT NULL
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/new_comments.csv'
INTO TABLE comments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM comments;

CREATE DATABASE twitter_db;

USE twitter_db;

CREATE TABLE twitter (
	time_date TIMESTAMP NOT NULL,
    model VARCHAR(255) NOT NULL,
    text_value TEXT NOT NULL,
    time_of_day VARCHAR(255) NOT NULL
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/new_twitter.csv'
INTO TABLE twitter
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM twitter;

