/*Task 1*/

/*1*/
select P.ProductID, P.Name AS ProductName, V.Name AS ProductModel, V.Summary
from SalesLT.Product AS P
JOIN SalesLT.vProductModelCatalogDescription AS V
ON (P.ProductModelID = V.ProductModelID)
ORDER BY P.ProductID;

/*2*/
DECLARE @Colors AS TABLE (Color nvarchar(15));

INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product
WHERE Color IS NOT NULL;

SELECT P.ProductID, P.Name AS ProductName, P.Color
FROM SalesLT.Product AS P
JOIN @Colors AS C 
ON P.Color = C.Color
ORDER BY P.Color;

/*3*/

CREATE TABLE #SizeTable (Size nvarchar(5));

INSERT INTO #SizeTable (Size)
SELECT DISTINCT Size FROM SalesLT.Product
WHERE Size IS NOT NULL;

SELECT P.ProductID, P.Name AS ProductName, P.Size
FROM SalesLT.Product AS P
JOIN #SizeTable AS S 
ON S.Size COllATE Cyrillic_General_CI_AS = P.Size
ORDER BY
CASE
    WHEN P.Size = 'S' THEN 44
    WHEN P.Size = 'M' THEN 46
    WHEN P.Size = 'L' THEN 48
	WHEN P.Size = 'XL' THEN 50
    ELSE P.Size
  END
DESC;

DROP TABLE #SizeTable;

/*4*/

select P.ProductID, P.Name AS ProductName, C.ParentProductCategoryName AS ParentCategory, C.ProductCategoryName AS Category
from SalesLT.Product AS P
CROSS APPLY dbo.ufnGetAllCategories() AS C
WHERE P.ProductCategoryID = C.ProductCategoryID
ORDER BY C.ProductCategoryName, C.ParentProductCategoryName, P.Name;

/*TASK 2*/

/*1*/

SELECT CompanyContact, Revenue
FROM (
    SELECT 
        CONCAT(C.CompanyName, ' (', C.FirstName, ' ', C.LastName, ')') AS CompanyContact,
        SUM(SOH.TotalDue) AS Revenue
    FROM 
        SalesLT.Customer AS C
    JOIN 
        SalesLT.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
	GROUP BY C.CompanyName, C.FirstName, C.LastName
) AS CustomerRevenue
ORDER BY CompanyContact;

/*2*/
WITH CustomerRevenue AS (
    SELECT 
        CONCAT(C.CompanyName, ' (', C.FirstName, ' ', C.LastName, ')') AS CompanyContact,
        SUM(SOH.TotalDue) AS Revenue
    FROM 
        SalesLT.Customer AS C
    JOIN 
        SalesLT.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
	GROUP BY C.CompanyName, C.FirstName, C.LastName
)

SELECT CompanyContact, Revenue
FROM CustomerRevenue
ORDER BY CompanyContact;