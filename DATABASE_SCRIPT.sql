-- ================================================================
-- HỆ THỐNG QUẢN LÝ NHÀ HÀNG
-- SQL SERVER DATABASE SCRIPT
-- ================================================================

USE master;
GO

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyNhaHang')
BEGIN
    ALTER DATABASE QuanLyNhaHang 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE QuanLyNhaHang;
END
GO

-- Tạo database mới
CREATE DATABASE QuanLyNhaHang;
GO

USE QuanLyNhaHang;
GO

-- ================================================================
-- 1. BẢNG TÀI KHOẢN
-- ================================================================
CREATE TABLE TaiKhoan
(
    MaTK INT PRIMARY KEY IDENTITY(1,1),
    TenDangNhap VARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(100) NOT NULL,
    Quyen NVARCHAR(30) NOT NULL,
    NgayTao DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1
);
GO

-- ================================================================
-- 2. BẢNG NHÂN VIÊN
-- ================================================================
CREATE TABLE NhanVien
(
    MaNV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    LuongCoBan BIGINT NOT NULL,
    NgayTao DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1
);
GO

-- ================================================================
-- 3. BẢNG LOẠI MÓN ĂN
-- ================================================================
CREATE TABLE LoaiMonAn
(
    MaLoai INT PRIMARY KEY IDENTITY(1,1),
    TenLoai NVARCHAR(50) UNIQUE NOT NULL,
    MoTa NVARCHAR(200)
);
GO

-- ================================================================
-- 4. BẢNG MÓN ĂN
-- ================================================================
CREATE TABLE MonAn
(
    MaMon INT PRIMARY KEY IDENTITY(1,1),
    TenMon NVARCHAR(100) UNIQUE NOT NULL,
    MaLoai INT NOT NULL,
    Gia BIGINT NOT NULL,
    DonVi NVARCHAR(20) DEFAULT N'Phần',
    NgayTao DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1,

    FOREIGN KEY (MaLoai) REFERENCES LoaiMonAn(MaLoai)
);
GO

-- ================================================================
-- 5. BẢNG BÀN
-- ================================================================
CREATE TABLE Ban
(
    MaBan INT PRIMARY KEY IDENTITY(1,1),
    TenBan NVARCHAR(50) UNIQUE NOT NULL,
    SoChoNgoi INT NOT NULL,
    Tang INT DEFAULT 1,
    TrangThai NVARCHAR(20) DEFAULT N'Trống',
    GhiChu NVARCHAR(200)
);
GO

-- ================================================================
-- 6. BẢNG KHÁCH HÀNG
-- ================================================================
CREATE TABLE KhachHang
(
    MaKH VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15) UNIQUE NOT NULL,
    HangThanhVien NVARCHAR(20) DEFAULT N'Đồng',
    DiemThuong INT DEFAULT 0,
    NgayDangKy DATETIME DEFAULT GETDATE(),
    GhiChu NVARCHAR(200),
    TrangThai BIT DEFAULT 1
);
GO

