# [Danny's Diner SQL Case Study](https://8weeksqlchallenge.com/case-study-1/)

![Screenshot of danny's diner 1 week casestudy.](https://8weeksqlchallenge.com/images/case-study-designs/1.png)

## Contents
- [Introduction](#introduction)
- [Problem Statement](#problem-statement)
- [Datasets](#datasets)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Example Datasets](#example-datasets)
- [Case Study Questions](#case-study-questions)
  - [Bonus Questions](#bonus-questions)
    - [Join All The Things](#join-all-the-things)
    - [Rank All The Things](#rank-all-the-things)

## Introduction
Danny seriously loves Japanese food, so in the beginning of 2021, he decides to open up a cute little restaurant that sells his 3 favourite foods: sushi, curry, and ramen. Danny's Diner needs assistance in utilizing their basic data to help them run the business effectively.

## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers' visiting patterns, spending habits, and favorite menu items. He plans on using these insights to decide whether he should expand the existing customer loyalty program.

## Datasets
Danny has shared three key datasets:
1. **Sales:** Captures customer purchases with order dates and product IDs.
2. **Menu:** Maps product IDs to product names and prices.
3. **Members:** Captures when customers joined the loyalty program.

## Entity Relationship Diagram
![ER Diagram]

## Example Datasets

**Table 1: sales**

| customer_id | order_date | product_id |
|-------------|------------|------------|
| A           | 2021-01-01 | 1          |
| A           | 2021-01-01 | 2          |
| A           | 2021-01-07 | 2          |
| B           | 2021-01-01 | 2          |
| B           | 2021-01-02 | 2          |
| B           | 2021-01-04 | 1          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-07 | 3          |

**Table 2: menu**

| product_id | product_name | price |
|------------|--------------|-------|
| 1          | sushi        | 10    |
| 2          | curry        | 15    |
| 3          | ramen        | 12    |

**Table 3: members**

| customer_id | join_date  |
|-------------|------------|
| A           | 2021-01-07 |
| B           | 2021-01-09 |



## Case Study Questions
1. [Total Amount Spent by Each Customer](#question-1)
2. [Number of Visits by Each Customer](#question-2)
3. [First Item Purchased by Each Customer](#question-3)
4. [Most Purchased Item and Frequency](#question-4)
5. [Most Popular Item for Each Customer](#question-5)
6. [First Item Purchased After Becoming a Member](#question-6)
7. [Last Item Purchased Before Becoming a Member](#question-7)
8. [Total Items and Amount Spent Before Membership](#question-8)
9. [Points Calculation](#question-9)
10. [Points Calculation After Joining Program](#question-10)

## Bonus Questions

### **Join All The Things**
Recreate the given table output using the available data.
Certainly! Below are the tables converted into Markdown format for your README.md file:

#### Sales Data

| customer_id | order_date  | product_name | price | member |
|-------------|-------------|--------------|-------|--------|
| A           | 2021-01-01  | curry        | 15    | N      |
| A           | 2021-01-01  | sushi        | 10    | N      |
| A           | 2021-01-07  | curry        | 15    | Y      |
| A           | 2021-01-10  | ramen        | 12    | Y      |
| A           | 2021-01-11  | ramen        | 12    | Y      |
| A           | 2021-01-11  | ramen        | 12    | Y      |
| B           | 2021-01-01  | curry        | 15    | N      |
| B           | 2021-01-02  | curry        | 15    | N      |
| B           | 2021-01-04  | sushi        | 10    | N      |
| B           | 2021-01-11  | sushi        | 10    | Y      |
| B           | 2021-01-16  | ramen        | 12    | Y      |
| B           | 2021-02-01  | ramen        | 12    | Y      |
| C           | 2021-01-01  | ramen        | 12    | N      |
| C           | 2021-01-01  | ramen        | 12    | N      |
| C           | 2021-01-07  | ramen        | 12    | N      |


### Rank All The Things
Generate rankings for customer products, with null rankings for non-member purchases.

#### Sales Ranking

| customer_id | order_date  | product_name | price | member | ranking |
|-------------|-------------|--------------|-------|--------|---------|
| A           | 2021-01-01  | curry        | 15    | N      | null    |
| A           | 2021-01-01  | sushi        | 10    | N      | null    |
| A           | 2021-01-07  | curry        | 15    | Y      | 1       |
| A           | 2021-01-10  | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11  | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11  | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01  | curry        | 15    | N      | null    |
| B           | 2021-01-02  | curry        | 15    | N      | null    |
| B           | 2021-01-04  | sushi        | 10    | N      | null    |
| B           | 2021-01-11  | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16  | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01  | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01  | ramen        | 12    | N      | null    |
| C           | 2021-01-01  | ramen        | 12    | N      | null    |
| C           | 2021-01-07  | ramen        | 12    | N      | null    |


### Enjoy Exploring Danny's Diner Data!


