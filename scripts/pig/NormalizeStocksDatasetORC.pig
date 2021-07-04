REGISTER '/usr/hdp/2.6.5.0-292/pig/piggybank.jar';
REGISTER '/usr/hdp/2.6.5.0-292/pig/piggybank.jar';

-- NormalizeStocksDataset to a single dataset with the required columns
collection_data =   LOAD '/user/maria_dev/hw-workspace/input/stocks-dataset/FullDataCsv/HCLTECH__EQ__NSE__NSE__MINUTE.csv' 
                USING PigStorage(',', '-tagFile') 
                AS (filepath:chararray, timestamp: chararray, open:float, high:float, low:float, close:float, volume: int);

collection_data =   FILTER collection_data BY $2 IS NOT NULl;

collection_data = FOREACH collection_data GENERATE
                (chararray) SUBSTRING(filepath, 0, INDEXOF(filepath, '.', 0)) AS filename,
                ToDate(SUBSTRING(timestamp, 0, INDEXOF(timestamp, ' ', 0)), 'yyyy-MM-dd') AS (date:datetime),
                open, high, low, close, volume;

per_day_stock = GROUP collection_data BY (filename, date);

stocks =        FOREACH per_day_stock GENERATE
                FLATTEN(group) AS (filename, date),
                MAX(collection_data.open) AS open,
                MAX(collection_data.high) AS high,
                MIN(collection_data.low) AS low,
                MAX(collection_data.close) AS close,
                MAX(collection_data.volume) AS volume,
                ROUND_TO(AVG(collection_data.close),2) AS adj_close;

-- LOAD master file for get the symbol and exchange
master_data =   LOAD '/user/maria_dev/hw-workspace/input/stocks-dataset/master.csv'
                USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER')
                AS (
                    symbol:chararray, 
                    name:chararray, 
                    instrument_type:chararray, 
                    segment:chararray, 
                    exchange:chararray, 
                    data_type: chararray, 
                    key:chararray,  
                    from:datetime, 
                    to:datetime
                );

-- JOIN stock file
-- Implement a Fragment Replicated join for optimizations
join_left   =   JOIN stocks BY filename LEFT OUTER, master_data BY key USING 'REPLICATED';

-- Filter out records without a master data
filter_left_join =  FILTER join_left BY $0 IS NOT NULL;

-- Aggregate the files with only required fileds
aggregate_table =   FOREACH filter_left_join GENERATE
                    exchange, symbol, 
                    date, open, high, low, close, volume, adj_close;

-- Save as an ORC file
-- More information can be found [here](http://pig.apache.org/docs/r0.14.0/func.html#OrcStorage)
STORE aggregate_table INTO '/user/maria_dev/hw-workspace/input/warehouse/stock_dataset/file-formats/orc' USING OrcStorage();