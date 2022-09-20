--Cleaning 1
/*Fixing the null, ' ', and NULL in the customer_orders tables*/
CREATE TABLE new_ctm_orders
AS
SELECT c.order_id, c.customer_id, c.pizza_id,
CASE 
	WHEN c.exclusions LIKE 'null' THEN NULL 
    WHEN c.exclusions = ' ' THEN NULL
    ELSE c.exclusions END exclusions,
CASE
	WHEN c.extras LIKE 'null' THEN NULL 
    WHEN c.extras = ' ' THEN NULL
    ELSE c.extras END extras,
c.order_time
FROM customer_orders c;


CREATE TABLE new_runners_ord
AS
SELECT order_id, runner_id,
	CASE
    	WHEN pickup_time LIKE 'null' THEN NULL
        ELSE pickup_time
        END pickup_time,
    CASE
    	WHEN distance LIKE 'null' THEN NULL
        WHEN distance LIKE '%km' THEN TRIM('km' from distance)
        ELSE distance
        END distance,
    CASE
    	WHEN duration LIKE 'null' THEN NULL
        WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
        WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
        WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
        ELSE duration
        END duration,
    CASE
    	WHEN cancellation LIKE 'null' THEN NULL
        WHEN cancellation IS NULL THEN NULL
        WHEN cancellation = ' ' THEN NULL
        ELSE cancellation
        END cancellation
         
FROM runner_orders;



ALTER TABLE new_runners_ord
MODIFY COLUMN pickup_time DATETIME;

ALTER table new_runner_orders 
MODIFY COLUMN duration INT;

ALTER table new_runner_orders 
MODIFY COLUMN distance FLOAT;



/* Changing Data Type of TEXT to VARCHAR */

ALTER table pizza_names 
MODIFY COLUMN pizza_name VARCHAR(30);