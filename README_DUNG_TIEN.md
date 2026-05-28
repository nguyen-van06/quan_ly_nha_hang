# 🎯 HƯỚNG DẪN HOÀN CHỈNH - HỆ THỐNG QUẢN LÝ NHÀ HÀNG

## 📦 CÁC FILE ĐƯỢC TẠO

```
1. DATABASE_SCRIPT.sql                → SQL script đầy đủ (tạo CSDL)
2. DATABASE_SCRIPT_COMPACT.sql        → SQL script gọn (nếu script trên quá dài)
3. CAU_TRUY_VAN_THONG_KE.sql         → 30+ truy vấn thống kê & báo cáo
4. HUONG_DAN_CHAY_DATABASE.md        → Hướng dẫn chạy trên SSMS
5. CAP_NHAT_CODE_CS.md               → Hướng dẫn sửa code C#
6. TONG_KET_DESIGN.md                → Thiết kế CSDL & kiến trúc
7. README_DUNG_TIEN.md               → File này - Hướng dẫn hoàn chỉnh
```

---

## 🚀 BƯỚC 1: CHẠY DATABASE (CÓ SẬN NGAY)

### 1.1 Mở SQL Server Management Studio (SSMS)

```
1. Khởi động SSMS
2. Đăng nhập:
   - Server: localhost\SQLEXPRESS (hoặc tên server của bạn)
   - Authentication: Windows Authentication
   - Nhấn Connect
```

### 1.2 Chạy Script SQL

```
Cách 1 - Nếu SSMS mở được file:
  1. File > Open > File...
  2. Chọn: DATABASE_SCRIPT.sql
  3. Nhấn F5 hoặc Query > Execute

Cách 2 - Copy-Paste:
  1. Mở Notepad hoặc VSCode
  2. Mở file: DATABASE_SCRIPT.sql
  3. Copy toàn bộ nội dung
  4. Dán vào SSMS (cửa sổ Query mới)
  5. Nhấn F5 để chạy

Cách 3 - Nếu script quá dài:
  1. Dùng DATABASE_SCRIPT_COMPACT.sql
  2. Hoặc split thành phần nhỏ hơn
```

### 1.3 Kiểm Tra Kết Quả

```sql
-- Chạy câu lệnh này để xác nhận
USE QuanLyNhaHang;
SELECT 'Database ready!' AS Status;

-- Xem tất cả bảng
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' 
ORDER BY TABLE_NAME;

-- Xem dữ liệu mẫu
SELECT * FROM NhanVien;
SELECT * FROM MonAn;
SELECT * FROM KhachHang;
```

✅ **Nếu thành công:** Database sẽ có 11 bảng + dữ liệu mẫu

---

## 💻 BƯỚC 2: CẬP NHẬT CODE C#

### 2.1 Tạo File DatabaseHelper.cs

```
1. Mở Visual Studio
2. Mở project: BTL_QuanLyNhaHang
3. Chuột phải vào project > Add > Class
4. Tên: DatabaseHelper.cs
5. Copy nội dung từ file: CAP_NHAT_CODE_CS.md (mục 5️⃣)
6. Save
```

### 2.2 Cập Nhật DangNhap.cs

```
1. Mở file: DangNhap.cs
2. Tìm dòng: string ketNoiCSDL = @"..."
3. Thay thế connection string (chi tiết trong CAP_NHAT_CODE_CS.md)
4. Cập nhật các method như hướng dẫn
5. Save
```

### 2.3 Cập Nhật QuanLyMonAn.cs

```
1. Mở file: QuanLyMonAn.cs
2. Tìm dòng: string ketNoiCSDL = @"..."
3. Thay thế connection string
4. Cập nhật LoadData() và các method khác
5. Save
```

### 2.4 Biên Dịch & Test

```
1. Nhấn Ctrl + Shift + B để biên dịch
2. Kiểm tra có lỗi không
3. Nhấn F5 để chạy
4. Test: Đăng nhập với admin/admin123
```

---

## 📊 BƯỚC 3: TẠO STORED PROCEDURES (TÙY CHỌN)

Nếu muốn code C# gọi Stored Procedures:

