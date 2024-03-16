```SQL
 WITH cte AS (
    SELECT 
        customer_id, 
        plans.plan_id, 
        plan_name, 
        start_date, 
        LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date, plans.plan_id) AS cutoff_date,
        price AS amount
    FROM 
        subscriptions
    JOIN 
        plans
    ON 
        subscriptions.plan_id = plans.plan_id
    WHERE 
        start_date BETWEEN '2020-01-01' AND '2020-12-31'
        AND plan_name NOT IN ('trial', 'churn')
),
cte1 AS (
    SELECT 
        customer_id, 
        plan_id, 
        plan_name, 
        start_date, 
        COALESCE(cutoff_date, '2020-12-31') AS cutoff_date, 
        amount
    FROM 
        cte
),
cte2 AS (
    SELECT 
        customer_id, 
        plan_id, 
        plan_name, 
        start_date, 
        cutoff_date, 
        amount 
    FROM 
        cte1
    UNION ALL
    SELECT 
        customer_id, 
        plan_id, 
        plan_name, 
        DATEADD(MONTH, 1, start_date) AS start_date, 
        cutoff_date, 
        amount 
    FROM 
        cte2
    WHERE 
        cutoff_date > DATEADD(MONTH, 1, start_date)
        AND plan_name <> 'pro annual'
),
cte3 AS (
    SELECT 
        *, 
        LAG(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY start_date) AS last_payment_plan,
        LAG(amount, 1) OVER(PARTITION BY customer_id ORDER BY start_date) AS last_amount_paid,
        RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS payment_order
    FROM 
        cte2
)
SELECT 
    customer_id, 
    plan_id, 
    plan_name, 
    start_date AS payment_date, 
    CASE 
        WHEN plan_id IN (2, 3) AND last_payment_plan = 1 THEN amount - last_amount_paid
        ELSE amount
    END AS amount, 
    payment_order
INTO 
    payments_2020
FROM 
    cte3;

SELECT * FROM payments_2020;
```
