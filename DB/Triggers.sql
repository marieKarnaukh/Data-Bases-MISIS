CREATE TRIGGER tr_UpdateStudentCount
ON �������
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @GroupID INT;
    DECLARE @StudentCount INT;

    DECLARE Group_Cursor CURSOR FOR
    SELECT DISTINCT ID_������
    FROM inserted
    UNION
    SELECT DISTINCT ID_������
    FROM deleted;

    OPEN Group_Cursor;

    FETCH NEXT FROM Group_Cursor INTO @GroupID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @StudentCount = COUNT(ID_��������)
        FROM �������
        WHERE ID_������ = @GroupID;

        UPDATE ������
        SET ����������_��������� = @StudentCount
        WHERE ID_������ = @GroupID;

        FETCH NEXT FROM Group_Cursor INTO @GroupID;
    END;

    CLOSE Group_Cursor;
    DEALLOCATE Group_Cursor;
END;

CREATE TRIGGER tr_ReplaceTeacherInSchedule
ON �������������
INSTEAD OF DELETE
AS
BEGIN
    CREATE TABLE #DeletedTeachers (
        ID_������������� INT
    );

    INSERT INTO #DeletedTeachers (ID_�������������)
    SELECT ID_�������������
    FROM DELETED;

    UPDATE ����������_�������
    SET ID_������������� = (
        SELECT TOP 1 ID_�������������
        FROM �������������
        WHERE ID_������������� <> (SELECT ID_������������� FROM #DeletedTeachers)
    )
    WHERE ID_������������� IN (SELECT ID_������������� FROM #DeletedTeachers);

    DROP TABLE #DeletedTeachers;

	UPDATE �������
    SET ID_��������_������������ = NULL
    WHERE ID_��������_������������ IN (SELECT ID_������������� FROM deleted);

	DELETE FROM �������������
    WHERE ID_������������� IN (SELECT ID_������������� FROM DELETED);
END;

CREATE TRIGGER tr_UpdateTeacherSalary
ON �������������
AFTER INSERT, UPDATE
AS
BEGIN
    
    UPDATE ���������
    SET ����� = ROUND(���������.����� * POWER(1.05, i.����), 2)
    FROM ���������
    INNER JOIN inserted i ON ���������.ID_��������� = i.ID_�������������
    WHERE ���������.ID_��������� = i.ID_�������������;
END;

/*SELECT 
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    create_date AS CreationDate,
    modify_date AS LastModifiedDate
FROM sys.triggers;

DROP TRIGGER tr_UpdateStudentCount;*/
