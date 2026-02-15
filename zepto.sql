create database zepto;

drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);



--data exploration

--count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;


--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;


-- data Analysis
Select * from zepto;
-- find top 10 best value products based on discount percent?
Select name,mrp,discountpercent
from zepto
order by discountpercent desc
limit 10

-- what are the products with high mrp but out of stock
Select distinct name ,mrp
from zepto
where outofstock=true and mrp>300
order by mrp desc

-- Calculate estimate revenue for each category
Select distinct category,
sum(discountedSellingprice *availablequantity) as revenue
from zepto
group by category
order by revenue desc


-- find all products where mrp is greater than 500 and discount is less than 10%
Select name,mrp,discountpercent
from zepto
where mrp>500 and discountpercent<10
order by mrp desc

-- Idebtify the top 5 categories offering the highest average discount percentage
Select category,Round(avg(discountpercent),2) as average
from zepto
group by category
order by average desc
limit 5;

-- Find the price  per gram for products above 100g and sort by best value
with my_cte as(
Select  name ,discountedsellingprice, weightingms,
Round(case when weightingms>100 then discountedsellingprice/weightingms else 0 end,2) as price
from zepto
)

Select  Distinct name,price 
from my_cte
where price<>0
order by price asc;

-- Group the categories into low,medium and bulk
Select distinct name,weightingms,
case when weightingms<1000 then 'Low'
when weightingms<5000 then 'Medium'
else 'Bulk'
end as weight_category
from zepto;

-- what is the total inventory weight per category
Select category,
sum(weightingms*availableQuantity) as total_weight
from zepto
group by category
order by total_weight desc;






















