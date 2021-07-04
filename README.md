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

```sh
> hadoop fs -ls /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text
> hadoop fs -cat /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text/part-v003-o000-r-00000
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
