# Performance Optimizations to Look into

- Hive `SORT BY` sorts the record globally hence it will only allocate one reducer, we can increase this amount to leverage a higer Performance

```
hive> SET mapreduce.job.reduces=3;
hive> USE stocks_db;
hive> SELECT * FROM stocks
ORDER BY price_close DESC;
```

The solution is to use `SORT BY` which will use number of reducers we specify,

```sh
hive> SELECT ymd, symbol, price_close
FROM stocks WHERE year(ymd) = '2003'
SORT BY symbol ASC, price_close DESC;

# this is so that we can analyze the output of the execution
hive> INSERT OVERWRITE LOCAL DIRECTORY '/home/hirw/output/hive/stocks'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT ymd, symbol, price_close
FROM stocks WHERE year(ymd) = '2003'
SORT BY symbol ASC, price_close DESC;
```

Go to the local directory and review the output, we will see three files one for each reducers.

```sh
> cd /home/hirw/output/hive/stocks
> ls -ltr
# we will see three files one for each reducers.
```

The only problem is that since we use three reducers we will see that same symbol from first file appearing in the second file might appear in different files. We need to make sure that the same symbol goes to same reducer, to do this we need to use `DISTRIBUTE BY` along with `SORT BY`. We need to specify the **key** by which it should be distributed.

```sh
hive> INSERT OVERWRITE LOCAL DIRECTORY '/home/hirw/output/hive/stocks'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT ymd, symbol, price_close
FROM stocks WHERE year(ymd) = '2003'
DISTRIBUTE BY symbol
SORT BY symbol ASC, price_close DESC;
```

To search the keyword in vim type `:/` and word to search like `:/b3b`.

```sh
> cd /home/hirw/output/hive/stocks
> ls -ltr
> vi 0000_0
```

Finally, if we've `SORT BY` and `DISTRIBUTE BY` with the same column, in this exmaple `symbol`. Then we can replace those two lines with `CLUSTER BY`. Both queries are the same.

```sh
hive> SELECT ymd, symbol, price_close
FROM stocks
DISTRIBUTE BY symbol
SORT BY symbol ASC;

# we can convert the above code to this
hive> INSERT OVERWRITE LOCAL DIRECTORY '/home/hirw/output/hive/stocks'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT ymd, symbol, price_close
FROM stocks
CLUSTER BY symbol;
```

### Partition

> Look for shell commands [here](hive/scripts/hiveql-partitions.q).

Have you ever been in a situation where you want to optimize a slow running query ? if you think it will super fast if it aims specifically for a set of data than the entire dataset. In this case what you need is a partition.

Lets say we need to query the stocks table to see the stocks for symobl `XYZ` for year `2000`. Even though as a user you are only interested in a specific symbol and year.

```sh
# but this will traverse the ENTIRE dataset and brings the result
hive> SELECT * FROM stocks
WHERE symbol = 'XYZ' and ymd = '2000-07-03';
```

Wouldnt it be so nice to target the queries to scan only the records with symbol `XYZ`. There is a way to exactly to do this that is using `PARTITIONS` in hive.

We need to mention a new name for the patition column

```sh
# table is partitioned by sym
hive> USE stocks_db;
hive> CREATE TABLE IF NOT EXISTS stocks_partition (
exch STRING,
symbol STRING,
ymd STRING,
price_open FLOAT,
price_high FLOAT,
price_low FLOAT,
price_close FLOAT,
volume INT,
price_adj_close FLOAT)
PARTITIONED BY (sym STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

hive> DESCRIBE FORMATTED stocks_partition;
```

Now to load data into the partitioned table is little different from loading a normal table; We're selecting all the records `B7J` and loading them.

```sh
hive> INSERT OVERWRITE TABLE stocks_partition
PARTITION (sym = 'B7J')
SELECT * FROM stocks s
WHERE s.symbol = 'B7J';

hive> INSERT OVERWRITE TABLE stocks_partition
PARTITION (sym = 'BB3')
SELECT * FROM stocks s
WHERE s.symbol = 'BB3';
```

#### Details on the partitions

To see the list of partitions in the table;

```sh
hive> SHOW PARTITIONS stocks_partition;
hive> DESCRIBE FORMATTED stocks_partition;
hive> !hadoop fs -ls /user/hive/warehouse/stocks_db.db/stocks_partition;
hive> !hadoop fs -ls /user/hive/warehouse/stocks_db.db/stocks_partition/sym=B7J;
```

#### Querying the data

Now wehn use execute the SELECT query with the `sym` on partitioned table it will run the mapreduce job only on the specified folder.

```sh
# SELECT with partition column in the where clause
hive> SELECT * FROM stocks_partition
WHERE sym='B7J';
```

