CREATE TRIGGER tr_UpdateStudentCount
ON Студент
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @GroupID INT;
    DECLARE @StudentCount INT;

    DECLARE Group_Cursor CURSOR FOR
    SELECT DISTINCT ID_группы
    FROM inserted
    UNION
    SELECT DISTINCT ID_группы
    FROM deleted;

    OPEN Group_Cursor;

    FETCH NEXT FROM Group_Cursor INTO @GroupID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @StudentCount = COUNT(ID_студента)
        FROM Студент
        WHERE ID_группы = @GroupID;

        UPDATE Группа
        SET Количество_студентов = @StudentCount
        WHERE ID_группы = @GroupID;

        FETCH NEXT FROM Group_Cursor INTO @GroupID;
    END;

    CLOSE Group_Cursor;
    DEALLOCATE Group_Cursor;
END;

CREATE TRIGGER tr_ReplaceTeacherInSchedule
ON Преподаватель
INSTEAD OF DELETE
AS
BEGIN
    CREATE TABLE #DeletedTeachers (
        ID_преподавателя INT
    );

    INSERT INTO #DeletedTeachers (ID_преподавателя)
    SELECT ID_преподавателя
    FROM DELETED;

    UPDATE Расписание_занятий
    SET ID_преподавателя = (
        SELECT TOP 1 ID_преподавателя
        FROM Преподаватель
        WHERE ID_преподавателя <> (SELECT ID_преподавателя FROM #DeletedTeachers)
    )
    WHERE ID_преподавателя IN (SELECT ID_преподавателя FROM #DeletedTeachers);

    DROP TABLE #DeletedTeachers;

	UPDATE Студент
    SET ID_научного_руководителя = NULL
    WHERE ID_научного_руководителя IN (SELECT ID_преподавателя FROM deleted);

	DELETE FROM Преподаватель
    WHERE ID_преподавателя IN (SELECT ID_преподавателя FROM DELETED);
END;

CREATE TRIGGER tr_UpdateTeacherSalary
ON Преподаватель
AFTER INSERT, UPDATE
AS
BEGIN
    
    UPDATE Должность
    SET Оклад = ROUND(Должность.Оклад * POWER(1.05, i.Стаж), 2)
    FROM Должность
    INNER JOIN inserted i ON Должность.ID_должности = i.ID_преподавателя
    WHERE Должность.ID_должности = i.ID_преподавателя;
END;

/*SELECT 
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    create_date AS CreationDate,
    modify_date AS LastModifiedDate
FROM sys.triggers;

DROP TRIGGER tr_UpdateStudentCount;*/
