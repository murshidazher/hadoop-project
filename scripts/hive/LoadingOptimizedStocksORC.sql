-- load the tables
DROP DATABASE IF EXISTS stocks_db CASCADE;

-- create a new table from scratch
CREATE DATABASE stocks_db;

USE stocks_db;

-- Create externally managed table
CREATE EXTERNAL TABLE IF NOT EXISTS stocks (
exch STRING,
symbol STRING,
ymd TIMESTAMP,
price_open FLOAT,
price_high FLOAT,
price_low FLOAT,
price_close FLOAT,
volume INT,
price_adj_close FLOAT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS orc -- SerDe as ORC
LOCATION '/user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc'
TBLPROPERTIES (
    'creator'='murshidazher', 
    'created_on' = '2021-07-05', 
    'description'='This table contains all stock data from 2017 until 2021.'
);

DESCRIBE FORMATTED stocks_db.stocks;

-- example select query
SELECT * FROM stocks
LIMIT 10;

-- add bucketing and more optimizations resolves for faster query execution time