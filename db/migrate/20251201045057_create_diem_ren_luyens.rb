class CreateDiemRenLuyens < ActiveRecord::Migration[8.0]
  def change
    create_table :diem_ren_luyens do |t|
      t.string :ma_sv
      t.string :ma_hoc_ky
      t.string :ma_nam_hoc
      t.string :thang
      t.decimal :diem
      t.string :ghi_chu

      t.timestamps
    end
  end
end
