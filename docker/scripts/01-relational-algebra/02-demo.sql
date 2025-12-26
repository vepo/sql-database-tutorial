-- performance-demo.sql
-- Turn on timing
\timing on

-- 1. Generate sample data (100,000 records)
SELECT 'Generating sample data...';
SELECT generate_sample_data(1000000);
SELECT COUNT(*) as total_employees FROM employees;

-- 2. Demo 1: Index usage
SELECT 'Demo 1: With vs Without Index';
EXPLAIN ANALYZE SELECT * FROM employees WHERE department = 'Engineering';

-- 3. Demo 2: Join performance
SELECT 'Demo 2: Join Performance';
EXPLAIN ANALYZE 
SELECT d.dept_name, AVG(e.salary) as avg_salary, COUNT(*) as emp_count
FROM employees e
JOIN departments d ON e.department = d.dept_name
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

-- 4. Demo 3: Subquery vs JOIN
SELECT 'Demo 3: Subquery vs JOIN Comparison';

-- Using subquery
EXPLAIN ANALYZE
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Using window function
EXPLAIN ANALYZE
SELECT name, salary, avg_salary
FROM (
    SELECT name, salary, AVG(salary) OVER() as avg_salary
    FROM employees
) sub
WHERE salary > avg_salary;

-- 5. Demo 4: Index scan vs Sequential scan
SELECT 'Demo 4: Index Scan Demo';
SET enable_indexscan = off;
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 100000;
SET enable_indexscan = on;
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 100000;

-- 6. Demo 5: Pagination performance
SELECT 'Demo 5: Pagination Methods';

-- OFFSET/LIMIT (traditional)
EXPLAIN ANALYZE 
SELECT * FROM employees 
ORDER BY id 
OFFSET 50000 LIMIT 20;

-- Keyset pagination (better for large offsets)
EXPLAIN ANALYZE 
SELECT * FROM employees 
WHERE id > 50000 
ORDER BY id 
LIMIT 20;

-- 7. Show statistics
SELECT 'Query Statistics from pg_stat_statements';
SELECT 
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    rows / calls as avg_rows
FROM pg_stat_statements 
WHERE query NOT LIKE '%pg_stat%'
ORDER BY total_exec_time DESC 
LIMIT 10;
