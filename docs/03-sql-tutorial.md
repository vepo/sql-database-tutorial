# SQL Tutorial: Database Navigation and Querying

## 📋 Overview

This module provides a comprehensive **SQL tutorial** covering essential database navigation, querying techniques, and practical examples using PostgreSQL. You'll learn how to explore databases, write efficient queries, and troubleshoot common issues through hands-on examples.

Through this tutorial, you'll master:
- Database exploration and navigation commands
- Essential SQL query patterns and best practices
- Complex joins, subqueries, and aggregations
- Data manipulation operations (INSERT, UPDATE, DELETE)
- Performance optimization techniques
- Common pitfalls and troubleshooting strategies

## 🚀 Environment Setup

### Start the Environment
```bash
docker-compose -f docker/03-sql-docker-compose.yaml up -d
``` 

### Stop and Cleanup
```bash
docker-compose -f docker/03-sql-docker-compose.yaml down -v
```

## 🧭 Database Navigation Fundamentals

### 1. Connecting to a Database

Use Docker to connect to your PostgreSQL container:

```bash
docker exec -it postgres-demo psql -U demo -d demo_db
```

### 2. Listing Databases

#### Using PostgreSQL Command
```sql
\l
```

#### Using SQL Query
```sql
SELECT datname AS database_name, 
       pg_size_pretty(pg_database_size(datname)) AS size, 
       datallowconn AS allow_connections, 
       encoding, 
       datcollate
FROM pg_catalog.pg_database;
```

### 3. Switching Databases

```sql
\c company_db
-- You are now connected to database "company_db" as user "demo"
```

### 4. Listing Tables in a Database

```sql
\d
-- Shows all tables, views, and sequences in the current database
```

```sql
company_db=# \d
                     List of relations
 Schema |             Name              |   Type   | Owner 
--------+-------------------------------+----------+-------
 public | active_projects               | view     | demo
 public | departments                   | table    | demo
 public | departments_department_id_seq | sequence | demo
 public | employee_directory            | view     | demo
 public | employee_projects             | table    | demo
 public | employees                     | table    | demo
 public | employees_employee_id_seq     | sequence | demo
 public | projects                      | table    | demo
 public | projects_project_id_seq       | sequence | demo
(9 rows)

company_db=# -- Shows all tables, views, and sequences in the current database
```

## 🔍 Querying Fundamentals

### 5. Basic SELECT Queries

#### Simple SELECT
```sql
-- Select all columns from a table
SELECT * FROM departments;

-- Select specific columns
SELECT department_id, department_name, location FROM departments;

-- Select with filtering
SELECT * FROM employees WHERE department_id = 1;

-- Select with ordering
SELECT * FROM employees ORDER BY salary DESC;
```

