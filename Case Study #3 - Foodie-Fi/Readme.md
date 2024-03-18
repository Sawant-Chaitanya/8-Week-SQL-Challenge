# [Case Study #3 - Foodie-Fi](https://8weeksqlchallenge.com/case-study-3/)

![image](https://8weeksqlchallenge.com/images/case-study-designs/3.png)


## Contents
- [Introduction](#introduction)
- [Available Data](#available-data)
    - [Table 1: plans](#table-1-plans)
    - [Table 2: subscriptions](#table-2-subscriptions)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions](#case-study-questions)
    - [A. Customer Journey](#a-customer-journey)
    - [B. Data Analysis Questions](#b-data-analysis-questions)
    - [C. Challenge Payment Question](#c-challenge-payment-question)
    - [D. Outside The Box Questions](#d-outside-the-box-questions)
- [Conclusion](#conclusion)

  
## Introduction
Subscription-based businesses are becoming increasingly popular, and Danny identified an opportunity in the market to launch Foodie-Fi, a streaming service exclusively for food-related content. With monthly and annual subscription options, customers gain unlimited access to a vast library of exclusive food videos from around the globe. Danny envisioned Foodie-Fi as a data-driven platform, where decisions regarding investments and feature enhancements would be guided by data insights.

## Available Data
Danny has provided data on Foodie-Fi's subscription plans and customer subscriptions, allowing us to delve into crucial business questions. The primary focus of this case study revolves around two tables within the foodie_fi database schema.


### Table 1: plans
This table contains details about the subscription plans offered by Foodie-Fi.

| plan_id | plan_name      | price |
|---------|----------------|-------|
| 0       | trial          | 0     |
| 1       | basic monthly  | 9.90  |
| 2       | pro monthly    | 19.90 |
| 3       | pro annual     | 199   |
| 4       | churn          | null  |

Customers can choose which plans to join Foodie-Fi when they first sign up.

Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90

Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

### Table 2: subscriptions
Customer subscriptions are recorded in this table, along with the start date of each plan.

| customer_id | plan_id | start_date |
|-------------|---------|------------|
| 1           | 0       | 2020-08-01 |
| 1           | 1       | 2020-08-08 |
| ...         | ...     | ...        |


Customer subscriptions show the exact date where their specific plan_id starts.

If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.

When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.

When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.

## Entity Relationship Diagram
![link_to_er_diagram](https://8weeksqlchallenge.com/images/case-study-3-erd.png)


## Case Study Questions
This case study encompasses various questions aimed at understanding Foodie-Fi's customer base, subscription trends, and payment processing.

### A. Customer Journey
Understand the onboarding journey of sample customers based on subscription data.
---
### B. Data Analysis Questions
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values?
3. What plan start_date values occur after the year 2020?
4. What is the churn rate and percentage of churned customers?
5. How many customers churned straight after their initial free trial?
6. Analyze the number and percentage of customer plans post-initial free trial.
7. Customer count and percentage breakdown of plan_name values at 2020-12-31.
8. How many customers upgraded to an annual plan in 2020?
9. Average days for a customer to upgrade to an annual plan.
10. Further breakdown of the average upgrade duration into 30-day periods.
    
----

### C. Challenge Payment Question

Create a new payments table for the year 2020 based on subscription data with specified rules.

The Foodie-Fi team requires the creation of a payments table for the year 2020, capturing amounts paid by each customer based on their subscriptions. The following criteria must be met:

- **Monthly Payments**: Occur on the same day as the original start_date of monthly plans.
- **Basic to Monthly/Pro Upgrades**: Reduced by the current paid amount in that month and start immediately.
- **Pro Monthly to Pro Annual Upgrades**: Paid at the end of the current billing period and start at the end of the month period.
- **Churn**: Customers who churn will no longer make payments.

#### Example Outputs:

| customer_id | plan_id | plan_name     | payment_date | amount | payment_order |
|-------------|---------|---------------|--------------|--------|---------------|
| 1           | 1       | basic monthly | 2020-08-08   | 9.90   | 1             |
| 1           | 1       | basic monthly | 2020-09-08   | 9.90   | 2             |
| 1           | 1       | basic monthly | 2020-10-08   | 9.90   | 3             |
| ...         | ...     | ...           | ...          | ...    | ...           |



---


### D. Outside The Box Questions
Explore open-ended questions focused on business growth, customer retention, and churn reduction strategies.


1. How would you calculate the rate of growth for Foodie-Fi?
2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?
3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?
4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?
5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?

----
## Conclusion
This case study presents realistic scenarios commonly encountered in digital product analytics across various industries. By applying SQL skills to analyze data and derive actionable insights, we can drive informed decision-making and contribute to the success of Foodie-Fi's subscription-based model.

---

