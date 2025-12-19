# Relational Algebra in SQL - Demonstration Repository

## 📋 Overview

This repository demonstrates the practical implementation of **relational algebra operations** using PostgreSQL with a real-world dataset. It provides a complete Docker-based environment to explore and compare different relational operations and their performance characteristics.

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose installed
- 2GB+ of available RAM

### Start the Environment
```bash
docker-compose up -d
``` 

### Stop and Cleanup

```bash
docker-compose down -v
```

## 📊 Dataset
The demo includes a generated dataset with:

* 1,000,000 employees across 7 departments
* 7 departments with budget and location data
* 100 projects with budget and timeline information

## 🧮 Relational Algebra Operations Demonstrated

### 1. Selection (σ)

```sql
-- Select all employees with salary > 100,000
SELECT * FROM employees WHERE salary > 100000;
```

```bash
time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees WHERE salary > 100000;"
   id    |     name      | department  |  salary   | hire_date  |         created_at         
---------+---------------+-------------+-----------+------------+----------------------------
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116
       2 | Bob Diana     | Marketing   | 184619.53 | 2018-03-30 | 2025-12-19 21:25:48.010116
       3 | Alice Eve     | HR          | 114804.04 | 2025-08-26 | 2025-12-19 21:25:48.010116
       5 | Diana John    | IT          | 159582.83 | 2023-10-19 | 2025-12-19 21:25:48.010116
       7 | Frank Bob     | Engineering | 184382.83 | 2016-07-24 | 2025-12-19 21:25:48.010116
       8 | John Alice    | Sales       | 104500.54 | 2017-07-18 | 2025-12-19 21:25:48.010116
       9 | Jane Charlie  | Marketing   | 119304.04 | 2016-09-07 | 2025-12-19 21:25:48.010116
      10 | Bob Diana     | HR          | 185289.04 | 2022-12-25 | 2025-12-19 21:25:48.010116

....

  999990 | Eve Jane      | IT          | 156327.64 | 2024-04-02 | 2025-12-19 21:25:48.010116
  999991 | Frank Bob     | Operations  | 113790.96 | 2020-10-16 | 2025-12-19 21:25:48.010116
  999992 | John Alice    | Engineering | 172066.33 | 2016-06-13 | 2025-12-19 21:25:48.010116
  999993 | Jane Charlie  | Sales       | 153027.06 | 2019-07-02 | 2025-12-19 21:25:48.010116
  999994 | Bob Diana     | Marketing   | 100315.18 | 2021-11-18 | 2025-12-19 21:25:48.010116
  999997 | Diana John    | IT          | 138343.17 | 2019-07-04 | 2025-12-19 21:25:48.010116
  999999 | Frank Bob     | Engineering | 104283.48 | 2019-02-23 | 2025-12-19 21:25:48.010116
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116
(666516 rows)

real	0m2,871s
user	0m0,043s
sys	0m0,529s
```

### 2. Projection (π)

```sql
-- Project specific columns
SELECT id, name, department FROM employees;
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT id, name, department FROM employees;"
   id    |     name      | department  
---------+---------------+-------------
       1 | Jane Charlie  | Sales
       2 | Bob Diana     | Marketing
       3 | Alice Eve     | HR
       4 | Charlie Frank | Finance
       5 | Diana John    | IT
       6 | Eve Jane      | Operations
       7 | Frank Bob     | Engineering
       8 | John Alice    | Sales

....

  999993 | Jane Charlie  | Sales
  999994 | Bob Diana     | Marketing
  999995 | Alice Eve     | HR
  999996 | Charlie Frank | Finance
  999997 | Diana John    | IT
  999998 | Eve Jane      | Operations
  999999 | Frank Bob     | Engineering
 1000000 | John Alice    | Sales
(1000000 rows)

real	0m2,871s
user	0m0,043s
sys	0m0,529s
```

### 3. Union (∪)


