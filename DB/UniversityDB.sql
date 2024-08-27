DROP DATABASE IF EXISTS UniversityDB;
CREATE DATABASE UniversityDB;
USE UniversityDB;

DROP TABLE IF EXISTS Студент;
DROP TABLE IF EXISTS Расписание_занятий;
DROP TABLE IF EXISTS Группа;
DROP TABLE IF EXISTS Дисциплина;
DROP TABLE IF EXISTS Направление_подготовки;
DROP TABLE IF EXISTS Уровень_подготовки;
DROP TABLE IF EXISTS Пара;
DROP TABLE IF EXISTS Преподаватель;
DROP TABLE IF EXISTS Сотрудник;
DROP TABLE IF EXISTS Должность;

CREATE TABLE Должность (
    ID_должности INT IDENTITY(1,1),
	Название_должности NVARCHAR(255) NOT NULL,
    Оклад INT NOT NULL,
    Ставка FLOAT DEFAULT 1.0,

    PRIMARY KEY (ID_должности)
);

CREATE TABLE Сотрудник (
    ID_сотрудника INT IDENTITY(1,1),
    ID_должности INT NOT NULL,
	Имя NVARCHAR(50) NOT NULL,
    Фамилия NVARCHAR(50) NOT NULL,
    Отчество NVARCHAR(50) NULL,
    Электронная_почта NVARCHAR(255) NULL,
    Номер_телефона NVARCHAR(20) NULL,
    
    PRIMARY KEY (ID_сотрудника),
    FOREIGN KEY (ID_должности) REFERENCES Должность(ID_должности)
);

CREATE TABLE Преподаватель (
    ID_преподавателя INT IDENTITY(1,1),
    ID_сотрудника INT NOT NULL,
    Стаж INT NULL,
    Научная_степень NVARCHAR(50) NULL,

    PRIMARY KEY (ID_преподавателя),
    FOREIGN KEY (ID_сотрудника) REFERENCES Сотрудник(ID_сотрудника)
);

CREATE TABLE Пара (
	ID_пары INT IDENTITY(1,1),
	День_недели NVARCHAR(15) NOT NULL,
	Время_начала TIME NOT NULL,
	Время_окончания TIME NOT NULL,
	Верхняя_нижняя_неделя NVARCHAR(10) NOT NULL,

	PRIMARY KEY (ID_пары)
);

CREATE TABLE Уровень_подготовки (
    ID_уровня_подготовки INT IDENTITY(1,1),
    Название_уровня_подготовки NVARCHAR(50) NOT NULL,
    Форма_обучения NVARCHAR(10) DEFAULT 'Очная' NOT NULL,

    PRIMARY KEY (ID_уровня_подготовки)
);

CREATE TABLE Направление_подготовки (
    ID_направления_подготовки INT IDENTITY(1,1),
    ID_уровня_подготовки INT NOT NULL,
    Название_направления_подготовки NVARCHAR(255) NOT NULL,
    Область_образования NVARCHAR(255) NOT NULL,

    PRIMARY KEY (ID_направления_подготовки),
    FOREIGN KEY (ID_уровня_подготовки) REFERENCES Уровень_подготовки(ID_уровня_подготовки)
);

CREATE TABLE Дисциплина (
    ID_дисциплины INT IDENTITY(1,1),
    ID_направления_подготовки INT NOT NULL,
	Название_дисциплины NVARCHAR(255) NOT NULL,
    Номер_семестра INT NOT NULL,
    Часы_практики INT NOT NULL,
    Часы_лабораторных INT NOT NULL,
    Часы_лекций INT NOT NULL,
    Количество_зачётных_единиц INT NOT NULL,

    PRIMARY KEY (ID_дисциплины),
    FOREIGN KEY (ID_направления_подготовки) REFERENCES Направление_подготовки(ID_направления_подготовки)
);

