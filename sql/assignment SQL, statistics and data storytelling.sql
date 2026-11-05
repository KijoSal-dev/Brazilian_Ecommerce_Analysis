#SQL, statistics and data storytelling
#Step 1: Understand the business and your datasets
#Existing tables
SHOW TABLES;

#The table structures
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE order_payments;
DESCRIBE order_reviews;
DESCRIBE products;
DESCRIBE sellers;

#Step 2: Prepare and validate your data
#2.1 Check record counts
SELECT 'customers' AS table_name, COUNT(*) AS total_records
FROM customers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'order_reviews', COUNT(*)
FROM order_reviews;

#2.2 Check missing values in important columns
#Customers Table
SELECT
    COUNT(*) AS total_customers,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_unique_id IS NULL) AS missing_customer_unique_id,
    SUM(customer_city IS NULL) AS customer_city,
    SUM(customer_state IS NULL) AS missing_customer_state
FROM customers;

#Orders Table
SELECT
     COUNT(*) AS total_orders,
     SUM(order_id IS NULL) AS missing_order_id,
     SUM(customer_id IS NULL) AS missing_customer_id,
     SUM(order_status IS NULL) AS missing_order_status,
     SUM(order_purchase_timestamp IS NULL) AS missing_order_purchase_timestamp,
     SUM(order_approved_at IS NULL) AS missing_order_aprroved_at,
     SUM(order_delivered_carrier_date IS NULL) AS missing_order_delivered_carrier_date,
     SUM(order_delivered_customer_date IS NULL) AS missing_order_delivered_customer_date
FROM orders;   

#  Order_Items
SELECT
     COUNT(*) AS total_order_items,
     SUM(order_id IS NULL) AS missing_order_id,
     SUM(order_item_id IS NULL) AS missing_order_item_id,
     SUM(product_id IS NULL) AS missing_product_id,
     SUM(seller_id IS NULL) AS missing_seller_id,
     SUM(price IS NULL) AS missing_price,
     SUM(freight_value IS NULL) AS missing_freight_value
FROM order_items;     

# order_payments
SELECT
     COUNT(*) AS total_order_payment,
     SUM(order_id IS NULL) AS missing_order_id,
     SUM(payment_sequential IS NULL) AS missing_payment_sequential,
     SUM(payment_type IS NULL) AS missing_payment_type,
     SUM(payment_installments IS NULL) AS missing_payment_installments,
     SUM(payment_value IS NULL) AS missing_payment_value
FROM order_payments;     

#order_reviews
SELECT
     COUNT(*) AS total_order_reviews,
     SUM(review_id IS NULL) AS missing_review_id,
     SUM(order_id IS NULL) AS missing_order_id,
     SUM(review_score IS NULL) AS missing_review_score,
     SUM(review_comment_title IS NULL) AS missing_review_comment_title,
     SUM(review_comment_message IS NULL) AS missing_review_comment_message,
     SUM(review_creation_date IS NULL) AS missing_review_creation_date,
     SUM(review_answer_timestamp IS NULL) AS missing_review_answer_timestamp
FROM order_reviews;     

#products
ALTER TABLE products
RENAME COLUMN product_name_lenght TO product_name_length;

ALTER TABLE products
RENAME COLUMN product_description_lenght TO product_description_length;

SELECT
     COUNT(*) AS total_products,
     SUM(product_id IS NULL)AS missing_product_id,
     SUM(product_category_name IS NULL) AS missing_product_category_name,
     SUM(product_name_length IS NULL) AS missing_product_name_length,
     SUM(product_description_length IS NULL) AS missing_product_description_length,
     SUM(product_photos_qty IS NULL) AS missing_product_photos_qty,
     SUM(product_weight_g IS NULL) AS missing_product_weight_g,
     SUM(product_length_cm IS NULL) AS missing_product_length_cm,
     SUM(product_height_cm IS NULL) AS missing_product_height_cm,
     SUM(product_width_cm IS NULL) AS missing_product_width_cm
FROM products;  

#product_category_translation
SELECT
     COUNT(*) AS total_product_category_translation,
     SUM(product_category_name IS NULL) AS missing_product_category_name,
     SUM(product_category_name_english IS NULL) AS missing_product_category_name_english
FROM product_category_translation;     
   
# sellers
SELECT
	 COUNT(*) AS total_Sellers,
     SUM(seller_id IS NULL) AS missing_seller_id,
     SUM(seller_city IS NULL) AS missing_seller_city,
     SUM(seller_state IS NULL) AS missing_seller_state
FROM sellers;   

#geolocation
SELECT
     COUNT(*) AS total_geolocation,
     SUM(geolocation_lat IS NULL) AS missing_geolocation_lat,
     SUM(geolocation_lng IS NULL) AS missing_geolocation_lng,
     SUM(geolocation_city IS NULL) AS missing_geolocation_city,
     SUM(geolocation_state IS NULL) AS missing_geolocation_state
FROM geolocation;     

#Step 2.3: Check for duplicate records
#customer
USE olist_analysis;
SELECT
     customer_id,
     COUNT(*) AS record_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

#orders
SELECT
     order_id,
     COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;     

# sellers
SELECT
     seller_id,
     COUNT(*) AS record_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;     

#products
SELECT
      product_id,
      COUNT(*) AS record_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

#order_items
SELECT
     order_id,
     order_item_id,
     COUNT(*) AS record_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;    

SELECT
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products
FROM order_items; 

SELECT
    COUNT(*) AS matched_orders
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;

#BUSINESS QUESTION  
#How are customers purchasing products, how much are they spending, 
#and how does delivery performance relate to customer reviews? 
#How customers purchase products by examining their payment methods?
SELECT
    payment_type,
    COUNT(*) AS payment_records,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

#Business Analysis
#Step1: Analyse product purchasing and spending  
#Which product categories generate the highest sales value, 
#and how many items are customers purchasing in each category?
SELECT
     p.product_category_name,
     COUNT(*) AS total_items_sold,
     COUNT(DISTINCT oi.order_id) AS total_orders,
     ROUND(SUM(oi.price),2) AS total_sales_value,
     ROUND(AVG(oi.price),2) AS average_item_price
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales_value DESC;    

#Step2: Analyse customer spending
#How much are customers spending per order?
SELECT
     COUNT(*) AS total_orders,
     ROUND(SUM(order_value), 2) AS total_sales_value,
     ROUND(AVG(order_value), 2) AS avg_order_value,
     ROUND(MAX(order_value), 2) AS highest_order_value,
     ROUND(MIN(order_value), 2) AS lowest_order_value
FROM(
     SELECT 
     order_id,
     SUM(price) AS order_value
     FROM order_items
     GROUP BY order_id
) AS order_totals;     

#Step3: Analyse delivery performance and customer reviews / satisfaction
#Are late deliveries are associated with lower customer review scores?
DESCRIBE order_reviews;
DESCRIBE orders;

SELECT
     CASE WHEN
     o.order_delivered_customer_date
     <= o.order_estimated_delivery_date
     THEN 'On Time'
     ELSE 'Late'
  END AS delivery_performance,
  
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(AVG(r.review_score), 2) AS average_review_score
  
FROM orders o
INNER JOIN order_reviews r
    ON o.order_id = r.order_id
    
WHERE o.order_delivered_customer_date IS NOT NULL 
    AND o.order_estimated_delivery_date IS NOT NULL
    AND r.review_score IS NOT NULL
    
GROUP BY delivery_performance
ORDER BY average_review_score DESC;    
  
  
  
     
     
     
