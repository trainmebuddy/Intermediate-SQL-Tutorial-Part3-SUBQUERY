--SQL Subquery
--Using a subquery in the WHERE clause to filter data:
SELECT * 
FROM Employee
WHERE DepartmentID = (SELECT DepartmentID FROM Department WHERE DepartmentName = 'Marketing')

--Using a subquery in the SELECT clause to perform calculations:
--Get number of ordres placed by each customers
SELECT 
 FirstName
,LastName,
(SELECT COUNT(*) FROM Sales as S WHERE s.CustomerID = c.CustomerID) as NumOfOrders
FROM Customer AS C

--Using a subquery in the FROM clause to create a derived table:
--Filter out any products that have item price that is greater than the average item price of all products
SELECT t1.ProductName, t1.ItemPrice, t2.AvgPrice
FROM Product t1
inner join (SELECT AVG(ItemPrice) as AvgPrice FROM Product) t2
on t1.ItemPrice > t2.AvgPrice

--Using a subquery with HAVING clause to get DepartmentName and the Sum of Salary for each department 
--by filtering out the departments whose average salary 
--is less than the overall average salary of all employees in the Employee table
SELECT d.DepartmentName, SUM(Salary) SumofSalary
FROM Employee e
INNER JOIN Department d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
HAVING AVG(e.Salary) < (SELECT AVG(Salary) FROM Employee)

--TYPES OF SUBQUERIES
--1.Single-row subquery
--Get a list of employees whose salary is greater than the average salary of all employees
SELECT * 
FROM Employee 
WHERE Salary > (SELECT AVG(Salary) FROM Employee)

--2.Multiple-row subquery
--Get a list of employees who are from Marketing department
SELECT * 
FROM Employee
WHERE DepartmentID in 
(SELECT DepartmentID FROM Department WHERE DepartmentName IN ('Marketing','Purchasing'))

--3.Correlated subquery
--Get a list of employees whose salary is greater than the average salary of all employees in their department
SELECT * 
FROM Employee AS E
WHERE Salary > (SELECT AVG(Salary) FROM Employee AS E2 WHERE E2.DepartmentID = E.DepartmentID)

--4. Nested subquery
--FIND THE MOST RECENT SALES DATE FOR EACH CUSTOMER AT STORE Santa Cruz Grocery
SELECT FirstName + ' ' + LastName as CustomerName, SalesDate
FROM Customer AS C
INNER JOIN (
SELECT CustomerID, MAX(SalesDate) as SalesDate
FROM Sales 
WHERE StoreID  = (
    SELECT StoreID
    FROM store
    WHERE StoreName ='Santa Cruz Grocery')
group by CustomerID) AS S
ON C.CustomerID = S.CustomerID

