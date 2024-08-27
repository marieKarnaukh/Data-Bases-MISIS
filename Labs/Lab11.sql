/*Task 1*/

/*1*/
DECLARE @SalesOrderID int = 0;

IF EXISTS (SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
BEGIN
    DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
    DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
END
ELSE
BEGIN
    DECLARE @MessageText nvarchar(50) = CONCAT('The order ', CAST(@SalesOrderID AS NVARCHAR), ' does not exist');
    THROW 50000, @MessageText, 1;
END;

/*2*/
DECLARE @SalesOrderID_ int = 0;

BEGIN TRY
	IF EXISTS (SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID_)
	BEGIN
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID_;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID_;
	END
	ELSE
	BEGIN
		DECLARE @MessageText_ nvarchar(50) = CONCAT('The order ', CAST(@SalesOrderID_ AS NVARCHAR), ' does not exist');
		THROW 50000, @MessageText_, 1;
	END
END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH;

/*Task 2*/

select * from SalesLT.SalesOrderDetail
where SalesOrderID = 71776;
select * from SalesLT.SalesOrderHeader
where SalesOrderID = 71776;

DECLARE @OrderID int = 71776;

BEGIN TRY
	IF EXISTS (SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
	BEGIN
		BEGIN TRANSACTION;
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
		THROW 50001, 'Error', 1;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
		COMMIT TRANSACTION;
	END
	ELSE
	BEGIN
		DECLARE @Message nvarchar(50) = CONCAT('The order ', CAST(@OrderID AS NVARCHAR), ' does not exist');
		THROW 50000, @Message, 1;
	END
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        THROW;
    END
    ELSE
    BEGIN
        PRINT ERROR_MESSAGE();
    END;
END CATCH;