```sql
company_db=# -- Select all columns from a table
company_db=# SELECT * FROM departments;
 department_id | department_name |   location    |   budget   | manager_id 
---------------+-----------------+---------------+------------+------------
             5 | Finance         | Austin        |  900000.00 |           
             6 | Operations      | Seattle       | 1100000.00 |           
             1 | Engineering     | New York      | 1500000.00 |          3
             2 | Marketing       | San Francisco |  800000.00 |          6
             3 | Sales           | Chicago       | 1200000.00 |          7
             4 | Human Resources | Boston        |  500000.00 |          8
(6 rows)

company_db=# 
company_db=# -- Select specific columns
company_db=#      SELECT department_id, department_name, location FROM departments;
 department_id | department_name |   location    
---------------+-----------------+---------------
             5 | Finance         | Austin
             6 | Operations      | Seattle
             1 | Engineering     | New York
             2 | Marketing       | San Francisco
             3 | Sales           | Chicago
             4 | Human Resources | Boston
(6 rows)

company_db=# 
company_db=# -- Select with filtering
company_db=# SELECT * FROM employees WHERE department_id = 1;
 employee_id | first_name | last_name |         email         |  phone   | hire_date  |        job_title         | department_id |  salary   | manager_id |         created_at         
-------------+------------+-----------+-----------------------+----------+------------+--------------------------+---------------+-----------+------------+----------------------------
           2 | Sarah      | Johnson   | sarah.j@company.com   | 555-0102 | 2019-06-01 | CTO                      |             1 | 200000.00 |          1 | 2026-01-13 11:37:07.926812
           3 | Michael    | Chen      | michael.c@company.com | 555-0103 | 2020-01-15 | Engineering Manager      |             1 | 150000.00 |          2 | 2026-01-13 11:37:07.926812
           4 | Emily      | Williams  | emily.w@company.com   | 555-0104 | 2021-03-22 | Senior Software Engineer |             1 | 130000.00 |          3 | 2026-01-13 11:37:07.926812
           5 | David      | Brown     | david.b@company.com   | 555-0105 | 2022-08-10 | Software Engineer        |             1 |  95000.00 |          3 | 2026-01-13 11:37:07.926812
          11 | James      | Anderson  | james.a@company.com   | 555-0111 | 2020-04-12 | DevOps Engineer          |             1 | 115000.00 |          3 | 2026-01-13 11:37:07.926812
          12 | Maria      | Thomas    | maria.t@company.com   | 555-0112 | 2021-08-19 | Software Engineer        |             1 |  98000.00 |          3 | 2026-01-13 11:37:07.926812
          13 | Charles    | Jackson   | charles.j@company.com | 555-0113 | 2022-11-03 | Junior Developer         |             1 |  75000.00 |          3 | 2026-01-13 11:37:07.926812
(7 rows)

company_db=# 
company_db=# -- Select with ordering
company_db=# SELECT * FROM employees ORDER BY salary DESC;
 employee_id | first_name  | last_name |           email           |  phone   | hire_date  |        job_title         | department_id |  salary   | manager_id |         created_at         
-------------+-------------+-----------+---------------------------+----------+------------+--------------------------+---------------+-----------+------------+----------------------------
           1 | John        | Smith     | john.smith@company.com    | 555-0101 | 2018-03-15 | CEO                      |               | 250000.00 |            | 2026-01-13 11:37:07.926812
           2 | Sarah       | Johnson   | sarah.j@company.com       | 555-0102 | 2019-06-01 | CTO                      |             1 | 200000.00 |          1 | 2026-01-13 11:37:07.926812
           3 | Michael     | Chen      | michael.c@company.com     | 555-0103 | 2020-01-15 | Engineering Manager      |             1 | 150000.00 |          2 | 2026-01-13 11:37:07.926812
           6 | Jessica     | Davis     | jessica.d@company.com     | 555-0106 | 2019-11-05 | Marketing Director       |             2 | 140000.00 |          1 | 2026-01-13 11:37:07.926812
           4 | Emily       | Williams  | emily.w@company.com       | 555-0104 | 2021-03-22 | Senior Software Engineer |             1 | 130000.00 |          3 | 2026-01-13 11:37:07.926812
           7 | Robert      | Miller    | robert.m@company.com      | 555-0107 | 2020-09-18 | Sales Manager            |             3 | 120000.00 |          1 | 2026-01-13 11:37:07.926812
          11 | James       | Anderson  | james.a@company.com       | 555-0111 | 2020-04-12 | DevOps Engineer          |             1 | 115000.00 |          3 | 2026-01-13 11:37:07.926812
           8 | Jennifer    | Wilson    | jennifer.w@company.com    | 555-0108 | 2021-07-30 | HR Manager               |             4 | 110000.00 |          1 | 2026-01-13 11:37:07.926812
          12 | Maria       | Thomas    | maria.t@company.com       | 555-0112 | 2021-08-19 | Software Engineer        |             1 |  98000.00 |          3 | 2026-01-13 11:37:07.926812
           5 | David       | Brown     | david.b@company.com       | 555-0105 | 2022-08-10 | Software Engineer        |             1 |  95000.00 |          3 | 2026-01-13 11:37:07.926812
           9 | William     | Moore     | william.m@company.com     | 555-0109 | 2022-02-14 | Financial Analyst        |             5 |  85000.00 |          1 | 2026-01-13 11:37:07.926812
          13 | Charles     | Jackson   | charles.j@company.com     | 555-0113 | 2022-11-03 | Junior Developer         |             1 |  75000.00 |          3 | 2026-01-13 11:37:07.926812
          14 | Patricia    | White     | patricia.w@company.com    | 555-0114 | 2020-12-07 | Marketing Specialist     |             2 |  72000.00 |          6 | 2026-01-13 11:37:07.926812
          15 | Christopher | Harris    | christopher.h@company.com | 555-0115 | 2023-01-25 | Sales Representative     |             3 |  68000.00 |          7 | 2026-01-13 11:37:07.926812
          10 | Lisa        | Taylor    | lisa.t@company.com        | 555-0110 | 2023-05-01 | Operations Coordinator   |             6 |  65000.00 |          1 | 2026-01-13 11:37:07.926812
(15 rows)

company_db=# 
```

### 6. Working with Subqueries

