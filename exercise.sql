-- Question 1. Create a Stored Procedure that will insert a new film into the film table with the
-- following arguments: title, description, release_year, language_id, rental_duration,
-- rental_rate, length, replace_cost, rating


CREATE OR REPLACE PROCEDURE add_new_film(title VARCHAR, description TEXT, release_year YEAR, language_id SMALLINT, rental_duration SMALLINT, rental_rate NUMERIC(4,2), length SMALLINT, replacement_cost NUMERIC(5,2), rating MPAA_RATING)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO film(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
	VALUES(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating);
END;
$$;

CALL add_new_film('Cocaine Bear', 'It is what it purports to be', 2023, 1, 7, 4.99, 112, 14.99, 'R');

-- Question 2. Create a Stored Function that will take in a category_id and return the number of
--films in that category

CREATE OR REPLACE FUNCTION count_films_in_category(cat_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE category_count INTEGER;
BEGIN 
	SELECT COUNT(film_id) INTO category_count
	FROM film_category
	WHERE category_id = cat_id;
	RETURN category_count;
END;
$$;

SELECT count_films_in_category(4);

