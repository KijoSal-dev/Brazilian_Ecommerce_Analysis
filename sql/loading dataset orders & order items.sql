SELECT COUNT(*) AS total_products
FROM products;

SELECT
    COUNT(*) AS total_products,
    SUM(product_name_lenght = 0) AS zero_name_lengths,
    SUM(product_description_lenght = 0) AS zero_description_lengths,
    SUM(product_photos_qty = 0) AS zero_photo_counts
FROM products;

SELECT
    COUNT(*) AS affected_products
FROM products
WHERE product_name_lenght = 0
  AND product_description_lenght = 0
  AND product_photos_qty = 0;
  
SELECT *
FROM products
WHERE product_name_lenght = 0
  AND product_description_lenght = 0
  AND product_photos_qty = 0
LIMIT 10;  

#Data Quality Observation – Products Dataset
#The Olist products dataset contains 32,951 records. Initial quality checks identified 610 products (approximately 1.85%) with zero values in product name length, product description length and photo quantity.
# Further inspection confirmed that these values occur together in the affected records. However, some other product attributes, including weight and dimensions, remain available.
# Potential implication: Analyses involving product descriptions, product names or product photography may be affected by incomplete information.
#Recommended action: Preserve the original records, investigate missing attributes and exclude or handle affected values appropriately when conducting analyses that depend on these fields.