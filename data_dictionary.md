# Brazilian E-Commerce Analysis – Data Dictionary

## 1. Introduction

This data dictionary provides a reference guide to the datasets used in the Brazilian E-Commerce Analysis project.

It explains what each dataset contains, the meaning of its columns, the expected data types, and how the datasets relate to one another.

The project uses nine datasets covering customer information, orders, products, sellers, payments, reviews, product categories and geographical locations.

The dictionary is intended to help readers understand the data structure before exploring the data cleaning and analysis notebooks.

## 2. Dataset Overview

The project contains the following nine datasets:

| No. | Dataset | Description | Records after cleaning |
|---:|---|---|---:|
| 1 | Customers | Customer identification and location information. | 99,441 |
| 2 | Orders | Order records, statuses and timestamps. | 99,441 |
| 3 | Order Items | Products purchased within each order, including prices and freight charges. | 112,650 |
| 4 | Order Payments | Payment methods, instalments and payment values. | 103,886 |
| 5 | Order Reviews | Customer ratings and written feedback. | 99,224 |
| 6 | Products | Product categories and physical characteristics. | 32,951 |
| 7 | Sellers | Seller identification and location information. | 3,095 |
| 8 | Geolocation | Postal code prefixes and geographical coordinates. | 738,332 |
| 9 | Category Translation | Portuguese product category names and their English translations. | 71 |

*Note: Record counts represent the cleaned datasets used in the analysis.*

## 3. Dataset and Column Definitions

The following sections describe the purpose of each dataset and the meaning of its individual columns.

### 3.1 Customers Dataset

**Source file:** `olist_customers_dataset.csv`

**Purpose:** Contains customer identification and geographical information.

| Column | Data Type | Description |
|---|---|---|
| `customer_id` | String | Unique identifier assigned to a customer record. |
| `customer_unique_id` | String | Identifier used to identify an individual customer across their order records. |
| `customer_zip_code_prefix` | String | Five-character Brazilian postal code prefix associated with the customer. |
| `customer_city` | String | City where the customer is located. |
| `customer_state` | String | Brazilian state associated with the customer. |

**Key identifier:** `customer_id`

### 3.2 Orders Dataset

**Source file:** `olist_orders_dataset.csv`

**Purpose:** Contains information about customer orders, their statuses and the timestamps associated with order processing and delivery.

| Column | Data Type | Description |
|---|---|---|
| `order_id` | String | Unique identifier assigned to an order. |
| `customer_id` | String | Identifier linking an order to the customer who placed it. |
| `order_status` | String | Recorded status of the order, such as delivered, shipped, canceled or unavailable. |
| `order_purchase_timestamp` | Datetime | Date and time when the customer placed the order. |
| `order_approved_at` | Datetime | Date and time when the order payment was approved. |
| `order_delivered_carrier_date` | Datetime | Date and time when the order was handed over to the logistics carrier. |
| `order_delivered_customer_date` | Datetime | Date and time when the order was delivered to the customer. |
| `order_estimated_delivery_date` | Datetime | Estimated date by which the order was expected to reach the customer. |

**Key identifier:** `order_id`

**Related dataset:** Customers, linked through `customer_id`.

### 3.3 Order Items Dataset

**Source file:** `olist_order_items_dataset.csv`

**Purpose:** Records the individual product items included in orders, together with their prices, sellers and freight charges.

| Column | Data Type | Description |
|---|---|---|
| `order_id` | String | Identifier linking the item record to its associated order. |
| `order_item_id` | Integer | Sequential number identifying an item within an order. |
| `product_id` | String | Identifier linking the purchased product to the Products dataset. |
| `seller_id` | String | Identifier linking the item to the seller responsible for selling it. |
| `shipping_limit_date` | Datetime | Deadline by which the seller was expected to hand the item over for shipping. |
| `price` | Numeric | Price of the product item, excluding freight charges. |
| `freight_value` | Numeric | Freight charge associated with the item. |

**Related datasets:** Orders, Products and Sellers.

### 3.4 Order Payments Dataset

