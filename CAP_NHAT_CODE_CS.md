# 📝 CẬP NHẬT CODE C# - HỆ THỐNG QUẢN LÝ NHÀ HÀNG

## 1️⃣ CONNECTION STRING CẬP NHẬT

### Vị trí cập nhật trong từng file:

#### 📄 **DangNhap.cs** (dòng ~22)
```csharp
// THAY THẾ:
string ketNoiCSDL = @"Data Source=localhost\SQLEXPRESS;
					  Initial Catalog=QuanLyNhaHang;
					  Integrated Security=True;
					  TrustServerCertificate=True;";
```

#### 📄 **QuanLyMonAn.cs** (dòng ~25)
```csharp
// THAY THẾ:
string ketNoiCSDL = @"Data Source=localhost\SQLEXPRESS;
					  Initial Catalog=QuanLyNhaHang;
					  Integrated Security=True;
					  TrustServerCertificate=True;";
```

---

## 2️⃣ CLASS ĐỂ HỖ TRỢ CSDL (Database Helper)

### Tạo file mới: `DatabaseHelper.cs`

```csharp
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace BTL_QuanLyNhaHang
{
	public class DatabaseHelper
	{
		// Connection string (sửa nếu cần)
		public static string ConnectionString = @"Data Source=localhost\SQLEXPRESS;
												   Initial Catalog=QuanLyNhaHang;
												   Integrated Security=True;
												   TrustServerCertificate=True;";

		/// <summary>
		/// Thực thi câu lệnh INSERT, UPDATE, DELETE
		/// </summary>
		public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
		{
			using (SqlConnection conn = new SqlConnection(ConnectionString))
			{
				conn.Open();
				using (SqlCommand cmd = new SqlCommand(query, conn))
				{
					if (parameters != null)
						cmd.Parameters.AddRange(parameters);
					return cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Thực thi câu lệnh SELECT, trả về DataTable
		/// </summary>
		public static DataTable ExecuteQuery(string query, SqlParameter[] parameters = null)
		{
			DataTable dt = new DataTable();
			using (SqlConnection conn = new SqlConnection(ConnectionString))
			{
				conn.Open();
				using (SqlCommand cmd = new SqlCommand(query, conn))
				{
					if (parameters != null)
						cmd.Parameters.AddRange(parameters);
					SqlDataAdapter adapter = new SqlDataAdapter(cmd);
					adapter.Fill(dt);
				}
			}
			return dt;
		}

		/// <summary>
		/// Thực thi câu lệnh trả về một giá trị (Scalar)
		/// </summary>
		public static object ExecuteScalar(string query, SqlParameter[] parameters = null)
		{
			using (SqlConnection conn = new SqlConnection(ConnectionString))
			{
				conn.Open();
				using (SqlCommand cmd = new SqlCommand(query, conn))
				{
					if (parameters != null)
						cmd.Parameters.AddRange(parameters);
					return cmd.ExecuteScalar();
				}
			}
		}

		/// <summary>
		/// Kiểm tra kết nối CSDL
		/// </summary>
		public static bool TestConnection()
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(ConnectionString))
				{
					conn.Open();
					return true;
				}
			}
			catch (Exception ex)
			{
				System.Windows.Forms.MessageBox.Show("Lỗi kết nối: " + ex.Message);
				return false;
			}
		}
	}
}
```

---

## 3️⃣ CẬP NHẬT CHO QuanLyMonAn.cs (Lấy dữ liệu từ CSDL thực)

### Thay thế method `LoadData()`:
```csharp
private void LoadData()
{
	try
	{
		string query = "SELECT m.MaMon, m.TenMon, l.TenLoai, m.Gia, m.DonVi " +
					   "FROM MonAn m " +
					   "INNER JOIN LoaiMonAn l ON m.MaLoai = l.MaLoai " +
					   "WHERE m.TrangThai = 1 " +
					   "ORDER BY l.TenLoai, m.TenMon";

		DataTable dt = DatabaseHelper.ExecuteQuery(query);
		dgvMonAn.DataSource = dt;
	}
	catch (Exception ex)
	{
		MessageBox.Show("Lỗi tải dữ liệu: " + ex.Message);
	}
}
```

