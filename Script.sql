/*find top 10 highest revenue generating products */
-- SELECT  product_id as top_10,sum(sale_price) as sales from df_orders group by product_id order by sales desc limit 10

/* top5 selling products in region */
-- with cte as (
-- SELECT    region,product_id,sum(sale_price) as sales from df_orders group by product_id order by region,sales)
-- select * from (SELECT  * ,row_number() over(PARTITION by region order by sales DESC) as rn from cte) a
-- WHERE rn<=5

/* find month over month growth comparison for 2022 and 2023 sales */
-- with cte as (
-- SELECT  YEAR(order_date) as o_year,MONTH(order_date) as o_month,sum(sale_price) as sales from df_orders  
-- group by YEAR(order_date),MONTH(order_date)
-- -- ORDER by YEAR(order_date),MONTH(order_date) not allowed in subquery
-- )

-- SELECT o_month ,o_year
-- ,sum(case when o_year=2022 then sales else 0 end) as sales_2022
-- ,SUM(case when o_year=2023 then sales else 0 end) as sales_2023
-- from cte
-- group by o_month
-- order by o_month


-- for each category month which had highest sales
-- with cte as (
-- SELECT category , FORMAT(order_date,'yyyyMM') as order_y_m, sum(sale_price) as sales  
-- FROM df_orders
-- group by category,FORMAT(order_date,'yyyyMM')
-- -- order by category,FORMAT(order_date,'yyyyMM')
-- )
-- SELECT * from (
-- SELECT *,
-- ROW_NUMBER () over(PARTITION by category order by sales DESC) as rowno
-- from cte ) al WHERE rowno=1


-- highest profit acc to sub category
with sub as (
SELECT  sub_category,YEAR(order_date) as o_year,sum(sale_price) as sales from df_orders  
group by sub_category,YEAR(order_date)
-- ORDER by YEAR(order_date),MONTH(order_date) not allowed in subquery
)
,sub2 as (
SELECT sub_category,o_year
,sum(case when o_year=2022 then sales else 0 end) as sales_2022
,SUM(case when o_year=2023 then sales else 0 end) as sales_2023
from sub
group by sub_category
)
SELECT  *
,((sales_2023-sales_2022)*100)/sales_2022 as growth_percentage
from sub2
order by growth_percentage DESC limit 1
