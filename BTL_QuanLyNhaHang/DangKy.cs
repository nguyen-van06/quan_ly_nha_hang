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
    public partial class DangKy : Form
    {
        public DangKy()
        {
            InitializeComponent();
        }

        private void btnDangKy_Click(object sender, EventArgs e)
        {
            try
            {
                // Bước 1: Kiểm tra xem có để trống ô nào không
                if (txtTenDangKy.Text.Trim() == "" || txtMatKhau.Text.Trim() == "" || txtXacNhanMK.Text.Trim() == "")
                {
                    MessageBox.Show("Vui lòng điền đầy đủ thông tin!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                // Bước 2: Kiểm tra mật khẩu và xác nhận mật khẩu có giống nhau không
                if (txtMatKhau.Text != txtXacNhanMK.Text)
                {
                    MessageBox.Show("Mật khẩu xác nhận không khớp!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                // Bước 3: Kiểm tra xem Tên đăng nhập này đã có ai dùng chưa
                string checkQuery = "SELECT COUNT(*) FROM TaiKhoan WHERE TenDangNhap = @TK";
                SqlParameter[] checkParam = { new SqlParameter("@TK", txtTenDangKy.Text) };

                object result = DatabaseHelper.ExecuteScalar(checkQuery, checkParam);
                int tonTai = result != null ? Convert.ToInt32(result) : 0;

                if (tonTai > 0)
                {
                    MessageBox.Show("Tên tài khoản này đã tồn tại, vui lòng chọn tên khác!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                // Bước 4: Nếu chưa ai dùng -> Thực hiện thêm mới vào CSDL
                // Thêm Quyen = 'Thu ngân' mặc định
                string insertQuery = "INSERT INTO TaiKhoan (TenDangNhap, MatKhau, Quyen, TrangThai) VALUES (@TK, @MK, @Q, 1)";
                SqlParameter[] insertParam = {
                    new SqlParameter("@TK", txtTenDangKy.Text),
                    new SqlParameter("@MK", txtMatKhau.Text),
                    new SqlParameter("@Q", "Thu ngân")
                };

                int affectedRows = DatabaseHelper.ExecuteNonQuery(insertQuery, insertParam);

                if (affectedRows > 0)
                {
                    MessageBox.Show("Đăng ký tài khoản thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    this.Close();
                }
                else
                {
                    MessageBox.Show("Đăng ký thất bại! Vui lòng thử lại.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
