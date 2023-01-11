# Pewlett-Hackard-Analysis
## Purpose
The purpose of this project is to analyze a dataset of employee information, stored in Excel files, and transfer it into a SQL database. The goal is to use SQL and python to determine which employees are eligible for retirement in the next few years and how many positions will need to be filled, and then create charts to display this information using python.
## SQL Queries
SQL queries are used to extract the relevant information from the database and create new tables as needed. The queries filter the data based on the employees' birthdate and hire date to determine who is eligible for retirement, and also join data from different tables to gather information about each employee's department and role.

## Database
![EmployeeDB](/Analysis/EmployeeDB.png)

With our main connection keys as employee number (emp_no) and Department Number (dept_no)

## Analysis: 
Two Questions were asked:
1. Who will be retiring in the next few years?

2. In which department do those positions need to be filled in?


![Eligible_for_Retirement](/Analysis/pie_chart_01.png)

Over the next five years Pewlett Hackard, a company of 240,124 employees, will have 33,118 of their employees over the age of 65; making them eligible for retirement. Below is a bar chart that brakes down those eligible by department.

![Bar_Chart](/Analysis/bar_chart.png)


