# 📋 HƯỚNG DẪN CHẠY SQL SCRIPT - HỆ THỐNG QUẢN LÝ NHÀ HÀNG

## 📌 THÔNG TIN CƠ BẢN
- **Tên Database:** `QuanLyNhaHang`
- **Máy chủ:** `localhost\SQLEXPRESS` (hoặc máy chủ của bạn)
- **Định dạng:** SQL Server T-SQL
- **Phiên bản .NET:** .NET Framework 4.7.2

---

## 🔧 BƯỚC 1: CHUẨN BỊ (Trước khi chạy Script)

### Yêu cầu:
1. ✅ Đã cài đặt **SQL Server 2019/2022** (hoặc phiên bản khác)
2. ✅ Đã cài đặt **SQL Server Management Studio (SSMS)**
3. ✅ Có file `DATABASE_SCRIPT.sql` (script này)

### Kiểm tra SQL Server có chạy:
```
Services > SQL Server (SQLEXPRESS) - Running
```

---

## 📂 BƯỚC 2: MỞ SQL SERVER MANAGEMENT STUDIO

1. Mở **SSMS** (SQL Server Management Studio)
2. Đăng nhập với:
   - **Server name:** `localhost\SQLEXPRESS` 
   - **Authentication:** Windows Authentication
   - Nhấn **Connect**

---

## 🎯 BƯỚC 3: CHẠY SCRIPT

### Cách 1: Sử dụng File Query
```
1. Trong SSMS, nhấn Ctrl + O hoặc File > Open > File...
2. Chọn file: DATABASE_SCRIPT.sql
3. Script sẽ được mở trong cửa sổ Query
4. Nhấn F5 hoặc nút Execute (▶)
5. Chờ cho đến khi thấy "Commands completed successfully"
```

### Cách 2: Copy-Paste trực tiếp
```
1. Mở SSMS
2. Nhấn Ctrl + N để tạo Query mới
3. Copy toàn bộ nội dung script vào
4. Nhấn F5 để chạy
```

---

## ✅ BƯỚC 4: KIỂM CHỨNG KẾT QUẢ

Sau khi script chạy xong, kiểm tra:

### 1️⃣ Database được tạo:
```sql
USE QuanLyNhaHang;
GO
```

### 2️⃣ Xem danh sách bảng:
```sql
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' 
ORDER BY TABLE_NAME;
```
**Kết quả:** 11 bảng (TaiKhoan, NhanVien, LoaiMonAn, MonAn, Ban, KhachHang, HoaDon, ChiTietHoaDon, DoiDiemThuong, LuongNhanVien, ThongKeNgay)

### 3️⃣ Xem dữ liệu mẫu:
```sql
SELECT * FROM NhanVien;
SELECT * FROM MonAn;
SELECT * FROM KhachHang;
SELECT * FROM Ban;
```

---

## 📊 CẤU TRÚC BẢNG

| Tên Bảng | Mô Tả | Khóa Chính |
|---------|-------|-----------|
| **TaiKhoan** | Thông tin đăng nhập | MaTK |
| **NhanVien** | Quản lý nhân viên | MaNV |
| **LoaiMonAn** | Phân loại món ăn | MaLoai |
| **MonAn** | Danh sách món ăn | MaMon |
| **Ban** | Quản lý bàn ăn | MaBan |
| **KhachHang** | Thông tin khách hàng | MaKH |
| **HoaDon** | Hóa đơn thanh toán | MaHD |
| **ChiTietHoaDon** | Chi tiết từng hóa đơn | MaChiTiet |
| **DoiDiemThuong** | Đổi điểm thưởng | MaDoiDiem |
| **LuongNhanVien** | Bảng lương | MaLuong |
| **ThongKeNgay** | Thống kê hàng ngày | MaTK |

---

## 🔐 DỮ LIỆU KHỞI ĐỘNG MẶC ĐỊNH

### Tài Khoản:
| TenDangNhap | MatKhau | Quyen |
|-------------|---------|-------|
| admin | admin123 | Quản lý |
| nhanvien1 | pass123 | Thu ngân |
| nhanvien2 | pass123 | Phục vụ bàn |

