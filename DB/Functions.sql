CREATE FUNCTION fn_CreateScheduleForTeacher (@Name NVARCHAR(50), @SecondName NVARCHAR(50), @Surname NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
		Неделя,
        FORMAT(Время_начала, N'hh\:mm') AS Время_начала,
		FORMAT(Время_окончания, N'hh\:mm') AS Время_окончания,
        Понедельник, 
        Вторник, 
        Среда, 
        Четверг, 
        Пятница
    FROM
    (
        SELECT
			Пара.Верхняя_нижняя_неделя AS Неделя,
            Пара.Время_начала,
            Пара.Время_окончания,
            Пара.День_недели,
            CONCAT(Группа.Название_группы, ' "', Дисциплина.Название_дисциплины, '" ', Расписание_занятий.Номер_аудитории) AS Расписание
			
        FROM Расписание_занятий
        JOIN Преподаватель ON Расписание_занятий.ID_преподавателя = Преподаватель.ID_преподавателя
		JOIN Сотрудник ON Преподаватель.ID_сотрудника = Сотрудник.ID_сотрудника
        JOIN Пара ON Расписание_занятий.ID_пары = Пара.ID_пары
        JOIN Дисциплина ON Расписание_занятий.ID_дисциплины = Дисциплина.ID_дисциплины
        JOIN Группа ON Расписание_занятий.ID_группы = Группа.ID_группы
        WHERE Сотрудник.Имя = @Name AND Сотрудник.Фамилия = @Surname AND Сотрудник.Отчество = @SecondName
    ) AS SourceTable
    PIVOT
    (
        MAX(Расписание) FOR День_недели IN ([Понедельник], [Вторник], [Среда], [Четверг], [Пятница])
    ) AS PivotTable
);

CREATE FUNCTION fn_GetEmployeePhoneList (
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @MiddleName NVARCHAR(50) = NULL
)
RETURNS TABLE
AS
RETURN
(
    WITH FilteredEmployees AS (
        SELECT
            Сотрудник.ID_сотрудника,
            Сотрудник.Имя AS Сотрудник_Имя,
            Сотрудник.Фамилия AS Сотрудник_Фамилия,
            Сотрудник.Отчество AS Сотрудник_Отчество,
            Сотрудник.Электронная_почта,
            Сотрудник.Номер_телефона,
            Должность.Название_должности
        FROM
            Сотрудник
        INNER JOIN Должность ON Сотрудник.ID_должности = Должность.ID_должности
        WHERE
            (@FirstName IS NULL OR Сотрудник.Имя = @FirstName)
            AND (@LastName IS NULL OR Сотрудник.Фамилия = @LastName)
            AND (@MiddleName IS NULL OR Сотрудник.Отчество = @MiddleName)
    )

    SELECT * FROM FilteredEmployees
);

CREATE FUNCTION fn_GetListOfDisciplines (@DirectionName NVARCHAR(255))
RETURNS TABLE
AS
RETURN
(
    WITH DirectionDisciplines AS (
        SELECT
            Дисциплина.ID_дисциплины,
            Дисциплина.Название_дисциплины,
            Дисциплина.Номер_семестра,
            Дисциплина.Часы_практики,
            Дисциплина.Часы_лабораторных,
            Дисциплина.Часы_лекций,
            Дисциплина.Количество_зачётных_единиц
        FROM
            Дисциплина
        INNER JOIN Направление_подготовки ON Дисциплина.ID_направления_подготовки = Направление_подготовки.ID_направления_подготовки
        WHERE
            Направление_подготовки.Название_направления_подготовки = @DirectionName
    )
    SELECT * FROM DirectionDisciplines ORDER BY Номер_семестра
    OFFSET 0 ROWS
);


CREATE FUNCTION fn_CalculateWorkloadForTeacher(@TeacherID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalWorkload INT = 0;

    SELECT @TotalWorkload = COUNT(*) * 2
    FROM Расписание_занятий
    WHERE ID_преподавателя = @TeacherID;

    RETURN @TotalWorkload * 2;
END;

CREATE FUNCTION fn_GetStudentsByGroup
    (@GroupName NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        Студент.ID_студента,
        Студент.Имя AS Имя,
        Студент.Фамилия AS Фамилия,
        Студент.Отчество AS Отчество,
        Студент.Дата_рождения,
        Студент.Электронная_почта,
        Группа.Название_группы
    FROM
        Студент
    JOIN Группа ON Студент.ID_группы = Группа.ID_группы
    WHERE
        Группа.Название_группы = @GroupName
);

