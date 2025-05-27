use adashi_staging;

/*Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.*/

SELECT 
    users.id AS owner_id,
    users.first_name AS name,
    COUNT(DISTINCT savings_acct.savings_id) AS savings_count,
    COUNT(DISTINCT plans.id) AS investment_count,
    SUM(DISTINCT plans.amount) + SUM(DISTINCT savings_acct.confirmed_amount) AS total_deposits
FROM users_customuser users
JOIN savings_savingsaccount savings_acct ON users.id = savings_acct.owner_id
JOIN plans_plan plans ON users.id = plans.owner_id
GROUP BY users.id, users.first_name
HAVING savings_count > 1 AND investment_count > 1
LIMIT 100;

