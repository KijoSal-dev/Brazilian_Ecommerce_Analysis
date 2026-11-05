#  sellers
LOAD DATA LOCAL INFILE
'C:/Users/hp/Downloads/Olist/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# product category translations
LOAD DATA LOCAL INFILE
'C:/Users/hp/Downloads/Olist/product_category_name_translation.csv'
INTO TABLE product_category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
