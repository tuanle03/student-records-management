ActiveAdmin.register KhoaHoc do
  # Cho phép cập nhật đầy đủ các thuộc tính của model KhoaHoc
  permit_params :ma_khoa, :ten, :ghi_chu

  # Hiển thị các cột quan trọng trong trang danh sách
  index title: "Danh sách khoá học" do
    selectable_column
    column "Mã khoá", :ma_khoa
    column "Tên khoá", :ten
    column "Ghi chú", :ghi_chu
    actions
  end

  # Bộ lọc tìm kiếm
  filter :ma_khoa, label: "Mã khoá", as: :select, collection: KhoaHoc.pluck(:ma_khoa)
  filter :ten, label: "Tên khoá", as: :select, collection: KhoaHoc.pluck(:ten)

  # Form tạo mới/ chỉnh sửa
  form do |f|
    f.inputs "Khoá học" do
      f.input :ma_khoa, label: "Mã khoá"
      f.input :ten, label: "Tên khoá"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  # Trang chi tiết
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
