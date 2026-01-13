-- =============================================
-- SQL Tutorial Database Initialization Script
-- PostgreSQL Version
-- =============================================

-- Drop existing databases if they exist (for tutorial reset)
DROP DATABASE IF EXISTS company_db;
DROP DATABASE IF EXISTS university_db;
DROP DATABASE IF EXISTS ecommerce_db;
DROP DATABASE IF EXISTS library_db;

-- =============================================
-- 1. COMPANY DATABASE
-- =============================================
CREATE DATABASE company_db;

\c company_db

-- Employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2) CHECK (salary >= 0),
    manager_id INT REFERENCES employees(employee_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    budget DECIMAL(15,2),
    manager_id INT REFERENCES employees(employee_id)
);

-- Projects table
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(200) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2),
    status VARCHAR(20) CHECK (status IN ('Planning', 'Active', 'On Hold', 'Completed', 'Cancelled'))
);

-- Employee projects (junction table)
CREATE TABLE employee_projects (
    employee_id INT REFERENCES employees(employee_id),
    project_id INT REFERENCES projects(project_id),
    role VARCHAR(50),
    hours_worked DECIMAL(5,2),
    PRIMARY KEY (employee_id, project_id)
);

-- Insert departments
INSERT INTO departments (department_name, location, budget) VALUES
('Engineering', 'New York', 1500000.00),
('Marketing', 'San Francisco', 800000.00),
('Sales', 'Chicago', 1200000.00),
('Human Resources', 'Boston', 500000.00),
('Finance', 'Austin', 900000.00),
('Operations', 'Seattle', 1100000.00);

-- Insert employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, department_id, salary, manager_id) VALUES
('John', 'Smith', 'john.smith@company.com', '555-0101', '2018-03-15', 'CEO', NULL, 250000.00, NULL),
('Sarah', 'Johnson', 'sarah.j@company.com', '555-0102', '2019-06-01', 'CTO', 1, 200000.00, 1),
('Michael', 'Chen', 'michael.c@company.com', '555-0103', '2020-01-15', 'Engineering Manager', 1, 150000.00, 2),
('Emily', 'Williams', 'emily.w@company.com', '555-0104', '2021-03-22', 'Senior Software Engineer', 1, 130000.00, 3),
('David', 'Brown', 'david.b@company.com', '555-0105', '2022-08-10', 'Software Engineer', 1, 95000.00, 3),
('Jessica', 'Davis', 'jessica.d@company.com', '555-0106', '2019-11-05', 'Marketing Director', 2, 140000.00, 1),
('Robert', 'Miller', 'robert.m@company.com', '555-0107', '2020-09-18', 'Sales Manager', 3, 120000.00, 1),
('Jennifer', 'Wilson', 'jennifer.w@company.com', '555-0108', '2021-07-30', 'HR Manager', 4, 110000.00, 1),
('William', 'Moore', 'william.m@company.com', '555-0109', '2022-02-14', 'Financial Analyst', 5, 85000.00, 1),
('Lisa', 'Taylor', 'lisa.t@company.com', '555-0110', '2023-05-01', 'Operations Coordinator', 6, 65000.00, 1),
('James', 'Anderson', 'james.a@company.com', '555-0111', '2020-04-12', 'DevOps Engineer', 1, 115000.00, 3),
('Maria', 'Thomas', 'maria.t@company.com', '555-0112', '2021-08-19', 'Software Engineer', 1, 98000.00, 3),
('Charles', 'Jackson', 'charles.j@company.com', '555-0113', '2022-11-03', 'Junior Developer', 1, 75000.00, 3),
('Patricia', 'White', 'patricia.w@company.com', '555-0114', '2020-12-07', 'Marketing Specialist', 2, 72000.00, 6),
('Christopher', 'Harris', 'christopher.h@company.com', '555-0115', '2023-01-25', 'Sales Representative', 3, 68000.00, 7);

