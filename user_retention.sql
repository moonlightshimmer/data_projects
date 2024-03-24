---- LOGIC1: Retention Rate Table----
WITH 
first_month_transaction AS (
 SELECT customer_id, 
        MIN(EXTRACT(MONTH FROM order_date)) AS first_month 
 FROM customer_transaction
 GROUP BY customer_id
),
transaction_month AS(
 SELECT DISTINCT customer_id, 
        EXTRACT(MONTH FROM order_date) AS month
 FROM customer_transaction
),
join_table AS
(
 SELECT tm.customer_id, tm.month, 
        fmt.first_month,
        tm.month - fmt.first_month AS month_diff
 FROM transaction_month AS tm
 JOIN first_month_transaction AS fmt
 ON tm.customer_id = fmt.customer_id
),
cohort_table AS 
(
 SELECT first_month,
        SUM(CASE WHEN month_diff = 0 THEN 1 ELSE 0 END) AS m0,
        SUM(CASE WHEN month_diff = 1 THEN 1 ELSE 0 END) AS m1,
        SUM(CASE WHEN month_diff = 2 THEN 1 ELSE 0 END) AS m2,
        SUM(CASE WHEN month_diff = 3 THEN 1 ELSE 0 END) AS m3,
        SUM(CASE WHEN month_diff = 4 THEN 1 ELSE 0 END) AS m4,
        SUM(CASE WHEN month_diff = 5 THEN 1 ELSE 0 END) AS m5,
        SUM(CASE WHEN month_diff = 6 THEN 1 ELSE 0 END) AS m6,
        SUM(CASE WHEN month_diff = 7 THEN 1 ELSE 0 END) AS m7,
        SUM(CASE WHEN month_diff = 8 THEN 1 ELSE 0 END) AS m8,
        SUM(CASE WHEN month_diff = 9 THEN 1 ELSE 0 END) AS m9,
        SUM(CASE WHEN month_diff = 10 THEN 1 ELSE 0 END) AS m10,
        SUM(CASE WHEN month_diff = 11 THEN 1 ELSE 0 END) AS m11
 FROM join_table
 GROUP BY first_month
 ORDER BY first_month
)
SELECT first_month AS cohort_month,
       ROUND((m0/CAST(m0 AS decimal))*100,0) AS m0,
       ROUND((m1/CAST(m0 AS decimal))*100,0) AS m1,
       ROUND((m2/CAST(m0 AS decimal))*100,0) AS m2,
       ROUND((m3/CAST(m0 AS decimal))*100,0) AS m3,
       ROUND((m4/CAST(m0 AS decimal))*100,0) AS m4,
       ROUND((m5/CAST(m0 AS decimal))*100,0) AS m5,
       ROUND((m6/CAST(m0 AS decimal))*100,0) AS m6,
       ROUND((m7/CAST(m0 AS decimal))*100,0) AS m7,
       ROUND((m8/CAST(m0 AS decimal))*100,0) AS m8,
       ROUND((m9/CAST(m0 AS decimal))*100,0) AS m9,
       ROUND((m10/CAST(m0 AS decimal))*100,0) AS m10,
       ROUND((m11/CAST(m0 AS decimal))*100,0) AS m11
FROM cohort_table;
