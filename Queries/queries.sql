-- Retirment eligibility
SELECT first_name, Last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Creating current_emp
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee Information
SELECT * FROM salaries
ORDER BY to_date DESC;

DROP TABLE emp_info;

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
	INNER JOIN salaries as s
		ON (e.emp_no = s.emp_no)
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');



-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- List of Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

---Creating Tailored Lists---
-- Sales team information
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	di.dept_name
FROM retirement_info as ri
	LEFT JOIN dept_info as di
	ON (ri.emp_no = di.emp_no)	
WHERE di.dept_name = 'Sales';

-- Sales and Development teams info
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	di.dept_name
FROM retirement_info as ri
	LEFT JOIN dept_info as di
	ON (ri.emp_no = di.emp_no)	
WHERE di.dept_name IN ('Sales', 'Development');


-- Creating retirement_eigible
SELECT e.emp_no,
    e.first_name,
    e.last_name,
	d.dept_name	
INTO retirement_eligible
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
WHERE de.to_date = ('9999-01-01')
AND (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_eligible;


-- Create a temporary table to store the duplicates
CREATE TEMPORARY TABLE duplicate_employees AS
    SELECT emp_no, title
    FROM retirement_eligible
    GROUP BY emp_no
    HAVING COUNT(*) > 1;

-- Create a new table to store employees with odd titles
CREATE TABLE odd_title (LIKE retirement_eligible);

-- Delete duplicate rows that do not contain "senior"
DELETE FROM retirement_eligible
WHERE emp_no IN (
    SELECT emp_no
    FROM duplicate_employees
    WHERE title NOT LIKE '%senior%'
)
AND title NOT LIKE '%senior%';

-- Delete duplicate rows that do not contain "assistant"
DELETE FROM retirement_eligible
WHERE emp_no IN (
    SELECT emp_no
        FROM duplicate_employees
    WHERE title NOT LIKE '%assistant%'
)
AND title NOT LIKE '%assistant%';

-- Insert rows with odd titles into the new table
INSERT INTO odd_title
SELECT * FROM retirement_eligible
WHERE emp_no IN (
    SELECT emp_no
    FROM duplicate_employees
    WHERE title NOT LIKE '%senior%'
    AND title NOT LIKE '%assistant%'
);
