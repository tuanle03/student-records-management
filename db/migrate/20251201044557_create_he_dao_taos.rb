class CreateHeDaoTaos < ActiveRecord::Migration[8.0]
  def change
    create_table :he_dao_taos, id: false do |t|
      t.string :ma_he_dt, primary_key: true
      t.string :ten
      t.integer :thoi_gian_hoc
      t.string :don_vi_tg
      t.string :ghi_chu

      t.timestamps
    end
  end
end
