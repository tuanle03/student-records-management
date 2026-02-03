ActiveAdmin.register DiemHocTap do
  menu label: "Điểm học tập", priority: 6

  permit_params :ma_sv, :ma_mon_hoc, :ma_hoc_ky, :ghi_chu, :diem_gp, :diem_hp, :diem_tb, :diem_thi_lai_lan1, :diem_thi_lai_lan2

  filter :ma_sv, as: :select, collection: proc { Hssv.order(:ma_sv).pluck(:ma_sv) }, label: "Mã học viên"
  filter :ma_mon_hoc, as: :select, collection: proc { MonHoc.order(:ma_mon_hoc).pluck(:ten, :ma_mon_hoc) }, label: "Môn học"
  filter :ma_hoc_ky, label: "Mã học kỳ", as: :select, collection: proc { DiemHocTap.pluck(:ma_hoc_ky).uniq }

  index title: "Điểm học tập" do
    selectable_column
    id_column
    column "Mã học viên" do |record|
      record.hssv&.ma_sv
    end
    column "Môn học" do |record|
      record.mon_hoc&.ten
    end
    column "Mã học kỳ", :ma_hoc_ky
    column "Điểm BP", :diem_gp
    column "Điểm KTHP", :diem_hp
    column "Điểm ĐGHP", :diem_tb
    column "Điểm thi lại lần 1", :diem_thi_lai_lan1
    column "Điểm thi lại lần 2", :diem_thi_lai_lan2
    column "Ghi chú", :ghi_chu
    column "Ngày tạo", :created_at
    column "Cập nhật lần cuối", :updated_at
    actions
  end

  form do |f|
    f.inputs "Điểm học tập" do
      f.input :ma_sv,
              as: :select,
              collection: Hssv.order(:ma_sv).pluck(:ma_sv),
              include_blank: false,
              label: "Mã học viên"
      f.input :ma_mon_hoc,
              as: :select,
              collection: MonHoc.order(:ma_mon_hoc).pluck(:ten, :ma_mon_hoc),
              include_blank: false,
              label: "Môn học"
      f.input :ma_hoc_ky, label: "Mã học kỳ"
      f.input :diem_gp, label: "Điểm BP"
      f.input :diem_hp, label: "Điểm KTHP"
      f.input :diem_tb, label: "Điểm ĐGHP"
      f.input :diem_thi_lai_lan1, label: "Điểm thi lại lần 1"
      f.input :diem_thi_lai_lan2, label: "Điểm thi lại lần 2"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  # Trang chi tiết
  show title: "Chi tiết điểm học tập" do
    attributes_table do
      row("ID") { |record| record.id }
      row("Mã học viên") { |record| record.hssv&.ma_sv }
      row("Môn học") { |record| record.mon_hoc&.ten }
      row("Mã học kỳ") { |record| record.ma_hoc_ky }
      row("Điểm BP") { |record| record.diem_gp }
      row("Điểm KTHP") { |record| record.diem_hp }
      row("Điểm ĐGHP") { |record| record.diem_tb }
      row("Điểm thi lại lần 1") { |record| record.diem_thi_lai_lan1 }
      row("Điểm thi lại lần 2") { |record| record.diem_thi_lai_lan2 }
      row("Ghi chú") { |record| record.ghi_chu }
      row("Ngày tạo") { |record| record.created_at }
      row("Cập nhật lần cuối") { |record| record.updated_at }
    end
  end
end
