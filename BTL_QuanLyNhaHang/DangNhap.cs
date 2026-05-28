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
    public partial class DangNhap : Form
    {
        public DangNhap()
        {
            InitializeComponent();
        }

        // SỰ KIỆN 1: KHI FORM VỪA MỞ LÊN (Kiểm tra kết nối)
        private void Form1_Load(object sender, EventArgs e)
        {
            if (DatabaseHelper.TestConnection())
            {
                MessageBox.Show("Đã kết nối Database thành công!", "Xác nhận", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show("Không thể kết nối Database! Vui lòng kiểm tra lại.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnDangNhap_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtTenDangNhap.Text.Trim() == "" || txtMatKhau.Text.Trim() == "")
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ Tên đăng nhập và Mật khẩu!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                // Tìm kiếm tài khoản
                string query = "SELECT Quyen FROM TaiKhoan WHERE TenDangNhap = @TK AND MatKhau = @MK AND TrangThai = 1";
                SqlParameter[] parameters = {
                    new SqlParameter("@TK", txtTenDangNhap.Text),
                    new SqlParameter("@MK", txtMatKhau.Text)
                };

                object ketQua = DatabaseHelper.ExecuteScalar(query, parameters);

                if (ketQua != null)
                {
                    // Đăng nhập thành công
                    MessageBox.Show("Đăng nhập thành công! Chức vụ: " + ketQua.ToString(), "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);

                    // Mở MainForm thay vì QuanLyMonAn
                    MainForm mainForm = new MainForm();
                    mainForm.Show();
                    this.Hide();
                }
                else
                {
                    // Sai tài khoản hoặc mật khẩu
                    MessageBox.Show("Tên đăng nhập hoặc mật khẩu không đúng!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtMatKhau.Clear();
                    txtTenDangNhap.Focus();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void cbHienMatKhau_CheckedChanged(object sender, EventArgs e)
        {
            if (cbHienMatKhau.Checked == true)
            {
                // Nếu ô vuông được tích -> Trả lại ký tự rỗng ('\0') để hiện chữ bình thường
                txtMatKhau.PasswordChar = '\0';
            }
            else
            {
                // Nếu ô vuông bị bỏ tích -> Đổi các chữ đã nhập thành dấu sao
                txtMatKhau.PasswordChar = '*';
            }
        }

        private void btnChuyenDK_Click(object sender, EventArgs e)
        {
            // 1. Tạo ra một bản sao của Form Đăng Ký
            DangKy frmDK = new DangKy(); 

            // 2. Ẩn Form Đăng nhập hiện tại đi 
            this.Hide();

            // 3. Hiển thị Form Đăng ký lên
            // Dùng ShowDialog() để người dùng bắt buộc phải thao tác xong bên Đăng ký mới về lại được
            frmDK.ShowDialog();

            // 4. Dòng code này sẽ tự động chạy SAU KHI Form Đăng ký bị đóng
            // Nó giúp hiển thị lại Form Đăng nhập
            this.Show();
        }
    } 
}
