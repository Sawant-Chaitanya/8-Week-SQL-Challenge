## Q1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 

```SQL
--Q1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?
SELECT 
    -- Selecting the total money for each pizza type
    SUM(CASE 
            WHEN pizza_name = 'Meatlovers' THEN 12
            WHEN pizza_name = 'Vegetarian' THEN 10
        END) AS total_money
FROM
    -- Joining customer_orders with pizza_names and runner_orders tables
    customer_orders AS cu_od
    LEFT JOIN pizza_names AS p_n ON cu_od.pizza_id = p_n.pizza_id
    INNER JOIN runner_orders ro ON ro.order_id = cu_od.order_id
WHERE
    -- Filtering out cancelled orders
    ro.cancellation IS NULL;

```
---

## Q2.What if there was an additional $1 charge for any pizza extras?

```SQL
--Q2.What if there was an additional $1 charge for any pizza extras?


WITH ValidOrders AS
(
    -- Selecting valid orders without cancellations
    SELECT 
        cu_od.order_id,
        pizza_id,
        CONVERT(int, value) AS ect 
    FROM
        customer_orders AS cu_od
    CROSS APPLY 
        STRING_SPLIT(cu_od.extras, ',') AS extras
    INNER JOIN 
        runner_orders ro ON ro.order_id = cu_od.order_id
    WHERE
        ro.cancellation IS NULL
),
Counts AS
(
    -- Counting non-zero extras for each order and pizza
    SELECT  
        order_id,
        pizza_id,
        COUNT(CASE WHEN ect <> 0 THEN 1 END) AS non_zero_count
    FROM 
        ValidOrders
    GROUP BY 
        order_id,
        pizza_id
),
SumTotals AS
(
    -- Calculating sum_tot based on pizza type
    SELECT  
        order_id,
        pizza_id,
        CASE 
            WHEN pizza_id = 1 THEN 12 + (non_zero_count * 1)
            ELSE 10 + (non_zero_count * 1)
        END AS sum_tot
    FROM 
        Counts
)
-- Summing up total sum
SELECT  
    SUM(sum_tot) AS total_sum
FROM 
    SumTotals;
```

---

## Q2.What if there was an additional $1 charge for any pizza extras?
>  **Add cheese is $1 extra ($2 for extra cheese)**
     
```sql


-- Calculate pizza prices and extra charges directly in a single query
WITH pricing AS (
    SELECT 
        co.id, 
        pn.pizza_name,
        -- Calculate pizza price based on pizza name
        CASE 
            WHEN pn.pizza_name = 'Meatlovers' THEN 12
            ELSE 10
        END AS pizza_price,
        -- Calculate extra charge based on topping name
        CASE 
            WHEN CAST(pt.topping_name AS varchar(MAX)) = 'Cheese' THEN 2
            WHEN pt.topping_name IS NOT NULL THEN 1
            ELSE 0
        END AS extra_charge
    FROM 
        #cust_orders AS co
    JOIN 
        pizza_names pn ON pn.pizza_id = co.pizza_id
    JOIN 
        runner_orders ro ON ro.order_id = co.order_id
    LEFT JOIN 
        #extras AS pe ON pe.id = co.id
    LEFT JOIN 
        pizza_toppings pt ON pt.topping_id = pe.extra_id
    WHERE 
        ro.cancellation IS NULL
),
-- Aggregate prices and charges by pizza
aggregated_pricing AS (
    SELECT 
        id, 
        pizza_name, 
        MAX(pizza_price) AS pizza_price, 
        SUM(extra_charge) AS extra_charges
    FROM 
        pricing
    GROUP BY 
        id, 
        pizza_name
)
-- Calculate total earned by summing pizza prices and extra charges
SELECT 
    SUM(pizza_price) + SUM(extra_charges) AS total_earned
FROM 
    aggregated_pricing;
```

### Explanation

#### Step 1: Calculate Pizza Prices and Extra Charges
```sql
WITH pricing AS (
    SELECT 
        co.id, 
        pn.pizza_name,
        -- Calculate pizza price based on pizza name
        CASE 
            WHEN pn.pizza_name = 'Meatlovers' THEN 12
            ELSE 10
        END AS pizza_price,
        -- Calculate extra charge based on topping name
        CASE 
            WHEN CAST(pt.topping_name AS varchar(MAX)) = 'Cheese' THEN 2
            WHEN pt.topping_name IS NOT NULL THEN 1
            ELSE 0
        END AS extra_charge
    FROM 
        #cust_orders AS co
    JOIN 
        pizza_names pn ON pn.pizza_id = co.pizza_id
    JOIN 
        runner_orders ro ON ro.order_id = co.order_id
    LEFT JOIN 
        #extras AS pe ON pe.id = co.id
    LEFT JOIN 
        pizza_toppings pt ON pt.topping_id = pe.extra_id
    WHERE 
        ro.cancellation IS NULL
),
```
- The `pricing` common table expression (CTE) calculates the pizza prices and extra charges directly in a single query.
- It selects the order ID, pizza name, pizza price, and extra charge columns.
- The `CASE` statement calculates the pizza price based on the pizza name:
  - If the pizza name is 'Meatlovers', the pizza price is set to 12; otherwise, it's set to 10.
- Another `CASE` statement calculates the extra charge based on the topping name:
  - If the topping name is 'Cheese', the extra charge is set to 2.
  - If the topping name is not 'Cheese' but is not NULL, the extra charge is set to 1.
  - Otherwise, the extra charge is set to 0.
- It joins the `#cust_orders` table with `pizza_names`, `runner_orders`, `#extras`, and `pizza_toppings` tables to retrieve relevant data.
- It filters out orders with cancellations (`ro.cancellation IS NULL`).