```sql
-- Two methods to achieve union
SELECT * FROM employees WHERE salary < 60000 
UNION 
SELECT * FROM employees WHERE salary > 100000;

-- Alternative with OR (usually faster)
SELECT * FROM employees WHERE salary < 60000 OR salary > 100000;
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees WHERE salary < 60000 UNION SELECT * FROM employees WHERE salary > 100000;"
   id    |     name      | department  |  salary   | hire_date  |         created_at         
---------+---------------+-------------+-----------+------------+----------------------------
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116
       2 | Bob Diana     | Marketing   | 184619.53 | 2018-03-30 | 2025-12-19 21:25:48.010116
       3 | Alice Eve     | HR          | 114804.04 | 2025-08-26 | 2025-12-19 21:25:48.010116
       5 | Diana John    | IT          | 159582.83 | 2023-10-19 | 2025-12-19 21:25:48.010116
       7 | Frank Bob     | Engineering | 184382.83 | 2016-07-24 | 2025-12-19 21:25:48.010116
       8 | John Alice    | Sales       | 104500.54 | 2017-07-18 | 2025-12-19 21:25:48.010116
       9 | Jane Charlie  | Marketing   | 119304.04 | 2016-09-07 | 2025-12-19 21:25:48.010116
      10 | Bob Diana     | HR          | 185289.04 | 2022-12-25 | 2025-12-19 21:25:48.010116

....

  999991 | Frank Bob     | Operations  | 113790.96 | 2020-10-16 | 2025-12-19 21:25:48.010116
  999992 | John Alice    | Engineering | 172066.33 | 2016-06-13 | 2025-12-19 21:25:48.010116
  999993 | Jane Charlie  | Sales       | 153027.06 | 2019-07-02 | 2025-12-19 21:25:48.010116
  999994 | Bob Diana     | Marketing   | 100315.18 | 2021-11-18 | 2025-12-19 21:25:48.010116
  999996 | Charlie Frank | Finance     |  51922.35 | 2019-06-11 | 2025-12-19 21:25:48.010116
  999997 | Diana John    | IT          | 138343.17 | 2019-07-04 | 2025-12-19 21:25:48.010116
  999999 | Frank Bob     | Engineering | 104283.48 | 2019-02-23 | 2025-12-19 21:25:48.010116
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116
(733471 rows)

real	0m3,374s
user	0m0,033s
sys	0m0,625s
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees WHERE salary < 60000 OR salary > 100000;"
   id    |     name      | department  |  salary   | hire_date  |         created_at         
---------+---------------+-------------+-----------+------------+----------------------------
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116
       2 | Bob Diana     | Marketing   | 184619.53 | 2018-03-30 | 2025-12-19 21:25:48.010116
       3 | Alice Eve     | HR          | 114804.04 | 2025-08-26 | 2025-12-19 21:25:48.010116
       5 | Diana John    | IT          | 159582.83 | 2023-10-19 | 2025-12-19 21:25:48.010116
       7 | Frank Bob     | Engineering | 184382.83 | 2016-07-24 | 2025-12-19 21:25:48.010116
       8 | John Alice    | Sales       | 104500.54 | 2017-07-18 | 2025-12-19 21:25:48.010116
       9 | Jane Charlie  | Marketing   | 119304.04 | 2016-09-07 | 2025-12-19 21:25:48.010116
      10 | Bob Diana     | HR          | 185289.04 | 2022-12-25 | 2025-12-19 21:25:48.010116

....

  999991 | Frank Bob     | Operations  | 113790.96 | 2020-10-16 | 2025-12-19 21:25:48.010116
  999992 | John Alice    | Engineering | 172066.33 | 2016-06-13 | 2025-12-19 21:25:48.010116
  999993 | Jane Charlie  | Sales       | 153027.06 | 2019-07-02 | 2025-12-19 21:25:48.010116
  999994 | Bob Diana     | Marketing   | 100315.18 | 2021-11-18 | 2025-12-19 21:25:48.010116
  999996 | Charlie Frank | Finance     |  51922.35 | 2019-06-11 | 2025-12-19 21:25:48.010116
  999997 | Diana John    | IT          | 138343.17 | 2019-07-04 | 2025-12-19 21:25:48.010116
  999999 | Frank Bob     | Engineering | 104283.48 | 2019-02-23 | 2025-12-19 21:25:48.010116
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116
(733471 rows)

real	0m3,232s
user	0m0,043s
sys	0m0,603s
```