**Source file:** `olist_order_payments_dataset.csv`

**Purpose:** Contains payment information associated with customer orders, including payment methods and monetary values.

| Column | Data Type | Description |
|---|---|---|
| `order_id` | String | Identifier linking the payment record to an order. |
| `payment_sequential` | Integer | Sequential number identifying a payment within an order. |
| `payment_type` | String | Payment method used, such as credit card, boleto, voucher or debit card. |
| `payment_installments` | Integer | Number of instalments selected for the payment. |
| `payment_value` | Numeric | Monetary value recorded for the payment. |

**Related dataset:** Orders, linked through `order_id`.

**Note:** An order can have multiple payment records.

### 3.5 Order Reviews Dataset

**Source file:** `olist_order_reviews_dataset.csv`

**Purpose:** Contains customer ratings and written feedback associated with their orders.

| Column | Data Type | Description |
|---|---|---|
| `review_id` | String | Identifier assigned to a customer review. |
| `order_id` | String | Identifier linking the review to the associated order. |
| `review_score` | Integer | Customer rating ranging from 1 (lowest) to 5 (highest). |
| `review_comment_title` | String | Short title or heading provided with the review. |
| `review_comment_message` | String | Written feedback submitted by the customer. |
| `review_creation_date` | Datetime | Date when the review survey was created or made available. |
| `review_answer_timestamp` | Datetime | Date and time when the customer submitted the review response. |

**Related dataset:** Orders, linked through `order_id`.

**Note:** An order may have multiple review records. Where required for order-level analysis, multiple review scores can be aggregated.

### 3.6 Products Dataset

**Source file:** `olist_products_dataset.csv`

**Purpose:** Contains product identification, category information and physical characteristics.

| Column | Data Type | Description |
|---|---|---|
| `product_id` | String | Unique identifier assigned to a product. |
| `product_category_name` | String | Original Portuguese product category name. |
| `product_name_length` | Numeric | Length of the product name, represented as a character count. |
| `product_description_length` | Numeric | Length of the product description, represented as a character count. |
| `product_photos_qty` | Numeric | Number of photographs associated with the product listing. |
| `product_weight_g` | Numeric | Product weight measured in grams. |
| `product_length_cm` | Numeric | Product length measured in centimetres. |
| `product_height_cm` | Numeric | Product height measured in centimetres. |
| `product_width_cm` | Numeric | Product width measured in centimetres. |

**Key identifier:** `product_id`

**Related dataset:** Order Items, linked through `product_id`.

### 3.7 Sellers Dataset

**Source file:** `olist_sellers_dataset.csv`

**Purpose:** Contains seller identification and geographical information.

| Column | Data Type | Description |
|---|---|---|
| `seller_id` | String | Unique identifier assigned to a seller. |
| `seller_zip_code_prefix` | String | Five-character Brazilian postal code prefix associated with the seller. |
| `seller_city` | String | City where the seller is located. |
| `seller_state` | String | Brazilian state associated with the seller. |

**Key identifier:** `seller_id`

**Related dataset:** Order Items, linked through `seller_id`.

### 3.8 Geolocation Dataset

**Source file:** `olist_geolocation_dataset.csv`

**Purpose:** Provides geographical information associated with Brazilian postal code prefixes. It includes coordinates and corresponding city and state information.

| Column | Data Type | Description |
|---|---|---|
| `geolocation_zip_code_prefix` | String | Five-character Brazilian postal code prefix. |
| `geolocation_lat` | Numeric | Latitude coordinate associated with the geographical location. |
| `geolocation_lng` | Numeric | Longitude coordinate associated with the geographical location. |
| `geolocation_city` | String | City associated with the geographical location. |
| `geolocation_state` | String | Brazilian state associated with the geographical location. |

**Related datasets:** Customers and Sellers, using their respective postal code prefix columns.

**Note:** Multiple geographical records may exist for the same postal code prefix because a prefix can be associated with different coordinates.

### 3.9 Category Translation Dataset

**Source file:** `product_category_name_translation.csv`

