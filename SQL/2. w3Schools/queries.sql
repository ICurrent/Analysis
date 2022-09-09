/*Get all the Products a particular customer purchases and Total Qty purchased */

SELECT ord.OrderID, od.CustomerID, c.CustomerName, 
		GROUP_CONCAT(ord.ProductID,' - ', p.ProductName SEPARATOR '\n') ProductDetail, 
        SUM(ord.Quantity) TotalQty
FROM order_details ord
JOIN products p ON ord.ProductID = p.ProductID
JOIN orders od ON ord.OrderID = od.OrderID
JOIN customers c ON od.CustomerID = c.CustomerID
GROUP BY 1, 2, 3
ORDER BY 2;
        /*or*/
SELECT ord.OrderID, c.CustomerName, 
	GROUP_CONCAT(p.ProductName,' - ', ord.Quantity) ProductPerQty,
    SUM(ord.Quantity) TotalQty
FROM order_details ord
JOIN products p ON ord.ProductID = p.ProductID
JOIN orders od ON ord.OrderID = od.OrderID
JOIN customers c ON od.CustomerID = c.CustomerID
GROUP BY 1
ORDER BY 2;


/*Get all the Products each customer purchases and Total Qty of each products purchased */
SELECT od.CustomerID, c.CustomerName, GROUP_CONCAT(ord.ProductID,' - ', p.ProductName SEPARATOR '\n') ProductDetails,
	   GROUP_CONCAT(ord.Quantity SEPARATOR '\n') ProductQty
FROM order_details ord
JOIN products p ON ord.ProductID = p.ProductID
JOIN orders od ON ord.OrderID = od.OrderID
JOIN customers c ON od.CustomerID = c.CustomerID
GROUP BY 1, 2;


/*Get all the OrderID and show the Products and TotalQTY per order of 'Ernst Handel'*/
WITH tab 
AS 
(
    SELECT ord.OrderID, c.CustomerName, 
	GROUP_CONCAT(p.ProductName,' - ', ord.Quantity) ProductPerQty,
    SUM(ord.Quantity) TotalQty
FROM order_details ord
JOIN products p ON ord.ProductID = p.ProductID
JOIN orders od ON ord.OrderID = od.OrderID
JOIN customers c ON od.CustomerID = c.CustomerID
GROUP BY 1
ORDER BY 2
)

SELECT *
FROM tab
WHERE CustomerName = 'Ernst Handel';



/*1. Select customer name together with each order the customer made*/
SELECT c.CustomerName, GROUP_CONCAT(o.OrderID SEPARATOR '\n') OrderID
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY 1;

/*or*/
SELECT CustomerName, OrderID
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID;

/*2. Select order id together with name of employee who handled the order*/
SELECT o.OrderID, CONCAT(e.FirstName, ' ', e.LastName) FullName
FROM orders o
JOIN employees e  ON o.EmployeeID = e.EmployeeID;

/*3. Select customers who did not placed any order yet*/
SELECT c.ContactName, o.OrderID
FROM customers c 
LEFT JOIN orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

/*4. Select order id together with the name of products*/
SELECT o.OrderID, p.ProductName
FROM order_details o
JOIN products p ON o.ProductID = p.ProductID;


/*5. Select products that no one bought*/
SELECT p.ProductName
FROM products p
LEFT JOIN order_details o ON p.ProductID = o.ProductID
WHERE o.ProductID IS NULL;

/*6. Select customer together with the products that he bought*/
SELECT c.CustomerName, GROUP_CONCAT(ProductName SEPARATOR '\n') Products
FROM customers c 
JOIN orders d ON c.CustomerID = d.CustomerID
JOIN order_details o ON d.OrderID = o.OrderID
JOIN products p  ON p.ProductID = o.ProductID
GROUP BY 1;


/*7. Select product names together with the name of corresponding category*/
SELECT c.CategoryID, GROUP_CONCAT(p.ProductName SEPARATOR '\n')
FROM `products` p 
JOIN categories c ON p.CategoryID = c.CategoryID
GROUP BY 1
ORDER BY 1;


/*8. Select orders together with the name of the shipping company*/
SELECT s.ShipperID, s.ShipperName, GROUP_CONCAT(o.OrderID SEPARATOR ', ') OrderID
FROM shippers s 
JOIN orders o ON s.ShipperID = o.ShipperID
GROUP BY 1;

/*9. Select customers with id greater than 50 together with each order they made*/
SELECT c.CustomerID, c.CustomerName, GROUP_CONCAT(o.OrderID, ':', o.ProductID, ' - ', p.ProductName SEPARATOR '\n') Orders
FROM customers c 
JOIN orders d ON c.CustomerID = d.CustomerID
JOIN order_details o ON d.OrderID = o.OrderID
JOIN products p  ON p.ProductID = o.ProductID
GROUP BY 1
HAVING c.CustomerID > 50;
/*or*/
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
GROUP BY 1
Having c.CustomerID > 50;


/*10. Select employees together with orders with order id greater than 10400*/
SELECT e.LastName, GROUP_CONCAT(o.OrderID SEPARATOR ', ') Orders
FROM employees e
JOIN orders o
ON e.EmployeeID = o.EmployeeID
WHERE o.OrderID> 10400
GROUP BY 1;
/*or*/
SELECT DISTINCT e.LastName
FROM orders o
JOIN employees e
ON o.EmployeeID = e.EmployeeID
WHERE o.OrderID > 10400;