### Thay thế method `btnThem_Click()`:
```csharp
private void btnThem_Click(object sender, EventArgs e)
{
	try
	{
		if (string.IsNullOrWhiteSpace(txtTenMon.Text))
		{
			MessageBox.Show("Vui lòng nhập tên món ăn!");
			return;
		}

		// Kiểm tra trùng lặp
		string queryCheck = "SELECT COUNT(*) FROM MonAn WHERE TenMon = @tenCheck";
		SqlParameter[] paramsCheck = { new SqlParameter("@tenCheck", txtTenMon.Text.Trim()) };

		int count = Convert.ToInt32(DatabaseHelper.ExecuteScalar(queryCheck, paramsCheck));
		if (count > 0)
		{
			MessageBox.Show("Tên món ăn này đã tồn tại!");
			return;
		}

		// Thêm mới
		string query = "INSERT INTO MonAn (TenMon, MaLoai, Gia, DonVi, TrangThai) " +
					   "VALUES (@ten, @loai, @gia, @donvi, 1)";

		SqlParameter[] parameters = {
			new SqlParameter("@ten", txtTenMon.Text),
			new SqlParameter("@loai", Convert.ToInt32(cmbLoaiMon.SelectedValue ?? 0)),
			new SqlParameter("@gia", Convert.ToInt32(txtDonGia.Text ?? "0")),
			new SqlParameter("@donvi", cmbDonVi.Text)
		};

		int result = DatabaseHelper.ExecuteNonQuery(query, parameters);
		if (result > 0)
		{
			MessageBox.Show("Thêm thành công!");
			ClearTextBoxes();
			LoadData();
		}
	}
	catch (Exception ex)
	{
		MessageBox.Show("Lỗi: " + ex.Message);
	}
}
```

---

## 4️⃣ CẬP NHẬT CHO DangNhap.cs (Xác thực từ CSDL)

### Thay thế method `Form1_Load()`:
```csharp
private void Form1_Load(object sender, EventArgs e)
{
	if (!DatabaseHelper.TestConnection())
	{
		MessageBox.Show("Không thể kết nối Database!");
		this.Close();
		return;
	}
	MessageBox.Show("Đã kết nối Database thành công!");
}
```

### Thay thế method `btnDangNhap_Click()`:
```csharp
private void btnDangNhap_Click(object sender, EventArgs e)
{
	try
	{
		if (string.IsNullOrWhiteSpace(txtTenDangNhap.Text) || 
			string.IsNullOrWhiteSpace(txtMatKhau.Text))
		{
			MessageBox.Show("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
			return;
		}

		string query = "SELECT Quyen FROM TaiKhoan " +
					   "WHERE TenDangNhap = @tk AND MatKhau = @mk AND TrangThai = 1";

		SqlParameter[] parameters = {
			new SqlParameter("@tk", txtTenDangNhap.Text),
			new SqlParameter("@mk", txtMatKhau.Text)
		};

		object result = DatabaseHelper.ExecuteScalar(query, parameters);

		if (result != null)
		{
			MessageBox.Show("Đăng nhập thành công! Chức vụ: " + result.ToString());
			QuanLyMonAn qlma = new QuanLyMonAn();
			qlma.Show();
			this.Hide();
		}
		else
		{
			MessageBox.Show("Tên đăng nhập hoặc mật khẩu không đúng!");
		}
	}
	catch (Exception ex)
	{
		MessageBox.Show("Lỗi: " + ex.Message);
	}
}
```

---

## 5️⃣ CẬP NHẬT CHO NhanVien.cs (Từ file nhanvien.cs)

### Thay thế phương thức LoadData để lấy từ CSDL:
```csharp
private void LoadData()
{
	try
	{
		string query = "SELECT MaNV, HoTen, ChucVu, SDT, LuongCoBan FROM NhanVien WHERE TrangThai = 1 ORDER BY MaNV";
		DataTable dt = DatabaseHelper.ExecuteQuery(query);

		listNhanVien.Clear();
		foreach (DataRow row in dt.Rows)
		{
			listNhanVien.Add(new Employee
			{
				MaNV = row["MaNV"].ToString(),
				HoTen = row["HoTen"].ToString(),
				ChucVu = row["ChucVu"].ToString(),
				SDT = row["SDT"].ToString(),
				LuongCoBan = Convert.ToInt64(row["LuongCoBan"])
			});
		}

		LoadDataGrid();
	}
	catch (Exception ex)
	{
		MessageBox.Show("Lỗi tải dữ liệu: " + ex.Message);
	}
}
```

