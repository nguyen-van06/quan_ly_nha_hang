# 👥 Hướng Dẫn Làm Việc Nhóm - Git & GitHub

## 📌 Quy Tắc Chung

### Những Điều CẦN LÀM:
✅ **Luôn** tạo branch mới để làm feature  
✅ **Luôn** commit với message rõ ràng  
✅ **Luôn** pull code từ develop trước khi push  
✅ **Luôn** tạo Pull Request để review code  
✅ **Luôn** xóa branch sau khi merge  

### Những Điều KHÔNG LÀM:
❌ Không commit trực tiếp lên `main` hoặc `develop`  
❌ Không push code chưa test  
❌ Không merge code của người khác trực tiếp  
❌ Không bỏ qua review code  

---

## 🌳 Branching Strategy

### Cấu Trúc Branch

```
main                 ← Production (ổn định)
  └─ v1.0, v1.1     ← Release tags

develop              ← Development (tích hợp)
  ├─ feature/auth    ← Feature 1
  ├─ feature/db      ← Feature 2
  └─ bugfix/login    ← Bug fix
```

### Tên Branch
```
feature/ten-feature           (tính năng mới)
bugfix/ten-loi                (sửa lỗi)
hotfix/ten-hotfix             (sửa cấp tốc)
refactor/ten-cai-tien         (tái cấu trúc)
docs/cap-nhat-tai-lieu        (tài liệu)
```

**Ví dụ:**
```
feature/quan-ly-nhan-vien
bugfix/loi-dang-nhap
hotfix/database-connection
```

---

## 🚀 Quy Trình Làm Việc

### BƯỚC 1: Cài Đặt Lần Đầu

```bash
# Clone repo
git clone https://github.com/yourusername/BTL_QuanLyNhaHang.git
cd BTL_QuanLyNhaHang

# Cấu hình user (lần đầu)
git config user.name "Tên Của Bạn"
git config user.email "email@example.com"

# Kiểm tra branches
git branch -a
```

### BƯỚC 2: Tạo Feature Branch

```bash
# Cập nhật code mới nhất từ develop
git checkout develop
git pull origin develop

# Tạo branch mới
git checkout -b feature/ten-feature

# Hoặc: git checkout -b feature/quan-ly-khach-hang
```

### BƯỚC 3: Làm Việc & Commit

```bash
# Xem những file đã thay đổi
git status

# Add file để commit
git add .
# Hoặc add cụ thể: git add DatabaseHelper.cs

# Commit với message rõ ràng
git commit -m "Thêm chức năng tìm kiếm khách hàng"
git commit -m "Sửa lỗi kết nối database"
git commit -m "Cập nhật giao diện MainForm"

# Push lên GitHub
git push origin feature/ten-feature
```

### BƯỚC 4: Pull Request & Review

```
1. Vào GitHub
2. Nhấn "Compare & Pull Request"
3. Điền mô tả chi tiết
4. Assign reviewer (người khác trong nhóm)
5. Chờ review & approve
6. Merge vào develop
7. Xóa branch
```

### BƯỚC 5: Merge & Hoàn Thành

```bash
# Sau khi merge trên GitHub, cập nhật local
git checkout develop
git pull origin develop

# Xóa branch cũ
git branch -d feature/ten-feature
git push origin --delete feature/ten-feature
```

---

## 💬 Commit Message Format

### Template
```
[TYPE] Mô tả ngắn gọn (50 ký tự)

Mô tả chi tiết (nếu cần):
- Chi tiết 1
- Chi tiết 2
- Chi tiết 3

Fixes #123 (nếu liên quan đến issue)
```

### TYPE
```
feat:     Tính năng mới
fix:      Sửa lỗi
docs:     Tài liệu
refactor: Tái cấu trúc code
test:     Thêm test
style:    Định dạng code
```

### Ví Dụ
```
feat: Thêm chức năng tìm kiếm khách hàng

- Thêm SearchBox vào MainForm
- Implement tìm kiếm theo SĐT
- Cập nhật database query

Fixes #45

---

fix: Sửa lỗi kết nối database khi timeout

Thêm Connection Timeout = 30 vào connection string

---

docs: Cập nhật README.md với hướng dẫn cài đặt

---

refactor: Tách DatabaseHelper thành các method nhỏ hơn
```

