# A. Pizza Metrics

```SQL
--Q1.How many pizzas were ordered?

SELECT COUNT(*) as count_of_pizzas 
FROM customer_orders 
```

```SQL
--2. How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) as unique_order_count 
FROM customer_orders
```

```SQL
--3. How many successful orders were delivered by each runner?
SELECT runner_id, 
COUNT(order_id) as successful_orders
FROM
 runner_orders
 where
 distance is not null
 group by runner_id
```
```SQL
--Q4 How many of each type of pizza was delivered?
SELECT
    -- Cast the pizza_name column to VARCHAR(MAX) to ensure compatibility in GROUP BY
    CAST(pz_nm.pizza_name AS VARCHAR(MAX)) AS pizza_name,
    COUNT(cu_od.order_id) AS delivered_pizza_count
FROM
    customer_orders AS cu_od
INNER JOIN
    pizza_names AS pz_nm ON cu_od.pizza_id = pz_nm.pizza_id
INNER JOIN
    runner_orders AS ru_od ON cu_od.order_id = ru_od.order_id
WHERE
    ru_od.distance IS NOT NULL   -- Exclude orders where distance is NULL
GROUP BY
    CAST(pz_nm.pizza_name AS VARCHAR(MAX));

```

### Explanation:

- **SELECT Clause**: 
  - `CAST(pz_nm.pizza_name AS VARCHAR(MAX)) AS pizza_name`: Casts the `pizza_name` column to `VARCHAR(MAX)` for compatibility in grouping.

- **WHERE Clause**:
  - `ru_od.distance IS NOT NULL`: Filters out undelivered orders.

- **GROUP BY Clause**:
  - `CAST(pz_nm.pizza_name AS VARCHAR(MAX))`: Groups by casted `pizza_name` column for compatibility.

### Explanation of Casting:

Using `CAST(pz_nm.pizza_name AS VARCHAR(MAX))` ensures compatibility for grouping, especially in databases like Microsoft SQL Server, 
which may have restrictions on directly grouping by certain data types like `text`. This casting avoids potential errors and ensures successful grouping operations.

---
```SQL
--Q5 How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
    -- Customer ID
    cu_od.customer_id,
    -- Cast the pizza_name column to VARCHAR(MAX) for compatibility in GROUP BY
    CAST(pz_nm.pizza_name AS VARCHAR(MAX)) AS pizza_name,
    COUNT(cu_od.order_id) AS delivered_pizza_count
FROM
    customer_orders AS cu_od
INNER JOIN
    pizza_names AS pz_nm ON cu_od.pizza_id = pz_nm.pizza_id
GROUP BY
    -- Grouping by customer ID and pizza name after casting for compatibility
    cu_od.customer_id, CAST(pz_nm.pizza_name AS VARCHAR(MAX))
ORDER BY 
    cu_od.customer_id;

```
```SQL
--Q6 What was the maximum number of pizzas delivered in a single order?
SELECT 
	ru_od.order_id,
    COUNT(cu_od.order_id) AS pizza_per_order
FROM
    customer_orders AS cu_od
INNER JOIN
    runner_orders AS ru_od ON cu_od.order_id = ru_od.order_id
WHERE
    ru_od.distance IS NOT NULL -- Filtering out orders with non-null distance
GROUP BY
    ru_od.order_id;
```
```SQL
--Q7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
    cu_od.customer_id,
    COUNT(CASE WHEN cu_od.exclusions <> '' OR cu_od.extras <> '' THEN 1 END) AS atleast_1_change, -- Count of orders with at least one change
    COUNT(CASE WHEN cu_od.exclusions = '' AND cu_od.extras = '' THEN 1 END) AS without_change -- Count of orders without any changes
FROM
    customer_orders AS cu_od
INNER JOIN
    runner_orders AS ru_od ON cu_od.order_id = ru_od.order_id
WHERE
    ru_od.distance IS NOT NULL  
GROUP BY 
    cu_od.customer_id
ORDER BY 
    cu_od.customer_id;

```
```SQL
--Q8. How many pizzas were delivered that had both exclusions and extras?
SELECT 
    COUNT(CASE WHEN cu_od.exclusions <> '' and cu_od.extras <> '' THEN 1 END) AS pizza_count_w_exclusions_extras 
FROM
    customer_orders AS cu_od
INNER JOIN
    runner_orders AS ru_od ON cu_od.order_id = ru_od.order_id
WHERE
    ru_od.distance IS NOT NULL  
```
```SQL
--Q9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
DATEPART(HOUR, order_time) AS hour_of_day,
count(*) AS pizza_count
from customer_orders 
group by DATEPART(HOUR, order_time);

```
```SQL
--Q10 What was the volume of orders for each day of the week?
SELECT
  DATENAME(dw, order_time) AS Weekday, -- Get the weekday name
  COUNT(*) AS NumOrders
FROM customer_orders
GROUP BY DATENAME(dw, order_time)
ORDER BY DATENAME(dw, order_time); -- Optional: Order by day of the week
```
