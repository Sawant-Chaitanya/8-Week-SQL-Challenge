```SQL
--Q1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
  DATEPART(WEEK, registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY DATEPART(WEEK, registration_date);
```
```SQL
--Q2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT 
    ru_od.runner_id,
    AVG(
		DATEDIFF(MINUTE, cu_od.order_time, ru_od.pickup_time)	
		) AS avg_time_in_minutes
FROM
    customer_orders AS cu_od
INNER JOIN
    runner_orders AS ru_od ON cu_od.order_id = ru_od.order_id
WHERE
    ru_od.distance IS NOT NULL 
GROUP BY
    ru_od.runner_id;

```

```SQL
--Q3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH cte AS 
(
   SELECT
      cu_od .order_id,
      COUNT(pizza_id) AS no_of_pizzas,
      AVG(DATEDIFF(MINUTE, cu_od .order_time, ru_od.pickup_time)) AS avg_time 
   FROM
      customer_orders as cu_od 
      JOIN
         runner_orders as ru_od 
         ON cu_od .order_id = ru_od.order_id 
         and ru_od.distance IS NOT NULL 
   GROUP BY
      cu_od .order_id 
)
SELECT
   no_of_pizzas,
   AVG(avg_time) AS avg_prep_time 
FROM
   cte 
GROUP BY
   no_of_pizzas;
```
```SQL
--4. What was the average distance travelled for each customer?
SELECT
    cu_od.customer_id,
    ROUND(CAST(AVG(ru_od.distance) AS DECIMAL),1) AS avg_dist_travelled
FROM
    customer_orders AS cu_od
JOIN
    runner_orders AS ru_od ON cu_od.order_id = ru_od.order_id
WHERE
    ru_od.distance IS NOT NULL
GROUP BY
    cu_od.customer_id;

```
```SQL
--Q5. What was the difference between the longest and shortest delivery times for all orders?
SELECT
	 MAX(CAST(duration AS FLOAT)) - MIN(CAST(duration AS FLOAT)) AS avg_dist_travelled
FROM
    runner_orders AS ru_od 
WHERE
    ru_od.distance IS NOT NULL;

```
```SQL
-- Q6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- Calculate average speed in km/h for each runner order

SELECT  
    runner_id,
    order_id,
    distance AS distance_km,
    duration AS duration_minutes,
    -- Calculate average speed in km/h by dividing distance (in km) by duration (in minutes) and then multiplying by 60
    distance / duration * 60 AS avg_speed_kmh
FROM 
    runner_orders
WHERE
    distance IS NOT NULL
-- Group by runner_id and order_id to ensure unique combinations
GROUP BY 
    runner_id,
    order_id,
    distance,
    duration,
    distance / duration * 60
-- Order the results by runner_id and order_id
ORDER BY
    runner_id,
    order_id;

```
```SQL
--Q7.What is the successful delivery percentage for each runner?
SELECT
    runner_id,
    COUNT(order_id) AS total_deliveries,
    SUM(CASE WHEN cancellation IS NULL THEN 1 ELSE 0 END) AS successful_deliveries,
    ROUND((SUM(CASE WHEN cancellation IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id)), 2) AS perc_successful
FROM
    runner_orders
GROUP BY
    runner_id;


```
