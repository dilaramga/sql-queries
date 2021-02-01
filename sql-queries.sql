/*Dilaram's work */
use AdventureWorks2012

--Question 1
--Retrieve information about the products with colour values except null, red, silver/black, white and list
--price between £75 and £750. Rename the column StandardCost to Price. Also, sort the results in
--descending order by list price.

SELECT * 
FROM Production.Product
WHERE Color NOT IN ('RED','SILVER/BLACK','WHITE') AND COLOR IS NOT NULL
AND ListPrice BETWEEN 75 AND 750
ORDER BY ListPrice DESC


--Question 2
--Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and
--female employees born between 1972 and 1975 and hire date between 2001 and 2002.

SELECT BusinessEntityID, LoginID, Gender, HireDate, BirthDate
FROM HumanResources.Employee
WHERE Gender = 'M' AND BirthDate BETWEEN '1962-01-01' AND '1970-12-31' AND HireDate>'2001'
OR Gender ='F' AND BirthDate BETWEEN '1972-01-01' AND '1975-12-31' AND HireDate BETWEEN '2001-01-01' AND '2002-12-31'


--Question 3
--Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include
--only the product ID, Name and colour.

SELECT TOP 10 ProductID,Color,Name
FROM Production.Product
WHERE ProductNumber Like 'BK%'
ORDER BY ListPrice DESC


--Question 4
--Create a list of all contact persons, where the first 4 characters of the last name are the same as the
--first four characters of the email address. Also, for all contacts whose first name and the last name
--begin with the same characters, create a new column called full name combining first name and the
--last name only. Also provide the length of the new column full name. 

SELECT *,len(was.[Full Name]) as "Length"
FROM (SELECT pp.[FirstName],pp.[MiddleName],pp.[LastName],pe.[EmailAddress],
		Concat(FirstName,' ', LastName) as "Full Name"		
		FROM Person.Person as pp
		FULL JOIN [Person].[EmailAddress] as pe ON pp.[BusinessEntityID]= pe.[BusinessEntityID]
		WHERE LEFT (LastName,4) = LEFT (EmailAddress,4) ) AS was
Where LEFT (FirstName,1)= LEFT (LastName,1)


--Question 5
--Return all product subcategories that take an average of 3 days or longer to manufacture.

SELECT pps.Name, pps.ProductSubCategoryID, pp.DaysToManufacture
FROM Production.Product as pp
FULL JOIN Production.ProductSubcategory as pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID 
WHERE DaysToManufacture >=3


--Question 6
--Create a list of product segmentation by defining criteria that places each item in a predefined
--segment as follows. If price gets less than £200 then low value. If price is between £201 and £750
--then mid value. If between £750 and £1250 then mid to high value else higher value. Filter the results
--only for black, silver and red color products.

SELECT Name, ListPrice, Color,   
       CASE
           WHEN ListPrice<200 THEN
               'Low Value'
           WHEN ListPrice BETWEEN 201 AND 750 THEN
               'Mid Value'
		   WHEN ListPrice BETWEEN 750 AND 1250 THEN
               'Mid to high'
           WHEN ListPrice>1250 THEN
               'High Value'        
       END As "Product Segment"
FROM Production.Product
WHERE Color IN ('BLACK','SILVER','RED')


--Question 7
--How many Distinct Job title are present in the Employee table.

SELECT  COUNT (DISTINCT JobTitle) AS total_title
FROM HumanResources.Employee


--Question 8
--Use employee table and calculate the ages of each employee at the time of hiring.

SELECT BusinessEntityID, LoginID, BirthDate, HireDate,
Datediff(Year, BirthDate, HireDate) as "Hired Age"
FROM HumanResources.Employee


--Question 9
--How many employees will be due a long service award in the next 5 years, if long service is 20 years? 

SELECT COUNT(*) as "Total long service award"
FROM
	(SELECT BusinessEntityID, LoginID,
		(Datediff(Year, HireDate, GETDATE())+5) as YICINFY /*Years in company in next five years */
	FROM HumanResources.Employee) AS abc
WHERE YICINFY>=20


--Question 10
--How many more years does each employee have to work before reaching sentiment, if sentiment age
--is 65? 

SELECT BusinessEntityID, BirthDate, PresentAge,
	Case
		When 65-PresentAge>0 THEN 65-PresentAge
		ELSE 0
	End AS TimeToSentiment
FROM
	(SELECT BusinessEntityID, BirthDate,
	Datediff(Year, BirthDate, GETDATE()) as PresentAge
	FROM HumanResources.Employee ) 
	AS dummy


--Question 11
--Implement new price policy on the product table base on the colour of the item
--If white increase price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2%.
--If multi, silver, silver/black or blue take the square root of the price and double the value. Column
--should be called Newprice. For each item, also calculate commission as 37.5% of newly
--computed list price. 

