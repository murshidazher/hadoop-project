# hadoop-project

> ⚠️ Under development

A list of scripts for stock market analysis. To test the job runs `http://<ip_address>:8088/cluster`

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

## Working with HDFS

Folder structure

```sh
cd /home/maria_dev/hw-workspace/hdp-stocks-scripts && \
git pull

cd /home/maria_dev/hw-workspace/hdp-stocks-scripts/scripts/pig
cd /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text

hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/part-v004-o000-r-00000
```

Remove the folders,

```sh
hadoop fs -rm -r /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text && \
hadoop fs -rm -r /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc
```

To view a folder,

```sh
hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text
```

```sh
pig NormalizeStocksDatasetText.pig
```

## ORC file

```sh
pig NormalizeStocksDatasetORC.pig
```

## Viewing

```sh
> hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text
> hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/part-v003-o000-r-00000
```

```sh
hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc
hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc/part-v003-o000-r-00000
```

## Download to Local

```sh
> cd /home/maria_dev/hw-workspace/output/pig
> hadoop fs -copyToLocal /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc/* ./orc/
> hadoop fs -copyToLocal /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/* ./text/
```

## Size Comparisons

```sh
hadoop fs -du -s -h /user/maria_dev/hw-workspace/input/stocks-dataset/FullDataCsv # FullDataCsv filesize
hadoop fs -ls -h /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text # text filesize
hadoop fs -ls -h /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc # orc filesize
```

## Run Hive Scripts

```sh
cd /home/maria_dev/hw-workspace/scripts/hive && \
rm -rf LoadingStocksORC.sql && \
nano LoadingStocksORC.sql && \
hive -f LoadingStocksORC.sql
```

All the neceddary jar libraries would be loaded to,

```sh
> cd /usr/lib/external/pig
> cd /usr/lib/external/hive
```

Create the folder structure in local and in hdfs too using,

```sh
> hadoop fs -mkdir hw-workspace/input/stocks-dataset/FullDataCsv
> hdfs dfs -mv hw-workspace/input/stocks-dataset/FullDataCsv/master.csv hw-workspace/input/stocks-dataset/
> hdfs dfs -ls
```

Move the CSV dataset to hadoop,

```sh
> hadoop fs -copyFromLocal ~/hw-workspace/input/stocks-dataset/FullDataCsv/* hw-workspace/input/stocks-dataset/FullDataCsv
```

kalbi platform
cmu swing modules to process speech

### Hadoop commands

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
