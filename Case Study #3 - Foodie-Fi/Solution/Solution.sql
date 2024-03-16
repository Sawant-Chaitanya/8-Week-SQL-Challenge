SELECT s.customer_id,
       p.plan_name,
       s.start_date,
       DATEDIFF(day, LAG(start_date) OVER (PARTITION BY customer_id ORDER BY start_date),start_date ) AS days_diff,
       DATEDIFF(month,LAG(start_date) OVER (PARTITION BY customer_id ORDER BY start_date),start_date) as months_diff
FROM   subscriptions AS s
JOIN   plans AS p
ON     s.plan_id = p.plan_id
;

---------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------B. Data Analysis Questions---------------------------------------------------------------------------

--1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions;


--2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT DATEFROMPARTS(YEAR(start_date), MONTH(start_date), 1) AS start_of_month,
       COUNT(*) AS trial_starts
FROM subscriptions
WHERE plan_id = 0
GROUP BY DATEFROMPARTS(YEAR(start_date), MONTH(start_date), 1)
ORDER BY start_of_month;


--3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.
SELECT 
    plan_name,
    COUNT(*) AS event_count
FROM 
    subscriptions
JOIN 
    plans ON subscriptions.plan_id = plans.plan_id
WHERE 
    start_date > '2020-12-31'
GROUP BY 
    plan_name;


--4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
WITH ChurnedCustomers AS (
    SELECT DISTINCT customer_id
    FROM subscriptions
    WHERE plan_id = 4
)
SELECT 
    COUNT(DISTINCT customer_id) AS churned_customer_count,
    ROUND((COUNT(DISTINCT customer_id) * 100.0) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS churned_percentage
FROM 
    ChurnedCustomers;

--5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH churn_cte AS (
    SELECT 
        customer_id,
        LAG(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) AS previous_plan,
        plan_id
    FROM 
        subscriptions
)
SELECT 
    COUNT(*) AS churn_count,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 0) AS prct_churn
FROM 
    churn_cte
WHERE 
    plan_id = 4 AND previous_plan = 0;

--6. What is the number and percentage of customer plans after their initial free trial?

-- CTE to get plan details including the next plan for each customer
WITH PlanDetails AS (
    SELECT *,
        -- Using LEAD function to get the next plan for each customer
        LEAD(plan_id, 1) OVER (PARTITION BY customer_id ORDER BY plan_id) AS next_plan
    FROM subscriptions
)
-- Main query to calculate the number and percentage of each customer plan after their initial free trial
SELECT 
    p.plan_name AS plan_name,
    COUNT(pd.next_plan) AS customer_count,
    CAST(COUNT(pd.next_plan) AS FLOAT) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions) AS percentage
FROM 
    PlanDetails pd
LEFT JOIN 
    plans p ON pd.next_plan = p.plan_id
WHERE  
    pd.plan_id = 0 AND pd.next_plan IS NOT NULL -- Filtering data for customers who churned straight after their initial free trial (plan_id = 0) and have a next plan
GROUP BY 
    p.plan_name
ORDER BY 
    customer_count;

--7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
-- CTE to get plan details including the next date for each customer up to '2020-12-31'
WITH PlanDetails AS (
    SELECT *,
           -- Using LEAD function to get the next date for each customer
           LEAD(start_date, 1) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_date
    FROM subscriptions
    WHERE start_date <= '2020-12-31' -- Filtering data up to '2020-12-31'
)

-- Main query to calculate the customer count and percentage breakdown for each plan_name
SELECT 
    P.plan_id,
    P.plan_name,
    COUNT(C.plan_id) AS customer_count,
    -- Calculating the percentage of each plan type among all customers
    (CAST(COUNT(C.plan_id) AS FLOAT) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions)) AS percentage_customer
FROM 
    PlanDetails C
LEFT JOIN 
    plans P ON C.plan_id = P.plan_id
-- Filtering data for customers whose next date is after '2020-12-31' or whose next date is NULL (indicating they are still subscribed)
WHERE 
    next_date IS NULL OR next_date > '2020-12-31'
GROUP BY 
    P.plan_id, P.plan_name
ORDER BY 
    P.plan_id;


select * from plans
select * from subscriptions


--8. How many customers have upgraded to an annual plan in 2020?
SELECT plan_name, 
        COUNT(s.plan_id) as number_annual_plan
FROM subscriptions s
INNER JOIN plans p ON s.plan_id = p.plan_id
WHERE plan_name = 'pro annual' and start_date <='2020-12-31'
GROUP BY plan_name;

--9. How many days on average does it take for a customer to upgrade to an annual plan from the day they join Foodie-Fi?
with annual as (
SELECT customer_id,
                start_date as start_annual
          FROM subscriptions s
          INNER JOIN plans p ON s.plan_id = p.plan_id
          WHERE plan_name = 'pro annual'
),
trial as (
SELECT customer_id,
                start_date as start_trial
          FROM subscriptions s
          INNER JOIN plans p ON s.plan_id = p.plan_id
          WHERE plan_name = 'trial'
)

select 
--a.customer_id,
AVG(DATEDIFF(d, start_trial, start_annual)) as ave_days_to_join_annual
from annual as a
inner join trial as t
on a.customer_id =t.customer_id;

--10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

-- CTE to fetch customers who subscribed to the 'pro annual' plan
WITH ProAnnualSubscribers AS (
    SELECT 
        customer_id,
        start_date AS start_annual
    FROM 
        subscriptions s
    INNER JOIN 
        plans p ON s.plan_id = p.plan_id
    WHERE 
        plan_name = 'pro annual'
),

-- CTE to fetch customers who subscribed to the 'trial' plan
TrialSubscribers AS (
    SELECT 
        customer_id,
        start_date AS start_trial
    FROM 
        subscriptions s
    INNER JOIN 
        plans p ON s.plan_id = p.plan_id
    WHERE 
        plan_name = 'trial'
)

-- Main query to calculate the average days to join the 'pro annual' plan for each 30-day period
SELECT 
    CONCAT((DATEDIFF(day, ts.start_trial, pas.start_annual) / 30) * 30 + 1, '-', 
           (DATEDIFF(day, ts.start_trial, pas.start_annual) / 30 + 1) * 30) AS period_range,
    AVG(DATEDIFF(day, ts.start_trial, pas.start_annual)) AS average_days_to_join_annual
FROM 
    ProAnnualSubscribers AS pas
INNER JOIN 
    TrialSubscribers AS ts ON pas.customer_id = ts.customer_id
GROUP BY 
    (DATEDIFF(day, ts.start_trial, pas.start_annual) / 30);

--11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
-- CTE to fetch subscription details with the next plan for each customer
WITH CTE AS (
    SELECT *, 
        LEAD(plan_id, 1) OVER (PARTITION BY customer_id ORDER BY plan_id) AS nxt_plan
    FROM subscriptions
    WHERE start_date <= '2020-12-31'
)

-- Main query to count the number of downgrades from pro monthly to basic monthly plan
SELECT COUNT(*) AS downgrade_cnt
FROM CTE 
WHERE nxt_plan = 1  -- Next plan is basic monthly
  AND plan_id = 2;   -- Current plan is pro monthly


--------------------------------------------------------------------------------------------------------------------------------------------------
--C. Challenge Payment Question
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

--------------------------------------------------------------------------------------------------------------------------------------------------



