-- Main SELECT query to retrieve customer data with accurate savings and investment aggregates
SELECT
    c.id AS owner_id,  -- Customer ID
    CONCAT(c.first_name, ' ', c.last_name) AS name,  -- Full name (first + last)

    -- Use COALESCE to handle cases where customer has no savings/investments
    COALESCE(s.savings_count, 0) AS savings_count,          -- Number of funded savings accounts
    COALESCE(p.investment_count, 0) AS investment_count,    -- Number of funded investment accounts

    -- Total deposits = savings + investments (both can be NULL if no activity)
    COALESCE(s.total_savings, 0) + COALESCE(p.total_investments, 0) AS total_deposits

FROM
    adashi_staging.users_customuser AS c  -- Base user table

-- Subquery to get savings account metrics per customer
LEFT JOIN (
    SELECT
        owner_id,  -- Grouped by customer
        COUNT(DISTINCT savings_id) AS savings_count,  -- Unique funded savings accounts
        SUM(amount) AS total_savings  -- Total amount in savings
    FROM
        adashi_staging.savings_savingsaccount
    WHERE
        amount > 0  -- Only consider funded accounts
    GROUP BY
        owner_id
) AS s ON c.id = s.owner_id  -- Join with users on customer ID

-- Subquery to get investment account metrics per customer
LEFT JOIN (
    SELECT
        owner_id,  -- Grouped by customer
        COUNT(DISTINCT id) AS investment_count,  -- Unique funded investments
        SUM(amount) AS total_investments  -- Total amount in investments
    FROM
        adashi_staging.plans_plan
    WHERE
        amount > 0  -- Only consider funded investments
    GROUP BY
        owner_id
) AS p ON c.id = p.owner_id  -- Join with users on customer ID

-- Only include users who have both savings AND investment accounts
WHERE
    COALESCE(s.savings_count, 0) >= 1
    AND COALESCE(p.investment_count, 0) >= 1

-- Order result by total deposits (ascending)
ORDER BY
    total_deposits;
