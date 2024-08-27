/*Task 1*/

/*1*/

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES ('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE());

select ProductID
from SalesLT.Product
where ProductID = SCOPE_IDENTITY();

select * from SalesLT.Product
where ProductID = SCOPE_IDENTITY();

/*2*/
INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES (4, 'Bells and Horns');

DECLARE @CategoryID INT;
SET @CategoryID = SCOPE_IDENTITY();

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES ('Bicycle Bell', 'BB-RING', 2.47, 4.99, @CategoryID, GETDATE()),
	   ('Bicycle Horn', 'BB-PARP', 1.29, 3.75, @CategoryID, GETDATE());

select P.Name, P.ProductNumber, P.StandardCost, P.ListPrice, P.ProductCategoryID, P.SellStartDate, PC.ParentProductCategoryID
from SalesLT.Product AS P
JOIN SalesLT.ProductCategory AS PC
ON (P.ProductCategoryID = PC.ProductCategoryID)
where P.ProductCategoryID = @CategoryID;

/*Task 2*/

/*1*/
UPDATE SalesLT.Product
SET ListPrice = (ListPrice * 1.1)
from SalesLT.Product AS P
JOIN SalesLT.ProductCategory AS PC
ON (P.ProductCategoryID = PC.ProductCategoryID)
where P.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');

/*2*/
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
from SalesLT.Product AS P
JOIN SalesLT.ProductCategory AS PC
ON (P.ProductCategoryID = PC.ProductCategoryID)
where P.ProductCategoryID = 37 AND P.ProductNumber <> 'LT-L123';

/*Task 3*/

DELETE SalesLT.Product
from SalesLT.Product AS P
JOIN SalesLT.ProductCategory AS PC
ON (P.ProductCategoryID = PC.ProductCategoryID)
where P.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');

DELETE FROM SalesLT.ProductCategory
where ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');