-- ================================================================
-- 7. BẢNG HÓA ĐƠN
-- ================================================================
CREATE TABLE HoaDon
(
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
GO

-- ================================================================
-- 8. BẢNG CHI TIẾT HÓA ĐƠN
-- ================================================================
CREATE TABLE ChiTietHoaDon
(
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
GO

-- ================================================================
-- 9. BẢNG ĐỔI ĐIỂM THƯỞNG
-- ================================================================
CREATE TABLE DoiDiemThuong
(
    MaDoiDiem INT PRIMARY KEY IDENTITY(1,1),
    MaKH VARCHAR(10) NOT NULL,

    DiemDung INT NOT NULL,
    TienGiam BIGINT NOT NULL,

    NgayDoi DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
GO

-- ================================================================
-- 10. BẢNG LƯƠNG NHÂN VIÊN
-- ================================================================
CREATE TABLE LuongNhanVien
(
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
GO

-- ================================================================
-- 11. BẢNG THỐNG KÊ NGÀY
-- ================================================================
CREATE TABLE ThongKeNgay
(
    MaTK INT PRIMARY KEY IDENTITY(1,1),

    Ngay DATE UNIQUE NOT NULL,

    SoHoaDon INT DEFAULT 0,
    TongDoanhThu BIGINT DEFAULT 0,
    SoKhachHang INT DEFAULT 0,

    GhiChu NVARCHAR(200)
);
GO

-- ================================================================
-- INDEX
-- ================================================================
CREATE INDEX idx_HoaDon_MaBan ON HoaDon(MaBan);
CREATE INDEX idx_HoaDon_MaKH ON HoaDon(MaKH);
CREATE INDEX idx_HoaDon_NgayGio ON HoaDon(NgayGio);

CREATE INDEX idx_ChiTietHoaDon_MaHD 
ON ChiTietHoaDon(MaHD);

CREATE INDEX idx_KhachHang_SDT 
ON KhachHang(SDT);

CREATE INDEX idx_NhanVien_MaNV 
ON NhanVien(MaNV);

CREATE INDEX idx_MonAn_TenMon 
ON MonAn(TenMon);
GO

-- ================================================================
-- DỮ LIỆU MẪU
-- ================================================================

-- Loại món ăn
INSERT INTO LoaiMonAn (TenLoai, MoTa)
VALUES
(N'Khai vị', N'Món khai vị'),
(N'Lẩu', N'Các món lẩu'),
(N'Nướng', N'Món nướng'),
(N'Món khác', N'Các món khác'),
(N'Nước ngọt', N'Đồ uống'),
(N'Bia/Rượu', N'Đồ uống có cồn');
GO

-- Món ăn
INSERT INTO MonAn (TenMon, MaLoai, Gia, DonVi)
VALUES
(N'Lẩu Thái', 2, 350000, N'Phần'),
(N'Bò Mỹ', 3, 120000, N'Phần'),
(N'Coca Cola', 5, 15000, N'Lon'),
(N'Khoai Tây Chiên', 1, 45000, N'Phần'),
(N'Gà Nướng', 3, 85000, N'Phần');
GO

-- Bàn
INSERT INTO Ban (TenBan, SoChoNgoi, Tang)
VALUES
(N'01', 4, 1),
(N'02', 4, 1),
(N'03', 6, 1),
(N'04', 8, 2);
GO

-- Nhân viên
INSERT INTO NhanVien
(MaNV, HoTen, ChucVu, SDT, LuongCoBan)
VALUES
('NV001', N'Nguyễn Văn A', N'Quản lý', '0911111111', 15000000),
('NV002', N'Trần Thị B', N'Thu ngân', '0922222222', 8000000),
('NV003', N'Lê Văn C', N'Phục vụ', '0933333333', 6000000);
GO

-- Tài khoản
INSERT INTO TaiKhoan
(TenDangNhap, MatKhau, Quyen)
VALUES
('admin', 'admin123', N'Quản lý'),
('thungan', '123456', N'Thu ngân');
GO

-- Khách hàng
INSERT INTO KhachHang
(MaKH, HoTen, SDT, HangThanhVien, DiemThuong)
VALUES
('KH001', N'Hoàng Anh', '0988888888', N'Vàng', 200),
('KH002', N'Nguyễn Hoa', '0977777777', N'Bạc', 100);
GO

-- ================================================================
-- HÓA ĐƠN MẪU
-- ================================================================
DECLARE @MaHD VARCHAR(30);

SET @MaHD = 'HD' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');

INSERT INTO HoaDon
(
    MaHD,
    MaBan,
    MaKH,
    MaNV,
    TongTienGoc,
    TongTienPhaiTra,
    TrangThai
)
VALUES
(
    @MaHD,
    1,
    'KH001',
    'NV002',
    500000,
    500000,
    N'Đã thanh toán'
);

INSERT INTO ChiTietHoaDon
(MaHD, MaMon, SoLuong, DonGia, ThanhTien)
VALUES
(@MaHD, 1, 1, 350000, 350000),
(@MaHD, 3, 10, 15000, 150000);
GO

-- ================================================================
-- STORED PROCEDURE
-- ================================================================

-- Lấy danh sách nhân viên
CREATE PROCEDURE sp_GetNhanVien
AS
BEGIN
    SELECT *
    FROM NhanVien
    WHERE TrangThai = 1
    ORDER BY MaNV;
END
GO

-- Lấy danh sách món ăn
CREATE PROCEDURE sp_GetMonAn
AS
BEGIN
    SELECT 
        m.MaMon,
        m.TenMon,
        l.TenLoai,
        m.Gia,
        m.DonVi
    FROM MonAn m
    INNER JOIN LoaiMonAn l
        ON m.MaLoai = l.MaLoai
    WHERE m.TrangThai = 1
    ORDER BY l.TenLoai, m.TenMon;
END
GO

-- Lấy chi tiết hóa đơn
CREATE PROCEDURE sp_GetChiTietHoaDon
    @MaHD VARCHAR(30)
AS
BEGIN
    SELECT
        ct.MaChiTiet,
        m.TenMon,
        ct.SoLuong,
        ct.DonGia,
        ct.ThanhTien
    FROM ChiTietHoaDon ct
    INNER JOIN MonAn m
        ON ct.MaMon = m.MaMon
    WHERE ct.MaHD = @MaHD;
END
GO

-- Tính lại tiền hóa đơn
CREATE PROCEDURE sp_TinhLaiTienHoaDon
    @MaHD VARCHAR(30)
AS
BEGIN
    UPDATE HoaDon
    SET TongTienGoc =
    (
        SELECT ISNULL(SUM(ThanhTien), 0)
        FROM ChiTietHoaDon
        WHERE MaHD = @MaHD
    )
    WHERE MaHD = @MaHD;

    UPDATE HoaDon
    SET
        TienGiamGia =
            CAST(TongTienGoc * PhanTramGiamGia / 100.0 AS BIGINT),

        TongTienPhaiTra =
            TongTienGoc -
            CAST(TongTienGoc * PhanTramGiamGia / 100.0 AS BIGINT)

    WHERE MaHD = @MaHD;
END
GO

-- ================================================================
-- KIỂM TRA
-- ================================================================

SELECT * FROM NhanVien;

SELECT * FROM MonAn;

SELECT * FROM HoaDon;

SELECT * FROM ChiTietHoaDon;
GO

-- ================================================================
-- THÔNG BÁO
-- ================================================================
PRINT '========================================';
PRINT 'TAO DATABASE QUAN LY NHA HANG THANH CONG';
PRINT '========================================';
GO