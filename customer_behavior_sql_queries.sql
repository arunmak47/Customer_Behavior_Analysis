#male vs female
select gender , SUM(purchase_amount) as revenue
from mytable
group by gender

#customers used a discount but still spent more than the average purchase amount?
select customer_id, purchase_amount
from mytable
where discount_applied="yes" and purchase_amount >=(select AVG(purchase_amount) from mytable)


#top 5 review with average review rating?
select item_purchased, AVG (review_rating) as "Average Product Rating"
from mytable 
group by item_purchased
order by avg(review_rating)desc
limit 5;

#compare the average purchase amount between standard and express shipping?
select shipping_type, 
ROUND(AVG(purchase_amount),2)
from mytable
where shipping_type in ('Standard','Express')
group by shipping_type;

#Do subscribed customers spend more? Compare average spend and total revenue 
--between subscribers and non-subscribers.
SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount),2) AS avg_spend,
       ROUND(SUM(purchase_amount),2) AS total_revenue
FROM mytable
GROUP BY subscription_status
ORDER BY total_revenue,avg_spend DESC;

#Which 5 products have the highest percentage of purchases with discounts applied?
SELECT item_purchased,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM mytable
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


#segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
with customer_type as (
SELECT customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM mytable)

select customer_segment,count(*) AS "Number of Customers" 
from customer_type 
group by customer_segment;

#What are the top 3 most purchased products within each category? 
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM mytable
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;
 
#Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM mytable
WHERE previous_purchases > 5
GROUP BY subscription_status;

#What is the revenue contribution of each age group? 
SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM mytable
GROUP BY age_group
ORDER BY total_revenue desc;







