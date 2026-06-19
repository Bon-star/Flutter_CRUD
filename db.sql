-- SQL Server schema for HomeWork assignment

CREATE DATABASE homework_db;
GO

USE homework_db;
GO

CREATE TABLE supplier (
    id      BIGINT IDENTITY(1,1) PRIMARY KEY,
    name    NVARCHAR(255) NOT NULL,
    phone   NVARCHAR(20),
    address NVARCHAR(500)
);
GO

-- Sample data (optional)
INSERT INTO supplier (name, phone, address) VALUES
    (N'Công ty ABC', '0901234567', N'123 Nguyễn Huệ, Q.1, TP.HCM'),
    (N'Nhà cung cấp XYZ', '0987654321', N'456 Lê Lợi, Q.3, TP.HCM');
GO