#### Step 2: Aggregate Prices and Charges by Pizza
```sql
aggregated_pricing AS (
    SELECT 
        id, 
        pizza_name, 
        MAX(pizza_price) AS pizza_price, 
        SUM(extra_charge) AS extra_charges
    FROM 
        pricing
    GROUP BY 
        id, 
        pizza_name
),
```
- The `aggregated_pricing` CTE aggregates the prices and charges by pizza.
- It groups the data by order ID and pizza name.
- It calculates the maximum pizza price and the sum of extra charges for each pizza.

#### Step 3: Calculate Total Earned
```sql
-- Calculate total earned by summing pizza prices and extra charges
SELECT 
    SUM(pizza_price) + SUM(extra_charges) AS total_earned
FROM 
    aggregated_pricing;
```
- The final query calculates the total earned by summing the pizza prices and extra charges from the `aggregated_pricing` CTE.
- It sums up the `pizza_price` and `extra_charges` columns to get the total earnings.
- The result is the total revenue earned from pizza sales, including base prices and extra charges.
---


## Q3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset -  generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```SQL
--Q3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - 
--generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

-- Drop the table if it exists
DROP TABLE IF EXISTS customer_ratings;

-- Create the customer_ratings table with order_id and rating columns
CREATE TABLE customer_ratings (
    order_id INTEGER,
    rating INTEGER,
    comment VARCHAR(MAX) , -- Comments or feedback from the customer
	runner_id INTEGER  -- ID of the runner who delivered the order
);

-- Inserting customer ratings data into the customer_ratings table
INSERT INTO customer_ratings (order_id, rating, comment, runner_id)
VALUES
    ('1', '4', 'Runner was a bit delayed but had a pleasant demeanor!', '1'),
    ('2', '5', NULL, '1'), -- No comment provided, but rated 5 stars
    ('3', '5', 'Service was excellent!', '1'),
    ('4', '2', 'Runner was late and seemed disinterested', '2'), -- Negative comment about the runner's attitude
    ('5', '5', NULL, '3'), -- No comment provided, but rated 5 stars
    ('7', '5', 'Outstanding service! This runner deserves a promotion.', '2'),
    ('8', '5', NULL, '2'), -- No comment provided, but rated 5 stars
    ('10', '5', 'Everything was perfect!', '1'); -- Customer left positive feedback

	--SELECT * FROM customer_ratings
```
---
## Q4.	Using your newly generated table - can you combine all of the information to form a table
```SQL
--Q4.	Using your newly generated table - can you combine all of the information to form a table
--	with the following information for successful deliveries?
		--customer_id
		--order_id
		--runner_id
		--rating
		--order_time
		--pickup_time
		--Time between order and pickup
		--Delivery duration
		--Average speed
		--Total number of pizzas

-- Retrieve customer order details along with runner and rating information
SELECT
    co.customer_id AS customer_id,  
    ro.order_id AS order_id,  
    ro.runner_id AS runner_id, 
    cr.rating AS rating,  
    co.order_time AS order_time,  
    ro.pickup_time AS pickup_time,  
    -- Calculate time taken to pick up the order in minutes
    DATEPART(MINUTE, ro.pickup_time - co.order_time) + DATEPART(HOUR, ro.pickup_time - co.order_time) * 60 AS time_to_pickup,
    ro.duration AS duration,  -- Alias for duration column
    -- Calculate average speed in km/h rounded to 2 decimal places
    ROUND(CAST(ro.distance / ro.duration * 60 AS DECIMAL), 2) AS avg_speed_kmh,
    COUNT(co.order_id) AS total_pizzas  -- Alias for total_pizzas column
FROM 
    runner_orders as ro
JOIN 
    #cust_orders as co ON co.order_id = ro.order_id
JOIN 
    customer_ratings cr ON cr.order_id = ro.order_id
WHERE 
    ro.cancellation IS NULL
GROUP BY
    co.customer_id,
    ro.order_id,
    ro.runner_id,
    cr.rating,
    co.order_time,
    ro.pickup_time,
    ro.duration,
    ro.distance  
ORDER BY 
    co.customer_id, ro.order_id;
```
---
## Q5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```SQL
--Q5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras
--and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

-- Calculate total revenue, total cost (delivery expenses), and total profit
WITH pizza_costs AS (
    -- Calculate the cost of each pizza based on its type
    SELECT 
        co.order_id,
        pn.pizza_name,
        CASE 
            WHEN pn.pizza_name = 'Meatlovers' THEN 12
            WHEN pn.pizza_name = 'Vegetarian' THEN 10
            ELSE 0
        END AS pizza_cost
    FROM 
        #cust_orders co
    JOIN 
        pizza_names pn ON co.pizza_id = pn.pizza_id
	JOIN runner_orders ro ON ro.order_id = co.order_id
      WHERE ro.cancellation IS NULL

),
-- Calculate total revenue by summing the cost of each pizza
total_revenue AS (
    SELECT 
        SUM(pizza_cost) AS tot_revenue
    FROM 
        pizza_costs
),
-- Calculate total delivery expenses by summing the distance traveled by runners
total_expenses AS (
    SELECT 
        SUM(ro.distance * 0.30) AS tot_expenses
    FROM 
        runner_orders ro
)
-- Calculate total profit by subtracting total expenses from total revenue
SELECT 
    tot_revenue,
    tot_expenses AS tot_cost,
    tot_revenue - tot_expenses AS tot_profit
FROM 
    total_revenue
CROSS JOIN 
    total_expenses;
```
