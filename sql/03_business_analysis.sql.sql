USE olist_eCommerce;

-- -------------------------------
-- 1. Overall Sales Performance
-- -------------------------------

-- Business Question:
-- What is the overall sales performance of the business?

SELECT
	COUNT(DISTINCT order_id) AS Orders_With_Items,
    COUNT(*) AS Total_Order_Items,
    ROUND(SUM(price), 2) AS Total_Sales,
    ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS Average_Order_Value
FROM olist_Order_Items;

-- Result:
-- 98,666 orders with item records and 112,650 order items generated
-- total product sales of 13,591,643.70, with an average order value
-- of 137.75.

-- Note:
-- The order count is based on orders present in the Order_Items table.
-- The orders table contains 99,441 orders in total, while 98,666 distinct
-- orders have associated order-item records.


-- ----------------------------------------
-- 2. Sales & Order Trend Over Time
-- ----------------------------------------

-- Business Question
-- How have monthly sales and order volumes changed over time?

SELECT
	DATE_FORMAT(o.order_purchase_timestamp, "%Y-%m") AS Order_Month,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(SUM(oi.price), 2) AS Total_Sales,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id) , 2) AS Average_Order_Value
FROM olist_Orders o
JOIN olist_Order_Items oi
	ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, "%Y-%m")
ORDER BY Order_Month;

-- Result:
-- Monthly sales show strong growth from 2017 into 2018, reaching a peak
-- of 1,010,271.37 in November 2017. Sales remained close to 1 million
-- per month during March-May 2018 before declining moderately through
-- August 2018.

-- Note:
-- September 2016, December 2016 and September 2018 contain very few
-- orders and appear to represent partial periods. Therefore, these months
-- should not be interpreted as meaningful indicators of sales performance.

-- =====================================================
-- 3. Top 10 Months by Sales
-- =====================================================

-- Business Question:
-- Which months generated the highest product sales?

SELECT
	DATE_FORMAT(o.order_purchase_timestamp, "%Y-%m") AS Order_Month,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(SUM(oi.price), 2) AS Total_Sales,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id) , 2) AS Average_Order_Value
FROM olist_Orders o
JOIN olist_Order_Items oi
	ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, "%Y-%m")
ORDER BY Total_Sales DESC
LIMIT 10;

-- Result:
-- November 2017 recorded the highest monthly sales at 1,010,271.37,
-- followed closely by April and May 2018 with nearly 1 million in sales.
-- May 2018 had the highest Average Order Value among the top 10 months
-- at 145.41, indicating higher spending per order.
--
-- Overall, sales remained strong from March to May 2018 despite a lower
-- number of orders compared with November 2017, suggesting that higher
-- order values contributed to the strong sales performance.

-- ----------------------------------------
-- 4. Top 10 Product Categories by Sales
-- ----------------------------------------

-- Business Question
-- Which product categories generate the highest sales revenue?

SELECT
    p.product_category_name_english AS Product_Category,
    COUNT(DISTINCT oi.order_id) AS Total_Orders,
    ROUND(SUM(oi.price), 2) AS Total_Sales,
    ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id), 2) AS Average_Order_Value
FROM olist_Order_Items oi
JOIN vw_olist_Products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name_english
ORDER BY Total_Sales DESC
LIMIT 10;

-- Result:
-- Health & Beauty generated the highest sales at R$1.26M, followed by
-- Watches & Gifts at R$1.21M and Bed Bath & Table at R$1.04M.
-- Watches & Gifts had the highest Average Order Value at R$214.26,
-- despite having fewer orders than Health & Beauty.
--
-- Overall, Health & Beauty had the highest sales and order volume among
-- the top 10 categories, while Watches & Gifts showed strong revenue
-- performance due to its significantly higher average order value.

-- ---------------------------------
-- 5: Top 10 Sellers by Sales
-- ---------------------------------

-- Business Question
-- Which sellers generate the highest sales revenue?

SELECT
    oi.seller_id AS Seller_ID,
    COUNT(DISTINCT oi.order_id) AS Total_Orders,
    ROUND(SUM(oi.price), 2) AS Total_Sales,
    ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id), 2) AS Average_Order_Value
FROM olist_Order_Items oi
JOIN olist_Sellers s
    ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id
ORDER BY Total_Sales DESC
LIMIT 10;

-- Result:
-- The top-performing seller generated 229.47K in sales from 1,132 orders.
-- The second-highest seller generated 222.78K despite having only 358 orders.
-- This seller also had the highest Average Order Value at 622.28,
-- indicating that higher-value orders contributed significantly to its
-- strong sales performance.
--
-- Overall, the results show that some sellers achieve high revenue through
-- higher order values, while others rely more on higher order volumes.

-- ---------------------------------
-- 6. Sales by Customer State
-- ---------------------------------

-- Business Question:
-- Which customer states generate the highest sales revenue?

SELECT
    c.customer_state AS Customer_State,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(SUM(oi.price), 2) AS Total_Sales,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id), 2
    ) AS Average_Order_Value
FROM olist_Orders o
JOIN olist_Customers c
    ON o.customer_id = c.customer_id
