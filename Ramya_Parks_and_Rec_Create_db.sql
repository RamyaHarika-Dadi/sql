   --DATABASE CREATED
CREATE DATABASE "Parks_and_Recreation";

--CREATE TABLES(3)
CREATE TABLE employee_demographics(
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE parks_departments (
  department_id INT NOT NULL IDENTITY(1,1),
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);


CREATE TABLE employee_salary(
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);

--INSERTING THE DATA INTO THE TABLES
INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);


INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');


-- QUERIES
SELECT name FROM sys.tables  -- to get the tables from the database
SELECT * FROM parks_departments;
SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;
SELECT first_name FROM employee_demographics;
SELECT DISTINCT gender FROM employee_demographics;

--WHERE
SELECT * FROM employee_salary WHERE salary > 80000;
SELECT * FROM employee_demographics WHERE gender = 'female';  --!= refers to not equal

--LIKE AND ALSO (%,-)
SELECT * FROM employee_demographics WHERE gender LIKE 'f%'; 
SELECT * FROM employee_demographics WHERE first_name LIKE 'b__%'; -- underscores represent the no.of words have to be present

-- GROUP BY (with aggregate functions like avg, max, count, min..)
SELECT gender FROM employee_demographics GROUP BY gender;
SELECT first_name, gender FROM employee_demographics GROUP BY gender;  -- doesn't work as we didn't use any aggregate function in the column retrieve, THE COLUMN MUST BE MENTION IN GROUP BY
SELECT gender, avg(age) AS AVG_AGE , MAX(age) as 'max age', min(age), count(age)FROM employee_demographics GROUP BY gender;
SELECT occupation FROM employee_salary GROUP BY occupation;
SELECT occupation, salary FROM employee_salary GROUP BY occupation, salary;

-- ORDER BY
SELECT * FROM employee_demographics ORDER BY first_name;
SELECT * FROM employee_demographics ORDER BY first_name desc;
SELECT * FROM employee_demographics ORDER BY gender, age;
SELECT * FROM employee_demographics ORDER BY gender, age desc; -- we can use the position for the column names as like their column numbers position
SELECT * FROM employee_demographics ORDER BY 5, 4; 

--HAVING (instead of where we use having for the aggregate functions in group by)
SELECT gender, avg(age) FROM employee_demographics GROUP BY gender HAVING avg(age)>40;-- as the aggregate function is created after the group by, we are not able to use where clause so instead of that we use having

SELECT occupation, avg(salary) FROM employee_salary WHERE occupation LIKE '%manager%' GROUP BY occupation HAVING avg(salary)>75000; --we can use where for row level but not for aggregrate function, we can also use having after group by for aggregrate function

-- LIMIT DOESN'T WORK IN SQL SERVER, INSTEAD WE USE TOP 
SELECT TOP(3) * FROM employee_demographics ORDER BY age DESC;
--IN LIMIT THERE A THING IN WHICH WE CAN SELECT THE RECORDS FROM WHATEVER ROW WE WANT BY GIVING IT AS LIMIT ROW_NUMBER, NO.OF_RECORDS
-- SELECT * FROM employee_demographics ORDER BY age DESC LIMIT 3;
-- SELECT * FROM employee_demographics ORDER BY age DESC LIMIT 3, 1;                

--ALIASING
SELECT gender, avg(age) avg_age FROM employee_demographics GROUP BY gender HAVING Avg(age) >40 ;


--JOINS ------------------------------------------------------------------------------------
--INNER JOIN
SELECT * FROM employee_demographics AS dem JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id;

SELECT dem.employee_id, gender, salary FROM employee_demographics as dem INNER JOIN employee_salary as sal ON dem.employee_id = sal.employee_id;

--OUTER JOIN -- LEFT OUTER JOIN -- RIGHT OUTER JOIN
SELECT dem.employee_id, gender, salary FROM employee_demographics as dem LEFT JOIN employee_salary as sal ON dem.employee_id = sal.employee_id;

SELECT dem.employee_id, gender, salary FROM employee_demographics as dem RIGHT JOIN employee_salary as sal ON dem.employee_id = sal.employee_id;

--SELF JOIN
SELECT * FROM employee_salary emp1 JOIN employee_salary emp2 ON emp1.employee_id = emp2.employee_id;

SELECT * FROM employee_salary emp1 JOIN employee_salary emp2 ON emp1.employee_id+1= emp2.employee_id;    --just for an example of secret santa

SELECT emp1.employee_id AS emp_id_santa, 
emp1.first_name AS first_name_santa, 
emp1.last_name AS last_name_santa, 
emp2.employee_id AS emp_id, 
emp2.first_name AS first_name_emp, 
emp2.last_name AS last_name_emp
FROM
employee_salary emp1 
JOIN 
employee_salary emp2 
ON 
emp1.employee_id+1= emp2.employee_id;    --just for an example of secret santa

--joining multiple tables together --------
SELECT * FROM employee_demographics AS dem 
JOIN employee_salary AS sal 
ON 
dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd 
ON
sal.dept_id = pd.department_id;

--FULL OUTER JOIN-------------- return all records from both tables whether they matches or not
SELECT * FROM employee_demographics AS dem FULL OUTER JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id;

SELECT dem.employee_id, dem.first_name,dem.last_name, dem.gender, sal.occupation,sal.salary FROM employee_demographics AS dem FULL OUTER JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id;

---UNIONS----------------------
SELECT first_name FROM employee_demographics UNION SELECT first_name FROM employee_salary;

SELECT first_name FROM employee_demographics UNION ALL SELECT first_name FROM employee_salary;

SELECT first_name, last_name, 'Old' AS Label FROM employee_demographics WHERE age >40 
UNION
SELECT first_name,last_name, 'Highly Paid' AS Label FROM employee_salary WHERE salary >70000 order by first_name;

SELECT first_name, last_name, 'Old man' AS Label FROM employee_demographics WHERE age >40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old woman' AS Label FROM employee_demographics WHERE age >40 AND gender = 'Female'
UNION
SELECT first_name,last_name, 'Highly Paid' AS Label FROM employee_salary WHERE salary >70000 order by first_name;

--CASE STATEMENT
SELECT first_name, last_name, age, 
CASE 
WHEN age<=30 THEN 'young' 
WHEN age BETWEEN 31 AND 50 THEN 'old'
WHEN age>=50 THEN 'on death''s door'    --for writing quotes we have to specify 2 quotes
end AS age from employee_demographics;

SELECT first_name, last_name, salary,
CASE
	WHEN salary <50000 THEN salary + (salary* 0.05)
	WHEN salary >50000 THEN salary *1.07
END AS new_salary 
FROM employee_salary;

--SUB QUERIES
SELECT * FROM employee_demographics WHERE employee_id IN ( SELECT employee_id from employee_salary where dept_id =1)

SELECT first_name, salary, (SELECT avg(salary) FROM employee_salary) FROM employee_salary;



--STRING FUNCTIONS
--Length
SELECT first_name, LEN(first_name) FROM employee_demographics; --in ssms it is len(). but for other server it may be length()

