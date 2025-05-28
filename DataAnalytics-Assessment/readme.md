# SQL Proficiency Assessment

## Overview
This repository contains my solutions to the SQL Proficiency Assessment. For each question, I describe my approach, document any challenges I encountered, and explain how I resolved them. All queries are optimized for both correctness and performance.

---

## Question 1: High-Value Customers with Multiple Products  
**Scenario:** Identify customers who have both a savings and an investment plan (cross-selling opportunity).

### Approach
- Joined `users_customuser` with `savings_savingsaccount` and `plans_plan`.  
- Used `COUNT(DISTINCT ...)` to count funded savings and investments separately.  
- Summed those counts to get `total_deposits`.  
- Filtered for customers with ≥1 savings AND ≥1 investment.  

### Challenges
- **Timeouts / Connection Drops:** The initial single-pass join scanned large tables without indexes and timed out.  
- **Incorrect Aggregation:** Early use of `SUM(DISTINCT)` mis-aggregated deposit totals.  

### Solutions
1. Broke savings vs. investment into two CTEs/subqueries to pre-aggregate small result sets.  
2. Removed `SUM(DISTINCT)` in favor of separate `COUNT(DISTINCT ...)` and simple addition.  

---

## Question 2: Transaction Frequency Analysis  
**Scenario:** Segment customers by their average monthly transaction frequency.

### Approach
- Calculated, for each customer:
  - Total transactions (`COUNT(*)`).
  - Active months (`COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m'))`).
  - Average per month = total ÷ active months.
- Bucketed customers into “High” (≥10), “Medium” (3–9), or “Low” (≤2) frequency.

### Challenges
- **None.** Once the timeframe and grouping rules were clarified, the query performed as expected.

---

## Question 3: Account Inactivity Alert  
**Scenario:** Flag accounts (savings or investment) with no inflow transactions in the last 365 days.

### Approach
- Aggregated each plan’s last transaction date:
  - `MAX(transaction_date)` per `(plan_id, owner_id)`.
  - Calculated `inactivity_days = DATEDIFF(CURDATE(), last_transaction_date)`.
- Filtered for `inactivity_days > 365` and limited to top 100.

### Challenges
- **Timeouts / Connection Drops:** Full-table `GROUP BY` on a large dataset caused MySQL to lose connection.  

### Solutions
1. **Dataset Limiting:** Used a CTE to compute and sort inactivity days, then `LIMIT 100` before joining to `plans_plan`.  

---

## Question 4: Customer Lifetime Value Estimation  
**Scenario:** Estimate each customer’s CLV based on tenure and transaction volume (profit per transaction = 0.1% of transaction value).

### Approach
- Calculated:
  - `tenure_months` = `TIMESTAMPDIFF(MONTH, date_joined, CURDATE())`.
  - `total_transactions` = `COUNT(*)` on inflows.
  - `estimated_clv` = `(total_transactions / tenure_months) × 12 × avg_profit_per_transaction`.
- Handled division-by-zero via `NULLIF`.

### Challenges
- **None.** Once profit and tenure definitions were set, the query ran efficiently.

---

## General Notes
- **CTEs/Subqueries** helped break down complex aggregations into performant steps.  
- All SQL files are named `Assessment_Qn.sql` and contain a single, well-commented query per the repo structure.

---