-- Insert projects
INSERT INTO projects (project_name, start_date, end_date, budget, status) VALUES
('Website Redesign', '2023-01-15', '2023-06-30', 50000.00, 'Completed'),
('Mobile App Development', '2023-03-01', '2023-12-15', 150000.00, 'Active'),
('CRM Implementation', '2023-02-10', '2023-09-30', 120000.00, 'Active'),
('Marketing Campaign Q4', '2023-10-01', '2023-12-31', 75000.00, 'Planning'),
('Data Migration', '2023-05-20', '2023-11-30', 90000.00, 'On Hold'),
('Employee Training Portal', '2023-04-05', '2023-08-15', 40000.00, 'Completed');

-- Assign employees to projects
INSERT INTO employee_projects (employee_id, project_id, role, hours_worked) VALUES
(3, 1, 'Project Manager', 120.5),
(4, 1, 'Lead Developer', 180.0),
(5, 1, 'Frontend Developer', 150.0),
(3, 2, 'Technical Lead', 95.0),
(4, 2, 'Backend Developer', 220.5),
(5, 2, 'Mobile Developer', 195.5),
(11, 2, 'DevOps Engineer', 85.0),
(7, 3, 'Implementation Lead', 135.0),
(15, 3, 'Support', 75.0),
(6, 4, 'Campaign Manager', 40.0),
(14, 4, 'Content Creator', 60.0),
(8, 5, 'HR Lead', 25.0),
(10, 5, 'Coordinator', 45.0);

-- Update departments with managers
UPDATE departments SET manager_id = 3 WHERE department_id = 1;
UPDATE departments SET manager_id = 6 WHERE department_id = 2;
UPDATE departments SET manager_id = 7 WHERE department_id = 3;
UPDATE departments SET manager_id = 8 WHERE department_id = 4;

-- =============================================
-- 2. UNIVERSITY DATABASE
-- =============================================
\c postgres
CREATE DATABASE university_db;

\c university_db

-- Students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    enrollment_date DATE NOT NULL,
    major VARCHAR(100),
    gpa DECIMAL(3,2) CHECK (gpa >= 0 AND gpa <= 4.0),
    credits_earned INT DEFAULT 0
);

-- Courses table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    department VARCHAR(100),
    description TEXT
);

-- Professors table
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(100),
    hire_date DATE,
    office_location VARCHAR(50)
);

-- Enrollments table
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id),
    professor_id INT REFERENCES professors(professor_id),
    semester VARCHAR(20),
    enrollment_date DATE,
    grade VARCHAR(2),
    UNIQUE(student_id, course_id, semester)
);

-- Insert students
INSERT INTO students (first_name, last_name, email, date_of_birth, enrollment_date, major, gpa, credits_earned) VALUES
('Alice', 'Johnson', 'alice.j@university.edu', '2002-05-15', '2021-09-01', 'Computer Science', 3.85, 75),
('Bob', 'Smith', 'bob.s@university.edu', '2003-02-28', '2022-09-01', 'Mathematics', 3.42, 45),
('Carol', 'Williams', 'carol.w@university.edu', '2001-11-10', '2020-09-01', 'Biology', 3.67, 105),
('David', 'Brown', 'david.b@university.edu', '2002-08-22', '2021-09-01', 'Physics', 3.21, 70),
('Eva', 'Davis', 'eva.d@university.edu', '2003-04-05', '2022-09-01', 'Chemistry', 3.89, 48),
('Frank', 'Miller', 'frank.m@university.edu', '2000-12-30', '2019-09-01', 'Engineering', 3.55, 130),
('Grace', 'Wilson', 'grace.w@university.edu', '2002-07-18', '2021-09-01', 'Economics', 3.76, 72),
('Henry', 'Moore', 'henry.m@university.edu', '2003-01-25', '2022-09-01', 'Business', 3.33, 42),
('Ivy', 'Taylor', 'ivy.t@university.edu', '2001-03-14', '2020-09-01', 'Psychology', 3.91, 98),
('Jack', 'Anderson', 'jack.a@university.edu', '2002-09-09', '2021-09-01', 'History', 3.44, 68);

