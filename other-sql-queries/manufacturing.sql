use AdventureWorks2012
select A.ProductID,A.[Name] as ProductName,A.StandardCost, A.ListPrice, A.DaysToManufacture,B.OrderQty, B.StockedQty, B.ScrappedQty,C.ScrapReasonID,C.[Name] as ScrapReason,D.[Name] as ProductSubC, E.[Name] as ProductCategory
from Production.Product as A
left join Production.WorkOrder as B
on A.ProductID = B.ProductID
right join Production.ScrapReason as C
on B.ScrapReasonID = C.ScrapReasonID
inner join Production.ProductSubcategory as D
on A.[ProductSubcategoryID]= D.[ProductSubcategoryID]
inner join Production.ProductCategory as E
on D.ProductCategoryID= E.ProductCategoryID

select  A.SpecialOfferID,  A.[Description],  A.DiscountPct,  A.[Type],  A.Category, B.ProductID
from Sales.SpecialOffer as A
Full join Sales.SpecialOfferProduct as B
on A.SpecialOfferID= B.SpecialOfferID
left join

select*
from Production.WorkOrder

select*
from Sales.SpecialOfferProduct

select *
from Sales.SalesOrderDetail as A
left join Sales.SpecialOfferProduct as B
on A.SpecialOfferID= B.SpecialOfferID
left join Sales.SpecialOffer as C
on B.SpecialOfferID= C.SpecialOfferID


select* 
from Purchasing.PurchaseOrderHeader

select A.PurchaseOrderID,B.OrderDate,A.DueDate,C.AverageLeadTime, A.OrderQty, A.ReceivedQty, A.RejectedQty, D.[Name] as ProductName,D.DaysToManufacture,E.[Name] as ProductSubCategory, F.[Name] as ProductCatName,DATEDIFF(day,OrderDate,DueDate) as 'RequiredDeliverytime'
from Purchasing.PurchaseOrderDetail as A
left join Purchasing.PurchaseOrderHeader as B
on A.PurchaseOrderID= B.PurchaseOrderID
left join Purchasing.ProductVendor as C
on A.ProductID= C.ProductID
left join Production.Product as D
on C.ProductID= D.ProductID
left join Production.ProductSubcategory as E
on D.ProductSubcategoryID= E.ProductSubcategoryID
right join Production.ProductCategory as F
on E.ProductCategoryID= F.ProductCategoryID


select*
from Sales.SalesOrderDetail as A
left join Production.Product as B
on A.ProductID= B.ProductID
left join Sales.SalesOrderHeader as C
on A.SalesOrderID= C.SalesOrderID
left join Sales.SpecialOfferProduct as D
on A.SpecialOfferID= D.SpecialOfferID



Sales.SalesOrderDetail.SpecialOfferID
=
Sales.SpecialOfferProduct.SpecialOffer
ID,
Sales.SalesOrderDetail.ProductID =
Sales.SpecialOfferProduct.ProductID

select pwr.ProductID, pwr.ScheduledStartDate, pwr.ScheduledEndDate, pwr.ActualStartDate,pwr.ActualEndDate, pwr.PlannedCost, pwr.ActualCost,
pl.[Name] as ManufacturingProcess,D.[Name] as ProductName,D.DaysToManufacture,E.[Name] as ProductSubCategory, F.[Name] as ProductCatName,
DATEDIFF(day,(DATEDIFF(day,ScheduledStartDate,ScheduledEndDate)),DATEDIFF(day,ActualStartDate,ActualEndDate))as DaysDelay
from Production.WorkOrderRouting as pwr
left join Production.Location as pl
on pwr.LocationID= pl.LocationID
left join Production.Product as D
on pwr.ProductID= D.ProductID
left join Production.ProductSubcategory as E
on D.ProductSubcategoryID= E.ProductSubcategoryID
right join Production.ProductCategory as F
on E.ProductCategoryID= F.ProductCategoryID


