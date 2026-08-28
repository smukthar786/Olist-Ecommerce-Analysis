USE olist_eCommerce;

##############################
# Record Count
##############################

# Finding the total number of records in each table.
SELECT 'customers' AS Table_Name, COUNT(*) AS row_count FROM olist_Customers
UNION ALL
SELECT 'orders', COUNT(*) FROM olist_Orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist_Order_Items
UNION ALL
SELECT 'products', COUNT(*) FROM olist_Products
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist_Sellers
UNION ALL
SELECT 'payments', COUNT(*) FROM olist_Order_Payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM olist_Order_Reviews
UNION ALL
SELECT 'categories', COUNT(*) FROM olist_Product_Category
UNION ALL
SELECT 'location', COUNT(*) FROM olist_GeoLocation;

##########################
# Null Checks
##########################

# Checking whether the primary key columns have NULL values in each table.
# olist_Customers
SELECT 
	COUNT(*) Total_Records,
    SUM(customer_id IS NULL) AS NULL_Customer_IDs,
    SUM(customer_unique_id IS NULL) AS NULL_customer_unique_id
FROM olist_Customers;

# olist_Products
SELECT
	COUNT(*) Total_Records,
    SUM(product_id IS NULL) AS NULL_product_id
FROM olist_Products;

# olist_Sellers
SELECT
	COUNT(*) Total_Records,
    SUM(seller_id IS NULL) AS NULL_seller_id
FROM olist_Sellers;

# olist_Orders
SELECT
	COUNT(*) AS Total_Records,
    SUM(order_id IS NULL) AS NULL_order_id,
    SUM(customer_id IS NULL) AS NULL_customer_id
FROM olist_Orders;

# olist_Order_Items
SELECT
	COUNT(*) AS Total_Records,
    SUM(order_id IS NULL) AS NULL_order_id,
    SUM(order_item_id IS NULL) AS NULL_order_item_id,
    SUM(product_id IS NULL) AS NULL_product_id,
    SUM(seller_id IS NULL) AS NULL_seller_id
FROM olist_Order_Items;

# olist_Order_Payments
SELECT
	COUNT(*) AS Total_Records,
    SUM(order_id IS NULL) AS NULL_order_id,
    SUM(payment_sequential IS NULL) AS NULL_payment_sequential
FROM olist_Order_Payments;

# olist_Order_Reviews
SELECT
	COUNT(*) AS Total_Records,
    SUM(review_id IS NULL) AS NULL_review_id,
    SUM(order_id IS NULL) AS NULL_order_id
FROM olist_Order_Reviews;

############################
# Checking Duplicates
############################

# Checking for Duplicate Primary Keys
# olist_Customers
SELECT
	customer_id, COUNT(*) AS Count
FROM olist_Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

# olist_Products
SELECT
	product_id, COUNT(*) AS Count
FROM olist_Products 
GROUP BY product_id
HAVING COUNT(*) > 1;

# olist_Sellers
SELECT
	seller_id, COUNT(*) AS Count
FROM olist_Sellers 
GROUP BY seller_id
HAVING COUNT(*) > 1;

# olist_Orders
SELECT
	order_id, COUNT(*) AS Count
FROM olist_Orders 
GROUP BY order_id
HAVING COUNT(*) > 1;

###############################
# Relation check 
###############################
# Checking whether the child tables contain IDs that are missing from their parent tables.

# Child: Orders; Parent: Customers
SELECT COUNT(*) AS unmatched_customers
FROM olist_Orders o
LEFT JOIN olist_Customers c
	ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

# Child: Order_Items; Parent: Orders
SELECT COUNT(*) AS unmatched_orders
FROM olist_Order_Items oi
LEFT JOIN olist_Orders o
	ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

# Child: Order_Items; Parent: Products
SELECT COUNT(*) AS unmatched_products
FROM olist_Order_Items oi
LEFT JOIN olist_Products p
	ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

# Child: Order_Items; Parent: Sellers
SELECT COUNT(*) AS unmatched_Sellers
FROM olist_Order_Items oi
LEFT JOIN olist_Sellers s
	ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

# Child: Payments; Parent: Orders
SELECT COUNT(*) AS unmatched_Orders
FROM olist_Order_Payments op
LEFT JOIN olist_Orders o
	ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

# Child: Reviews; Parent: Orders
SELECT COUNT(*) AS unmatched_Orders
FROM olist_Order_Reviews r
LEFT JOIN olist_Orders o
	ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

