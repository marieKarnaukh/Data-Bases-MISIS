/*Task 1*/
select * from SalesLT.Product;

/*1*/
select ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice > (SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail)
GROUP BY ProductID, Name, ListPrice;

/*2*/
select ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice >= 100 AND 
(select MIN(UnitPrice) from SalesLT.SalesOrderDetail WHERE (SalesLT.Product.ProductID = SalesLT.SalesOrderDetail.ProductID)) < 100
GROUP BY ProductID, Name, ListPrice;

/*3*/
SELECT ProductID, Name, StandardCost, ListPrice, 
(select AVG(UnitPrice) from SalesLT.SalesOrderDetail WHERE SalesLT.Product.ProductID = SalesLT.SalesOrderDetail.ProductID) AS AvgSellingPrice
FROM SalesLT.Product
GROUP BY ProductID, Name, StandardCost, ListPrice;


/*4*/
SELECT ProductID, Name, StandardCost, ListPrice, 
(select AVG(UnitPrice) from SalesLT.SalesOrderDetail WHERE SalesLT.Product.ProductID = SalesLT.SalesOrderDetail.ProductID) AS AvgSellingPrice
FROM SalesLT.Product
GROUP BY ProductID, Name, StandardCost, ListPrice
HAVING ListPrice > (select AVG(UnitPrice) from SalesLT.SalesOrderDetail WHERE SalesLT.Product.ProductID = SalesLT.SalesOrderDetail.ProductID);

/*Task 2*/

/*1*/
SELECT soh.SalesOrderID, ci.CustomerID, ci.FirstName, ci.LastName, soh.TotalDue
FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS ci
ORDER BY soh.SalesOrderID;

/*2*/
SELECT ci.CustomerID, ci.FirstName, ci.LastName, a.AddressLine1, a.City
FROM SalesLT.CustomerAddress ca
JOIN SalesLT.Address a
ON ca.AddressID = a.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS ci
ORDER BY ci.CustomerID;
