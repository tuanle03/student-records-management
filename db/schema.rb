# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_12_02_193118) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "diem_hoc_taps", force: :cascade do |t|
    t.string "ma_sv", null: false
    t.string "ma_mon_hoc", null: false
    t.string "ma_hoc_ky", null: false
    t.string "ghi_chu"
    t.decimal "diem_gp", precision: 8, scale: 2
    t.decimal "diem_hp", precision: 8, scale: 2
    t.decimal "diem_tb", precision: 8, scale: 2
    t.decimal "diem_thi_lai_lan1", precision: 8, scale: 2
    t.decimal "diem_thi_lai_lan2", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diem_ren_luyens", force: :cascade do |t|
    t.string "ma_sv"
    t.string "ma_hoc_ky"
    t.string "ma_nam_hoc"
    t.string "thang"
    t.decimal "diem"
    t.string "ghi_chu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "he_dao_taos", primary_key: "ma_he_dt", id: :string, force: :cascade do |t|
    t.string "ten"
    t.integer "thoi_gian_hoc"
    t.string "don_vi_tg"
    t.string "ghi_chu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hssvs", primary_key: "ma_sv", id: :string, force: :cascade do |t|
    t.string "ho_dem"
    t.string "ten"
    t.datetime "ngay_sinh"
    t.boolean "gioi_tinh"
    t.string "anh"
    t.string "ma_huyen"
    t.string "dien_thoai"
    t.string "dan_toc"
    t.string "ton_giao"
    t.string "khu_vuc"
    t.string "doi_tuong"
    t.datetime "ngay_doan"
    t.datetime "ngay_dang"
    t.string "so_cmnd"
    t.datetime "ngay_cmnd"
    t.string "noi_cmnd"
    t.string "que_quan"
    t.string "tru_quan"
    t.string "ktk_l"
    t.text "tom_tat_qtct"
    t.string "ho_ten_cha"
    t.datetime "nam_sinh_cha"
    t.string "nghe_nghiep_cha"
    t.string "noi_lam_cha"
    t.string "ho_khau_cha"
    t.string "ho_ten_me"
    t.datetime "nam_sinh_me"
    t.string "nghe_nghiep_me"
    t.string "noi_lam_me"
    t.string "ho_khau_me"
    t.string "ho_ten_vo"
    t.datetime "nam_sinh_vo"
    t.string "nghe_nghiep_vo"
    t.string "noi_lam_vo"
    t.string "ho_khau_vo"
    t.string "anh_chiem"
    t.string "ma_lop"
    t.string "ma_khoa"
    t.string "ma_hdt"
    t.string "ma_nganh"
    t.string "ghi_chu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "khoa_hocs", primary_key: "ma_khoa", id: :string, force: :cascade do |t|
    t.string "ten"
    t.string "ghi_chu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lops", primary_key: "ma_lop", id: :string, force: :cascade do |t|
    t.string "ten"
    t.string "ma_khoa"
    t.string "khoa_hoc"
    t.string "ma_nganh"
    t.string "ma_he_dt"
    t.string "ma_cb"
    t.string "ghi_chu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "giao_vien_id"
    t.index ["giao_vien_id"], name: "index_lops_on_giao_vien_id"
  end

  create_table "mon_hocs", primary_key: "ma_mon_hoc", id: :string, force: :cascade do |t|
    t.string "ten"
    t.integer "so_tin_chi"
    t.string "ghi_chu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nganhs", primary_key: "ma_nganh", id: :string, force: :cascade do |t|
    t.string "ten_nganh"
    t.string "ghi_chu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phan_loai_tap_thes", force: :cascade do |t|
    t.string "ma_lop"
    t.string "danh_hieu_de_nghi"
    t.string "phan_loai_tap_the"
    t.string "ma_nam_hoc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "diem_hoc_taps", "hssvs", column: "ma_sv", primary_key: "ma_sv"
  add_foreign_key "diem_hoc_taps", "mon_hocs", column: "ma_mon_hoc", primary_key: "ma_mon_hoc"
  add_foreign_key "hssvs", "he_dao_taos", column: "ma_hdt", primary_key: "ma_he_dt"
  add_foreign_key "hssvs", "khoa_hocs", column: "ma_khoa", primary_key: "ma_khoa"
  add_foreign_key "hssvs", "lops", column: "ma_lop", primary_key: "ma_lop"
  add_foreign_key "hssvs", "nganhs", column: "ma_nganh", primary_key: "ma_nganh"
  add_foreign_key "lops", "he_dao_taos", column: "ma_he_dt", primary_key: "ma_he_dt"
  add_foreign_key "lops", "khoa_hocs", column: "ma_khoa", primary_key: "ma_khoa"
  add_foreign_key "lops", "nganhs", column: "ma_nganh", primary_key: "ma_nganh"
  add_foreign_key "lops", "users", column: "giao_vien_id"
end