# Check whether Date/Datetime data is stored properly after loading the data.
DESCRIBE olist_Orders;

# Check for inconsistent dates
SELECT
    SUM(CAST(order_approved_at AS CHAR) = '0000-00-00 00:00:00') AS zero_approved,
    SUM(CAST(order_delivered_carrier_date AS CHAR) = '0000-00-00 00:00:00') AS zero_carrier,
    SUM(CAST(order_delivered_customer_date AS CHAR) = '0000-00-00 00:00:00') AS zero_customer_delivery,
    SUM(CAST(order_estimated_delivery_date AS CHAR) = '0000-00-00 00:00:00') AS zero_estimated
FROM olist_Orders;

SELECT
	SUM(CAST(shipping_limit_date AS CHAR) = '0000-00-00 00:00:00') AS zero_shipping_limit
FROM olist_Order_Items;

SELECT
	SUM(CAST(review_creation_date AS CHAR) = '0000-00-00 00:00:00') AS zero_review_creation,
    SUM(CAST(review_answer_timestamp AS CHAR) = '0000-00-00 00:00:00') AS zero_review_answer
FROM olist_Order_Reviews;

# Find the count of unique zero date entries across all 3 columns which showed inconsistency in orders table.
SELECT COUNT(*) AS zero_date_orders
FROM olist_Orders
WHERE
    CAST(order_approved_at AS CHAR) = '0000-00-00 00:00:00'
    OR CAST(order_delivered_carrier_date AS CHAR) = '0000-00-00 00:00:00'
    OR CAST(order_delivered_customer_date AS CHAR) = '0000-00-00 00:00:00';
    
# Find the count of unique zero date entries across all 2 columns which showed inconsistency in reviews table.
SELECT COUNT(*) AS zero_date_reviews
FROM olist_Order_Reviews
WHERE
    CAST(review_creation_date AS CHAR) = '0000-00-00 00:00:00'
    OR CAST(review_answer_timestamp AS CHAR) = '0000-00-00 00:00:00';
    
# Convert the Zero Date entries to NULL.
# Orders table
UPDATE olist_Orders
SET
    order_approved_at =
        CASE
            WHEN CAST(order_approved_at AS CHAR) = '0000-00-00 00:00:00'
            THEN NULL
            ELSE order_approved_at
        END,

    order_delivered_carrier_date =
        CASE
            WHEN CAST(order_delivered_carrier_date AS CHAR) = '0000-00-00 00:00:00'
            THEN NULL
            ELSE order_delivered_carrier_date
        END,

    order_delivered_customer_date =
        CASE
            WHEN CAST(order_delivered_customer_date AS CHAR) = '0000-00-00 00:00:00'
            THEN NULL
            ELSE order_delivered_customer_date
        END
WHERE
    CAST(order_approved_at AS CHAR) = '0000-00-00 00:00:00'
    OR CAST(order_delivered_carrier_date AS CHAR) = '0000-00-00 00:00:00'
    OR CAST(order_delivered_customer_date AS CHAR) = '0000-00-00 00:00:00';
    
# Reviews table
UPDATE olist_Order_Reviews
SET
    review_creation_date =
        CASE
            WHEN CAST(review_creation_date AS CHAR) = '0000-00-00 00:00:00'
            THEN NULL
            ELSE review_creation_date
        END,

    review_answer_timestamp =
        CASE
            WHEN CAST(review_answer_timestamp AS CHAR) = '0000-00-00 00:00:00'
            THEN NULL
            ELSE review_answer_timestamp
        END
WHERE
    CAST(review_creation_date AS CHAR) = '0000-00-00 00:00:00'
    OR CAST(review_answer_timestamp AS CHAR) = '0000-00-00 00:00:00';
  
# Check for inconsistent date sequence in orders table after handling the zero datetime
SELECT
    COUNT(*) AS invalid_date_sequence
FROM olist_Orders
WHERE
    (order_approved_at IS NOT NULL
     AND order_approved_at < order_purchase_timestamp)

 OR
    (order_delivered_carrier_date IS NOT NULL
     AND order_approved_at IS NOT NULL
     AND order_delivered_carrier_date < order_approved_at)

 OR
    (order_delivered_customer_date IS NOT NULL
     AND order_delivered_carrier_date IS NOT NULL
     AND order_delivered_customer_date < order_delivered_carrier_date)

 OR
    (order_estimated_delivery_date IS NOT NULL
     AND order_estimated_delivery_date < order_purchase_timestamp);

