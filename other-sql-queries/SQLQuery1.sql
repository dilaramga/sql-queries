

use[AdventureWorksDW2012]
SELECT
DC.[CustomerKey] AS [Customer ID],
DC.GeographyKey,
DC.[FirstName], 
DC.[LastName],
DC.[Gender],
DC.[MaritalStatus] AS [Marital Status], DC.EnglishEducation, DC.FrenchEducation, DC.SpanishEducation, DC.EnglishOccupation, DC.FrenchOccupation, DC.SpanishOccupation,
DG.City,
DG.EnglishCountryRegionName as Country,
FIS.[Total Quantity],
FIS.[Total Cost],
FIS.[Total Sale],
(FIS.[Total Sale]-Fis.[Total Cost]) as Profit,
CASE
WHEN  (FIS.[Total Sale]-Fis.[Total Cost])<=400 THEN 'Low Profitable'
WHEN (FIS.[Total Sale]-Fis.[Total Cost])<1000 THEN 'Mid Profitable'
WHEN (FIS.[Total Sale]-Fis.[Total Cost])>=1000 THEN 'High Profitable'

END AS [Profit Segment]


From dbo.DimCustomer as DC
inner join 
	(select CustomerKey, sum(OrderQuantity) as [Total Quantity],
		sum(TotalProductCost) as [Total Cost],
		sum(SalesAmount) as [Total Sale]
	
	From dbo.FactInternetSales
		group by CustomerKey)AS FIS
on DC.CustomerKey = FIS.CustomerKey
left join dbo.DimGeography as DG
on DC.GeographyKey = DG.GeographyKey;