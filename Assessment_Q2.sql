-- Step 1: Calculate average transactions per customer per month
WITH customer_monthly_tranx AS (
	SELECT
		s.owner_id,
		DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
		COUNT(*) AS monthly_tranx_count
	FROM adashi_staging.savings_savingsaccount AS s
	GROUP BY s.owner_id, DATE_FORMAT(s.transaction_date, '%Y-%m')
    ),

-- Step 2: Average transaction count per user per month
customer_avg_tranx AS (
	SELECT
		owner_id,
        AVG(monthly_tranx_count) AS avg_transactions_per_month
	FROM customer_monthly_tranx
    GROUP BY owner_id
    ),

-- Step 3: Categorize customers by transaction frequency
categorized_customers AS (
	SELECT
		CASE
			WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
		END AS frequency_category,
        avg_transactions_per_month
	FROM customer_avg_tranx
)

-- Step 4: Count customers per category and average their transaction rates
SELECT
	frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY
	FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
