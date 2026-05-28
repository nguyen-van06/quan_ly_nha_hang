-- ================================================================
-- TÓM TẮT SCRIPT SQL - CHẠY NHANH
-- (Nếu script chính quá dài, copy toàn bộ file này vào SSMS)
-- ================================================================

USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyNhaHang')
BEGIN
	ALTER DATABASE QuanLyNhaHang SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE QuanLyNhaHang;
END
GO
CREATE DATABASE QuanLyNhaHang;
GO
USE QuanLyNhaHang;
GO

-- BẢNG TÀI KHOẢN
CREATE TABLE TaiKhoan (
	MaTK INT PRIMARY KEY IDENTITY(1,1),
	TenDangNhap VARCHAR(50) UNIQUE NOT NULL,
	MatKhau VARCHAR(100) NOT NULL,
	Quyen VARCHAR(30) NOT NULL,
	NgayTao DATETIME DEFAULT GETDATE(),
	TrangThai BIT DEFAULT 1
);

-- BẢNG NHÂN VIÊN
CREATE TABLE NhanVien (
	MaNV VARCHAR(10) PRIMARY KEY,
	HoTen NVARCHAR(100) NOT NULL,
	ChucVu NVARCHAR(50) NOT NULL,
	SDT VARCHAR(15) NOT NULL,
	LuongCoBan BIGINT NOT NULL,
	NgayTao DATETIME DEFAULT GETDATE(),
	TrangThai BIT DEFAULT 1
);

-- BẢNG LOẠI MÓN ĂN
CREATE TABLE LoaiMonAn (
	MaLoai INT PRIMARY KEY IDENTITY(1,1),
	TenLoai NVARCHAR(50) NOT NULL UNIQUE,
	MoTa NVARCHAR(200)
);

-- BẢNG MÓN ĂN
CREATE TABLE MonAn (
	MaMon INT PRIMARY KEY IDENTITY(1,1),
	TenMon NVARCHAR(100) NOT NULL UNIQUE,
	MaLoai INT NOT NULL,
	Gia INT NOT NULL,
	DonVi NVARCHAR(20) DEFAULT N'Phần',
	NgayTao DATETIME DEFAULT GETDATE(),
	TrangThai BIT DEFAULT 1,
	FOREIGN KEY (MaLoai) REFERENCES LoaiMonAn(MaLoai)
);

-- BẢNG BÀN
CREATE TABLE Ban (
	MaBan INT PRIMARY KEY IDENTITY(1,1),
	TenBan NVARCHAR(50) NOT NULL UNIQUE,
	SoChoNgoi INT NOT NULL,
	Tang INT DEFAULT 1,
	TrangThai NVARCHAR(20) DEFAULT N'Trống',
	GhiChu NVARCHAR(200)
);

-- BẢNG KHÁCH HÀNG
CREATE TABLE KhachHang (
	MaKH VARCHAR(10) PRIMARY KEY,
	HoTen NVARCHAR(100) NOT NULL,
	SDT VARCHAR(15) NOT NULL UNIQUE,
	HangThanhVien NVARCHAR(20) DEFAULT N'Đồng',
	DiemThuong INT DEFAULT 0,
	NgayDangKy DATETIME DEFAULT GETDATE(),
	GhiChu NVARCHAR(200),
	TrangThai BIT DEFAULT 1
);

