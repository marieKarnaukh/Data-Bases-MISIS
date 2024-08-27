select * from SalesLT.Product;

/*Task 1*/

/*1*/
select ProductID, UPPER(Name) AS ProductName, CAST(ROUND(Weight, 0) AS int) AS ApproxWeight
from SalesLT.Product;

/*2*/
select ProductID, UPPER(Name) AS ProductName, CAST(ROUND(Weight, 0) AS int) AS ApproxWeight, 
FORMAT(SellStartDate, 'MMMM') AS SellStartMonth, FORMAT(SellStartDate, 'yyyy') AS SellStartYear
from SalesLT.Product;

/*3*/
select ProductID, UPPER(Name) AS ProductName, CAST(ROUND(Weight, 0) AS int) AS ApproxWeight, 
FORMAT(SellStartDate, 'MMMM') AS SellStartMonth, FORMAT(SellStartDate, 'yyyy') AS SellStartYear, LEFT(ProductNumber, 2) AS ProductType
from SalesLT.Product;

/*4*/
select ProductID, UPPER(Name) AS ProductName, CAST(ROUND(Weight, 0) AS int) AS ApproxWeight, 
FORMAT(SellStartDate, 'MMMM') AS SellStartMonth, FORMAT(SellStartDate, 'yyyy') AS SellStartYear, LEFT(ProductNumber, 2) AS ProductType
from SalesLT.Product
WHERE ISNUMERIC(Size) = 1;

/*Task 2*/

select * from SalesLT.SalesOrderHeader;
select * from SalesLT.SalesOrderDetail;
select * from SalesLT.Customer;

/*1*/
select C.CompanyName, SOH.TotalDue AS Revenue, RANK() OVER (ORDER BY TotalDue DESC) AS RankByRevenue
from SalesLT.SalesOrderHeader AS SOH JOIN SalesLT.Customer AS C 
ON (SOH.CustomerID = C.CustomerID);

/*Task 3*/

select RANK() OVER (ORDER BY ListPrice DESC) AS RankByPrice, ListPrice
from SalesLT.Product;

select AVG(ListPrice) AS avgPrice
from SalesLT.Product
where ProductID > 500;

/*1*/
SELECT Product.Name, SUM(SalesOrderDetail.LineTotal) AS TotalRevenue
FROM SalesLT.Product
JOIN SalesLT.SalesOrderDetail
ON Product.ProductID = SalesOrderDetail.ProductID
GROUP BY Product.Name
ORDER BY TotalRevenue DESC;

/*2*/
SELECT Product.Name, SUM(SalesOrderDetail.LineTotal) AS TotalRevenue
FROM SalesLT.Product
JOIN SalesLT.SalesOrderDetail
ON Product.ProductID = SalesOrderDetail.ProductID
WHERE Product.ListPrice > 1000
GROUP BY Product.Name
ORDER BY TotalRevenue DESC;

/*3*/
SELECT Product.Name, SUM(SalesOrderDetail.LineTotal) AS TotalRevenue
FROM SalesLT.Product
JOIN SalesLT.SalesOrderDetail
ON Product.ProductID = SalesOrderDetail.ProductID
GROUP BY Product.Name
HAVING SUM(SalesOrderDetail.LineTotal) > 20000
ORDER BY TotalRevenue DESC;
