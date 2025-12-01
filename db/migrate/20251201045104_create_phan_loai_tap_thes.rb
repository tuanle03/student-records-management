class CreatePhanLoaiTapThes < ActiveRecord::Migration[8.0]
  def change
    create_table :phan_loai_tap_thes do |t|
      t.string :ma_lop
      t.string :danh_hieu_de_nghi
      t.string :phan_loai_tap_the
      t.string :ma_nam_hoc

      t.timestamps
    end
  end
end
