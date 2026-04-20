-- Homework 2
-- Stored Procedure: check_stock(p_id INT, p_qty INT)

-- Sample table (as given in the assignment)
CREATE TABLE IF NOT EXISTS inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

-- Drop & recreate for easy re-run
DROP PROCEDURE IF EXISTS check_stock(INT, INT);

CREATE OR REPLACE PROCEDURE check_stock(p_id INT, p_qty INT)
LANGUAGE plpgsql
AS $$
DECLARE
    current_qty INT;
BEGIN
    SELECT quantity
    INTO current_qty
    FROM inventory
    WHERE product_id = p_id;

    IF current_qty IS NULL THEN
        RAISE EXCEPTION 'Sản phẩm không tồn tại';
    END IF;

    IF current_qty < p_qty THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho';
    END IF;
END;
$$;

-- Test data (optional)
-- TRUNCATE TABLE inventory RESTART IDENTITY;
-- INSERT INTO inventory (product_name, quantity) VALUES
-- ('Product A', 10),
-- ('Product B', 2);

-- Call procedure to test
-- Trường hợp đủ hàng
-- CALL check_stock(1, 5);

-- Trường hợp không đủ hàng
-- CALL check_stock(2, 5);
