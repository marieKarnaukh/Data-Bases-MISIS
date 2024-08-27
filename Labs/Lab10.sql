/*Task 1*/

/*1*/

--pr_InsertSalesOrderHeader
/*
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
*/

EXEC SalesLT.pr_InsertSalesOrderHeader '2023-11-04', '2023-11-11', 1;

/*2*/

--pr_AddProductToOrder
/*
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
*/

EXEC SalesLT.pr_AddProductToOrder 71949, 760, 1, 782.99;
EXEC SalesLT.pr_AddProductToOrder 0, 760, 1, 782.99;


/*Task 2*/

DECLARE @MarketAveragePrice money = 2000;
DECLARE @MaxAcceptablePrice money = 5000;
DECLARE @BikeCategoryID int;

-- Получим идентификатор категории "Bikes"
SELECT @BikeCategoryID = ProductCategoryID
FROM SalesLT.ProductCategory
WHERE Name = 'Bikes';

-- Переменные для новой средней и максимальной цен
DECLARE @NewAveragePrice money = 0;
DECLARE @NewMaxPrice money = 0;

WHILE (@NewAveragePrice < @MarketAveragePrice AND @NewMaxPrice < @MaxAcceptablePrice)
BEGIN
    -- Обновляем цены на велосипеды
    UPDATE SalesLT.Product
    SET ListPrice = ListPrice * 1.10
	FROM SalesLT.Product AS P
	JOIN SalesLT.ProductCategory AS PC
	ON (P.ProductCategoryID = PC.ProductCategoryID)
    WHERE PC.ParentProductCategoryID = @BikeCategoryID;

    -- Рассчитываем новую среднюю цену для велосипедов
    SELECT @NewAveragePrice = AVG(ListPrice)
    FROM SalesLT.Product AS P
	JOIN SalesLT.ProductCategory AS PC
	ON (P.ProductCategoryID = PC.ProductCategoryID)
    WHERE PC.ParentProductCategoryID = @BikeCategoryID;

    -- Рассчитываем новую максимальную цену для велосипедов
    SELECT @NewMaxPrice = MAX(ListPrice)
    FROM SalesLT.Product AS P
    JOIN SalesLT.ProductCategory AS PC
	ON (P.ProductCategoryID = PC.ProductCategoryID)
    WHERE PC.ParentProductCategoryID = @BikeCategoryID;
END;

PRINT 'New Average Price: ' + CONVERT(NVARCHAR(50), @NewAveragePrice);
PRINT 'New Max Price: ' + CONVERT(NVARCHAR(50), @NewMaxPrice);

DECLARE @tmp int = 2;
WHILE @tmp <=10
BEGIN
	PRINT @tmp;
	set @tmp = @tmp + 2;
END
 
