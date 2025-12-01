class CreateDiemHocTaps < ActiveRecord::Migration[8.0]
  def change
    create_table :diem_hoc_taps do |t|
      t.string :ma_sv, null: false
      t.string :ma_mon_hoc, null: false
      t.string :ma_hoc_ky, null: false
      t.string :ghi_chu

      t.decimal :diem_gp,           precision: 8, scale: 2
      t.decimal :diem_hp,           precision: 8, scale: 2
      t.decimal :diem_tb,           precision: 8, scale: 2
      t.decimal :diem_thi_lai_lan1, precision: 8, scale: 2
      t.decimal :diem_thi_lai_lan2, precision: 8, scale: 2

      t.timestamps
    end

    add_foreign_key :diem_hoc_taps, :hssvs,    column: :ma_sv,       primary_key: :ma_sv
    add_foreign_key :diem_hoc_taps, :mon_hocs, column: :ma_mon_hoc, primary_key: :ma_mon_hoc
  end
end
