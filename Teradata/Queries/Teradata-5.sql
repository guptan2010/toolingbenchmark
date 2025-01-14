SELECT 
    c.first_name || ' ' || c.last_name AS full_name, 
    s.sale_date, 
    EXTRACT(YEAR FROM s.sale_date) AS sale_year, 
    s.total_amount,
    COALESCE(r.refund_amount, 0) AS refund_amount,
    (s.total_amount - COALESCE(r.refund_amount, 0)) AS net_sales,
    ROUND(
        (s.total_amount - COALESCE(r.refund_amount, 0)) / s.total_amount * 100, 
        2
    ) AS net_sales_percentage,
    COUNT(DISTINCT f.feedback_id) AS total_feedbacks,
    CASE 
        WHEN s.total_amount > 1000 THEN 'High'
        WHEN s.total_amount BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS sales_category,
    TRIM(c.city) || ', ' || TRIM(c.state) AS location,
    CAST(CURRENT_DATE AS FORMAT 'YYYY-MM-DD') AS report_date,
    EXTRACT(HOUR FROM s.sale_time) AS sale_hour,
    EXTRACT(MINUTE FROM s.sale_time) AS sale_minute,
    EXTRACT(SECOND FROM s.sale_time) AS sale_second,
    CASE 
        WHEN s.payment_method = 'Credit Card' THEN 'CC'
        WHEN s.payment_method = 'Cash' THEN 'Cash'
        ELSE 'Other'
    END AS payment_type,
    POSITION(' ' IN c.first_name) AS space_position,
    CHAR_LENGTH(c.first_name) AS first_name_length,
    SUBSTRING(c.first_name FROM 1 FOR 3) AS first_name_prefix
FROM customer c
LEFT JOIN sales s 
    ON c.customer_id = s.customer_id
LEFT JOIN (
    SELECT 
        sale_id, 
        SUM(refund_amount) AS refund_amount
    FROM refunds
    WHERE refund_date BETWEEN DATE '2023-01-01' AND DATE '2023-12-31'
    GROUP BY sale_id
) r
    ON s.sale_id = r.sale_id
LEFT JOIN feedback f
    ON s.sale_id = f.sale_id
WHERE UPPER(c.state) IN ('CALIFORNIA', 'TEXAS', 'NEW YORK')
  AND s.sale_date BETWEEN DATE '2023-01-01' AND DATE '2023-12-31'
GROUP BY c.customer_id, c.first_name, c.last_name, s.sale_date, s.total_amount, r.refund_amount, c.city, c.state, s.sale_time, s.payment_method
HAVING net_sales > 500
ORDER BY net_sales DESC, total_feedbacks DESC;
