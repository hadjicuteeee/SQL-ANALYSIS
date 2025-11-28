--YOU CAN USE THIS FOR SELECTION
SELECT * FROM EMPLOYEES e
LEFT JOIN orders o on e.emp_id = o.emp_id
LEFT JOIN attendance a on e.emp_id = a.emp_id;




-- Shows all employees who have related orders and attendance using (INNER JOIN)
SELECT * FROM employees e 
join orders using(emp_id)
join attendance using (emp_id);



-- Retrieves employee name and age based on birth_date
SELECT 
	name as "Studensts", 
	AGE(CURRENT_DATE, birth_date)
from employees;



-- Retrieves total order amount per day
SELECT 
	DATE_TRUNC('day', order_date) as order_day,
	SUM(amount) as amount
from orders 
group by order_day;



-- Retrieves total order amount per employee per month, sorted descending
SELECT name,
	EXTRACT(MONTH from order_date) as monthly,
	SUM(amount) as total_amount
FROM employees 
JOIN orders using(emp_id)
GROUP BY name, monthly
ORDER BY total_amount DESC;



-- Shows each employee's orders in the last 30 days
SELECT 
    e.name,
    DATE_TRUNC('day', o.order_date) AS order_date,
    o.amount
FROM employees e
JOIN orders o ON e.emp_id = o.emp_id
WHERE order_date >= '2024-10-05':: DATE - INTERVAL '30 DAYS'
ORDER BY o.order_date;



-- Retrieves the latest order date from orders
SELECT 
	DATE_TRUNC('day', MAX(order_date)) as "LATEST DATE"
FROM orders;



-- Retrieves the maximum order amount per employee
SELECT name, MAX(amount) as total
from orders
join employees using(emp_id)
group by name;



-- Shows the highest amount per employee using DISTINCT ON
SELECT DISTINCT ON (name)
name,
amount
from employees e
inner join orders o on e.emp_id = o.emp_id
order by name, amount desc;



-- Retrieves total working hours per employee per day
SELECT name,
	CAST(check_in AS DATE) as "WORK DATE",
	ROUND(EXTRACT(EPOCH FROM(check_out - check_in) ) /3600, 2) as "Time Hour"
FROM employees e
INNER JOIN attendance a on e.emp_id = a.emp_id;



-- Retrieves the earliest check-in time per employee
SELECT DISTINCT ON (name)
	name,
	check_in as early_time
from employees
join attendance using(emp_id)
order by name, check_in ASC;



-- Retrieves total order amount per year
SELECT
	EXTRACT(YEAR FROM ORDER_DATE) AS YEARLY,
	sum(amount) as total
from orders
group by EXTRACT(YEAR FROM ORDER_DATE);

