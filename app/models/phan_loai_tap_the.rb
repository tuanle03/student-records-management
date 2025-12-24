class PhanLoaiTapThe < ApplicationRecord
  belongs_to :lop, foreign_key: :ma_lop, primary_key: :ma_lop, optional: true

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "danh_hieu_de_nghi", "id", "id_value", "ma_lop", "ma_nam_hoc", "phan_loai_tap_the", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "lop" ]
  end
end
