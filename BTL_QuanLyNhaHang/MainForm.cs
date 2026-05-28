using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BTL_QuanLyNhaHang
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            this.Text = "Hệ Thống Quản Lý Nhà Hàng";
            this.WindowState = FormWindowState.Maximized;

            // Tạo TabControl
            TabControl tabControl = new TabControl();
            tabControl.Dock = DockStyle.Fill;
            this.Controls.Add(tabControl);

            // Tab 1: Quản Lý Nhân Viên
            TabPage tabNhanVien = new TabPage("Quản Lý Nhân Viên");
            CreateNhanVienTab(tabNhanVien);
            tabControl.TabPages.Add(tabNhanVien);

            // Tab 2: Quản Lý Món Ăn
            TabPage tabMonAn = new TabPage("Quản Lý Món Ăn");
            CreateMonAnTab(tabMonAn);
            tabControl.TabPages.Add(tabMonAn);

            // Tab 3: Thanh Toán
            TabPage tabThanhToan = new TabPage("Thanh Toán");
            CreateThanhToanTab(tabThanhToan);
            tabControl.TabPages.Add(tabThanhToan);

            // Tab 4: Quản Lý Khách Hàng
            TabPage tabKhachHang = new TabPage("Quản Lý Khách Hàng");
            CreateKhachHangTab(tabKhachHang);
            tabControl.TabPages.Add(tabKhachHang);

            // Tab 5: Báo Cáo & Thống Kê
            TabPage tabBaoCao = new TabPage("Báo Cáo");
            CreateBaoCaoTab(tabBaoCao);
            tabControl.TabPages.Add(tabBaoCao);
        }

        // ========== TAB 1: QUẢN LÝ NHÂN VIÊN ==========
        private void CreateNhanVienTab(TabPage tab)
        {
            // Panel tìm kiếm
            Panel pnlSearch = new Panel { Height = 60, Dock = DockStyle.Top, BorderStyle = BorderStyle.FixedSingle };
            Label lblSearch = new Label { Text = "Tìm kiếm:", Location = new Point(10, 15), AutoSize = true };
            TextBox txtSearch = new TextBox { Location = new Point(80, 12), Width = 200 };
            Button btnSearch = new Button { Text = "Tìm", Location = new Point(290, 12), Width = 60 };
            pnlSearch.Controls.AddRange(new Control[] { lblSearch, txtSearch, btnSearch });

            // DataGridView
            DataGridView dgv = new DataGridView { Dock = DockStyle.Fill, ReadOnly = true, AllowUserToAddRows = false };
            dgv.Columns.Add("MaNV", "Mã NV");
            dgv.Columns.Add("HoTen", "Họ Tên");
            dgv.Columns.Add("ChucVu", "Chức Vụ");
            dgv.Columns.Add("SDT", "Số Điện Thoại");
            dgv.Columns.Add("Luong", "Lương");

            LoadNhanVienData(dgv);

            tab.Controls.Add(dgv);
            tab.Controls.Add(pnlSearch);
        }

        private void LoadNhanVienData(DataGridView dgv)
        {
            try
            {
                string query = "SELECT MaNV, HoTen, ChucVu, SDT, LuongCoBan FROM NhanVien WHERE TrangThai = 1 ORDER BY MaNV";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                dgv.Rows.Clear();
                foreach (DataRow row in dt.Rows)
                {
                    dgv.Rows.Add(
                        row["MaNV"],
                        row["HoTen"],
                        row["ChucVu"],
                        row["SDT"],
                        string.Format("{0:N0}", row["LuongCoBan"])
                    );
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải nhân viên: " + ex.Message);
            }
        }

        // ========== TAB 2: QUẢN LÝ MÓN ĂN ==========
        private void CreateMonAnTab(TabPage tab)
        {
            // Panel input
            Panel pnlInput = new Panel { Height = 140, Dock = DockStyle.Top, BorderStyle = BorderStyle.FixedSingle };

            Label lblTen = new Label { Text = "Tên Món:", Location = new Point(10, 10), AutoSize = true };
            TextBox txtTenMon = new TextBox { Location = new Point(100, 7), Width = 200 };

            Label lblLoai = new Label { Text = "Loại:", Location = new Point(310, 10), AutoSize = true };
            ComboBox cmbLoai = new ComboBox { Location = new Point(380, 7), Width = 150, DropDownStyle = ComboBoxStyle.DropDownList };
            LoadLoaiMonAn(cmbLoai);

            Label lblGia = new Label { Text = "Giá:", Location = new Point(10, 45), AutoSize = true };
            TextBox txtGia = new TextBox { Location = new Point(100, 42), Width = 200 };

            Label lblDonVi = new Label { Text = "Đơn Vị:", Location = new Point(310, 45), AutoSize = true };
            TextBox txtDonVi = new TextBox { Location = new Point(380, 42), Width = 150 };

            Button btnThem = new Button { Text = "Thêm", Location = new Point(100, 80), Width = 80 };
            Button btnSua = new Button { Text = "Sửa", Location = new Point(190, 80), Width = 80 };
            Button btnXoa = new Button { Text = "Xóa", Location = new Point(280, 80), Width = 80 };

            pnlInput.Controls.AddRange(new Control[] { 
                lblTen, txtTenMon, lblLoai, cmbLoai, lblGia, txtGia, lblDonVi, txtDonVi,
                btnThem, btnSua, btnXoa
            });

            // DataGridView
            DataGridView dgv = new DataGridView { Dock = DockStyle.Fill, AllowUserToAddRows = false };
            dgv.Columns.Add("MaMon", "Mã");
            dgv.Columns.Add("TenMon", "Tên Món");
            dgv.Columns.Add("Loai", "Loại");
            dgv.Columns.Add("Gia", "Giá");
            dgv.Columns.Add("DonVi", "Đơn Vị");

            LoadMonAnData(dgv);

            tab.Controls.Add(dgv);
            tab.Controls.Add(pnlInput);
        }

        private void LoadLoaiMonAn(ComboBox cmb)
        {
            try
            {
                string query = "SELECT MaLoai, TenLoai FROM LoaiMonAn";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                cmb.DataSource = dt;
                cmb.DisplayMember = "TenLoai";
                cmb.ValueMember = "MaLoai";
            }
            catch { }
        }

        private void LoadMonAnData(DataGridView dgv)
        {
            try
            {
                string query = @"SELECT m.MaMon, m.TenMon, l.TenLoai, m.Gia, m.DonVi 
                                FROM MonAn m 
                                INNER JOIN LoaiMonAn l ON m.MaLoai = l.MaLoai 
                                WHERE m.TrangThai = 1";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                dgv.Rows.Clear();
                foreach (DataRow row in dt.Rows)
                {
                    dgv.Rows.Add(
                        row["MaMon"],
                        row["TenMon"],
                        row["TenLoai"],
                        string.Format("{0:N0}", row["Gia"]),
                        row["DonVi"]
                    );
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải món ăn: " + ex.Message);
            }
        }

        // ========== TAB 3: THANH TOÁN ==========
        private void CreateThanhToanTab(TabPage tab)
        {
            Label lblThongBao = new Label { 
                Text = "Tab Thanh Toán - Chọn bàn & thêm món để tạo hóa đơn", 
                Dock = DockStyle.Fill,
                TextAlign = ContentAlignment.MiddleCenter,
                Font = new Font("Arial", 14)
            };
            tab.Controls.Add(lblThongBao);
        }

        // ========== TAB 4: QUẢN LÝ KHÁCH HÀNG ==========
        private void CreateKhachHangTab(TabPage tab)
        {
            // Panel input
            Panel pnlInput = new Panel { Height = 100, Dock = DockStyle.Top, BorderStyle = BorderStyle.FixedSingle };

            Label lblHoTen = new Label { Text = "Họ Tên:", Location = new Point(10, 10), AutoSize = true };
            TextBox txtHoTen = new TextBox { Location = new Point(80, 7), Width = 200 };

            Label lblSDT = new Label { Text = "SĐT:", Location = new Point(290, 10), AutoSize = true };
            TextBox txtSDT = new TextBox { Location = new Point(330, 7), Width = 150 };

            Label lblHang = new Label { Text = "Hạng:", Location = new Point(490, 10), AutoSize = true };
            ComboBox cmbHang = new ComboBox { Location = new Point(530, 7), Width = 100, DropDownStyle = ComboBoxStyle.DropDownList };
            cmbHang.Items.AddRange(new string[] { "Đồng", "Bạc", "Vàng", "Vip" });

            Button btnThem = new Button { Text = "Thêm KH", Location = new Point(80, 50), Width = 80 };
            Button btnSua = new Button { Text = "Sửa", Location = new Point(170, 50), Width = 80 };

            pnlInput.Controls.AddRange(new Control[] { 
                lblHoTen, txtHoTen, lblSDT, txtSDT, lblHang, cmbHang, btnThem, btnSua
            });

            // DataGridView
            DataGridView dgv = new DataGridView { Dock = DockStyle.Fill, AllowUserToAddRows = false };
            dgv.Columns.Add("MaKH", "Mã KH");
            dgv.Columns.Add("HoTen", "Họ Tên");
            dgv.Columns.Add("SDT", "SĐT");
            dgv.Columns.Add("Hang", "Hạng");
            dgv.Columns.Add("Diem", "Điểm");

            LoadKhachHangData(dgv);

            tab.Controls.Add(dgv);
            tab.Controls.Add(pnlInput);
        }

        private void LoadKhachHangData(DataGridView dgv)
        {
            try
            {
                string query = "SELECT MaKH, HoTen, SDT, HangThanhVien, DiemThuong FROM KhachHang WHERE TrangThai = 1";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                dgv.Rows.Clear();
                foreach (DataRow row in dt.Rows)
                {
                    dgv.Rows.Add(
                        row["MaKH"],
                        row["HoTen"],
                        row["SDT"],
                        row["HangThanhVien"],
                        row["DiemThuong"]
                    );
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải khách hàng: " + ex.Message);
            }
        }

        // ========== TAB 5: BÁO CÁO & THỐNG KÊ ==========
        private void CreateBaoCaoTab(TabPage tab)
        {
            // Panel chọn loại báo cáo
            Panel pnlControl = new Panel { Height = 60, Dock = DockStyle.Top, BorderStyle = BorderStyle.FixedSingle };

            Label lblLoai = new Label { Text = "Chọn báo cáo:", Location = new Point(10, 15), AutoSize = true };
            ComboBox cmbLoai = new ComboBox { Location = new Point(110, 12), Width = 250, DropDownStyle = ComboBoxStyle.DropDownList };
            cmbLoai.Items.AddRange(new string[] { 
                "Doanh thu theo ngày",
                "Doanh thu theo tháng",
                "Top 5 món bán chạy",
                "Top khách hàng chi tiêu nhiều",
                "Chi phí lương",
                "Danh sách nhân viên"
            });
            cmbLoai.SelectedIndex = 0;

            Button btnXem = new Button { Text = "Xem", Location = new Point(370, 12), Width = 60 };

            pnlControl.Controls.AddRange(new Control[] { lblLoai, cmbLoai, btnXem });

            // DataGridView
            DataGridView dgv = new DataGridView { Dock = DockStyle.Fill, AllowUserToAddRows = false, ReadOnly = true };

            btnXem.Click += (s, e) =>
            {
                string loai = cmbLoai.SelectedItem?.ToString() ?? "";
                LoadBaoCao(dgv, loai);
            };

            tab.Controls.Add(dgv);
            tab.Controls.Add(pnlControl);
        }

        private void LoadBaoCao(DataGridView dgv, string loai)
        {
            try
            {
                dgv.Rows.Clear();
                dgv.Columns.Clear();

                string query = "";

                switch (loai)
                {
                    case "Doanh thu theo ngày":
                        query = @"SELECT CAST(NgayGio AS DATE) AS Ngay, COUNT(*) AS SoHoaDon, 
                                 SUM(TongTienPhaiTra) AS DoanhThu FROM HoaDon 
                                 GROUP BY CAST(NgayGio AS DATE) ORDER BY Ngay DESC";
                        break;

                    case "Top 5 món bán chạy":
                        query = @"SELECT TOP 5 m.TenMon, SUM(ct.SoLuong) AS SoLuong, 
                                 SUM(ct.ThanhTien) AS DoanhThu FROM ChiTietHoaDon ct
                                 INNER JOIN MonAn m ON ct.MaMon = m.MaMon 
                                 GROUP BY m.TenMon ORDER BY SoLuong DESC";
                        break;

                    case "Top khách hàng chi tiêu nhiều":
                        query = @"SELECT TOP 10 k.HoTen, COUNT(h.MaHD) AS SoHoaDon, 
                                 SUM(h.TongTienPhaiTra) AS TongChiTieu FROM KhachHang k
                                 LEFT JOIN HoaDon h ON k.MaKH = h.MaKH 
                                 GROUP BY k.HoTen ORDER BY TongChiTieu DESC";
                        break;

                    case "Chi phí lương":
                        query = @"SELECT Thang, Nam, COUNT(DISTINCT MaNV) AS SoNV, 
                                 SUM(LuongThucLinh) AS TongLuong FROM LuongNhanVien 
                                 GROUP BY Thang, Nam ORDER BY Nam DESC, Thang DESC";
                        break;

                    case "Danh sách nhân viên":
                        query = @"SELECT MaNV, HoTen, ChucVu, SDT, LuongCoBan FROM NhanVien 
                                 WHERE TrangThai = 1 ORDER BY MaNV";
                        break;
                }

                if (!string.IsNullOrEmpty(query))
                {
                    DataTable dt = DatabaseHelper.ExecuteQuery(query);
                    foreach (DataColumn col in dt.Columns)
                    {
                        dgv.Columns.Add(col.ColumnName, col.ColumnName);
                    }

                    foreach (DataRow row in dt.Rows)
                    {
                        object[] values = new object[row.ItemArray.Length];
                        for (int i = 0; i < row.ItemArray.Length; i++)
                        {
                            values[i] = row[i];
                        }
                        dgv.Rows.Add(values);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải báo cáo: " + ex.Message);
            }
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            // Khi đóng MainForm, quay lại form DangNhap
            DangNhap frmDN = new DangNhap();
            frmDN.Show();
        }
    }
}