-- Insert professors
INSERT INTO professors (first_name, last_name, email, department, hire_date, office_location) VALUES
('Dr. Robert', 'Johnson', 'r.johnson@university.edu', 'Computer Science', '2015-08-01', 'CS-301'),
('Dr. Maria', 'Garcia', 'm.garcia@university.edu', 'Mathematics', '2018-01-15', 'MATH-205'),
('Dr. James', 'Wilson', 'j.wilson@university.edu', 'Biology', '2010-09-01', 'BIO-102'),
('Dr. Sarah', 'Chen', 's.chen@university.edu', 'Physics', '2016-03-20', 'PHYS-150'),
('Dr. Thomas', 'White', 't.white@university.edu', 'Chemistry', '2019-07-01', 'CHEM-220'),
('Dr. Lisa', 'Martinez', 'l.martinez@university.edu', 'Engineering', '2012-11-01', 'ENG-310');

-- Insert courses
INSERT INTO courses (course_code, course_name, credits, department, description) VALUES
('CS101', 'Introduction to Programming', 3, 'Computer Science', 'Fundamentals of programming using Python'),
('CS201', 'Data Structures', 4, 'Computer Science', 'Advanced data structures and algorithms'),
('CS301', 'Database Systems', 3, 'Computer Science', 'Introduction to database design and SQL'),
('MATH101', 'Calculus I', 4, 'Mathematics', 'Differential calculus'),
('MATH201', 'Linear Algebra', 3, 'Mathematics', 'Vector spaces and linear transformations'),
('BIO101', 'General Biology', 4, 'Biology', 'Introduction to biological principles'),
('PHYS101', 'Physics I', 4, 'Physics', 'Mechanics and thermodynamics'),
('CHEM101', 'General Chemistry', 4, 'Chemistry', 'Fundamental chemical principles'),
('ENG101', 'Introduction to Engineering', 3, 'Engineering', 'Overview of engineering disciplines'),
('ECON101', 'Principles of Economics', 3, 'Economics', 'Micro and macroeconomic principles');

-- Insert enrollments (with some variation)
INSERT INTO enrollments (student_id, course_id, professor_id, semester, enrollment_date, grade) VALUES
(1, 1, 1, 'Fall 2023', '2023-09-05', 'A'),
(1, 2, 1, 'Spring 2023', '2023-01-15', 'A-'),
(1, 3, 1, 'Fall 2023', '2023-09-05', 'B+'),
(2, 4, 2, 'Fall 2023', '2023-09-05', 'B'),
(2, 5, 2, 'Spring 2023', '2023-01-15', 'C+'),
(3, 6, 3, 'Fall 2023', '2023-09-05', 'A'),
(3, 1, 1, 'Spring 2023', '2023-01-15', 'B+'),
(4, 7, 4, 'Fall 2023', '2023-09-05', 'B-'),
(5, 8, 5, 'Fall 2023', '2023-09-05', 'A'),
(6, 9, 6, 'Fall 2023', '2023-09-05', 'A-'),
(6, 1, 1, 'Spring 2023', '2023-01-15', 'B'),
(7, 10, NULL, 'Fall 2023', '2023-09-05', NULL),
(8, 1, 1, 'Fall 2023', '2023-09-05', 'C+'),
(9, 6, 3, 'Fall 2023', '2023-09-05', 'A-'),
(10, 4, 2, 'Fall 2023', '2023-09-05', 'B+');

-- =============================================
-- 3. E-COMMERCE DATABASE
-- =============================================
\c postgres
CREATE DATABASE ecommerce_db;

\c ecommerce_db

-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    registration_date DATE DEFAULT CURRENT_DATE,
    total_spent DECIMAL(10,2) DEFAULT 0
);

-- Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10,2) CHECK (price >= 0),
    cost DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    supplier VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0),
    shipping_address TEXT
);

