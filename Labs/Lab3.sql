/*
select * from SalesLT.Customer;
select * from SalesLT.Product;
select * from SalesLT.SalesOrderHeader;
select * from SalesLT.Address;
select * from SalesLT.CustomerAddress;
*/

/*Task 1*/

/*1*/

select C.CompanyName, S.SalesOrderID, S.TotalDue
from SalesLT.Customer AS C JOIN SalesLT.SalesOrderHeader AS S
ON (C.CustomerID = S.CustomerID);

/*2*/
select C.CompanyName, S.SalesOrderID, S.TotalDue, CONCAT(A.AddressLine1, ISNULL(A.AddressLine2, '')) AS MainOfficeAddress, 
		A.City, A.StateProvince, A.PostalCode, A.CountryRegion  
from SalesLT.Customer AS C 
JOIN SalesLT.SalesOrderHeader AS S ON (C.CustomerID = S.CustomerID)
JOIN SalesLT.CustomerAddress AS CA ON (C.CustomerID = CA.CustomerID)
JOIN SalesLT.Address AS A ON (CA.AddressID = A.AddressID)
WHERE CA.AddressType = 'Main Office';

/*Task 2*/

/*1*/
select C.CompanyName, CONCAT(C.FirstName, ' ', C.LastName) AS Name, C.Phone, S.SalesOrderID, S.TotalDue
from SalesLT.Customer AS C
LEFT JOIN SalesLT.SalesOrderHeader AS S ON (C.CustomerID = S.CustomerID)
ORDER BY S.SalesOrderID DESC;

/*2*/
select C.CustomerID, C.CompanyName, CONCAT(C.FirstName, ' ', C.LastName) AS Name, C.Phone
from SalesLT.Customer AS C
LEFT JOIN SalesLT.CustomerAddress AS CA ON (C.CustomerID = CA.CustomerID)
WHERE CA.CustomerID IS NULL;

/*3*/
select C.CustomerID, P.ProductID
from SalesLT.Customer AS C
FULL JOIN SalesLT.SalesOrderHeader AS SOH ON (C.CustomerID = SOH.CustomerID)
FULL JOIN SalesLT.SalesOrderDetail AS SOD ON (SOH.SalesOrderID = SOD.SalesOrderID)
FULL JOIN SalesLT.Product AS P ON (SOD.ProductID = P.ProductID)
WHERE C.CustomerID IS NULL OR P.ProductID IS NULL;