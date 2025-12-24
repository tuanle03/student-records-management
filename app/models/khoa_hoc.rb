class KhoaHoc < ApplicationRecord
  self.primary_key = "ma_khoa"

  has_many :lops,  foreign_key: :ma_khoa, primary_key: :ma_khoa
  has_many :hssvs, foreign_key: :ma_khoa, primary_key: :ma_khoa

  def self.ransackable_associations(auth_object = nil)
    [ "hssvs", "lops" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "ghi_chu", "ma_khoa", "ten", "updated_at" ]
  end

  def to_s
    ten
  end
end
