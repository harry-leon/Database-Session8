-- Homework 4
-- Stored Procedure: calculate_discount(p_id INT, OUT p_final_price NUMERIC)
-- Requirements:
--   - p_final_price = price - (price * discount_percent / 100)
--   - If discount_percent > 50, cap at 50
--   - Update products.price to the discounted price

-- Sample table (as given in the assignment)
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC,
    discount_percent INT
);

-- Drop & recreate for easy re-run
DROP PROCEDURE IF EXISTS calculate_discount(INT);

CREATE OR REPLACE PROCEDURE calculate_discount(p_id INT, OUT p_final_price NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC;
    v_discount_percent INT;
    v_applied_discount INT;
BEGIN
    SELECT price, discount_percent
    INTO v_price, v_discount_percent
    FROM products
    WHERE id = p_id;

    IF v_price IS NULL THEN
        RAISE EXCEPTION 'Sản phẩm không tồn tại';
    END IF;

    v_applied_discount := LEAST(COALESCE(v_discount_percent, 0), 50);

    p_final_price := v_price - (v_price * v_applied_discount / 100.0);

    UPDATE products
    SET price = p_final_price
    WHERE id = p_id;
END;
$$;

-- Test data (optional)
-- TRUNCATE TABLE products RESTART IDENTITY;
-- INSERT INTO products (name, price, discount_percent) VALUES
-- ('P1', 100, 10),
-- ('P2', 200, 60);

-- Call procedure to test
-- DO $$
-- DECLARE p_final_price NUMERIC;
-- BEGIN
--   CALL calculate_discount(2, p_final_price);
--   RAISE NOTICE 'Final price: %', p_final_price;
-- END $$;
