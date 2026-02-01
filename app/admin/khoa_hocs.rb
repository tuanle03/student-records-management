ActiveAdmin.register KhoaHoc do
  menu label: "Khoá học", priority: 3

  permit_params :ma_khoa, :ten, :ghi_chu

  filter :ma_khoa, label: "Mã khoá", as: :select, collection: proc { KhoaHoc.pluck(:ma_khoa) }
  filter :ten, label: "Tên khoá", as: :select, collection: proc { KhoaHoc.pluck(:ten) }

  index title: "Danh sách khoá học" do
    selectable_column
    column "Mã khoá", :ma_khoa
    column "Tên khoá", :ten
    column "Ghi chú", :ghi_chu
    actions
  end

  form do |f|
    f.inputs "Khoá học" do
      f.input :ma_khoa, label: "Mã khoá"
      f.input :ten, label: "Tên khoá"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  show title: "Chi tiết khoá học" do
    attributes_table do
      row("Mã khoá") { |kh| kh.ma_khoa }
      row("Tên khoá") { |kh| kh.ten }
      row("Ghi chú") { |kh| kh.ghi_chu }
      row("Ngày tạo") { |kh| kh.created_at }
      row("Cập nhật lần cuối") { |kh| kh.updated_at }
    end
  end
end