**Purpose:** Provides English translations of the original Portuguese product category names.

| Column | Data Type | Description |
|---|---|---|
| `product_category_name` | String | Original Portuguese product category name. |
| `product_category_name_english` | String | English translation of the product category name. |

**Related dataset:** Products, linked through `product_category_name`.

## 4. Relationships Between Datasets

The datasets can be combined using their common identifiers. These relationships support analysis across customers, orders, products, payments, sellers and reviews.

| Dataset 1 | Dataset 2 | Linking Column | Relationship |
|---|---|---|---|
| Customers | Orders | `customer_id` | One customer record can be associated with multiple orders. |
| Orders | Order Items | `order_id` | One order can contain multiple item records. |
| Orders | Order Payments | `order_id` | One order can have multiple payment records. |
| Orders | Order Reviews | `order_id` | One order can have one or more review records. |
| Products | Order Items | `product_id` | One product can appear in multiple order-item records. |
| Sellers | Order Items | `seller_id` | One seller can be associated with multiple order-item records. |
| Products | Category Translation | `product_category_name` | Product categories can be matched to their English translations. |
| Customers | Geolocation | `customer_zip_code_prefix` | Customer postal code prefixes can be matched to geographical records. |
| Sellers | Geolocation | `seller_zip_code_prefix` | Seller postal code prefixes can be matched to geographical records. |

### Important identifier distinctions

- `customer_id` identifies a customer record associated with an order.
- `customer_unique_id` identifies an individual customer across their order records.
- `order_id` identifies an individual order.
- `product_id` identifies a product.
- `seller_id` identifies a seller.
- `review_id` identifies a review record.

These identifiers should be treated as categorical identifiers rather than numerical measurements.

## 5. Data Types and Measurement Conventions

The following conventions apply to the cleaned datasets:

| Data category | Representation | Examples |
|---|---|---|
| Identifiers | String | `order_id`, `customer_id`, `product_id` |
| Categorical variables | String | `order_status`, `payment_type`, `customer_state` |
| Dates and timestamps | Datetime | `order_purchase_timestamp`, `review_answer_timestamp` |
| Monetary values | Numeric | `price`, `freight_value`, `payment_value` |
| Counts and quantities | Integer or numeric | `order_item_id`, `payment_installments`, `product_photos_qty` |
| Physical measurements | Numeric | `product_weight_g`, `product_length_cm` |
| Geographical coordinates | Numeric | `geolocation_lat`, `geolocation_lng` |

**Measurement conventions:**

- Monetary values are expressed in Brazilian Real (R$).
- Product weight is measured in grams.
- Product dimensions are measured in centimetres.
- Review scores range from 1 to 5.
- Brazilian postal code prefixes are stored as five-character strings to preserve leading zeros.

## 6. Data Preparation Notes

The following preparation steps were applied during the data-cleaning process:

1. Date columns were converted to datetime format to support chronological calculations and delivery performance analysis.
2. Postal code prefix columns were standardized to five-character strings.
3. Exact duplicate geolocation records were removed while retaining records with different geographical coordinates.
4. Misspelled product column names were corrected:
   - `product_name_lenght` was renamed to `product_name_length`.
   - `product_description_lenght` was renamed to `product_description_length`.
5. Original Portuguese product category names were retained, with English translations available through the category translation dataset.
6. Missing values in the source datasets were not automatically replaced or deleted where no reliable replacement could be established.

## 7. Document Scope

This document describes the structure, meaning and relationships of the datasets used in the project.

It does not present sales performance results, customer purchasing trends, delivery findings or business recommendations. Those are documented separately in the data analysis notebook and decision brief.

**Related project resources:**

- `notebooks/01_data_quality_assessment.ipynb` – Data quality assessment.
- `notebooks/02_data_cleaning.ipynb` – Data cleaning and validation.
- `notebooks/03_data_analysis.ipynb` – Exploratory and business analysis.
- `data/cleaned/` – Cleaned datasets.
- `reports/figures/` – Analysis visualisations.
- `reports/decision_brief.md` – Summary of findings and recommended business actions.