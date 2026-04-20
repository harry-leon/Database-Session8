-- Homework 1
-- Stored Procedure: calculate_order_total(order_id_input INT, OUT total NUMERIC)

-- Sample table (as given in the assignment)
CREATE TABLE IF NOT EXISTS order_detail (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    unit_price NUMERIC
);

-- Drop & recreate for easy re-run
DROP PROCEDURE IF EXISTS calculate_order_total(INT);

CREATE OR REPLACE PROCEDURE calculate_order_total(order_id_input INT, OUT total NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    INTO total
    FROM order_detail
    WHERE order_id = order_id_input;
END;
$$;

-- Call procedure to test (returns a result row with column "total")
-- CALL calculate_order_total(1, NULL);
