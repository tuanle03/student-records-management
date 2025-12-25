ActiveAdmin.register DiemRenLuyen do
  permit_params :ma_sv, :ma_hoc_ky, :ma_nam_hoc, :thang, :diem, :ghi_chu

  index do
    selectable_column
    id_column
    column :hssv do |record|
      record.hssv&.ma_sv
    end
    column :ma_hoc_ky
    column :ma_nam_hoc
    column :thang
    column :diem
    column :ghi_chu
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_sv
  filter :ma_hoc_ky
  filter :ma_nam_hoc

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Điểm rèn luyện" do
      f.input :ma_sv,
              as: :select,
              collection: Hssv.order(:ma_sv).pluck(:ma_sv),
              include_blank: false,
              label: "Mã sinh viên"
      f.input :ma_hoc_ky
      f.input :ma_nam_hoc
      f.input :thang
      f.input :diem
      f.input :ghi_chu
    end
    f.actions
  end

  # Trang chi tiết
  show do
    attributes_table do
      row :id
      row :hssv do |record|
        record.hssv&.ma_sv
      end
      row :ma_hoc_ky
      row :ma_nam_hoc
      row :thang
      row :diem
      row :ghi_chu
      row :created_at
      row :updated_at
    end
  end
end
