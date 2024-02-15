-- Generar una tabla
CREATE TABLE employees_audit(
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastName VARCHAR(50) NOT NULL, 
    changeDate DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

-- Trigger para ver si un usuario se le cambió el apellido
CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW 
INSERT INTO employees_audit
(employeeNumber, lastName, changeDate, action)
VALUES
(OLD.employeeNumber, OLD.lastName, NOW(), 'trigger-update');

-- Como crear un stored procedure
DELIMITER // 

CREATE PROCEDURE InsLog(IN pENum INT, IN pLName VARCHAR(50), IN pDate DATETIME, IN pAction VARCHAR(50))
BEGIN
    INSERT INTO employees_audit
    (employeeNumber, lastName, changeDate, action)
    VALUES
    (pENum, pLName, pDate, pAction);
END //

DELIMITER ;

--Para llamar el stored procedure es con
CALL InsLog(OLD.employeeNumber, OLD.lastName, NOW(), 'sp-update');
