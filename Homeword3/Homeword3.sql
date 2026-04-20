-- Homework 3
-- Stored Procedure: adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
-- Rule by job_level:
--   Level 1 -> +5%
--   Level 2 -> +10%
--   Level 3 -> +15%

-- Sample table (as given in the assignment)
CREATE TABLE IF NOT EXISTS employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    job_level INT,
    salary NUMERIC
);

-- Drop & recreate for easy re-run
DROP PROCEDURE IF EXISTS adjust_salary(INT);

CREATE OR REPLACE PROCEDURE adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    v_job_level INT;
    v_salary NUMERIC;
    v_multiplier NUMERIC;
BEGIN
    SELECT job_level, salary
    INTO v_job_level, v_salary
    FROM employees
    WHERE emp_id = p_emp_id;

    IF v_job_level IS NULL OR v_salary IS NULL THEN
        RAISE EXCEPTION 'Nhân viên không tồn tại';
    END IF;

    v_multiplier := CASE v_job_level
        WHEN 1 THEN 1.05
        WHEN 2 THEN 1.10
        WHEN 3 THEN 1.15
        ELSE 1.00
    END;

    p_new_salary := v_salary * v_multiplier;

    UPDATE employees
    SET salary = p_new_salary
    WHERE emp_id = p_emp_id;
END;
$$;

-- Test data (optional)
-- TRUNCATE TABLE employees RESTART IDENTITY;
-- INSERT INTO employees (emp_name, job_level, salary) VALUES
-- ('A', 1, 1000),
-- ('B', 2, 2000),
-- ('C', 3, 3000);

-- Execute test
-- DO $$
-- DECLARE p_new_salary NUMERIC;
-- BEGIN
--   CALL adjust_salary(3, p_new_salary);
--   RAISE NOTICE 'New salary: %', p_new_salary;
-- END $$;
