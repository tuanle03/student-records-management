ActiveAdmin.register Lop do
  permit_params :ma_lop, :ten, :ma_khoa, :khoa_hoc, :ma_nganh, :ma_he_dt,
                :ma_cb, :ghi_chu, :giao_vien_id

  remove_filter :students

  filter :ma_lop, label: "Mã lớp"
  filter :ten, label: "Tên lớp"
  filter :khoa_hoc,
          as: :select,
          collection: KhoaHoc.order(:ma_khoa).map { |kh| [ kh.ten, kh.ma_khoa ] },
          label: "Khoá học"
  filter :nganh,
          as: :select,
          collection: Nganh.order(:ma_nganh).pluck(:ten_nganh, :ma_nganh),
          label: "Ngành"
  filter :he_dao_tao,
          as: :select,
          collection: HeDaoTao.order(:ma_he_dt).pluck(:ten, :ma_he_dt),
          label: "Hệ đào tạo"
  filter :ma_cb, label: "Chủ nhiệm Trung đội"
  filter :giao_vien,
          as: :select,
          collection: User.teachers.order(:email).map { |u| [ u.email, u.id ] },
          label: "Giáo viên chủ nhiệm"

  index title: "Thông tin lớp" do
    selectable_column
    id_column
    column "Mã lớp", :ma_lop
    column "Tên lớp", :ten
    column "Khoá học" do |lop|
      lop.khoa_hoc.ten if lop.khoa_hoc
    end
    column "Ngành" do |lop|
      lop.nganh.ten_nganh if lop.nganh
    end
    column "Hệ đào tạo" do |lop|
      lop.he_dao_tao.ten if lop.he_dao_tao
    end
    column "Chủ nhiệm Trung đội", :ma_cb
    column "Giáo viên chủ nhiệm" do |lop|
      lop.giao_vien.email if lop.giao_vien
    end
    column "Ghi chú", :ghi_chu
    actions
  end

  show title: "Chi tiết lớp" do
    attributes_table do
      row("Mã lớp") { |lop| lop.ma_lop }
      row("Tên lớp") { |lop| lop.ten }
      row("Khoá học") { |lop| lop.khoa_hoc.ten if lop.khoa_hoc }
      row("Ngành") { |lop| lop.nganh.ten_nganh if lop.nganh }
      row("Hệ đào tạo") { |lop| lop.he_dao_tao.ten if lop.he_dao_tao }
      row("Chủ nhiệm Trung đội") { |lop| lop.ma_cb }
      row("Giáo viên chủ nhiệm") { |lop| lop.giao_vien.email if lop.giao_vien }
      row("Ghi chú") { |lop| lop.ghi_chu }
    end
  end

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
              include_blank: "Chọn giáo viên chủ nhiệm",
              label: "Giáo viên chủ nhiệm"

      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end
end
