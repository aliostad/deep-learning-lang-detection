# Question 1
# Karl Seal has made the most rentals (45) at store 2

WITH store2_customers AS (
    SELECT rental.customer_id, rental.rental_id
    FROM rental
    JOIN customer ON rental.customer_id = customer.customer_id
    WHERE customer.store_id = 2
  ),
    best_customer AS (
    SELECT customer_id, COUNT(*)
    FROM store2_customers
    GROUP BY customer_id ORDER BY count DESC
    LIMIT 1
    )
SELECT first_name, last_name, customer.customer_id, count
FROM customer
JOIN best_customer
ON best_customer.customer_id = customer.customer_id;

#********************************************************************
WITH store2_rentals AS (
    SELECT rental.customer_id, rental.rental_id
    FROM rental
    JOIN staff ON staff.staff_id = rental.staff_id
    WHERE staff.store_id = 2
  ),
  best2_customers AS (
    SELECT store2_rentals.customer_id, COUNT(*)
    FROM store2_rentals
    JOIN customer ON store2_rentals.customer_id = customer.customer_id
    GROUP BY store2_rentals.customer_id ORDER BY count DESC
    LIMIT 1
  )
SELECT first_name, last_name, customer.customer_id, count
FROM customer
JOIN best2_customers
ON best2_customers.customer_id = customer.customer_id