---

## 🔄 Cập Nhật Code Từ Develop

```bash
# Nếu develop đã có update từ người khác
git checkout feature/ten-feature
git fetch origin
git rebase origin/develop

# Hoặc (nếu có conflict)
git merge origin/develop
# (Giải quyết conflict, sau đó)
git add .
git commit -m "Merge develop vào feature branch"
git push origin feature/ten-feature
```

---

## ⚠️ Giải Quyết Conflict

### Khi Conflict Xảy Ra

```bash
# Xem file nào bị conflict
git status

# Mở file bị conflict & xóa marker conflict
# <<<<<<< HEAD
# your code
# =======
# their code
# >>>>>>> branch-name

# Giữ code bạn muốn, xóa dòng marker

# Sau khi sửa:
git add .
git commit -m "Resolve conflict"
git push origin feature/ten-feature
```

### Tránh Conflict
✅ Pull code mới trước khi làm việc  
✅ Chia nhỏ công việc (không sửa cùng file)  
✅ Commit thường xuyên  
✅ Communicate với nhóm  

---

## 📋 Phân Công Công Việc

### Cách Quản Lý Task

```
GitHub > Issues > Create Issue
```

**Format Issue:**
```
Title: [MODULE] Tên task

Description:
## Mô tả
Chi tiết công việc

## Acceptance Criteria
- [ ] Hoàn thành X
- [ ] Hoàn thành Y
- [ ] Test thành công

## Assign to
@member-name

## Label
enhancement, bug, documentation
```

### Ví Dụ
```
Title: [NhanVien] Thêm chức năng xóa nhân viên

## Mô tả
Cần thêm nút "Xóa" vào Tab Quản Lý Nhân Viên
với xác nhận trước khi xóa

## Acceptance Criteria
- [ ] Button Xóa có trên UI
- [ ] Xóa nhân viên từ CSDL
- [ ] Có xác nhận trước khi xóa
- [ ] Danh sách update lại

## Assign to
@nhan-vien-2

## Label
enhancement, UI
```

---

## 🧪 Trước Khi Push

### Checklist

- [ ] Code biên dịch thành công (Build Success)
- [ ] Không có lỗi (Error = 0)
- [ ] Không có warning (hoặc warning không quan trọng)
- [ ] Đã test tính năng mới
- [ ] Không thay đổi code của người khác
- [ ] Commit message rõ ràng
- [ ] Pull code mới từ develop trước push

### Lệnh Kiểm Tra

```bash
# Build project
Ctrl + Shift + B (Visual Studio)

# Xem changes
git diff

# Xem commits chưa push
git log origin/develop..HEAD

# Trước khi push, pull lại develop
git fetch origin
git rebase origin/develop
```

---

## 👥 Quy Tắc Review Code

### Khi Bạn Gửi PR

```
✅ Mô tả rõ ràng những gì thay đổi
✅ Link đến issue (nếu có)
✅ Chụp screenshot (nếu là UI)
✅ Liệt kê những file thay đổi
✅ Đề cập đến bất kỳ breaking changes
```

### Khi Review Code Của Người Khác

```
✅ Kiểm tra logic
✅ Kiểm tra naming & style
✅ Kiểm tra có lỗi SQL injection không
✅ Kiểm tra exception handling
✅ Đề xuất cải thiện (nếu có)
✅ Approve sau khi yên tâm
```

### Comment Type

```
// Approve
"Looks good! ✅"
"LGTM (Looks Good To Me)"

// Request Changes
"Có vấn đề ở logic này. Hãy thay đổi..."
"Biến này naming không rõ, đổi sang..."

// Just Comment
"Bạn có thể optimize chỗ này bằng..."
"Xem xét thêm error handling cho..."
```

---

## 🐛 Quy Trình Fix Bug

### Khi Gặp Bug

