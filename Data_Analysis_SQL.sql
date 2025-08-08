-- ========================================
-- Task 4: SQL for Data Analysis (SQLite)
-- Author: Mansi Rawal
-- Description: Queries for extracting and analyzing retail data
-- ========================================

-- 🔹 1. Basic use SELECT, WHERE, ORDER BY, GROUP BY
SELECT customer_city, customer_state,
COUNT (*) AS city_count
FROM olist_customers_dataset
GROUP BY customer_city, customer_state
ORDER By COUNT(*) DESC;

-- 🔹 2. INNER JOIN: Orders with Product Category Info
SELECT t.product_category_name_english,Count (*) as count_orders
FROM olist_products_dataset p
INNER JOIN olist_order_items_dataset oi ON p.product_id = oi.product_id
INNER JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP By t.product_category_name_english 
Order By COUNT(*) DESC

SELECT
  c.customer_id,
  c.customer_city,
  COUNT(o.order_id) AS orders_count
FROM olist_customers_dataset c
LEFT JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 🔹 3. Subqueries

⦁	Find customers who spent above average:

SELECT customer_id
FROM (
  SELECT o.customer_id, SUM(p.payment_value) AS total_spent
  FROM olist_orders_dataset o
  JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
  GROUP BY o.customer_id
) AS customer_totals
WHERE total_spent > (
  SELECT AVG(total_spent) FROM (
    SELECT o.customer_id, SUM(p.payment_value) AS total_spent
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
    GROUP BY o.customer_id
  )
);


-- 🔹4. Aggregate Functions (SUM, AVG, COUNT)
⦁	Average payment value per order:

SELECT
  o.order_id,
  AVG(p.payment_value) AS avg_payment
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY o.order_id;

-- 🔹5. Creating Views for Analysis
⦁	Define a reusable analysis view:

CREATE VIEW customer_summary AS
SELECT
  o.customer_id,
  COUNT(o.order_id) AS total_orders,
  SUM(p.payment_value) AS total_spent,
  AVG(p.payment_value) AS avg_payment
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY o.customer_id;

⦁	Then query:

SELECT * FROM customer_summary ORDER BY total_spent DESC LIMIT 5;


-- 🔹6. Optimize with Indexes
⦁	Create indexes for performance:

CREATE INDEX idx_orders_purchase_date ON olist_orders_dataset(order_purchase_timestamp);
CREATE INDEX idx_order_items_product ON olist_order_items_dataset(product_id);
CREATE INDEX idx_payments_order ON olist_order_payments_dataset(order_id);
