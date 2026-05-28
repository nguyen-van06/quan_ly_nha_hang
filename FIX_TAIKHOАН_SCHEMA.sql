-- ================================================================
-- CẬP NHẬT SQL SCHEMA - THÊM DEFAULT CHO CỘT QUYEN
-- ================================================================
-- Chạy script này trên SSMS nếu chưa có DEFAULT

USE QuanLyNhaHang;
GO

-- Kiểm tra xem constraint DEFAULT đã tồn tại chưa
IF NOT EXISTS (SELECT * FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('TaiKhoan') AND NAME LIKE 'DF_TaiKhoan_Quyen%')
BEGIN
	-- Thêm DEFAULT nếu chưa có
	ALTER TABLE TaiKhoan
	ADD CONSTRAINT DF_TaiKhoan_Quyen DEFAULT N'Thu ngân' FOR Quyen;

	PRINT 'DEFAULT constraint đã được thêm cho cột Quyen';
END
ELSE
BEGIN
	PRINT 'DEFAULT constraint đã tồn tại';
END

-- Kiểm tra lại
SELECT 
	c.name AS ColumnName,
	d.definition AS DefaultValue
FROM sys.columns c
LEFT JOIN sys.default_constraints d ON c.default_object_id = d.object_id
WHERE c.object_id = OBJECT_ID('TaiKhoan');

GO
