--Cleaning 1
/*Fixing the null, ' ', and NULL in the customer_orders tables*/
CREATE TABLE new_ctm_orders
AS
SELECT * 
FROM customer_orders;
UPDATE new_ctm_orders SET exclusions = ' '
WHERE exclusions IS NULL OR exclusions = 'null';
UPDATE new_ctm_orders SET extras = ' '
WHERE extras IS NULL OR extras = 'null';


CREATE TABLE new_runners_ord
AS
SELECT order_id, runner_id,
	CASE
    	WHEN pickup_time LIKE 'null' THEN ' '
        ELSE pickup_time
        END pickup_time,
    CASE
    	WHEN distance LIKE 'null' THEN ' '
        WHEN distance LIKE '%km' THEN TRIM('km' from distance)
        ELSE distance
        END distance,
    CASE
    	WHEN duration LIKE 'null' THEN ' '
        WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
        WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
        WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
        ELSE duration
        END duration,
    CASE
    	WHEN cancellation LIKE 'null' THEN ' '
        WHEN cancellation IS NULL THEN ' '
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