/*
select * from SalesLT.Customer;
select * from SalesLT.CustomerAddress;
select * from SalesLT.Address;
*/

/*Task 1*/

/*1*/

SELECT C.CompanyName, A.AddressLine1, A.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS C
INNER JOIN SalesLT.CustomerAddress AS CA ON C.CustomerID = CA.CustomerID
INNER JOIN SalesLT.Address AS A ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Main Office'
ORDER BY C.CompanyName, AddressType;

/*2*/

SELECT C.CompanyName, A.AddressLine1, A.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS C
INNER JOIN SalesLT.CustomerAddress AS CA ON C.CustomerID = CA.CustomerID
INNER JOIN SalesLT.Address AS A ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Shipping'
ORDER BY C.CompanyName, AddressType;

/*3*/

SELECT CompanyName, AddressLine1, City, AddressType
FROM (
  SELECT C.CompanyName, A.AddressLine1, A.City, 'Billing' AS AddressType
  FROM SalesLT.Customer AS C
  INNER JOIN SalesLT.CustomerAddress AS CA ON C.CustomerID = CA.CustomerID
  INNER JOIN SalesLT.Address AS A ON CA.AddressID = A.AddressID
  WHERE CA.AddressType = 'Main Office'
  UNION ALL
  SELECT C.CompanyName, A.AddressLine1, A.City, 'Shipping' AS AddressType
  FROM SalesLT.Customer AS C
  INNER JOIN SalesLT.CustomerAddress AS CA ON C.CustomerID = CA.CustomerID
  INNER JOIN SalesLT.Address AS A ON CA.AddressID = A.AddressID
  WHERE CA.AddressType = 'Shipping'
) AS CombinedAddresses
ORDER BY CompanyName, AddressType;


/*Task 2*/

/*1*/

SELECT C.CompanyName
FROM SalesLT.Customer AS C
WHERE C.CustomerID NOT IN (
  SELECT CustomerID
  FROM SalesLT.CustomerAddress
  WHERE AddressType = 'Shipping'
)
ORDER BY C.CompanyName;

/*2*/

SELECT C.CompanyName
FROM SalesLT.Customer AS C
WHERE C.CustomerID IN (
  SELECT CustomerID
  FROM SalesLT.CustomerAddress
  WHERE AddressType = 'Main Office'
)
AND C.CustomerID IN (
  SELECT CustomerID
  FROM SalesLT.CustomerAddress
  WHERE AddressType = 'Shipping'
)
ORDER BY C.CompanyName;