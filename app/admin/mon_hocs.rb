ActiveAdmin.register MonHoc do
  # Cho phép cập nhật đầy đủ các thuộc tính của model MonHoc
  permit_params :ma_mon_hoc, :ten, :so_tin_chi, :ghi_chu

  # Hiển thị các cột quan trọng trong trang danh sách
  index do
    selectable_column
    id_column :ma_mon_hoc
    column :ten
    column :so_tin_chi
    column :ghi_chu
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_mon_hoc
  filter :ten

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Môn học" do
      f.input :ma_mon_hoc
      f.input :ten
      f.input :so_tin_chi
      f.input :ghi_chu
    end
    f.actions
  end

  # Trang chi tiết
  show do
    attributes_table do
      row :ma_mon_hoc
      row :ten
      row :so_tin_chi
      row :ghi_chu
      row :created_at
      row :updated_at
    end
  end
end
