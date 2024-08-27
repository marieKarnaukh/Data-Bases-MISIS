/*Task 1*/

/*1*/
DECLARE @TableName NVARCHAR(128) = 'Product'
DECLARE @SchemaName NVARCHAR(128) = 'SalesLT'

DECLARE @SqlQuery NVARCHAR(MAX)
SET @SqlQuery = '
    SELECT COLUMN_NAME, DATA_TYPE
    FROM ' + DB_NAME() + '.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = N''' + @TableName + '''
        AND TABLE_SCHEMA = N''' + @SchemaName + '''
        AND DATA_TYPE IN (''char'', ''nchar'', ''varchar'', ''nvarchar'', ''text'', ''ntext'')'

EXEC (@SqlQuery)


/*2*/
DECLARE @TableName_ NVARCHAR(128) = 'Product'
DECLARE @SchemaName_ NVARCHAR(128) = 'SalesLT'
DECLARE @DatabaseName_ NVARCHAR(128) = DB_NAME()
DECLARE @SearchValue NVARCHAR(255) = 'Bike'

DECLARE columnCursor CURSOR FOR
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName_ 
	  AND TABLE_SCHEMA = @SchemaName_
	  AND TABLE_CATALOG = @DatabaseName_
	  AND DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')

DECLARE @ColumnName NVARCHAR(128)
DECLARE @ColumnType NVARCHAR(128)
DECLARE @SqlQuery_ NVARCHAR(MAX)

OPEN columnCursor

FETCH NEXT FROM columnCursor INTO @ColumnName, @ColumnType
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SqlQuery_ = '
        SELECT *
        FROM ' + @SchemaName_ + '.' + @TableName_ + '
        WHERE ' + @ColumnName + ' LIKE ''%' + @SearchValue + '%'''

    PRINT @SqlQuery_

    EXEC (@SqlQuery_)

    FETCH NEXT FROM columnCursor INTO @ColumnName, @ColumnType
END

CLOSE columnCursor
DEALLOCATE columnCursor

/*Task 2*/

/*1*/
DECLARE @RowCount INT

EXEC @RowCount = SalesLT.uspFindStringInTable @schema = 'SalesLT', @table = 'Product', @stringToFind = 'Bike'

PRINT 'Number of Rows: ' + CAST(@RowCount AS NVARCHAR(10))

/*2*/
DECLARE @stringToFind NVARCHAR(2000)
SET @stringToFind = 'Bikes'

DECLARE @SqlQuery1 NVARCHAR(MAX)

CREATE TABLE #SearchResults (TableName NVARCHAR(128), Row_Count INT)

SELECT @SqlQuery1 = 
    STUFF((
        SELECT CHAR(13) +
            'INSERT INTO #SearchResults (TableName, Row_Count)' +
            'SELECT ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + ' AS TableName, COUNT(*) AS Row_Count ' +
            'FROM ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + ' ' +
            'WHERE ' + COLUMN_NAME + ' LIKE ''%' + @stringToFind + '%'' '
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')

EXEC sp_executesql @SqlQuery1

SELECT *
FROM #SearchResults

DROP TABLE #SearchResults


