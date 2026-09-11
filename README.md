# 🔍 Data Digger

## Objective

"Data Digger" is a practical SQL project that provides hands-on experience in managing a MySQL database using CRUD operations, clauses, operators, aggregate functions, primary keys, and foreign keys. Students will design and manipulate a structured relational database for an E-Commerce Store to gain deeper insights into SQL query execution.

## 🗂️ Database Schema

The `data_digger` database contains **4 tables** that model a simple e-commerce store:

| Table | Purpose | Primary Key | Foreign Key(s) |
|---|---|---|---|
| `customer` | Stores customer details | `customer_id` | — |
| `orders` | Stores orders placed by customers | `order_id` | `customer_id` → `customer(customer_id)` |
| `product` | Stores product catalog & stock | `product_id` | — |
| `order_details` | Line items linking orders to products | `order_detail_id` | `order_id` → `orders(order_id)`, `product_id` → `product(product_id)` |

## 📜 Query-by-Query Walkthrough


### 👤 Customer Table

#### 1. Create `customer` table

Creates the `customer` table with `customer_id` as the PRIMARY KEY, along with `name`, `email`, and `address` columns to store customer records.

```sql
CREATE TABLE customer(
customer_id INT PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(100),
address TEXT
);
```

**Output:** ✅ Table created successfully.

#### 2. Insert records into `customer`

Inserts 5 sample customers (Alice Smith, Bob Jones, Charlie Brown, Alice Green, Eva White) into the `customer` table.

```sql
INSERT INTO customer(customer_id, name, email, address)
VALUES
(1, 'Alice Smith', 'alice.smith@email.com', '123 Maple St'),
(2, 'Bob Jones', 'bob.jones@email.com', '456 Oak St'),
(3, 'Charlie Brown', 'charlie.b@email.com', '789 Pine St'),
(4, 'Alice Green', 'alice.green@email.com', '321 Elm St'),
(5, 'Eva White', 'eva.white@email.com', '654 Birch St');
```

**Output:** ✅ 5 row(s) inserted successfully.

#### 3. View all customers

Retrieves every row from the `customer` table to verify the inserted data.

```sql
SELECT * FROM customer;
```

**Output:**

| customer_id | name | email | address |
|---|---|---|---|
| 1 | Alice Smith | alice.smith@email.com | 123 Maple St |
| 2 | Bob Jones | bob.jones@email.com | 456 Oak St |
| 3 | Charlie Brown | charlie.b@email.com | 789 Pine St |
| 4 | Alice Green | alice.green@email.com | 321 Elm St |
| 5 | Eva White | eva.white@email.com | 654 Birch St |

#### 4. Update customer address

Updates the `address` of customer_id = 2 (Bob Jones) to '999 New Avenue Rd'.

```sql
UPDATE customer SET address = '999 New Avenue Rd' WHERE customer_id = 2;
```

**Output:** ✅ 1 row(s) updated successfully.

#### 5. Attempt to delete customer 1 (blocked by Foreign Key)

This statement is commented out in the source file. Customer 1 **cannot** be deleted because `order_id = 101` in the `orders` table references `customer_id = 1` via a FOREIGN KEY constraint — deleting it would break referential integrity.

```sql
-- DELETE FROM customer WHERE customer_id = 1;
```

**Output:** _Statement is commented out in the source file — not executed._

#### 6. Search customers named 'Alice'

Uses `OR` and the `LIKE` operator with a wildcard (`Alice%`) to find every customer whose name is exactly 'Alice' or starts with 'Alice'.

```sql
SELECT * FROM customer WHERE name = 'Alice' OR name LIKE 'Alice%';
```

**Output:**

| customer_id | name | email | address |
|---|---|---|---|
| 1 | Alice Smith | alice.smith@email.com | 123 Maple St |
| 4 | Alice Green | alice.green@email.com | 321 Elm St |


### 🧾 Orders Table

#### 7. Create `orders` table

Creates the `orders` table with `order_id` as PRIMARY KEY and `customer_id` as a FOREIGN KEY referencing `customer(customer_id)`, linking each order to a customer.

```sql
CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
total_amount DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
```

**Output:** ✅ Table created successfully.

#### 8. Insert records into `orders`

Inserts 5 orders, each linked to a customer via `customer_id`, along with the order date and total amount.

```sql
INSERT INTO orders(order_id, customer_id, order_date, total_amount)
VALUES
(101, 1, '2026-09-05', 150.50),
(102, 2, '2026-09-01', 85.00),
(103, 3, '2026-08-20', 200.00),
(104, 4, '2026-07-15', 45.25),
(105, 5, '2026-09-10', 310.00);
```

**Output:** ✅ 5 row(s) inserted successfully.

#### 9. View orders for a specific customer

Filters the `orders` table to show only orders placed by `customer_id = 3` (Charlie Brown).

```sql
SELECT * FROM orders WHERE customer_id = 3;
```

**Output:**

| order_id | customer_id | order_date | total_amount |
|---|---|---|---|
| 103 | 3 | 2026-08-20 | 200 |

#### 10. Update order total

Updates the `total_amount` of the order belonging to `customer_id = 4` (Alice Green) to 234.00.

```sql
UPDATE orders SET total_amount = 234.00 WHERE customer_id = 4;
```

**Output:** ✅ 1 row(s) updated successfully.

#### 11. Delete an order

Deletes the order with `order_id = 102` from the `orders` table.

