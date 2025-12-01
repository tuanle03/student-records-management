class CreateLops < ActiveRecord::Migration[8.0]
  def change
    create_table :lops, id: false do |t|
      t.string :ma_lop, primary_key: true
      t.string :ten
      t.string :ma_khoa
      t.string :khoa_hoc
      t.string :ma_nganh
      t.string :ma_he_dt
      t.string :ma_cb
      t.string :ghi_chu

      t.timestamps
    end

    add_foreign_key :lops, :khoa_hocs, column: :ma_khoa, primary_key: :ma_khoa
    add_foreign_key :lops, :nganhs, column: :ma_nganh, primary_key: :ma_nganh
    add_foreign_key :lops, :he_dao_taos, column: :ma_he_dt, primary_key: :ma_he_dt
  end
end
