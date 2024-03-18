## Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey. Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

---

```SQL
SELECT 
    sd.customer_id,
    CONCAT('Started with ', 
           CASE 
               WHEN sd.plan_id = 0 THEN 'a trial plan' 
               WHEN sd.plan_id = 1 THEN 'a basic monthly plan' 
               WHEN sd.plan_id = 2 THEN 'a pro monthly plan' 
               WHEN sd.plan_id = 3 THEN 'a pro annual plan' 
               WHEN sd.plan_id = 4 THEN 'a churned plan' 
               ELSE 'an unknown plan' 
           END,
           ' on ', sd.start_date) AS onboarding_journey
FROM 
    subscriptions_demo as sd
ORDER BY 
    sd.customer_id, sd.start_date;

```

### Here's a brief description of each customer's onboarding journey based on the provided sample data:

- **Customer 1:** Started with a trial plan on August 1, 2020, then upgraded to a basic monthly plan on August 8, 2020.

- **Customer 2:** Began with a trial plan on September 20, 2020, then upgraded to a pro annual plan on September 27, 2020.

- **Customer 11:** Joined with a trial plan on November 19, 2020, then churned on November 26, 2020.

- **Customer 13:** Initially joined with a trial plan on December 15, 2020, switched to a basic monthly plan on December 22, 2020, and later upgraded to a pro monthly plan on March 29, 2021.

- **Customer 15:** Started with a trial plan on March 17, 2020, then switched to a pro monthly plan on March 24, 2020, and later churned on April 29, 2020.

- **Customer 16:** Joined with a trial plan on May 31, 2020, upgraded to a basic monthly plan on June 7, 2020, and later upgraded to a pro annual plan on October 21, 2020.

- **Customer 18:** Started with a trial plan on July 6, 2020, then upgraded to a pro monthly plan on July 13, 2020.

- **Customer 19:** Began with a trial plan on June 22, 2020, upgraded to a pro monthly plan on June 29, 2020, and later upgraded to a pro annual plan on August 29, 2020.
