# db/seeds.rb

# Chỉ seed dữ liệu trong môi trường development
unless Rails.env.development?
  puts "⚠️ Bỏ qua seed vì không phải môi trường development (#{Rails.env})"
  return
end

# Làm sạch dữ liệu cũ (nếu cần)
puts "🧹 Cleaning up old data..."
DiemRenLuyen.delete_all
DiemHocTap.delete_all
Hssv.delete_all
MonHoc.delete_all
Lop.delete_all
HeDaoTao.delete_all
Nganh.delete_all
KhoaHoc.delete_all
User.where(role: [ User::ROLE_TEACHER, User::ROLE_STAFF ]).delete_all
AdminUser.delete_all
puts "✅ Old data cleaned."

puts "🌱 Seeding development data..."

# ---------------------------
# 1. Tài khoản đăng nhập
# ---------------------------

AdminUser.find_or_create_by!(email: "admin@example.com") do |u|
  u.password              = "password"
  u.password_confirmation = "password"
end
puts "✅ AdminUser: admin@example.com / password"

# Tài khoản giáo viên và nhân viên
giao_vien_1 = User.find_or_create_by!(email: "teacher1@qlhv.local") do |u|
  u.password              = "password123"
  u.password_confirmation = "password123"
  u.role = User::ROLE_TEACHER
end
giao_vien_2 = User.find_or_create_by!(email: "teacher2@qlhv.local") do |u|
  u.password              = "password123"
  u.password_confirmation = "password123"
  u.role = User::ROLE_TEACHER
end
nhan_vien = User.find_or_create_by!(email: "staff@qlhv.local") do |u|
  u.password              = "password123"
  u.password_confirmation = "password123"
  u.role = User::ROLE_STAFF
end
puts "✅ Tạo tài khoản giáo viên & nhân viên"

# ---------------------------
# 2. Bảng tham chiếu: Khóa, Ngành, Hệ đào tạo
# ---------------------------

k44 = KhoaHoc.find_or_create_by!(ma_khoa: "K44") do |k|
  k.ten     = "Khóa 44 (2021–2025)"
  k.ghi_chu = "Cao đẳng chính quy"
end

k45 = KhoaHoc.find_or_create_by!(ma_khoa: "K45") do |k|
  k.ten     = "Khóa 45 (2022–2026)"
  k.ghi_chu = "Cao đẳng chính quy"
end

cntt = Nganh.find_or_create_by!(ma_nganh: "CNTT") do |n|
  n.ten_nganh = "Công nghệ thông tin"
  n.ghi_chu   = "Ngành CNTT"
end

qtkd = Nganh.find_or_create_by!(ma_nganh: "QTKD") do |n|
  n.ten_nganh = "Quản trị kinh doanh"
  n.ghi_chu   = "Ngành QTKD"
end

cd_chinh_quy = HeDaoTao.find_or_create_by!(ma_he_dt: "CĐCQ") do |h|
  h.ten           = "Cao đẳng chính quy"
  h.thoi_gian_hoc = 3
  h.don_vi_tg     = "năm"
  h.ghi_chu       = "Đào tạo toàn thời gian"
end

vhlt = HeDaoTao.find_or_create_by!(ma_he_dt: "VHLT") do |h|
  h.ten           = "Vừa học vừa làm"
  h.thoi_gian_hoc = 4
  h.don_vi_tg     = "năm"
  h.ghi_chu       = "Hệ vừa học vừa làm"
end

puts "✅ Đã seed KhoaHoc, Nganh, HeDaoTao"

# ---------------------------
# 3. Lớp - gán giáo viên chủ nhiệm
# ---------------------------

lop_ctk44a = Lop.find_or_create_by!(ma_lop: "CTK44A") do |lop|
  lop.ten       = "Công nghệ thông tin K44A"
  lop.ma_khoa   = k44.ma_khoa
  lop[:khoa_hoc]  = "2021–2025"
  lop.ma_nganh  = cntt.ma_nganh
  lop.ma_he_dt  = cd_chinh_quy.ma_he_dt
  lop.giao_vien = giao_vien_1
  lop.ma_cb     = "GV001"
  lop.ghi_chu   = "Lớp ban A"
end

