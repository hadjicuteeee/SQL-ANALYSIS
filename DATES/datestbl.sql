CREATE TABLE employees(
emp_id SERIAL PRIMARY KEY,
name VARCHAR(50),
department VARCHAR(50),
hire_date DATE,
birth_date DATE
);

CREATE TABLE orders(
order_id SERIAL PRIMARY KEY,
emp_id INT
REFERENCES employees(emp_id),
order_date TIMESTAMP,
amount numeric (10,2)
);

CREATE TABLE attendance(
att_id SERIAL PRIMARY KEY,
emp_id INT REFERENCES employees(emp_id),
check_in TIMESTAMP,
check_out TIMESTAMP
);


INSERT INTO employees (name, department, hire_date, birth_date) VALUES
('Hadji', 'IT', '2022-05-10', '2002-01-15'),
('Jinwoo', 'Marketing', '2021-11-03', '2001-03-22'),
('Mika', 'Finance', '2020-01-20', '1998-12-05');

INSERT INTO orders (emp_id, order_date, amount) VALUES
(1, '2024-10-01 10:23:00', 1499.50),
(1, '2024-10-03 15:45:00', 2499.00),
(2, '2024-10-02 08:10:00', 899.99),
(3, '2024-09-28 18:05:00', 1200.00);

INSERT INTO attendance(emp_id, check_in, check_out) VALUES
(1, '2024-10-04 08:59:00', '2024-10-04 17:12:00'),
(1, '2024-10-05 09:10:00', '2024-10-05 16:45:00'),
(2, '2024-10-04 10:00:00', '2024-10-04 18:00:00'),
(3, '2024-10-03 08:30:00', '2024-10-03 17:05:00');