# Getting the total number of incosistent datetime series in each column in Orders table.
SELECT
    SUM(
        order_approved_at IS NOT NULL
        AND order_approved_at < order_purchase_timestamp
    ) AS approved_before_purchase,

    SUM(
        order_delivered_carrier_date IS NOT NULL
        AND order_approved_at IS NOT NULL
        AND order_delivered_carrier_date < order_approved_at
    ) AS carrier_before_approval,

    SUM(
        order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date
    ) AS customer_delivery_before_carrier,

    SUM(
        order_estimated_delivery_date IS NOT NULL
        AND order_estimated_delivery_date < order_purchase_timestamp
    ) AS estimated_before_purchase
FROM olist_Orders;

# Verifying the remaining issues in carrier_before_approval and customer_delivery_before_carrier
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM olist_Orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
LIMIT 20;

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM olist_Orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date
LIMIT 20;


-- Note:
-- A total of 1382 records have inconsistencies between the order approval date and carrier
-- delivery date and also between carrier delivery date and customer delivery date. 
-- These records are not modified to preserve the integrity of the original dataset.
-- Since the actual delivery dates cannot be independently verified, manually correcting
-- them could introduce inaccurate information. The inconsistencies are
-- documented and will be considered during subsequent analysis.

# Correcting attribute names in olist_Products table
-- The original dataset contains spelling errors in the product name-length
-- and product description-length column names. The columns are renamed for
-- clarity and consistency while preserving the underlying data.

ALTER TABLE olist_Products
RENAME COLUMN product_name_lenght TO product_name_length;

ALTER TABLE olist_Products
RENAME COLUMN product_description_lenght TO product_description_length;

###################################
# Foreign Key Validation 
###################################

# olist_Orders.customer_id → olist_Customers.customer_id
SELECT COUNT(*) AS unmatched_customer_ids
FROM olist_Orders o
LEFT JOIN olist_Customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

# olist_Order_Items.order_id → olist_Orders.order_id
SELECT COUNT(*) AS unmatched_order_ids
FROM olist_Order_Items oi
LEFT JOIN olist_Orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

# olist_Order_Items.product_id → olist_Products.product_id
SELECT COUNT(*) AS unmatched_product_ids
FROM olist_Order_Items oi
LEFT JOIN olist_Products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

# olist_Order_Items.seller_id → olist_Sellers.seller_id
SELECT COUNT(*) AS unmatched_seller_ids
FROM olist_Order_Items oi
LEFT JOIN olist_Sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

# olist_Order_Payments.order_id → olist_Orders.order_id
SELECT COUNT(*) AS unmatched_order_ids
FROM olist_Order_Payments p
LEFT JOIN olist_Orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

# olist_Order_Reviews.order_id → olist_Orders.order_id
SELECT COUNT(*) AS unmatched_order_ids
FROM olist_Order_Reviews r
LEFT JOIN olist_Orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- All identified foreign-key relationships were validated for orphaned
-- records. Each validation query returned 0 unmatched records.
-- Foreign-key constraints can therefore be safely added to the tables.

##############################
# Adding Foreign Key
##############################

# Adding fk in orders table
ALTER TABLE olist_Orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES olist_Customers(customer_id);

DESCRIBE olist_Orders;

# Adding fk in order_items table
ALTER TABLE olist_Order_Items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES olist_Orders(order_id),

ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES olist_Products(product_id),

ADD CONSTRAINT fk_order_items_seller
FOREIGN KEY (seller_id)
REFERENCES olist_Sellers(seller_id);

DESCRIBE olist_Order_Items;

# Adding fk in payments table
ALTER TABLE olist_Order_Payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id)
REFERENCES olist_Orders(order_id);

DESCRIBE olist_Order_Payments;

# Adding fk in reviews table
ALTER TABLE olist_Order_Reviews
ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id)
REFERENCES olist_Orders(order_id);

DESCRIBE olist_Order_Reviews;

##################################
# Sanity Checks for the tables
##################################

# Checking Orders table:
SELECT
    COUNT(*) AS total_orders,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_status IS NULL) AS null_order_status,
    SUM(order_purchase_timestamp IS NULL) AS null_purchase_timestamp,
    SUM(order_approved_at IS NULL) AS null_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS null_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS null_customer_delivery_date,
    SUM(order_estimated_delivery_date IS NULL) AS null_estimated_delivery_date