/*1. Select the most expensive product*/
SELECT p.ProductName, p.Price
FROM `products` p
WHERE p.Price = (SELECT MAX(Price) FROM products)


/*2. Select the second most expensive product*/
SELECT p.ProductName, p.Price
FROM `products` p
ORDER BY n DESC
LIMIT n-1 OFFSET n-1
/*or*/
SELECT p.ProductName, p.Price
FROM `products` p
ORDER BY 2 DESC
LIMIT 1, 1
/*or*/
SELECT *
FROM(
    SELECT p.ProductName, p.Price
    FROM `products` p
    ORDER BY 2 DESC
    LIMIT 2) tab
ORDER BY 2
LIMIT 1;
/*or*/
WITH
	tabl1 AS (SELECT ProductID,ProductName,Price
		FROM products
		ORDER BY Price DESC
		LIMIT 2),
	tabl2 AS (SELECT ProductID,ProductName,Price
		FROM products
		ORDER BY Price DESC
		LIMIT 1)
        
SELECT tabl1.ProductID,tabl1.ProductName,tabl1.Price
FROM tabl1
LEFT JOIN tabl2 ON tabl1.ProductID = tabl2.ProductID
WHERE tabl2.ProductID IS NULL;

/*or*/
SELECT *
FROM(
    SELECT p.ProductID, p.ProductName, p.Price, RANK() OVER(ORDER BY p.Price DESC) Ranking
    FROM `products` p
    ORDER BY 3) tab
WHERE Ranking = 2;


/*3. Select name and price of each product, sort the result by price in decreasing order*/
SELECT p.ProductName, p.Price
FROM products p
ORDER BY 2 DESC;


/*4. Select 5 most expensive products*/
SELECT p.ProductName, p.Price
FROM products p
ORDER BY 2 DESC
LIMIT 5;


/*5. Select 5 most expensive products without the most expensive (in final 4 products)*/
SELECT p.ProductName, p.Price
FROM products p
ORDER BY 2 DESC
LIMIT 4 OFFSET 1;


/*6. Select name of the cheapest product (only name) without using LIMIT and OFFSET*/
SELECT p.ProductName, p.Price
FROM products p
WHERE p.Price = (SELECT MIN(Price) FROM products)


/*7. Select name of the cheapest product (only name) using subquery*/
SELECT ProductName
FROM products
WHERE Price IN (
	SELECT MIN(Price) FROM products
);

/*8. Select number of employees with LastName that starts with 'D'*/
SELECT COUNT(*)
FROM employees e
WHERE e.LastName LIKE 'D%';
/*or*/
SELECT EmployeeID, LastName, FirstName
FROM employees
WHERE LastName LIKE 'D%';

/* BONUS : same question for Customer this time */
SELECT c.ContactName
FROM customers c
WHERE c.ContactName LIKE 'D%';

/*9. Select customer name together with the number of orders made by the corresponding customer 
sort the result by number of orders in decreasing order*/
SELECT c.CustomerName, c.ContactName, COUNT(o.OrderID) 'No of Orders'
FROM customers c 
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY 1
ORDER BY 3 DESC;


/*10. Add up the price of all products*/
SELECT SUM(Price)
FROM products;

/*11. Select orderID together with the total price of  that Order, order the result by total price of order in increasing order*/
SELECT o.OrderID, SUM(p.Price * ord.Quantity) 'Total Price'
FROM orders o 
JOIN order_details ord ON o.OrderID = ord.OrderID
JOIN products p ON ord.ProductID = p.ProductID
GROUP BY 1
ORDER BY 2;

SELECT od.OrderID, SUM((od.Quantity * p.Price)) AS TotalValueOfOrder
FROM order_details od
JOIN products p ON p.ProductID = od.ProductID
GROUP BY 1
ORDER BY 2 ASC;


/*12. Select customer who spend the most money*/
SELECT c.CustomerName, c.ContactName, SUM(p.Price * ord.Quantity) 'Total Price'
FROM orders o 
JOIN order_details ord ON o.OrderID = ord.OrderID
JOIN products p ON ord.ProductID = p.ProductID
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1;

/*13. Select customer who spend the most money and lives in Canada*/
SELECT c.CustomerName, c.ContactName, c.Country, SUM(p.Price * ord.Quantity) 'Total Price'
FROM orders o 
JOIN order_details ord ON o.OrderID = ord.OrderID
JOIN products p ON ord.ProductID = p.ProductID
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY 1
HAVING c.Country = 'Canada'
ORDER BY 3 DESC
LIMIT 1;

/*14. Select customer who spend the second most money*/
SELECT c.CustomerName, c.ContactName, SUM(p.Price * ord.Quantity) 'Total Price'
FROM orders o 
JOIN order_details ord ON o.OrderID = ord.OrderID
JOIN products p ON ord.ProductID = p.ProductID
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1, 1;


/*15. Select shipper together with the total price of proceed orders*/
SELECT s.ShipperID, s.ShipperName, SUM(p.Price * ord.Quantity)
FROM orders o
JOIN shippers s ON o.ShipperID = s.ShipperID
JOIN order_details ord ON o.OrderID = ord.OrderID
JOIN products p ON ord.ProductID = p.ProductID
GROUP BY 1
ORDER BY 3 DESC;




