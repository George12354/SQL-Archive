/*Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
•	Account tenure (months since signup)
•	Total transactions
•	Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
•	Order by estimated CLV from highest to lowest*/

use adashi_staging;

;with cte as(
SELECT users.id as customer_id, 
users.username, 
timestampdiff(Month, users.date_joined, CURDATE()) as tenure_months,
count(savings_acct.id) as total_transactions,
AVG(savings_acct.confirmed_amount) as average_transaction_value
FROM users_customuser users
JOIN savings_savingsaccount savings_acct ON users.id = savings_acct.owner_id
group by customer_id, users.username
)

/*avg_profit_per_transaction = average_transaction_value * 0.1%
nullif -- returns null if cte.tenure_months == 0
*/

select cte.customer_id,
		cte.username,
        cte.tenure_months,
        cte.total_transactions,
        (cte.total_transactions / nullif(cte.tenure_months, 0)) * 12 * (cte.average_transaction_value * 0.1/100) as estimated_clv
from cte
order by estimated_clv desc;