We can also load a partition from a hdfs location, this will create a folder called `stocks-zuu` and insert all the selected records to it.

```sh
# Extract only CBZ records in to a directory
hive> INSERT OVERWRITE DIRECTORY 'output/hive/stocks-zuu'
SELECT *
FROM stocks WHERE symbol='ZUU';
```

Now we can load that extracted data using the `ALTER` command,

```sh
hive> ALTER TABLE stocks_partition ADD IF NOT EXISTS
PARTITION (sym = 'ZUU') LOCATION 'output/hive/stocks-zuu';
```

Hive will not validate the data loaded into the paritions hence we should make sure that we dont load any incorrect data. So its developer's responsibility to validate it.

```sh
# this is incorrect loading microsoft stocks into apple partitions
hive> INSERT OVERWRITE TABLE stocks_partition
PARTITION (sym = 'APPL')
SELECT * FROM stocks s
WHERE s.symbol = 'MSFT';
```

### Enable Dynamic Parition

> Paritions minimize the query execution time and its very powerful.

So far we've been giving the records for the partitions, so when we use dynamic partitions the partitions values will be know at exection time.

```sh
hive> SET hive.exec.dynamic.partition=true; # enable the dynamic partitions first

hive> INSERT OVERWRITE TABLE stocks_partition
PARTITION (sym)
SELECT s.*, s.symbol
FROM stocks s;

# this will give you an exection by default hive dynamic partition mode is set to strict - we need atleast one partition need to be given
```

But this will lead to security vulnerabilities in hive,

```sh
# Setting dynamic partition mode to nonstrict. Property is strict by default
hive> SET hive.exec.dynamic.partition.mode=nonstrict;
```

An alternative would be to create another table,

```sh
# Table with 3 partition columns - exch_name, yr, sym
hive> CREATE TABLE IF NOT EXISTS stocks_dynamic_partition (
exch STRING,
symbol STRING,
ymd STRING,
price_open FLOAT,
price_high FLOAT,
price_low FLOAT,
price_close FLOAT,
volume INT,
price_adj_close FLOAT)
PARTITIONED BY (exch_name STRING, yr STRING, sym STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

hive> DESCRIBE FORMATTED stocks_dynamic_partition;
```

#### Dyanimc Parition Insert

```sh
hive> INSERT OVERWRITE TABLE stocks_dynamic_partition
PARTITION (exch_name='ABCSE', yr, sym)
SELECT *, year(ymd), symbol
FROM stocks;

hive> INSERT OVERWRITE TABLE stocks_dynamic_partition
PARTITION (exch_name='ABCSE', yr, sym)
SELECT *, year(ymd), symbol
FROM stocks WHERE year(ymd) IN ('2001', '2002', '2003') and symbol like 'B%';
```

We might get an error that is number of partitions allowed per node is less than number of partitions we're trying to create which is by default set to `100`.

```sh
--Set the number of partitions per node.
hive> SET hive.exec.max.dynamic.partitions=1000;
hive> SET hive.exec.max.dynamic.partitions.pernode=500; # how many partitions allowed per node
```

When a partition mode is set to strict it wont let you execute it without mentioning the partition in where clause. Since the

```sh
# Property to control Hive's mode
hive> SET hive.mapred.mode=strict;

# since this query is assumed risky because we didnt specify a partition in the where clause for filtering
hive> SELECT * FROM stocks_dynamic_partition
WHERE volume > 10000;
```

### Buckets

> Look for shell commands [here](hive/scripts/hiveql-buckets.q). We will get a constant number of buckets than too many files and tiny files created using a partition.

In this we will see couple of potentital problems we will encounter with partions and especially with dynamic partitions and how to address them with buckets.

There are too many paritions under each year and tiny partitions are also available. We also know that dealing with tiny partitions is not ideal with hadoop. We may argue that symbol is not the best column to partition under but never the less.

```sh
hive> !hadoop fs -ls /user/hive/warehouse/stocks_db.db/stocks_dynamic_partition/exch_name=ABCSE/yr=2003/sym=BUB;
```

We will be using `BUCKETS`; what the below command means is that we will partion by exchange name and year and store the records for the year under 5 buckets five files. Each symbol will fall under a bucket using a hash function and all the files for that bucket will be stored under the file for the assumed bucket.

```sh
hive> CREATE TABLE IF NOT EXISTS stocks_bucket (
exch STRING,
symbol STRING,
ymd STRING,
price_open FLOAT,
price_high FLOAT,
price_low FLOAT,
price_close FLOAT,
volume INT,
price_adj_close FLOAT)
PARTITIONED BY (exch_name STRING, yr STRING)
CLUSTERED BY (symbol) INTO 5 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
```