lop_ctk44b = Lop.find_or_create_by!(ma_lop: "CTK44B") do |lop|
  lop.ten       = "Công nghệ thông tin K44B"
  lop.ma_khoa   = k44.ma_khoa
  lop[:khoa_hoc]  = "2021–2025"
  lop.ma_nganh  = cntt.ma_nganh
  lop.ma_he_dt  = cd_chinh_quy.ma_he_dt
  lop.giao_vien = giao_vien_2
  lop.ma_cb     = "GV002"
  lop.ghi_chu   = "Lớp ban B"
end

lop_qtk45a = Lop.find_or_create_by!(ma_lop: "QTK45A") do |lop|
  lop.ten       = "Quản trị kinh doanh K45A"
  lop.ma_khoa   = k45.ma_khoa
  lop[:khoa_hoc]  = "2022–2026"
  lop.ma_nganh  = qtkd.ma_nganh
  lop.ma_he_dt  = vhlt.ma_he_dt
  lop.giao_vien = giao_vien_1
  lop.ma_cb     = "GV010"
  lop.ghi_chu   = "Lớp QTKD hệ VHLT"
end

puts "✅ Đã seed Lops với giáo viên chủ nhiệm"

# ---------------------------
# 4. Môn học
# ---------------------------

ltcb = MonHoc.find_or_create_by!(ma_mon_hoc: "CT101") do |m|
  m.ten        = "Lập trình căn bản"
  m.so_tin_chi = 3
  m.ghi_chu    = "Học kỳ 1"
end

csdl = MonHoc.find_or_create_by!(ma_mon_hoc: "CT201") do |m|
  m.ten        = "Cơ sở dữ liệu"
  m.so_tin_chi = 3
  m.ghi_chu    = "Học kỳ 2"
end

thnh = MonHoc.find_or_create_by!(ma_mon_hoc: "CT301") do |m|
  m.ten        = "Thiết kế web"
  m.so_tin_chi = 3
  m.ghi_chu    = "Học kỳ 3"
end

puts "✅ Đã seed MonHocs"

# ---------------------------
# 5. Học sinh / sinh viên (Hssv)
# ---------------------------

sv1 = Hssv.find_or_create_by!(ma_sv: "SV001") do |sv|
  sv.ho_dem      = "Nguyễn Văn"
  sv.ten         = "A"
  sv.ngay_sinh   = Date.new(2004, 1, 1)
  sv.gioi_tinh   = true   # Nam
  sv.dien_thoai  = "0901 111 111"
  sv.que_quan    = "Đà Nẵng"
  sv.tru_quan    = "Quận Hải Châu, Đà Nẵng"
  sv.ma_lop      = lop_ctk44a.ma_lop
  sv.ma_khoa     = k44.ma_khoa
  sv.ma_hdt      = cd_chinh_quy.ma_he_dt
  sv.ma_nganh    = cntt.ma_nganh
  sv.ghi_chu     = "Lớp trưởng"
end

sv2 = Hssv.find_or_create_by!(ma_sv: "SV002") do |sv|
  sv.ho_dem      = "Trần Thị"
  sv.ten         = "B"
  sv.ngay_sinh   = Date.new(2004, 3, 15)
  sv.gioi_tinh   = false  # Nữ
  sv.dien_thoai  = "0902 222 222"
  sv.que_quan    = "Huế"
  sv.tru_quan    = "TP Huế"
  sv.ma_lop      = lop_ctk44a.ma_lop
  sv.ma_khoa     = k44.ma_khoa
  sv.ma_hdt      = cd_chinh_quy.ma_he_dt
  sv.ma_nganh    = cntt.ma_nganh
  sv.ghi_chu     = "Bí thư chi đoàn"
end

sv3 = Hssv.find_or_create_by!(ma_sv: "SV003") do |sv|
  sv.ho_dem      = "Lê Văn"
  sv.ten         = "C"
  sv.ngay_sinh   = Date.new(2003, 12, 20)
  sv.gioi_tinh   = true
  sv.dien_thoai  = "0903 333 333"
  sv.que_quan    = "Quảng Nam"
  sv.tru_quan    = "Hội An, Quảng Nam"
  sv.ma_lop      = lop_ctk44b.ma_lop
  sv.ma_khoa     = k44.ma_khoa
  sv.ma_hdt      = cd_chinh_quy.ma_he_dt
  sv.ma_nganh    = cntt.ma_nganh
  sv.ghi_chu     = ""
end