-- Order items table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(10,2) CHECK (unit_price >= 0),
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- Insert customers
INSERT INTO customers (first_name, last_name, email, phone, address, city, state, zip_code, registration_date, total_spent) VALUES
('John', 'Doe', 'john.doe@email.com', '555-0201', '123 Main St', 'New York', 'NY', '10001', '2023-01-15', 1250.75),
('Jane', 'Smith', 'jane.smith@email.com', '555-0202', '456 Oak Ave', 'Los Angeles', 'CA', '90001', '2023-02-20', 890.50),
('Mike', 'Johnson', 'mike.j@email.com', '555-0203', '789 Pine Rd', 'Chicago', 'IL', '60601', '2023-03-10', 1540.25),
('Sarah', 'Williams', 'sarah.w@email.com', '555-0204', '321 Elm St', 'Houston', 'TX', '77001', '2023-04-05', 720.00),
('David', 'Brown', 'david.b@email.com', '555-0205', '654 Maple Dr', 'Phoenix', 'AZ', '85001', '2023-05-12', 1830.80),
('Lisa', 'Davis', 'lisa.d@email.com', '555-0206', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', '2023-06-18', 640.30),
('Tom', 'Wilson', 'tom.w@email.com', '555-0207', '147 Birch Ct', 'San Antonio', 'TX', '78201', '2023-07-22', 950.45),
('Emily', 'Taylor', 'emily.t@email.com', '555-0208', '258 Spruce Way', 'San Diego', 'CA', '92101', '2023-08-30', 1100.60);

-- Insert products
INSERT INTO products (product_name, category, price, cost, stock_quantity, supplier) VALUES
('Wireless Headphones', 'Electronics', 129.99, 65.00, 150, 'TechSupplier Inc.'),
('Smartphone Case', 'Accessories', 24.99, 8.50, 300, 'CaseMasters'),
('Bluetooth Speaker', 'Electronics', 89.99, 45.00, 200, 'AudioTech'),
('Laptop Stand', 'Office Supplies', 39.99, 15.00, 180, 'OfficeGear Co.'),
('USB-C Cable', 'Accessories', 19.99, 6.00, 500, 'CableWorld'),
('Desk Lamp', 'Home Goods', 34.99, 12.00, 120, 'HomeEssentials'),
('Coffee Mug', 'Kitchen', 16.99, 4.50, 400, 'KitchenWare'),
('Notebook Set', 'Stationery', 29.99, 10.00, 250, 'WriteRight'),
('Backpack', 'Accessories', 79.99, 35.00, 100, 'BagCompany'),
('Fitness Tracker', 'Electronics', 149.99, 80.00, 80, 'FitTech');

-- Insert orders
INSERT INTO orders (customer_id, order_date, status, total_amount, shipping_address) VALUES
(1, '2023-10-01 09:30:00', 'Delivered', 259.98, '123 Main St, New York, NY 10001'),
(2, '2023-10-02 14:15:00', 'Shipped', 134.98, '456 Oak Ave, Los Angeles, CA 90001'),
(3, '2023-10-03 11:00:00', 'Processing', 349.97, '789 Pine Rd, Chicago, IL 60601'),
(1, '2023-10-05 16:45:00', 'Delivered', 89.99, '123 Main St, New York, NY 10001'),
(4, '2023-10-06 10:20:00', 'Pending', 64.98, '321 Elm St, Houston, TX 77001'),
(5, '2023-10-07 13:10:00', 'Shipped', 209.97, '654 Maple Dr, Phoenix, AZ 85001'),
(6, '2023-10-08 15:30:00', 'Processing', 104.99, '987 Cedar Ln, Philadelphia, PA 19101'),
(7, '2023-10-09 08:45:00', 'Delivered', 149.99, '147 Birch Ct, San Antonio, TX 78201');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 129.99),  -- 2 Wireless Headphones
(2, 3, 1, 89.99),   -- 1 Bluetooth Speaker
(2, 5, 1, 19.99),   -- 1 USB-C Cable
(2, 8, 1, 24.99),   -- 1 Smartphone Case (corrected from 29.99)
(3, 10, 1, 149.99), -- 1 Fitness Tracker
(3, 4, 2, 39.99),   -- 2 Laptop Stands
(3, 6, 1, 34.99),   -- 1 Desk Lamp
(3, 7, 1, 16.99),   -- 1 Coffee Mug
(4, 3, 1, 89.99),   -- 1 Bluetooth Speaker
(5, 5, 2, 19.99),   -- 2 USB-C Cables
(5, 7, 1, 16.99),   -- 1 Coffee Mug
(5, 9, 1, 79.99),   -- 1 Backpack (corrected price)
(6, 1, 1, 129.99),  -- 1 Wireless Headphones
(6, 4, 2, 39.99),   -- 2 Laptop Stands
(7, 2, 1, 24.99),   -- 1 Smartphone Case
(7, 8, 1, 29.99),   -- 1 Notebook Set
(7, 5, 2, 19.99),   -- 2 USB-C Cables
(8, 10, 1, 149.99); -- 1 Fitness Tracker

