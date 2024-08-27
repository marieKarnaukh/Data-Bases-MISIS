CREATE PROCEDURE pr_AddNewStudent (
    @Дата_рождения DATE,
    @Имя NVARCHAR(50),
    @Фамилия NVARCHAR(50),
    @Отчество NVARCHAR(50) = NULL,
    @ID_группы INT = NULL,
    @ID_научного_руководителя INT = NULL
)
AS
BEGIN
    DECLARE @SelectedGroup INT;

    IF @ID_группы IS NULL
    BEGIN
        WITH SelectedGroup AS (
            SELECT TOP 1 ID_группы
            FROM Группа
            ORDER BY Количество_студентов ASC
        )
        SELECT @SelectedGroup = ID_группы FROM SelectedGroup;
    END

    INSERT INTO Студент (Имя, Фамилия, Отчество, ID_группы, Дата_рождения, ID_научного_руководителя)
    VALUES (@Имя, @Фамилия, @Отчество, @SelectedGroup, @Дата_рождения, @ID_научного_руководителя);

    DECLARE @ID INT = SCOPE_IDENTITY();
    DECLARE @Электронная_почта NVARCHAR(255)= CONCAT(@ID, '@example.com');

    UPDATE Студент
    SET Электронная_почта = @Электронная_почта
    WHERE ID_студента = @ID;

    PRINT CONCAT('Студент успешно добавлен в ', @SelectedGroup, ' группу.');
END;


CREATE PROCEDURE pr_AddNewEmployee (
    @ID_должности INT,
    @Имя NVARCHAR(50),
    @Фамилия NVARCHAR(50),
    @Отчество NVARCHAR(50) = NULL,
    @Электронная_почта NVARCHAR(255) = NULL,
    @Номер_телефона NVARCHAR(20) = NULL,
    @Стаж INT = NULL,
    @Научная_степень NVARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Должность WHERE ID_должности = @ID_должности)
		BEGIN
			THROW 50000, 'Должности с таким ID не существует', 1;
		END

		BEGIN TRANSACTION
			INSERT INTO Сотрудник (ID_должности, Имя, Фамилия, Отчество, Электронная_почта, Номер_телефона)
			VALUES (@ID_должности, @Имя, @Фамилия, @Отчество, @Электронная_почта, @Номер_телефона);

			DECLARE @ID_сотрудника INT;
			SET @ID_сотрудника = SCOPE_IDENTITY();

			DECLARE @Название_должности NVARCHAR(255) = (
				SELECT Название_должности
				FROM Должность
				JOIN Сотрудник ON Сотрудник.ID_должности = Должность.ID_должности
				WHERE ID_сотрудника = @ID_сотрудника);

			IF @Название_должности IN ('Профессор', 'Доцент', 'Старший преподаватель', 'Преподаватель')
			BEGIN
				INSERT INTO Преподаватель (ID_сотрудника, Стаж, Научная_степень)
				VALUES (@ID_сотрудника, @Стаж, @Научная_степень);
			END
		COMMIT TRANSACTION
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
	END CATCH
END;

CREATE PROCEDURE pr_RemoveEmployee (@ID_сотрудника INT)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM Преподаватель WHERE ID_сотрудника = @ID_сотрудника;

        DELETE FROM Сотрудник WHERE ID_сотрудника = @ID_сотрудника;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
			THROW;
		END
	END CATCH;
END;

CREATE PROCEDURE pr_TransferStudentToAnotherGroup (
    @ID_студента INT,
    @ID_группы_новой INT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Студент WHERE ID_студента = @ID_студента) OR
           NOT EXISTS (SELECT 1 FROM Группа WHERE ID_группы = @ID_группы_новой)
        BEGIN
            ROLLBACK;
            THROW 50000, 'Студент или группа не существует.', 1;
        END

        UPDATE Студент
        SET ID_группы = @ID_группы_новой
        WHERE ID_студента = @ID_студента;

		PRINT CONCAT('Студент успешно переведён в ', @ID_группы_новой, ' группу.');

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

CREATE PROCEDURE sp_CreateScheduleForGroup (@GroupName NVARCHAR(50))
AS
BEGIN
    WITH ScheduleCTE AS (
        SELECT
            Пара.Верхняя_нижняя_неделя AS Неделя,
            Пара.Время_начала,
            Пара.Время_окончания,
            Пара.День_недели,
            CONCAT(LEFT(Сотрудник.Имя, 1), '.', LEFT(ISNULL(Сотрудник.Отчество, ''), 1), '.', Сотрудник.Фамилия, ' "', Дисциплина.Название_дисциплины, '" ', Расписание_занятий.Номер_аудитории) AS Расписание
        FROM Расписание_занятий
        JOIN Преподаватель ON Расписание_занятий.ID_преподавателя = Преподаватель.ID_преподавателя
        JOIN Сотрудник ON Преподаватель.ID_сотрудника = Сотрудник.ID_сотрудника
        JOIN Пара ON Расписание_занятий.ID_пары = Пара.ID_пары
        JOIN Дисциплина ON Расписание_занятий.ID_дисциплины = Дисциплина.ID_дисциплины
        JOIN Группа ON Расписание_занятий.ID_группы = Группа.ID_группы
        WHERE Группа.Название_группы = @GroupName
    )

    SELECT 
        Неделя,
        FORMAT(Время_начала, N'hh\:mm') AS Время_начала,
        FORMAT(Время_окончания, N'hh\:mm') AS Время_окончания,
        Понедельник,
        Вторник,
        Среда,
        Четверг,
        Пятница
    FROM ScheduleCTE
    PIVOT
    (
        MAX(Расписание) FOR День_недели IN ([Понедельник], [Вторник], [Среда], [Четверг], [Пятница])
    ) AS PivotTable
END;

CREATE PROCEDURE pr_RemoveStudent(@StudentID INT)
AS
BEGIN
    DECLARE @Result NVARCHAR(255);

    BEGIN TRY
        DECLARE @GroupID INT;

        SELECT @GroupID = MAX(ID_группы)
        FROM Студент
        WHERE ID_студента = @StudentID;

        IF @GroupID IS NOT NULL
        BEGIN
            DELETE FROM Студент WHERE ID_студента = @StudentID;
            SET @Result = 'Студент успешно удалён';
        END
        ELSE
        BEGIN
            SET @Result = 'Студент с таким ID не найден';
        END
    END TRY

    BEGIN CATCH
        SET @Result = 'Не удалось удалить студента';
    END CATCH

    PRINT @Result;
END;