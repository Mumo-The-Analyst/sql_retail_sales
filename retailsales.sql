-- Database and table setup

CREATE TABLE retail_sales3
(
transactions_id INT,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR (15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT *
FROM retail_sales3;

-- Data exploration and cleaning

-- records count
SELECT COUNT(*)
FROM retail_sales3;

-- distinct customer count
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales3;

-- distinct category count
SELECT DISTINCT category
FROM retail_sales3;

-- standardize the data
ALTER TABLE `retail_db`.`retail_sales3` 
CHANGE COLUMN `quantiy` `quantity` INT NULL DEFAULT NULL;

-- Null value check table
SELECT *
FROM retail_sales3
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

DELETE FROM retail_sales3
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- data exploration

-- how many sales we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales3;

-- how many uniques custimers we have?
SELECT COUNT(DISTINCT customer_id) AS unique_customer_num
FROM retail_sales3;

-- how many uniques categories we have?
SELECT DISTINCT category 
FROM retail_sales3;


-- Data analysis and findings - solving some business problems

-- 1.SQL code to retrieve all columns for sales made on '2022-11-20'
SELECT *
FROM retail_sales3
WHERE sale_date = '2022-11-20';

-- 2. SQL query to retreive all transactions where category is 'clothing' and the quantity sold is more than 4 in the month of Oct-2022
SELECT category, SUM(quantity)
FROM retail_sales3
WHERE category = 'Clothing'
GROUP BY 1;

SELECT *
FROM retail_sales3
WHERE 
    category = 'Clothing'
    AND 
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-10'
    AND
    quantity >= 4;
    
-- 3. SQL query to calculate the total sales(total_sale) for each category
SELECT category, 
SUM(total_sale) AS net_sale,
COUNT(*) AS total_orders
FROM retail_sales3
GROUP BY category;

-- 4.SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
ROUND(AVG(age),2) AS avg_age
FROM retail_sales3
WHERE category = 'Beauty';

-- 5.SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales3
WHERE total_sale > 1000;

-- 6. SQL query to find the total number of transactions(transaction_id) made by each gender in each category
SELECT category, gender, COUNT(transactions_id) AS total_trans
FROM retail_sales3
GROUP BY category, gender
ORDER By 1;

-- 7. SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH Monthly_Avg_Sales AS (
    SELECT 
	YEAR(sale_date) AS year,
	MONTH(sale_date) AS month,
	AVG(total_sale) AS avg_sale
    FROM retail_sales3
    GROUP BY 
        YEAR(sale_date), MONTH(sale_date)
),
Best_Selling_Month AS (
    SELECT 
        year, 
        month, 
        avg_sale,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS `rank`
    FROM 
        Monthly_Avg_Sales
)
SELECT 
    year, 
    month, 
    avg_sale
FROM 
    Best_Selling_Month
WHERE 
    `rank` = 1;

-- 8. SQL query to find the top 5 customers based on highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales3
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
;

-- 9. SQL to find the number of unique customers who purchased items from each category
SELECT
category,
COUNT(DISTINCT customer_id) AS count_unique_customers
FROM retail_sales3
GROUP BY category;

-- 10. SQL query to create each shift and number of orders(Example Morning < 12, Afternoon Between 12 & 17, Evening > 17)
WITH hourly_sales AS
(
SELECT *,
CASE
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales3
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;