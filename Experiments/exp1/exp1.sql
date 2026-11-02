/*
EXPERIMENT 1
TITLE: Creation of a Database and SQL Queries for Information Retrieval

AIM:
To create a relational database and STUDENT table, insert ten records,
and retrieve information using SQL filtering, sorting, pattern matching,
and conditional operators.

EXPERIMENT:
Perform the following SQL statements using MySQL.
*/

-- 1. Create the database
CREATE DATABASE UniversityDB;

-- 2. Select the database
USE UniversityDB;

-- 3. Create the Student table
CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(50) NOT NULL,
    Department VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Marks DECIMAL(5,2),
    City VARCHAR(30)
);

-- 4. Display the structure of the Student table
DESC Student;

-- 5. Insert ten records into the Student table
INSERT INTO Student
(Student_ID, Student_Name, Department, Year, Age, Gender, Marks, City)
VALUES
(101, 'Arun',   'CSE',  2, 19, 'Male',   85, 'Chennai'),
(102, 'Priya',  'ECE',  3, 20, 'Female', 92, 'Hyderabad'),
(103, 'Ravi',   'CSE',  2, 19, 'Male',   67, 'Vijayawada'),
(104, 'Sneha',  'AIML', 1, 18, 'Female', 88, 'Bengaluru'),
(105, 'Kiran',  'EEE',  4, 21, 'Male',   56, 'Chennai'),
(106, 'Divya',  'CSE',  3, 20, 'Female', 94, 'Tirupati'),
(107, 'Rahul',  'MECH', 2, 19, 'Male',   72, 'Nellore'),
(108, 'Anjali', 'AIML', 1, 18, 'Female', 81, 'Hyderabad'),
(109, 'Naveen', 'ECE',  4, 21, 'Male',   63, 'Guntur'),
(110, 'Kavya',  'CSE',  3, 20, 'Female', 90, 'Chennai');

-- 6. Retrieve all records
SELECT * FROM Student ORDER BY Student_ID;

-- 7. Retrieve only Student_ID, Student_Name and Department
SELECT Student_ID, Student_Name, Department
FROM Student
ORDER BY Student_ID;

-- 8. Retrieve CSE students
SELECT Student_ID, Student_Name, Department
FROM Student
WHERE Department = 'CSE'
ORDER BY Student_ID;

-- 9. Use the AND operator
SELECT Student_Name, Department, Marks
FROM Student
WHERE Department = 'CSE' AND Marks > 80
ORDER BY Student_ID;

-- 10. Use the OR operator
SELECT Student_Name, Department
FROM Student
WHERE Department = 'AIML' OR Department = 'ECE'
ORDER BY Student_ID;

-- 11. Display distinct departments
SELECT DISTINCT Department
FROM Student
ORDER BY Department;

-- 12. Sort marks in ascending order
SELECT Student_Name, Marks
FROM Student
ORDER BY Marks ASC;

-- 13. Sort marks in descending order
SELECT Student_Name, Marks
FROM Student
ORDER BY Marks DESC;

-- 14. Retrieve students whose marks are between 70 and 90
SELECT Student_Name, Marks
FROM Student
WHERE Marks BETWEEN 70 AND 90
ORDER BY Marks ASC;

-- 15. Search student names beginning with 'A'
SELECT Student_ID, Student_Name
FROM Student
WHERE Student_Name LIKE 'A%'
ORDER BY Student_ID;

-- 16. Use the IN operator
SELECT Student_Name, Department
FROM Student
WHERE Department IN ('CSE', 'ECE', 'AIML')
ORDER BY Student_ID;

-- 17. Find records where City is NULL
SELECT Student_ID, Student_Name, City
FROM Student
WHERE City IS NULL;

-- 18. Display the top three marks
SELECT Student_Name, Department, Marks
FROM Student
ORDER BY Marks DESC, Student_ID ASC
LIMIT 3;
