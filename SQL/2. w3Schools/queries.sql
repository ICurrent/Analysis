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