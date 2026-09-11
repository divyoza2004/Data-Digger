CREATE DATABASE data_digger;
USE data_digger; 
-- customer table 
CREATE TABLE customer(
customer_id INT PRIMARY KEY,
name VARCHAR(100), 
email VARCHAR(100), 
address TEXT
);
INSERT INTO customer(customer_id, name, email, address) 
VALUES 
(1, 'Alice Smith', 'alice.smith@email.com', '123 Maple St'),
(2, 'Bob Jones', 'bob.jones@email.com', '456 Oak St'),
(3, 'Charlie Brown', 'charlie.b@email.com', '789 Pine St'),
(4, 'Alice Green', 'alice.green@email.com', '321 Elm St'),
(5, 'Eva White', 'eva.white@email.com', '654 Birch St');
SELECT * FROM customer;
UPDATE customer SET address = '999 New Avenue Rd' WHERE customer_id = 2;
-- Customer 1 ko delete nahi kar sakte kyunki iska order id 101 orders table me exist karta hai
-- DELETE FROM customer WHERE customer_id = 1; 
SELECT * FROM customer WHERE name = 'Alice' OR name LIKE 'Alice%';

-- Order Table 
CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE, 
total_amount DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
INSERT INTO orders(order_id, customer_id, order_date, total_amount) 
VALUES 
(101, 1, '2026-09-05', 150.50),
(102, 2, '2026-09-01', 85.00),
(103, 3, '2026-08-20', 200.00),
(104, 4, '2026-07-15', 45.25),
(105, 5, '2026-09-10', 310.00);
SELECT * FROM orders WHERE customer_id = 3; 
UPDATE orders SET total_amount = 234.00 WHERE customer_id = 4; 
DELETE FROM orders WHERE order_id = 102; 
SELECT * FROM orders WHERE order_date >= CURRENT_DATE - INTERVAL '30' DAY; 
SELECT  MAX(total_amount) AS HighestAmount, MIN(total_amount) AS LowestAmount, AVG(total_amount) AS AverageAmount FROM orders; 

-- Product Table 
CREATE TABLE product(
product_id INT PRIMARY KEY, 
product_name VARCHAR(100), 
price DECIMAL(10,2),
quantity_stock INT
);
INSERT INTO product(product_id, product_name, price, quantity_stock) 
VALUES 
(1, 'Wireless Mouse', 450.00, 25),
(2, 'Mechanical Keyboard', 1800.00, 15),
(3, 'Gaming Headset', 2500.00, 0),
(4, 'USB-C Cable', 600.00, 50),
(5, 'Laptop Stand', 1200.00, 8);
-- order_details  
CREATE TABLE order_details(
order_detail_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
subtotal DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES product(product_id)
);
INSERT INTO order_details(order_detail_id, order_id, product_id, quantity, subtotal)
VALUES
(1, 101, 1, 1, 450.00),
(2, 101, 4, 2, 1200.00),
(3, 103, 2, 1, 1800.00),
(4, 104, 4, 1, 600.00),
(5, 105, 5, 2, 2400.00);
SELECT * FROM order_details WHERE order_id = 101;
SELECT SUM(subtotal) AS total_revenue FROM order_details;
SELECT product_id, SUM(quantity) AS total_quantity_ordered  FROM order_details GROUP BY product_id ORDER BY total_quantity_ordered DESC LIMIT 3;
SELECT COUNT(*) AS TimesSold FROM order_details WHERE product_id = 4;