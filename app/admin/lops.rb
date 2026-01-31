ActiveAdmin.register Lop do
  permit_params :ma_lop, :ten, :ma_khoa, :khoa_hoc, :ma_nganh, :ma_he_dt,
                :ma_cb, :ghi_chu, :giao_vien_id

  remove_filter :students

  form do |f|
    f.inputs "Thông tin lớp" do
      f.input :ma_lop,
              label: "Mã lớp"
      f.input :ten,
              label: "Tên lớp"

      f.input :ma_khoa,
              as: :select,
              collection: KhoaHoc.order(:ma_khoa).map { |kh| [ kh.ten, kh.ma_khoa ] },
              label: "Khoá học",
              include_blank: "Chọn khoá"

      f.input :ma_nganh,
              as: :select,
              collection: Nganh.order(:ma_nganh).pluck(:ten_nganh, :ma_nganh),
              label: "Ngành"

      f.input :ma_he_dt,
              as: :select,
              collection: HeDaoTao.order(:ma_he_dt).pluck(:ten, :ma_he_dt),
              label: "Hệ đào tạo"

      f.input :ma_cb, label: "Chủ nhiệm Trung đội"
      f.input :giao_vien,
              as: :select,
              collection: User.teachers.order(:email).map { |u| [ u.email, u.id ] },
              include_blank: "Chọn giáo viên chủ nhiệm"

      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end
end