---

## 6️⃣ TRUY VẤN HỮUÍCH CHO TỪNG CHỨC NĂNG

### 🎯 Thanh toán (Form1.cs từ thanh_toan folder)

```csharp
// Tính tổng tiền hóa đơn
public decimal CalculateTotal(string maHD)
{
	string query = "SELECT SUM(ThanhTien) FROM ChiTietHoaDon WHERE MaHD = @ma";
	SqlParameter[] param = { new SqlParameter("@ma", maHD) };
	object result = DatabaseHelper.ExecuteScalar(query, param);
	return result != null ? Convert.ToDecimal(result) : 0;
}

// Lưu hóa đơn
public bool SaveHoaDon(string maHD, int maBan, string maKH, string maNV, 
					   decimal tongTien, int giamGia, string phuongThuc)
{
	string query = @"INSERT INTO HoaDon 
					 (MaHD, MaBan, MaKH, MaNV, TongTienGoc, PhanTramGiamGia, 
					  TienGiamGia, TongTienPhaiTra, PhuongThucTT, TrangThai)
					 VALUES (@ma, @ban, @kh, @nv, @tong, @giam, @tiengiam, @trasoat, @pt, 'Đã thanh toán')";

	decimal tienGiam = (tongTien * giamGia / 100);
	decimal trasoat = tongTien - tienGiam;

	SqlParameter[] param = {
		new SqlParameter("@ma", maHD),
		new SqlParameter("@ban", maBan),
		new SqlParameter("@kh", maKH ?? (object)DBNull.Value),
		new SqlParameter("@nv", maNV),
		new SqlParameter("@tong", (long)tongTien),
		new SqlParameter("@giam", giamGia),
		new SqlParameter("@tiengiam", (long)tienGiam),
		new SqlParameter("@trasoat", (long)trasoat),
		new SqlParameter("@pt", phuongThuc)
	};

	return DatabaseHelper.ExecuteNonQuery(query, param) > 0;
}
```

### 📊 Báo cáo - Thống kê (QLKH.cs)

```csharp
// Lấy danh sách khách hàng
public DataTable GetKhachHang()
{
	string query = "SELECT MaKH, HoTen, SDT, HangThanhVien, DiemThuong FROM KhachHang WHERE TrangThai = 1 ORDER BY MaKH";
	return DatabaseHelper.ExecuteQuery(query);
}

// Doanh thu theo ngày
public DataTable GetThongKeDoanhThu(DateTime ngay)
{
	string query = @"SELECT 
						COUNT(*) AS SoHoaDon,
						SUM(TongTienPhaiTra) AS TongDoanhThu,
						COUNT(DISTINCT MaKH) AS SoKhachHang
					 FROM HoaDon
					 WHERE CAST(NgayGio AS DATE) = @ngay";

	SqlParameter[] param = { new SqlParameter("@ngay", ngay.Date) };
	return DatabaseHelper.ExecuteQuery(query, param);
}
```

---

## ⚠️ LƯU Ý QUAN TRỌNG

1. **Connection String:** Sửa `localhost\SQLEXPRESS` nếu server tên khác
2. **TrustServerCertificate=True:** Cần cho SQL 2022
3. **Integrated Security=True:** Dùng Windows Authentication (không cần user/password)
4. **Testing:** Chạy `DatabaseHelper.TestConnection()` trước khi sử dụng

---

## ✅ KIỂM TRA SAU CẬP NHẬT

1. Biên dịch project (`Ctrl + Shift + B`)
2. Chạy form DangNhap
3. Kiểm tra thông báo "Đã kết nối Database thành công!"
4. Thử đăng nhập với: `admin` / `admin123`

**Nếu lỗi, kiểm tra:**
- ✅ Database `QuanLyNhaHang` đã được tạo?
- ✅ Connection string có khớp?
- ✅ SQL Server đang chạy?

