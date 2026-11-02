/*
EXPERIMENT 04
TITLE: Creating a Database to Set Various Constraints

AIM:
To create a relational database and implement PRIMARY KEY, FOREIGN KEY,
NOT NULL, UNIQUE, CHECK and DEFAULT constraints in MySQL.
*/

-- 1. Create database
CREATE DATABASE IF NOT EXISTS RetailConstraintDB;
USE RetailConstraintDB;

-- 2. Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(60) NOT NULL,
    email VARCHAR(80) NOT NULL UNIQUE,
    city VARCHAR(40) DEFAULT 'Chennai'
) ENGINE=InnoDB;

-- 3. Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    sku VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(60) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
) ENGINE=InnoDB;

-- 4. Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_status VARCHAR(12) NOT NULL DEFAULT 'Pending',
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT fk_order_product FOREIGN KEY (product_id)
        REFERENCES Products(product_id),
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_status CHECK
        (order_status IN ('Pending', 'Confirmed', 'Cancelled'))
) ENGINE=InnoDB;

-- 5. Insert customers
INSERT INTO Customers (customer_id, customer_name, email, city)
VALUES
(201, 'Asha', 'asha@example.com', 'Chennai'),
(202, 'Bala', 'bala@example.com', 'Hyderabad'),
(203, 'Charu', 'charu@example.com', 'Bengaluru');

-- 6. Insert products
INSERT INTO Products (product_id, sku, product_name, price, stock)
VALUES
(301, 'KB-01', 'Keyboard', 850, 25),
(302, 'MS-02', 'Mouse', 450, 40),
(303, 'HD-03', 'Hard Drive', 4200, 10);

-- 7. Insert orders
INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES
(401, 201, 301, 2, 'Pending'),
(402, 202, 302, 3, 'Confirmed'),
(403, 203, 303, 1, 'Pending');

-- 8. Test DEFAULT constraint
INSERT INTO Customers (customer_id, customer_name, email)
VALUES (204, 'Deepa', 'deepa@example.com');

SELECT customer_id, customer_name, city
FROM Customers
WHERE customer_id = 204;

-- 9. Test PRIMARY KEY constraint (expected to be rejected)
INSERT INTO Customers (customer_id, customer_name, email)
VALUES (201, 'Duplicate', 'duplicate@example.com');

-- 10. Test UNIQUE constraint (expected to be rejected)
INSERT INTO Customers (customer_id, customer_name, email)
VALUES (205, 'Esha', 'asha@example.com');

-- 11. Test NOT NULL constraint (expected to be rejected)
INSERT INTO Customers (customer_id, customer_name, email)
VALUES (205, NULL, 'esha@example.com');

-- 12. Test CHECK constraint for price (expected to be rejected)
INSERT INTO Products (product_id, sku, product_name, price, stock)
VALUES (304, 'BAD-04', 'Invalid Product', -10, 5);

-- 13. Test CHECK constraint for quantity (expected to be rejected)
INSERT INTO Orders (order_id, customer_id, product_id, quantity)
VALUES (404, 201, 301, 0);

-- 14. Test FOREIGN KEY constraint (expected to be rejected)
INSERT INTO Orders (order_id, customer_id, product_id, quantity)
VALUES (404, 999, 301, 1);

-- 15. Test CHECK constraint for order status (expected to be rejected)
INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES (404, 201, 301, 1, 'Shipped');

-- 16. Display customer records
SELECT customer_id, customer_name, email, city
FROM Customers
ORDER BY customer_id;

-- 17. Display order records
SELECT order_id, customer_id, product_id, quantity, order_status
FROM Orders
ORDER BY order_id;

-- 18. Display table constraints
SHOW CREATE TABLE Orders;
