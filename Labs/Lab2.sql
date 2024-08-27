/*Task 1*/

/*1*/
select * from SalesLT.Address;

select DISTINCT City, StateProvince
from SalesLT.Address;

/*2*/
select * from SalesLT.Product;

select TOP 10 Percent Name
from SalesLT.Product
ORDER BY Weight DESC;

/*3*/
select Name
from SalesLT.Product
ORDER BY Weight DESC
OFFSET 10 ROWS
FETCH FIRST 100 ROWS ONLY;

/*Task 2*/

/*1*/
select * from SalesLT.Product;

select Name, Color, Size
from SalesLT.Product
WHERE ProductModelID = 1;

/*2*/
select ProductNumber, Name
from SalesLT.Product
WHERE Color IN ('black', 'red', 'white') AND Size IN ('S', 'M');

/*3*/
select ProductNumber, Name, ListPrice
from SalesLT.Product
WHERE ProductNumber LIKE 'BK-%';

/*4*/
select ProductNumber, Name, ListPrice
from SalesLT.Product
WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]';