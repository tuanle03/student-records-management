ActiveAdmin.register Nganh do
  menu label: "Ngành học", priority: 4

  permit_params :ma_nganh, :ten_nganh, :ghi_chu

  filter :ma_nganh, label: "Mã ngành", as: :select, collection: proc { Nganh.pluck(:ma_nganh) }
  filter :ten_nganh, label: "Tên ngành", as: :select, collection: proc { Nganh.pluck(:ten_nganh) }

  index title: "Danh sách ngành học" do
    selectable_column
    column "Mã ngành", :ma_nganh
    column "Tên ngành", :ten_nganh
    column "Ghi chú", :ghi_chu
    actions
  end

  form do |f|
    f.inputs "Thông tin ngành" do
      f.input :ma_nganh, label: "Mã ngành"
      f.input :ten_nganh, label: "Tên ngành"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  show do
    attributes_table do
      row("Mã ngành") { |n| n.ma_nganh }
      row("Tên ngành") { |n| n.ten_nganh }
      row("Ghi chú") { |n| n.ghi_chu }
    end
  end
end
