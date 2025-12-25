ActiveAdmin.register HeDaoTao do
  # Cho phép cập nhật đầy đủ các thuộc tính của model HeDaoTao
  permit_params :ma_he_dt, :ten, :thoi_gian_hoc, :don_vi_tg, :ghi_chu

  # Hiển thị các cột quan trọng trong trang danh sách
  index do
    selectable_column
    id_column :ma_he_dt
    column :ten
    column :thoi_gian_hoc
    column :don_vi_tg
    column :ghi_chu
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_he_dt
  filter :ten

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Thông tin hệ đào tạo" do
      f.input :ma_he_dt
      f.input :ten
      f.input :thoi_gian_hoc
      f.input :don_vi_tg
      f.input :ghi_chu
    end
    f.actions
  end

  # Trang chi tiết
  show do
    attributes_table do
      row :ma_he_dt
      row :ten
      row :thoi_gian_hoc
      row :don_vi_tg
      row :ghi_chu
      row :created_at
      row :updated_at
    end
  end
end
