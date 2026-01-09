drop table if exists zepto;
create table zepto(
sku_id int auto_increment primary key,
category varchar(120),
name varchar(150) not null,
mrp float(8,2),
discount_percent float(5,2),
available_quantity int,
discounted_selling_price float(8,2),
weight_inGms int,
out_of_stock varchar(5),
quantity int
)

-- Data Exploration

-- Counting Rows 
select count(*) from zepto

-- Sample Data
select * from zepto limit 3

-- Finding Null values
select * from zepto 
where name is null
or category is null
or mrp is null
or discount_percent is null
or discounted_selling_price is null
or available_quantity is null
or weight_inGms is null
or quantity is null
or out_of_stock is null

-- Collecting Types of  Prodcut categories

select distinct category from zepto
order by category

-- Stock Details

select out_of_stock,count(sku_id)
from zepto
group by out_of_stock

-- Product Name With Multiple Entries

select name,count(sku_id) as stock_units
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc

-- Data cleaning

-- Product with price zero

select * from zepto 
where mrp = 0 or discounted_selling_price =0

delete from zepto where mrp = 0

-- Converting paise to rupees

update zepto 
set mrp =mrp/100.0,
discounted_selling_price=discounted_selling_price/100.0;

select mrp,discounted_selling_price from zepto limit 4

-- Finding Top 10 best value prodcuts based on discount

select distinct name ,mrp,discount_percent
from zepto
order by discount_percent desc 
limit 10;

-- Prodcuts with High MRP But out of Stock

select distinct name,mrp
from zepto where out_of_stock = 'TRUE' and mrp >(select  avg(mrp) from zepto)
order by mrp desc;

-- Estimating revenue for each category

select category,sum(discounted_selling_price*available_quantity ) as total_revenue
from zepto
group by category
order by total_revenue
-- Same Estimation Using window function
select distinct category,sum(discounted_selling_price*available_quantity ) over(partition by category) as total_revenue
from zepto
order by total_revenue

-- Prodcuts where mrp greater than 500 but discount less than 10%

select name,mrp,discount_percent from zepto where mrp >500 and discount_percent<10
order by mrp desc,discount_percent desc

-- Top 5 Categories highest average discount percentage

select distinct category,round(avg(discount_percent) over(partition by category),2) as average_discount
from zepto
order by average_discount desc limit 5

-- Price Per Gram For products

select distinct name,weight_inGms,discounted_selling_price,
round(discounted_selling_price/weight_inGms,2) as price_per_gram
from zepto
where weight_inGms>=100
order by price_per_gram

-- Grouping products based on weight

select distinct name,weight_inGms,

case 
    when weight_inGms >5000 then 'Bulk'
    when weight_inGms between 1000 and 5000 then 'Medium'
    else 'Low'
end as weight_category
from zepto
order by weight_inGms desc

-- Total Inventory Weight per Category

select distinct category,sum(weight_inGms * available_quantity) over(partition by category) as total_weight
from zepto
order by total_weight desc

-- Total
    
