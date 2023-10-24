/*
Database for a warehouse selling products to other companys.
Made as an assignment in the course "Databaser (databases)" with different tasks
such as showing CRUD (Create Read Update Delete).
Made by Linus Boström 2023-10-04
*/


DROP DATABASE IF EXISTS warehouse2;
CREATE DATABASE warehouse2;
USE warehouse2;

DROP TABLE IF EXISTS product;
CREATE TABLE product(
	productId INT PRIMARY KEY AUTO_INCREMENT,
	productName VARCHAR(55),
	purchasePrice DOUBLE,
	sellPrice DOUBLE,
	quantityStored DOUBLE
);
DROP TABLE IF EXISTS customer;
CREATE TABLE customer(
	customerId INT PRIMARY KEY AUTO_INCREMENT,
    companyName VARCHAR(55),
    address VARCHAR(90),
    city VARCHAR(55)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	orderId INT PRIMARY KEY AUTO_INCREMENT,
	quantity DOUBLE,
    customerId INT,
    CONSTRAINT orderCustomerKey FOREIGN KEY (customerId) 
    REFERENCES customer (customerId)
    ON UPDATE CASCADE 
    ON DELETE SET NULL
);

DROP TABLE IF EXISTS manager;
CREATE TABLE manager(
	id INT PRIMARY KEY AUTO_INCREMENT,
    managerName VARCHAR(55),
    dateOfBirth DATE,
    phoneNumber VARCHAR(20),
    managerId INT,
	CONSTRAINT managerManagerKey FOREIGN KEY (managerId)
    REFERENCES manager (id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff(
	staffId INT PRIMARY KEY AUTO_INCREMENT,
    staffName VARCHAR(55),
    dateOfBirth DATE,
    staffPhoneNumber VARCHAR(20),
    managerId INT,
    CONSTRAINT staffManagerKey FOREIGN KEY (managerId)
    REFERENCES manager (id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);



DROP TABLE IF EXISTS delivery;
CREATE TABLE delivery(
	deliveryId INT PRIMARY KEY AUTO_INCREMENT,
    shippedDate DATE,
    schedueledDate DATE,
    orderId INT,
    staffId INT,
	CONSTRAINT deliveryOrderKey FOREIGN KEY (orderId)
    REFERENCES orders (orderId)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
    CONSTRAINT deliveryStaffKey FOREIGN KEY (staffId)
    REFERENCES staff (staffId)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);
-- Making a linktable for the many-to-many relation between product and orders
DROP TABLE IF EXISTS orderToProductLink;
CREATE TABLE orderToProductLink(
	productId INT,
    orderId INT,
    PRIMARY KEY (productId,orderId),
	CONSTRAINT FOREIGN KEY orderToProductKey(productId)
    REFERENCES product (productId)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
    
	CONSTRAINT FOREIGN KEY orderToOrderKey (orderId)
    REFERENCES orders (orderId)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
-- Adding new data to the tables
INSERT INTO product (productName, purchasePrice, sellPrice, quantityStored) VALUES 
					("Spoon",3,15,300),
                    ("Fork",3,15,300),
                    ("Knife",3,15,300),
                    ("Milk",10,28,8000),
                    ("Coffee",39,49,900),
                    ("Tea",29,39,1000),
                    ("Glass",10,20,1000),
                    ("Cup",11,25,2000);
                    
INSERT INTO customer (companyName,address,city) VALUES 
					("McDonalds","Hamburgarevägen 7","BigMacstaden"),
					("Subway","Smörgåsgatan 6","Ostbyn"),
					("Arla","Mjölkvägen 1.5","Kostaden"),
					("Sia glass","Glassgatan 5","Kallstad"),
					("Microsoft","Datavägen 1","Databorg"),
					("Volvo","Bilvägen 4","Bilbyn"),
					("Saab","Bilvägen 3","Bilbyn");

INSERT INTO orders (quantity,customerId) VALUES
					(20,1),
                    (20,1),
                    (20,1),
                    (300,4),
                    (300,5),
                    (20,6),
                    (10,7),
                    (6,3);

INSERT INTO manager (managerName, dateOfBirth, phoneNumber, managerId) VALUES
					("Kalle Berg","1959-12-01","0709123456",NULL),
                    ("Kerstin Svensson","1969-10-28","0705787878",NULL),
                    ("Micke Micksson","1999-01-01","0730123123",2),
                    ("Berit Beritsson","1978-03-20","0798141414",1);

INSERT INTO staff (staffName, dateOfBirth, staffPhoneNumber, managerId) VALUES
					("Göran Svensson","1978-11-12","0703131313",3),
                    ("Ulla Svensson","1999-12-31","0705151515",3),
                    ("Frida Henriksson","2001-05-22","0730303030",3),
                    ("Theodor Samuelsson","1968-09-11","0734443444",3),
                    ("Samuel Theodorsson","2006-08-08","0732223322",3),
                    ("Donald Duck","2001-01-10","0744141424",4),
                    ("Felicia Ström","1990-02-20","0705352515",4),
                    ("Johanna Hultqvist","1998-10-20","0724151515",4),
                    ("Musse Pigg","1997-09-18","0702012032",4);

INSERT INTO delivery (shippedDate,schedueledDate, orderId, staffId) VALUES
					("2023-10-04","2023-10-04",1,1),
                    ("2023-10-04","2023-10-04",2,1),
                    ("2023-10-04","2023-10-04",3,1),
                    ("2023-10-03","2023-10-01",4,2),
                    ("2023-10-03","2023-10-01",5,2),
                    ("2023-10-02","2023-10-01",6,3),
                    (NULL,"2023-11-11",7,NULL),
                    (NULL,"2023-11-11",8,NULL);

INSERT INTO orderToProductLink (productId, orderId) VALUES
					(1,1),
                    (2,2),
                    (3,3),
                    (4,4),
                    (4,5),
                    (5,6),
                    (6,7),
                    (1,8);

-- Adding date and staff to an already existing delivery
UPDATE delivery 
SET shippedDate = "2023-10-05", staffId = 5
WHERE deliveryId = 7;

UPDATE delivery 
SET shippedDate = "2023-10-05", staffId = 5
WHERE deliveryId = 8;

-- Adding column in product 
ALTER TABLE product 
ADD COLUMN deliveryDate DATE;
-- Removing the column
ALTER TABLE product
DROP COLUMN deliveryDate;

-- Adding a table 
CREATE TABLE removeThis(
	id INT PRIMARY KEY AUTO_INCREMENT,
    something VARCHAR(20)
);

-- Removing a table
DROP TABLE removeThis;


-- inserting a new product and then removing it.
INSERT INTO product (productName, purchasePrice, sellPrice, quantityStored) VALUES ("Something",10,20,30); -- productId = 9
DELETE FROM product WHERE productId = 9;



