# Entity Relationship Modelling with PostgreSQL

## 📋 Overview

This module demonstrates **Entity-Relationship (ER) Modelling** concepts using practical PostgreSQL examples. You'll learn how to design database schemas, implement relationships between entities, and create a complete employee management system with related data tables.

Through hands-on examples, you'll understand:
- How to translate ER diagrams into database tables
- Different types of relationships (one-to-one, one-to-many, many-to-many)
- Foreign key constraints and referential integrity
- Normalization principles in practice

## 🚀 Environment Setup

### Start the Environment
```bash
docker-compose -f docker/02-er-modelling-docker-compose.yaml up -d
``` 

### Stop and Cleanup

```bash
docker-compose -f docker/02-er-modelling-docker-compose.yaml down -v
```

## 1. 📝 Creating the Core Entity: Employee Table

Objective: Create the primary entity table to store basic employee information.

```sql
CREATE TABLE tb_employee (
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(100),
    surname    VARCHAR(100),
    birth_date DATE,
    position   VARCHAR(100)
);
```

Docker Command:

```bash
docker exec postgres-demo psql -U demo -d demo_db -c "
CREATE TABLE tb_employee (
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(100),
    surname    VARCHAR(100),
    birth_date DATE,
    position   VARCHAR(100)
);
"
```

## 2. 📊 Populating the Employee Table

Objective: Insert sample data to work with real records.

```sql
INSERT INTO tb_employee (name, surname, birth_date, position) VALUES
('James',   'Smith',    '1985-03-15', 'Software Engineer'),
('Emily',   'Johnson',  '1990-07-22', 'Project Manager'),
('Michael', 'Williams', '1978-11-08', 'Senior Developer'),
('Sarah',   'Brown',    '1993-05-30', 'Data Analyst'),
('David',   'Jones',    '1982-09-14', 'System Administrator');
```

Docker Command:

```bash
docker exec postgres-demo psql -U demo -d demo_db -c "
INSERT INTO tb_employee (name, surname, birth_date, position) VALUES
('James',   'Smith',    '1985-03-15', 'Software Engineer'),
('Emily',   'Johnson',  '1990-07-22', 'Project Manager'),
('Michael', 'Williams', '1978-11-08', 'Senior Developer'),
('Sarah',   'Brown',    '1993-05-30', 'Data Analyst'),
('David',   'Jones',    '1982-09-14', 'System Administrator');
"
```

## 3. ✅ Verifying Data Insertion

Objective: Confirm the data has been properly inserted.

```bash
docker exec  postgres-demo psql -U demo -d demo_db -c "SELECT * FROM tb_employee;"
```

Expected Output: Should display 5 employee records with auto-generated IDs.

## 4. 🔗 Implementing One-to-Many Relationships

Objective: Create related tables to demonstrate one-to-many relationships.

```sql
CREATE TABLE tb_employee_address (
    id          BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    street      VARCHAR(200),
    city        VARCHAR(100),
    state       VARCHAR(100),
    postal_code VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES tb_employee(id)
);

CREATE TABLE tb_employee_contacts (
    id          BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    type        VARCHAR(50),
    value       VARCHAR(100),
    FOREIGN KEY (employee_id) REFERENCES tb_employee(id)
);
```

Docker Command:

```bash
docker exec  postgres-demo psql -U demo -d demo_db -c "
CREATE TABLE tb_employee_address (
    id          BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    street      VARCHAR(200),
    city        VARCHAR(100),
    state       VARCHAR(100),
    postal_code VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES tb_employee(id)
);

CREATE TABLE tb_employee_contacts (
    id          BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    type        VARCHAR(50),
    value       VARCHAR(100),
    FOREIGN KEY (employee_id) REFERENCES tb_employee(id)
);
"
```

## 5. 📍 Adding Related Data

Objective: Populate the related tables with sample data to demonstrate relationships.

```sql
INSERT INTO tb_employee_address (employee_id, street, city, state, postal_code) VALUES
(1, '123 Main Street', 'New York', 'NY', '10001'),
(1, '456 Park Avenue', 'New York', 'NY', '10022'), -- James has 2 addresses
(2, '789 Oak Lane', 'Boston', 'MA', '02108'),
(3, '321 Pine Road', 'Chicago', 'IL', '60601'),
(4, '654 Maple Drive', 'Austin', 'TX', '73301'),
(5, '987 Cedar Blvd', 'Seattle', 'WA', '98101');

-- Insert contact information for employees
INSERT INTO tb_employee_contacts (employee_id, type, value) VALUES
-- James Smith (ID: 1)
(1, 'email', 'james.smith@company.com'),
(1, 'phone', '+1-212-555-1234'),
(1, 'mobile', '+1-917-555-1234'),

-- Emily Johnson (ID: 2)
(2, 'email', 'emily.johnson@company.com'),
(2, 'phone', '+1-617-555-5678'),
(2, 'linkedin', 'linkedin.com/in/emilyjohnson'),

-- Michael Williams (ID: 3)
(3, 'email', 'michael.williams@company.com'),
(3, 'phone', '+1-312-555-9012'),
(3, 'github', 'github.com/mwilliams'),

-- Sarah Brown (ID: 4)
(4, 'email', 'sarah.brown@company.com'),
(4, 'phone', '+1-512-555-3456'),
(4, 'skype', 'sarah.brown_work'),

-- David Jones (ID: 5)
(5, 'email', 'david.jones@company.com'),
(5, 'phone', '+1-206-555-7890'),
(5, 'emergency', '+1-206-555-7891');
```

