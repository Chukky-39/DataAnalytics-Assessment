-- Step 1: Get last transactions for savings accounts
SELECT
		s.savings_id AS plan_id,
		owner_id,
        'Savings' AS type,
		MAX(last_returns_date) AS last_transaction_date,
        DATEDIFF(CURDATE(), MAX(last_returns_date)) AS inactivity_days
	FROM adashi_staging.savings_savingsaccount AS s
	GROUP BY savings_id, owner_id
    HAVING MAX(last_returns_date) <= CURDATE() - INTERVAL 365 DAY
	
    
    UNION

-- Step 2: Get last transactions for investment plans
SELECT
		p.id AS plan_id,
		owner_id,
        'Investments' AS type,
		MAX(last_returns_date) AS last_transaction_date,
        DATEDIFF(CURDATE(), MAX(last_returns_date)) AS inactivity_days
	FROM adashi_staging.plans_plan AS p
	GROUP BY id, owner_id
    HAVING MAX(last_returns_date) <= CURDATE() - INTERVAL 365 DAY
;
