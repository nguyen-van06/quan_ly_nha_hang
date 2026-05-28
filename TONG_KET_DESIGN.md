# 🎯 TÓM TẮT - HỆ THỐNG QUẢN LÝ NHÀ HÀNG

## 📦 Các File Được Tạo

| File | Mô Tả |
|------|-------|
| **DATABASE_SCRIPT.sql** | ✨ Script SQL hoàn chỉnh để tạo CSDL |
| **HUONG_DAN_CHAY_DATABASE.md** | 📖 Hướng dẫn chi tiết chạy trên SSMS |
| **CAP_NHAT_CODE_CS.md** | 💻 Cầu chỉnh code C# để sử dụng CSDL |
| **TONG_KET_DESIGN.md** | 📋 File này - Tổng kết design |

---

## 🏗️ THIẾT KẾ CSDL

### 11 Bảng Chính:

```
1. TaiKhoan          → Quản lý đăng nhập (3 quyền: Quản lý, Thu ngân, Phục vụ)
2. NhanVien          → 5 nhân viên mẫu (Quản lý, Thu ngân, Bếp, Phục vụ)
3. LoaiMonAn         → 6 loại (Khai vị, Lẩu, Nướng, Khác, Nước ngọt, Bia/Rượu)
4. MonAn             → 10 món ăn mẫu có giá
5. Ban               → 8 bàn (Tầng 1 & Tầng 2)
6. KhachHang         → 3 khách VIP mẫu
7. HoaDon            → Lưu hóa đơn (có hỗ trợ giảm giá)
8. ChiTietHoaDon     → Chi tiết từng món trong hóa đơn
9. DoiDiemThuong     → Lịch sử đổi điểm thưởng
10. LuongNhanVien    → Bảng tính lương
11. ThongKeNgay      → Thống kê doanh thu hàng ngày
```

---

## 🔑 Tính Năng Chính

### ✅ Quản Lý Nhân Viên
- Thêm, sửa, xóa nhân viên
- Các chức vụ: Quản lý, Thu ngân, Phục vụ bàn, Bếp
- Lương cơ bản theo chức vụ

### ✅ Quản Lý Món Ăn
- CRUD (Create, Read, Update, Delete)
- Phân loại theo 6 danh mục
- Lưu giá, đơn vị tính

### ✅ Quản Lý Khách Hàng
- Đăng ký khách hàng mới
- Hạng thành viên (Đồng, Bạc, Vàng, VIP)
- Tích luỹ điểm thưởng
- Có thể là khách vãng lai (không cần đăng ký)

### ✅ Hóa Đơn & Thanh Toán
- Tạo hóa đơn tự động (HDyyyyMMddHHmmss)
- Chọn bàn, nhân viên phục vụ
- Thêm múi món ăn vào hóa đơn
- Tính toán tổng tiền
- Áp dụng giảm giá (%)
- Hỗ trợ 3 cách thanh toán: Tiền mặt, Thẻ, Online
- Tính tiền thừa tự động
- Tích điểm cho khách hàng

### ✅ Thống Kê & Báo Cáo
- Thống kê doanh thu theo ngày
- Danh sách món ăn bán chạy
- Chi phí lương theo tháng
- Thông tin khách hàng

---

## 📊 QUAN HỆ BẢNG

