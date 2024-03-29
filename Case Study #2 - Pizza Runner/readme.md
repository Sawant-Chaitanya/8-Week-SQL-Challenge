
# Case Study #2 - Pizza Runner
![screenshot of pizza runner case study](https://8weeksqlchallenge.com/images/case-study-designs/2.png)

## Contents
- [Introduction](#introduction)
- [Available Data](#available-data)
    - [Table 1: runners](#table-1-runners)
    - [Table 2: customer_orders](#table-2-customer_orders)
    - [Table 3: runner_orders](#table-3-runner_orders)
    - [Table 4: pizza_names](#table-4-pizza_names)
    - [Table 5: pizza_recipes](#table-5-pizza_recipes)
    - [Table 6: pizza_toppings](#table-6-pizza_toppings)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions](#case-study-questions)
    - [A. Pizza Metrics](#a-pizza-metrics)
    - [B. Runner and Customer Experience](#b-runner-and-customer-experience)
    - [C. Ingredient Optimisation](#c-ingredient-optimisation)
    - [D. Pricing and Ratings](#d-pricing-and-ratings)
    - [E. Bonus Questions](#e-bonus-questions)
- [Conclusion](#conclusion)



## Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide???🍕🤤 (Well according to Wikipedia anyway…).
  Inspired by 80s retro styling and the universal love for pizza, Danny Ma launched Pizza Runner, a delivery service aiming to combine nostalgia with convenience. The concept involves delivering fresh pizza from Pizza Runner Headquarters using a fleet of "runners" and a mobile app for order management.



## Available Data
The Pizza Runner database schema includes the following tables:

### Table 1: runners
Captures registration dates for each new runner.

| runner_id | registration_date |
|-----------|-------------------|
| 1         | 2021-01-01        |
| 2         | 2021-01-03        |
| 3         | 2021-01-08        |
| 4         | 2021-01-15        |

### Table 2: customer_orders
Records individual pizza orders with details like order time, pizza type, exclusions, and extras.


| order_id | customer_id | pizza_id | exclusions | extras | order_time         |
|----------|-------------|----------|------------|--------|--------------------|
| 1        | 101         | 1        |            |        | 2020-01-01 18:05:02|
| 2        | 101         | 1        |            |        | 2020-01-01 19:00:52|
| 3        | 102         | 1        |            |        | 2020-01-02 23:51:23|
| 3        | 102         | 2        |            | NULL   | 2020-01-02 23:51:23|
| 4        | 103         | 1        | 4          |        | 2020-01-04 13:23:46|
| 4        | 103         | 1        | 4          |        | 2020-01-04 13:23:46|
| 4        | 103         | 2        | 4          |        | 2020-01-04 13:23:46|
| 5        | 104         | 1        | null       | 1      | 2020-01-08 21:00:29|
| 6        | 101         | 2        | null       | null   | 2020-01-08 21:03:13|
| 7        | 105         | 2        | null       | 1      | 2020-01-08 21:20:29|
| 8        | 102         | 1        | null       | null   | 2020-01-09 23:54:33|
| 9        | 103         | 1        | 4          | 1, 5   | 2020-01-10 11:22:59|
| 10       | 104         | 1        | null       | null   | 2020-01-11 18:34:49|
| 10       | 104         | 1        | 2, 6       | 1, 4   | 2020-01-11 18:34:49|






### Table 3: runner_orders
Contains order delivery details like pickup time, distance, duration, and cancellation status.

| order_id | runner_id | pickup_time         | distance | duration   | cancellation           |
|----------|-----------|---------------------|----------|------------|------------------------|
| 1        | 1         | 2020-01-01 18:15:34 | 20km     | 32 minutes |                        |
| 2        | 1         | 2020-01-01 19:10:54 | 20km     | 27 minutes |                        |
| 3        | 1         | 2020-01-03 00:12:37 | 13.4km   | 20 mins    |                        |
| 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40         |                        |
| 5        | 3         | 2020-01-08 21:10:57 | 10       | 15         |                        |
| 6        | 3         | null                | null     | null       | Restaurant Cancellation|
| 7        | 2         | 2020-01-08 21:30:45 | 25km     | 25mins     | null                   |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4 km  | 15 minute  | null                   |
| 9        | 2         | null                | null     | null       | Customer Cancellation  |
| 10       | 1         | 2020-01-11 18:50:20 | 10km     | 10minutes  | null                   |

### Table 4: pizza_names
Maps pizza IDs to pizza names.

| pizza_id | pizza_name   |
|----------|--------------|
| 1        | Meat Lovers  |
| 2        | Vegetarian   |

### Table 5: pizza_recipes
Lists toppings for each pizza.

| pizza_id | toppings                |
|----------|-------------------------|
| 1        | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2        | 4, 6, 7, 9, 11, 12      |

### Table 6: pizza_toppings
Contains topping IDs and names.

| topping_id | topping_name  |
|------------|---------------|
| 1          | Bacon         |
| 2          | BBQ Sauce     |
| 3          | Beef          |
| 4          | Cheese        |
| 5          | Chicken       |
| 6          | Mushrooms     |
| 7          | Onions        |
| 8          | Pepperoni     |
| 9          | Peppers       |
| 10         | Salami        |
| 11         | Tomatoes      |
| 12         | Tomato Sauce  |


## Entity Relationship Diagram
![ER Diagram](https://github.com/Sawant-Chaitanya/Week-2/assets/89839734/c1bc9034-f1ae-4330-92f9-c5031ed92e0c)

## Case Study Questions

### A. Pizza Metrics
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meat Lovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

### B. Runner and Customer Experience
1. How many runners signed up for each 1-week period?
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

### C. Ingredient Optimisation
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table.
5. Generate an alphabetically ordered comma-separated ingredient list for each pizza order.

### D. Pricing and Ratings
1. Calculate the total revenue and expenses.
2. Calculate the total profit.
3. Design a table for customer ratings and insert sample data.
4. Join information for successful deliveries.

### E. Bonus Questions
1. Impact of new pizza additions

 on the existing data design.
2. Write an INSERT statement for a new Supreme pizza.

## Conclusion
The Pizza Runner case study offers a comprehensive dataset to explore various aspects of a delivery service business. From analyzing pizza metrics to optimizing ingredients and pricing, this case study provides valuable insights into operational efficiency and customer satisfaction.


