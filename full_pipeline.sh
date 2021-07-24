# bin/bash

sudo su -

mkdir /user/maria_dev/hw-workspace

cd /user/maria_dev/hw-workspace &&
  git clone https://github.com/murshidazher/hdp-stocks-scripts.git

# or pull the latest changes
cd /user/maria_dev/hw-workspace/hdp-stocks-scripts &&
  git pull

# delete the old dir and create a new one
rm -rf /user/maria_dev/hw-workspace/input/stock_dataset &&
  mkdir -p /user/maria_dev/hw-workspace/input/stocks-dataset

# get the newly updated kaggle dataset and arrange it
cd /user/maria_dev/hw-workspace/input/stock_dataset &&
  kaggle datasets download hk7797/stock-market-india &&
  unzip stock-market-india.zip &&
  mv FullDataCsv/master.csv .

# remove the old dataset in hdfs and update with the new one
hadoop fs -rm -rf /user/maria_dev/hw-workspace/input/stocks-dataset/FullDataCsv &&
  hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/stocks-dataset/FullDataCsv &&
  hadoop fs -copyFromLocal ~/hw-workspace/input/stocks-dataset/FullDataCsv/* hw-workspace/input/stocks-dataset/FullDataCsv/ &&
  hadoop fs -copyFromLocal ~/hw-workspace/input/stocks-dataset/master.csv hw-workspace/input/stocks-dataset/

# Remove the output folders before script execution
hadoop fs -rm -r /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/text &&
  hadoop fs -rm -r /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc

# make the folder structure
hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats

hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/stocks-dataset/file-formats/orc/

hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/stocks-dataset/file-formats/txt/

# execute preprocessing
pig ~/hw-workspace/hdp-stocks-scripts/scripts/pig/NormalizeStocksDatasetText.pig
pig ~/hw-workspace/hdp-stocks-scripts/scripts/pig/NormalizeStocksDatasetORC.pig

# execute hive
beeline -u jdbc:hive2://sandbox-hdp.hortonworks.com:10000/ -n maria_dev -f ~/hw-workspace/hdp-stocks-scripts/scripts/hive/LoadingStocksORC.hql
