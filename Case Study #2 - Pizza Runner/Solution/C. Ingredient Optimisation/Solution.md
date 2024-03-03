## Q1.What are the standard ingredients for each pizza?
```SQL
--Q1.What are the standard ingredients for each pizza?
WITH pizza AS (
    SELECT 
        pizza_recipes.pizza_id, 
        pizza_names.pizza_name, 
        LTRIM(RTRIM(value)) AS toppings
    FROM 
        pizza_recipes
    CROSS APPLY 
        STRING_SPLIT(CONVERT(VARCHAR(MAX), pizza_recipes.toppings), ',') AS toppings
    INNER JOIN 
        pizza_names ON pizza_names.pizza_id = pizza_recipes.pizza_id
)
SELECT 
    pizza.pizza_name, 
    pizza_toppings.topping_name 
FROM 
    pizza
INNER JOIN 
    pizza_toppings ON pizza_toppings.topping_id = pizza.toppings
order BY
	 CAST(pizza.pizza_name as varchar), 
     CAST(pizza_toppings.topping_name as varchar) ;
```
----
### Query Explanation

This query retrieves pizza names along with their respective toppings from the `pizza_recipes` and `pizza_names` tables. It first splits the comma-separated toppings into individual rows, trims any leading or trailing spaces from each topping, and then joins them with the `pizza_names` table to get the corresponding pizza names. Finally, it joins the result with the `pizza_toppings` table to get the names of the toppings and orders the result alphabetically by pizza name and topping name.

#### Steps:

