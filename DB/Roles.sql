-- Создание ролей
CREATE ROLE db_admin;
CREATE ROLE db_user;
CREATE ROLE role_teacher;
CREATE ROLE role_student;
CREATE ROLE role_group_curator;

-- Назначение прав для дефолтных ролей
GRANT CONTROL TO db_admin;
GRANT SELECT, INSERT, UPDATE, DELETE TO db_user;

-- Назначение прав для пользовательских ролей
GRANT SELECT, INSERT, UPDATE, DELETE ON Сотрудник TO role_teacher;
GRANT SELECT ON Студент TO role_student;
GRANT SELECT, UPDATE ON Группа TO role_group_curator;

-- Создание пользователей
CREATE LOGIN user1 WITH PASSWORD = 'password1';
CREATE LOGIN user2 WITH PASSWORD = 'password2';
CREATE LOGIN user3 WITH PASSWORD = 'password3';
CREATE LOGIN user4 WITH PASSWORD = 'password4';
CREATE LOGIN user5 WITH PASSWORD = 'password5';
CREATE LOGIN user6 WITH PASSWORD = 'password6';
CREATE LOGIN user7 WITH PASSWORD = 'password7';
CREATE LOGIN user8 WITH PASSWORD = 'password8';
CREATE LOGIN user9 WITH PASSWORD = 'password9';
CREATE LOGIN user10 WITH PASSWORD = 'password10';

-- Создание учетных записей пользователей в базе данных
CREATE USER user1 FOR LOGIN user1;
CREATE USER user2 FOR LOGIN user2;
CREATE USER user3 FOR LOGIN user3;
CREATE USER user4 FOR LOGIN user4;
CREATE USER user5 FOR LOGIN user5;
CREATE USER user6 FOR LOGIN user6;
CREATE USER user7 FOR LOGIN user7;
CREATE USER user8 FOR LOGIN user8;
CREATE USER user9 FOR LOGIN user9;
CREATE USER user10 FOR LOGIN user10;

-- Назначение дефолтных ролей пользователям
ALTER USER user1 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user2 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user3 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user4 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user5 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user6 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user7 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user8 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user9 WITH DEFAULT_SCHEMA = dbo;
ALTER USER user10 WITH DEFAULT_SCHEMA = dbo;

-- Назначение пользовательских ролей пользователям
ALTER ROLE db_admin ADD MEMBER user1;
ALTER ROLE db_admin ADD MEMBER user2;
ALTER ROLE db_user ADD MEMBER user3;
ALTER ROLE db_user ADD MEMBER user4;
ALTER ROLE db_user ADD MEMBER user5;
ALTER ROLE db_user ADD MEMBER user6;
ALTER ROLE db_user ADD MEMBER user7;
ALTER ROLE db_user ADD MEMBER user8;
ALTER ROLE db_user ADD MEMBER user9;
ALTER ROLE db_user ADD MEMBER user10;
ALTER ROLE role_teacher ADD MEMBER user1;
ALTER ROLE role_teacher ADD MEMBER user2;
ALTER ROLE role_student ADD MEMBER user3;
ALTER ROLE role_student ADD MEMBER user4;
ALTER ROLE role_group_curator ADD MEMBER user5;
ALTER ROLE role_group_curator ADD MEMBER user6;
