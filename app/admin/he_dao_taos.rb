ActiveAdmin.register HeDaoTao do
  menu label: "Hệ đào tạo", priority: 8

  permit_params :ma_he_dt, :ten, :thoi_gian_hoc, :don_vi_tg, :ghi_chu

  filter :ma_he_dt, label: "Mã hệ đào tạo", as: :select, collection: proc { HeDaoTao.pluck(:ma_he_dt) }
  filter :ten, label: "Tên hệ đào tạo", as: :select, collection: proc { HeDaoTao.pluck(:ten) }

  index title: "Danh sách hệ đào tạo" do
    selectable_column
    column "Mã hệ đào tạo", :ma_he_dt
    column "Tên hệ đào tạo", :ten
    column "Thời gian học", :thoi_gian_hoc
    column "Đơn vị thời gian", :don_vi_tg
    column "Ghi chú", :ghi_chu
    actions
  end

  form do |f|
    f.inputs "Thông tin hệ đào tạo" do
      f.input :ma_he_dt, label: "Mã hệ đào tạo"
      f.input :ten, label: "Tên hệ đào tạo"
      f.input :thoi_gian_hoc, label: "Thời gian học"
      f.input :don_vi_tg, label: "Đơn vị thời gian"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  show title: "Chi tiết hệ đào tạo" do
    attributes_table do
      row("Mã hệ đào tạo") { |hdt| hdt.ma_he_dt }
      row("Tên hệ đào tạo") { |hdt| hdt.ten }
      row("Thời gian học") { |hdt| hdt.thoi_gian_hoc }
      row("Đơn vị thời gian") { |hdt| hdt.don_vi_tg }
      row("Ghi chú") { |hdt| hdt.ghi_chu }
      row("Ngày tạo") { |hdt| hdt.created_at }
      row("Cập nhật lần cuối") { |hdt| hdt.updated_at }
    end
  end
end
