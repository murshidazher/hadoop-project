import pandas as pd
from pyspark import SparkConf, SparkContext
from pyspark.sql import HiveContext

conf = (SparkConf().set("spark.kryoserializer.buffer.max", "512m"))

sc.stop()
sc = SparkContext(conf=conf)
#sc = SparkContext()
sqlContext = SQLContext.getOrCreate(sc)

# Create a Hive Context

hive_context = HiveContext(sc)

print("Reading Hive table…")
sparkdf = hive_context.sql("SELECT * FROM stocks_db.stocks")

print("Registering DataFrame as a table…")

sparkdf.show() # Show first rows of dataframe

sparkdf.printSchema()

sparkdf.limit(10).toPandas().head(3)