SELECT  COUNT(*) FROM okibaba-data-engineering.ny_taxi.external_green_tripdata_2022;

SELECT DISTINCT(PULocationID) FROM okibaba-data-engineering.ny_taxi.external_green_tripdata_2022;

SELECT DISTINCT(PULocationID) FROM okibaba-data-engineering.ny_taxi.non_partitioned_green_tripdata_2022;

SELECT count(*) FROM okibaba-data-engineering.ny_taxi.external_green_tripdata_2022
WHERE fare_amount=0;