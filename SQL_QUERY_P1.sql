--SQL Retail sales analysis - p1 
CREATE DATABASE sql_project_p2;


--Create table 
CREATE TABLE retail_sales(
transactions_id	INT PRIMARY KEY,
sale_date DATE, 
sale_time TIME,
customer_id	INT,
gender VARCHAR (25),
age	INT,
category VARCHAR (25),	
quantiy	INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
    count (*)
	FROM retail_sales;

	SELECT * FROM retail_sales 
	where transactions_id is NULL;

SELECT * FROM retail_sales 
WHERE transactions_id is NULL
     or 
	 sale_date IS NULL 
	 or 
	 sale_time IS NULL 
	 or
	 customer_id IS NULL 
	 OR 
	 gender IS NULL 
	 OR 
	 age IS NULL 
	 OR 
	 category IS NULL 
	 OR 
	 quantiy IS NULL 
	 OR 
	 price_per_unit IS NULL 
	 OR 
	 cogs IS NULL 
	 OR 
	 total_sale IS NULL;

-- data cleaning
DELETE FROM retail_sales
WHERE transactions_id is NULL
     or 
	 sale_date IS NULL 
	 or 
	 sale_time IS NULL 
	 or
	 customer_id IS NULL 
	 OR 
	 gender IS NULL 
	 OR 
	 age IS NULL 
	 OR 
	 category IS NULL 
	 OR 
	 quantiy IS NULL 
	 OR 
	 price_per_unit IS NULL 
	 OR 
	 cogs IS NULL 
	 OR 
	 total_sale IS NULL;

--data exploration
--How many sales we have 

SELECT 
    count (*) AS total_sale
	FROM retail_sales;

-- How many unique customers we have 
SELECT 
    count (DISTINCT customer_id) AS total_customer 
	 FROM retail_sales;

-- How many unique category we have 
SELECT 
    DISTINCT category
	 FROM retail_sales;


--Data analysis and key business problems and ansswer 
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
  FROM retail_sales
   WHERE sale_date ='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT
*
FROM retail_sales
where category = 'Clothing'
      AND 
	 TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'
     AND 
	 quantiy >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) and totalorder for each category.

SELECT 
category,
sum(total_sale) as net_sales,
COUNT(*) as total_order
FROM retail_sales
GROUP BY 1 

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
ROUND(AVG(age),2) AS average_age 
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
from retail_sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
     category,
	 gender,
	 count(*) AS total_transaction
	 from retail_sales
	 GROUP BY 
	 category,
	 gender
	 ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
     year,
	 month,
	 avg_sale
	 FROM
	 (
	SELECT 
		EXTRACT ( YEAR FROM sale_date) AS year,
		EXTRACT (MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK () OVER (PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) AS rank
	from retail_sales
GROUP BY 1,2  
) AS t1
WHERE rank=1
--ORDER BY 1,3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
customer_id, 
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,
   COUNT(DISTINCT customer_id) AS cnt_unique_cus
FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS 
(
SELECT *,
     CASE
	  WHEN EXTRACT (HOUR FROM sale_time) <12 THEN 'Morning'
	  WHEN EXTRACT(HOUR FROM sale_time ) BETWEEN 12 AND 17 THEN 'Afternoon'
	  ELSE 'Evening'
	 END AS shift
FROM retail_sales
)
SELECT 
    shift,
	COUNT(*) AS total_order
	FROM hourly_sale
	GROUP BY shift
--End of project 