CREATE PROCEDURE pr_AddNewStudent (
    @����_�������� DATE,
    @��� NVARCHAR(50),
    @������� NVARCHAR(50),
    @�������� NVARCHAR(50) = NULL,
    @ID_������ INT = NULL,
    @ID_��������_������������ INT = NULL
)
AS
BEGIN
    DECLARE @SelectedGroup INT;

    IF @ID_������ IS NULL
    BEGIN
        WITH SelectedGroup AS (
            SELECT TOP 1 ID_������
            FROM ������
            ORDER BY ����������_��������� ASC
        )
        SELECT @SelectedGroup = ID_������ FROM SelectedGroup;
    END

    INSERT INTO ������� (���, �������, ��������, ID_������, ����_��������, ID_��������_������������)
    VALUES (@���, @�������, @��������, @SelectedGroup, @����_��������, @ID_��������_������������);

    DECLARE @ID INT = SCOPE_IDENTITY();
    DECLARE @�����������_����� NVARCHAR(255)= CONCAT(@ID, '@example.com');

    UPDATE �������
    SET �����������_����� = @�����������_�����
    WHERE ID_�������� = @ID;

    PRINT CONCAT('������� ������� �������� � ', @SelectedGroup, ' ������.');
END;


CREATE PROCEDURE pr_AddNewEmployee (
    @ID_��������� INT,
    @��� NVARCHAR(50),
    @������� NVARCHAR(50),
    @�������� NVARCHAR(50) = NULL,
    @�����������_����� NVARCHAR(255) = NULL,
    @�����_�������� NVARCHAR(20) = NULL,
    @���� INT = NULL,
    @�������_������� NVARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM ��������� WHERE ID_��������� = @ID_���������)
		BEGIN
			THROW 50000, '��������� � ����� ID �� ����������', 1;
		END

		BEGIN TRANSACTION
			INSERT INTO ��������� (ID_���������, ���, �������, ��������, �����������_�����, �����_��������)
			VALUES (@ID_���������, @���, @�������, @��������, @�����������_�����, @�����_��������);

			DECLARE @ID_���������� INT;
			SET @ID_���������� = SCOPE_IDENTITY();

			DECLARE @��������_��������� NVARCHAR(255) = (
				SELECT ��������_���������
				FROM ���������
				JOIN ��������� ON ���������.ID_��������� = ���������.ID_���������
				WHERE ID_���������� = @ID_����������);

			IF @��������_��������� IN ('���������', '������', '������� �������������', '�������������')
			BEGIN
				INSERT INTO ������������� (ID_����������, ����, �������_�������)
				VALUES (@ID_����������, @����, @�������_�������);
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

CREATE PROCEDURE pr_RemoveEmployee (@ID_���������� INT)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM ������������� WHERE ID_���������� = @ID_����������;

        DELETE FROM ��������� WHERE ID_���������� = @ID_����������;

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
    @ID_�������� INT,
    @ID_������_����� INT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM ������� WHERE ID_�������� = @ID_��������) OR
           NOT EXISTS (SELECT 1 FROM ������ WHERE ID_������ = @ID_������_�����)
        BEGIN
            ROLLBACK;
            THROW 50000, '������� ��� ������ �� ����������.', 1;
        END

        UPDATE �������
        SET ID_������ = @ID_������_�����
        WHERE ID_�������� = @ID_��������;

		PRINT CONCAT('������� ������� �������� � ', @ID_������_�����, ' ������.');

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
            ����.�������_������_������ AS ������,
            ����.�����_������,
            ����.�����_���������,
            ����.����_������,
            CONCAT(LEFT(���������.���, 1), '.', LEFT(ISNULL(���������.��������, ''), 1), '.', ���������.�������, ' "', ����������.��������_����������, '" ', ����������_�������.�����_���������) AS ����������
        FROM ����������_�������
        JOIN ������������� ON ����������_�������.ID_������������� = �������������.ID_�������������
        JOIN ��������� ON �������������.ID_���������� = ���������.ID_����������
        JOIN ���� ON ����������_�������.ID_���� = ����.ID_����
        JOIN ���������� ON ����������_�������.ID_���������� = ����������.ID_����������
        JOIN ������ ON ����������_�������.ID_������ = ������.ID_������
        WHERE ������.��������_������ = @GroupName
    )

    SELECT 
        ������,
        FORMAT(�����_������, N'hh\:mm') AS �����_������,
        FORMAT(�����_���������, N'hh\:mm') AS �����_���������,
        �����������,
        �������,
        �����,
        �������,
        �������
    FROM ScheduleCTE
    PIVOT
    (
        MAX(����������) FOR ����_������ IN ([�����������], [�������], [�����], [�������], [�������])
    ) AS PivotTable
END;

CREATE PROCEDURE pr_RemoveStudent(@StudentID INT)
AS
BEGIN
    DECLARE @Result NVARCHAR(255);

    BEGIN TRY
        DECLARE @GroupID INT;

        SELECT @GroupID = MAX(ID_������)
        FROM �������
        WHERE ID_�������� = @StudentID;

        IF @GroupID IS NOT NULL
        BEGIN
            DELETE FROM ������� WHERE ID_�������� = @StudentID;
            SET @Result = '������� ������� �����';
        END
        ELSE
        BEGIN
            SET @Result = '������� � ����� ID �� ������';
        END
    END TRY

    BEGIN CATCH
        SET @Result = '�� ������� ������� ��������';
    END CATCH

    PRINT @Result;
END;