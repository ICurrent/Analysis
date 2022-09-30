--Questions
--1) What is the total amount each customer spent at the restaurant?
SELECT customer_id, SUM(price)
FROM sales s
JOIN menu m USING(product_id)
GROUP BY 1;

--2) How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date) Noofday
FROM sales
GROUP BY 1


--3) What was the first item from the menu purchased by each customer?
SELECT customer_id, order_date, 
GROUP_CONCAT(DISTINCT product_name ORDER BY product_id SEPARATOR '\n') product_name
FROM `sales` s
JOIN menu m USING(product_id)
WHERE order_date = (SELECT MIN(order_date) FROM sales)
GROUP BY 1


WITH cte_order AS (
    SELECT s.customer_id, m.product_name,
    ROW_NUMBER() OVER(
        PARTITION BY s.customer_id
        ORDER BY s.order_date,
        s.product_id
    ) AS first_purchase
    FROM sales AS s JOIN menu AS m
    ON s.product_id = m.product_id
)
SELECT * from cte_order WHERE first_purchase = 1;

--4) What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_name, COUNT(*) 
FROM `sales` s
JOIN menu m USING(product_id)
GROUP BY 1
ORDER BY 1;

--5) Which item was the most popular for each customer?
SELECT customer_id, product_name
FROM (
    SELECT customer_id, product_name, COUNT(product_id) num, 
	RANK() OVER(PARTITION BY customer_id ORDER BY num DESC) chk
	FROM `sales` s
	JOIN menu m USING(product_id)
	GROUP BY 1, 2
	ORDER BY 1) TAB
WHERE chk = 1;


--6) Which item was purchased first by the customer after they became a member?
WITH member_cte 
AS (
    SELECT s.customer_id, mem.join_date, s.order_date, s.product_id,
    ROW_NUMBER() OVER(
        PARTITION BY s.customer_id
        ORDER BY s.order_date) AS order_rank
    FROM sales AS s JOIN members AS mem
    ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date
    )
    
SELECT s.customer_id, s.order_date, m.product_name
FROM member_cte AS s JOIN menu AS m 
ON s.product_id = m.product_id
WHERE order_rank = 1;


--7) Which item was purchased just before the customer became a member?
SELECT t.customer_id, t.join_date, t.order_date, t.product_name 
FROM(
    SELECT s.customer_id, mem.join_date, s.order_date, m.product_name,
    RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS order_rank
    FROM sales AS s 
 	JOIN members AS mem
    ON s.customer_id = mem.customer_id
 	JOIN menu m ON s.product_id = m.product_id
    WHERE s.order_date < mem.join_date) t
WHERE order_rank = 1;

--8)What is the total items and amount spent for each member before they became a member?
SELECT t.customer_id, t.order_date, COUNT(t.product_name) 'No_of_Products ', SUM(t.price) Total_price 
FROM(
    SELECT s.customer_id, mem.join_date, s.order_date, m.product_name, m.price,
    RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS order_rank
    FROM sales AS s 
 	JOIN members AS mem
    ON s.customer_id = mem.customer_id
 	JOIN menu m ON s.product_id = m.product_id
    WHERE s.order_date < mem.join_date) t
GROUP BY 1;

--9) If each $1 spent equates to 10 points and sushi has a 2x 
--points multiplier - how many points would each customer have?
WITH points_cte AS(
    SELECT *,
    CASE
    WHEN product_id= 1
    THEN price * 20
    ELSE price * 10
    END AS points
    FROM menu
)
SELECT s.customer_id, SUM(p.points) total_points
FROM sales s
JOIN points_cte p ON s.product_id = p.product_id
GROUP BY s.customer_id;


--10)In the first week after a customer joins the program 
--(including their join date) they earn 2x points on all items, 
--not just sushi - how many points do customer A and B have at 
--the end of January?
WITH cte 
AS(
    SELECT s.customer_id, s.order_date, m.join_date, 
   DATE_FORMAT(m.join_date, '%M') month, me.product_id, me.price 
	FROM sales s 
	JOIN menu me ON s.product_id=me.product_id
	JOIN members m ON s.customer_id = m.customer_id)
    
SELECT cte.customer_id, cte.month, 
SUM(CASE WHEN (cte.order_date >= cte.join_date) OR (cte.product_id = 1)
THEN cte.price * 20
else cte.price * 10
END) point
FROM cte
WHERE cte.month = 'January'
GROUP BY 1;


--Bonus Question

--Bonus Question
WITH cte AS(
    SELECT s.customer_id, s.order_date, mu.product_name , mu.price,
    CASE 
        WHEN s.order_date>=m.join_date THEN 'y' ELSE 'n'
        END AS membership
    FROM sales s
    LEFT JOIN members m ON s.customer_id=m.customer_id
    INNER JOIN menu mu ON mu.product_id=s.product_id),

cte1 AS(
    SELECT *, dense_rank() OVER (PARTITION BY Customer_id ,membership ORDER BY order_date ASC) rankk
    FROM cte 
)
SELECT *, 
CASE 
    WHEN membership='y' THEN rank ELSE NULL
    END AS ranking 
FROM cte1 


/*BQ1*/
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE 
    WHEN mem.join_date > s.order_date THEN 'N'
    WHEN mem.join_date <= s.order_date THEN 'Y'
    ELSE 'N'
    END AS valid_member
FROM sales AS s LEFT JOIN menu AS m ON s.product_id = m.product_id 
LEFT JOIN members AS mem
ON s.customer_id = mem.customer_id;


/*BQ2*/
WITH overall_rank_cte AS(
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE 
    WHEN mem.join_date > s.order_date THEN 'N'
    WHEN mem.join_date <= s.order_date THEN 'Y'
    ELSE 'N'
    END AS valid_member
FROM sales AS s LEFT JOIN menu AS m ON s.product_id = m.product_id 
LEFT JOIN members AS mem
ON s.customer_id = mem.customer_id
)

SELECT *,
CASE
WHEN valid_member = 'N' THEN NULL
ELSE
RANK () OVER(PARTITION BY customer_id, valid_member
ORDER BY order_date) 
END AS member_ranking
FROM overall_rank_cte;