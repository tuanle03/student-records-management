ActiveAdmin.register Lop do
  permit_params :ma_lop, :ten, :ma_khoa, :khoa_hoc, :ma_nganh, :ma_he_dt,
                :ma_cb, :ghi_chu, :giao_vien_id

  form do |f|
    f.inputs "Thông tin lớp" do
      f.input :ma_lop
      f.input :ten

      f.input :ma_khoa,
              as: :select,
              collection: KhoaHoc.order(:ma_khoa).map { |kh| [ kh.ten, kh.ma_khoa ] },
              label: "Khoá học",
              include_blank: "Chọn khoá"

      f.input :ma_nganh,
              as: :select,
              collection: Nganh.order(:ma_nganh).pluck(:ten_nganh, :ma_nganh)

      f.input :ma_he_dt,
              as: :select,
              collection: HeDaoTao.order(:ma_he_dt).pluck(:ten, :ma_he_dt)

      f.input :ma_cb
      f.input :giao_vien,
              as: :select,
              collection: User.teachers.order(:email).map { |u| [ u.email, u.id ] },
              include_blank: "Chọn giáo viên chủ nhiệm"

      f.input :ghi_chu
    end
    f.actions
  end
end
