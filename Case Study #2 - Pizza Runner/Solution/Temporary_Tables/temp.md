
# Temporary Tables Creation and Data Insertion
> ## Mostly for convinces (specifically in section C.Ingredient Optimisation section ),  following temp_tables are used in SSMS

----


### temporary table #cust_orders

```sql
-- Create temporary table #cust_orders
CREATE TABLE #cust_orders (
    id INT IDENTITY(1,1) PRIMARY KEY, -- Primary key column auto-incremented
    order_id INT,                      -- Order ID column
    customer_id INT,                   -- Customer ID column
    pizza_id INT,                      -- Pizza ID column
    exclusions VARCHAR(MAX),           -- Exclusions column (comma-separated values)
    extras VARCHAR(MAX),               -- Extras column (comma-separated values)
    order_time DATETIME                -- Order time column
);

-- Insert data into the temporary table
INSERT INTO #cust_orders (order_id, customer_id, pizza_id, exclusions, extras, order_time)
SELECT order_id, customer_id, pizza_id, exclusions, extras, order_time
FROM customer_orders
ORDER BY order_id;

-- Select all records from the temporary table
SELECT * FROM #cust_orders;
```

### Explanation

We created a temporary table `#cust_orders` with the following columns:
- `id`: Primary key column auto-incremented using `IDENTITY(1,1)`.
- `order_id`: Represents the ID of the order.
- `customer_id`: Represents the ID of the customer who placed the order.
- `pizza_id`: Represents the ID of the pizza ordered.
- `exclusions`: Represents any exclusions for the ordered pizza (comma-separated values).
- `extras`: Represents any extra toppings for the ordered pizza (comma-separated values).
- `order_time`: Represents the time when the order was placed.

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'customer_orders';

We populated this temporary table with data from the `customer_orders` table, ordering the records by `order_id`. This temporary table can be used for further analysis or processing within the current session and will be automatically dropped when the session ends

---


## Temporary Table #Pizza

### Description
This temporary table stores information about pizzas, including their IDs, names, and toppings.

### SQL Code
```sql
-- Create temporary table #Pizza
CREATE TABLE #Pizza (
    pizza_id INT,                    -- Pizza ID column
    pizza_name VARCHAR(100),         -- Pizza name column
    toppings VARCHAR(MAX)            -- Toppings column
);

-- Insert data into the temporary table
INSERT INTO #Pizza
SELECT 
    pr.pizza_id, 
    pn.pizza_name,
    LTRIM(RTRIM(value)) AS toppings
FROM 
    pizza_recipes pr
CROSS APPLY 
    STRING_SPLIT(CONVERT(VARCHAR(MAX), pr.toppings), ',') AS toppings
INNER JOIN 
    pizza_names pn ON pn.pizza_id = pr.pizza_id;

-- Select all records from the temporary table
SELECT * FROM #Pizza;
```
----
## Temporary Table #exclusions

### Description
This temporary table stores the IDs of exclusions for customer orders.

### SQL Code
```sql
-- Create temporary table #exclusions
SELECT 
    id,
    order_id,
    CAST(value AS INT) AS exclusion_id
INTO 
    #exclusions
FROM 
    #cust_orders
CROSS APPLY 
    STRING_SPLIT(exclusions, ',');

-- Select all records from the temporary table
SELECT * FROM #exclusions;
```
----
## Temporary Table #extras

### Description
This temporary table stores the IDs of extras for customer orders.

### SQL Code
```sql
-- Create temporary table #extras
SELECT 
    id,
    order_id,
    CAST(value AS INT) AS extra_id
INTO 
    #extras
FROM 
    #cust_orders
CROSS APPLY 
    STRING_SPLIT(extras, ',');

-- Select all records from the temporary table
SELECT * FROM #extras;
```