1. **Common Table Expression (CTE) Definition (pizza)**:
   ```sql
   WITH pizza AS (
       SELECT 
           pizza_recipes.pizza_id, 
           pizza_names.pizza_name, 
           LTRIM(RTRIM(value)) AS toppings
       FROM 
           pizza_recipes
       CROSS APPLY 
           STRING_SPLIT(CONVERT(VARCHAR(MAX), pizza_recipes.toppings), ',') AS toppings
       INNER JOIN 
           pizza_names ON pizza_names.pizza_id = pizza_recipes.pizza_id
   )
   ```
   - This part defines a CTE named `pizza`.
   - It selects the `pizza_id`, `pizza_name`, and trimmed `toppings` from the `pizza_recipes` table, splitting the comma-separated values in the `toppings` column into individual rows using [`STRING_SPLIT`](https://www.sqlservertutorial.net/sql-server-string-functions/sql-server-string_split-function/).
   - It then joins the result with the `pizza_names` table based on the `pizza_id`.

2. **Main Query**:
   ```sql
   SELECT 
       pizza.pizza_name, 
       pizza_toppings.topping_name 
   FROM 
       pizza
   INNER JOIN 
       pizza_toppings ON pizza_toppings.topping_id = pizza.toppings
   ```
   - This part of the query selects the `pizza_name` and `topping_name` from the `pizza` CTE.
   - It joins the `pizza` CTE with the `pizza_toppings` table based on the `toppings` column.

3. **ORDER BY clause**:
   ```sql
   ORDER BY
       CAST(pizza.pizza_name as varchar), -- casted as varchar as text type cannot be sorted
       CAST(pizza_toppings.topping_name as varchar) ; -- casted as varchar as text type cannot be Sorted
   ```
   - This part of the query orders the result alphabetically by pizza name and topping name.
   - It uses the `CAST` function to cast the text types to varchar, as text type cannot be sorted directly.

#### Purpose:
The purpose of this query is to retrieve a list of pizzas along with their toppings, ensuring that the toppings are properly trimmed and the result is ordered alphabetically by pizza name and topping name. This organized list can be useful for menu display or analysis purposes.

---


## Q2.What was the most commonly added extra?
```SQL
--Q2.What was the most commonly added extra?
-- CTE to calculate the most common extra topping
with MostCommonTopping as 
(
   SELECT
      TOP 1 value AS topping_id,
      COUNT(LTRIM(RTRIM(value))) AS count 
   FROM
      customer_orders CROSS APPLY STRING_SPLIT(CONVERT(VARCHAR(MAX), extras), ',') AS extra 
   Group by
      value 
   order by
      value desc 
)
-- Main query to fetch the topping name and its count
SELECT
   topping_name,
   count 
from
   pizza_toppings as pt 
   inner join
      MostCommonTopping as mt 
      on pt.topping_id = mt.topping_id;
```
---

## Q3.What was the most common exclusion?

```SQL
--Q3.What was the most common exclusion?
-- CTE to calculate the most common excluded topping
with MostCommonTopping as 
(
   SELECT
      TOP 1 value AS topping_id,
      COUNT(LTRIM(RTRIM(value))) AS count 
   FROM
      customer_orders CROSS APPLY STRING_SPLIT(CONVERT(VARCHAR(MAX), exclusions), ',') AS extra 
   Group by
      value 
   order by
      value desc 
)
-- Main query to fetch the topping name and its count
SELECT
   topping_name,
   count 
from
   pizza_toppings as pt 
   inner join
      MostCommonTopping as mt 
      on pt.topping_id = mt.topping_id;
```
---

## Q4. Generate an order item for each record in the customers_orders table in the format of one of the following:

```SQL
--Q4. Generate an order item for each record in the customers_orders table in the format of one of the following:
		--Meat Lovers
		--Meat Lovers - Exclude Beef
		--Meat Lovers - Extra Bacon
		--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
-- This query generates order items for each record in the `customers_orders` table,
-- formatting them with base pizza name, exclusions (if present), and extras (if present).

WITH OrderItems AS (
  -- Select relevant data from `customer_orders` and `pizza_names` tables.
  SELECT
    co.order_id,
    pn.pizza_name,
    COALESCE(co.exclusions, '') AS exclusions,
    COALESCE(co.extras, '') AS extras
  FROM
    customer_orders AS co
  INNER JOIN
    pizza_names AS pn ON co.pizza_id = pn.pizza_id
)

SELECT
  order_id,
  CONCAT(
    pizza_name, -- Base pizza name

    -- Append " - Exclude " and list of exclusions if present
    CASE WHEN exclusions <> '' THEN
      ' - Exclude ' + REPLACE(
        (
          -- Aggregate topping names from `pizza_toppings` using exclusion IDs
          SELECT STRING_AGG(CAST(pt_exclusions.topping_name AS NVARCHAR(MAX)), ', ')
          FROM pizza_toppings AS pt_exclusions
          WHERE pt_exclusions.topping_id IN (SELECT CAST(value AS INT) FROM STRING_SPLIT(exclusions, ','))
        ),
        ',', ', '
      )
    ELSE '' END,

    -- Append " - Extra " and list of extras if present
    CASE WHEN extras <> '' THEN
      ' - Extra ' + REPLACE(
        (
          -- Aggregate topping names from `pizza_toppings` using extra IDs
          SELECT STRING_AGG(CAST(pt_extras.topping_name AS NVARCHAR(MAX)), ', ')
          FROM pizza_toppings AS pt_extras
          WHERE pt_extras.topping_id IN (SELECT CAST(value AS INT) FROM STRING_SPLIT(extras, ','))
        ),
        ',', ', '
      )
    ELSE '' END
  ) AS order_detail
FROM
  OrderItems;
```
let's break down the query into steps based on the instructions provided:

### Step 1: Extract Order Details Using a Common Table Expression (CTE)
```sql
-- Create a Common Table Expression (CTE) to extract order details
WITH OrderItems AS (
    SELECT 
        co.order_id,
        pn.pizza_name,
        COALESCE(co.exclusions, '') AS exclusions,
        COALESCE(co.extras, '') AS extras
    FROM 
        customer_orders AS co
    INNER JOIN 
        pizza_names AS pn ON co.pizza_id = pn.pizza_id
)
```
- **Explanation**:
  - The `OrderItems` CTE retrieves order details from the `customer_orders` table.
  - It selects the `order_id`, `pizza_name`, `exclusions`, and `extras`.
  - The `COALESCE` function replaces NULL values in `exclusions` and `extras` columns with empty strings to avoid NULL-related errors.



### Step 2: Construct the `order_detail` Column

```sql
SELECT 
    order_id,
    CONCAT(pizza_name, 
           CASE 
               WHEN exclusions <> '' THEN 
                   ' - Exclude ' + REPLACE((SELECT STRING_AGG(CAST(pt_exclusions.topping_name AS NVARCHAR(MAX)), ', ') 
                                             FROM pizza_toppings AS pt_exclusions 
                                             WHERE pt_exclusions.topping_id IN (SELECT CAST(value AS INT) FROM STRING_SPLIT(exclusions, ','))), ',', ', ')
               ELSE ''
           END,
           CASE 
               WHEN extras <> '' THEN 
                   ' - Extra ' + REPLACE((SELECT STRING_AGG(CAST(pt_extras.topping_name AS NVARCHAR(MAX)), ', ') 
                                         FROM pizza_toppings AS pt_extras 
                                         WHERE pt_extras.topping_id IN (SELECT CAST(value AS INT) FROM STRING_SPLIT(extras, ','))), ',', ', ')
               ELSE ''
           END) AS order_detail
FROM 
    OrderItems;
```

- **Explanation**:
  1. **SELECT statement**:
     - The main query selects `order_id` and constructs the `order_detail` column using the `CONCAT` function.
  
  2. **Concatenation with `CONCAT`**:
     - The `CONCAT` function concatenates the `pizza_name` with any exclusions and extras.
  
  3. **Exclusions Handling**:
     - The `CASE` statement checks if there are exclusions (`exclusions <> ''`). If there are, it appends '- Exclude' to the `order_detail`.
  
  4. **Extras Handling**:
     - Similarly, the `CASE` statement checks if there are extras (`extras <> ''`). If there are, it appends '- Extra' to the `order_detail`.
  
  5. **String Aggregation with `STRING_AGG`**:
     - For both exclusions and extras, the `STRING_SPLIT` function splits the comma-separated list of topping IDs into individual values.
     - The `STRING_AGG` function aggregates these topping names into a single string, separated by commas.
  
  6. **Formatting with `REPLACE`**:
     - The `REPLACE` function replaces commas with ', ' to ensure consistent formatting in the aggregated string.

### Conclusion
This step constructs the `order_detail` column by concatenating the `pizza_name` with any exclusions and extras, handling each condition appropriately. The `STRING_SPLIT` and `STRING_AGG` functions are used to process the comma-separated lists of toppings. The result is formatted as specified in the instructions.

---

## Q5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients

> For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

```SQL
WITH pizza_details AS (
    -- Selecting pizza order details and identifying doubled toppings
    SELECT
        co.id,
        co.order_id,
        co.pizza_id,
        pn.pizza_name,
        pt.topping_name,
        -- Using a window function to check for doubled toppings
        MAX(CASE
            WHEN pt.topping_id IN (
                SELECT extra_id FROM #extras WHERE #extras.id = co.id
            ) THEN '2x'
            ELSE NULL
        END) OVER (PARTITION BY co.id) AS double_option
    FROM
        #cust_orders co
    JOIN
        #pizza pi ON pi.pizza_id = co.pizza_id
    JOIN
        pizza_names pn ON pn.pizza_id = pi.pizza_id
    JOIN
        pizza_toppings pt ON pt.topping_id = pi.toppings
    WHERE
        pt.topping_id NOT IN (
            SELECT exclusion_id FROM #exclusions WHERE #exclusions.id = co.id)
)

-- Aggregating pizza order details and constructing the final output
SELECT
    id,
    order_id,
    -- Concatenating pizza name with toppings, considering doubled toppings
    CONCAT(
        pizza_name,
        ': ',
        -- Using STRING_AGG to concatenate toppings into a comma-separated list
        STRING_AGG(
            CONCAT(
                double_option, -- Adding '2x' prefix for doubled toppings
                topping_name
            ),
            ', '
        )
    ) AS order_detail
FROM
    pizza_details
GROUP BY
    id,
    order_id,
    pizza_id,
    pizza_name
ORDER BY
    id;
```


let's break down the query into steps based on the instructions provided:

### Objective:
The objective of the query is to generate an alphabetically ordered comma-separated ingredient list for each pizza order from the customer_orders table. Additionally, it aims to add a '2x' in front of any relevant ingredients.

Here is the Query Breakdown:


### **1.Common Table Expression (CTE) Definition (pizza_details):**

```sql
WITH pizza_details AS (
    -- Selecting pizza order details and identifying doubled toppings
    SELECT
        co.id,
        co.order_id,
        co.pizza_id,
        pn.pizza_name,
        pt.topping_name,
        -- Using a window function to check for doubled toppings
        MAX(CASE
            WHEN pt.topping_id IN (
                SELECT extra_id FROM #extras WHERE #extras.id = co.id
            ) THEN '2x'
            ELSE NULL
        END) OVER (PARTITION BY co.id) AS double_option
    FROM
        #cust_orders co
    JOIN
        #pizza pi ON pi.pizza_id = co.pizza_id
    JOIN
        pizza_names pn ON pn.pizza_id = pi.pizza_id
    JOIN
        pizza_toppings pt ON pt.topping_id = pi.toppings
    WHERE
        pt.topping_id NOT IN (
            SELECT exclusion_id FROM #exclusions WHERE #exclusions.id = co.id)
)
```

This part of the query defines a Common Table Expression (CTE) named `pizza_details`. It selects pizza order details such as `id`, `order_id`, `pizza_id`, `pizza_name`, and `topping_name`. Additionally, it utilizes a window function (`MAX() OVER`) to identify doubled toppings based on a condition specified in the subquery.

### **2.Main Query**:

```sql
-- Aggregating pizza order details and constructing the final output
SELECT
    id,
    order_id,
    -- Concatenating pizza name with toppings, considering doubled toppings
    CONCAT(
        pizza_name,
        ': ',
        -- Using STRING_AGG to concatenate toppings into a comma-separated list
        STRING_AGG(
            CONCAT(
                double_option, -- Adding '2x' prefix for doubled toppings
                topping_name
            ),
            ', '
        )
    ) AS order_detail
FROM
    pizza_details
GROUP BY
    id,
    order_id,
    pizza_id,
    pizza_name
ORDER BY
    id;
```

This part of the query aggregates pizza order details from the `pizza_details` CTE and constructs the final output. It concatenates the pizza name with its toppings, considering doubled toppings using the `double_option` column. The `STRING_AGG` function concatenates toppings into a comma-separated list. Finally, the results are grouped by `id`, `order_id`, `pizza_id`, and `pizza_name`, and ordered by `id`.

### Achieving Main Objectives:

#### Alphabetically Ordered Comma-Separated Ingredient List:
The query achieves this objective by selecting and concatenating toppings using the `STRING_AGG` function, which automatically orders the toppings alphabetically due to the nature of string aggregation.

#### '2x' in Front of Relevant Ingredients:
This objective is achieved by using a window function (`MAX() OVER`) in the CTE to identify doubled toppings. The `double_option` column in the CTE indicates whether a topping is doubled with a '2x' prefix, which is then concatenated with the topping name in the final output.

#### How Using Window Function Helps:
Using a window function allows the query to evaluate the condition for doubled toppings more efficiently compared to using a correlated subquery. Window functions can operate on partitions of data without the need for costly subqueries, resulting in improved performance.


---

## Q6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


```sql
--Q6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

-- Common Table Expression (CTE) to calculate the total quantity of each ingredient
WITH ingredient_counts AS (
    SELECT
         CAST(pt.topping_name AS VARCHAR) AS topping_name,
        COUNT(DISTINCT co.id) AS base_count,  -- Count distinct orders for base ingredients
        SUM(CASE WHEN ex.extra_id IS NOT NULL THEN 1 ELSE 0 END) AS extra_count -- Count extra occurrences
    FROM 
        pizza_toppings pt
    INNER JOIN 
        #pizza pi ON pi.toppings = pt.topping_id
    INNER JOIN 
        #cust_orders co ON co.pizza_id = pi.pizza_id
    LEFT JOIN 
        #extras ex ON ex.id = co.id AND ex.extra_id = pt.topping_id  -- For extra ingredients
    LEFT JOIN 
        #exclusions exl ON exl.id = co.id AND exl.exclusion_id = pt.topping_id -- For excluded toppings
    WHERE 
        exl.exclusion_id IS NULL  -- Filter out excluded toppings
    GROUP BY 
        CAST(pt.topping_name AS VARCHAR)
)

-- Query to select the ingredient name and its total usage count
SELECT
    ingredient_name = topping_name,  
    total_used = base_count + extra_count
FROM 
    ingredient_counts
ORDER BY 
    total_used DESC, ingredient_name;
```

Here is the breakdown of the query:

1. **Common Table Expression (CTE): `ingredient_counts`**
    - This CTE calculates the total quantity of each ingredient used in all delivered pizzas.
    - It selects the topping name, counts the distinct orders for base ingredients (`base_count`), and sums the occurrences of extra ingredients (`extra_count`).
    - The query involves joining the `pizza_toppings`, `#pizza`, `#cust_orders`, `#extras`, and `#exclusions` tables.
    - `LEFT JOIN` is used to account for extra and excluded toppings, filtering out excluded toppings using a `WHERE` clause.
    - The results are grouped by the topping name.
    
    ```sql
    WITH ingredient_counts AS (
        SELECT
            CAST(pt.topping_name AS VARCHAR) AS topping_name,
            COUNT(DISTINCT co.id) AS base_count,  
            SUM(CASE WHEN ex.extra_id IS NOT NULL THEN 1 ELSE 0 END) AS extra_count
        FROM 
            pizza_toppings pt
        INNER JOIN 
            #pizza pi ON pi.toppings = pt.topping_id
        INNER JOIN 
            #cust_orders co ON co.pizza_id = pi.pizza_id
        LEFT JOIN 
            #extras ex ON ex.id = co.id AND ex.extra_id = pt.topping_id
        LEFT JOIN 
            #exclusions exl ON exl.id = co.id AND exl.exclusion_id = pt.topping_id
        WHERE 
            exl.exclusion_id IS NULL
        GROUP BY 
            CAST(pt.topping_name AS VARCHAR)
    )
    ```

2. **Main Query:**
    - Selects the ingredient name (`topping_name`) and its total usage count.
    - The total usage count is calculated by adding the base count (`base_count`) and the extra count (`extra_count`) for each ingredient.
    - Results are ordered by the total usage count in descending order, with ties broken by ingredient name.

    ```sql
    SELECT
        ingredient_name = topping_name,  
        total_used = base_count + extra_count
    FROM 
        ingredient_counts
    ORDER BY 
        total_used DESC, ingredient_name;
    ```

This query provides insights into the most frequently used ingredients in all delivered pizzas, considering both base and extra toppings. It can be helpful for understanding ingredient popularity and optimizing ingredient inventory management.
