SELECT *
FROM order_details$

SELECT *
FROM orders$

SELECT * 
FROM pizza_types$

SELECT *
FROM pizzas$


--How many customers do we have each day? Are there any peak hours?

SELECT order_id, date
FROM orders$


SELECT B.order_id, COUNT(B.quantity) AS Pizzas_Per_Order, 
  CASE 
    WHEN DATEPART(HOUR, time) = 0 THEN '12 AM'
    WHEN DATEPART(HOUR, time) < 12 THEN CONCAT(DATEPART(HOUR, time), ' AM')
    WHEN DATEPART(HOUR, time) = 12 THEN '12 PM'
    ELSE CONCAT(DATEPART(HOUR, time) - 12, ' PM')
  END AS hour_of_day,
  time, A.date
FROM orders$ A
join order_details$ B
on A.order_id = B.order_id
GROUP BY DATEPART(HOUR, time), B.order_id, time, A.date
ORDER BY B.order_id

;


--How many pizzas are typically in an order? Do we have any bestsellers?

SELECT order_id, COUNT(quantity) AS Pizzas_Per_Order
  FROM order_details$
  GROUP BY order_id

SELECT AVG(Pizzas_Per_Order) AS Average_Pizzas_Per_Order
FROM (
  SELECT order_id, COUNT(quantity) AS Pizzas_Per_Order
  FROM order_details$
  GROUP BY order_id
) AS subquery;

--Do we have any bestsellers?

SELECT A.name, SUM(C.quantity) AS Sold_quantity
FROM pizza_types$ A
     JOIN pizzas$ B ON A.pizza_type_id = B.pizza_type_id
     JOIN order_details$ C ON C.pizza_id = B.pizza_id
GROUP BY A.name
ORDER BY Sold_quantity DESC;


--How much money did we make this year? Can we indentify any seasonality in the sales?


SELECT ROUND(SUM(A.price * B.quantity), 2) AS Revenue 
FROM pizzas$ A
JOIN order_details$ B
ON A.pizza_id = B.pizza_id;


SELECT B.order_id, ROUND((A.price * B.quantity), 2) AS Revenue 
FROM pizzas$ A
JOIN order_details$ B
ON A.pizza_id = B.pizza_id



--Can we indentify any seasonality in the sales?

SELECT DATEPART(QUARTER, B.date) AS Quarter, ROUND(SUM(C.price * A.quantity), 2) AS Revenue 
FROM order_details$ A
JOIN orders$ B ON A.order_id = B.order_id
JOIN pizzas$ C ON A.pizza_id = C.pizza_id
GROUP BY DATEPART(QUARTER, B.date)
ORDER BY Revenue DESC





