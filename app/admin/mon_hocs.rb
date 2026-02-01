ActiveAdmin.register MonHoc do
  menu label: "Môn học", priority: 5

  permit_params :ma_mon_hoc, :ten, :so_tin_chi, :ghi_chu

  filter :ma_mon_hoc, label: "Mã môn học", as: :select, collection: proc { MonHoc.pluck(:ma_mon_hoc) }
  filter :ten, label: "Tên môn học", as: :select, collection: proc { MonHoc.pluck(:ten) }

  index title: "Danh sách môn học" do
    selectable_column
    column "Mã môn học", :ma_mon_hoc
    column "Tên môn học", :ten
    column "Số tín chỉ", :so_tin_chi
    column "Ghi chú", :ghi_chu
    actions
  end

  form do |f|
    f.inputs "Môn học" do
      f.input :ma_mon_hoc, label: "Mã môn học"
      f.input :ten, label: "Tên môn học"
      f.input :so_tin_chi, label: "Số tín chỉ"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  show do
    attributes_table do
      row("Mã môn học") { |mh| mh.ma_mon_hoc }
      row("Tên môn học") { |mh| mh.ten }
      row("Số tín chỉ") { |mh| mh.so_tin_chi }
      row("Ghi chú") { |mh| mh.ghi_chu }
    end
  end
end