```sql
DELETE FROM orders WHERE order_id = 102;
```

**Output:** ✅ 1 row(s) deleted successfully.

#### 12. Orders placed in the last 30 days

Retrieves orders where `order_date` falls within the last 30 days from the current date, using a date interval comparison. (MySQL's `CURRENT_DATE - INTERVAL '30' DAY` is written here as SQLite's `date('now','-30 days')` — same logic, different dialect syntax.)

```sql
SELECT * FROM orders WHERE order_date >= CURRENT_DATE - INTERVAL '30' DAY;
```

**Output:**

| order_id | customer_id | order_date | total_amount |
|---|---|---|---|
| 101 | 1 | 2026-09-05 | 150.5 |
| 103 | 3 | 2026-08-20 | 200 |
| 105 | 5 | 2026-09-10 | 310 |

#### 13. Aggregate order statistics

Uses the aggregate functions `MAX()`, `MIN()`, and `AVG()` to find the highest, lowest, and average order amount across all orders.

```sql
SELECT  MAX(total_amount) AS HighestAmount, MIN(total_amount) AS LowestAmount, AVG(total_amount) AS AverageAmount FROM orders;
```

**Output:**

| HighestAmount | LowestAmount | AverageAmount |
|---|---|---|
| 310 | 150.5 | 223.625 |


### 📦 Product Table

#### 14. Create `product` table

Creates the `product` table with `product_id` as PRIMARY KEY, storing product name, price, and quantity currently in stock.

```sql
CREATE TABLE product(
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
price DECIMAL(10,2),
quantity_stock INT
);
```

**Output:** ✅ Table created successfully.

#### 15. Insert records into `product`

Inserts 5 products (Wireless Mouse, Mechanical Keyboard, Gaming Headset, USB-C Cable, Laptop Stand) with their price and stock quantity.

```sql
INSERT INTO product(product_id, product_name, price, quantity_stock)
VALUES
(1, 'Wireless Mouse', 450.00, 25),
(2, 'Mechanical Keyboard', 1800.00, 15),
(3, 'Gaming Headset', 2500.00, 0),
(4, 'USB-C Cable', 600.00, 50),
(5, 'Laptop Stand', 1200.00, 8);
```

**Output:** ✅ 5 row(s) inserted successfully.


### 🔗 Order Details Table

#### 16. Create `order_details` table

Creates the `order_details` table, a linking table with two FOREIGN KEYS — `order_id` referencing `orders` and `product_id` referencing `product` — to record which products belong to which order.

```sql
CREATE TABLE order_details(
order_detail_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
subtotal DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES product(product_id)
);
```

**Output:** ✅ Table created successfully.

#### 17. Insert records into `order_details`

Inserts 5 order line items, each linking an order to a product with a quantity and subtotal.

```sql
INSERT INTO order_details(order_detail_id, order_id, product_id, quantity, subtotal)
VALUES
(1, 101, 1, 1, 450.00),
(2, 101, 4, 2, 1200.00),
(3, 103, 2, 1, 1800.00),
(4, 104, 4, 1, 600.00),
(5, 105, 5, 2, 2400.00);
```

**Output:** ✅ 5 row(s) inserted successfully.

#### 18. View details of a specific order

Retrieves every product line item belonging to `order_id = 101`.

```sql
SELECT * FROM order_details WHERE order_id = 101;
```

**Output:**

| order_detail_id | order_id | product_id | quantity | subtotal |
|---|---|---|---|---|
| 1 | 101 | 1 | 1 | 450 |
| 2 | 101 | 4 | 2 | 1200 |

#### 19. Total revenue (SUM aggregate)

Uses the `SUM()` aggregate function to add up the `subtotal` column across all order details, giving the total revenue generated.

```sql
SELECT SUM(subtotal) AS total_revenue FROM order_details;
```

**Output:**

| total_revenue |
|---|
| 6450 |

#### 20. Top 3 best-selling products

Groups rows by `product_id` using `GROUP BY`, sums the quantity sold with `SUM()`, sorts the result with `ORDER BY ... DESC`, and limits it to the top 3 products using `LIMIT`.

```sql
SELECT product_id, SUM(quantity) AS total_quantity_ordered  FROM order_details GROUP BY product_id ORDER BY total_quantity_ordered DESC LIMIT 3;
```

**Output:**

| product_id | total_quantity_ordered |
|---|---|
| 4 | 3 |
| 5 | 2 |
| 2 | 1 |

#### 21. Count how many times a product was sold

Uses `COUNT(*)` to find how many order-detail rows contain `product_id = 4` (USB-C Cable), i.e. how many times it was sold.

```sql
SELECT COUNT(*) AS TimesSold FROM order_details WHERE product_id = 4;
```

**Output:**

| TimesSold |
|---|
| 2 |

## ✅ Key SQL Concepts Demonstrated

- **CRUD operations** — `CREATE TABLE`, `INSERT`, `SELECT`, `UPDATE`, `DELETE`
- **Clauses** — `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`
- **Operators** — `=`, `OR`, `LIKE` (wildcard search), `>=` (date range)
- **Aggregate functions** — `MAX()`, `MIN()`, `AVG()`, `SUM()`, `COUNT()`
- **Keys & constraints** — `PRIMARY KEY`, `FOREIGN KEY` (referential integrity, e.g. blocking the delete of `customer_id = 1`)
