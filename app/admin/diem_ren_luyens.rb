ActiveAdmin.register DiemRenLuyen do
  menu label: "Điểm rèn luyện", priority: 7

  permit_params :ma_sv, :ma_hoc_ky, :ma_nam_hoc, :thang, :diem, :ghi_chu

  filter :ma_sv, as: :select, collection: proc { Hssv.order(:ma_sv).pluck(:ma_sv) }, label: "Mã học viên"
  filter :ma_hoc_ky, label: "Mã học kỳ", as: :select, collection: proc { DiemRenLuyen.pluck(:ma_hoc_ky) }
  filter :ma_nam_hoc, label: "Mã năm học", as: :select, collection: proc { DiemRenLuyen.pluck(:ma_nam_hoc) }

  index title: "Điểm rèn luyện" do
    selectable_column
    id_column
    column "Mã học viên" do |record|
      record.hssv&.ma_sv
    end
    column "Mã học kỳ", :ma_hoc_ky
    column "Mã năm học", :ma_nam_hoc
    column "Tháng", :thang
    column "Điểm", :diem
    column "Ghi chú", :ghi_chu
    column "Ngày tạo", :created_at
    column "Cập nhật lần cuối", :updated_at
    actions
  end

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Điểm rèn luyện" do
      f.input :ma_sv,
              as: :select,
              collection: Hssv.order(:ma_sv).pluck(:ma_sv),
              include_blank: false,
              label: "Mã học viên"
      f.input :ma_hoc_ky, label: "Mã học kỳ"
      f.input :ma_nam_hoc, label: "Mã năm học"
      f.input :thang, label: "Tháng"
      f.input :diem, label: "Điểm"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  # Trang chi tiết
  show title: "Chi tiết điểm rèn luyện" do
    attributes_table do
      row("ID") { |record| record.id }
      row("Mã học viên") { |record| record.hssv&.ma_sv }
      row("Mã học kỳ") { |record| record.ma_hoc_ky }
      row("Mã năm học") { |record| record.ma_nam_hoc }
      row("Tháng") { |record| record.thang }
      row("Điểm") { |record| record.diem }
      row("Ghi chú") { |record| record.ghi_chu }
      row("Ngày tạo") { |record| record.created_at }
      row("Cập nhật lần cuối") { |record| record.updated_at }
    end
  end
end
