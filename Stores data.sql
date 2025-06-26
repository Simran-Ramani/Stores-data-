

create database store

select * from [dbo].[Stores]

--- To get the detailed information about the store data---
EXEC sp_help '[dbo].[Stores]'

---Previewing the top 5 data ----
select top 5 * from [dbo].[Stores]

--- Checking for missing or null value-- 
select count(*) as [total rows],
sum(case when store_ID is null then 1 else 0 end) as null_store_ID,
sum(case when Store_Area is null then 1 else 0 end) as null_store_area,
sum(case when Items_available is null then 1 else 0 end) as null_items_available,
sum(case when daily_customer_count is null then 1 else 0 end) as null_customer_count,
sum(case when store_sales is null then 1 else 0 end) as null_store_sales
from [dbo].[Stores]


-- checking for duplicates--- 
Select store_ID, count (*) from [dbo].[Stores]
group by Store_ID
Having count(*)>1

--- checking distribution of sales column ---
select 
min(store_sales) as minimum_sales,
max(store_sales)as maximum_sales,
avg(store_sales) as average_sales
from [dbo].[Stores]


-- stores which has more sales than average sales over all the store--
SELECT Store_ID, store_sales, 
       (SELECT AVG(store_sales) FROM [dbo].[Stores]) AS avg_store_sales
FROM [dbo].[Stores]
WHERE store_sales > (
    SELECT AVG(store_sales) FROM [dbo].[Stores]
)


select top 5 * from [dbo].[Stores]
where store_sales> (select avg(store_sales) from [dbo].[Stores])
order by Store_Sales desc


--- low efficiency store--- 
select *, store_sales/ store_area as sales_per_sq_ft from [dbo].[Stores]

ALTER TABLE [dbo].[Stores]
ADD sales_per_sq_ft FLOAT

update [dbo].[Stores]
set sales_per_sq_ft = store_sales/ store_area

SELECT *
FROM [dbo].[Stores]
WHERE sales_per_sq_ft > (
    SELECT AVG(sales_per_sq_ft)
    FROM [dbo].[Stores]
)
order by sales_per_sq_ft desc
--- the average sales/ sq ft is 40.47 
--- 70 or above - high sales/ sq ft 
--- 50-70 - low sales sales/sq ft
--- 40-50 - above average sales/sq ft
--- below 40 - below average sales/sq ft 

select *, store_sales/ Items_Available as sales_per_item from [dbo].[Stores]

ALTER TABLE [dbo].[Stores]
ADD sales_per_item FLOAT

update [dbo].[Stores]
set sales_per_item = store_sales/ Items_Available

SELECT *
FROM [dbo].[Stores]
WHERE sales_per_item > (
    SELECT AVG(sales_per_item)
    FROM [dbo].[Stores]
)
order by sales_per_item desc

-- store high efficient--
select * from [dbo].[Stores] where sales_per_sq_ft > 70 and sales_per_item >60


---store efficient--
select * from [dbo].[Stores] where  sales_per_sq_ft between 50 and 70  and  sales_per_item between 50 and 60


--above average -- 
select * from [dbo].[Stores] where  sales_per_sq_ft between 40 and 50  and  sales_per_item between 34 and 50

-- not efficient 
select * from [dbo].[Stores] where  sales_per_sq_ft<40  and  sales_per_item<34 

-- customer behaviour-- 
-- sales per customer as it helps to undersatnd the customer spending--

select store_sales/daily_customer_count from  [dbo].[Stores] as sales_per_customer 

ALTER TABLE [dbo].[Stores]
ADD sales_per_customer FLOAT

update [dbo].[Stores]
set sales_per_customer = store_sales/Daily_Customer_Count


select * FROM [dbo].[Stores] 
ORDER BY sales_per_customer desc

