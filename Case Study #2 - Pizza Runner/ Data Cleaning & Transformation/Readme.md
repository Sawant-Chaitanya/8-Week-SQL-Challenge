# Data Cleaning & Transformation
---
## Table: customer_orders

In the `customer_orders` table below,  there are
- In  `exclusions` column: there are missing/ blank spaces ' ' and null values. 
- In  `extras` column: there are missing/ blank spaces ' ' and null values.

  
```sql
-- Update the original "customer_orders" table directly
UPDATE pizza_runner.customer_orders
-- Set the exclusions column
SET exclusions =
  CASE
    WHEN exclusions IS NULL THEN ''  -- Replace NULL with empty string
    WHEN exclusions LIKE 'null' THEN TRIM(exclusions)  -- Trim "null" strings
    ELSE exclusions  -- Keep original value
  END,
-- Set the extras column
  extras =
  CASE
    WHEN extras IS NULL THEN ''  -- Replace NULL with empty string
    WHEN extras LIKE 'null' THEN TRIM(extras)  -- Trim "null" strings
    ELSE extras  -- Keep original value
  END
-- Update rows where exclusions or extras are NULL or "null"
WHERE exclusions IS NULL OR exclusions LIKE 'null' OR extras IS NULL OR extras LIKE 'null';

-- Optional: Verify the update results 
SELECT order_id, customer_id, pizza_id, exclusions, extras, order_time
FROM pizza_runner.customer_orders
-- Filter out rows where exclusions or extras are neither NULL nor "null"
WHERE exclusions IS NOT NULL AND exclusions NOT LIKE 'null' AND extras IS NOT NULL AND extras NOT LIKE 'null';
```

### Explanation:
1. **UPDATE statement**: This statement updates the original `customer_orders` table directly.
2. **SET clause**:
   - For the `exclusions` column, it uses a `CASE` statement to handle different scenarios:
     - If `exclusions` is NULL, it replaces it with an empty string.
     - If `exclusions` is 'null', it trims the string and assigns the result to `exclusions`.
     - Otherwise, it keeps the original value of `exclusions`.
   - Similar logic is applied to the `extras` column.
3. **WHERE clause**: This clause filters the rows to be updated. It selects rows where either `exclusions` or `extras` are NULL or 'null'.
4. **Optional SELECT statement**: This is provided to verify the update results without creating another temporary table. It selects the updated columns from `customer_orders` where both `exclusions` and `extras` are not NULL and not 'null'.
----

## Table: runner_orders

 the `runner_orders` table below, there are
- the `exclusions` column: there are missing/ blank spaces ' ' and null values. 
- the `extras` column: there are missing/ blank spaces ' ' and null values

```sql
-- Clean the Data: Update "runner_orders" table directly
UPDATE pizza_runner.runner_orders 
SET pickup_time =
  CASE
    WHEN pickup_time LIKE 'null' THEN ''  -- Replace "null" with empty string
    ELSE pickup_time
  END,
  distance =
  CASE
    WHEN distance LIKE 'null' THEN ''  -- Replace "null" with empty string
    WHEN distance LIKE '%km' THEN TRIM(TRAILING 'km' FROM distance)  -- Trim trailing "km"
    ELSE distance
  END,

  duration = REPLACE(TRANSLATE(duration, 'minutesnull', '           '), ' ', ''),

  cancellation =
  CASE
    WHEN cancellation IS NULL OR cancellation LIKE 'null' THEN ''  -- Replace "null" with empty string
    ELSE cancellation
  END;

```
```SQL
-- Verify the Cleaning Results: Check if any rows still have unclean data in the relevant columns
SELECT *
FROM pizza_runner.runner_orders 
WHERE pickup_time LIKE 'null' OR distance LIKE 'null' OR duration LIKE 'null' OR cancellation IS NULL OR cancellation LIKE 'null' 
or duration like '%min%' or distance like '%Km%';
```


### Explanation:
1. **Clean the Data**:
   - This SQL script updates the `runner_orders` table directly, avoiding temporary tables.
   - It cleans up the data in various columns (`pickup_time`, `distance`, `duration`, `cancellation`) based on specific conditions using `CASE` statements.
   - For each column, it checks if the value is 'null' and replaces it with an empty string or performs additional cleaning operations (trimming, removing units like 'km' or 'mins', etc.).
   - The `WHERE` clause filters the rows to be updated, selecting rows where any of the specified columns contain 'null' values.
2. **Verify the Cleaning Results**:
   - After updating the data, this script checks if any rows still have unclean data in the relevant columns.
   - It selects all columns from the `runner_orders` table where any of the specified columns still contain 'null' values.


----
