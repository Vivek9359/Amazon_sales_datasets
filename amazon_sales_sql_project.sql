
-- ------------------------------------- Create database and Table ---------------------------------------

-- create a database of company 
create database if not exists company;

-- use of database
use company;

-- Create a database of amazon_sales_csv file import files path of folder
-- path of G:\CSV file\amazon_sales_dataset.csv 

-- select a table
select * from amazon_sales;

-- find a product_id null value
select * from amazon_sales where product_id is null;

-- select a average price 
select round(avg(Price)) as Avg_price from amazon_sales; 

-- Total income values 
select round(sum(total_revenue),2) as total_value from amazon_sales; 

-- Customer priority of payment Method useing of group by function
select payment_method, 
count(payment_method) from amazon_sales
group by payment_method;


-- ------------------------------------- Sales Performance Questions ---------------------------------------

-- What is the average order value?
SELECT ROUND(AVG(total_revenue),2) AS avg_order_value
FROM amazon_sales;

-- Top 10 Revenue Generating Categories
SELECT product_category,
       ROUND(SUM(total_revenue),2) AS category_revenue
FROM amazon_sales
GROUP BY product_category
ORDER BY category_revenue DESC
LIMIT 10;

-- Best Selling Categories
SELECT product_category,
       SUM(quantity_sold) AS units_sold
FROM amazon_sales
GROUP BY product_category
ORDER BY units_sold DESC; 

-- Monthly Revenue Trend
SELECT YEAR(order_date) AS year,
       MONTH(order_date) AS month,
       ROUND(SUM(total_revenue),2) revenue
FROM amazon_sales
GROUP BY year,month
ORDER BY year,month; 

-- ------------------------------------- Discount Analysis ---------------------------------------

-- Discount Revenue income
SELECT discount_percent,
       ROUND(SUM(total_revenue),2) revenue
FROM amazon_sales
GROUP BY discount_percent
ORDER BY discount_percent; 

-- Average Discount by Category
SELECT product_category,
       ROUND(AVG(discount_percent),2) AvgValue_discount
FROM amazon_sales
GROUP BY product_category
ORDER BY avg_discount DESC; 

-- ------------------------------------- Customer Satisfaction Analysis ---------------------------------------

-- Highest Rated Categories
SELECT product_category,
       ROUND(AVG(rating),2) avg_rating
FROM amazon_sales
GROUP BY product_category
ORDER BY avg_rating DESC;

-- Categories Receiving Most Reviews
SELECT product_category,
       SUM(review_count) reviews
FROM amazon_sales
GROUP BY product_category
ORDER BY reviews DESC;


-- ------------------------------------Top Product in Each Category---------------------------------------------- 


-- Rank Categories by Revenue  
SELECT product_category,
       SUM(total_revenue) revenue,
       RANK() OVER(
           ORDER BY SUM(total_revenue) DESC
       ) revenue_rank
FROM amazon_sales
GROUP BY product_category;

-- top Product Category

WITH cte AS
(
SELECT product_category,
       product_id,
       SUM(total_revenue) revenue,
       ROW_NUMBER() OVER(
           PARTITION BY product_category
           ORDER BY SUM(total_revenue) DESC
       ) rn
FROM amazon_sales
GROUP BY product_category,product_id
)
SELECT *
FROM cte
WHERE rn=1;

