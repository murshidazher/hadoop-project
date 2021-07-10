# hadoop-project

> ⚠️ Under development

A list of scripts for stock market analysis. To test the job runs `http://<ip_address>:8088/cluster`

- Has `56918121` ~ `fifty-six` million records initially before pre-processing.

## Downloading Scripts

To simply download the updated scripts on terminal:

```sh
curl -L https://git.io/<slug_name> -o <file_name>

# examples
curl -L https://git.io/hdp-pig-orc -o hdp-pig-orc.pig
```

### Slugs for Scripts

The below table contains the slugs for scripts files, which can be used as `https://git.io/<slug_name>`

|            Filename            |          Slug           |                           Description                            |
| :----------------------------: | :---------------------: | :--------------------------------------------------------------: |
| NormalizeStocksDatasetORC.pig  |      `hdp-pig-orc`      | Contains the script for generating an `ORC` based stock dataset. |
| NormalizeStocksDatasetText.pig |      `hdp-pig-txt`      | Contains the script for generating a `text` based stock dataset. |
|      LoadingStocksORC.sql      |   `hdp-stocks-db.sql`   |               Hive query for `stocks_db` creation.               |
| LoadingOptimizedStocksORC.sql  | `hdp-stocks-db-opt.sql` |   Hive query for `stocks_db` creation with hive optimisations.   |

### Download the Files

- [orc files](https://downgit.github.io/#/home?url=https://github.com/murshidazher/hdp-stocks-scripts/tree/main/warehouse/file-format/orc)
- [txt files](https://downgit.github.io/#/home?url=https://github.com/murshidazher/hdp-stocks-scripts/tree/main/warehouse/file-format/text)

## Working with HDFS

Create the folder structure in local and in hdfs too using,

```sh
mkdir -p hw-workspace/input/warehouse/stock_dataset/file-formats/text && \
mkdir -p hw-workspace/input/warehouse/stock_dataset/file-formats/orc && \
mkdir -p hw-workspace/input/stocks-dataset

cd hw-workspace && \
git clone https://github.com/murshidazher/hdp-stocks-scripts.git

# [setup kaggle](https://github.com/Kaggle/kaggle-api)
cd hw-workspace/input/stock_dataset && \
kaggle datasets download hk7797/stock-market-india && \
unzip stock-market-india.zip && \
mv FullDataCsv/master.csv .

hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/stocks-dataset/FullDataCsv && \
hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats && \
hadoop fs -copyFromLocal ~/hw-workspace/input/stocks-dataset/FullDataCsv/* hw-workspace/input/stocks-dataset/FullDataCsv/ && \
hadoop fs -copyFromLocal ~/hw-workspace/input/stocks-dataset/master.csv hw-workspace/input/stocks-dataset/

> hdfs dfs -ls hw-workspace/input/stocks-dataset/ # check files
```

Remove the output folders before script execution,

```sh
hadoop fs -rm -r /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text && \
hadoop fs -rm -r /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc
```

Get the latest scripts,

```
cd /home/maria_dev/hw-workspace/hdp-stocks-scripts && \
git pull
```

Execute the pig script

```sh
> pig ~/hw-workspace/hdp-stocks-scripts/scripts/pig/NormalizeStocksDatasetText.pig
> pig ~/hw-workspace/hdp-stocks-scripts/scripts/pig/NormalizeStocksDatasetORC.pig
```

Create Hive table

```sh
> hive -f ~/hw-workspace/hdp-stocks-scripts/scripts/hive/LoadingStocksORC.sql
```

Basic Script Structure

```sh
cd /home/maria_dev/hw-workspace/hdp-stocks-scripts && \
git pull

cd /home/maria_dev/hw-workspace/hdp-stocks-scripts/scripts/pig
cd /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text

hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/part-v004-o000-r-00000
```

## Viewing

To view the processed outputs,

```sh
> hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text
> hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/part-v003-o000-r-00000
```

```sh
hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc
hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc/part-v003-o000-r-00000
```

## Download to Local

To download the file to local file system,

```sh
> cd /home/maria_dev/hw-workspace/output/pig
> hadoop fs -copyToLocal /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc/* ./orc/
> hadoop fs -copyToLocal /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/* ./text/
```

## Size Comparisons

To perform size comparions among files,

```sh
hadoop fs -du -s -h /user/maria_dev/hw-workspace/input/stocks-dataset/FullDataCsv # FullDataCsv filesize
hadoop fs -ls -h /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text # text filesize
hadoop fs -ls -h /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc # orc filesize
```

kalbi platform
cmu swing modules to process speech

### Hadoop commands

For basic hadoop commands,

```sh
Usage: hadoop fs -ls [-d] [-h] [-R] [-t] [-S] [-r] [-u] <args>

Options:
-d: Directories are listed as plain files.
-h: Format file sizes in a human-readable fashion (eg 64.0m instead of 67108864).
-R: Recursively list subdirectories encountered.
-t: Sort output by modification time (most recent first).
-S: Sort output by file size.
-r: Reverse the sort order.
-u: Use access time rather than modification time for display and sorting.
```