#### Subquery in SELECT Clause
```sql
SELECT department_id, 
       department_name, 
       budget,
       (SELECT SUM(salary) 
        FROM employees emp 
        WHERE emp.department_id = dep.department_id) as monthly_cost
FROM departments dep;
```

```sql
company_db=# SELECT department_id, 
company_db-#        department_name, 
company_db-#        budget,
company_db-#        (SELECT SUM(salary) 
company_db(#         FROM employees emp 
company_db(#         WHERE emp.department_id = dep.department_id) as monthly_cost
company_db-# FROM departments dep;
 department_id | department_name |   budget   | monthly_cost 
---------------+-----------------+------------+--------------
             5 | Finance         |  900000.00 |     85000.00
             6 | Operations      | 1100000.00 |     65000.00
             1 | Engineering     | 1500000.00 |    863000.00
             2 | Marketing       |  800000.00 |    212000.00
             3 | Sales           | 1200000.00 |    188000.00
             4 | Human Resources |  500000.00 |    110000.00
(6 rows)

company_db=# 
```

**Why is this correct?**
This query correctly calculates the total monthly salary cost for each department by using a correlated subquery. For each department row in the outer query, the subquery calculates the sum of salaries for employees in that specific department.

#### Subquery in WHERE Clause
```sql
-- Find departments where total employee salary exceeds budget
SELECT * FROM departments
WHERE budget < (
    SELECT SUM(salary)
    FROM employees
    WHERE employees.department_id = departments.department_id
);
```

```sql
company_db=# -- Find departments where total employee salary exceeds budget
company_db=# SELECT * FROM departments
company_db-# WHERE budget < (
company_db(#     SELECT SUM(salary)
company_db(#     FROM employees
company_db(#     WHERE employees.department_id = departments.department_id
company_db(# );
 department_id | department_name | location | budget | manager_id 
---------------+-----------------+----------+--------+------------
(0 rows)

company_db=# 
```

## 🔗 Advanced JOIN Operations

### 7. INNER JOIN (Default)
```sql
-- Get employees with their department names
SELECT 
    emp.employee_id,
    emp.first_name,
    emp.last_name,
    dep.department_name
FROM employees emp
INNER JOIN departments dep 
    ON emp.department_id = dep.department_id;
```

```sql
company_db=# -- Get employees with their department names
company_db=# SELECT 
company_db-#     emp.employee_id,
company_db-#     emp.first_name,
company_db-#     emp.last_name,
company_db-#     dep.department_name
company_db-# FROM employees emp
company_db-# INNER JOIN departments dep 
company_db-#     ON emp.department_id = dep.department_id;
 employee_id | first_name  | last_name | department_name 
-------------+-------------+-----------+-----------------
           9 | William     | Moore     | Finance
          10 | Lisa        | Taylor    | Operations
          13 | Charles     | Jackson   | Engineering
          12 | Maria       | Thomas    | Engineering
          11 | James       | Anderson  | Engineering
           5 | David       | Brown     | Engineering
           4 | Emily       | Williams  | Engineering
           3 | Michael     | Chen      | Engineering
           2 | Sarah       | Johnson   | Engineering
          14 | Patricia    | White     | Marketing
           6 | Jessica     | Davis     | Marketing
          15 | Christopher | Harris    | Sales
           7 | Robert      | Miller    | Sales
           8 | Jennifer    | Wilson    | Human Resources
(14 rows)

company_db=# 
```

### 8. LEFT JOIN Example
```sql
-- Get all departments and their employees (even if department has no employees)
SELECT 
    dep.department_name,
    emp.first_name,
    emp.last_name
FROM departments dep
LEFT JOIN employees emp 
    ON dep.department_id = emp.department_id;
```

```sql
company_db=# -- Get all departments and their employees (even if department has no employees)
company_db=# SELECT 
company_db-#     dep.department_name,
company_db-#     emp.first_name,
company_db-#     emp.last_name
company_db-# FROM departments dep
company_db-# LEFT JOIN employees emp 
company_db-#     ON dep.department_id = emp.department_id;
 department_name | first_name  | last_name 
-----------------+-------------+-----------
 Finance         | William     | Moore
 Operations      | Lisa        | Taylor
 Engineering     | Charles     | Jackson
 Engineering     | Maria       | Thomas
 Engineering     | James       | Anderson
 Engineering     | David       | Brown
 Engineering     | Emily       | Williams
 Engineering     | Michael     | Chen
 Engineering     | Sarah       | Johnson
 Marketing       | Patricia    | White
 Marketing       | Jessica     | Davis
 Sales           | Christopher | Harris
 Sales           | Robert      | Miller
 Human Resources | Jennifer    | Wilson
(14 rows)

company_db=# 
```

