-- ============================================
-- Employee Data Generation Script
-- Generates 10,000 realistic employee records
-- ============================================

-- Enable timing to see performance
\timing on

-- ============================================
-- 1. Create a function to generate random data
-- ============================================
CREATE OR REPLACE FUNCTION generate_random_employee_data(num_records INTEGER DEFAULT 10000)
RETURNS VOID AS $$
DECLARE
    i INTEGER;
    first_names TEXT[] := ARRAY[
        'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 
        'William', 'Elizabeth', 'David', 'Susan', 'Richard', 'Jessica', 'Joseph', 'Sarah', 
        'Thomas', 'Karen', 'Charles', 'Nancy', 'Christopher', 'Lisa', 'Daniel', 'Margaret', 
        'Matthew', 'Betty', 'Anthony', 'Sandra', 'Donald', 'Ashley', 'Mark', 'Dorothy', 
        'Paul', 'Emily', 'Steven', 'Donna', 'Andrew', 'Michelle', 'Kenneth', 'Carol', 
        'Joshua', 'Amanda', 'Kevin', 'Melissa', 'Brian', 'Deborah', 'George', 'Stephanie', 
        'Edward', 'Rebecca', 'Ronald', 'Laura', 'Timothy', 'Helen', 'Jason', 'Sharon', 
        'Jeffrey', 'Cynthia', 'Ryan', 'Kathleen', 'Jacob', 'Amy', 'Gary', 'Shirley', 
        'Nicholas', 'Angela', 'Eric', 'Anna', 'Stephen', 'Ruth', 'Jonathan', 'Brenda'
    ];
    
    last_names TEXT[] := ARRAY[
        'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 
        'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 
        'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 
        'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker', 
        'Young', 'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores', 
        'Green', 'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell', 
        'Carter', 'Roberts'
    ];
    
    positions TEXT[] := ARRAY[
        'Software Engineer', 'Senior Developer', 'DevOps Engineer', 'Data Scientist',
        'Data Analyst', 'Machine Learning Engineer', 'Systems Administrator', 
        'Network Engineer', 'Database Administrator', 'Security Analyst',
        'Project Manager', 'Product Manager', 'Scrum Master', 'Business Analyst',
        'UX Designer', 'UI Developer', 'Frontend Developer', 'Backend Developer',
        'Full Stack Developer', 'QA Engineer', 'Test Automation Engineer',
        'Technical Lead', 'Architect', 'CTO', 'Engineering Manager',
        'Sales Engineer', 'Support Engineer', 'IT Consultant', 'Cloud Engineer',
        'Mobile Developer', 'Web Developer', 'Embedded Engineer'
    ];
    
    start_date DATE := '1990-01-01';
    end_date DATE := '2005-12-31';
    random_date DATE;
    random_salary DECIMAL(10,2);
BEGIN
    RAISE NOTICE 'Starting generation of % employee records...', num_records;
    
    -- Insert employees in batches for better performance
    FOR i IN 1..num_records LOOP
        -- Generate random date between 1990-01-01 and 2005-12-31
        random_date := start_date + (random() * (end_date - start_date))::INTEGER;
        
        -- Generate random salary between 40,000 and 250,000
        random_salary := 40000 + (random() * 210000);
        
        INSERT INTO tb_employee (
            name, 
            surname, 
            birth_date, 
            position
        ) VALUES (
            first_names[1 + (random() * (array_length(first_names, 1) - 1))::INTEGER],
            last_names[1 + (random() * (array_length(last_names, 1) - 1))::INTEGER],
            random_date,
            positions[1 + (random() * (array_length(positions, 1) - 1))::INTEGER]
        );
        
        -- Show progress every 1000 records
        IF i % 1000 = 0 THEN
            RAISE NOTICE 'Inserted % records...', i;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Successfully inserted % employee records!', num_records;
    
    -- Create statistics for better query planning
    ANALYZE tb_employee;
    
    RAISE NOTICE 'Table statistics updated.';
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 2. Create function to generate related data
-- ============================================
CREATE OR REPLACE FUNCTION generate_employee_related_data()
RETURNS VOID AS $$
DECLARE
    employee_record RECORD;
    address_count INTEGER;
    contact_count INTEGER;
    emp_id BIGINT;
