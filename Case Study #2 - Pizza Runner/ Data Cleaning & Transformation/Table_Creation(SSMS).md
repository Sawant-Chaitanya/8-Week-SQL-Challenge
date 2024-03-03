# Case Study: Pizza Runner


## Available Data
Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimize Pizza Runner’s operations.

### Entity Relationship Diagram
![ER Diagram](https://github.com/Sawant-Chaitanya/Week-2/assets/89839734/c1bc9034-f1ae-4330-92f9-c5031ed92e0c)

Table 1: runners
The runners table shows the registration_date for each new runner

```sql
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
```

Table 2: customer_orders
Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.

```sql
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);
```

Table 3: runner_orders
After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

```sql
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);
```

Table 4: pizza_names
At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

```sql
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
```

Table 5: pizza_recipes
Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

```sql
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
```

Table 6: pizza_toppings
This table contains all of the topping_name values with their corresponding topping_id value

```sql
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
```

## Schema SQL Query Results

```sql
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras")
VALUES
  ('1', '101', '1', '', '' ),
  ('2', '101', '1', '', ''),
  ('3', '102', '1', '', '''),
  ('3', '102', '2', '', NULL),
  ('4', '103', '1', '4', ''),
  ('4', '103', '1', '4', ''),
  ('4', '103', '2', '4', ''),
  ('5', '104', '1', 'null', '1'),
  ('6', '101', '2', 'null', 'null'),
  ('7', '105', '2', 'null', '1'),
  ('8', '102', '1', 'null', 'null'),
  ('9', '103', '1', '4', '1, 5'),
  ('10', '104', '1', 'null', 'null'),
  ('10', '104', '1', '2, 6', '1, 4');


	-- Update the customer_orders table to insert date values into the order_time column
UPDATE customer_orders
SET order_time = 
    CASE 
        WHEN order_id = 1 THEN '2020-01-01 18:05:02'
        WHEN order_id = 2 THEN '2020-01-01 19:00:52'
        WHEN order_id = 3 THEN '2020-01-02 23:51:23'
        WHEN order_id = 4 THEN '2020-01-04 13:23:46'
        WHEN order_id = 5 THEN '2020-01-08 21:00:29'
        WHEN order_id = 6 THEN '2020-01-08 21:03:13'
        WHEN order_id = 7 THEN '2020-01-08 21:20:29'
        WHEN order_id = 8 THEN '2020-01-09 23:54:33'
        WHEN order_id = 9 THEN '2020-01-10 11:22:59'
        WHEN order_id = 10 THEN '2020-01-11 18:34:49'
    END;

INSERT INTO runner_orders
  (order_id, runner_id, distance, duration, cancellation)
VALUES
    (1, 1, '20km', '32 minutes', ''),
    (2, 1, '20km', '27 minutes', ''),
    (3, 1, '13.4km', '20 mins', NULL),
    (4, 2, '23.4', '40', NULL),
    (5, 3, '10', '15', NULL),
    (6, 3, NULL, NULL, 'Restaurant Cancellation'),
    (7, 2, '25km', '25mins', NULL),
    (8, 2, '23.4 km', '15 minute', NULL),
    (9, 2, NULL, NULL, 'Customer Cancellation'),
    (10, 1, '10km', '10minutes', NULL);


-- Update the runner_orders table to insert date values into the pickup_time column
UPDATE runner_orders
SET pickup_time = 
    CASE 
        WHEN order_id = 1 THEN '2020-01-01 18:15:34'
        WHEN order_id = 2 THEN '2020-01-01 19:10:54'
        WHEN order_id = 3 THEN '2020-01-03 00:12:37'
        WHEN order_id = 4 THEN '2020-01-04 13:53:03'
        WHEN order_id = 5 THEN '2020-01-08 21:10:57'
        WHEN order_id = 7 THEN '2020-01-08 21:30:45'
        WHEN order_id = 8 THEN '2020-01-10 00:15:02'
        WHEN order_id = 10 THEN '2020-01-11 18:50:20'
    END;


INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meat Lovers'),
  (2, 'Vegetarian');

INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
```

This data setup provides the foundation for analyzing Pizza Runner's operations, including runner registration, customer orders, runner assignments, and pizza details.
