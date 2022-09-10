-- How many pizzas were ordered?
SELECT COUNT(c.order_id) 'Number of Order'
FROM customer_orders c

-- How many unique customer orders were made?
SELECT COUNT(DISTINCT c.customer_id) 
FROM customer_orders c

-- How many successful orders were delivered by each runner?


-- How many of each type of pizza was delivered?


-- How many Vegetarian and Meatlovers were ordered by each customer?


-- What was the maximum number of pizzas delivered in a single order?


-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?


-- How many pizzas were delivered that had both exclusions and extras?

-- What was the total volume of pizzas ordered for each hour of the day?


-- What was the volume of orders for each day of the week?