We can do a describe command and see the number of buckets under the `Storage Information` section.

```sh
hive> DESCRIBE FORMATTED stocks_bucket;
hive> !hadoop fs -ls /user/hive/warehouse/stocks_db.db/stocks_bucket;
```

When inserting we need to make sure that we enfore the bucketing

```sh
hive> SET hive.exec.dynamic.partition=true;

# Set number of partitions per node
hive> SET hive.exec.max.dynamic.partitions=15000;
hive> SET hive.exec.max.dynamic.partitions.pernode=15000;

hive> SET hive.enforce.bucketing = true;
```

Now that all properties are set we can execute the dynamic inserts, you will see the number of reducers will be `5` the same as number of buckets.

```sh
hive> INSERT OVERWRITE TABLE stocks_bucket
PARTITION (exch_name='ABCSE', yr)
SELECT *, year(ymd)
FROM stocks WHERE year(ymd) IN ('2001', '2002', '2003') and symbol like 'B%';
```

#### Sampling

This is used when we dont want to query the entire table and only execute it in a subsection of the table by random sampling.

```sh
# Table sampling with out buckets
# since stocks table is not bucketed it needs to randomly assign it, the table needs to scan the entire table to return three buckets since its not bucketed
# this is time expensive
hive> SELECT *
FROM stocks TABLESAMPLE(BUCKET 3 OUT OF 5 ON symbol) s;

#Table sampling with buckets
# we're sampling on a bucketized table.
hive> SELECT *
FROM stocks_bucket TABLESAMPLE(BUCKET 3 OUT OF 5 ON symbol) s;
```

## Optimizations

#### Sort Merge Bucket (SMB) Join

So far we've been seeing joins with regular tables and lets see what kind of benifits we get with bucketed tables. When you have tables which are sorted and bucketed, hive can perform a faster map side merge join. This type of join is called `SMB` join. However, your join should meet the following criteria.

1. all join table must be bucketized
2. number of buckets of the big table must be perfectly divisible by the buckets in the small table.
3. bucket column in the table and join columns in the query must be one and the same.
4. the properties must be set to enable smb

<img src="./docs/60.png">

Lets create two table `stocks_smb` and `dividends_smb`,

```sh
--Enable bucketing
hive> SET hive.enforce.bucketing = true;

### Create stocks table
# bucket it based on symbol and sort it based on symbol

--Create stocks_smb table with 10 buckets. Bucket the table based on symbol column and also sort by symbol column.
hive> CREATE TABLE IF NOT EXISTS stocks_smb (
exch STRING,
symbol STRING,
ymd STRING,
price_open FLOAT,
price_high FLOAT,
price_low FLOAT,
price_close FLOAT,
volume INT,
price_adj_close FLOAT)
CLUSTERED BY (symbol) SORTED BY (symbol) INTO 10 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
--Create dividends_smb table with 5 buckets. Bucket the table based on symbol column and also sort by symbol column.
hive> CREATE TABLE IF NOT EXISTS dividends_smb (
exch STRING,
symbol STRING,
ymd STRING,
dividend FLOAT
)
CLUSTERED BY (symbol) SORTED BY (symbol) INTO 5 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

hive> INSERT OVERWRITE TABLE stocks_smb
SELECT * FROM stocks;

# if we do a ls on the location we will see 10 files
hive> !hadoop fs -ls /user/hirw/warehouse/stocks_db.db/stocks_smb

hive> INSERT OVERWRITE TABLE dividends_smb
SELECT * FROM dividends;

# if we do a ls on the location we will see 5 files
hive> !hadoop fs -ls /user/hirw/warehouse/stocks_db.db/dividends_smb
```

> 💡 We see that the number of buckets in the big table is perfectly divisible by number of buckets in the small table. `10/5 = 2`

Now, since all the tables are loaded, sorted and bucketized. Lets make sure that all the criterias are met for SMB.

```sh
hive> SET hive.auto.convert.sortmerge.join=true;
hive> SET hive.optimize.bucketmapjoin = true;
hive> SET hive.optimize.bucketmapjoin.sortedmerge = true;
hive> SET hive.auto.convert.sortmerge.join.noconditionaltask=true;
```

```sh
hive> SELECT s.exch, s.symbol, s.ymd, s.price_close, d.dividend
FROM stocks_smb s INNER JOIN dividends_smb d
ON s.symbol = d.symbol;
```

First the big table is loaded, since there are 10 buckets 10 mappers are spawned. Since the buckets are already sorted and only the matching records are considered this job is entirely performed on map side enabling a much faster execution time.
