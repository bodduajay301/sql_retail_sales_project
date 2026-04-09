-- sql retail sales analysis - p1
create database sql_project_1;


-- Create Table
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantiy	INT,
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale INT
	);

SELECT * FROM retail_sales
LIMIT 10

SELECT
	COUNT(*)
FROM retail_sales
--- DATA CLEANING
SELECT * FROM retail_sales
WHERE age IS NULL


SELECT * FROM retail_sales
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
	category IS NULL
	OR
	age is null
	or
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

ALTER TABLE retail_sales 
RENAME COLUMN quantiy TO quantity;

DELETE FROM retail_sales
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
	age is null
	or
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

SELECT
	COUNT(*)
FROM retail_sales
-- Data Exploration

--How many sales we have?
select count(*) as total_sale FROM retail_sales;

--How many customers we have?
select count(*) as customer_id from retail_sales;

--How many UNIQUE customers we have?
select count(DISTINCT customer_id) as total_sale from retail_sales;

--How many DISTINCT category we have?
select count(DISTINCT category) as total_sale from retail_sales;


--Data Analysis & Business Key problems & Answers

--1Q. Write a SQL query to retrive all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05';

--2Q. write a SQL query to retrive all the transactions where the category is cloathing and the quantity sold is more than 4 in the month of nov-2022
select  *
from retail_sales
where category = 'Clothing'
	and 
	to_char(sale_date,'yyyy-mm')='2022-11'
	and
	quantity>= 4;

--3Q. write a SQL query to caluclate the total sale (total_sale) for each category.

select 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1;

--4Q Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
select 
	ROUND(avg(age),2) as avg_age
	from retail_sales
where category = 'Beauty'

--5Q. Write a SQL query to find all transactions where the total_sale is greater than 1000?
select *  from retail_sales
where total_sale>1000

--6Q. write a SQl query to find total number of transactions(transaction_id) made by each gender in each category?


select 
	category,
	gender,
	count(*) as total_transactions
from retail_sales
group 
	by 
	category,
	gender

--7Q. write a SQL query to caluclate the average sale for each month . find out best selling month in each year?
select * from
(
select
	EXTRACT(year FROM  sale_date) as year,
	EXTRACT(month FROM sale_date) as month,
	ROUND(avg(total_sale),2) as average_sale,
	rank() over(partition by extract(year from sale_date)order by avg(total_sale)desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1

--8Q. write a SQL query to find the top % customers based on the highest total sales ?
select 
	customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
limit 5

--9Q. write a SQL query to find the number of unique customers who purchased items from each category

select
	category,
	count(distinct(customer_id)) as cnt_unique_customers
from retail_sales
group by category


--10Q. write a SQL query to create each shift and number of orders(example morning<12, afternoon between12& 17, evening>17).
with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time)<12 then 'morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		when extract(hour from sale_time)>17 then 'evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift


--end of project

	
