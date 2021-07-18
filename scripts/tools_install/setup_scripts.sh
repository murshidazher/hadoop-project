# bin/bash

mkdir -p hw-workspace/input/warehouse/stock_dataset/file-formats/text &&
  mkdir -p hw-workspace/input/warehouse/stock_dataset/file-formats/orc &&
  mkdir -p hw-workspace/input/stocks-dataset

cd hw-workspace &&
  git clone https://github.com/murshidazher/hdp-stocks-scripts.git

hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats

hadoop fs -mkdir -p /user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc

hadoop fs -copyFromLocal ~/hw-workspace/hdp-stocks-scripts/warehouse/file-format/orc/* hw-workspace/input/stocks-dataset/file-formats/orc/

hive -f ~/hw-workspace/hdp-stocks-scripts/scripts/hive/LoadingStocksORC.sql
