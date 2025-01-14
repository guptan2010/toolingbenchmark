SELECT 
    d.department_id, 
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    SUM(CASE 
        WHEN e.salary > 120000 THEN 1 
        ELSE 0 
    END) AS high_salary_count,
    AVG(CASE 
        WHEN e.job_title LIKE '%Manager%' THEN e.salary 
        ELSE NULL 
    END) AS avg_manager_salary,
    MAX(e.salary) AS highest_salary,
    MIN(e.salary) AS lowest_salary,
    ROUND(AVG(e.salary), 2) AS overall_avg_salary,
    CASE 
        WHEN COUNT(e.employee_id) > 50 THEN 'Large'
        WHEN COUNT(e.employee_id) BETWEEN 20 AND 50 THEN 'Medium'
        ELSE 'Small'
    END AS department_size
FROM department d
LEFT JOIN employee e 
    ON d.department_id = e.department_id
WHERE d.region IN ('North', 'East', 'South')
  AND e.hire_date >= DATE '2015-01-01'
GROUP BY d.department_id, d.department_name
HAVING SUM(e.salary) > 2000000
ORDER BY department_size ASC, total_employees DESC;