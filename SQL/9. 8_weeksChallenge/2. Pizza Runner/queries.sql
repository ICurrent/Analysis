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


                --Part B
-- B. Runner and Customer Experience
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)


--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?


--Is there any relationship between the number of pizzas and how long the order takes to prepare?


--What was the average distance travelled for each customer?


--What was the difference between the longest and shortest delivery times for all orders?


--What was the average speed for each runner for each delivery and do you notice any trend for these values?


--What is the successful delivery percentage for each runner?