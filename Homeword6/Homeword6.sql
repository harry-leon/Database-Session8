-- Homework 6
-- Stored Procedure: calculate_bonus(p_emp_id INT, p_percent NUMERIC, OUT p_bonus NUMERIC)
-- Rules:
--   - If employee not found -> RAISE EXCEPTION 'Employee not found'
--   - If p_percent <= 0 -> p_bonus = 0 (no calculation)
--   - Else p_bonus = salary * p_percent / 100 and save to employees.bonus

-- Table (compatible with Homework 5)
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary NUMERIC(10,2),
    bonus NUMERIC(10,2) DEFAULT 0,
    status TEXT
);

-- Drop & recreate for easy re-run
DROP PROCEDURE IF EXISTS calculate_bonus(INT, NUMERIC);

CREATE OR REPLACE PROCEDURE calculate_bonus(p_emp_id INT, p_percent NUMERIC, OUT p_bonus NUMERIC)
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

    IF COALESCE(p_percent, 0) <= 0 THEN
        p_bonus := 0;
    ELSE
        p_bonus := v_salary * p_percent / 100.0;
    END IF;

    UPDATE employees
    SET bonus = p_bonus
    WHERE id = p_emp_id;
END;
$$;

-- Test calls (example)
-- DO $$
-- DECLARE p_bonus NUMERIC;
-- BEGIN
--   CALL calculate_bonus(1, 10, p_bonus);
--   RAISE NOTICE 'Employee 1 bonus: %', p_bonus;
--
--   CALL calculate_bonus(1, 0, p_bonus);
--   RAISE NOTICE 'Employee 1 bonus (0%%): %', p_bonus;
-- END $$;
