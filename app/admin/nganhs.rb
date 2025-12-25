ActiveAdmin.register Nganh do
  # Cho phép cập nhật đầy đủ các thuộc tính của model Nganh
  permit_params :ma_nganh, :ten_nganh, :ghi_chu

  # Hiển thị các cột quan trọng trong trang danh sách
  index do
    selectable_column
    id_column :ma_nganh
    column :ten_nganh
    column :ghi_chu
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_nganh
  filter :ten_nganh

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Thông tin ngành" do
      f.input :ma_nganh
      f.input :ten_nganh
      f.input :ghi_chu
    end
    f.actions
  end

  # Trang chi tiết
  show do
    attributes_table do
      row :ma_nganh
      row :ten_nganh
      row :ghi_chu
      row :created_at
      row :updated_at
    end
  end
end