-- =============================================
-- 4. LIBRARY DATABASE
-- =============================================
\c postgres
CREATE DATABASE library_db;

\c library_db

-- Books table
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE,
    title VARCHAR(300) NOT NULL,
    author VARCHAR(200) NOT NULL,
    genre VARCHAR(100),
    published_year INT,
    publisher VARCHAR(200),
    pages INT,
    language VARCHAR(50),
    copies_available INT DEFAULT 1 CHECK (copies_available >= 0)
);

-- Members table
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    membership_date DATE DEFAULT CURRENT_DATE,
    membership_type VARCHAR(20) CHECK (membership_type IN ('Basic', 'Premium', 'Student', 'Senior')),
    active BOOLEAN DEFAULT TRUE
);

-- Loans table
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    member_id INT REFERENCES members(member_id),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    late_fee DECIMAL(5,2) DEFAULT 0 CHECK (late_fee >= 0),
    CHECK (due_date >= loan_date),
    CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- Insert books
INSERT INTO books (isbn, title, author, genre, published_year, publisher, pages, language, copies_available) VALUES
('978-0451524935', '1984', 'George Orwell', 'Dystopian', 1949, 'Secker & Warburg', 328, 'English', 5),
('978-0061120084', 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 'J.B. Lippincott & Co.', 281, 'English', 3),
('978-0743273565', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 'Charles Scribner''s Sons', 180, 'English', 4),
('978-0141439518', 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 'T. Egerton', 279, 'English', 6),
('978-0547928227', 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 'George Allen & Unwin', 310, 'English', 2),
('978-0439023481', 'The Hunger Games', 'Suzanne Collins', 'Young Adult', 2008, 'Scholastic Press', 374, 'English', 7),
('978-1400033416', 'The Kite Runner', 'Khaled Hosseini', 'Historical Fiction', 2003, 'Riverhead Books', 371, 'English', 4),
('978-0316015844', 'Twilight', 'Stephenie Meyer', 'Fantasy', 2005, 'Little, Brown and Company', 498, 'English', 8),
('978-0553380163', 'A Brief History of Time', 'Stephen Hawking', 'Science', 1988, 'Bantam Books', 212, 'English', 3),
('978-0679720201', 'Invisible Man', 'Ralph Ellison', 'Fiction', 1952, 'Random House', 581, 'English', 2),
('978-0140283334', 'Lord of the Flies', 'William Golding', 'Fiction', 1954, 'Faber and Faber', 224, 'English', 5),
('978-0060850524', 'Brave New World', 'Aldous Huxley', 'Dystopian', 1932, 'Chatto & Windus', 268, 'English', 4);

-- Insert members
INSERT INTO members (first_name, last_name, email, phone, membership_date, membership_type, active) VALUES
('Alice', 'Johnson', 'alice.j@email.com', '555-0301', '2022-01-10', 'Premium', TRUE),
('Bob', 'Smith', 'bob.s@email.com', '555-0302', '2022-03-15', 'Basic', TRUE),
('Carol', 'Williams', 'carol.w@email.com', '555-0303', '2023-02-20', 'Student', TRUE),
('David', 'Brown', 'david.b@email.com', '555-0304', '2021-11-05', 'Premium', TRUE),
('Eva', 'Davis', 'eva.d@email.com', '555-0305', '2023-05-12', 'Senior', TRUE),
('Frank', 'Miller', 'frank.m@email.com', '555-0306', '2022-07-18', 'Basic', FALSE),
('Grace', 'Wilson', 'grace.w@email.com', '555-0307', '2023-01-25', 'Student', TRUE),
('Henry', 'Taylor', 'henry.t@email.com', '555-0308', '2022-09-30', 'Premium', TRUE);

-- Insert loans
INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, late_fee) VALUES
(1, 1, '2023-09-01', '2023-09-15', '2023-09-14', 0),
(2, 2, '2023-09-05', '2023-09-19', '2023-09-25', 3.00),
(3, 3, '2023-09-10', '2023-09-24', NULL, 0),
(4, 1, '2023-09-15', '2023-09-29', '2023-09-28', 0),
(5, 4, '2023-09-12', '2023-09-26', NULL, 0),
(6, 5, '2023-09-03', '2023-09-17', '2023-09-17', 0),
(7, 6, '2023-08-20', '2023-09-03', '2023-09-10', 3.50),
(8, 7, '2023-09-18', '2023-10-02', NULL, 0),
(9, 8, '2023-09-08', '2023-09-22', '2023-09-20', 0),
(10, 2, '2023-09-14', '2023-09-28', NULL, 0);

