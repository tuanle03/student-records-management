ActiveAdmin.register DiemHocTap do
  permit_params :ma_sv, :ma_mon_hoc, :ma_hoc_ky, :ghi_chu, :diem_gp, :diem_hp, :diem_tb, :diem_thi_lai_lan1, :diem_thi_lai_lan2

  index do
    selectable_column
    id_column
    column :hssv do |record|
      record.hssv&.ma_sv
    end
    column :mon_hoc do |record|
      record.mon_hoc&.ten
    end
    column :ma_hoc_ky
    column :diem_gp
    column :diem_hp
    column :diem_tb
    column :diem_thi_lai_lan1
    column :diem_thi_lai_lan2
    column :ghi_chu
    actions
  end

  filter :ma_sv
  filter :ma_mon_hoc
  filter :ma_hoc_ky

  form do |f|
    f.inputs "Điểm học tập" do
      f.input :ma_sv,
              as: :select,
              collection: Hssv.order(:ma_sv).pluck(:ma_sv),
              include_blank: false,
              label: "Mã sinh viên"
      f.input :ma_mon_hoc,
              as: :select,
              collection: MonHoc.order(:ma_mon_hoc).pluck(:ten, :ma_mon_hoc),
              include_blank: false,
              label: "Môn học"
      f.input :ma_hoc_ky
      f.input :diem_gp
      f.input :diem_hp
      f.input :diem_tb
      f.input :diem_thi_lai_lan1
      f.input :diem_thi_lai_lan2
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
      row :mon_hoc do |record|
        record.mon_hoc&.ten
      end
      row :ma_hoc_ky
      row :diem_gp
      row :diem_hp
      row :diem_tb
      row :diem_thi_lai_lan1
      row :diem_thi_lai_lan2
      row :ghi_chu
      row :created_at
      row :updated_at
    end
  end
end