### 9. Multiple JOINs
```sql
-- Get projects with assigned employees and their departments
SELECT 
    prj.project_name,
    emp.first_name,
    emp.last_name,
    dep.department_name
FROM projects prj
JOIN employee_projects emp_prj 
    ON prj.project_id = emp_prj.project_id
JOIN employees emp 
    ON emp_prj.employee_id = emp.employee_id
JOIN departments dep 
    ON emp.department_id = dep.department_id;
```

```sql
company_db=# -- Get projects with assigned employees and their departments
company_db=# SELECT 
company_db-#     prj.project_name,
company_db-#     emp.first_name,
company_db-#     emp.last_name,
company_db-#     dep.department_name
company_db-# FROM projects prj
company_db-# JOIN employee_projects emp_prj 
company_db-#     ON prj.project_id = emp_prj.project_id
company_db-# JOIN employees emp 
company_db-#     ON emp_prj.employee_id = emp.employee_id
company_db-# JOIN departments dep 
company_db-#     ON emp.department_id = dep.department_id;
      project_name      | first_name  | last_name | department_name 
------------------------+-------------+-----------+-----------------
 Data Migration         | Lisa        | Taylor    | Operations
 Mobile App Development | Michael     | Chen      | Engineering
 Mobile App Development | Emily       | Williams  | Engineering
 Mobile App Development | David       | Brown     | Engineering
 Mobile App Development | James       | Anderson  | Engineering
 Website Redesign       | Michael     | Chen      | Engineering
 Website Redesign       | Emily       | Williams  | Engineering
 Website Redesign       | David       | Brown     | Engineering
 Marketing Campaign Q4  | Jessica     | Davis     | Marketing
 Marketing Campaign Q4  | Patricia    | White     | Marketing
 CRM Implementation     | Robert      | Miller    | Sales
 CRM Implementation     | Christopher | Harris    | Sales
 Data Migration         | Jennifer    | Wilson    | Human Resources
(13 rows)

company_db=# 
```

## 📊 Data Aggregation Techniques

### 10. Basic GROUP BY
```sql
-- Count employees per department
SELECT 
    department_id,
    COUNT(*) as employee_count,
    AVG(salary) as average_salary
FROM employees
GROUP BY department_id;
```

```sql
company_db=# -- Count employees per department
company_db=# SELECT 
company_db-#     department_id,
company_db-#     COUNT(*) as employee_count,
company_db-#     AVG(salary) as average_salary
company_db-# FROM employees
company_db-# GROUP BY department_id;
 department_id | employee_count |   average_salary    
---------------+----------------+---------------------
               |              1 | 250000.000000000000
             1 |              7 | 123285.714285714286
             5 |              1 |  85000.000000000000
             4 |              1 | 110000.000000000000
             2 |              2 | 106000.000000000000
             6 |              1 |  65000.000000000000
             3 |              2 |  94000.000000000000
(7 rows)

company_db=# 
```

### 11. GROUP BY with HAVING
```sql
-- Find departments with more than 5 employees
SELECT 
    department_id,
    COUNT(*) as employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

```sql
company_db=# -- Find departments with more than 5 employees
company_db=# SELECT 
company_db-#     department_id,
company_db-#     COUNT(*) as employee_count
company_db-# FROM employees
company_db-# GROUP BY department_id
company_db-# HAVING COUNT(*) > 5;
 department_id | employee_count 
---------------+----------------
             1 |              7
(1 row)

company_db=# 
```

## ⚠️ Problem Analysis: Incorrect Data in Complex Query

### The Problematic Query
```sql
SELECT 
    dep.department_id, 
    dep.department_name, 
    dep.budget, 
    SUM(prj.budget) as project_budget, 
    SUM(emp.salary) as employee_salaries
FROM departments dep 
LEFT JOIN employees emp ON emp.department_id = dep.department_id 
LEFT JOIN employee_projects emp_prj ON emp_prj.employee_id = emp.employee_id 
LEFT JOIN projects prj ON prj.project_id = emp_prj.project_id 
GROUP BY dep.department_id
ORDER BY dep.department_name ASC;
```

```sql
company_db=# SELECT 
company_db-#     dep.department_id, 
company_db-#     dep.department_name, 
company_db-#     dep.budget, 
company_db-#     SUM(prj.budget) as project_budget, 
company_db-#     SUM(emp.salary) as employee_salaries
company_db-# FROM departments dep 
company_db-# LEFT JOIN employees emp ON emp.department_id = dep.department_id 
company_db-# LEFT JOIN employee_projects emp_prj ON emp_prj.employee_id = emp.employee_id 
company_db-# LEFT JOIN projects prj ON prj.project_id = emp_prj.project_id 
company_db-# GROUP BY dep.department_id
company_db-# ORDER BY dep.department_name ASC;
 department_id | department_name |   budget   | project_budget | employee_salaries 
