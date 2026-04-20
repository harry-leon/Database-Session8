-- Homework 5
-- Stored Procedure: update_employee_status(p_emp_id INT, OUT p_status TEXT)
-- Rules:
--   - If employee not found -> RAISE EXCEPTION 'Employee not found'
--   - salary < 5000 -> 'Junior'
--   - salary 5000..10000 -> 'Mid-level'
--   - salary > 10000 -> 'Senior'

-- Table (as given in the assignment)
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary NUMERIC(10,2),
    bonus NUMERIC(10,2) DEFAULT 0,
    status TEXT
);

-- Sample data (optional)
-- TRUNCATE TABLE employees RESTART IDENTITY;
-- INSERT INTO employees (name, department, salary) VALUES
-- ('Nguyen Van A', 'HR', 4000),
-- ('Tran Thi B', 'IT', 6000),
-- ('Le Van C', 'Finance', 10500),
-- ('Pham Thi D', 'IT', 8000),
-- ('Do Van E', 'HR', 12000);

-- Drop & recreate for easy re-run
DROP PROCEDURE IF EXISTS update_employee_status(INT);

CREATE OR REPLACE PROCEDURE update_employee_status(p_emp_id INT, OUT p_status TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_salary NUMERIC(10,2);
BEGIN
    SELECT salary
    INTO v_salary
    FROM employees
    WHERE id = p_emp_id;

    IF v_salary IS NULL THEN
        RAISE EXCEPTION 'Employee not found';
    END IF;

    p_status := CASE
        WHEN v_salary < 5000 THEN 'Junior'
        WHEN v_salary <= 10000 THEN 'Mid-level'
        ELSE 'Senior'
    END;

    UPDATE employees
    SET status = p_status
    WHERE id = p_emp_id;
END;
$$;

-- Test calls (example)
-- DO $$
-- DECLARE p_status TEXT;
-- BEGIN
--   CALL update_employee_status(1, p_status);
--   RAISE NOTICE 'Employee 1 status: %', p_status;
-- END $$;
