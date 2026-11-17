-- Chi dung cho SQL Server Express tren may thuc hanh.
-- Thay <DAT_MAT_KHAU_SQL_CUA_BAN> bang mat khau lab (khong dua mat khau that len GitHub);
-- sau do go dung mat khau nay vao form Ket noi SQL Server.
USE master;
GO
IF SUSER_ID(N'lab2_user') IS NULL
    CREATE LOGIN lab2_user WITH PASSWORD = '<DAT_MAT_KHAU_SQL_CUA_BAN>', CHECK_POLICY = ON;
GO
USE LAB2_MaHoaHienDai;
GO
IF DATABASE_PRINCIPAL_ID(N'lab2_user') IS NULL
    CREATE USER lab2_user FOR LOGIN lab2_user;
GO
IF IS_ROLEMEMBER(N'db_datareader', N'lab2_user') = 0
    ALTER ROLE db_datareader ADD MEMBER lab2_user;
IF IS_ROLEMEMBER(N'db_datawriter', N'lab2_user') = 0
    ALTER ROLE db_datawriter ADD MEMBER lab2_user;
GO
