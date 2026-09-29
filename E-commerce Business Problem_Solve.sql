
-- 1.Why did sales decline in March compared with February, and
--  which category and product contributed the most to the decline?
 
-- use the database

use sales_data;

-- see all tables
show tables;

-- see all data
select * from orders;

-- find the MOM growth_percentage

with a as(select month(order_date) as month_num,
       count(*) as total_orders,
       round(sum(quantity*price),2) as total_sales
from orders
group by month(order_date)),
prev_month_sales as(
select month_num,total_orders,total_sales,
lag(total_sales) over(order by month_num) as previous_month_sales
from a
)
select month_num,total_orders,total_sales,previous_month_sales,
round((total_sales - previous_month_sales)/previous_month_sales*100,2) as Growth_PCT
from prev_month_sales ;

-- find the month who decline the Sales most

select month(order_date) as month_num,
	   count(*) as total_orders,
       round(sum(quantity*price),2) as total_sales,
       round(avg(quantity*price),2) as avg_order_vale
from orders 
where month(order_date) in (2,3)
group by month(order_date) ;    

-- find which category is decilne the most 

select category,
   sum(
   case 
   when month(order_date) = 2 then quantity*price
   else 0
   end
   ) as feb_sales,
   sum(
   case 
   when month(order_date) = 3 then quantity*price
   else 0
   end
   ) as march_sales,
   sum(
   case
   when month(order_date) = 3 then quantity*price 
   else 0
   end
   ) -
   sum(
   case
   when month(order_date) = 2 then quantity*price  
   else 0
   end
   ) as sales_change
   
from orders 
where month(order_date) in (2,3) 
group by category
order by sales_change desc;


-- find which product in electronics decline most

select  product,
     sum(
     case
     when month(order_date) = 2 then quantity*price
     else 0
     end
     ) as feb_sales,
     sum(
     case
     when month(order_date) = 3 then quantity*price
     else 0
     end 
     ) as march_sales,
     sum(
     case
     when month(order_date) = 3 then quantity*price
     else 0
     end
     )-
     sum(
       case when month(order_date) = 2 then quantity*price
     else 0
     end 
     ) as change_sales
from orders
where month(order_date) in (2,3) and category = 'Electronics'
group by product 
order by  change_sales desc; 

    