Docker Command:

```bash
docker exec  postgres-demo psql -U demo -d demo_db -c "
INSERT INTO tb_employee_address (employee_id, street, city, state, postal_code) VALUES
(1, '123 Main Street', 'New York', 'NY', '10001'),
(1, '456 Park Avenue', 'New York', 'NY', '10022'), -- James has 2 addresses
(2, '789 Oak Lane', 'Boston', 'MA', '02108'),
(3, '321 Pine Road', 'Chicago', 'IL', '60601'),
(4, '654 Maple Drive', 'Austin', 'TX', '73301'),
(5, '987 Cedar Blvd', 'Seattle', 'WA', '98101');

-- Insert contact information for employees
INSERT INTO tb_employee_contacts (employee_id, type, value) VALUES
-- James Smith (ID: 1)
(1, 'email', 'james.smith@company.com'),
(1, 'phone', '+1-212-555-1234'),
(1, 'mobile', '+1-917-555-1234'),

-- Emily Johnson (ID: 2)
(2, 'email', 'emily.johnson@company.com'),
(2, 'phone', '+1-617-555-5678'),
(2, 'linkedin', 'linkedin.com/in/emilyjohnson'),

-- Michael Williams (ID: 3)
(3, 'email', 'michael.williams@company.com'),
(3, 'phone', '+1-312-555-9012'),
(3, 'github', 'github.com/mwilliams'),

-- Sarah Brown (ID: 4)
(4, 'email', 'sarah.brown@company.com'),
(4, 'phone', '+1-512-555-3456'),
(4, 'skype', 'sarah.brown_work'),

-- David Jones (ID: 5)
(5, 'email', 'david.jones@company.com'),
(5, 'phone', '+1-206-555-7890'),
(5, 'emergency', '+1-206-555-7891');
"
```

### 6. 🤝 Implementing One-to-One Relationship

```sql
CREATE TABLE tb_employee_previous_experience (
    id         BIGSERIAL PRIMARY KEY,
    company    VARCHAR(100),
    position   VARCHAR(100),
    start_date DATE,
    end_date   DATE
);

ALTER TABLE tb_employee
ADD previous_experience_id BIGINT,
ADD FOREIGN KEY (previous_experience_id) REFERENCES tb_employee_previous_experience(id),
ADD UNIQUE (previous_experience_id);
```

```bash
docker exec postgres-demo psql -U demo -d demo_db -c "
CREATE TABLE tb_employee_previous_experience (
    id         BIGSERIAL PRIMARY KEY,
    company    VARCHAR(100),
    position   VARCHAR(100),
    start_date DATE,
    end_date   DATE
);

ALTER TABLE tb_employee
ADD previous_experience_id BIGINT,
ADD FOREIGN KEY (previous_experience_id) REFERENCES tb_employee_previous_experience(id),
ADD UNIQUE (previous_experience_id);
"
```

### 7. 🧪 Testing the Relationships


#### 7.1 Query All Employee Data with Joins

```sql
SELECT 
    e.id,
    e.name || ' ' || e.surname AS full_name,
    e.position,
    COUNT(DISTINCT a.id) AS address_count,
    COUNT(DISTINCT c.id) AS contact_count
FROM tb_employee e
LEFT JOIN tb_employee_address a ON e.id = a.employee_id
LEFT JOIN tb_employee_contacts c ON e.id = c.employee_id
GROUP BY e.id, e.name, e.surname, e.position
ORDER BY e.id;
```

Docker Command: 

```bash
docker exec postgres-demo psql -U demo -d demo_db -c "
SELECT 
    e.id,
    e.name || ' ' || e.surname AS full_name,
    e.position,
    COUNT(DISTINCT a.id) AS address_count,
    COUNT(DISTINCT c.id) AS contact_count
FROM tb_employee e
LEFT JOIN tb_employee_address a ON e.id = a.employee_id
LEFT JOIN tb_employee_contacts c ON e.id = c.employee_id
GROUP BY e.id, e.name, e.surname, e.position
ORDER BY e.id;
"
```


#### 7.2 Check Foreign Key Constraints

```sql
-- Try to insert invalid data (should fail)
INSERT INTO tb_employee_address (employee_id, street, city, state, postal_code) 
VALUES (999, 'Invalid Street', 'Nowhere', 'XX', '00000');
```

```bash
docker exec postgres-demo psql -U demo -d demo_db -c "
-- Try to insert invalid data (should fail)
INSERT INTO tb_employee_address (employee_id, street, city, state, postal_code) 
VALUES (999, 'Invalid Street', 'Nowhere', 'XX', '00000');
"
```


## 📊 Relationship Summary
| Table                           | Relationship Type | Description                                              |
|---------------------------------|:-----------------:|----------------------------------------------------------|
| tb_employee                     | Core Entity       | Primary employee record                                  |
| tb_employee_address             | One-to-Many       | Each employee can have multiple addresses                |
| tb_employee_contacts            | One-to-Many       | Each employee can have multiple contact methods          |
| tb_employee_previous_experience | One-to-One        | Each employee has at most one previous experience record |