JOIN olist_Order_Items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY Total_Sales DESC;

-- Result:
-- Sao Paulo (SP) generated the highest sales at 5.20M from 41,375 orders,
-- followed by Rio de Janeiro (RJ) at 1.82M and Minas Gerais (MG) at 1.59M.
-- SP's strong sales performance was primarily driven by its significantly
-- higher order volume, despite having a lower Average Order Value of 125.75.
--
-- Overall, sales are heavily concentrated in the leading states, while some
-- lower-volume states show higher average order values.

-- ---------------------------------
-- 7. Payment Method Analysis
-- ---------------------------------

-- Business Question:
-- Which payment methods are most commonly used by customers,
-- and how much payment value does each method generate?

SELECT
    payment_type AS Payment_Method,
    COUNT(DISTINCT order_id) AS Total_Orders,
    ROUND(SUM(payment_value), 2) AS Total_Payment_Value,
    ROUND(
        SUM(payment_value) / COUNT(DISTINCT order_id), 2
    ) AS Average_Payment_Per_Order
FROM olist_Order_Payments
WHERE payment_type <> 'not_defined'
GROUP BY payment_type
ORDER BY Total_Payment_Value DESC;

-- Result:
-- Credit cards were the most widely used payment method, accounting for
-- 76,505 orders and generating 12.54M in total payment value.
-- Boleto was the second most commonly used method, with 19,784 orders
-- and 2.87M in payments.
--
-- Credit card payments also had the highest Average Payment Per Order
-- at 163.94, while voucher and debit card usage was considerably lower.

-- ---------------------------------
-- 8. Order Status Analysis
-- ---------------------------------

-- Business Question:
-- What proportion of orders are successfully delivered,
-- and how are the remaining orders distributed across other statuses?

SELECT
    order_status AS Order_Status,
    COUNT(*) AS Total_Orders,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2
    ) AS Percentage_of_Orders
FROM olist_Orders
GROUP BY order_status
ORDER BY Total_Orders DESC;

-- Result:
-- 97.02% of all orders were marked as delivered, representing 96,478
-- out of 99,441 total orders. Shipped orders accounted for 1.11%,
-- while canceled and unavailable orders represented only 0.63% and
-- 0.61%, respectively.
--
-- Overall, delivered orders account for the vast majority of orders,
-- with all other order statuses representing relatively small proportions.

-- ---------------------------------
-- 9. Delivery Performance
-- ---------------------------------

-- Business Question:
-- How efficiently are orders delivered, and what proportion arrive
-- on or before the estimated delivery date?

SELECT
    COUNT(*) AS Delivered_Orders,
    
    ROUND(AVG(
        TIMESTAMPDIFF(
            HOUR,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) / 24, 2) AS Average_Delivery_Days,

    SUM(
        CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS On_Time_Orders,

    SUM(
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS Late_Orders,

    ROUND(
        SUM(
            CASE
                WHEN order_delivered_customer_date <= order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS On_Time_Delivery_Percentage

FROM olist_Orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
  
-- Result:
-- Delivered orders took an average of 12.54 days to reach customers.
-- Of the 96,470 delivered orders with valid delivery dates, 88,644
-- (91.89%) arrived on or before the estimated delivery date, while
-- 7,826 orders (8.11%) were delivered late.
--
-- Overall, the majority of delivered orders met the estimated delivery
-- timeline, indicating generally strong delivery performance.

-- ---------------------------------
-- 10. Review Score Analysis
-- ---------------------------------

-- Business Question:
-- How are customer review scores distributed,
-- and what is the overall average review score?

SELECT
    review_score AS Review_Score,
    COUNT(*) AS Total_Reviews,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2
    ) AS Percentage_of_Reviews,
    ROUND(
        SUM(SUM(review_score)) OVER() /
        SUM(COUNT(*)) OVER(), 2
    ) AS Average_Review_Score
FROM olist_Order_Reviews
GROUP BY review_score
ORDER BY review_score DESC;


-- Result:
-- Customer reviews were largely positive, with an overall average review
-- score of 4.09 out of 5. Five-star reviews accounted for 57.83% of all
-- reviews, while 4-star reviews represented 19.31%.
--
-- Overall, 77.14% of reviews received a rating of 4 or 5 stars, indicating
-- generally high customer satisfaction, although 11.46% of reviews received
-- the lowest rating of 1 star.

-- ---------------------------------------------
-- 11. Delivery Performance vs Review Score
-- ---------------------------------------------

-- Business Question:
-- How does delivery performance relate to customer review scores?

SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END AS Delivery_Status,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(AVG(r.review_score), 2) AS Average_Review_Score
FROM olist_Orders o
JOIN olist_Order_Reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY Delivery_Status
ORDER BY Average_Review_Score DESC;

-- Result:
-- Orders delivered on time received an average review score of 4.30 out
-- of 5, compared with only 2.57 for orders delivered after the estimated
-- delivery date.
--
-- The 1.73-point difference indicates a strong association between
-- delivery timeliness and customer satisfaction, with late deliveries
-- receiving substantially lower review scores.