-- BẢNG HÓA ĐƠN
CREATE TABLE HoaDon (
	MaHD VARCHAR(30) PRIMARY KEY,
	MaBan INT NOT NULL,
	MaKH VARCHAR(10),
	MaNV VARCHAR(10) NOT NULL,
	NgayGio DATETIME DEFAULT GETDATE(),
	TongTienGoc BIGINT NOT NULL,
	PhanTramGiamGia INT DEFAULT 0,
	TienGiamGia BIGINT DEFAULT 0,
	TongTienPhaiTra BIGINT NOT NULL,
	DiemThuongTT INT DEFAULT 0,
	PhuongThucTT NVARCHAR(20) DEFAULT N'Tiền mặt',
	TienKhachDua BIGINT DEFAULT 0,
	TienThua BIGINT DEFAULT 0,
	TrangThai NVARCHAR(20) DEFAULT N'Chưa thanh toán',
	FOREIGN KEY (MaBan) REFERENCES Ban(MaBan),
	FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
	FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- BẢNG CHI TIẾT HÓA ĐƠN
CREATE TABLE ChiTietHoaDon (
	MaChiTiet INT PRIMARY KEY IDENTITY(1,1),
	MaHD VARCHAR(30) NOT NULL,
	MaMon INT NOT NULL,
	SoLuong INT NOT NULL,
	DonGia BIGINT NOT NULL,
	ThanhTien BIGINT NOT NULL,
	GhiChu NVARCHAR(200),
	FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
	FOREIGN KEY (MaMon) REFERENCES MonAn(MaMon)
);

-- BẢNG ĐỔI ĐIỂM THƯỞNG
CREATE TABLE DoiDiemThuong (
	MaDoiDiem INT PRIMARY KEY IDENTITY(1,1),
	MaKH VARCHAR(10) NOT NULL,
	DiemDung INT NOT NULL,
	TienGiam BIGINT NOT NULL,
	NgayDoi DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- BẢNG LƯƠNG NHÂN VIÊN
CREATE TABLE LuongNhanVien (
	MaLuong INT PRIMARY KEY IDENTITY(1,1),
	MaNV VARCHAR(10) NOT NULL,
	Thang INT NOT NULL,
	Nam INT NOT NULL,
	LuongCoBan BIGINT NOT NULL,
	PhuCap BIGINT DEFAULT 0,
	KhauTru BIGINT DEFAULT 0,
	LuongThucLinh BIGINT NOT NULL,
	NgayTinhLuong DATETIME DEFAULT GETDATE(),
	TrangThai NVARCHAR(20) DEFAULT N'Chưa thanh toán',
	FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
	UNIQUE (MaNV, Thang, Nam)
);

-- BẢNG THỐNG KÊ HÀNG NGÀY
CREATE TABLE ThongKeNgay (
	MaTK INT PRIMARY KEY IDENTITY(1,1),
	Ngay DATE NOT NULL UNIQUE,
	SoHoaDon INT DEFAULT 0,
	TongDoanhThu BIGINT DEFAULT 0,
	SoKhachHang INT DEFAULT 0,
	GhiChu NVARCHAR(200)
);

-- TẠO INDEX
CREATE INDEX idx_HoaDon_MaBan ON HoaDon(MaBan);
CREATE INDEX idx_HoaDon_MaKH ON HoaDon(MaKH);
CREATE INDEX idx_HoaDon_NgayGio ON HoaDon(NgayGio);
CREATE INDEX idx_ChiTietHoaDon_MaHD ON ChiTietHoaDon(MaHD);
CREATE INDEX idx_KhachHang_SDT ON KhachHang(SDT);

-- DỮ LIỆU KHỞI ĐỘNG
INSERT INTO LoaiMonAn VALUES
(N'Khai vị', N'Các món khai vị nhẹ'),
(N'Lẩu', N'Các loại lẩu nóng'),
(N'Nướng', N'Thực phẩm nướng'),
(N'Các món khác', N'Các món khác'),
(N'Nước ngọt', N'Đồ uống không cồn'),
(N'Bia/Rượu', N'Đồ uống có cồn');

INSERT INTO MonAn VALUES
(N'Lẩu Thái Thập Cẩm', 2, 350000, N'Phần', GETDATE(), 1),
(N'Bò Mỹ Ba Chỉ Nhúng Thêm', 3, 120000, N'Suất', GETDATE(), 1),
(N'Nước Ngọt Coca Cola', 5, 15000, N'Cốc', GETDATE(), 1),
(N'Khoai Tây Chiên Bơ Tỏi', 1, 45000, N'Phần', GETDATE(), 1),
(N'Chạo Tôm', 1, 65000, N'Phần', GETDATE(), 1),
(N'Ghiền Tôm', 1, 75000, N'Phần', GETDATE(), 1),
(N'Gà Nướng Chanh', 3, 85000, N'Phần', GETDATE(), 1),
(N'Cơm Chiên Hải Sản', 4, 95000, N'Phần', GETDATE(), 1),
(N'Bia Hà Nội', 6, 25000, N'Lon', GETDATE(), 1),
(N'Rượu Tây Bắc', 6, 100000, N'Chai', GETDATE(), 1);

INSERT INTO Ban VALUES
(N'01', 4, 1, N'Trống', NULL),
(N'02', 4, 1, N'Trống', NULL),
(N'03', 6, 1, N'Trống', NULL),
(N'04', 6, 1, N'Trống', NULL),
(N'05', 8, 2, N'Trống', NULL),
(N'06', 8, 2, N'Trống', NULL),
(N'07', 2, 1, N'Trống', NULL),
(N'08', 2, 1, N'Trống', NULL);

INSERT INTO NhanVien VALUES
(N'NV001', N'Nguyễn Văn Anh', N'Quản lý', N'0912345678', 15000000, GETDATE(), 1),
(N'NV002', N'Trần Thị Bình', N'Thu ngân', N'0987654321', 8000000, GETDATE(), 1),
(N'NV003', N'Lê Văn Cường', N'Phục vụ bàn', N'0901234567', 6000000, GETDATE(), 1),
(N'NV004', N'Phạm Thị Dung', N'Phục vụ bàn', N'0934567890', 6000000, GETDATE(), 1),
(N'NV005', N'Võ Văn Emm', N'Bếp', N'0945678901', 7000000, GETDATE(), 1);

INSERT INTO TaiKhoan VALUES
(N'admin', N'admin123', N'Quản lý', GETDATE(), 1),
(N'nhanvien1', N'pass123', N'Thu ngân', GETDATE(), 1),
(N'nhanvien2', N'pass123', N'Phục vụ bàn', GETDATE(), 1);

INSERT INTO KhachHang VALUES
(N'KH001', N'Hoàng Anh Tuấn', N'0987654321', N'Vip', 250, GETDATE(), NULL, 1),
(N'KH002', N'Nguyễn Thị Hoa', N'0901234567', N'Vàng', 150, GETDATE(), NULL, 1),
(N'KH003', N'Lê Văn Phong', N'0912345678', N'Bạc', 75, GETDATE(), NULL, 1);

PRINT 'DATABASE CREATED SUCCESSFULLY!';
PRINT 'Tables: 11';
PRINT 'Sample Data: OK';
