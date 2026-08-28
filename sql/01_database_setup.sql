CREATE SCHEMA IF NOT EXISTS olist_eCommerce;
USE olist_eCommerce;

-- Create a table for Customers in order to import the dataset from the csv.
CREATE TABLE olist_Customers(
	customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state VARCHAR(5)
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'D:/Data Analytics/Projects/SQL Project/olist_customers_dataset.csv'
INTO TABLE olist_Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a table for Products in order to import the dataset from the csv.
CREATE TABLE olist_Products(
	product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- NOTE:
-- Update the file paths in the LOAD DATA LOCAL INFILE statements
-- according to the location of the downloaded Olist CSV files
-- on your local system.

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_Products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a table for Sellers in order to import the dataset from the csv.
CREATE TABLE olist_Sellers(
	seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    seller_state VARCHAR(5)
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_Sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a table for Orders in order to import the dataset from the csv.
CREATE TABLE olist_Orders(
	order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(25),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a table for Order_Items in order to import the dataset from the csv.
CREATE TABLE olist_Order_Items(
	order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
	price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    
    PRIMARY KEY (order_id, order_item_id)
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_Order_Items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a table for Order_Payments in order to import the dataset from the csv.
CREATE TABLE olist_Order_Payments(
	order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(25),
    payment_installments INT,
    payment_value DECIMAL(10, 2),
    
    PRIMARY KEY (order_id, payment_sequential)
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_Order_Payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a table for Order_Reviews in order to import the dataset from the csv.
CREATE TABLE olist_Order_Reviews(
	review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(200),
    review_comment_message VARCHAR(500),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_Order_Reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a table for Product_Category in order to import the dataset from the csv.
CREATE TABLE olist_Product_Category(
	product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_Product_Category
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- Create a table for GeoLocation in order to import the dataset from the csv.
CREATE TABLE olist_GeoLocation(
	geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10, 2),
    geolocation_lng DECIMAL(10, 2),
    geolocation_city VARCHAR(50),
    geolocation_state VARCHAR(5)
);

-- Load the data from csv file
LOAD DATA LOCAL INFILE 'path/to/olist_customers_dataset.csv'
INTO TABLE olist_GeoLocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
