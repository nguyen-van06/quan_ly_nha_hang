-- ================================================================
-- CÁC TRUY VẤN HỮU DỤNG - THỐNG KÊ VÀ BÁO CÁO
-- ================================================================

USE QuanLyNhaHang;
GO

-- ================================================================
-- 1. THỐNG KÊ DOANH THU
-- ================================================================

-- 1.1 Doanh thu theo ngày
SELECT 
	CAST(NgayGio AS DATE) AS Ngay,
	COUNT(*) AS SoHoaDon,
	SUM(TongTienPhaiTra) AS TongDoanhThu,
	COUNT(DISTINCT MaKH) AS SoKhachHang
FROM HoaDon
GROUP BY CAST(NgayGio AS DATE)
ORDER BY Ngay DESC;

-- 1.2 Doanh thu theo tháng
SELECT 
	YEAR(NgayGio) AS Nam,
	MONTH(NgayGio) AS Thang,
	COUNT(*) AS SoHoaDon,
	SUM(TongTienPhaiTra) AS TongDoanhThu
FROM HoaDon
GROUP BY YEAR(NgayGio), MONTH(NgayGio)
ORDER BY Nam DESC, Thang DESC;

-- 1.3 Doanh thu theo nhân viên
SELECT 
	nv.MaNV,
	nv.HoTen,
	nv.ChucVu,
	COUNT(hd.MaHD) AS SoHoaDon,
	SUM(hd.TongTienPhaiTra) AS TongDoanhThu
FROM NhanVien nv
LEFT JOIN HoaDon hd ON nv.MaNV = hd.MaNV
WHERE nv.TrangThai = 1
GROUP BY nv.MaNV, nv.HoTen, nv.ChucVu
ORDER BY TongDoanhThu DESC;

-- ================================================================
-- 2. THỐNG KÊ MÓN ĂN
-- ================================================================

-- 2.1 Top 5 món ăn bán chạy nhất
SELECT TOP 5
	m.MaMon,
	m.TenMon,
	l.TenLoai,
	m.Gia,
	SUM(ct.SoLuong) AS SoLuongBan,
	SUM(ct.ThanhTien) AS DoanhThu
FROM ChiTietHoaDon ct
INNER JOIN MonAn m ON ct.MaMon = m.MaMon
INNER JOIN LoaiMonAn l ON m.MaLoai = l.MaLoai
GROUP BY m.MaMon, m.TenMon, l.TenLoai, m.Gia
ORDER BY SoLuongBan DESC;

-- 2.2 Tổng số lượng từng món bán được
SELECT 
	m.MaMon,
	m.TenMon,
	l.TenLoai,
	COUNT(*) AS SoLanBan,
	SUM(ct.SoLuong) AS TongSoLuong,
	AVG(ct.SoLuong) AS SoLuongTrungBinh,
	SUM(ct.ThanhTien) AS TongDoanhThu
FROM ChiTietHoaDon ct
INNER JOIN MonAn m ON ct.MaMon = m.MaMon
INNER JOIN LoaiMonAn l ON m.MaLoai = l.MaLoai
GROUP BY m.MaMon, m.TenMon, l.TenLoai
ORDER BY TongSoLuong DESC;

-- 2.3 Doanh thu theo danh mục món ăn
SELECT 
	l.MaLoai,
	l.TenLoai,
	COUNT(DISTINCT ct.MaChiTiet) AS SoLuongHoaDon,
	SUM(ct.SoLuong) AS TongSoLuong,
	SUM(ct.ThanhTien) AS DoanhThu,
	CAST(SUM(ct.ThanhTien) * 100.0 / 
		(SELECT SUM(ThanhTien) FROM ChiTietHoaDon) AS DECIMAL(5,2)) AS PhanTramDoanhThu
FROM ChiTietHoaDon ct
INNER JOIN MonAn m ON ct.MaMon = m.MaMon
INNER JOIN LoaiMonAn l ON m.MaLoai = l.MaLoai
GROUP BY l.MaLoai, l.TenLoai
ORDER BY DoanhThu DESC;

-- ================================================================
-- 3. THỐNG KÊ KHÁCH HÀNG
-- ================================================================

-- 3.1 Danh sách khách hàng
SELECT 
	MaKH,
	HoTen,
	SDT,
	HangThanhVien,
	DiemThuong,
	DATEDIFF(DAY, NgayDangKy, GETDATE()) AS SoNgayThanhVien,
	NgayDangKy
