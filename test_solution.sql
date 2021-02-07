-- Question 1
SELECT * FROM Orders
WHERE restaurantstatus = 'restaurant_accepted'

-- Question 2
SELECT COUNT(*) FROM Orders
WHERE restaurantstatus = 'restaurant_accepted'
GROUP BY CONVERT(date, createdat)

-- Quesiton 3
SELECT COUNT(DISTINCT customerid) FROM Orders
WHERE restaurantstatus = 'restaurant_accepted'
GROUP BY CONVERT(date, createdat), customeraddressprovince

-- Question 4
SELECT customerid, COUNT(*) [Number of orders] FROM Orders
WHERE restaurantname LIKE 'Nando''s%'
AND createdat BETWEEN CONVERT(date, '20191021') AND CONVERT(date, '20191028')
GROUP BY customerid

-- Question 5
SELECT o.customerid, o.orderid, CONVERT(date, o.createdat) [order date], o.restaurantname
FROM Orders o
INNER JOIN Order_rank r ON o.orderid = r.OrderId
WHERE o.restaurantname LIKE 'Nando''s%'
AND r.Rank = 1

-- Question 6
SELECT CustomerId, order_date [OrderDate], OrderId, restaurantname [RestaurantName] FROM (
SELECT r.*, o.restaurantname, LEAD(o.restaurantname) OVER (PARTITION BY r.customerid ORDER BY r.rank) [next_order], CONVERT(date, o.createdat) [order_date] FROM Orders o
INNER JOIN Order_rank r ON o.orderid = r.OrderId
WHERE o.restaurantname LIKE 'Nando''s%') AS t1
WHERE next_order IS NOT NULL
UNION
SELECT CustomerId, order_date [OrderDate], OrderId, restaurantname [RestaurantName]  FROM (
SELECT r.*, o.restaurantname, LAG(o.restaurantname) OVER (PARTITION BY r.customerid ORDER BY r.rank) [prev_order], CONVERT(date, o.createdat) [order_date] FROM Orders o
INNER JOIN Order_rank r ON o.orderid = r.OrderId
WHERE o.restaurantname LIKE 'Nando''s%') AS t2
WHERE prev_order IS NOT NULL