---------------+-----------------+------------+----------------+-------------------
             1 | Engineering     | 1500000.00 |      750000.00 |        1238000.00
             5 | Finance         |  900000.00 |                |          85000.00
             4 | Human Resources |  500000.00 |       90000.00 |         110000.00
             2 | Marketing       |  800000.00 |      150000.00 |         212000.00
             6 | Operations      | 1100000.00 |       90000.00 |          65000.00
             3 | Sales           | 1200000.00 |      240000.00 |         188000.00
(6 rows)

company_db=# 
```

**Why are these results incorrect?**

1. **Data Multiplication Issue**: When joining multiple tables, employees working on multiple projects create duplicate rows in the result set before aggregation.
2. **Salary Duplication**: An employee's salary gets counted multiple times if they work on multiple projects.
3. **Missing DISTINCT**: The SUM() function counts the same values multiple times due to joins.

### Corrected Query
```sql
-- Correct approach using DISTINCT or separate aggregations
SELECT 
    dep.department_id, 
    dep.department_name, 
    dep.budget,
    -- Calculate project budget separately
    (SELECT COALESCE(SUM(DISTINCT prj.budget), 0)
     FROM projects prj
     JOIN employee_projects emp_prj ON prj.project_id = emp_prj.project_id
     JOIN employees emp ON emp_prj.employee_id = emp.employee_id
     WHERE emp.department_id = dep.department_id) as project_budget,
    -- Calculate salaries separately
    (SELECT COALESCE(SUM(emp.salary), 0)
     FROM employees emp
     WHERE emp.department_id = dep.department_id) as employee_salaries
