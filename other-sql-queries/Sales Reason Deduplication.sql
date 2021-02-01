--INVESTIGATE THE TABLES BEFORE JOINING

SELECT * FROM [Sales].[SalesReason];
SELECT * FROM [Sales].[SalesOrderHeaderSalesReason] ORDER BY SalesOrderID;
SELECT * FROM [Sales].[SalesOrderDetail] ORDER BY SalesOrderID; ---121317

--SALES REASON HAVE INCREASED THE NUMBER OF LINE ITEMS TO 131K - DUPLICATION
Select * from [Sales].[SalesOrderHeaderSalesReason] as A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
RIGHT JOIN [Sales].[SalesOrderDetail] AS C
ON A.SalesOrderID = C.SalesOrderID



--DEDUPLICATION
--CONVERTING SALES REASON NAME VALUES TO VARIABLES(FIELDS)
SELECT 
A.[SalesOrderID]
,B.[Name]
,CASE WHEN B.[Name] = 'Price' THEN 1 ELSE 0 END AS SalesReason_Price
,CASE WHEN B.[Name] = 'Quality' THEN 1 ELSE 0 END AS SalesReason_Quality
,CASE WHEN B.[Name] = 'Review' THEN 1 ELSE 0 END AS SalesReason_Review
,CASE WHEN B.[Name] = 'Other' THEN 1 ELSE 0 END AS SalesReason_Other
,CASE WHEN B.[Name] = 'Television  Advertisement' THEN 1 ELSE 0 END AS SalesReason_TV
,CASE WHEN B.[Name] = 'Manufacturer' THEN 1 ELSE 0 END AS SalesReason_Manufacturer
,CASE WHEN B.[Name] = 'On Promotion' THEN 1 ELSE 0 END AS SalesReason_Promotion
FROM [Sales].[SalesOrderHeaderSalesReason] AS A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
order by A.[SalesOrderID];



--SUMMARISING THE NEWLY CREATED VARIABLES BY SALESORDERID USING AN ANALYTICAL QUERY
SELECT 
A.[SalesOrderID]
,max(CASE WHEN B.[Name] = 'Price' THEN 1 ELSE 0 END) AS SalesReason_Price
,max(CASE WHEN B.[Name] = 'Quality' THEN 1 ELSE 0 END) AS SalesReason_Quality
,max(CASE WHEN B.[Name] = 'Review' THEN 1 ELSE 0 END) AS SalesReason_Review
,Max(CASE WHEN B.[Name] = 'Other' THEN 1 ELSE 0 END) AS SalesReason_Other
,max(CASE WHEN B.[Name] = 'Television  Advertisement' THEN 1 ELSE 0 END) AS SalesReason_TV
,max(CASE WHEN B.[Name] = 'Manufacturer' THEN 1 ELSE 0 END) AS SalesReason_Manufacturer
,max(CASE WHEN B.[Name] = 'On Promotion' THEN 1 ELSE 0 END) AS SalesReason_Promotion
FROM [Sales].[SalesOrderHeaderSalesReason] AS A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
group by A.[SalesOrderID]
order by A.[SalesOrderID];

/**JOINING THE DEDUPLICATED SALES REASON TABLES TO OTHER TABLES USING SUB QUERIES AND SELECTING USEFUL VARIABLES LIKE A PRODUCT CATEGORY NAME**/

SELECT 
A.[SalesOrderDetailID]
,A.[SalesOrderID]
,A.[OrderQty]
,A.[UnitPrice]
,A.[OrderQty]*A.[UnitPrice] AS Revenue
,A.[UnitPriceDiscount]
,B.[OrderDate]
,CASE WHEN B.[OnlineOrderFlag] = 1 THEN 'Online' ELSE 'Reseller' END AS Sales_Channel
,B.[OnlineOrderFlag]
,B.[CustomerID]
,C.[Name] AS ProductName
,C.StandardCost
,C.[ListPrice]
,C.[DaysToManufacture]
,A.[OrderQty]*C.StandardCost AS Total_Cost
,(A.[OrderQty]*A.[UnitPrice]) - (A.[OrderQty]*C.StandardCost) AS Profit
,C.[ListPrice] - A.[UnitPrice] AS Price_belowLS /**THIS HELPS US IDENTIFY PRODUCTS SOLD BELOW LISTPRICE*/
,D.[Name] AS ProductSubcatname
,E.[Name] AS Productcatname
,F.*
FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN [Sales].[SalesOrderHeader] AS B
ON A.SalesOrderID = B.SalesOrderID
LEFT JOIN [Production].[Product] AS C
ON A.[ProductID] = C.ProductID
LEFT JOIN [Production].[ProductSubcategory] AS D
ON C.[ProductSubcategoryID] = D.[ProductSubcategoryID]
LEFT JOIN [Production].[ProductCategory] AS E
ON D.[ProductCategoryID] = E.[ProductCategoryID]
LEFT JOIN (SELECT 
A.[SalesOrderID]
,max(CASE WHEN B.[Name] = 'Price' THEN 1 ELSE 0 END) AS SalesReason_Price
,max(CASE WHEN B.[Name] = 'Quality' THEN 1 ELSE 0 END) AS SalesReason_Quality
,max(CASE WHEN B.[Name] = 'Review' THEN 1 ELSE 0 END) AS SalesReason_Review
,max(CASE WHEN B.[Name] = 'Other' THEN 1 ELSE 0 END) AS SalesReason_Other
,max(CASE WHEN B.[Name] = 'Television  Advertisement' THEN 1 ELSE 0 END) AS SalesReason_TV
,max(CASE WHEN B.[Name] = 'Manufacturer' THEN 1 ELSE 0 END) AS SalesReason_Manufacturer
,max(CASE WHEN B.[Name] = 'On Promotion' THEN 1 ELSE 0 END) AS SalesReason_Promotion
FROM [Sales].[SalesOrderHeaderSalesReason] AS A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
group by A.[SalesOrderID]) F
ON A.SalesOrderID = F.SalesOrderID;

