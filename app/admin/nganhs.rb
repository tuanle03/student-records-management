ActiveAdmin.register Nganh do
  # Cho phép cập nhật đầy đủ các thuộc tính của model Nganh
  permit_params :ma_nganh, :ten_nganh, :ghi_chu

  # Hiển thị các cột quan trọng trong trang danh sách
  index title: "Danh sách ngành học" do
    selectable_column
    column "Mã ngành", :ma_nganh
    column "Tên ngành", :ten_nganh
    column "Ghi chú", :ghi_chu
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_nganh, label: "Mã ngành"
  filter :ten_nganh, label: "Tên ngành"

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Thông tin ngành" do
      f.input :ma_nganh, label: "Mã ngành"
      f.input :ten_nganh, label: "Tên ngành"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  # Trang chi tiết
  show do
    attributes_table do
      row("Mã ngành") { |n| n.ma_nganh }
      row("Tên ngành") { |n| n.ten_nganh }
      row("Ghi chú") { |n| n.ghi_chu }
    end
  end
end
