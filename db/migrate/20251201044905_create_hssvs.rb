class CreateHssvs < ActiveRecord::Migration[8.0]
  def change
    create_table :hssvs, id: false do |t|
      t.string :ma_sv, primary_key: true
      t.string :ho_dem
      t.string :ten
      t.datetime :ngay_sinh
      t.boolean :gioi_tinh
      t.string :anh

      t.string :ma_huyen
      t.string :dien_thoai
      t.string :dan_toc
      t.string :ton_giao
      t.string :khu_vuc
      t.string :doi_tuong

      t.datetime :ngay_doan
      t.datetime :ngay_dang
      t.string :so_cmnd
      t.datetime :ngay_cmnd
      t.string :noi_cmnd

      t.string :que_quan
      t.string :tru_quan
      t.string :ktk_l
      t.text   :tom_tat_qtct

      t.string :ho_ten_cha
      t.datetime :nam_sinh_cha
      t.string :nghe_nghiep_cha
      t.string :noi_lam_cha
      t.string :ho_khau_cha

      t.string :ho_ten_me
      t.datetime :nam_sinh_me
      t.string :nghe_nghiep_me
      t.string :noi_lam_me
      t.string :ho_khau_me

      t.string :ho_ten_vo
      t.datetime :nam_sinh_vo
      t.string :nghe_nghiep_vo
      t.string :noi_lam_vo
      t.string :ho_khau_vo

      t.string :anh_chiem

      t.string :ma_lop
      t.string :ma_khoa
      t.string :ma_hdt
      t.string :ma_nganh

      t.string :ghi_chu

      t.timestamps
    end

    add_foreign_key :hssvs, :lops, column: :ma_lop, primary_key: :ma_lop
    add_foreign_key :hssvs, :khoa_hocs, column: :ma_khoa, primary_key: :ma_khoa
    add_foreign_key :hssvs, :he_dao_taos, column: :ma_hdt, primary_key: :ma_he_dt
    add_foreign_key :hssvs, :nganhs, column: :ma_nganh, primary_key: :ma_nganh
  end
end
