ActiveAdmin.register PhanLoaiTapThe do
  # Cho phép cập nhật đầy đủ các thuộc tính của model PhanLoaiTapThe
  permit_params :ma_lop, :danh_hieu_de_nghi, :phan_loai_tap_the, :ma_nam_hoc

  # Hiển thị các cột quan trọng trong trang danh sách
  index do
    selectable_column
    id_column
    column :lop do |record|
      record.lop&.ten
    end
    column :danh_hieu_de_nghi
    column :phan_loai_tap_the
    column :ma_nam_hoc
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_lop
  filter :ma_nam_hoc

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Phân loại tập thể" do
      f.input :ma_lop,
              as: :select,
              collection: Lop.order(:ma_lop).pluck(:ten, :ma_lop),
              include_blank: false,
              label: "Lớp"
      f.input :danh_hieu_de_nghi
      f.input :phan_loai_tap_the
      f.input :ma_nam_hoc
    end
    f.actions
  end

  # Trang chi tiết
  show do
    attributes_table do
      row :id
      row :lop do |record|
        record.lop&.ten
      end
      row :danh_hieu_de_nghi
      row :phan_loai_tap_the
      row :ma_nam_hoc
      row :created_at
      row :updated_at
    end
  end
end