BEGIN
    RAISE NOTICE 'Starting generation of related data (addresses and contacts)...';
    
    -- Generate addresses and contacts for each employee
    FOR employee_record IN SELECT id FROM tb_employee ORDER BY id LOOP
        emp_id := employee_record.id;
        
        -- Generate 1-2 addresses per employee (70% have 1, 30% have 2)
        IF random() < 0.7 THEN
            address_count := 1;
        ELSE
            address_count := 2;
        END IF;
        
        -- Insert addresses
        FOR i IN 1..address_count LOOP
            INSERT INTO tb_employee_address (
                employee_id,
                street,
                city,
                state,
                postal_code
            ) VALUES (
                emp_id,
                CASE 
                    WHEN random() < 0.3 THEN (100 + (random() * 900)::INTEGER) || ' Main Street'
                    WHEN random() < 0.5 THEN (100 + (random() * 900)::INTEGER) || ' Oak Avenue'
                    ELSE (100 + (random() * 900)::INTEGER) || ' Maple Drive'
                END,
                CASE 
                    WHEN random() < 0.2 THEN 'New York'
                    WHEN random() < 0.4 THEN 'Los Angeles'
                    WHEN random() < 0.6 THEN 'Chicago'
                    WHEN random() < 0.8 THEN 'Houston'
                    ELSE 'Phoenix'
                END,
                CASE 
                    WHEN random() < 0.2 THEN 'NY'
                    WHEN random() < 0.4 THEN 'CA'
                    WHEN random() < 0.6 THEN 'IL'
                    WHEN random() < 0.8 THEN 'TX'
                    ELSE 'AZ'
                END,
                LPAD((10000 + (random() * 90000)::INTEGER)::TEXT, 5, '0')
            );
        END LOOP;
        
        -- Generate 2-4 contacts per employee
        contact_count := 2 + (random() * 2)::INTEGER;
        
        -- Insert contacts
        INSERT INTO tb_employee_contacts (
            employee_id,
            type,
            value
        ) VALUES 
        -- Everyone gets email
        (
            emp_id,
            'email',
            'employee' || emp_id || '@company.com'
        ),
        -- Everyone gets phone
        (
            emp_id,
            'phone',
            '+1-' || LPAD((200 + (random() * 800)::INTEGER)::TEXT, 3, '0') || 
            '-555-' || LPAD((1000 + (random() * 9000)::INTEGER)::TEXT, 4, '0')
        );
        
        -- Additional random contacts
        FOR i IN 1..(contact_count - 2) LOOP
            INSERT INTO tb_employee_contacts (
                employee_id,
                type,
                value
            ) VALUES (
                emp_id,
                CASE (random() * 3)::INTEGER
                    WHEN 0 THEN 'mobile'
                    WHEN 1 THEN 'linkedin'
                    WHEN 2 THEN 'github'
                    ELSE 'skype'
                END,
                CASE 
                    WHEN random() < 0.25 THEN '+1-' || LPAD((200 + (random() * 800)::INTEGER)::TEXT, 3, '0') || '-555-' || LPAD((1000 + (random() * 9000)::INTEGER)::TEXT, 4, '0')
                    WHEN random() < 0.5 THEN 'linkedin.com/in/employee' || emp_id
                    WHEN random() < 0.75 THEN 'github.com/emp' || emp_id
                    ELSE 'skype:employee' || emp_id
                END
            );
        END LOOP;
        
        -- Show progress every 1000 employees
        IF emp_id % 1000 = 0 THEN
            RAISE NOTICE 'Processed % employees...', emp_id;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Successfully generated related data for all employees!';
    
    -- Update statistics
    ANALYZE tb_employee_address;
    ANALYZE tb_employee_contacts;
    
    RAISE NOTICE 'Related tables statistics updated.';
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 3. Create function to verify data generation
-- ============================================
CREATE OR REPLACE FUNCTION verify_data_generation()
RETURNS TABLE (
    tbl_name TEXT,
    rec_count BIGINT,
    avg_per_emp DECIMAL(10,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        'tb_employee'::TEXT as tbl_name,
        COUNT(*) as rec_count,
        1.00 as avg_per_emp
    FROM tb_employee
    
    UNION ALL
    
    SELECT 
        'tb_employee_address'::TEXT as tbl_name,
        COUNT(*) as rec_count,
        ROUND(COUNT(*)::DECIMAL / (SELECT COUNT(*) FROM tb_employee), 2) as avg_per_emp
    FROM tb_employee_address
    
    UNION ALL
    
    SELECT 
        'tb_employee_contacts'::TEXT as tbl_name,
        COUNT(*) as rec_count,
        ROUND(COUNT(*)::DECIMAL / (SELECT COUNT(*) FROM tb_employee), 2) as avg_per_emp
    FROM tb_employee_contacts;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 4. Main execution function
-- ============================================
CREATE OR REPLACE FUNCTION generate_complete_employee_dataset(num_employees INTEGER DEFAULT 10000)
RETURNS VOID AS $$
DECLARE
    v_table_name TEXT;
    v_record_count BIGINT;
    v_avg_per_employee DECIMAL(10,2);
BEGIN
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'EMPLOYEE DATA GENERATION STARTED';
    RAISE NOTICE 'Target: % employees', num_employees;
    RAISE NOTICE '==============================================';
    
    -- Step 1: Generate employees
    PERFORM generate_random_employee_data(num_employees);
    
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Employee generation completed!';
    RAISE NOTICE '==============================================';
    
    -- Step 2: Generate related data
    PERFORM generate_employee_related_data();
    
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Related data generation completed!';
    RAISE NOTICE '==============================================';
    
    -- Step 3: Verify results
    RAISE NOTICE 'Verification results:';
    RAISE NOTICE '---------------------';
    
    FOR v_table_name, v_record_count, v_avg_per_employee IN 
        SELECT * FROM verify_data_generation() 
    LOOP
        RAISE NOTICE '%: % records (avg: % per employee)', 
            v_table_name, v_record_count, v_avg_per_employee;
    END LOOP;
    
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'DATA GENERATION COMPLETED SUCCESSFULLY!';
    RAISE NOTICE '==============================================';
END;
$$ LANGUAGE plpgsql;