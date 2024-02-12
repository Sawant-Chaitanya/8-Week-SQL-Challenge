```SQL
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

