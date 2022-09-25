-- How many pizzas were ordered?
SELECT COUNT(c.order_id) 'Number of Order'
FROM new_ctm_orders c

-- How many unique customer orders were made?
SELECT COUNT(DISTINCT c.customer_id) 
FROM new_ctm_orders c

-- How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(*) 'Successful order'
FROM `new_runners_ord`
WHERE duration != 0
GROUP BY 1;

SELECT runner_id, COUNT(*) 'Successful order'
FROM `new_runners_ord`
WHERE cancellation = ' '
GROUP BY 1;

-- How many of each type of pizza was delivered?
SELECT c.pizza_id, COUNT(*) 'No of Orders'
FROM `new_runners_ord` r
JOIN new_ctm_orders c ON r.order_id = c.order_id
WHERE duration != 0
GROUP BY 1;

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT p.pizza_id, p.pizza_name, COUNT(*) 'No of Order'
FROM `new_ctm_orders` c 
JOIN pizza_names p ON c.pizza_id = p.pizza_id
GROUP BY 1;

-- What was the maximum number of pizzas delivered in a single order?
WITH cte 
AS
    (SELECT r.order_id, COUNT(c.pizza_id) No_of_Pizza
    FROM `new_runners_ord` r 
    JOIN new_ctm_orders c ON r.order_id = c.order_id
    GROUP BY 1)
    
SELECT MAX(No_of_Pizza)
FROM cte;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id,
SUM(CASE 
        WHEN c.exclusions != ' ' OR c.extras != ' ' THEN 1  
        ELSE 0
        END) AS atleast_one_change,
SUM(CASE 
        WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1
        ELSE 0
        END) AS no_changes 
FROM new_ctm_orders AS c 
JOIN new_runners_ord AS r ON c.order_id = r.order_id 
WHERE r.duration != 0
GROUP BY c.customer_id;

-- How many pizzas were delivered that had both exclusions and extras?
SELECT c.customer_id, c.exclusions, c.extras, COUNT(c.pizza_id)
FROM new_ctm_orders AS c 
JOIN new_runners_ord AS r ON c.order_id = r.order_id 
WHERE (r.duration != 0) AND (c.exclusions != ' ' AND c.extras != ' ')
GROUP BY c.customer_id;

-- What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) hour_of_day, COUNT(order_id) Pizza_ordered
FROM new_ctm_orders
GROUP BY 1;

-- What was the volume of orders for each day of the week?
SELECT WEEKDAY(order_time) AS day_of_week, COUNT(order_id) AS volume_of_pizzas 
FROM new_ctm_orders GROUP BY 1;


                -Part B
--- B. Runner and Customer Experience
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
SUM(CASE WHEN EXTRACT(DAY FROM registration_date) < 8 THEN 1 ELSE 0 END) Week1,
SUM(CASE WHEN EXTRACT(DAY FROM registration_date) >= 8 AND EXTRACT(DAY FROM registration_date) <14 THEN 1 ELSE 0 END) Week2,
SUM(CASE WHEN EXTRACT(DAY FROM registration_date) >= 14 AND EXTRACT(DAY FROM registration_date) <21 THEN 1 ELSE 0 END) Week3,
SUM(CASE WHEN EXTRACT(DAY FROM registration_date) >= 21 THEN 1 ELSE 0 END) Week4
FROM runners;

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT tab.runner_id, ROUND(AVG(tab.total_time_in_min), 2)
FROM(
    SELECT r.runner_id,
	TIMESTAMPDIFF (hour, order_time,pickup_time ) * 60 +
    TIMESTAMPDIFF (minute, order_time,pickup_time ) + 
    TIMESTAMPDIFF (second , order_time,pickup_time ) / 60 as total_time_in_min
    FROM new_ctm_orders c 
    JOIN new_runners_ord r ON c.order_id = r.order_id
    WHERE cancellation IS NULL) tab
GROUP BY 1;



--Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT c.order_id, COUNT(pizza_id) No_of_Pizza,
TIMESTAMPDIFF (hour, order_time, pickup_time ) * 60 * 60 + 
TIMESTAMPDIFF (minute, order_time, pickup_time ) * 60 + 
TIMESTAMPDIFF (second , order_time, pickup_time ) total_time_in_sec
FROM new_ctm_orders c  
JOIN new_runners_ord r USING(order_id)
WHERE cancellation IS NULL
GROUP BY 1
ORDER BY 2 asc;

--What was the average distance travelled for each customer?
SELECT customer_id , ROUND(AVG(distance),2) avg_dist_travelled
FROM new_ctm_orders c
JOIN new_runners_ord r USING(order_id)
WHERE cancellation = ' '
GROUP BY customer_id;

--What was the difference between the longest and shortest delivery times for all orders?
SELECT
MAX(duration)- MIN(duration)  max_min_diff 
FROM new_runners_ord
WHERE cancellation = ' ';

--What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT runner_id,order_id, ROUND(AVG(distance/duration),2)* 60*60 avg_speed_km_per_hr
FROM new_runners_ord
WHERE cancellation = ' '
GROUP BY runner_id,order_id;

--What is the successful delivery percentage for each runner?
SELECT runner_id, 
ROUND(SUM(CASE WHEN cancellation = ' ' THEN 1 ELSE 0 END)/COUNT(duration),2) * 100 'successful delivery'
FROM new_runners_ord r
GROUP BY 1;