CREATE TABLE Группа (
    ID_группы INT IDENTITY(1,1),
    Название_группы NVARCHAR(50) NOT NULL,
	Количество_студентов INT CHECK (Количество_студентов <= 30) DEFAULT 0,
	ID_направления_подготовки INT NOT NULL,
    ID_куратора INT NOT NULL,
    Номер_курса INT NOT NULL,

    PRIMARY KEY (ID_группы),
    FOREIGN KEY (ID_куратора) REFERENCES Преподаватель(ID_преподавателя),
	FOREIGN KEY (ID_направления_подготовки) REFERENCES Направление_подготовки(ID_направления_подготовки)
);

CREATE TABLE Расписание_занятий (
    ID_преподавателя INT NOT NULL,
    ID_пары INT NOT NULL,
    ID_дисциплины INT NOT NULL,
    ID_группы INT NOT NULL,
    Номер_аудитории NVARCHAR(10) NOT NULL,

    PRIMARY KEY (ID_преподавателя, ID_пары),
    FOREIGN KEY (ID_преподавателя) REFERENCES Преподаватель(ID_преподавателя),
    FOREIGN KEY (ID_пары) REFERENCES Пара(ID_пары),
    FOREIGN KEY (ID_дисциплины) REFERENCES Дисциплина(ID_дисциплины),
    FOREIGN KEY (ID_группы) REFERENCES Группа(ID_группы)
);

CREATE TABLE Студент (
    ID_студента INT IDENTITY(2200000, 1),
	Имя NVARCHAR(50) NOT NULL,
    Фамилия NVARCHAR(50) NOT NULL,
    Отчество NVARCHAR(50) NULL,
	ID_группы INT NOT NULL,
	Дата_рождения DATE NOT NULL,
    Электронная_почта NVARCHAR(255) NULL,
    ID_научного_руководителя INT NULL,

    PRIMARY KEY (ID_студента),
    FOREIGN KEY (ID_научного_руководителя) REFERENCES Преподаватель(ID_преподавателя),
    FOREIGN KEY (ID_группы) REFERENCES Группа(ID_группы)
);


-- Создание копии структуры БД
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'CopyOfDatabase')
BEGIN
    CREATE DATABASE CopyOfDatabase;
END;

-- Создание копии данных БД
BACKUP DATABASE UniversityDB
TO DISK = 'C:\CopyOfDatabase.bak'
WITH COPY_ONLY, INIT, COMPRESSION;

/*
Функции
	fn_CreateScheduleForGroup (название группы) - расписание для конкретной группы + *
	fn_CreateScheduleForTeacher (имя, фамилия, отчество) - расписание для преподавателя + *
	fn_GetStudentsByGroup (название группы) - получение списка студентов по номеру группы + *
	
	fn_GetEmployeePhoneList (ФИО по умолчанию NULL) - возвращает список контактной информации сотрудника + *
	fn_GetListOfDisciplines(ID_направления) - список дисциплин для определенного направления  (сортировка по семестру) + *

Процедуры
	pr_AddNewStudent (...) - добавление нового студента + (если группа не указана, то в группу с наименьшим кол-вом человек) + *
	pr_AddNewEmployee (...) - добавление нового сотрудника + *
	pr_RemoveStudent (ID_студента) - удаление студента + *
	pr_RemoveEmployee (ID_сотрудника) - удаление сотрудника (транзакции) + *
	pr_TransferStudentToAnotherGroup (ID_студента, ID_группы) - перевод студента в другую группу (транзакции) + *

Представления
	v_DiplomaStudents - студенты-дипломники с научными руководителями + *
	v_GroupCurator - информация о группах и их кураторах + *
	v_GetSalary - рассчет зарплаты сотрудников + *
	v_TeachersList - списком всех преподавателей и их должностями + *
	
Триггеры
	tr_ReplaceTeacherInSchedule: при удалении сотрудника в расписании заменить препода + расписание + *

	tr_UpdateStudentCount: обновление количества студентов + *
	
	tr_UpdateTeacherSalary: увеличивает оклад преподавателя на 5% за каждый год стажа + *
*/
