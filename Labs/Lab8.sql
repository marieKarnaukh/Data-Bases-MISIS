/*Task 1*/

/*1*/

SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

/*2*/
SELECT 
    CASE 
        WHEN GROUPING_ID(a.CountryRegion, a.StateProvince) = 3 THEN 'Total'
        WHEN GROUPING_ID(a.CountryRegion, a.StateProvince) = 1 THEN CONCAT(a.CountryRegion, ' Subtotal')
        WHEN GROUPING_ID(a.CountryRegion, a.StateProvince) = 0 THEN CONCAT(a.StateProvince, ' Subtotal')
    END AS Level,
    a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

/*3*/
SELECT 
    CASE 
        WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 7 THEN 'Total'
        WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 3 THEN CONCAT(a.CountryRegion, ' Subtotal')
        WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 1 THEN CONCAT(a.StateProvince, ' Subtotal')
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 0 THEN CONCAT(a.City, ' Subtotal')
    END AS Level,
    a.CountryRegion, a.StateProvince, a.City, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince;

/*Task 2*/

CREATE TABLE #tmp (CompanyName nvarchar(50), Accessories nvarchar(50), Bikes nvarchar(50), Clothing nvarchar(50), Components nvarchar(50));

INSERT INTO #tmp
select CompanyName, Accessories, Bikes, Clothing, Components
from (
	select C.CompanyName, a.ParentProductCategoryName AS Category, SUM(sod.LineTotal) AS Revenue
	from SalesLT.Customer AS c
	LEFT JOIN SalesLT.SalesOrderHeader AS soh ON (c.CustomerID = soh.CustomerID)
	LEFT JOIN SalesLT.SalesOrderDetail AS sod ON (soh.SalesOrderID = sod.SalesOrderID)
	LEFT JOIN SalesLT.Product AS p ON (p.ProductID = sod.ProductID)
	CROSS APPLY dbo.ufnGetAllCategories() AS a
	WHERE p.ProductCategoryID = a.ProductCategoryID
	GROUP BY C.CompanyName, a.ParentProductCategoryName
	) AS Category
PIVOT (SUM(Revenue) FOR Category IN ([Accessories], [Bikes], [Clothing], [Components]))
AS pvt
ORDER BY CompanyName;

select * from #tmp;

select CompanyName, Category, Revenue
from #tmp
UNPIVOT (Revenue FOR Category IN ([Accessories], [Bikes], [Clothing], [Components]))
AS unpvt
ORDER BY CompanyName;

