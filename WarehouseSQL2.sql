/* 
Second file on the assignment. 
This file contains queries related to the tasks in the assignment.
Made by Linus Boström 2023-10-04
*/
USE Warehouse2;

-- Making some SELECT queries to show data. 

-- Showing all staff with last name "Svensson"
SELECT * FROM staff
WHERE staffName LIKE '%Svensson%';

-- Showing name of staff and the name of their manager.
SELECT s.staffName AS "Name of staff", m.managerName AS "Name of manager"
FROM staff s
JOIN manager m
ON s.managerId = m.id;

-- Showing what product a customer have ordered and how many.
SELECT p.productName AS "Product", c.companyName AS "Company", o.quantity AS "Quantity"
FROM orderToProductLink otp
JOIN product p
ON otp.productId = p.productId
JOIN orders o
ON otp.orderId = o.orderId
JOIN customer c
ON o.customerId = c.customerId;

-- Showing how much profit the warehouse made from each sale, and ordered by most profit.
SELECT p.productName AS "Product", c.companyName AS "Company", o.quantity AS "Quantity", o.quantity*(p.sellPrice-p.purchasePrice) AS Profit
FROM orderToProductLink otp
JOIN product p
ON otp.productId = p.productId
JOIN orders o
ON otp.orderId = o.orderId
JOIN customer c
ON o.customerId = c.customerId
ORDER BY Profit DESC;

-- Showing the managers that have a manager and their names.
SELECT m1.managerName AS "Manager", m2.managerName AS "Their manager"
FROM manager m1
JOIN manager m2
ON m1.managerId = m2.id;

-- Showing all products wich has a selling price higher than the selling price of cups as a subquery. 
SELECT * FROM product
WHERE sellPrice > (SELECT sellPrice 
                    FROM product
                    WHERE productId = 8);


-- Creating view for a previous select query showing the many-to-many relationship between products and orders.
-- This view shows product name, the company that ordered and how many they ordered.
CREATE VIEW productCompanyQuantitySales AS
	SELECT p.productName AS "Product", c.companyName AS "Company", o.quantity AS "Quantity"
	FROM orderToProductLink otp
	JOIN product p
	ON otp.productId = p.productId
	JOIN orders o
	ON otp.orderId = o.orderId
	JOIN customer c
	ON o.customerId = c.customerId;

-- Now this can be accesed with a more simple select query.
SELECT * FROM productCompanyQuantitySales;
-- Another example 
SELECT * FROM productCompanyQuantitySales
WHERE product = "Milk";


-- Making a stored procedure that shows an orders status in delivery and the company that place the order.
DELIMITER $$
CREATE PROCEDURE getDeliveryAndCustomer(
	idOrder INT
)
BEGIN
	SELECT d.orderId AS "Order",d.shippedDate AS "Shipped Date", d.schedueledDate AS "Estimated delivery", c.companyName AS "Company"
    FROM orders o
    JOIN customer c
    ON o.customerId = c.customerId
    JOIN delivery d
    ON d.orderId = o.orderId
    WHERE o.orderId = idOrder;
END$$
DELIMITER ;

CALL getDeliveryAndCustomer(3)


-- Making a trigger that reduces the stored quantity of a product when a order is placed.
-- The trigger assumes that frontend check if stored quantity >= ordered quantity before the order is placed.

DELIMITER $$
CREATE TRIGGER changeStoredQuantity
	AFTER INSERT ON orderToProductLink
	FOR EACH ROW
BEGIN
	UPDATE product
    SET quantityStored = quantityStored - COALESCE((SELECT o.quantity FROM orders o WHERE NEW.orderID = o.orderID),0)
    WHERE product.productId = NEW.productId;
END$$
DELIMITER ;

INSERT INTO orders (quantity,customerId) VALUES (5,4); -- => orderId = 9

SELECT * FROM product; -- Knife with productId 3 have 300 quantity stored

INSERT INTO orderToProductLink (productId,orderId) VALUES (3,9);

SELECT * FROM product; -- Now knife have 295 left

