ActiveAdmin.register Lop do
  permit_params :ma_lop, :ten, :ma_khoa, :khoa_hoc, :ma_nganh, :ma_he_dt, :ma_cb, :ghi_chu, :giao_vien_id

  form do |f|
    f.inputs "Thông tin lớp" do
      f.input :ma_lop
      f.input :ten
      f.input :ma_khoa
      f.input :khoa_hoc
      f.input :ma_nganh
      f.input :ma_he_dt
      f.input :ma_cb
      f.input :giao_vien,
              as: :select,
              collection: User.teacher.order(:email),
              label_method: :email,
              value_method: :id,
              include_blank: "Chọn giáo viên chủ nhiệm"
      f.input :ghi_chu
    end
    f.actions
  end
end
