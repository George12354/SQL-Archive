/*Task: Calculate the average number of transactions per customer per month and categorize them:
•	"High Frequency" (≥10 transactions/month)
•	"Medium Frequency" (3-9 transactions/month)
•	"Low Frequency" (≤2 transactions/month)*/

use adashi_staging;

SELECT month(savings_acct.transaction_date) as transaction_month,
		CASE
			when COUNT(savings_acct.savings_id) / COUNT(DISTINCT users.id) >= 10  then 'High Frequency'
			when COUNT(savings_acct.savings_id) / COUNT(DISTINCT users.id) Between 3 and 9	then 'Medium Frequency'
			when COUNT(savings_acct.savings_id) / COUNT(DISTINCT users.id) <= 2 then 'Low Frequency'
		END as frequency_category,
	COUNT(distinct users.id) as customer_count,
    COUNT(savings_acct.savings_id) / COUNT(DISTINCT users.id) AS avg_transactions_per_month
FROM users_customuser users
JOIN savings_savingsaccount savings_acct ON users.id = savings_acct.owner_id
group by transaction_month;