```sql
-- Mở SSMS và chạy các SP từ DATABASE_SCRIPT.sql

-- Hoặc sử dụng các SP này:

-- SP: Lấy danh sách nhân viên
EXEC sp_GetNhanVien;

-- SP: Lấy danh sách món ăn
EXEC sp_GetMonAn;

-- SP: Lấy chi tiết hóa đơn
EXEC sp_GetChiTietHoaDon 'HD20260516112600';
```

---

## 📈 BƯỚC 4: CHẠY CÁC TRUY VẤN THỐNG KÊ

Mở file: `CAU_TRUY_VAN_THONG_KE.sql`

Chứa 30+ truy vấn hữu ích:

```
✅ Thống kê doanh thu (theo ngày, tháng, nhân viên)
✅ Thống kê món ăn (Top bán chạy)
✅ Thống kê khách hàng (Top VIP, khách mới)
✅ Thống kê nhân viên & lương
✅ Thống kê bàn ăn (tỷ lệ sử dụng)
✅ Thống kê thanh toán & khuyến mãi
✅ Báo cáo tổng quát
```

Copy-paste từng truy vấn vào SSMS để xem báo cáo.

---

## 🔌 CONNECTION STRING CHÍNH XÁC

### Cho Windows Authentication (Recommended):
```csharp
"Data Source=localhost\\SQLEXPRESS;Initial Catalog=QuanLyNhaHang;Integrated Security=True;TrustServerCertificate=True;"
```

### Nếu cần SQL Server Authentication:
```csharp
"Data Source=localhost\\SQLEXPRESS;Initial Catalog=QuanLyNhaHang;User ID=sa;Password=YourPassword;TrustServerCertificate=True;"
```

### Nếu dùng máy chủ từ xa:
```csharp
"Data Source=192.168.1.100\\SQLEXPRESS;Initial Catalog=QuanLyNhaHang;Integrated Security=True;Connection Timeout=30;"
```

---

## ⚙️ CẤU HÌNH CHI TIẾT

### Tên Database:
- **Exact:** `QuanLyNhaHang` (không được thay đổi)

### Tài khoản mặc định:
```
Username: admin
Password: admin123
Quyền: Quản lý
```

### Máy chủ mặc định:
```
localhost\SQLEXPRESS  (hoặc .\SQLEXPRESS)
```

### Cổng mặc định:
```
SQL Server: 1433
```

---

## 🧪 KIỂM TRA & DEBUG

### Nếu không kết nối được CSDL:

```csharp
// Thêm code này để test
using System;
using System.Data.SqlClient;

try 
{
	SqlConnection conn = new SqlConnection(connectionString);
	conn.Open();
	MessageBox.Show("Kết nối thành công!");
	conn.Close();
}
catch (Exception ex)
{
	MessageBox.Show("Lỗi: " + ex.Message);
}
```

### Lỗi thường gặp:

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-----------|----------|
| Cannot connect | SQL Server không chạy | Start SQL Server service |
| Database not found | Tên database sai | Kiểm tra tên: QuanLyNhaHang |
| Login failed | Tài khoản sai | Dùng Windows Auth hoặc sa/password |
| Timeout | Query quá lâu | Tăng timeout: Connection Timeout=30 |
| TLS failed | Mã hóa không hỗ trợ | Thêm: TrustServerCertificate=True |

---

## 📱 CÔNG DỤNG CỦA TỪNG BỘ PHẬN

### 🎯 Phần NhanVien (thanh_toan-quan_ly_nhan_vien\nhanvien.cs)
```
CSDL → NhanVien table
├─ Thêm nhân viên
├─ Sửa thông tin
├─ Xóa nhân viên
└─ Hiển thị danh sách
```

### 🎯 Phần Thanh Toán (thanh_toan-quan_ly_nhan_vien\Form1.cs)
```
CSDL → HoaDon + ChiTietHoaDon
├─ Tạo hóa đơn tự động
├─ Thêm món ăn vào hóa đơn
├─ Tính giảm giá
├─ Chọn cách thanh toán
└─ Lưu hóa đơn
```

### 🎯 Phần Quản Lý Khách Hàng (Baocao-ThongKe\QLKH.cs)
```
CSDL → KhachHang + DoiDiemThuong
├─ Thêm khách mới
├─ Cập nhật thông tin
├─ Xem điểm thưởng
└─ Đổi điểm lấy giảm giá
```