FROM KhachHang
WHERE TrangThai = 1
ORDER BY DiemThuong DESC;

-- 3.2 Top khách hàng chi tiêu nhiều nhất
SELECT TOP 10
	kh.MaKH,
	kh.HoTen,
	kh.HangThanhVien,
	COUNT(hd.MaHD) AS SoHoaDon,
	SUM(hd.TongTienPhaiTra) AS TongChiTieu,
	AVG(hd.TongTienPhaiTra) AS ChiTieuTrungBinh,
	kh.DiemThuong
FROM KhachHang kh
LEFT JOIN HoaDon hd ON kh.MaKH = hd.MaKH
WHERE kh.TrangThai = 1
GROUP BY kh.MaKH, kh.HoTen, kh.HangThanhVien, kh.DiemThuong
ORDER BY TongChiTieu DESC;

-- 3.3 Khách hàng mới
SELECT 
	MaKH,
	HoTen,
	SDT,
	NgayDangKy,
	DATEDIFF(DAY, NgayDangKy, GETDATE()) AS SoNgayDangKy
FROM KhachHang
WHERE DATEDIFF(DAY, NgayDangKy, GETDATE()) <= 30
ORDER BY NgayDangKy DESC;

-- ================================================================
-- 4. THỐNG KÊ NHÂN VIÊN & LƯƠNG
-- ================================================================

-- 4.1 Danh sách nhân viên
SELECT 
	MaNV,
	HoTen,
	ChucVu,
	SDT,
	LuongCoBan,
	CASE 
		WHEN TrangThai = 1 THEN 'Đang làm'
		ELSE 'Đã nghỉ'
	END AS TrangThaiNV
FROM NhanVien
ORDER BY ChucVu, HoTen;

-- 4.2 Chi phí lương theo tháng
SELECT 
	Thang,
	Nam,
	COUNT(DISTINCT MaNV) AS SoNhanVien,
	SUM(LuongCoBan) AS TongLuongCoBan,
	SUM(PhuCap) AS TongPhuCap,
	SUM(KhauTru) AS TongKhauTru,
	SUM(LuongThucLinh) AS TongLuongThucLinh
FROM LuongNhanVien
GROUP BY Thang, Nam
ORDER BY Nam DESC, Thang DESC;

-- 4.3 Lương chi tiết từng nhân viên
SELECT 
	ln.MaNV,
	nv.HoTen,
	nv.ChucVu,
	ln.Thang,
	ln.Nam,
	ln.LuongCoBan,
	ln.PhuCap,
	ln.KhauTru,
	ln.LuongThucLinh,
	ln.TrangThai
FROM LuongNhanVien ln
INNER JOIN NhanVien nv ON ln.MaNV = nv.MaNV
ORDER BY ln.Nam DESC, ln.Thang DESC, nv.HoTen;

-- 4.4 Hiệu suất làm việc (số hóa đơn xử lý)
SELECT 
	nv.MaNV,
	nv.HoTen,
	nv.ChucVu,
	COUNT(hd.MaHD) AS SoHoaDonXuLy,
	SUM(hd.TongTienPhaiTra) AS TongGiaTriHoaDon,
	COUNT(hd.MaHD) * 100.0 / (SELECT COUNT(*) FROM HoaDon) AS PhanTramHoaDon
FROM NhanVien nv
LEFT JOIN HoaDon hd ON nv.MaNV = hd.MaNV
GROUP BY nv.MaNV, nv.HoTen, nv.ChucVu
ORDER BY SoHoaDonXuLy DESC;

-- ================================================================
-- 5. THỐNG KÊ BÀN ĂNHANG
-- ================================================================

-- 5.1 Trạng thái các bàn
SELECT 
	MaBan,
	TenBan,
	SoChoNgoi,
	Tang,
	TrangThai,
	GhiChu
FROM Ban
ORDER BY Tang, MaBan;

-- 5.2 Tỷ lệ sử dụng các bàn
SELECT 
	b.MaBan,
	b.TenBan,
	b.SoChoNgoi,
	COUNT(hd.MaHD) AS SoLanSuDung,
	SUM(hd.TongTienPhaiTra) AS TongDoanhThuTuBan,
	CAST(COUNT(hd.MaHD) * 100.0 / (SELECT COUNT(*) FROM HoaDon) AS DECIMAL(5,2)) AS PhanTramSuDung