```bash
# 1. Tạo Issue mô tả bug

# 2. Tạo branch fix
git checkout develop
git pull origin develop
git checkout -b bugfix/mo-ta-loi

# 3. Fix lỗi & test
# ... code here ...

# 4. Commit & push
git add .
git commit -m "fix: Mô tả lỗi"
git push origin bugfix/mo-ta-loi

# 5. Tạo PR (link vào issue)

# 6. Merge sau review
```

---

## 🔴 Emergency Hotfix

```bash
# Nếu production bị lỗi
git checkout main
git pull origin main
git checkout -b hotfix/mo-ta-hotfix

# Fix nhanh chóng

git add .
git commit -m "hotfix: Sửa cấp tốc lỗi X"
git push origin hotfix/mo-ta-hotfix

# Tạo PR vào MAIN (không phải develop!)
# Sau khi merge main, merge lại vào develop

git checkout develop
git pull origin develop
git merge main
git push origin develop
```

---

## 📊 Lệnh Git Hữu Ích

### Xem Lịch Sử

```bash
# Xem commit log
git log

# Xem commit theo author
git log --author="Tên"

# Xem commit ngắn gọn
git log --oneline

# Xem commit với graph
git log --graph --oneline --all
```

### Hủy Thay Đổi

```bash
# Hủy thay đổi file chưa commit
git checkout -- filename

# Hủy thay đổi tất cả
git checkout -- .

# Hủy commit gần nhất (chưa push)
git reset --soft HEAD~1

# Hủy commit & thay đổi
git reset --hard HEAD~1
```

### Stash (Tạm Lưu)

```bash
# Tạm lưu thay đổi
git stash

# Xem danh sách stash
git stash list

# Lấy stash lại
git stash pop

# Xóa stash
git stash drop
```

---

## 🚨 SOS - Khi Có Vấn Đề

### Lỡ Commit Vào Main

```bash
# Hủy commit gần nhất
git reset --soft HEAD~1

# Tạo branch mới
git checkout -b feature/ten

# Commit lại & push
git commit -m "..."
git push origin feature/ten
```

### Push Nhầm File Lớn

```bash
# Hủy commit
git reset --soft HEAD~1

# Xóa file khỏi staging
git reset HEAD file-lớn.bin

# Commit lại (không có file)
git commit -m "..."
git push origin feature/ten
```

### Merge Nhầm Branch

```bash
# Hủy merge (trước khi push)
git merge --abort

# Hoặc (sau khi push)
git revert -m 1 commit-hash
```

---

## 📞 Communication

### Discord / Slack
```
#general        - Thông báo chung
#dev            - Thảo luận code
#pr-review      - Thông báo PR
#bug-report     - Báo cáo bug
#questions      - Hỏi đáp
```

### Standup Hàng Ngày
```
Morning (9:00 AM):
- Hôm qua làm gì?
- Hôm nay sẽ làm gì?
- Có blocker gì không?

Status Check (3:00 PM):
- Update tiến độ
- Có issue gì không?
```

---

## ✅ Checklist Hoàn Thành Task

```
[ ] Code hoàn thành
[ ] Test thành công
[ ] Commit & push
[ ] Tạo Pull Request
[ ] Assign reviewer
[ ] Review & approve
[ ] Merge vào develop
[ ] Xóa branch
[ ] Đóng issue
[ ] Update Trello/Jira
```

---

## 🎓 Tài Liệu Tham Khảo

- [Git Tutorial](https://git-scm.com/book/en/v2)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Semantic Commits](https://www.conventionalcommits.org/)
- [GitHub Docs](https://docs.github.com/)

---

## 💡 Tips & Tricks

### Alias Hữu Ích

```bash
# Thêm vào .gitconfig
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --graph --oneline --all'

# Sử dụng
git st        # = git status
git co main   # = git checkout main
git br -a     # = git branch -a
git ci -m ""  # = git commit -m ""
```

### Visual Git Client (Optional)

- **GitHub Desktop** - Đơn giản, miễn phí
- **SourceTree** - Mạnh mẽ, miễn phí
- **Gitkraken** - Đẹp, có phiên bản trả phí

---

**Chúc bạn và nhóm làm việc hiệu quả! 🚀**

Có câu hỏi? Tạo issue hoặc hỏi trên Discord!
