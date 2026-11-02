/*
EXPERIMENT 2
TITLE: Insertion, Deletion, Modification, Alteration, Updating and Conditional Record Viewing

AIM:
To create an Employee Payroll database and demonstrate INSERT, DELETE,
ALTER, UPDATE and SELECT statements, including conditional modifications
and retrieval.

EXPERIMENT:
Perform the following SQL statements using MySQL 8.0+.
*/

-- Query 1: Create the database and select it
CREATE DATABASE PayrollLabDB;
USE PayrollLabDB;

-- Query 2: Create the Employee table
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50) NOT NULL,
    Department VARCHAR(25) NOT NULL,
    Designation VARCHAR(30) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    City VARCHAR(30),
    Join_Date DATE NOT NULL
);

-- Query 3: Insert eight initial records
INSERT INTO Employee
(Emp_ID, Emp_Name, Department, Designation, Salary, City, Join_Date)
VALUES
(201, 'Asha',   'HR',      'Executive',   38000, 'Chennai',    '2023-06-12'),
(202, 'Bharat', 'IT',      'Developer',   52000, 'Hyderabad',  '2022-08-01'),
(203, 'Charan', 'Sales',   'Associate',   32000, 'Vijayawada', '2024-01-15'),
(204, 'Deepa',  'IT',      'Analyst',     48000, 'Bengaluru',  '2023-03-20'),
(205, 'Eshan',  'Finance', 'Accountant',  45000, 'Chennai',    '2021-11-05'),
(206, 'Farah',  'HR',      'Recruiter',   41000, 'Hyderabad',  '2024-02-10'),
(207, 'Gopal',  'Sales',   'Executive',   35000, 'Nellore',    '2022-07-18'),
(208, 'Hema',   'IT',      'Developer',   56000, 'Tirupati',   '2021-09-30');

-- Query 4: View the initial records
SELECT * FROM Employee ORDER BY Emp_ID;

-- Query 5: Insert one new employee
INSERT INTO Employee
VALUES (209, 'Ishita', 'Marketing', 'Coordinator', 39000, 'Guntur', '2025-01-06');

-- Query 6: Update one employee's salary
UPDATE Employee
SET Salary = 55000
WHERE Emp_ID = 202;

SELECT Emp_ID, Emp_Name, Salary
FROM Employee
WHERE Emp_ID = 202;

-- Query 7: Increase Sales department salaries by 10%
UPDATE Employee
SET Salary = ROUND(Salary * 1.10, 2)
WHERE Department = 'Sales';

SELECT Emp_ID, Emp_Name, Salary
FROM Employee
WHERE Department = 'Sales'
ORDER BY Emp_ID;

-- Query 8: Modify an employee's department
UPDATE Employee
SET Department = 'Operations'
WHERE Emp_ID = 206;

SELECT Emp_ID, Emp_Name, Department
FROM Employee
WHERE Emp_ID = 206;

-- Query 9: Add a new Email column
ALTER TABLE Employee
ADD COLUMN Email VARCHAR(80) NULL;

SHOW COLUMNS FROM Employee LIKE 'Email';

-- Query 10: Populate the Email column
UPDATE Employee
SET Email = 'asha@company.test'
WHERE Emp_ID = 201;

UPDATE Employee
SET Email = 'bharat@company.test'
WHERE Emp_ID = 202;

SELECT Emp_ID, Emp_Name, Email
FROM Employee
WHERE Email IS NOT NULL
ORDER BY Emp_ID;

-- Query 11: Modify the Designation column data type
ALTER TABLE Employee
MODIFY COLUMN Designation VARCHAR(50) NOT NULL;

SHOW COLUMNS FROM Employee LIKE 'Designation';

-- Query 12: View employees whose salary is at least 45000
SELECT Emp_ID, Emp_Name, Department, Salary
FROM Employee
WHERE Salary >= 45000
ORDER BY Salary DESC, Emp_ID;

-- Query 13: Delete the selected employee Ishita
DELETE FROM Employee
WHERE Emp_ID = 209;

SELECT COUNT(*) AS Total_Employees
FROM Employee;

-- Query 14: Delete Farah using a condition
DELETE FROM Employee
WHERE Department = 'Operations' AND Emp_ID = 206;

SELECT Emp_ID, Emp_Name, Department
FROM Employee
ORDER BY Emp_ID;

-- Query 15: View the final payroll records
SELECT Emp_ID, Emp_Name, Department, Salary, Email
FROM Employee
ORDER BY Emp_ID;

-- Additional verification queries
SELECT COUNT(*) AS Final_Count
FROM Employee;

SELECT Emp_Name, Salary
FROM Employee
WHERE Department = 'Sales'
ORDER BY Emp_ID;

SHOW COLUMNS FROM Employee;

-- Practice exercises (run separately after completing the experiment):
-- 1. Insert employee 210 with valid details.
-- 2. Change the city of employee 204 to Chennai.
-- 3. Increase Finance salary by 5%.
-- 4. List employees whose salary is over 40000.
-- 5. Add a Phone column as VARCHAR(15).
-- 6. Populate the Phone field for employee 201.
-- 7. Display all employees in IT ordered by salary.
-- 8. Delete employee 210 using a specific ID.
-- 9. Display employees with NULL email.
-- 10. Explain why UPDATE without WHERE is dangerous.
