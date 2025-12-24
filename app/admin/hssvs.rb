ActiveAdmin.register Hssv do
  permit_params :ma_sv, :ho_dem, :ten, :ngay_sinh, :gioi_tinh,
                :ma_lop, :ma_khoa, :ma_hdt, :ma_nganh,
                :dien_thoai, :que_quan, :tru_quan, :ghi_chu

  index do
    selectable_column
    id_column :ma_sv
    column :ho_dem
    column :ten
    column :lop do |s|
      s.lop&.ten
    end
    column :khoa_hoc do |s|
      s.khoa_hoc&.ten
    end
    column :he_dao_tao do |s|
      s.he_dao_tao&.ten
    end
    column :ngan_h do |s|
      s.nganh&.ten_nganh
    end
    actions
  end

  filter :ma_sv
  filter :ten
  filter :lop, collection: -> { Lop.all }

  form do |f|
    f.inputs "Thông tin cơ bản" do
      f.input :ma_sv
      f.input :ho_dem
      f.input :ten
      f.input :ngay_sinh, as: :datepicker
      f.input :gioi_tinh, as: :select, collection: [ [ "Nam", true ], [ "Nữ", false ] ]

      f.input :lop, as: :select, collection: Lop.all.collect { |l| [ l.ten, l.ma_lop ] }
      f.input :khoa_hoc, as: :select, collection: KhoaHoc.all.collect { |k| [ k.ten, k.ma_khoa ] }
      f.input :he_dao_tao, as: :select, collection: HeDaoTao.all.collect { |h| [ h.ten, h.ma_he_dt ] }
      f.input :nganh, as: :select, collection: Nganh.all.collect { |n| [ n.ten_nganh, n.ma_nganh ] }

      f.input :dien_thoai
      f.input :que_quan
      f.input :tru_quan
      f.input :ghi_chu
    end
    f.actions
  end

  action_item :import, only: :index do
    link_to "Import từ Excel", action: :import
  end

  collection_action :import, method: :get do
    render "admin/hssv/import"
  end

  collection_action :do_import, method: :post do
    if params[:file].present?
      HssvImporter.new(params[:file].path).call
      redirect_to admin_hssvs_path, notice: "Import thành công"
    else
      redirect_to import_admin_hssvs_path, alert: "Chưa chọn file"
    end
  end
end
