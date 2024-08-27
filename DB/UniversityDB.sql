DROP DATABASE IF EXISTS UniversityDB;
CREATE DATABASE UniversityDB;
USE UniversityDB;

DROP TABLE IF EXISTS �������;
DROP TABLE IF EXISTS ����������_�������;
DROP TABLE IF EXISTS ������;
DROP TABLE IF EXISTS ����������;
DROP TABLE IF EXISTS �����������_����������;
DROP TABLE IF EXISTS �������_����������;
DROP TABLE IF EXISTS ����;
DROP TABLE IF EXISTS �������������;
DROP TABLE IF EXISTS ���������;
DROP TABLE IF EXISTS ���������;

CREATE TABLE ��������� (
    ID_��������� INT IDENTITY(1,1),
	��������_��������� NVARCHAR(255) NOT NULL,
    ����� INT NOT NULL,
    ������ FLOAT DEFAULT 1.0,

    PRIMARY KEY (ID_���������)
);

CREATE TABLE ��������� (
    ID_���������� INT IDENTITY(1,1),
    ID_��������� INT NOT NULL,
	��� NVARCHAR(50) NOT NULL,
    ������� NVARCHAR(50) NOT NULL,
    �������� NVARCHAR(50) NULL,
    �����������_����� NVARCHAR(255) NULL,
    �����_�������� NVARCHAR(20) NULL,
    
    PRIMARY KEY (ID_����������),
    FOREIGN KEY (ID_���������) REFERENCES ���������(ID_���������)
);

CREATE TABLE ������������� (
    ID_������������� INT IDENTITY(1,1),
    ID_���������� INT NOT NULL,
    ���� INT NULL,
    �������_������� NVARCHAR(50) NULL,

    PRIMARY KEY (ID_�������������),
    FOREIGN KEY (ID_����������) REFERENCES ���������(ID_����������)
);

CREATE TABLE ���� (
	ID_���� INT IDENTITY(1,1),
	����_������ NVARCHAR(15) NOT NULL,
	�����_������ TIME NOT NULL,
	�����_��������� TIME NOT NULL,
	�������_������_������ NVARCHAR(10) NOT NULL,

	PRIMARY KEY (ID_����)
);

CREATE TABLE �������_���������� (
    ID_������_���������� INT IDENTITY(1,1),
    ��������_������_���������� NVARCHAR(50) NOT NULL,
    �����_�������� NVARCHAR(10) DEFAULT '�����' NOT NULL,

    PRIMARY KEY (ID_������_����������)
);

CREATE TABLE �����������_���������� (
    ID_�����������_���������� INT IDENTITY(1,1),
    ID_������_���������� INT NOT NULL,
    ��������_�����������_���������� NVARCHAR(255) NOT NULL,
    �������_����������� NVARCHAR(255) NOT NULL,

    PRIMARY KEY (ID_�����������_����������),
    FOREIGN KEY (ID_������_����������) REFERENCES �������_����������(ID_������_����������)
);

CREATE TABLE ���������� (
    ID_���������� INT IDENTITY(1,1),
    ID_�����������_���������� INT NOT NULL,
	��������_���������� NVARCHAR(255) NOT NULL,
    �����_�������� INT NOT NULL,
    ����_�������� INT NOT NULL,
    ����_������������ INT NOT NULL,
    ����_������ INT NOT NULL,
    ����������_��������_������ INT NOT NULL,

    PRIMARY KEY (ID_����������),
    FOREIGN KEY (ID_�����������_����������) REFERENCES �����������_����������(ID_�����������_����������)
);

CREATE TABLE ������ (
    ID_������ INT IDENTITY(1,1),
    ��������_������ NVARCHAR(50) NOT NULL,
	����������_��������� INT CHECK (����������_��������� <= 30) DEFAULT 0,
	ID_�����������_���������� INT NOT NULL,
    ID_�������� INT NOT NULL,
    �����_����� INT NOT NULL,

    PRIMARY KEY (ID_������),
    FOREIGN KEY (ID_��������) REFERENCES �������������(ID_�������������),
	FOREIGN KEY (ID_�����������_����������) REFERENCES �����������_����������(ID_�����������_����������)
);

CREATE TABLE ����������_������� (
    ID_������������� INT NOT NULL,
    ID_���� INT NOT NULL,
    ID_���������� INT NOT NULL,
    ID_������ INT NOT NULL,
    �����_��������� NVARCHAR(10) NOT NULL,

    PRIMARY KEY (ID_�������������, ID_����),
    FOREIGN KEY (ID_�������������) REFERENCES �������������(ID_�������������),
    FOREIGN KEY (ID_����) REFERENCES ����(ID_����),
    FOREIGN KEY (ID_����������) REFERENCES ����������(ID_����������),
    FOREIGN KEY (ID_������) REFERENCES ������(ID_������)
);

CREATE TABLE ������� (
    ID_�������� INT IDENTITY(2200000, 1),
	��� NVARCHAR(50) NOT NULL,
    ������� NVARCHAR(50) NOT NULL,
    �������� NVARCHAR(50) NULL,
	ID_������ INT NOT NULL,
	����_�������� DATE NOT NULL,
    �����������_����� NVARCHAR(255) NULL,
    ID_��������_������������ INT NULL,

    PRIMARY KEY (ID_��������),
    FOREIGN KEY (ID_��������_������������) REFERENCES �������������(ID_�������������),
    FOREIGN KEY (ID_������) REFERENCES ������(ID_������)
);


-- �������� ����� ��������� ��
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'CopyOfDatabase')
BEGIN
    CREATE DATABASE CopyOfDatabase;
END;

-- �������� ����� ������ ��
BACKUP DATABASE UniversityDB
TO DISK = 'C:\CopyOfDatabase.bak'
WITH COPY_ONLY, INIT, COMPRESSION;

/*
�������
	fn_CreateScheduleForGroup (�������� ������) - ���������� ��� ���������� ������ + *
	fn_CreateScheduleForTeacher (���, �������, ��������) - ���������� ��� ������������� + *
	fn_GetStudentsByGroup (�������� ������) - ��������� ������ ��������� �� ������ ������ + *
	
	fn_GetEmployeePhoneList (��� �� ��������� NULL) - ���������� ������ ���������� ���������� ���������� + *
	fn_GetListOfDisciplines(ID_�����������) - ������ ��������� ��� ������������� �����������  (���������� �� ��������) + *

���������
	pr_AddNewStudent (...) - ���������� ������ �������� + (���� ������ �� �������, �� � ������ � ���������� ���-��� �������) + *
	pr_AddNewEmployee (...) - ���������� ������ ���������� + *
	pr_RemoveStudent (ID_��������) - �������� �������� + *
	pr_RemoveEmployee (ID_����������) - �������� ���������� (����������) + *
	pr_TransferStudentToAnotherGroup (ID_��������, ID_������) - ������� �������� � ������ ������ (����������) + *

�������������
	v_DiplomaStudents - ��������-���������� � �������� �������������� + *
	v_GroupCurator - ���������� � ������� � �� ��������� + *
	v_GetSalary - ������� �������� ����������� + *
	v_TeachersList - ������� ���� �������������� � �� ����������� + *
	
��������
	tr_ReplaceTeacherInSchedule: ��� �������� ���������� � ���������� �������� ������� + ���������� + *

	tr_UpdateStudentCount: ���������� ���������� ��������� + *
	
	tr_UpdateTeacherSalary: ����������� ����� ������������� �� 5% �� ������ ��� ����� + *
*/
