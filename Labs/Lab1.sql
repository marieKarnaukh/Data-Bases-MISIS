/*Task 1*/
               
/*1*/
select * from SalesLT.Customer;

/*2*/
select
	ISNULL(Title, '') + FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName + ' ' + ISNULL(Suffix, '') AS FullName
from SalesLT.Customer;

/*3*/
select 
	SalesPerson, ISNULL(Title, '') + FirstName AS CustomerName, Phone
from SalesLT.Customer;

/*Task 2*/

/*1*/
select
	CAST(CustomerID AS varchar) + ': ' + CompanyName AS CustomerCompany
from SalesLT.Customer;

/*2*/

/* select * from SalesLT.SalesOrderHeader; */

select
	CAST(SalesOrderID AS varchar) + ' (' +  CAST(RevisionNumber AS varchar) + ')' AS OrderRevision,
	CAST(OrderDate AS date) AS OrderDate
from SalesLT.SalesOrderHeader;

/*Task 3*/

/*1*/
select
	FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS CustomerName
from SalesLT.Customer;

/*2*/
UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;

select 
	CustomerID, ISNULL(EmailAddress, Phone) AS PrimaryContact
from SalesLT.Customer;

/*3*/
UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

select
	SalesOrderID, OrderDate, IIF(ShipDate IS NOT NULL, 'Shipped', 'Awaiting Shipment') AS ShippingStatus
from SalesLT.SalesOrderHeader;