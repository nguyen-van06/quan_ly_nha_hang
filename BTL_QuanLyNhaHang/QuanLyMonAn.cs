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
    public partial class QuanLyMonAn : Form
    {
        public QuanLyMonAn()
        {
            InitializeComponent();
        }

        string ketNoiCSDL = @"Data Source=localhost\SQLEXPRESS;Initial Catalog=QuanLyNhaHang;Integrated Security=True;TrustServerCertificate=True;";
        SqlConnection conn;

        private void QuanLyMonAn_Load(object sender, EventArgs e)
        {
            conn = new SqlConnection(ketNoiCSDL);
            LoadData();
        }

        private void LoadData()
        {
            conn.Open();
            string query = "SELECT * FROM MonAn";
            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            dgvMonAn.DataSource = dt;
            conn.Close();
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            conn.Open();
            string queryCheck = "SELECT COUNT(*) FROM MonAn WHERE TenMon = @tenCheck";
            SqlCommand cmdCheck = new SqlCommand(queryCheck, conn);
            cmdCheck.Parameters.AddWithValue("@tenCheck", txtTenMon.Text.Trim()); 

            int count = Convert.ToInt32(cmdCheck.ExecuteScalar());

            if (count > 0)
            { 
                MessageBox.Show("Tên món ăn này đã tồn tại trong thực đơn! Vui lòng kiểm tra lại.",
                                "Thông báo trùng lặp", MessageBoxButtons.OK, MessageBoxIcon.Error);
                ClearTextBoxes();
                return;      
            }


            string query = "INSERT INTO MonAn (TenMon, LoaiMon, Gia, DonVi) VALUES (@ten, @loai, @gia, @donvi)";
            SqlCommand cmd = new SqlCommand(query, conn);

            cmd.Parameters.AddWithValue("@ten", txtTenMon.Text);
            cmd.Parameters.AddWithValue("@loai", cmbLoaiMon.Text);
            cmd.Parameters.AddWithValue("@gia", int.Parse(txtDonGia.Text));
            cmd.Parameters.AddWithValue("@donvi", cmbDonVi.Text);

            cmd.ExecuteNonQuery();
            MessageBox.Show("Thêm món ăn thành công!");

            ClearTextBoxes();
            conn.Close();
            LoadData();
        }

        private void btnCapNhat_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtMaMon.Text))
            {
                MessageBox.Show("Vui lòng click chọn một món ăn từ danh sách trước khi thực hiện cập nhật!",
                                "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            conn.Open();
            // Sửa thông tin dựa vào Mã món ăn
            string query = "UPDATE MonAn SET TenMon = @ten, LoaiMon = @loai, Gia = @gia, DonVi = @donvi WHERE MaMon = @ma";
            SqlCommand cmd = new SqlCommand(query, conn);

            cmd.Parameters.AddWithValue("@ma", txtMaMon.Text);
            cmd.Parameters.AddWithValue("@ten", txtTenMon.Text);
            cmd.Parameters.AddWithValue("@loai", cmbLoaiMon.Text);
            cmd.Parameters.AddWithValue("@gia", int.Parse(txtDonGia.Text));
            cmd.Parameters.AddWithValue("@donvi", cmbDonVi.Text);

            cmd.ExecuteNonQuery();
            MessageBox.Show("Cập nhật thành công!");

            ClearTextBoxes();
            conn.Close();
            LoadData();
        }

        private void dgvMonAn_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                // Lấy dòng dữ liệu hiện tại được chọn
                DataGridViewRow row = dgvMonAn.Rows[e.RowIndex];

                // Đẩy thông tin từ các cột của hàng được chọn lên các ô nhập liệu bên phải
                // (Thay tên "MaMon", "TenMon"... bằng đúng tên cột dữ liệu của bạn)
                txtMaMon.Text = row.Cells["MaMon"].Value.ToString();
                txtTenMon.Text = row.Cells["TenMon"].Value.ToString();
                cmbLoaiMon.Text = row.Cells["LoaiMon"].Value.ToString();
                txtDonGia.Text = row.Cells["Gia"].Value.ToString();
                cmbDonVi.Text = row.Cells["DonVi"].Value.ToString();

                // KHÓA ô Mã món ăn lại (Không cho sửa mã khi đang thực hiện chức năng sửa thông tin)
                txtMaMon.ReadOnly = true;
            }
        }

        // hàm xóa ô nhập liệu
        private void ClearTextBoxes()
        {
            txtMaMon.Clear();
            txtTenMon.Clear();
            cmbLoaiMon.SelectedIndex = -1; // Đưa combobox về trạng thái chưa chọn
            txtDonGia.Clear();
            cmbDonVi.SelectedIndex = -1;
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtMaMon.Text))
            {
                MessageBox.Show("Vui lòng click chọn một hàng món ăn từ danh sách trước khi xóa!",
                                "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DialogResult result = MessageBox.Show($"Bạn có chắc chắn muốn xóa món ăn có mã: {txtMaMon.Text} không?", "Xác nhận xóa", MessageBoxButtons.YesNo);


            if (result == DialogResult.Yes)
            {

                conn.Open();

                // Câu lệnh SQL thực hiện xóa dựa vào Mã món
                string query = "DELETE FROM MonAn WHERE MaMon = @ma";
                SqlCommand cmd = new SqlCommand(query, conn);

                // Truyền mã món ăn của hàng đang chọn vào câu lệnh SQL
                cmd.Parameters.AddWithValue("@ma", txtMaMon.Text);

                // Thực thi câu lệnh xóa
                int check = cmd.ExecuteNonQuery();

                // Nếu xóa thành công (có số dòng bị ảnh hưởng > 0)
                if (check > 0)
                {
                    MessageBox.Show("Xóa món ăn thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    conn.Close();
                    LoadData();
                    ClearTextBoxes();
                }
            }
        }
    }
}
