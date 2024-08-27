CREATE PROCEDURE SalesLT.pr_InsertSalesOrderHeader (
    @OrderDate DATE,
    @DueDate DATE,
    @CustomerID INT )
AS
    DECLARE @NewSalesOrderID INT;

    INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
    VALUES (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');

    SET @NewSalesOrderID = SCOPE_IDENTITY();

    PRINT 'New SalesOrderID: ' + CAST(@NewSalesOrderID AS NVARCHAR);