### 4. Intersection (∩)

```sql
-- Using INTERSECT
SELECT * FROM employees WHERE salary > 60000 
INTERSECT 
SELECT * FROM employees WHERE salary < 100000;

-- Using AND condition
SELECT * FROM employees WHERE salary > 60000 AND salary < 100000;
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees WHERE salary > 60000 INTERSECT SELECT * FROM employees WHERE salary < 100000;"
   id   |     name      | department  |  salary  | hire_date  |         created_at         
--------+---------------+-------------+----------+------------+----------------------------
 320175 | Frank Bob     | Marketing   | 88582.21 | 2016-07-05 | 2025-12-19 21:25:48.010116
 979033 | Jane Charlie  | Operations  | 88515.85 | 2018-06-08 | 2025-12-19 21:25:48.010116
 887491 | Alice Eve     | HR          | 88731.60 | 2017-08-13 | 2025-12-19 21:25:48.010116
 575867 | Alice Eve     | IT          | 71996.50 | 2017-08-04 | 2025-12-19 21:25:48.010116
 373538 | Bob Diana     | Finance     | 61186.35 | 2025-02-17 | 2025-12-19 21:25:48.010116
 348888 | John Alice    | Sales       | 92012.70 | 2022-07-30 | 2025-12-19 21:25:48.010116
 960145 | Jane Charlie  | Finance     | 91114.98 | 2021-02-08 | 2025-12-19 21:25:48.010116
 615962 | Bob Diana     | Finance     | 77008.90 | 2021-12-12 | 2025-12-19 21:25:48.010116

....

 949646 | Eve Jane      | IT          | 97054.86 | 2020-09-19 | 2025-12-19 21:25:48.010116
 117050 | Bob Diana     | HR          | 98050.74 | 2024-01-01 | 2025-12-19 21:25:48.010116
 661272 | John Alice    | HR          | 78378.80 | 2016-02-06 | 2025-12-19 21:25:48.010116
 509627 | Alice Eve     | Operations  | 96118.74 | 2021-10-27 | 2025-12-19 21:25:48.010116
 489129 | Jane Charlie  | Finance     | 92853.34 | 2023-11-16 | 2025-12-19 21:25:48.010116
  88101 | Diana John    | Operations  | 66246.65 | 2018-04-23 | 2025-12-19 21:25:48.010116
  28898 | Bob Diana     | Marketing   | 66900.84 | 2020-08-09 | 2025-12-19 21:25:48.010116
  56638 | Eve Jane      | Sales       | 72519.52 | 2019-05-31 | 2025-12-19 21:25:48.010116
(266529 rows)

real	0m1,616s
user	0m0,014s
sys	0m0,232s
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees WHERE salary > 60000 AND salary < 100000;"
   id   |     name      | department  |  salary  | hire_date  |         created_at         
--------+---------------+-------------+----------+------------+----------------------------
      4 | Charlie Frank | Finance     | 82209.00 | 2025-02-24 | 2025-12-19 21:25:48.010116
      6 | Eve Jane      | Operations  | 85249.23 | 2025-06-19 | 2025-12-19 21:25:48.010116
     16 | John Alice    | Marketing   | 72971.33 | 2016-07-25 | 2025-12-19 21:25:48.010116
     22 | Eve Jane      | Sales       | 86367.94 | 2023-08-19 | 2025-12-19 21:25:48.010116
     24 | John Alice    | HR          | 73662.70 | 2024-05-08 | 2025-12-19 21:25:48.010116
     25 | Jane Charlie  | Finance     | 86645.92 | 2024-04-08 | 2025-12-19 21:25:48.010116
     26 | Bob Diana     | IT          | 76406.17 | 2023-07-11 | 2025-12-19 21:25:48.010116
     28 | Charlie Frank | Engineering | 60233.65 | 2025-12-05 | 2025-12-19 21:25:48.010116

....

 999971 | Alice Eve     | Engineering | 62914.69 | 2017-06-01 | 2025-12-19 21:25:48.010116
 999973 | Diana John    | Marketing   | 65180.74 | 2021-02-14 | 2025-12-19 21:25:48.010116
 999974 | Eve Jane      | HR          | 92440.11 | 2020-07-03 | 2025-12-19 21:25:48.010116
 999981 | Diana John    | HR          | 83649.74 | 2024-03-31 | 2025-12-19 21:25:48.010116
 999985 | Jane Charlie  | Engineering | 83211.46 | 2017-12-22 | 2025-12-19 21:25:48.010116
 999987 | Alice Eve     | Marketing   | 67419.86 | 2017-11-16 | 2025-12-19 21:25:48.010116
 999995 | Alice Eve     | HR          | 90374.53 | 2017-01-17 | 2025-12-19 21:25:48.010116
 999998 | Eve Jane      | Operations  | 94336.18 | 2022-07-11 | 2025-12-19 21:25:48.010116
(266529 rows)


real	0m1,211s
user	0m0,024s
sys	0m0,233s
```