SELECT Name,Color,ListPrice,NewPrice,0.375*NewPrice as Commission
FROM 
	(
	SELECT Name, Color, ListPrice,
		Case
		When Color ='WHITE' THEN ListPrice*1.08
		When Color ='YELLOW' THEN ListPrice*0.925
		When Color ='Black' THEN ListPrice*1.172
		WHEN Color IN ('MULTI', 'SILVER', 'SILVER/BLACK', 'BLUE') THEN SQRT(ListPrice)*2
		ELSE ListPrice
		END AS NewPrice
	FROM Production.Product
	) AS dummy1
WHere ListPrice != NewPrice


--Question 12
--Print the information about all the Sales.Person and their sales quota. For every Sales person you
--should provide their FirstName, LastName, HireDate, SickLeaveHours and Region where they work
 
SELECT sp.*,pp.FirstName, pp.LastName, hre.HireDate, hre.SickLeaveHours
FROM Sales.SalesPerson as sp
LEFT JOIN [Person].[Person] as pp 
ON sp.BusinessEntityID= pp.BusinessEntityID
LEFT JOIN [HumanResources].[Employee] as hre 
ON pp.[BusinessEntityID] = hre.[BusinessEntityID]

--Question 13
--Using adventure works, write a query to extract the following information.
--• Product name
--• Product category name
--• Product subcategory name
--• Sales person
--• Revenue
--• Month of transaction
--• Quarter of transaction
--• Region

SELECT pp.Name AS "Product Name",ppc.Name as "Product category", ppsc.Name AS "Product subcategory name",
ssoh.SalesOrderID as salesPerson,
ssod.UnitPrice * ssod.OrderQty as Revenue,
MONTH(pth.TransactionDate) AS "Transaction Month",
CASE
	WHEN MONTH(pth.TransactionDate)<=4 THEN 1
	WHEN MONTH(pth.TransactionDate) BETWEEN 4 AND 8 THEN 2
	WHEN MONTH(pth.TransactionDate)>8 THEN 3	
END AS "Quarter of transaction"

FROM Production.Product as pp
FULL JOIN Production.ProductSubcategory as ppsc ON pp.ProductSubcategoryID = ppsc.ProductSubcategoryID
FULL JOIN Production.ProductCategory as ppc ON ppsc.ProductCategoryID = ppc.ProductCategoryID
FULL JOIN Production.TransactionHistory as pth ON pth.ProductID = pp.ProductID
FULL JOIN Sales.SalesOrderDetail as ssod ON pp.ProductID= ssod.ProductID
FULL JOIN Sales.SalesOrderHeader as ssoh ON ssod.SalesOrderID= ssoh.SalesOrderID


--Question 14
--Display the information about the details of an order i.e. order number, order date, amount of order,
--which customer gives the order and which salesman works for that customer and how much
--commission he gets for an order
SELECT sc.CustomerID, ssoh.OrderDate, ssoh.SalesOrderNumber, ssod.OrderQty,ssoh.SalesPersonID,(ssod.UnitPrice*ssp.CommissionPct) AS Comission
FROM Sales.SalesOrderHeader as ssoh
INNER JOIN Sales.Customer as sc ON ssoh.TerritoryID= sc.TerritoryID
INNER JOIN Sales.SalesPerson as ssp ON sc.TerritoryID= ssp.TerritoryID
INNER JOIN Sales.SalesOrderDetail as ssod ON ssoh.SalesOrderID= ssod.SalesOrderID


---Question 15
--For all the products calculate
--• Commission as 14.790% of standard cost,
--• Margin, if standard cost is increased or decreased as follows:
--- Black: +22%,
--- Red: -12%
--- Silver: +15%
--- Multi: +5%
--- White: Two times original cost divided by the square root of cost
--- For other colors, standard cost remains the same

SELECT ProductId,Name,Color,ListPrice,NewStandardCost,Commission, ListPrice-NewStandardCost AS Margin
FROM
		(
		SELECT ProductID, Name,Color,ListPrice, StandardCost,0.1479*StandardCost AS Commission,
		Case
				When Color ='WHITE' THEN (StandardCost*2)/SQRT(StandardCost)
				When Color ='RED' THEN StandardCost*0.88
				When Color ='BLACK' THEN StandardCost*1.22
				WHEN Color ='SILVER' THEN StandardCost*1.15
				WHEN Color ='MULTI' THEN StandardCost*1.05
				ELSE StandardCost
				END AS NewStandardCost
		FROM Production.Product
		) AS abc


--Question 16
--Create a view to find out the top 5 most expensive products for each colour.
Create VIEW Expensive_color_ AS
WITH result AS (
SELECT ProductID,Color, ListPrice,
ROW_NUMBER() over(PARTITION BY Color ORDER BY ListPrice DESC) as RowNO
FROM Production.Product
)
SELECT *
FROM result
WHERE RowNO <=5
