# hadoop-project

A list of scripts for stock market analysis

## Working with HDFS

Folder structure

```sh
cd /home/maria_dev/hw-workspace/scripts/pig
cd /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text

hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/part-v004-o000-r-00000
```

Remove the folders,

```sh
hadoop fs -rm /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/part-v004-o000-r-00000 && \
hadoop fs -rm /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/_SUCCESS && \
hadoop fs -rmdir /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text && \
hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text
```

or

```sh
hadoop fs -rm -r /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text && \
hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text
```

```sh
cd /home/maria_dev/hw-workspace/scripts/pig && \
rm -rf NormalizeStocksDatasetText.pig && \
nano NormalizeStocksDatasetText.pig && \
pig NormalizeStocksDatasetText.pig
```

## ORC file

```sh
cd /home/maria_dev/hw-workspace/scripts/pig && \
rm -rf NormalizeStocksDatasetORC.pig && \
nano NormalizeStocksDatasetORC.pig && \
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

## Size Comparisons

```sh
hadoop fs -ls -h /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/ # FullDataCsv filesize
hadoop fs -ls -h /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text # text filesize
hadoop fs -ls -h /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc # orc filesize
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