-- Update copies_available based on active loans
UPDATE books 
SET copies_available = copies_available - 1 
WHERE book_id IN (
    SELECT book_id FROM loans WHERE return_date IS NULL
);

-- =============================================
-- CREATE SOME VIEWS FOR TUTORIAL EXERCISES
-- =============================================
\c company_db

-- View for employee directory
CREATE VIEW employee_directory AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    e.email,
    e.job_title,
    d.department_name,
    e.hire_date,
    e.salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- View for active projects
CREATE VIEW active_projects AS
SELECT 
    p.project_name,
    p.start_date,
    p.end_date,
    p.budget,
    p.status,
    COUNT(ep.employee_id) AS team_size
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
WHERE p.status = 'Active'
GROUP BY p.project_id;

\c university_db

-- View for student performance
CREATE VIEW student_performance AS
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.major,
    s.gpa,
    COUNT(e.enrollment_id) AS courses_taken,
    AVG(CASE 
        WHEN e.grade = 'A' THEN 4.0
        WHEN e.grade = 'A-' THEN 3.7
        WHEN e.grade = 'B+' THEN 3.3
        WHEN e.grade = 'B' THEN 3.0
        WHEN e.grade = 'B-' THEN 2.7
        WHEN e.grade = 'C+' THEN 2.3
        WHEN e.grade = 'C' THEN 2.0
        WHEN e.grade = 'C-' THEN 1.7
        WHEN e.grade = 'D+' THEN 1.3
        WHEN e.grade = 'D' THEN 1.0
        ELSE 0
    END) AS avg_grade_points
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

\c ecommerce_db

-- View for customer orders summary
CREATE VIEW customer_orders_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

\c library_db

-- View for overdue books
CREATE VIEW overdue_books AS
SELECT 
    b.title,
    b.author,
    m.first_name || ' ' || m.last_name AS borrower_name,
    m.email,
    l.loan_date,
    l.due_date,
    l.late_fee,
    CURRENT_DATE - l.due_date AS days_overdue
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL 
AND l.due_date < CURRENT_DATE;

-- =============================================
-- CREATE INDEXES FOR PERFORMANCE
-- =============================================
\c company_db
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_manager ON employees(manager_id);
CREATE INDEX idx_employee_projects_emp ON employee_projects(employee_id);
CREATE INDEX idx_employee_projects_proj ON employee_projects(project_id);

\c university_db
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_students_major ON students(major);

\c ecommerce_db
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_products_category ON products(category);

\c library_db
CREATE INDEX idx_loans_member ON loans(member_id);
CREATE INDEX idx_loans_due_date ON loans(due_date) WHERE return_date IS NULL;
CREATE INDEX idx_books_genre ON books(genre);

-- =============================================
-- SWITCH BACK TO DEFAULT DATABASE
-- =============================================
\c postgres

-- =============================================
-- PRINT SUMMARY
-- =============================================
DO $$
BEGIN
    RAISE NOTICE '=============================================';
    RAISE NOTICE 'DATABASES CREATED SUCCESSFULLY!';
    RAISE NOTICE '=============================================';
    RAISE NOTICE '1. company_db      - Company management system';
    RAISE NOTICE '2. university_db   - University course system';
    RAISE NOTICE '3. ecommerce_db    - Online shopping system';
    RAISE NOTICE '4. library_db      - Library management system';
    RAISE NOTICE '=============================================';
    RAISE NOTICE 'Each database contains:';
    RAISE NOTICE '- Multiple related tables';
    RAISE NOTICE '- Sample data for queries';
    RAISE NOTICE '- Indexes for performance';
    RAISE NOTICE '- Views for common queries';
    RAISE NOTICE '=============================================';
    RAISE NOTICE 'Connect to any database using: \c database_name';
    RAISE NOTICE '=============================================';
END $$;