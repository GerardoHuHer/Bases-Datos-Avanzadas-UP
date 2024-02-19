-- 1.- Listar todos los productos del que más se vende al que menos, por unidades vendidas, para todos los datos de la base.
SELECT products.productName, orderdetails.productCode, SUM(orderdetails.quantityOrdered) AS TOTAL
FROM orderdetails, products
WHERE
    orderdetails.productCode = products.productCode
GROUP BY orderdetails.productCode
ORDER BY SUM(quantityOrdered) DESC;

-- 2.- Listar todos los productos del que más se vende al que menos, por unidades vendidas, pero segmentado por el año de la fecha de orden.
SELECT orderdetails.productCode, products.productName, SUM(quantityOrdered) AS cantTotal, YEAR(orders.orderDate) as Anio
FROM orderdetails, products, orders
WHERE 
    products.productCode = orderdetails.productCode AND 
    orderdetails.orderNumber = orders.orderNumber
GROUP BY orderdetails.productCode, YEAR(orders.orderDate)
ORDER BY SUM(quantityOrdered) DESC;  

-- 3.- Listar todos los productos del que más se vende al que menos, por unidades vendidas, pero segmentado por oficina.
SELECT orderdetails.productCode, products.productName, SUM(quantityOrdered) AS cantTotal, offices.officeCode
FROM orderdetails, products, orders, customers, employees, offices
WHERE 
    products.productCode = orderdetails.productCode AND 
    orderdetails.orderNumber = orders.orderNumber AND 
    orders.CustomerNumber = customers.CustomerNumber AND
    customers.salesRepEmployeeNumber = employees.employeeNumber AND
    employees.officeCode = offices.officeCode
GROUP BY orderdetails.productCode, offices.officeCode
ORDER BY SUM(quantityOrdered) DESC;

-- 4, 5, 6.- Igual a los tres anteriores, pero no por unidades vendidas, sino por monto reportado en las órdenes de compra, para aquéllas que NO cumplen con el estado 'Shipped' y 'Resolved'.

-- 4. 
SELECT products.productName, orderdetails.productCode, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS TOTAL, orders.status
FROM orderdetails, products, orders
WHERE
    orderdetails.productCode = products.productCode AND
    orderdetails.orderNumber = orders.orderNumber AND
    orders.status NOT IN ('Shipped', 'Resolved')
GROUP BY orderdetails.productCode, orders.status
ORDER BY SUM(orderdetails.quantityOrdered* orderdetails.priceEach) DESC;

-- 5.
SELECT orderdetails.productCode, products.productName, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS cantTotal, YEAR(orders.orderDate) as Anio, orders.status
FROM orderdetails, products, orders
WHERE 
    products.productCode = orderdetails.productCode AND 
    orderdetails.orderNumber = orders.orderNumber AND
    orders.status NOT IN ('Shipped', 'Resolved')
GROUP BY orderdetails.productCode, YEAR(orders.orderDate), orders.status
ORDER BY SUM(orderdetails.quantityOrdered * orderdetails.priceEach) DESC;

-- 6.
SELECT orderdetails.productCode, products.productName, SUM(quantityOrdered * orderdetails.priceEach) AS Total, offices.officeCode, orders.status
FROM orderdetails, products, orders, customers, employees, offices
WHERE 
    products.productCode = orderdetails.productCode AND 
    orderdetails.orderNumber = orders.orderNumber AND 
    orders.CustomerNumber = customers.CustomerNumber AND
    customers.salesRepEmployeeNumber = employees.employeeNumber AND
    employees.officeCode = offices.officeCode AND
    orders.status NOT IN ('Shipped', 'Resolved')
GROUP BY orderdetails.productCode, offices.officeCode, orders.status
ORDER BY SUM(quantityOrdered) DESC;

-- 9.   
-- Crear tabla
CREATE TABLE new_orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    city VARCHAR(75) DEFAULT NULL, 
    country VARCHAR(75) DEFAULT NULL
)

-- Stored Procedure
DELIMITER //
CREATE PROCEDURE new_order_log(IN pDate INT, IN pCity VARCHAR(75), IN pCountry VARCHAR(75))
BEGIN
    INSERT INTO new_orders
    (order_date, city, country)
    VALUES
    (pDate, pCity, pCountry);
END //
DELIMITER ;

