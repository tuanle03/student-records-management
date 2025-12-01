class CreateMonHocs < ActiveRecord::Migration[8.0]
  def change
    create_table :mon_hocs, id: false do |t|
      t.string :ma_mon_hoc, primary_key: true
      t.string :ten
      t.integer :so_tin_chi
      t.string :ghi_chu

      t.timestamps
    end
  end
end
