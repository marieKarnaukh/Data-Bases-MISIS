CREATE PROCEDURE SalesLT.uspFindStringInTable
    @schema sysname,
    @table sysname,
    @stringToFind nvarchar(2000)
AS
BEGIN
    DECLARE columnCursor CURSOR FOR
	SELECT COLUMN_NAME, DATA_TYPE
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @table 
		AND TABLE_SCHEMA = @schema
		AND DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')

	DECLARE @ColumnName NVARCHAR(128)
	DECLARE @ColumnType NVARCHAR(128)
	DECLARE @SqlQuery_ NVARCHAR(MAX)
	DECLARE @RowCountTemp INT = 0

	OPEN columnCursor

	FETCH NEXT FROM columnCursor INTO @ColumnName, @ColumnType
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SqlQuery_ = '
			SELECT *
			FROM ' + @schema + '.' + @table + '
			WHERE ' + @ColumnName + ' LIKE ''%' + @stringToFind + '%'''

		EXEC (@SqlQuery_)

		FETCH NEXT FROM columnCursor INTO @ColumnName, @ColumnType
	END

	CLOSE columnCursor
	DEALLOCATE columnCursor

    RETURN @@ROWCOUNT
END