```
					┌──────────────┐
					│  TaiKhoan    │
					└──────┬───────┘
						   │ (1)
						   │
					┌──────▼───────────────────┐
					│  NhanVien               │
					│ ────────────────────   │
					│ MaNV (PK)              │
					│ HoTen, ChucVu, SDT     │
					│ LuongCoBan             │
					└──────┬───────────┬─────┘
						   │(1)        │(1)
					(N)────┘           └────(N)
					│                       │
		┌───────────▼──────────────┐  ┌────▼──────────────────┐
		│  LuongNhanVien          │  │  HoaDon               │
		│  ─────────────────────  │  │  ────────────────────│
		│  MaLuong (PK)           │  │  MaHD (PK)           │
		│  Thang, Nam             │  │  MaBan, MaKH, MaNV   │
		│  LuongThucLinh          │  │  TongTienPhaiTra     │
		└─────────────────────────┘  │  TrangThai           │
									 └────┬──────────────────┘
										  │(1)
						  (N)─────────────┘
						  │
		┌─────────────────▼──────────────────┐
		│  ChiTietHoaDon                     │
		│  ──────────────────────────────   │
		│  MaChiTiet (PK)                   │
		│  MaHD, MaMon                      │
		│  SoLuong, DonGia, ThanhTien       │
		└─────────────────┬──────────────────┘
						  │(N)
						  │
					(1)───┤
					│     │
		┌───────────▼─────▼───────────────┐
		│  MonAn                          │
		│  ──────────────────────────────│
		│  MaMon (PK)                    │
		│  TenMon, Gia, DonVi            │
		│  MaLoai (FK)                   │
		└────────┬──────────────────────┘
				 │(N)
				 │
		  (1)────┤
		  │      │
	┌─────▼──────▼────────────────┐
	│  LoaiMonAn                  │
	│  ────────────────────────── │
	│  MaLoai (PK)               │
	│  TenLoai (UNIQUE)          │
	└─────────────────────────────┘


		┌───────────────────────────┐
		│  KhachHang                │
		│  ──────────────────────  │
		│  MaKH (PK)               │
		│  HoTen, SDT, HangTT      │
		│  DiemThuong              │
		└──────────┬────────────────┘
				   │(1)
				   │
			(N)────┤
			│      │
		┌───▼──────▼──────────────────┐
		│  DoiDiemThuong             │
		│  ────────────────────────  │
		│  MaDoiDiem (PK)            │
		│  MaKH, DiemDung, TienGiam  │
		└────────────────────────────┘


		┌──────────────────────────────┐
		│  Ban                         │
		│  ─────────────────────────  │
		│  MaBan (PK)                 │
		│  TenBan, SoChoNgoi, Tang    │
		│  TrangThai                  │
		└──────────────────────────────┘


		┌──────────────────────────────┐
		│  ThongKeNgay                 │
		│  ─────────────────────────  │
		│  MaTK (PK)                  │
		│  Ngay (UNIQUE)              │
		│  SoHoaDon, TongDoanhThu     │
		└──────────────────────────────┘
```

---

## 🚀 CÁC BƯỚC THỰC HIỆN

### Bước 1: Chạy SQL Script ✅
```
1. Mở SQL Server Management Studio (SSMS)
2. Chạy file DATABASE_SCRIPT.sql
3. Kiểm tra database được tạo thành công
```

### Bước 2: Cập Nhật Code C# ✅
```
1. Tạo file DatabaseHelper.cs
2. Update Connection String trong DangNhap.cs
3. Sửa LoadData() để lấy từ CSDL
4. Biên dịch lại project
```

### Bước 3: Kiểm Tra & Test ✅
```
1. Chạy form DangNhap
2. Đăng nhập với: admin / admin123
3. Test các chức năng Quản lý Món Ăn
4. Test Thanh toán
```

---

## 📋 DỮ LIỆU MẶC ĐỊNH

### Tài Khoản
```
admin / admin123           → Quản lý
nhanvien1 / pass123        → Thu ngân
nhanvien2 / pass123        → Phục vụ bàn
```

### Nhân Viên (5 người)
```
NV001: Nguyễn Văn Anh      → Quản lý (15M)
NV002: Trần Thị Bình       → Thu ngân (8M)
NV003: Lê Văn Cường        → Phục vụ bàn (6M)
NV004: Phạm Thị Dung       → Phục vụ bàn (6M)
NV005: Võ Văn Emm          → Bếp (7M)
```

### Bàn (8 bàn)
```
Tầng 1: Bàn 01, 02, 03, 04, 07, 08 (2-6 chỗ)
Tầng 2: Bàn 05, 06 (8 chỗ)
```

