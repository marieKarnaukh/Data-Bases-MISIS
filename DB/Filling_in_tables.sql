INSERT INTO ��������� (��������_���������, ������, �����)
VALUES
    ('���������', 1, 100000),
    ('������', 1, 80000),
    ('������� �������������', 0.5, 60000),
    ('�������������', 1, 70000),
    ('���������', 0.5, 50000),
    ('��������', 0.5, 40000),
	('������� ���������', 0.5, 55000),
    ('���������� ��������', 1, 90000),
    ('������������ �����������', 0.5, 65000);

INSERT INTO ��������� (ID_���������, ���, �������, ��������, �����������_�����, �����_��������)
VALUES
    (1, '����', '�������', '��������', 'anna@example.com', '+7 (999) 123-45-67'),
    (2, '�������', '������', '�������������', 'dmitry@example.com', '+7 (999) 987-65-43'),
    (3, '�����', '��������', '��������', 'elena@example.com', '+7 (999) 111-22-33'),
    (4, '�������', '������', '���������', 'alexey@example.com', '+7 (999) 555-44-33'),
	(5, '�����', '��������', '����������', 'maria@example.com', '+7 (999) 876-54-32');

INSERT INTO ������������� (ID_����������, ����, �������_�������)
VALUES
    (1, 5, '�������� ����'),
    (2, 8, '������ ����'),
    (3, 3, '�������'),
    (4, 10, '������ ����');

INSERT INTO ���� (����_������, �����_������, �����_���������, �������_������_������)
VALUES
    ('�����������', '09:00', '10:35', '�������'),
    ('�����������', '10:50', '12:25', '�������'),
    ('�����������', '12:40', '14:15', '�������'),
    ('�����������', '14:30', '16:05', '�������'),
    ('�����������', '16:20', '17:55', '�������'),

    ('�������', '09:00', '10:35', '�������'),
    ('�������', '10:50', '12:25', '�������'),
    ('�������', '12:40', '14:15', '�������'),
    ('�������', '14:30', '16:05', '�������'),
    ('�������', '16:20', '17:55', '�������'),

    ('�����', '09:00', '10:35', '�������'),
    ('�����', '10:50', '12:25', '�������'),
    ('�����', '12:40', '14:15', '�������'),
    ('�����', '14:30', '16:05', '�������'),
    ('�����', '16:20', '17:55', '�������'),

    ('�������', '09:00', '10:35', '�������'),
    ('�������', '10:50', '12:25', '�������'),
    ('�������', '12:40', '14:15', '�������'),
    ('�������', '14:30', '16:05', '�������'),
    ('�������', '16:20', '17:55', '�������'),

    ('�������', '09:00', '10:35', '�������'),
    ('�������', '10:50', '12:25', '�������'),
    ('�������', '12:40', '14:15', '�������'),
    ('�������', '14:30', '16:05', '�������'),
    ('�������', '16:20', '17:55', '�������'),

    ('�����������', '09:00', '10:35', '������'),
    ('�����������', '10:50', '12:25', '������'),
    ('�����������', '12:40', '14:15', '������'),
    ('�����������', '14:30', '16:05', '������'),
    ('�����������', '16:20', '17:55', '������'),

    ('�������', '09:00', '10:35', '������'),
    ('�������', '10:50', '12:25', '������'),
    ('�������', '12:40', '14:15', '������'),
    ('�������', '14:30', '16:05', '������'),
    ('�������', '16:20', '17:55', '������'),

    ('�����', '09:00', '10:35', '������'),
    ('�����', '10:50', '12:25', '������'),
    ('�����', '12:40', '14:15', '������'),
    ('�����', '14:30', '16:05', '������'),
    ('�����', '16:20', '17:55', '������'),

    ('�������', '09:00', '10:35', '������'),
    ('�������', '10:50', '12:25', '������'),
    ('�������', '12:40', '14:15', '������'),
    ('�������', '14:30', '16:05', '������'),
    ('�������', '16:20', '17:55', '������'),

    ('�������', '09:00', '10:35', '������'),
    ('�������', '10:50', '12:25', '������'),
    ('�������', '12:40', '14:15', '������'),
    ('�������', '14:30', '16:05', '������'),
    ('�������', '16:20', '17:55', '������');

INSERT INTO �������_���������� (��������_������_����������, �����_��������)
VALUES
    ('�����������', '�����'),
    ('�����������', '�������'),
    
    ('������������', '�����'),
    ('������������', '�������'),
    
    ('�����������', '�����'),
    ('�����������', '�������');

INSERT INTO �����������_���������� (ID_������_����������, ��������_�����������_����������, �������_�����������)
VALUES
    (1, '�������������� ����������', '����������� �����'),
    (1, '��������� � ����������', '������������� �����'),
    (2, '����������', '������������ �����'),
    (2, '��������', '����������� �����'),
    (3, '�����', '����������� �����');

INSERT INTO ���������� (ID_�����������_����������, ��������_����������, 
						�����_��������, ����_��������, ����_������������, 
						����_������, ����������_��������_������)
VALUES
    (1, '���������� ����������������', 1, 20, 30, 60, 5),
    (1, '���� ������', 2, 10, 20, 40, 4),
    (2, '���������', 3, 15, 10, 30, 3),
    (2, '�������������� ������', 4, 30, 15, 45, 6),
    (3, '����������', 5, 5, 25, 35, 3);

