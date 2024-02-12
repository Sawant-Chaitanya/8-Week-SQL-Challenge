```SQL
USE dannys_diner;

--1. What is the total amount each customer spent at the restaurant?
SELECT 
  sales.customer_id, 
  SUM(menu.price) AS tot_sales
FROM sales
INNER JOIN menu
  ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id ASC;

```
```SQL
--2. How many days has each customer visited the restaurant?
SELECT 
  customer_id, 
  COUNT(DISTINCT order_date) AS visit_count
FROM sales
GROUP BY customer_id
order by visit_count desc;
```
```SQL
--3. What was the first item from the menu purchased by each customer?
-- Identify the first item from the menu purchased by each customer
WITH first_purchase AS (
    -- Rank the products purchased by each customer based on order date
    SELECT 
        customer_id,
        product_id,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rk
    FROM 
        sales
)
-- Join the ranked products with the menu to get the product names
SELECT 
    fp.customer_id,
    m.product_name
FROM 
    first_purchase AS fp
INNER JOIN 
    menu AS m ON fp.product_id = m.product_id
-- Filter to get only the first purchase of each customer
WHERE 
    fp.rk = 1
GROUP BY 
```
```SQL
--4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1
  m.product_name,
  COUNT(s.product_id) AS most_purchased_count 
FROM 
  sales AS s
INNER JOIN 
  menu AS m
  ON s.product_id = m.product_id
GROUP BY 
  m.product_name -- Grouping by product name to count occurrences
ORDER BY 
  most_purchased_count DESC; -- Sorting in descending order to get the most purchased item

```

```SQL

--Q5 Which item was the most popular for each customer?
  -- Common Table Expression (CTE) to calculate purchase counts for each customer and product
WITH CustomerPurchaseCounts AS (
  SELECT 
    s.customer_id,
    m.product_name,
    COUNT(s.product_id) AS purchase_count,
    rank() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.product_id) DESC) AS rank
  FROM 
    sales AS s
  INNER JOIN 
    menu AS m ON s.product_id = m.product_id
  GROUP BY 
    s.customer_id, m.product_name
)
-- Main query to select the most popular item for each customer
SELECT 
  customer_id,
  product_name,
  purchase_count
FROM 
  CustomerPurchaseCounts
WHERE 
  rank = 1; -- Select only the most popular item for each customer

```
```SQL
 -- Q6 Which item was purchased first by the customer after they became a member?

 -- Common Table Expression (CTE) to filter and rank customer-product combinations
WITH RankedCustomerProducts AS (
  SELECT
    sl.customer_id,
    mn.product_name,
    ROW_NUMBER() OVER (
      PARTITION BY sl.customer_id
      ORDER BY sl.order_date) AS row_num
  FROM 
    sales AS sl
  INNER JOIN 
    menu AS mn ON sl.product_id = mn.product_id 
  LEFT JOIN 
    members AS mm ON sl.customer_id = mm.customer_id
  WHERE sl.order_date > mm.join_date
)
   
-- Main query to select the first product purchased by each customer after joining
SELECT 
  customer_id, 
  product_name 
FROM  
  RankedCustomerProducts
WHERE 
  row_num = 1;
```
```SQL

--Q7 Which item was purchased just before the customer became a member?
-- Common Table Expression (CTE) to filter and rank customer-product combinations
WITH RankedCustomerProducts AS (
  SELECT
    sl.customer_id,
    mn.product_name,
    ROW_NUMBER() OVER (
      PARTITION BY sl.customer_id
      ORDER BY sl.order_date DESC) AS row_num
  FROM 
    sales AS sl
  INNER JOIN 
    menu AS mn ON sl.product_id = mn.product_id 
  LEFT JOIN 
    members AS mm ON sl.customer_id = mm.customer_id
  WHERE sl.order_date < mm.join_date
)
   
-- Main query to select the first product purchased by each customer before joining
SELECT 
  customer_id, 
  product_name 
FROM  
  RankedCustomerProducts
WHERE 
  row_num = 1
  ORDER BY customer_id ASC;
```
```SQL

-- Q8 What is the total items and amount spent for each member before they became a member?
-- Select the customer ID along with the total number of items purchased and the total sales amount
SELECT
    sl.customer_id,
    COUNT(mn.product_name) AS total_items,
    SUM(mn.price)  AS total_sales
FROM 
    sales AS sl
INNER JOIN 
    menu AS mn ON sl.product_id = mn.product_id 
INNER JOIN 
    members AS mm ON sl.customer_id = mm.customer_id
-- Filter sales made before the customer joined the loyalty program
WHERE 
    sl.order_date < mm.join_date
-- Group the results by customer ID
GROUP BY    
    sl.customer_id
-- Order the results by customer ID
ORDER BY 
    sl.customer_id;


```
