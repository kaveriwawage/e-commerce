use olist_store_analysis;
#1 :KPI
#Weekday vs weekend (order_purchase_timestamp) payment statistics
select
   case when dayofweek(STR_TO_DATE(o.order_purchase_timestamp, '%y-%m-%d' )) 
   IN (1, 7) THEN 'Weekend' ELSE 'weekday' END AS DayType,
   COUNT(DISTINCT o.order_id) AS TotalOrders,
   round(SUM(P.payment_value)) AS TotalPayment,
   round(AVG(p.payment_value)) AS AveragePayment
FROM
     olist_orders_dataset o
JOIN
   olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY
   DayType;
   

#2nd -- KPI
#Number of orders with a review score of 5 and payment type as a credit card.

SELECT 
   COUNT( p.order_id) AS NumberofOrders
FROM
     olist_order_payments_dataset p
JOIN 
	 olist_order_reviews_dataset r ON p.order_id =r.order_id
WHERE 
    r.Review_score = 4
    AND payment_type = 'credit_card';

    
#3rd KPI
#The average number of days taken for order_deliverd_customer_date for pet_shop

SELECT
       product_category_name,
	round(AVG(DATEDIFF(order_delivered_customer_date, Order_purchase_Timestamp))) AS avg_delivary_time
FROM 
    olist_orders_dataset o
JOIN
    olist_order_items_dataset i ON i.order_id = o.order_id
JOIN 
    olist_products_dataset p ON p.product_id=i.product_id
WHERE
    p.product_category_name = 'pet_shop'
    AND o.order_delivered_customer_date IS NOT NULL;

#4th KPI
#Average price and payment values from customers of sao paulo city

SELECT
    round(AVG(i.price)) AS average_price,
    round(AVG(p.Payment_value)) AS average_payment
FROM 
    olist_customers_dataset c
JOIN
    olist_orders_dataset o ON c.customer_id = o.Customer_id
JOIN
    olist_order_items_dataset i ON o.order_id = i.order_id
JOIN
    olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE
   customer_city= 'sao paulo';
  
#5th---KPI
#Relationship between shipping days (order_deliverd_customer_date - order_purchase_timestamp) Vs review scores

SELECT
   round(AVG(DATEDIFF(order_Delivered_Customer_Date, Order_Purchase_Timestamp)),0) AS AvgShippingDays,
   Review_score
FROM
	olist_orders_dataset o
JOIN
    olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE
    Order_Delivered_Customer_Date IS NOT NULL
    AND order_purchase_Timestamp IS NOT NULL
GROUP BY
    Review_score;
    
    