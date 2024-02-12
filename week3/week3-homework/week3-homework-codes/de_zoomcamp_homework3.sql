DROP TABLE IF EXISTS `okibaba-data-engineering.ny_taxi.external_green_tripdata_2022`;
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `okibaba-data-engineering.ny_taxi.external_green_tripdata_2022`
OPTIONS (
  format = 'parquet',
  uris = [
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_01.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_02.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_03.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_04.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_05.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_06.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_07.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_08.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_09.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_10.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_11.parquet',
    'gs://okibaba-zoomcamp-hw3/green/2022/green_tripdata_2022_12.parquet'
    ]
);



CREATE OR REPLACE TABLE `okibaba-data-engineering.ny_taxi.non_partitioned_green_tripdata_2022`
AS SELECT * FROM `okibaba-data-engineering.ny_taxi.external_green_tripdata_2022`;


--create table with date time type, by updating original table
CREATE OR REPLACE TABLE `okibaba-data-engineering.ny_taxi.corrected_green_tripdata_2022` AS
SELECT
  VendorID,
  TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 AS INT64)) AS lpep_pickup_datetime, -- Convert nanoseconds to TIMESTAMP
  TIMESTAMP_MICROS(CAST(lpep_dropoff_datetime / 1000 AS INT64)) AS lpep_dropoff_datetime, -- Convert nanoseconds to TIMESTAMP
  CAST(passenger_count AS FLOAT64) AS passenger_count,
  trip_distance,
  CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  PULocationID,
  DOLocationID,
  payment_type,
  fare_amount,
  extra,
  mta_tax,
  tip_amount,
  tolls_amount,
  improvement_surcharge,
  total_amount,
  congestion_surcharge,
  trip_type,
  ehail_fee

FROM `okibaba-data-engineering.ny_taxi.external_green_tripdata_2022`;




SELECT  COUNT(*) FROM okibaba-data-engineering.ny_taxi.external_green_tripdata_2022;

SELECT DISTINCT(PULocationID) FROM okibaba-data-engineering.ny_taxi.external_green_tripdata_2022;

SELECT DISTINCT(PULocationID) FROM okibaba-data-engineering.ny_taxi.non_partitioned_green_tripdata_2022;

SELECT count(*) FROM okibaba-data-engineering.ny_taxi.external_green_tripdata_2022
WHERE fare_amount=0;


-- Creating a partition and cluster table
CREATE OR REPLACE TABLE okibaba-data-engineering.ny_taxi.PU_partitoned_clustered_green_tripdata_2022
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID  AS
SELECT * FROM okibaba-data-engineering.ny_taxi.corrected_green_tripdata_2022;


SELECT DISTINCT PULocationID
FROM `okibaba-data-engineering.ny_taxi.partitoned_clustered_green_tripdata_2022`
WHERE lpep_pickup_datetime >= '2022-06-01' AND lpep_pickup_datetime <= '2022-06-30';


SELECT DISTINCT PULocationID
FROM `okibaba-data-engineering.ny_taxi.corrected_green_tripdata_2022`
WHERE lpep_pickup_datetime >= '2022-06-01' AND lpep_pickup_datetime <= '2022-06-30';
