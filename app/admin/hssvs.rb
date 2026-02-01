ActiveAdmin.register Hssv do
  menu label: "Học viên", priority: 1

  controller do
    def find_resource
      scoped_collection.find_by!(ma_sv: params[:id])
    end
  end

  permit_params :ma_sv, :ho_dem, :ten, :ngay_sinh, :gioi_tinh,
                :ma_lop, :ma_khoa, :ma_hdt, :ma_nganh,
                :dien_thoai, :que_quan, :tru_quan, :ghi_chu

  filter :lop, as: :select, collection: proc { Lop.order(:ten).map { |l| [ l.ten, l.ma_lop ] } }, label: "Lớp"
  filter :khoa_hoc, as: :select, collection: proc { KhoaHoc.order(:ten).map { |k| [ k.ten, k.ma_khoa ] } }, label: "Khoá học"
  filter :he_dao_tao, as: :select, collection: proc { HeDaoTao.order(:ten).map { |h| [ h.ten, h.ma_he_dt ] } }, label: "Hệ đào tạo"
  filter :nganh, as: :select, collection: proc { Nganh.order(:ten_nganh).pluck(:ten_nganh, :ma_nganh) }, label: "Ngành"
  filter :ma_sv, label: "Mã học viên", as: :select, collection: proc { Hssv.order(:ma_sv).pluck(:ma_sv) }

  index title: "Danh sách học viên" do
    selectable_column
    column "Mã học viên", :ma_sv
    column "Họ & tên đệm", :ho_dem
    column "Tên", :ten
    column "Lớp" do |s|
      s.lop&.ten
    end
    column "Khoá học" do |s|
      s.khoa_hoc&.ten
    end
    column "Hệ đào tạo" do |s|
      s.he_dao_tao&.ten
    end
    column "Ngành" do |s|
      s.nganh&.ten_nganh
    end
    column "Điện thoại", :dien_thoai
    actions
  end

  show title: proc { |s| "Chi tiết học viên: #{s.ho_dem} #{s.ten}" } do
    attributes_table do
      row("Mã học viên") { |s| s.ma_sv }
      row("Họ & tên đệm") { |s| s.ho_dem }
      row("Tên") { |s| s.ten }
      row("Ngày sinh") { |s| s.ngay_sinh }
      row("Giới tính") { |s| s.gioi_tinh_label }
      row("Lớp") { |s| s.lop&.ten }
      row("Khoá học") { |s| s.khoa_hoc&.ten }
      row("Hệ đào tạo") { |s| s.he_dao_tao&.ten }
      row("Ngành") { |s| s.nganh&.ten_nganh }
      row("Điện thoại") { |s| s.dien_thoai }
      row("Tôn giáo") { |s| s.ton_giao }
      row("Dân tộc") { |s| s.dan_toc }
      row("Khu vực") { |s| s.khu_vuc }
      row("Đối tượng") { |s| s.doi_tuong }
      row("Ngày vào Đoàn") { |s| s.ngay_doan }
      row("Ngày vào Đảng") { |s| s.ngay_dang }
      row("Số CMND") { |s| s.so_cmnd }
      row("Ngày cấp CMND") { |s| s.ngay_cmnd }
      row("Nơi cấp CMND") { |s| s.noi_cmnd }
      row("Quê quán") { |s| s.que_quan }
      row("Hộ khẩu thường trú") { |s| s.tru_quan }
      row("Khen thưởng kỷ luật") { |s| s.ktk_l }
      row("Tóm tắt quá trình công tác") { |s| s.tom_tat_qtct }
      row("Họ tên cha") { |s| s.ho_ten_cha }
      row("Năm sinh cha") { |s| s.nam_sinh_cha }
      row("Nghề nghiệp cha") { |s| s.nghe_nghiep_cha }
      row("Nơi làm việc cha") { |s| s.noi_lam_cha }
      row("Hộ khẩu cha") { |s| s.ho_khau_cha }
      row("Họ tên mẹ") { |s| s.ho_ten_me }
      row("Năm sinh mẹ") { |s| s.nam_sinh_me }
      row("Nghề nghiệp mẹ") { |s| s.nghe_nghiep_me }
      row("Nơi làm việc mẹ") { |s| s.noi_lam_me }
      row("Hộ khẩu mẹ") { |s| s.ho_khau_me }
      row("Họ tên vợ/chồng") { |s| s.ho_ten_vo }
      row("Năm sinh vợ/chồng") { |s| s.nam_sinh_vo }
      row("Nghề nghiệp vợ/chồng") { |s| s.nghe_nghiep_vo }
      row("Nơi làm việc vợ/chồng") { |s| s.noi_lam_vo }
      row("Hộ khẩu vợ/chồng") { |s| s.ho_khau_vo }
      row("Ghi chú") { |s| s.ghi_chu }
    end
  end

  form do |f|
    f.inputs "Thông tin cơ bản" do
      f.input :ma_sv, label: "Mã học viên"
      f.input :ho_dem, label: "Họ & tên đệm"
      f.input :ten, label: "Tên"
      f.input :ngay_sinh, as: :datepicker, datepicker_options: { dateFormat: "yy-mm-dd" }, label: "Ngày sinh"
      f.input :gioi_tinh, as: :select, collection: [ [ "Nam", true ], [ "Nữ", false ] ], label: "Giới tính"

      f.input :lop, as: :select, collection: Lop.all.collect { |l| [ l.ten, l.ma_lop ] }, label: "Lớp"
      f.input :khoa_hoc, as: :select, collection: KhoaHoc.all.collect { |k| [ k.ten, k.ma_khoa ] }, label: "Khoá học"
      f.input :he_dao_tao, as: :select, collection: HeDaoTao.all.collect { |h| [ h.ten, h.ma_he_dt ] }, label: "Hệ đào tạo"
      f.input :nganh, as: :select, collection: Nganh.all.collect { |n| [ n.ten_nganh, n.ma_nganh ] }, label: "Ngành"

      f.input :dien_thoai, label: "Điện thoại"
      f.input :que_quan, label: "Quê quán"
      f.input :tru_quan, label: "Hộ khẩu thường trú"
      f.input :ghi_chu, label: "Ghi chú"
    end
    f.actions
  end

  # action_item :import, only: :index do
  #   link_to "Import từ Excel", action: :import
  # end
  #
  # collection_action :import, method: :get do
  #   render "admin/hssv/import"
  # end

  # collection_action :do_import, method: :post do
  #   if params[:file].present?
  #     HssvImporter.new(params[:file].path).call
  #     redirect_to admin_hssvs_path, notice: "Import thành công"
  #   else
  #     redirect_to import_admin_hssvs_path, alert: "Chưa chọn file"
  #   end
  # end
end
