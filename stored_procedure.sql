--Stored Procedure

SELECT *
FROM customer
WHERE loyalty_member = TRUE;

--ALTER TABLE customer
--ADD COLUMN loyalty_member;

--Reset all customer loyalty to False
UPDATE customer 
SET loyalty_member = FALSE;

-- Create a Procedure that will set anyone who has spent >= $100 to loyalty_member = TRUE 
-- Query to get the customers who have spent >= $100
SELECT customer_id, SUM(amount)
FROM payment 
GROUP BY customer_id 
HAVING SUM(amount) >= 100;

-- Update the customer table to have those customers who have spent >= as loyalty members
UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id 
	FROM payment 
	GROUP BY customer_id 
	HAVING SUM(amount) >= 100
);

--Put that into a stored procedure
CREATE OR REPLACE PROCEDURE update_loyalty_status(loyalty_min NUMERIC(5,2) DEFAULT 100.00)
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE customer 
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		SELECT customer_id 
		FROM payment 
		GROUP BY customer_id 
		HAVING SUM(amount) >= loyalty_min
	);
END;
$$;

--EXECUTE the prcedure with CALL 
CALL update_loyalty_status();

SELECT *
FROM customer 
WHERE loyalty_member = TRUE;

--Find customer who is close to the miniumum
SELECT customer_id, SUM(amount)
FROM payment 
GROUP BY customer_id 
HAVING SUM(amount) BETWEEN 95 AND 100;


--Add a new payment of 4.99 with that customer to push them over the threshhold
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES(554, 1, 1, 4.99, '2023-03-16 11:26:40');

SELECT * 
FROM customer 
WHERE customer_id = 554;

--Create a procedure to add new rows to a table
SELECT *
FROM actor
ORDER BY actor_id DESC;

INSERT INTO actor(first_name, last_name, last_update)
VALUES('Eren','Enou',NOW());

CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR, last_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES(first_name,last_name,NOW());
END;
$$;

CALL add_actor('Tom','Cruise');

DROP PROCEDURE IF EXISTS add_actor;