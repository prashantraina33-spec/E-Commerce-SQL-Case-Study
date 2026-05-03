CREATE DATABASE ecommerce_company;

USE ecommerce_company;

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orderdetails;

-- total customers
SELECT COUNT(*) FROM customers;

-- total orders
SELECT COUNT(*) FROM orders;

-- total products sold
SELECT SUM(quantity) FROM orderdetails;



#1. CUSTOMER INSIGHTS

#Q: How many customers are from each city?

SELECT location, COUNT(*) AS total_customers
FROM customers
GROUP BY location
ORDER BY total_customers DESC;


#Q: Which customers have placed the most orders?

SELECT c.name, c.location, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.location
ORDER BY total_orders DESC
LIMIT 10;


#Q: Top customers by total spending?

SELECT c.name, c.location, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.location
ORDER BY total_spent DESC
LIMIT 10;



#2. PRODUCT ANALYSIS


#Q: Which products are sold the most (by quantity)?

SELECT p.name, p.category, SUM(od.quantity) AS total_qty_sold
FROM products p
JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY total_qty_sold DESC;


#Q: Total revenue generated per product?

SELECT p.name, p.category,
       SUM(od.quantity * od.price_per_unit) AS total_revenue
FROM products p
JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY total_revenue DESC;


#Q: Revenue by category?

SELECT p.category, SUM(od.quantity * od.price_per_unit) AS category_revenue
FROM products p
JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;



#3. SALES OPTIMIZATION


#Q: Monthly sales trend?

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY month;


#Q: Average order value?

SELECT ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders;


#Q: High-value orders (above average)?

SELECT * FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC;



#4. INVENTORY MANAGEMENT


#Q: Which products have low sales (possible overstock)?

SELECT p.name, p.category, COALESCE(SUM(od.quantity), 0) AS total_sold
FROM products p
LEFT JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY total_sold ASC;


#Q: Products never ordered?

SELECT p.name, p.category
FROM products p
LEFT JOIN orderdetails od ON p.product_id = od.product_id
WHERE od.product_id IS NULL;