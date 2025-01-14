WITH RECURSIVE org_chart (employee_id, manager_id, level, path, total_reports) AS (
    SELECT 
        employee_id, 
        manager_id, 
        1 AS level, 
        CAST(employee_id AS VARCHAR(100)) AS path,
        0 AS total_reports
    FROM employee
    WHERE manager_id IS NULL
    UNION ALL
    SELECT 
        e.employee_id, 
        e.manager_id, 
        oc.level + 1,
        oc.path || ' -> ' || CAST(e.employee_id AS VARCHAR(100)),
        oc.total_reports + 1
    FROM employee e
    INNER JOIN org_chart oc 
        ON e.manager_id = oc.employee_id
    WHERE oc.level <= 15
)
SELECT 
    employee_id, 
    manager_id, 
    level, 
    path, 
    total_reports,
    CASE 
        WHEN level = 1 THEN 'Executive'
        WHEN level <= 5 THEN 'Senior Manager'
        ELSE 'Staff'
    END AS role_type
FROM org_chart
WHERE LENGTH(path) > 15
ORDER BY total_reports DESC, level ASC;
