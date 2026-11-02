/*
EXPERIMENT 07: Creation of Views, Sequences, Indexes and Savepoints

AIM:
To create and use database views, implement automatic sequential identifiers,
create and inspect indexes, and control transactions using SAVEPOINT,
ROLLBACK and COMMIT in MySQL.
*/

CREATE DATABASE IF NOT EXISTS WarehouseDB;
USE WarehouseDB;

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(60) NOT NULL,
    Category VARCHAR(30) NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    Stock_Qty INT NOT NULL,
    Warehouse VARCHAR(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1001;

INSERT INTO Product
(Product_Name,Category,Unit_Price,Stock_Qty,Warehouse)
VALUES
('Keyboard','Electronics',800,40,'Chennai'),
('Mouse','Electronics',450,12,'Chennai'),
('Office Chair','Furniture',4500,8,'Bengaluru'),
('Desk','Furniture',7200,15,'Chennai'),
('Notebook','Stationery',60,100,'Hyderabad'),
('Pen Pack','Stationery',120,25,'Hyderabad'),
('Monitor','Electronics',12500,6,'Bengaluru'),
('Printer','Electronics',9500,4,'Chennai');

-- Create a product view
CREATE VIEW vw_product_catalog AS
SELECT Product_ID,Product_Name,Category,Unit_Price
FROM Product;

-- Retrieve data from the view
SELECT * FROM vw_product_catalog
ORDER BY Product_ID;

-- Create a low-stock view
CREATE VIEW vw_low_stock AS
SELECT Product_ID,Product_Name,Stock_Qty
FROM Product
WHERE Stock_Qty < 10;

-- Display low-stock products
SELECT * FROM vw_low_stock
ORDER BY Product_ID;

-- Replace a view definition
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT Product_ID,Product_Name,Category,Stock_Qty
FROM Product
WHERE Stock_Qty <= 12;

-- Generate the next automatic ID
INSERT INTO Product
(Product_Name,Category,Unit_Price,Stock_Qty,Warehouse)
VALUES ('Webcam','Electronics',2200,18,'Chennai');

SELECT LAST_INSERT_ID() AS New_Product_ID;

-- Create an index
CREATE INDEX idx_product_category
ON Product(Category);

-- Inspect indexes
SHOW INDEX FROM Product;

-- Inspect an indexed query plan
EXPLAIN SELECT * FROM Product
WHERE Category='Electronics';

-- Create and use a savepoint
START TRANSACTION;

UPDATE Product SET Stock_Qty=Stock_Qty-5
WHERE Product_ID=1001;

SAVEPOINT sp_after_keyboard;

UPDATE Product SET Stock_Qty=Stock_Qty-3
WHERE Product_ID=1002;

SELECT Product_ID,Stock_Qty FROM Product
WHERE Product_ID IN (1001,1002)
ORDER BY Product_ID;

-- Roll back to savepoint
ROLLBACK TO SAVEPOINT sp_after_keyboard;

SELECT Product_ID,Stock_Qty FROM Product
WHERE Product_ID IN (1001,1002)
ORDER BY Product_ID;

-- Commit retained changes
COMMIT;

SELECT Product_ID,Stock_Qty FROM Product
WHERE Product_ID IN (1001,1002)
ORDER BY Product_ID;

-- Demonstrate full rollback
START TRANSACTION;

UPDATE Product SET Stock_Qty=0
WHERE Product_ID=1003;

ROLLBACK;

SELECT Product_ID,Stock_Qty FROM Product
WHERE Product_ID=1003;

-- Drop the secondary index
DROP INDEX idx_product_category ON Product;

SHOW INDEX FROM Product;

-- Verification
SELECT COUNT(*) AS Total_Products FROM Product;

SELECT Product_ID,Stock_Qty FROM Product
WHERE Product_ID IN (1001,1002,1003);

SHOW FULL TABLES IN WarehouseDB;
