CREATE FUNCTION fn_CreateScheduleForTeacher (@Name NVARCHAR(50), @SecondName NVARCHAR(50), @Surname NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
		������,
        FORMAT(�����_������, N'hh\:mm') AS �����_������,
		FORMAT(�����_���������, N'hh\:mm') AS �����_���������,
        �����������, 
        �������, 
        �����, 
        �������, 
        �������
    FROM
    (
        SELECT
			����.�������_������_������ AS ������,
            ����.�����_������,
            ����.�����_���������,
            ����.����_������,
            CONCAT(������.��������_������, ' "', ����������.��������_����������, '" ', ����������_�������.�����_���������) AS ����������
			
        FROM ����������_�������
        JOIN ������������� ON ����������_�������.ID_������������� = �������������.ID_�������������
		JOIN ��������� ON �������������.ID_���������� = ���������.ID_����������
        JOIN ���� ON ����������_�������.ID_���� = ����.ID_����
        JOIN ���������� ON ����������_�������.ID_���������� = ����������.ID_����������
        JOIN ������ ON ����������_�������.ID_������ = ������.ID_������
        WHERE ���������.��� = @Name AND ���������.������� = @Surname AND ���������.�������� = @SecondName
    ) AS SourceTable
    PIVOT
    (
        MAX(����������) FOR ����_������ IN ([�����������], [�������], [�����], [�������], [�������])
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
            ���������.ID_����������,
            ���������.��� AS ���������_���,
            ���������.������� AS ���������_�������,
            ���������.�������� AS ���������_��������,
            ���������.�����������_�����,
            ���������.�����_��������,
            ���������.��������_���������
        FROM
            ���������
        INNER JOIN ��������� ON ���������.ID_��������� = ���������.ID_���������
        WHERE
            (@FirstName IS NULL OR ���������.��� = @FirstName)
            AND (@LastName IS NULL OR ���������.������� = @LastName)
            AND (@MiddleName IS NULL OR ���������.�������� = @MiddleName)
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
            ����������.ID_����������,
            ����������.��������_����������,
            ����������.�����_��������,
            ����������.����_��������,
            ����������.����_������������,
            ����������.����_������,
            ����������.����������_��������_������
        FROM
            ����������
        INNER JOIN �����������_���������� ON ����������.ID_�����������_���������� = �����������_����������.ID_�����������_����������
        WHERE
            �����������_����������.��������_�����������_���������� = @DirectionName
    )
    SELECT * FROM DirectionDisciplines ORDER BY �����_��������
    OFFSET 0 ROWS
);


CREATE FUNCTION fn_CalculateWorkloadForTeacher(@TeacherID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalWorkload INT = 0;

    SELECT @TotalWorkload = COUNT(*) * 2
    FROM ����������_�������
    WHERE ID_������������� = @TeacherID;

    RETURN @TotalWorkload * 2;
END;

CREATE FUNCTION fn_GetStudentsByGroup
    (@GroupName NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        �������.ID_��������,
        �������.��� AS ���,
        �������.������� AS �������,
        �������.�������� AS ��������,
        �������.����_��������,
        �������.�����������_�����,
        ������.��������_������
    FROM
        �������
    JOIN ������ ON �������.ID_������ = ������.ID_������
    WHERE
        ������.��������_������ = @GroupName
);