FROM departments dep
ORDER BY dep.department_name ASC;
```

```sql
company_db=# -- Correct approach using DISTINCT or separate aggregations
company_db=# SELECT 
company_db-#     dep.department_id, 
company_db-#     dep.department_name, 
company_db-#     dep.budget,
company_db-#     -- Calculate project budget separately
company_db-#     (SELECT COALESCE(SUM(DISTINCT prj.budget), 0)
company_db(#      FROM projects prj
company_db(#      JOIN employee_projects emp_prj ON prj.project_id = emp_prj.project_id
company_db(#      JOIN employees emp ON emp_prj.employee_id = emp.employee_id
company_db(#      WHERE emp.department_id = dep.department_id) as project_budget,
company_db-#     -- Calculate salaries separately
company_db-#     (SELECT COALESCE(SUM(emp.salary), 0)
company_db(#      FROM employees emp
company_db(#      WHERE emp.department_id = dep.department_id) as employee_salaries
company_db-# FROM departments dep
company_db-# ORDER BY dep.department_name ASC;
 department_id | department_name |   budget   | project_budget | employee_salaries 
---------------+-----------------+------------+----------------+-------------------
             1 | Engineering     | 1500000.00 |      200000.00 |         863000.00
             5 | Finance         |  900000.00 |              0 |          85000.00
             4 | Human Resources |  500000.00 |       90000.00 |         110000.00
             2 | Marketing       |  800000.00 |       75000.00 |         212000.00
             6 | Operations      | 1100000.00 |       90000.00 |          65000.00
             3 | Sales           | 1200000.00 |      120000.00 |         188000.00
(6 rows)

company_db=# 
```

### Alternative Corrected Query (Using CTEs)
```sql
-- Using CTE (Common Table Expressions) for clarity
WITH department_employees AS (
    SELECT 
        department_id,
        SUM(salary) as total_salary
    FROM employees
    GROUP BY department_id
),
department_projects AS (
    SELECT 
        emp.department_id,
        SUM(DISTINCT prj.budget) as total_project_budget
    FROM projects prj
    JOIN employee_projects emp_prj ON prj.project_id = emp_prj.project_id
    JOIN employees emp ON emp_prj.employee_id = emp.employee_id
    GROUP BY emp.department_id
)
SELECT 
    dep.department_id,
    dep.department_name,
    dep.budget,
    COALESCE(dp.total_project_budget, 0) as project_budget,
    COALESCE(de.total_salary, 0) as employee_salaries
FROM departments dep
LEFT JOIN department_employees de ON dep.department_id = de.department_id
LEFT JOIN department_projects dp ON dep.department_id = dp.department_id
ORDER BY dep.department_name ASC;
```

```sql
company_db=# -- Using CTE (Common Table Expressions) for clarity
company_db=# WITH department_employees AS (
company_db(#     SELECT 
company_db(#         department_id,
company_db(#         SUM(salary) as total_salary
company_db(#     FROM employees
company_db(#     GROUP BY department_id
company_db(# ),
company_db-# department_projects AS (
company_db(#     SELECT 
company_db(#         emp.department_id,
company_db(#         SUM(DISTINCT prj.budget) as total_project_budget
company_db(#     FROM projects prj
company_db(#     JOIN employee_projects emp_prj ON prj.project_id = emp_prj.project_id
company_db(#     JOIN employees emp ON emp_prj.employee_id = emp.employee_id
company_db(#     GROUP BY emp.department_id
company_db(# )
company_db-# SELECT 
company_db-#     dep.department_id,
company_db-#     dep.department_name,
company_db-#     dep.budget,
company_db-#     COALESCE(dp.total_project_budget, 0) as project_budget,
company_db-#     COALESCE(de.total_salary, 0) as employee_salaries
company_db-# FROM departments dep
company_db-# LEFT JOIN department_employees de ON dep.department_id = de.department_id
company_db-# LEFT JOIN department_projects dp ON dep.department_id = dp.department_id
company_db-# ORDER BY dep.department_name ASC;
 department_id | department_name |   budget   | project_budget | employee_salaries 
---------------+-----------------+------------+----------------+-------------------
             1 | Engineering     | 1500000.00 |      200000.00 |         863000.00
             5 | Finance         |  900000.00 |              0 |          85000.00
             4 | Human Resources |  500000.00 |       90000.00 |         110000.00
             2 | Marketing       |  800000.00 |       75000.00 |         212000.00
             6 | Operations      | 1100000.00 |       90000.00 |          65000.00
             3 | Sales           | 1200000.00 |      120000.00 |         188000.00
(6 rows)

company_db=# 
```

## 🛠️ Data Modification Operations

### 12. INSERT Data
```sql
-- Use a DO block to allow variables usage
DO $$
DECLARE
    new_dept_id INTEGER;
BEGIN
    -- Insert department and capture the ID
    INSERT INTO departments (department_name, location, budget)
    VALUES ('Research & Development', 'Austin', 950000.00)
    RETURNING department_id INTO new_dept_id;
    
    -- Insert employees using the captured ID
    INSERT INTO employees (first_name, last_name, email, job_title, department_id, salary, hire_date)
    VALUES 
        ('John', 'Doe', 'john.doe@company.com', 'Senior Researcher', new_dept_id, 75000.00, '2026-01-15'),
        ('Jane', 'Smith', 'jane.smith@company.com', 'Researcher', new_dept_id, 68000.00, '2026-01-15');
END $$;
```

```sql
company_db=# -- Use a DO block to allow variables usage
company_db=# DO $$
company_db$# DECLARE
company_db$#     new_dept_id INTEGER;
company_db$# BEGIN
company_db$#     -- Insert department and capture the ID
company_db$#     INSERT INTO departments (department_name, location, budget)
company_db$#     VALUES ('Research & Development', 'Austin', 950000.00)
company_db$#     RETURNING department_id INTO new_dept_id;
company_db$#     
company_db$#     -- Insert employees using the captured ID
company_db$#     INSERT INTO employees (first_name, last_name, email, job_title, department_id, salary, hire_date)
company_db$#     VALUES 
company_db$#         ('John', 'Doe', 'john.doe@company.com', 'Senior Researcher', new_dept_id, 75000.00, '2026-01-15'),
company_db$#         ('Jane', 'Smith', 'jane.smith@company.com', 'Researcher', new_dept_id, 68000.00, '2026-01-15');
company_db$# END $$;
DO
company_db=# SELECT * FROM employees WHERE job_title like '%Researcher';
 employee_id | first_name | last_name |         email          | phone | hire_date  |     job_title     | department_id |  salary  | manager_id |        created_at         
-------------+------------+-----------+------------------------+-------+------------+-------------------+---------------+----------+------------+---------------------------
          16 | John       | Doe       | john.doe@company.com   |       | 2026-01-15 | Senior Researcher |             7 | 75000.00 |            | 2026-01-15 21:59:07.44861
          17 | Jane       | Smith     | jane.smith@company.com |       | 2026-01-15 | Researcher        |             7 | 68000.00 |            | 2026-01-15 21:59:07.44861
(2 rows)

company_db=# 
```

### 13. UPDATE Data
```sql
-- Give all employees in Engineering a 10% raise
UPDATE employees
SET salary = salary * 1.10
WHERE department_id = 1;

-- Update department budget based on employee costs
UPDATE departments dep
SET budget = (
    SELECT SUM(salary) * 12 * 1.20  -- 20% overhead
    FROM employees emp
    WHERE emp.department_id = dep.department_id
)
WHERE budget IS NULL;
```

```sql
company_db=# -- Give all employees in Engineering a 10% raise
company_db=# UPDATE employees
company_db-# SET salary = salary * 1.10
company_db-# WHERE department_id = 1;
UPDATE 7
company_db=# 
company_db=# -- Update department budget based on employee costs
company_db=# UPDATE departments dep
company_db-# SET budget = (
company_db(#     SELECT SUM(salary) * 12 * 1.20  -- 20% overhead
company_db(#     FROM employees emp
company_db(#     WHERE emp.department_id = dep.department_id
company_db(# )
company_db-# WHERE budget IS NULL;
UPDATE 0
company_db=# SELECT * FROM employees WHERE department_id = 1;
 employee_id | first_name | last_name |         email         |  phone   | hire_date  |        job_title         | department_id |  salary   | manager_id |        created_at         
-------------+------------+-----------+-----------------------+----------+------------+--------------------------+---------------+-----------+------------+---------------------------
           2 | Sarah      | Johnson   | sarah.j@company.com   | 555-0102 | 2019-06-01 | CTO                      |             1 | 220000.00 |          1 | 2026-01-15 21:56:42.43906
           3 | Michael    | Chen      | michael.c@company.com | 555-0103 | 2020-01-15 | Engineering Manager      |             1 | 165000.00 |          2 | 2026-01-15 21:56:42.43906
           4 | Emily      | Williams  | emily.w@company.com   | 555-0104 | 2021-03-22 | Senior Software Engineer |             1 | 143000.00 |          3 | 2026-01-15 21:56:42.43906
           5 | David      | Brown     | david.b@company.com   | 555-0105 | 2022-08-10 | Software Engineer        |             1 | 104500.00 |          3 | 2026-01-15 21:56:42.43906
          11 | James      | Anderson  | james.a@company.com   | 555-0111 | 2020-04-12 | DevOps Engineer          |             1 | 126500.00 |          3 | 2026-01-15 21:56:42.43906
          12 | Maria      | Thomas    | maria.t@company.com   | 555-0112 | 2021-08-19 | Software Engineer        |             1 | 107800.00 |          3 | 2026-01-15 21:56:42.43906
          13 | Charles    | Jackson   | charles.j@company.com | 555-0113 | 2022-11-03 | Junior Developer         |             1 |  82500.00 |          3 | 2026-01-15 21:56:42.43906
(7 rows)

company_db=# 
```

### 14. DELETE Data
```sql
-- Delete employees with no department (not possible due to foreign key constraints)
DELETE FROM employees
WHERE department_id IS NULL;

-- Delete a department only if it has no employees
DELETE FROM departments
WHERE department_id = 7
AND NOT EXISTS (
    SELECT 1 
    FROM employees 
    WHERE department_id = 7
);
```

```sql
company_db=# -- Delete employees with no department
company_db=# DELETE FROM employees
company_db-# WHERE department_id IS NULL;
ERROR:  update or delete on table "employees" violates foreign key constraint "employees_manager_id_fkey" on table "employees"
DETAIL:  Key (employee_id)=(1) is still referenced from table "employees".
company_db=# 
company_db=# -- Delete a department only if it has no employees
company_db=# DELETE FROM departments
company_db-# WHERE department_id = 7
company_db-# AND NOT EXISTS (
company_db(#     SELECT 1 
company_db(#     FROM employees 
company_db(#     WHERE department_id = 7
company_db(# );
DELETE 0
company_db=# 
```

## 📋 Creating and Using Views

### 15. Creating Views
```sql
-- Create a view for active projects
CREATE VIEW active_projects AS
SELECT 
    prj.project_id,
    prj.project_name,
    prj.budget,
    COUNT(emp_prj.employee_id) as team_size
FROM projects prj
LEFT JOIN employee_projects emp_prj ON prj.project_id = emp_prj.project_id
WHERE prj.status = 'Active'
GROUP BY prj.project_id, prj.project_name, prj.budget;

-- Use the view
SELECT * FROM active_projects WHERE team_size > 3;
```

```sql
company_db=# -- Create a view for active projects
company_db=# CREATE VIEW active_projects AS
company_db-# SELECT 
company_db-#     prj.project_id,
company_db-#     prj.project_name,
company_db-#     prj.budget,
company_db-#     COUNT(emp_prj.employee_id) as team_size
company_db-# FROM projects prj
company_db-# LEFT JOIN employee_projects emp_prj ON prj.project_id = emp_prj.project_id
company_db-# WHERE prj.status = 'Active'
company_db-# GROUP BY prj.project_id, prj.project_name, prj.budget;
ERROR:  relation "active_projects" already exists
company_db=# 
company_db=# -- Use the view
company_db=# SELECT * FROM active_projects WHERE team_size > 3;
      project_name      | start_date |  end_date  |  budget   | status | team_size 
------------------------+------------+------------+-----------+--------+-----------
 Mobile App Development | 2023-03-01 | 2023-12-15 | 150000.00 | Active |         4
(1 row)

company_db=# 
```

## 🏆 Best Practices

### 16. SQL Best Practices
1. **Always use explicit JOINs** instead of implicit joins
2. **Use table aliases** for readability
3. **Test queries with LIMIT** before running on full datasets
4. **Use transactions** for multiple update/insert operations
5. **Add comments** to complex queries
6. **Validate data types** before operations

### 17. Transaction Example
```sql
-- Example: Promote an employee and adjust their salary
BEGIN;

-- First, get current salary for reference
SELECT first_name, last_name, salary 
FROM employees 
WHERE employee_id = 4;

-- Update the employee's job title and salary
UPDATE employees 
SET job_title = 'Lead Software Engineer', 
    salary = salary * 1.15  -- 15% raise
WHERE employee_id = 4;

-- Assign them to manage the Engineering department
UPDATE departments 
SET manager_id = 4 
WHERE department_id = 1;

COMMIT;

-- Verify the changes
SELECT e.employee_id, e.first_name, e.last_name, e.job_title, e.salary, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id = 4;
```

```sql
company_db=# -- Example 1: Promote an employee and adjust their salary
company_db=# BEGIN;
BEGIN
company_db=*# 
company_db=*# -- First, get current salary for reference
company_db=*# SELECT first_name, last_name, salary 
company_db-*# FROM employees 
company_db-*# WHERE employee_id = 4;
 first_name | last_name |  salary   
------------+-----------+-----------
 Emily      | Williams  | 143000.00
(1 row)

company_db=*# 
company_db=*# -- Update the employee's job title and salary
company_db=*# UPDATE employees 
company_db-*# SET job_title = 'Lead Software Engineer', 
company_db-*#     salary = salary * 1.15  -- 15% raise
company_db-*# WHERE employee_id = 4;
UPDATE 1
company_db=*# 
company_db=*# -- Assign them to manage the Engineering department
company_db=*# UPDATE departments 
company_db-*# SET manager_id = 4 
company_db-*# WHERE department_id = 1;
UPDATE 1
company_db=*# 
company_db=*# -- Log the promotion (if you had an audit table)
company_db=*# -- INSERT INTO promotion_log (employee_id, old_title, new_title, raise_percentage, promoted_by, promotion_date)
company_db=*# -- VALUES (4, 'Senior Software Engineer', 'Lead Software Engineer', 15, CURRENT_USER, NOW());
company_db=*# 
company_db=*# COMMIT;
COMMIT
company_db=# 
company_db=# -- Verify the changes
company_db=# SELECT e.employee_id, e.first_name, e.last_name, e.job_title, e.salary, d.department_name
company_db-# FROM employees e
company_db-# LEFT JOIN departments d ON e.department_id = d.department_id
company_db-# WHERE e.employee_id = 4;
 employee_id | first_name | last_name |       job_title        |  salary   | department_name 
-------------+------------+-----------+------------------------+-----------+-----------------
           4 | Emily      | Williams  | Lead Software Engineer | 164450.00 | Engineering
(1 row)

company_db=# 
```

## 📚 Summary

This tutorial covers essential SQL operations from basic navigation to complex querying. By practicing with these examples, you'll build confidence in writing and debugging SQL queries, understanding database relationships, and optimizing query performance for real-world applications.

---

_Ready to master SQL? Continue practicing with different datasets and explore advanced features like window functions, stored procedures, and performance tuning!_