### 🎯 Phần Quản Lý Món Ăn (BTL_QuanLyNhaHang\QuanLyMonAn.cs)
```
CSDL → MonAn + LoaiMonAn
├─ Thêm món
├─ Sửa giá
├─ Xóa món
└─ Hiển thị danh sách
```

### 🎯 Phần Đăng Nhập (BTL_QuanLyNhaHang\DangNhap.cs)
```
CSDL → TaiKhoan
├─ Xác thực user/password
├─ Lấy quyền hạn
└─ Mở form tương ứng
```

---

## ✨ CHỨC NĂNG NỔI BẬT

### ✅ Hỗ trợ 3 quyền:
- **Quản lý:** Xem tất cả, cấp quyền
- **Thu ngân:** Thanh toán, quản lý khách
- **Phục vụ:** Ghi đơn, không sửa giá

### ✅ Hỗ trợ 3 loại khách:
- **Khách VIP:** Có điểm, giảm giá cao
- **Khách thành viên:** Tích điểm, giảm giá
- **Khách vãng lai:** Không cần đăng ký, không giảm giá

### ✅ Thống kê đa dạng:
- Doanh thu theo ngày/tháng/nhân viên
- Top 5 món bán chạy
- Khách hàng chi tiêu nhiều nhất
- Chi phí lương
- Tỷ lệ sử dụng bàn

---

## 📝 NOTES QUAN TRỌNG

⚠️ **TRƯỚC KHI CHẠY:**
1. ✅ Đã cài SQL Server 2019+ ?
2. ✅ Đã cài SSMS ?
3. ✅ Kiểm tra version .NET Framework: 4.7.2 ?
4. ✅ Tên project không có khoảng trắng ?

⚠️ **KHI CHẠY SCRIPT:**
1. ✅ Script sẽ XÓA database cũ nếu có
2. ✅ Script sẽ TẠO database mới
3. ✅ Script sẽ THÊM dữ liệu mẫu
4. ✅ Chúng có thể mất 5-10 giây

⚠️ **KHI UPDATE CODE:**
1. ✅ Biên dịch trước khi chạy (Ctrl+Shift+B)
2. ✅ Xóa lỗi Intellisense: Clean Solution > Rebuild
3. ✅ Test connection trước khi sử dụng form

---

## 🎓 REFERENCES

### Các file hướng dẫn chi tiết:
1. **HUONG_DAN_CHAY_DATABASE.md** → Cách chạy script SQL
2. **CAP_NHAT_CODE_CS.md** → Cách cập nhật code C#
3. **TONG_KET_DESIGN.md** → Thiết kế CSDL
4. **CAU_TRUY_VAN_THONG_KE.sql** → 30+ truy vấn thống kê

### Tài liệu tham khảo:
- Microsoft Docs: SQL Server
- Microsoft Docs: ADO.NET
- Microsoft Docs: Windows Forms

---

## ✅ CHECKLIST HOÀN THÀNH

```
[ ] Chạy DATABASE_SCRIPT.sql thành công
[ ] Database QuanLyNhaHang tồn tại (11 bảng)
[ ] Tạo file DatabaseHelper.cs
[ ] Cập nhật connection string
[ ] Biên dịch project không lỗi
[ ] Test form DangNhap
[ ] Đăng nhập admin thành công
[ ] Xem được danh sách Món Ăn
[ ] Thêm được Món Ăn mới
[ ] Xem được danh sách Nhân Viên
[ ] Chạy được truy vấn thống kê
```

---

## 🎉 HOÀN THÀNH!

Sau khi hoàn thành tất cả bước trên, bạn có thể:

✅ Chạy hệ thống quản lý nhà hàng
✅ Đăng nhập với 3 quyền khác nhau
✅ Quản lý nhân viên, món ăn, khách hàng
✅ Lập hóa đơn, thanh toán
✅ Xem báo cáo & thống kê
✅ Hoàn thành bài tập lớn! 🏆

---

## 📞 HỖ TRỢ

Nếu có vấn đề:
1. Kiểm tra logs trong Output window
2. Thử xóa bin/obj folder
3. Rebuild solution
4. Tìm kiếm error code trên Google
5. Hỏi team hoặc giáo viên

**Chúc bạn thành công! 🚀**

