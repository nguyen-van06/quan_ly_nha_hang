# 🍽️ Hệ Thống Quản Lý Nhà Hàng

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.7.2-blue)](https://www.microsoft.com/net/download)
[![Visual Studio](https://img.shields.io/badge/Visual%20Studio-2026-blue)](https://visualstudio.microsoft.com/)

Một ứng dụng Windows Forms quản lý hoàn chỉnh cho nhà hàng, bao gồm quản lý nhân viên, món ăn, khách hàng và thanh toán.

## 📋 Mục Lục
- [Tính Năng](#tính-năng)
- [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
- [Cài Đặt](#cài-đặt)
- [Hướng Dẫn Sử Dụng](#hướng-dẫn-sử-dụng)
- [Đóng Góp](#đóng-góp)

---

## ✨ Tính Năng

### 🔐 Xác Thực
- ✅ Đăng nhập với tài khoản & mật khẩu
- ✅ Đăng ký tài khoản mới
- ✅ 3 mức quyền: Quản lý, Thu ngân, Phục vụ

### 👨‍💼 Quản Lý Nhân Viên
- ✅ Xem danh sách nhân viên
- ✅ Thêm/Sửa/Xóa nhân viên
- ✅ Quản lý chức vụ & lương

### 🍽️ Quản Lý Món Ăn
- ✅ Danh sách món ăn phân loại
- ✅ Quản lý giá & đơn vị tính
- ✅ Thêm/Sửa/Xóa món

### 🧑‍💼 Quản Lý Khách Hàng
- ✅ Thông tin khách hàng
- ✅ Phân hạng thành viên
- ✅ Tích luỹ điểm thưởng

### 💳 Thanh Toán
- ✅ Tạo hóa đơn tự động
- ✅ Tính giảm giá & tiền thừa
- ✅ 3 phương thức thanh toán

### 📊 Báo Cáo & Thống Kê
- ✅ Doanh thu theo ngày/tháng
- ✅ Top 5 món bán chạy
- ✅ Chi phí lương

---

## 🖥️ Yêu Cầu Hệ Thống

### Phần Mềm
- **OS:** Windows 7 / 10 / 11
- **.NET Framework:** 4.7.2+
- **SQL Server:** 2019, 2022 (Express)
- **IDE:** Visual Studio 2019+

---

## 📦 Cài Đặt

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/BTL_QuanLyNhaHang.git
cd BTL_QuanLyNhaHang
```

### 2. Database
```
1. Mở SQL Server Management Studio
2. Chạy: DATABASE_SCRIPT.sql
3. Sửa connection string nếu cần
```

### 3. Chạy Ứng Dụng
```
1. Mở Visual Studio
2. Mở: BTL_QuanLyNhaHang.slnx
3. Nhấn F5
```

### 4. Đăng Nhập
```
Username: admin
Password: admin123
```

---

## 📖 Đóng Góp

Xem **COLLABORATION.md** để hướng dẫn đóng góp vào project.

### Quy Trình
1. Fork repository
2. Tạo branch: `git checkout -b feature/YourFeature`
3. Commit: `git commit -m 'Add feature'`
4. Push: `git push origin feature/YourFeature`
5. Pull Request

---

## 📝 License

MIT License - xem file [LICENSE](LICENSE)

---

**Last Updated:** Tháng 5, 2026
