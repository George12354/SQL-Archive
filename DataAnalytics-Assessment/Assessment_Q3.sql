/*Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).*/

use adashi_staging;

;WITH top_inactive AS (
  SELECT
    plan_id,
    owner_id,
    MAX(transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(transaction_date)) AS inactivity_days
  FROM savings_savingsaccount
  WHERE
    confirmed_amount = 0
    AND transaction_date IS NOT NULL
  GROUP BY plan_id, owner_id
  HAVING inactivity_days >= 365  
  ORDER BY inactivity_days DESC
  LIMIT 100
)
SELECT DISTINCT
  t.plan_id,
  t.owner_id,
  CASE
    WHEN plans.is_regular_savings = 1 THEN 'savings'
    WHEN plans.is_a_fund = 1 THEN 'investment'
    ELSE 'unknown'
  END AS type,
  t.last_transaction_date,
  t.inactivity_days
FROM top_inactive AS t
LEFT JOIN plans_plan plans ON t.owner_id = plans.owner_id
ORDER BY t.inactivity_days DESC;