### Nhân Viên:
- **NV001:** Nguyễn Văn Anh - Quản lý (15M)
- **NV002:** Trần Thị Bình - Thu ngân (8M)
- **NV003:** Lê Văn Cường - Phục vụ bàn (6M)
- **NV004:** Phạm Thị Dung - Phục vụ bàn (6M)
- **NV005:** Võ Văn Emm - Bếp (7M)

### Bàn:
- 8 bàn (từ 01 đến 08)
- Tầng 1: Bàn 01-04, 07-08
- Tầng 2: Bàn 05-06

### Khách Hàng:
- **KH001:** Hoàng Anh Tuấn - VIP - 250 điểm
- **KH002:** Nguyễn Thị Hoa - Vàng - 150 điểm
- **KH003:** Lê Văn Phong - Bạc - 75 điểm

---

## ⚠️ CÓ LỖI? ĐÂY LÀ GIẢI PHÁP:

### ❌ Lỗi: "Database already exists"
```sql
-- Xóa database cũ thủ công
DROP DATABASE QuanLyNhaHang;
-- Rồi chạy script lại
```

### ❌ Lỗi: "SQL Server không khởi động"
```
1. Mở Services (services.msc)
2. Tìm "SQL Server (SQLEXPRESS)"
3. Nhấp phải > Start
```

### ❌ Lỗi: "Cannot connect to server"
- Kiểm tra tên server: `localhost\SQLEXPRESS` hoặc chỉ `SQLEXPRESS`
- Hoặc dùng IP: `.\SQLEXPRESS` hoặc `(local)\SQLEXPRESS`

### ❌ Lỗi: "TLS negotiation failed"
- Thêm vào connection string: `TrustServerCertificate=True;`
- (Đã thêm sẵn trong code của bạn)

---

## 💻 CẬP NHẬT CONNECTION STRING TRONG CODE C#

Trong file `DangNhap.cs` và `QuanLyMonAn.cs`, sửa:

```csharp
string ketNoiCSDL = @"Data Source=localhost\SQLEXPRESS;
					  Initial Catalog=QuanLyNhaHang;
					  Integrated Security=True;
					  TrustServerCertificate=True;";
```

---

## 🎓 LƯỚI TRẢI (Schema)

### Quan hệ giữa các bảng:
```
TaiKhoan (1) ───── (N) NhanVien ───── (N) HoaDon
										 │
										 ├─── (N) ChiTietHoaDon ───── (N) MonAn
										 │
										 └─── (N) Ban
										 └─── (1) KhachHang ───── (N) DoiDiemThuong
												  │
												  └─── (N) LuongNhanVien
```

---

## 🔄 MỘT SỐ CÂU TRUY VẤN TIỆN DỤNG

### Thống kê doanh thu theo ngày:
```sql
SELECT 
	CAST(h.NgayGio AS DATE) AS Ngay,
	COUNT(*) AS SoHoaDon,
	SUM(h.TongTienPhaiTra) AS TongDoanhThu
FROM HoaDon h
GROUP BY CAST(h.NgayGio AS DATE)
ORDER BY Ngay DESC;
```

### Top 5 món ăn bán chạy:
```sql
SELECT TOP 5
	m.TenMon,
	SUM(ct.SoLuong) AS SoLuongBan,
	SUM(ct.ThanhTien) AS DoanhThu
FROM ChiTietHoaDon ct
INNER JOIN MonAn m ON ct.MaMon = m.MaMon
GROUP BY m.TenMon
ORDER BY SoLuongBan DESC;
```

### Chi phí lương theo tháng:
```sql
SELECT 
	Thang,
	Nam,
	SUM(LuongThucLinh) AS TongChiPhiLuong
FROM LuongNhanVien
GROUP BY Thang, Nam
ORDER BY Nam DESC, Thang DESC;
```

---

## 📞 HỖ TRỢ

Nếu có lỗi hoặc câu hỏi, kiểm tra:
1. ✅ Phiên bản SQL Server khớp
2. ✅ Connection string chính xác
3. ✅ TrustServerCertificate=True (cho SQL 2022+)
4. ✅ Tài khoản Windows có quyền tạo database

---

**Chúc bạn thành công với bài tập lớn! 🎉**
