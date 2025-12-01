class CreateKhoaHocs < ActiveRecord::Migration[8.0]
  def change
    create_table :khoa_hocs, id: false do |t|
      t.string :ma_khoa, primary_key: true
      t.string :ten
      t.string :ghi_chu

      t.timestamps
    end
  end
end
