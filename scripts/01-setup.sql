-- demo-setup.sql
-- Enable performance extensions
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_buffercache;
CREATE EXTENSION IF NOT EXISTS pg_prewarm;

-- Reset pg_stat_statements
SELECT pg_stat_statements_reset();

-- Create demo tables
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE,
    budget DECIMAL(15,2),
    location VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2),
    department_id INT REFERENCES departments(id)
);

-- Create indexes for performance demo
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department);
CREATE INDEX IF NOT EXISTS idx_employees_salary ON employees(salary);
CREATE INDEX IF NOT EXISTS idx_employees_hire_date ON employees(hire_date);
CREATE INDEX IF NOT EXISTS idx_projects_department ON projects(department_id);

-- Function to generate sample data
CREATE OR REPLACE FUNCTION generate_sample_data(num_records INT) 
RETURNS VOID AS $$
DECLARE
    depts TEXT[] := ARRAY['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'IT', 'Operations'];
    names TEXT[] := ARRAY['John', 'Jane', 'Bob', 'Alice', 'Charlie', 'Diana', 'Eve', 'Frank'];
BEGIN
    -- Insert departments
    INSERT INTO departments (dept_name, budget, location) 
    SELECT 
        dept,
        (RANDOM() * 1000000)::DECIMAL(15,2),
        CASE 
            WHEN RANDOM() < 0.5 THEN 'New York' 
            ELSE 'San Francisco' 
        END
    FROM UNNEST(depts) dept
    ON CONFLICT (dept_name) DO NOTHING;
    
    -- Insert employees
    INSERT INTO employees (name, department, salary, hire_date)
    SELECT 
        names[1 + (i % array_length(names, 1))] || ' ' || 
        names[1 + ((i + 3) % array_length(names, 1))],
        depts[1 + (i % array_length(depts, 1))],
        (RANDOM() * 150000 + 50000)::DECIMAL(10,2),
        CURRENT_DATE - INTERVAL '1 day' * FLOOR(RANDOM() * 3650)
    FROM generate_series(1, num_records) i;
    
    -- Insert projects
    INSERT INTO projects (project_name, start_date, end_date, budget, department_id)
    SELECT 
        'Project ' || i,
        CURRENT_DATE - INTERVAL '1 day' * FLOOR(RANDOM() * 365),
        CURRENT_DATE + INTERVAL '1 day' * FLOOR(RANDOM() * 365),
        (RANDOM() * 500000)::DECIMAL(15,2),
        1 + (i % (SELECT COUNT(*) FROM departments))
    FROM generate_series(1, 100) i;
END;
$$ LANGUAGE plpgsql;