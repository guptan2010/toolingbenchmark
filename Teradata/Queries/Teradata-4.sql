SELECT 
    region, 
    product_id, 
    p.product_name,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    ROUND(SUM(CASE 
        WHEN promotion_applied THEN sales_amount * 0.9 
        ELSE sales_amount 
    END), 2) AS adjusted_sales,
    MAX(sales_amount) AS max_sales,
    MIN(sales_amount) AS min_sales,
    VARIANCE(sales_amount) AS sales_variance,
    STDDEV_POP(sales_amount) AS sales_stddev,
    TRIM(p.product_name) || ' (' || CAST(product_id AS VARCHAR(10)) || ')' AS product_info,
    CAST(CURRENT_DATE AS FORMAT 'YYYY-MM-DD') AS report_date,
    EXTRACT(YEAR FROM transaction_date) AS transaction_year,
    EXTRACT(MONTH FROM transaction_date) AS transaction_month,
    EXTRACT(DAY FROM transaction_date) AS transaction_day,
    CASE 
        WHEN sales_amount > 1000 THEN 'High'
        WHEN sales_amount BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS sales_category
FROM (
    SELECT *
    FROM sales
    WHERE transaction_date BETWEEN DATE '2023-01-01' AND DATE '2023-12-31'
      AND region IN ('West', 'East', 'Central')
    SAMPLE CASE 
        WHEN region = 'West' THEN 100 
        WHEN region = 'East' THEN 200 
        ELSE 50 
    END
) sampled_sales
LEFT JOIN product p
    ON sampled_sales.product_id = p.product_id
GROUP BY region, product_id, p.product_name, transaction_date, sales_amount
HAVING total_sales > 500
ORDER BY total_sales DESC, transaction_count DESC;



