ActiveAdmin.register PhanLoaiTapThe do
  menu label: "Phân loại tập thể", priority: 9

  permit_params :ma_lop, :danh_hieu_de_nghi, :phan_loai_tap_the, :ma_nam_hoc

  filter :ma_lop, as: :select, collection: proc { Lop.all.collect { |l| [ l.ten, l.ma_lop ] } }, label: "Lớp"
  filter :ma_nam_hoc, label: "Năm học", as: :select, collection: proc { PhanLoaiTapThe.pluck(:ma_nam_hoc).uniq }

  index title: "Phân loại tập thể" do
    selectable_column
    id_column
    column "Lớp" do |record|
      record.lop&.ten
    end
    column "Danh hiệu đề nghị", :danh_hieu_de_nghi
    column "Phân loại tập thể", :phan_loai_tap_the
    column "Năm học", :ma_nam_hoc
    actions
  end

  form do |f|
    f.inputs "Phân loại tập thể" do
      f.input :ma_lop,
              as: :select,
              collection: Lop.order(:ma_lop).pluck(:ten, :ma_lop),
              include_blank: false,
              label: "Lớp"
      f.input :danh_hieu_de_nghi, label: "Danh hiệu đề nghị"
      f.input :phan_loai_tap_the, label: "Phân loại tập thể"
      f.input :ma_nam_hoc, label: "Năm học"
    end
    f.actions
  end

  show title: "Chi tiết phân loại tập thể" do
    attributes_table do
      row("ID") { |record| record.id }
      row("Lớp") { |record| record.lop&.ten }
      row("Danh hiệu đề nghị") { |record| record.danh_hieu_de_nghi }
      row("Phân loại tập thể") { |record| record.phan_loai_tap_the }
      row("Năm học") { |record| record.ma_nam_hoc }
      row("Ngày tạo") { |record| record.created_at }
      row("Cập nhật lần cuối") { |record| record.updated_at }
    end
  end
end
