ActiveAdmin.register KhoaHoc do
  # Cho phép cập nhật đầy đủ các thuộc tính của model KhoaHoc
  permit_params :ma_khoa, :ten, :ghi_chu

  # Hiển thị các cột quan trọng trong trang danh sách
  index do
    selectable_column
    id_column :ma_khoa
    column :ten
    column :ghi_chu
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_khoa
  filter :ten

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Khoá học" do
      f.input :ma_khoa
      f.input :ten
      f.input :ghi_chu
    end
    f.actions
  end

  # Trang chi tiết
  show do
    attributes_table do
      row :ma_khoa
      row :ten
      row :ghi_chu
      row :created_at
      row :updated_at
    end
  end
end