### Khách Hàng (3 VIP)
```
KH001: Hoàng Anh Tuấn      → VIP (250 điểm)
KH002: Nguyễn Thị Hoa      → Vàng (150 điểm)
KH003: Lê Văn Phong        → Bạc (75 điểm)
```

### Món Ăn (10 món)
```
1. Lẩu Thái Thập Cẩm       → 350,000đ
2. Bò Mỹ Ba Chỉ Nhúng      → 120,000đ
3. Nước Ngọt Coca Cola     → 15,000đ
4. Khoai Tây Chiên Bơ Tỏi  → 45,000đ
5. Chạo Tôm               → 65,000đ
6. Ghiền Tôm              → 75,000đ
7. Gà Nướng Chanh         → 85,000đ
8. Cơm Chiên Hải Sản      → 95,000đ
9. Bia Hà Nội             → 25,000đ
10. Rượu Tây Bắc          → 100,000đ
```

---

## 🔄 WORKFLOW CHÍNH

### 1️⃣ Đăng Nhập
```
Nhân viên → Nhập user/pass → Kiểm tra TaiKhoan → Lấy Quyen
```

### 2️⃣ Lập Hóa Đơn
```
Chọn bàn → Nhập SĐT khách (nếu có) → Thêm món ăn → Tính tổng
```

### 3️⃣ Thanh Toán
```
Xác nhận các món → Áp dụng giảm giá → Chọn cách thanh toán
→ Tính tiền thừa → Lưu HoaDon + ChiTietHoaDon → In hóa đơn
```

### 4️⃣ Quản Lý Khách Hàng
```
Tìm khách hoặc Tạo mới → Cập nhật thông tin
→ Tích điểm → Đổi điểm (nếu đủ)
```

### 5️⃣ Báo Cáo
```
Chọn ngày → Thống kê doanh thu → Xuất báo cáo
```

---

## ⚙️ CÔNG NGHỆ SỬ DỤNG

| Thành phần | Công nghệ |
|-----------|-----------|
| **Backend** | SQL Server 2019/2022 |
| **Frontend** | Windows Forms (.NET Framework 4.7.2) |
| **Lập trình** | C# |
| **Driver** | SqlClient |
| **IDE** | Visual Studio 2026 |

---

## 🆘 CÓ LỖI?

### Lỗi: "Cannot connect to database"
✅ Kiểm tra Connection String
✅ Kiểm tra SQL Server đang chạy
✅ Kiểm tra tên server (localhost\SQLEXPRESS)

### Lỗi: "The database does not exist"
✅ Chạy lại DATABASE_SCRIPT.sql
✅ Kiểm tra database name: QuanLyNhaHang

### Lỗi: "Timeout expired"
✅ Tăng Connection Timeout: `Connection Timeout=30;`
✅ Kiểm tra query có quá lâu?

### Lỗi: "Cannot find table"
✅ Chạy script lại đầy đủ
✅ Kiểm tra database được chọn: `USE QuanLyNhaHang`

---

## 📞 HỖ TRỢ THÊM

Nếu cần:
1. ✅ Xem chi tiết bảng: `sp_help MonAn;`
2. ✅ Xem dữ liệu: `SELECT * FROM NhanVien;`
3. ✅ Test truy vấn trong SSMS trước update code
4. ✅ Sử dụng Ctrl+K + Ctrl+C để format code C#

---

## ✨ KẾT THÚC

Bây giờ bạn có:
- ✅ SQL Script hoàn chỉnh (DATABASE_SCRIPT.sql)
- ✅ Hướng dẫn chạy trên SSMS (HUONG_DAN_CHAY_DATABASE.md)
- ✅ Code C# đã update (CAP_NHAT_CODE_CS.md)
- ✅ Thiết kế CSDL rõ ràng (file này)

**Chúc mừng! Bạn đã sẵn sàng để tiếp tục dự án. 🎉**

