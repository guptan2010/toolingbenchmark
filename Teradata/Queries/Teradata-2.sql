SELECT 
    e.employee_id, 
    e.department_id, 
    e.salary, 
    e.job_title,
    d.avg_department_salary,
    e.hire_date,
    CASE 
        WHEN e.salary > 100000 THEN 'High'
        WHEN e.salary BETWEEN 50000 AND 100000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_band,
    COALESCE(e.bonus, 0) AS adjusted_bonus,
    TRIM(e.job_title) || ' (' || e.employee_id || ')' AS employee_info,
    CAST(CURRENT_DATE AS FORMAT 'YYYY-MM-DD') AS report_date,
    EXTRACT(YEAR FROM e.hire_date) AS hire_year,
    EXTRACT(MONTH FROM e.hire_date) AS hire_month,
    EXTRACT(DAY FROM e.hire_date) AS hire_day
FROM employee e
LEFT JOIN (
    SELECT department_id, AVG(salary) AS avg_department_salary
    FROM employee
    GROUP BY department_id
) d
ON e.department_id = d.department_id
WHERE e.salary > d.avg_department_salary
  AND e.hire_date >= DATE '2015-01-01'
ORDER BY e.department_id, e.salary DESC;