INSERT INTO ������ (��������_������, ID_��������, �����_�����, ID_�����������_����������)
VALUES
    ('���-22-1', 1, 2, 1),
	('���-22-2', 1, 2, 1),
	('���-23-1', 1, 1, 1),
	('���-23-2', 1, 1, 1),
    ('����-22-1', 2, 2, 1),
	('����-22-2', 2, 2, 1),
	('����-20-1', 2, 4, 1),
	('����-21-1', 4, 3, 1),
    ('���-22-1', 4, 2, 2);

INSERT INTO ����������_������� (ID_�������������, ID_����, ID_����������, ID_������, �����_���������)
VALUES
    (1, 1, 1, 1, '�-4'),
    (2, 2, 2, 1, '�-613'),
    (3, 3, 3, 1, '�-304'),
    (4, 4, 4, 2, '�-734'),
    (4, 5, 4, 2, '�-112'),
    (3, 6, 3, 2, '�-507'),
    (2, 7, 2, 1, '�-201'),
    (1, 8, 1, 1, '�-409'),
    (4, 10, 4, 1, '�-512'),
    (1, 11, 1, 1, '�-205'),
    (3, 12, 3, 2, '�-402'),
    (2, 13, 2, 1, '�-623'),
    (1, 14, 1, 1, '�-101'),
    (2, 15, 2, 1, '�-202'),
    (3, 16, 3, 3, '�-303'),
    (4, 17, 4, 3, '�-404'),
    (4, 18, 4, 3, '�-505'),
    (1, 19, 1, 1, '�-606'),
    (2, 20, 2, 1, '�-707'),
    (3, 21, 3, 5, '�-808'),
    (4, 22, 4, 5, '�-909'),
    (4, 23, 4, 1, '�-101'),
    (1, 24, 1, 1, '�-202'),
    (2, 25, 2, 3, '�-303'),
    (3, 26, 3, 1, '�-404'),
    (4, 27, 4, 1, '�-505'),
    (4, 28, 4, 6, '�-606'),
    (1, 29, 1, 6, '�-707'),
    (2, 30, 2, 6, '�-808'),
    (3, 31, 3, 9, '�-909'),
    (4, 32, 4, 1, '�-101'),
    (4, 33, 4, 1, '�-202'),
    (1, 34, 1, 1, '�-303'),
    (2, 35, 2, 7, '�-404'),
    (3, 36, 3, 6, '�-505'),
    (4, 37, 4, 6, '�-606'),
    (4, 38, 4, 1, '�-707'),
    (1, 39, 1, 1, '�-808'),
    (2, 40, 2, 1, '�-909'),
    (3, 41, 3, 1, '�-101'),
    (4, 42, 4, 1, '�-202'),
    (4, 43, 4, 3, '�-303'),
    (1, 44, 1, 3, '�-404'),
    (2, 45, 2, 3, '�-505'),
    (3, 46, 3, 6, '�-606'),
    (4, 47, 4, 8, '�-707'),
    (4, 48, 4, 8, '�-808'),
    (1, 49, 1, 1, '�-909'),
    (2, 50, 2, 1, '�-101');

INSERT INTO ������� (���, �������, ��������, ID_������,
					 ����_��������, �����������_�����, ID_��������_������������)
VALUES
    ('�����', '��������', '����������', 1, '1999-09-22', 'maria@example.com', 2),
    ('�����', '��������', '���������', 2, '2001-04-30', 'pavel@example.com', 3),
    ('���������', '������', '����������', 3, '1997-12-18', 'ekaterina@example.com', 4),
    ('�����', '���������', '������������', 4, '1998-06-11', 'artem@example.com', 1),
	('����', '������', '�������������', 1, '1999-02-15', 'ivan@example.com', 4),
    ('�������', '��������', '����������', 1, '2000-11-03', 'natalia@example.com', 4),
    ('�����', '��������', '��������', 1, '1997-08-27', 'denis@example.com', 4),
    ('����������', '��������', '���������', 1, '2001-07-09', 'alexandra@example.com', 3),
    ('������', '������', '����������', 1, '1998-03-18', 'maxim@example.com', 3),
    ('����', '�������', '��������', 1, '1999-05-21', 'anna@example.com', 2),
    ('������', '�����', '���������', 1, '2000-09-30', 'sergey@example.com', 1),
    ('�����', '��������', '��������', 1, '1998-12-14', 'olga@example.com', 2),
    ('�������', '��������', '��������', 1, '2001-01-25', 'dmitriy@example.com', 1),
    ('�����', '���������', '��������', 1, '1999-06-05', 'elena@example.com', 4),
    ('�����', '��������', '���������', 1, '2000-08-17', 'artem@example.com', 4),
    ('��������', '������', '��������', 1, '1997-04-12', 'kristina@example.com', 1),
    ('�����', '���������', '����������', 1, '2001-10-28', 'roman@example.com', 1),
    ('����', '��������', '���������', 1, '1998-07-02', 'yulia@example.com', 1),
    ('���������', '������', '����������', 1, '1999-11-14', 'vladislav@example.com', 1),
    ('���������', '��������', '��������', 1, '2000-02-19', 'anastasia@example.com', 2),
    ('�����', '�����', '����������', 1, '1997-09-23', 'igor@example.com', 2),
    ('������', '��������', '�������������', 1, '2001-12-31', 'marina@example.com', 2),
    ('�������', '�������', '��������', 1, '1998-06-17', 'artemiy@example.com', 3),
    ('�����', '��������', '������������', 1, '1999-03-22', 'elena@example.com', 4);