### 5. Difference (-)

```sql
-- Employees with salary between 60k-100k, excluding IT department
SELECT * FROM employees WHERE salary > 60000 AND salary < 100000 
EXCEPT 
SELECT * FROM employees WHERE department = 'IT';
-- Using OR condition
SELECT * FROM employees WHERE (salary > 60000 AND salary < 100000) AND NOT (department = 'IT');
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees WHERE salary > 60000 AND salary < 100000 EXCEPT SELECT * FROM employees WHERE department = 'IT';"
   id   |     name      | department  |  salary  | hire_date  |         created_at         
--------+---------------+-------------+----------+------------+----------------------------
 320175 | Frank Bob     | Marketing   | 88582.21 | 2016-07-05 | 2025-12-19 21:25:48.010116
 979033 | Jane Charlie  | Operations  | 88515.85 | 2018-06-08 | 2025-12-19 21:25:48.010116
 887491 | Alice Eve     | HR          | 88731.60 | 2017-08-13 | 2025-12-19 21:25:48.010116
 373538 | Bob Diana     | Finance     | 61186.35 | 2025-02-17 | 2025-12-19 21:25:48.010116
 348888 | John Alice    | Sales       | 92012.70 | 2022-07-30 | 2025-12-19 21:25:48.010116
 960145 | Jane Charlie  | Finance     | 91114.98 | 2021-02-08 | 2025-12-19 21:25:48.010116
 615962 | Bob Diana     | Finance     | 77008.90 | 2021-12-12 | 2025-12-19 21:25:48.010116
 234888 | John Alice    | HR          | 70719.65 | 2022-04-06 | 2025-12-19 21:25:48.010116

....

  95628 | Charlie Frank | Sales       | 63415.55 | 2021-07-17 | 2025-12-19 21:25:48.010116
 117050 | Bob Diana     | HR          | 98050.74 | 2024-01-01 | 2025-12-19 21:25:48.010116
 661272 | John Alice    | HR          | 78378.80 | 2016-02-06 | 2025-12-19 21:25:48.010116
 509627 | Alice Eve     | Operations  | 96118.74 | 2021-10-27 | 2025-12-19 21:25:48.010116
 489129 | Jane Charlie  | Finance     | 92853.34 | 2023-11-16 | 2025-12-19 21:25:48.010116
  88101 | Diana John    | Operations  | 66246.65 | 2018-04-23 | 2025-12-19 21:25:48.010116
  28898 | Bob Diana     | Marketing   | 66900.84 | 2020-08-09 | 2025-12-19 21:25:48.010116
  56638 | Eve Jane      | Sales       | 72519.52 | 2019-05-31 | 2025-12-19 21:25:48.010116
(228502 rows)

real	0m1,147s
user	0m0,022s
sys	0m0,176s
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees WHERE (salary > 60000 AND salary < 100000) AND NOT (department = 'IT');"
   id   |     name      | department  |  salary  | hire_date  |         created_at         
--------+---------------+-------------+----------+------------+----------------------------
      4 | Charlie Frank | Finance     | 82209.00 | 2025-02-24 | 2025-12-19 21:25:48.010116
      6 | Eve Jane      | Operations  | 85249.23 | 2025-06-19 | 2025-12-19 21:25:48.010116
     16 | John Alice    | Marketing   | 72971.33 | 2016-07-25 | 2025-12-19 21:25:48.010116
     22 | Eve Jane      | Sales       | 86367.94 | 2023-08-19 | 2025-12-19 21:25:48.010116
     24 | John Alice    | HR          | 73662.70 | 2024-05-08 | 2025-12-19 21:25:48.010116
     25 | Jane Charlie  | Finance     | 86645.92 | 2024-04-08 | 2025-12-19 21:25:48.010116
     28 | Charlie Frank | Engineering | 60233.65 | 2025-12-05 | 2025-12-19 21:25:48.010116
     30 | Eve Jane      | Marketing   | 65132.13 | 2020-09-03 | 2025-12-19 21:25:48.010116

....

 999971 | Alice Eve     | Engineering | 62914.69 | 2017-06-01 | 2025-12-19 21:25:48.010116
 999973 | Diana John    | Marketing   | 65180.74 | 2021-02-14 | 2025-12-19 21:25:48.010116
 999974 | Eve Jane      | HR          | 92440.11 | 2020-07-03 | 2025-12-19 21:25:48.010116
 999981 | Diana John    | HR          | 83649.74 | 2024-03-31 | 2025-12-19 21:25:48.010116
 999985 | Jane Charlie  | Engineering | 83211.46 | 2017-12-22 | 2025-12-19 21:25:48.010116
 999987 | Alice Eve     | Marketing   | 67419.86 | 2017-11-16 | 2025-12-19 21:25:48.010116
 999995 | Alice Eve     | HR          | 90374.53 | 2017-01-17 | 2025-12-19 21:25:48.010116
 999998 | Eve Jane      | Operations  | 94336.18 | 2022-07-11 | 2025-12-19 21:25:48.010116
(228502 rows)

real	0m1,085s
user	0m0,025s
sys	0m0,182s
```


