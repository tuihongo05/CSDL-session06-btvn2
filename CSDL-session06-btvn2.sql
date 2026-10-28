CREATE DATABASE session06_btvn2;
USE session06_btvn2;

CREATE TABLE categories(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE products(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    price DOUBLE(10,2),
    category_id INT ,
    FOREIGN KEY(category_id) REFERENCES categories(id)
);

CREATE TABLE customers(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE orders(
	id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(id)
);

CREATE TABLE order_details(
	order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DOUBLE(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY(order_id) REFERENCES orders(id),
    FOREIGN KEY(product_id) REFERENCES products(id)
);

-- Them 2 khach hang moi vao bang customers
INSERT INTO customers(id, name, email)
VALUES
(1, 'Tran Van A', 'a@gmail.com'),
(2, 'Nguyen Thi B', 'b@gmail.com');

-- Liet ke khach hang da co it nhat 1 don hang
SELECT DISTINCT c.id, c.name, c.email
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id;

-- Tim khach hang chua tung dat don nao
SELECT DISTINCT customers.id, customers.name, customers.email
FROM customers
LEFT JOIN orders
ON customers.id = orders.customer_id
WHERE orders.customer_id IS NULL;

-- Tinh tong doanh thu moi khach hang mang lai
SELECT customers.id, customers.name, SUM(order_details.quantity * order_details.price) AS total
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id
INNER JOIN order_details
ON orders.id = order_details.order_id
GROUP BY customers.id, customers.name;

-- Xac dinh khach hang mua san pham cao nhat
SELECT DISTINCT customers.id, customers.name, customers.email
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id
INNER JOIN order_details
ON orders.id = order_details.order_id
INNER JOIN products
ON order_details.product_id = products.id
WHERE products.price = (
	SELECT MAX(price)
    FROM products
);