FROM olist_Orders;

-- Note:
-- 160 invalid zero-date values (0000-00-00 00:00:00) in order_approved_at,
-- 1783 invalid zero-date values in order_delivered_carrier_date and 
-- 2965 invalid zero-date values in order_delivered_customer_date
-- were converted to NULL because the actual approval timestamps could not
-- be determined from the source data.

# Checking Order_Items table:
SELECT
    COUNT(*) AS total_order_items,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(order_item_id IS NULL) AS null_order_item_id,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(seller_id IS NULL) AS null_seller_id,
    SUM(shipping_limit_date IS NULL) AS null_shipping_limit_date,
    SUM(price IS NULL) AS null_price,
    SUM(freight_value IS NULL) AS null_freight_value
FROM olist_Order_Items;

# Checking Products table:
SELECT
    COUNT(*) AS total_products,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(product_category_name IS NULL) AS null_category_name,
    SUM(product_name_length IS NULL) AS null_name_length,
    SUM(product_description_length IS NULL) AS null_description_length,
    SUM(product_photos_qty IS NULL) AS null_photos_qty,
    SUM(product_weight_g IS NULL) AS null_weight_g,
    SUM(product_length_cm IS NULL) AS null_length_cm,
    SUM(product_height_cm IS NULL) AS null_height_cm,
    SUM(product_width_cm IS NULL) AS null_width_cm
FROM olist_Products;

# Checking Customers table:
SELECT
    COUNT(*) AS total_customers,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(customer_unique_id IS NULL) AS null_customer_unique_id,
    SUM(customer_zip_code_prefix IS NULL) AS null_zip_code_prefix,
    SUM(customer_city IS NULL) AS null_city,
    SUM(customer_state IS NULL) AS null_state
FROM olist_Customers;

# Checking Sellers table:
SELECT
    COUNT(*) AS total_sellers,
    SUM(seller_id IS NULL) AS null_seller_id,
    SUM(seller_zip_code_prefix IS NULL) AS null_zip_code_prefix,
    SUM(seller_city IS NULL) AS null_city,
    SUM(seller_state IS NULL) AS null_state
FROM olist_Sellers;

# Checking Order_Payments table:
SELECT
    COUNT(*) AS total_payment_records,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(payment_sequential IS NULL) AS null_payment_sequential,
    SUM(payment_type IS NULL) AS null_payment_type,
    SUM(payment_installments IS NULL) AS null_payment_installments,
    SUM(payment_value IS NULL) AS null_payment_value
FROM olist_Order_Payments;

# Checking Order_Reviews table:
SELECT
    COUNT(*) AS total_review_records,
    SUM(review_id IS NULL) AS null_review_id,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(review_score IS NULL) AS null_review_score,
    SUM(review_comment_title IS NULL) AS null_comment_title,
    SUM(review_comment_message IS NULL) AS null_comment_message,
    SUM(review_creation_date IS NULL) AS null_creation_date,
    SUM(review_answer_timestamp IS NULL) AS null_answer_timestamp
FROM olist_Order_Reviews;

-- Note:
-- One invalid zero-date value (0000-00-00 00:00:00) was identified in
-- both review_creation_date and review_answer_timestamp.
-- Since the actual timestamps could not be determined from the source data,
-- these values were converted to NULL rather than assigning an assumed date.

# Checking GeoLocation table:
SELECT
    COUNT(*) AS total_geolocation_records,
    SUM(geolocation_zip_code_prefix IS NULL) AS null_zip_code_prefix,
    SUM(geolocation_lat IS NULL) AS null_latitude,
    SUM(geolocation_lng IS NULL) AS null_longitude,
    SUM(geolocation_city IS NULL) AS null_city,
    SUM(geolocation_state IS NULL) AS null_state
FROM olist_GeoLocation;

# Invalid cordinates check for latitude and longitude
SELECT
    COUNT(*) AS invalid_coordinates
FROM olist_GeoLocation
WHERE geolocation_lat NOT BETWEEN -90 AND 90
   OR geolocation_lng NOT BETWEEN -180 AND 180;
   
# Invalid zipcode check
SELECT
    COUNT(*) AS invalid_zip_prefixes
FROM olist_GeoLocation
WHERE geolocation_zip_code_prefix < 1000
   OR geolocation_zip_code_prefix > 99999;
   
