# DataAnalytics-Assessment
Data Analytics Assessment from Cowrywise

Assessment_Q1- My approach in solving this question was to understand the goal which was to analyze customer activity (transactions) based on their products (from savings and investments) & sort them out based on their activites.
With this in mind, I took the following steps:-
   * I retrieved customer info (ID and full name)from users_customuser.
   * Inputed the following Subqueries:
        > Savings: Count distinct funded savings accounts and sum their amounts.
        > Investments: Count distinct funded investments and sum their amounts.
   * Used LEFT JOIN the aggregates to the main table to retain all customers, even if they lack one type of account.
   * Used WHERE & AND to filter only users who have both savings and investment accounts (after using COALESCE to treat NULLs as zeros)
   * Used ORDER BY to sort out the combined deposits (total_deposits) in ascending order.
The Challenge I faced was performance issues from Aggregation and joins on the large transactional tables (savings or investments) which caused my execution to slow & disconnect my connection to the SQL server. I resolved this by later applying Subqueries for both tables (savings_savingsaccount and plans_plan)

Assessment_Q2- My approach in solving this question was to understand the goal which was to check the frequency of transactions done by customers in the savings_savingsaccount & sort them based on its average per month. I took the following steps:-
   * Extracting year-month from transaction_date, Grouping them by owner_id and month & lasting Counting the transactions
   * Find the Averages for the monthly transaction counts for each customer across all months they were active
   * Classifying customers into High Frequency: ≥10 txns/month, Medium Frequency: 3–9 txns/month & Low Frequency: <3 txns/month
   * Aggregation by Counting how many customers fall into each category & Computing average of their monthly averages per category.
The Challenge I faced was not able to categorize them based on their frequency but I was able to resolve this by researching & using FIELD()

Assessment_Q3- My approach in solving this question was to understand the goal which was to check the accounts of customers without any inflow of transations for over a year. I took the following steps:-
   * Savings accounts: Got the most recent transaction from last_returns_date for each savings_id grouped by owner_id. Also included accounts where that date is more than a year ago.
   * Investment plans: Did the same for investment plans using the plans_plan table.
   * Combine both using UNION, labeling each with "Savings" or "Investments"
The Challenge I faced was receieving some inactivity_days as null but I was able to resolve this by adding a 'WHERE' statement

Assessment_Q4- My approach in solving was understand the goal which was to analyze volume as well as duration of customer activity (transactions for savings and/or investments accounts). I took the following steps:-
   * Calculate estimated CLV per customer based on:
        Tenure in months
        Total transactions (from savings)
        Average profit per transaction: 0.1% of average transaction value
        CLV ≈ monthly avg × 12 × avg profit per txn
   * Selecting Customer ID & full name from users_customuser
   * Transaction data from savings_savingsaccount by summing up transactions from the Amount column
   * Using Left join to include customers with no transactions
   * COALESCE & NULLIF was used to avoid NULL and divide-by-zero errors
The Challenge I faced was trying to get the average_profit_per_transaction as the question only indicated the profit_per_transaction but I was able to resolve this by researching & understanding that average transation = sum of all amounts / count of all amounts which is then multiplied by 0.1% to get average_profit_per_transaction.
