class AddGiaoVienToLops < ActiveRecord::Migration[8.0]
  def change
    add_reference :lops, :giao_vien, null: true, foreign_key: { to_table: :users }
  end
end
