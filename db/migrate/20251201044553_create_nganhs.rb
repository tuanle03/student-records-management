class CreateNganhs < ActiveRecord::Migration[8.0]
  def change
    create_table :nganhs, id: false do |t|
      t.string :ma_nganh, primary_key: true
      t.string :ten_nganh
      t.string :ghi_chu

      t.timestamps
    end
  end
end
