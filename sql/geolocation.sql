# geospatial 
LOAD DATA LOCAL INFILE
'C:/Users/hp/Downloads/Olist/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DESCRIBE geolocation;

# imported records
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM geolocation
LIMIT 10;

# check decimal values
SELECT
    COUNT(*) AS total_records,
    SUM(geolocation_lat = ROUND(geolocation_lat, 0)) AS whole_number_latitudes,
    SUM(geolocation_lng = ROUND(geolocation_lng, 0)) AS whole_number_longitudes,
    SUM(geolocation_lat IS NULL) AS missing_latitudes,
    SUM(geolocation_lng IS NULL) AS missing_longitudes
FROM geolocation;

#coordinate ranges
SELECT
    MIN(geolocation_lat) AS min_latitude,
    MAX(geolocation_lat) AS max_latitude,
    MIN(geolocation_lng) AS min_longitude,
    MAX(geolocation_lng) AS max_longitude
FROM geolocation;

#Correct the column data types
ALTER TABLE geolocation
MODIFY COLUMN geolocation_lat DECIMAL(10,7),
MODIFY COLUMN geolocation_lng DECIMAL(10,7);

SHOW CREATE TABLE geolocation;

#actual imported values
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM geolocation
LIMIT 10;

#actual coordinate precision
SELECT
    COUNT(*) AS total_records,
    SUM(geolocation_lat = ROUND(geolocation_lat, 0))
        AS whole_number_latitudes,
    SUM(geolocation_lng = ROUND(geolocation_lng, 0))
        AS whole_number_longitudes,
    SUM(geolocation_lat IS NULL)
        AS missing_latitudes,
    SUM(geolocation_lng IS NULL)
        AS missing_longitudes
FROM geolocation;

#Identify coordinates outside Brazil
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM geolocation
WHERE
    geolocation_lat NOT BETWEEN -34 AND 6
    OR geolocation_lng NOT BETWEEN -74 AND -34
LIMIT 50;

#suspicious coordinate records
SELECT
    COUNT(*) AS total_records,

    SUM(
        geolocation_lat NOT BETWEEN -34 AND 6
        OR geolocation_lng NOT BETWEEN -74 AND -34
    ) AS outside_brazil,

    SUM(
        geolocation_lat BETWEEN -34 AND 6
        AND geolocation_lng BETWEEN -74 AND -34
    ) AS within_brazil

FROM geolocation;

#most extreme coordinate records
SELECT *
FROM geolocation
ORDER BY geolocation_lat ASC
LIMIT 10;

SELECT *
FROM geolocation
ORDER BY geolocation_lat DESC
LIMIT 10;

# Percentage of suspicious coordinates
SELECT
    COUNT(*) AS total_records,

    SUM(
        geolocation_lat NOT BETWEEN -34 AND 6
        OR geolocation_lng NOT BETWEEN -74 AND -34
    ) AS suspicious_records,

    ROUND(
        100.0 * SUM(
            geolocation_lat NOT BETWEEN -34 AND 6
            OR geolocation_lng NOT BETWEEN -74 AND -34
        ) / COUNT(*), 4
    ) AS suspicious_percentage

FROM geolocation;