sv4 = Hssv.find_or_create_by!(ma_sv: "SV010") do |sv|
  sv.ho_dem      = "Phạm Thị"
  sv.ten         = "D"
  sv.ngay_sinh   = Date.new(2003, 5, 10)
  sv.gioi_tinh   = false
  sv.dien_thoai  = "0904 444 444"
  sv.que_quan    = "Quảng Trị"
  sv.tru_quan    = "Quảng Trị"
  sv.ma_lop      = lop_qtk45a.ma_lop
  sv.ma_khoa     = k45.ma_khoa
  sv.ma_hdt      = vhlt.ma_he_dt
  sv.ma_nganh    = qtkd.ma_nganh
  sv.ghi_chu     = "Sinh viên hệ VHLT"
end

puts "✅ Đã seed Hssvs (sinh viên)"

# ---------------------------
# 6. Điểm học tập (DiemHocTap)
# ---------------------------

def seed_diem(ma_sv, mon, hoc_ky:, diem_gp:, diem_hp:, thi_lai1: nil, thi_lai2: nil)
  DiemHocTap.find_or_create_by!(
    ma_sv:      ma_sv,
    ma_mon_hoc: mon.ma_mon_hoc,
    ma_hoc_ky:  hoc_ky
  ) do |d|
    d.diem_gp           = diem_gp
    d.diem_hp           = diem_hp
    d.diem_tb           = (diem_gp * 0.4 + diem_hp * 0.6).round(2)
    d.diem_thi_lai_lan1 = thi_lai1
    d.diem_thi_lai_lan2 = thi_lai2
    d.ghi_chu           = "Seed demo"
  end
end

seed_diem(sv1.ma_sv, ltcb, hoc_ky: "HK1_2024", diem_gp: 8.5, diem_hp: 8.0)
seed_diem(sv1.ma_sv, csdl, hoc_ky: "HK2_2024", diem_gp: 7.5, diem_hp: 7.0)

seed_diem(sv2.ma_sv, ltcb, hoc_ky: "HK1_2024", diem_gp: 7.0, diem_hp: 6.5)
seed_diem(sv2.ma_sv, csdl, hoc_ky: "HK2_2024", diem_gp: 6.0, diem_hp: 5.5)

seed_diem(sv3.ma_sv, ltcb, hoc_ky: "HK1_2024", diem_gp: 5.0, diem_hp: 4.5, thi_lai1: 6.0)
seed_diem(sv3.ma_sv, thnh, hoc_ky: "HK3_2024", diem_gp: 8.0, diem_hp: 8.5)

puts "✅ Đã seed DiemHocTaps"

# ---------------------------
# 7. Điểm rèn luyện
# ---------------------------

[
  [ sv1.ma_sv, "HK1_2024", "2024-2025", "10", 85 ],
  [ sv1.ma_sv, "HK2_2024", "2024-2025", "03", 90 ],
  [ sv2.ma_sv, "HK1_2024", "2024-2025", "10", 78 ],
  [ sv3.ma_sv, "HK1_2024", "2024-2025", "10", 65 ]
].each do |ma_sv, ma_hoc_ky, ma_nam_hoc, thang, diem|
  DiemRenLuyen.find_or_create_by!(
    ma_sv: ma_sv,
    ma_hoc_ky: ma_hoc_ky,
    ma_nam_hoc: ma_nam_hoc,
    thang: thang
  ) do |d|
    d.diem    = diem
    d.ghi_chu = "Seed demo điểm rèn luyện"
  end
end

puts "✅ Đã seed DiemRenLuyens"

# ---------------------------
# 8. Phân loại tập thể lớp
# ---------------------------

PhanLoaiTapThe.find_or_create_by!(
  ma_lop: lop_ctk44a.ma_lop,
  ma_nam_hoc: "2024-2025"
) do |p|
  p.danh_hieu_de_nghi = "Lớp tiên tiến xuất sắc"
  p.phan_loai_tap_the = "Xuất sắc"
end

PhanLoaiTapThe.find_or_create_by!(
  ma_lop: lop_ctk44b.ma_lop,
  ma_nam_hoc: "2024-2025"
) do |p|
  p.danh_hieu_de_nghi = "Lớp tiên tiến"
  p.phan_loai_tap_the = "Khá"
end

puts "✅ Đã seed PhanLoaiTapThes"

puts "🎉 Seeding xong!"
