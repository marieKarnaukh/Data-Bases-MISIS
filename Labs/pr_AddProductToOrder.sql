CREATE PROCEDURE SalesLT.pr_AddProductToOrder
    @OrderID INT,
    @ProductID INT,
    @Quantity INT,
    @UnitPrice money
AS
BEGIN
    IF EXISTS (SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
    BEGIN
        INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
        VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice);
    END
    ELSE
    BEGIN
        PRINT 'The order does not exist.';
    END
END;