### 6. Cartesian Product (×)

```sql
-- Full cartesian product (expensive!)
SELECT * FROM employees CROSS JOIN departments;

-- Practical use with filter
SELECT * FROM employees CROSS JOIN departments 
WHERE department = dept_name;
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees CROSS JOIN departments;"
   id    |     name      | department  |  salary   | hire_date  |         created_at         | id |  dept_name  |  budget   |   location    
---------+---------------+-------------+-----------+------------+----------------------------+----+-------------+-----------+---------------
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  1 | Engineering | 633869.63 | New York
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  2 | Sales       |  41521.61 | San Francisco
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  3 | Marketing   |  62656.23 | San Francisco
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  4 | HR          | 874782.07 | San Francisco
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  5 | Finance     | 913265.60 | San Francisco
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  6 | IT          | 280380.19 | San Francisco
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  7 | Operations  | 827000.25 | San Francisco
       2 | Bob Diana     | Marketing   | 184619.53 | 2018-03-30 | 2025-12-19 21:25:48.010116 |  1 | Engineering | 633869.63 | New York

....

  999999 | Frank Bob     | Engineering | 104283.48 | 2019-02-23 | 2025-12-19 21:25:48.010116 |  7 | Operations  | 827000.25 | San Francisco
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  1 | Engineering | 633869.63 | New York
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  2 | Sales       |  41521.61 | San Francisco
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  3 | Marketing   |  62656.23 | San Francisco
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  4 | HR          | 874782.07 | San Francisco
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  5 | Finance     | 913265.60 | San Francisco
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  6 | IT          | 280380.19 | San Francisco
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  7 | Operations  | 827000.25 | San Francisco
(7000000 rows)

real	0m47,073s
user	0m0,825s
sys	0m7,847s
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM employees CROSS JOIN departments WHERE department = dept_name;"
   id    |     name      | department  |  salary   | hire_date  |         created_at         | id |  dept_name  |  budget   |   location    
---------+---------------+-------------+-----------+------------+----------------------------+----+-------------+-----------+---------------
       1 | Jane Charlie  | Sales       | 152111.55 | 2019-07-09 | 2025-12-19 21:25:48.010116 |  2 | Sales       |  41521.61 | San Francisco
       2 | Bob Diana     | Marketing   | 184619.53 | 2018-03-30 | 2025-12-19 21:25:48.010116 |  3 | Marketing   |  62656.23 | San Francisco
       3 | Alice Eve     | HR          | 114804.04 | 2025-08-26 | 2025-12-19 21:25:48.010116 |  4 | HR          | 874782.07 | San Francisco
       4 | Charlie Frank | Finance     |  82209.00 | 2025-02-24 | 2025-12-19 21:25:48.010116 |  5 | Finance     | 913265.60 | San Francisco
       5 | Diana John    | IT          | 159582.83 | 2023-10-19 | 2025-12-19 21:25:48.010116 |  6 | IT          | 280380.19 | San Francisco
       6 | Eve Jane      | Operations  |  85249.23 | 2025-06-19 | 2025-12-19 21:25:48.010116 |  7 | Operations  | 827000.25 | San Francisco
       7 | Frank Bob     | Engineering | 184382.83 | 2016-07-24 | 2025-12-19 21:25:48.010116 |  1 | Engineering | 633869.63 | New York
       8 | John Alice    | Sales       | 104500.54 | 2017-07-18 | 2025-12-19 21:25:48.010116 |  2 | Sales       |  41521.61 | San Francisco

....

  999993 | Jane Charlie  | Sales       | 153027.06 | 2019-07-02 | 2025-12-19 21:25:48.010116 |  2 | Sales       |  41521.61 | San Francisco
  999994 | Bob Diana     | Marketing   | 100315.18 | 2021-11-18 | 2025-12-19 21:25:48.010116 |  3 | Marketing   |  62656.23 | San Francisco
  999995 | Alice Eve     | HR          |  90374.53 | 2017-01-17 | 2025-12-19 21:25:48.010116 |  4 | HR          | 874782.07 | San Francisco
  999996 | Charlie Frank | Finance     |  51922.35 | 2019-06-11 | 2025-12-19 21:25:48.010116 |  5 | Finance     | 913265.60 | San Francisco
  999997 | Diana John    | IT          | 138343.17 | 2019-07-04 | 2025-12-19 21:25:48.010116 |  6 | IT          | 280380.19 | San Francisco
  999998 | Eve Jane      | Operations  |  94336.18 | 2022-07-11 | 2025-12-19 21:25:48.010116 |  7 | Operations  | 827000.25 | San Francisco
  999999 | Frank Bob     | Engineering | 104283.48 | 2019-02-23 | 2025-12-19 21:25:48.010116 |  1 | Engineering | 633869.63 | New York
 1000000 | John Alice    | Sales       | 157509.75 | 2016-03-01 | 2025-12-19 21:25:48.010116 |  2 | Sales       |  41521.61 | San Francisco
(1000000 rows)

real	0m6,422s
user	0m0,147s
sys	0m1,154s
```

### 7. Join (⨝)


```sql
-- Left join with aggregation
SELECT dpt.id, COUNT(prj.id) as projects 
FROM departments dpt 
LEFT JOIN projects prj ON dpt.id = prj.department_id 
GROUP BY dpt.id;
```

```bash
$ time docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT dpt.id, count(prj.id) as projects FROM departments dpt LEFT JOIN projects prj on dpt.id = prj.department_id GROUP BY dpt.id;" 
 id | projects 
----+----------
  3 |       15
  5 |       14
  4 |       14
  6 |       14
  2 |       15
  7 |       14
  1 |       14
(7 rows)


real	0m0,058s
user	0m0,010s
sys	0m0,007s
```

## SQL vs Relational Algebra

* Selection (σ) = `WHERE` clause
* Projection (π) = `SELECT` specific columns
* Union (∪) = `UNION` or `OR` conditions
* Intersection (∩) = `INTERSECT` or `AND` conditions
* Difference (-) = `EXCEPT` operator
* Cartesian Product (×) = `CROSS JOIN`
* Join (⨝) = `INNER JOIN`, `LEFT JOIN`, etc.