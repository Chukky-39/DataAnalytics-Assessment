-- Select the required columns for the output
SELECT
	c.id AS customer_id,                     		-- Customer ID from users_customuser
	CONCAT(c.first_name, ' ', c.last_name) AS name, -- Combine first and last name from users_customuser
	-- Calculate tenure in months : difference between current date and signup date
    TIMESTAMPDIFF(MONTH, c.created_on, '2025-05-19') AS tenure_months,
    -- Calculate total transactions: sum of all transaction amounts for the customer
    COALESCE(SUM(s.amount), 0) AS total_transactions,
    -- Calculate estimated CLV:
    -- 1. Average transaction value per month = total_transactions / tenure_months
    -- 2. Multiply by 12 to get annual value (12 months)
    -- 3. Multiply by avg_profit_per_transaction = 0.1% * COALESCE(SUM(s.amount), 0) / NULLIF(COUNT(s.amount), 0)
    -- Formula: (total_transactions / tenure) * 12 * avg_profit_per_transaction 
    -- Use NULLIF to avoid division by zero if tenure_months is 0
    ROUND(
        (COALESCE(SUM(s.amount), 0) / NULLIF(TIMESTAMPDIFF(MONTH, c.created_on, '2025-05-19'), 0)) 
        * 12 
        * (
        0.001 * COALESCE(SUM(s.amount), 0) / NULLIF(COUNT(s.amount), 0)
        ),                                  
        2
    ) AS estimated_clv
FROM
    adashi_staging.users_customuser AS c             	-- Base table: Customer details
LEFT JOIN
    adashi_staging.savings_savingsaccount AS s			-- Join with savings_savingsaccount to get transactions
    ON c.id = s.owner_id
GROUP BY
    c.id, c.first_name, c.last_name, c.created_on		-- Group by customer to aggregate transactions
HAVING
    tenure_months > 0									-- Exclude customers with zero tenure to avoid division issues
ORDER BY
    estimated_clv										-- Sort by estimated CLV, lowest to highest
    ;										