FROM Ban b
LEFT JOIN HoaDon hd ON b.MaBan = hd.MaBan
GROUP BY b.MaBan, b.TenBan, b.SoChoNgoi
ORDER BY SoLanSuDung DESC;

-- ================================================================
-- 6. THỐNG KÊ THANH TOÁN
-- ================================================================

-- 6.1 Theo phương thức thanh toán
SELECT 
	PhuongThucTT,
	COUNT(*) AS SoHoaDon,
	SUM(TongTienPhaiTra) AS TongTien,
	AVG(TongTienPhaiTra) AS TienTrungBinh
FROM HoaDon
GROUP BY PhuongThucTT
ORDER BY TongTien DESC;

-- 6.2 Hóa đơn có áp dụng giảm giá
SELECT 
	COUNT(*) AS SoHoaDon,
	COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HoaDon) AS PhanTramAD,
	SUM(TienGiamGia) AS TongTienGiam,
	AVG(PhanTramGiamGia) AS PhanTramGiamTrungBinh
FROM HoaDon
WHERE PhanTramGiamGia > 0;

-- 6.3 Hóa đơn chưa thanh toán
SELECT 
	MaHD,
	MaBan,
	MaNV,
	NgayGio,
	TongTienPhaiTra,
	DATEDIFF(DAY, NgayGio, GETDATE()) AS SoNgayChuaThanhToan
FROM HoaDon
WHERE TrangThai = N'Chưa thanh toán'
ORDER BY NgayGio;

-- ================================================================
-- 7. THỐNG KÊ KHUYẾN MÃI & ĐIỂM THƯỞNG
-- ================================================================

-- 7.1 Tổng tiền giảm giá
SELECT 
	COUNT(*) AS SoHoaDonGiam,
	SUM(TienGiamGia) AS TongTienGiam,
	SUM(TienGiamGia) * 100.0 / SUM(TongTienGoc) AS PhanTramGiamTheoGoc
FROM HoaDon;

-- 7.2 Lịch sử đổi điểm thưởng
SELECT 
	kh.MaKH,
	kh.HoTen,
	ddt.DiemDung,
	ddt.TienGiam,
	ddt.NgayDoi
FROM DoiDiemThuong ddt
INNER JOIN KhachHang kh ON ddt.MaKH = kh.MaKH
ORDER BY ddt.NgayDoi DESC;

-- ================================================================
-- 8. TẠO BÁO CÁO TỔNG QUÁT
-- ================================================================

-- 8.1 Báo cáo hôm nay
SELECT 
	CAST(GETDATE() AS DATE) AS Ngay,
	(SELECT COUNT(*) FROM HoaDon WHERE CAST(NgayGio AS DATE) = CAST(GETDATE() AS DATE)) AS SoHoaDon,
	(SELECT SUM(TongTienPhaiTra) FROM HoaDon WHERE CAST(NgayGio AS DATE) = CAST(GETDATE() AS DATE)) AS DoanhThuHomNay,
	(SELECT COUNT(DISTINCT MaKH) FROM HoaDon WHERE CAST(NgayGio AS DATE) = CAST(GETDATE() AS DATE)) AS SoKhachHang,
	(SELECT COUNT(*) FROM KhachHang WHERE TrangThai = 1) AS TongKhachHang,
	(SELECT COUNT(*) FROM NhanVien WHERE TrangThai = 1) AS TongNhanVien;

-- 8.2 Báo cáo toàn bộ
SELECT 
	'Tổng hóa đơn' AS LoaiThongKe,
	CAST(COUNT(*) AS VARCHAR(20)) AS GiaTri
FROM HoaDon

UNION ALL

SELECT 'Tổng doanh thu', CAST(CAST(SUM(TongTienPhaiTra) AS BIGINT) AS VARCHAR(20))
FROM HoaDon

UNION ALL

SELECT 'Tổng khách hàng', CAST(COUNT(*) AS VARCHAR(20))
FROM KhachHang WHERE TrangThai = 1

UNION ALL

SELECT 'Tổng nhân viên', CAST(COUNT(*) AS VARCHAR(20))
FROM NhanVien WHERE TrangThai = 1

UNION ALL

SELECT 'Tổng tiền giảm giá', CAST(CAST(SUM(TienGiamGia) AS BIGINT) AS VARCHAR(20))
FROM HoaDon

UNION ALL

SELECT 'Tổng hóa đơn chưa thanh toán', CAST(COUNT(*) AS VARCHAR(20))
FROM HoaDon WHERE TrangThai = N'Chưa thanh toán';