# Check for review scores
SELECT
    review_score,
    COUNT(*) AS review_count
FROM olist_Order_Reviews
GROUP BY review_score
ORDER BY review_score;

# Check for order item prices and freight values
SELECT
    SUM(price < 0) AS negative_prices,
    SUM(freight_value < 0) AS negative_freight_values,
    MIN(price) AS minimum_price,
    MIN(freight_value) AS minimum_freight_value
FROM olist_Order_Items;

# Check for payment values and installments
SELECT
    SUM(payment_value < 0) AS negative_payment_values,
    SUM(payment_installments < 0) AS negative_installments,
    MIN(payment_value) AS minimum_payment_value,
    MIN(payment_installments) AS minimum_installments,
    MAX(payment_installments) AS maximum_installments
FROM olist_Order_Payments;

-- Checking which records are having payment_installments as 0 to validate 
-- whether the entry is proper
SELECT
    payment_type,
    COUNT(*) AS record_count
FROM olist_Order_Payments
WHERE payment_installments = 0
GROUP BY payment_type
ORDER BY record_count DESC;

-- For payment_installments = 0, the payment type is credit card.
-- Checking the entry for those records.
SELECT *
FROM olist_Order_Payments
WHERE payment_type = 'credit_card'
  AND payment_installments = 0;
  
-- Note:
-- Two credit-card payment records have payment_installments = 0 despite
-- having positive payment values. Since the actual installment count cannot
-- be determined from the source data, these values are retained unchanged
-- to preserve the original dataset. They should be considered anomalies
-- when performing installment-related analysis.

# Checking for payment categories
SELECT
    payment_type,
    COUNT(*) AS payment_count
FROM olist_Order_Payments
GROUP BY payment_type
ORDER BY payment_count DESC;

SELECT *
FROM olist_Order_Payments
WHERE payment_type = 'not_defined';

-- Note:
-- Three payment records have payment_type = 'not_defined' and payment_value = 0.
-- Since the source data does not provide the actual payment method, these
-- records are retained unchanged to preserve the original dataset.
-- They should be considered separately when analyzing payment methods or
-- payment values.

# Check for Order Status:
SELECT
    order_status,
    COUNT(*) AS order_count
FROM olist_Orders
GROUP BY order_status
ORDER BY order_count DESC;

# Customer and Seller State values check
SELECT
    customer_state,
    COUNT(*) AS customer_count
FROM olist_Customers
GROUP BY customer_state
ORDER BY customer_count DESC;

SELECT
    seller_state,
    COUNT(*) AS seller_count
FROM olist_Sellers
GROUP BY seller_state
ORDER BY seller_count DESC;

###########################
# Creating Analytical View
###########################
-- The product category translation table is joined with the products table
-- to provide English product category names for analysis. The original
-- tables are kept unchanged, while the view provides a convenient dataset
-- for product and category-level analysis.

CREATE VIEW vw_olist_Products AS
SELECT
	op.product_id,
    op.product_category_name,
    pc.product_category_name_english,
    op.product_name_length,
    op.product_description_length,
    op.product_photos_qty,
    op.product_weight_g,
    op.product_length_cm,
    op.product_height_cm,
    op.product_width_cm
FROM olist_Products op
LEFT JOIN olist_Product_Category pc
	ON op.product_category_name = pc.product_category_name;
    
SELECT *
FROM vw_olist_Products
LIMIT 10;

# Check for untranslated categories
SELECT
    COUNT(*) AS total_products,
    SUM(product_category_name_english IS NULL) AS untranslated_categories
FROM vw_olist_Products;

SELECT
    product_category_name,
    COUNT(*) AS product_count
FROM vw_olist_Products
WHERE product_category_name_english IS NULL
GROUP BY product_category_name
ORDER BY product_count DESC;

SELECT
    product_category_name,
    LENGTH(product_category_name) AS category_length,
    COUNT(*) AS product_count
FROM olist_Products
WHERE product_category_name = ''
GROUP BY product_category_name;

-- Note:
-- 623 products do not have an English category translation.
-- Of these, 610 products have a blank product category, while 10 products
-- belong to 'portateis_cozinha_e_preparadores_de_alimentos' and 3 products
-- belong to 'pc_gamer', for which no corresponding English translation
-- exists in the source translation table.
-- These values are retained without manual modification to preserve the
-- original data and avoid introducing assumed category mappings.