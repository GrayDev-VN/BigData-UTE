CREATE DATABASE IF NOT EXISTS retail_warehouse;
USE retail_warehouse;

CREATE TABLE IF NOT EXISTS sales_records (
    order_id INT,
    customer_name STRING,
    product STRING,
    category STRING,
    quantity INT,
    price DOUBLE,
    order_date STRING,
    city STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
tblproperties('skip.header.line.count'='1');

LOAD DATA LOCAL INPATH '/home/hadoop/shared_data/sales_data.csv' OVERWRITE INTO TABLE sales_records;
