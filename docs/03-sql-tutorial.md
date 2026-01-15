

01. Connecto with the database

```bash
docker exec -it postgres-demo psql -U demo -d demo_db
```

02. List all databases


```sql
demo_db-# \l
                                               List of databases
     Name      | Owner | Encoding | Locale Provider | Collate | Ctype | Locale | ICU Rules | Access privileges 
---------------+-------+----------+-----------------+---------+-------+--------+-----------+-------------------
 company_db    | demo  | UTF8     | libc            | C       | C     |        |           | 
 demo_db       | demo  | UTF8     | libc            | C       | C     |        |           | 
 ecommerce_db  | demo  | UTF8     | libc            | C       | C     |        |           | 
 library_db    | demo  | UTF8     | libc            | C       | C     |        |           | 
 postgres      | demo  | UTF8     | libc            | C       | C     |        |           | 
 template0     | demo  | UTF8     | libc            | C       | C     |        |           | =c/demo          +
               |       |          |                 |         |       |        |           | demo=CTc/demo
 template1     | demo  | UTF8     | libc            | C       | C     |        |           | =c/demo          +
               |       |          |                 |         |       |        |           | demo=CTc/demo
 university_db | demo  | UTF8     | libc            | C       | C     |        |           | 
(8 rows)

demo_db-# 
```

03. List all databases using SQL


```sql
SELECT datname AS database_name, 
       pg_size_pretty(pg_database_size(datname)) AS size, 
       datallowconn AS allow_connections, 
       encoding, 
       datcollate
FROM pg_catalog.pg_database;
```

```sql
company_db=# SELECT datname AS database_name, 
company_db-#        pg_size_pretty(pg_database_size(datname)) AS size, 
company_db-#        datallowconn AS allow_connections, 
company_db-#        encoding, 
company_db-#        datcollate
company_db-# FROM pg_catalog.pg_database;
 database_name |  size   | allow_connections | encoding | datcollate 
---------------+---------+-------------------+----------+------------
 postgres      | 7678 kB | t                 |        6 | C
 demo_db       | 7774 kB | t                 |        6 | C
 template1     | 7750 kB | t                 |        6 | C
 template0     | 7521 kB | f                 |        6 | C
 company_db    | 7982 kB | t                 |        6 | C
 university_db | 8030 kB | t                 |        6 | C
 ecommerce_db  | 7990 kB | t                 |        6 | C
 library_db    | 7966 kB | t                 |        6 | C
(8 rows)

company_db=# 

```

04. Connect with specific database

```sql
demo_db=# \c company_db
You are now connected to database "company_db" as user "demo".
company_db=#   
```

05. List tables in a database

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

company_db=# 
```

06. Execute a single SQL Query

```sql
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
```

07. Subquery

```sql
SELECT department_id, 
       department_name, 
       budget, 
       (SELECT SUM(emp.salary) 
        FROM employees emp 
        WHERE emp.department_id = dep.department_id) as monthly_cost,
        budget - monthly_cost
FROM departments dep;
```

```sql
company_db=# SELECT department_id, 
company_db-#        department_name, 
company_db-#        budget, 
company_db-#        (SELECT SUM(emp.salary) 
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

This information is correct, can you explain why?|

06. Execut inner join 

```sql
SELECT 
     prj.project_id, 
     prj.project_name, 
     prj.budget, 
     SUM(emp.salary) as employee_cost
FROM projects prj 
LEFT JOIN employee_projects emp_prj ON emp_prj.project_id = prj.project_id 
LEFT JOIN employees emp ON emp.employee_id = emp_prj.employee_id 

GROUP BY prj.project_id 
ORDER BY project_name ASC;
```

```sql
company_db=# SELECT 
company_db-#      prj.project_id, 
company_db-#      prj.project_name, 
company_db-#      prj.budget, 
company_db-#      SUM(emp.salary) as employee_cost
company_db-# FROM projects prj 
company_db-# LEFT JOIN employee_projects emp_prj ON emp_prj.project_id = prj.project_id 
company_db-# LEFT JOIN employees emp ON emp.employee_id = emp_prj.employee_id 
company_db-# 
company_db-# GROUP BY prj.project_id 
company_db-# ORDER BY project_name ASC;
 project_id |       project_name       |  budget   | employee_cost 
------------+--------------------------+-----------+---------------
          3 | CRM Implementation       | 120000.00 |     188000.00
          5 | Data Migration           |  90000.00 |     175000.00
          6 | Employee Training Portal |  40000.00 |              
          4 | Marketing Campaign Q4    |  75000.00 |     212000.00
          2 | Mobile App Development   | 150000.00 |     490000.00
          1 | Website Redesign         |  50000.00 |     375000.00
(6 rows)

company_db=# 
```

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
company_db-#      dep.department_id, 
company_db-#      dep.department_name, 
company_db-#      dep.budget, 
company_db-#      SUM(prj.budget) as project_budget, 
company_db-#      SUM(emp.salary) as employee_salaries 
company_db-# 
company_db-# FROM departments dep 
company_db-# LEFT JOIN employees emp ON emp.department_id = dep.department_id 
company_db-# LEFT JOIN employee_projects emp_prj ON emp_prj.employee_id = emp.employee_id 
company_db-# LEFT JOIN projects prj ON prj.project_id = emp_prj.project_id 
company_db-# 
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

These information are incorrect, can you explain why?